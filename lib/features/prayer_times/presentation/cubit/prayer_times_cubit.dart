import 'dart:async';
import 'dart:developer' as dev;
import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/domain/entities/resolved_location.dart';
import '../../../../core/domain/usecases/get_preferred_location.dart';
import '../../../../core/services/notification_prefs.dart';
import '../../../../core/services/notification_scheduler.dart';
import '../../data/prayer_calculator.dart';
import '../../domain/calculation_prefs.dart';
import 'prayer_times_state.dart';

const List<String> _prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit(this._getPreferredLocation, this._scheduler)
    : super(const PrayerTimesState());

  final GetPreferredLocation _getPreferredLocation;
  final PrayerCalculator _calc = PrayerCalculator();
  Timer? _tick;
  Timer? _midnightTimer;
  final NotificationScheduler _scheduler;

  // Expose scheduler for testing and debug access
  NotificationScheduler get scheduler => _scheduler;

  Future<void> fetchToday() async {
    emit(state.copyWith(status: PrayerTimesStatus.loading));
    try {
      final resolved = await _getPreferredLocation();
      if (resolved == null) {
        throw Exception('Set your city to compute prayer times.');
      }
      final coords = adhan.Coordinates(
        resolved.coordinate.latitude,
        resolved.coordinate.longitude,
      );
      String? label = resolved.label;
      final bool usingDevice = resolved.usesDeviceLocation;
      final prefs = await _loadPrefs();
      final timesObj = _calc.compute(
        lat: coords.latitude,
        lng: coords.longitude,
        date: DateTime.now(),
        prefs: prefs,
      );

      final now = DateTime.now();
      final ordered = _buildTimesMap(timesObj);
      String? nextName;
      DateTime? nextTime;
      for (final entry in ordered.entries) {
        final t = entry.value;
        if (t != null && t.isAfter(now)) {
          nextName = entry.key;
          nextTime = t;
          break;
        }
      }
      if (nextName == null || nextTime == null) {
        final t2 = _calc.compute(
          lat: coords.latitude,
          lng: coords.longitude,
          date: now.add(const Duration(days: 1)),
          prefs: prefs,
        );
        nextName = 'Fajr';
        nextTime = t2.fajr;
      }

      final times = <String, DateTime>{
        for (final e in ordered.entries)
          if (e.value != null) e.key: e.value!,
      };

      final String? locName = label;
      String? resolvedName = locName;
      if (resolvedName == null || resolvedName.isEmpty) {
        try {
          final placemarks = await geocoding.placemarkFromCoordinates(
            coords.latitude,
            coords.longitude,
          );
          final place = placemarks.isNotEmpty ? placemarks.first : null;
          resolvedName = [
            place?.locality,
            place?.country,
          ].where((e) => (e ?? '').isNotEmpty).join(', ');
        } catch (_) {}
      }
      if (resolved.source == PreferredLocationSource.device) {
        await _persistLastLocation(
          lat: coords.latitude,
          lng: coords.longitude,
          label: resolvedName ?? label,
        );
      }

      _startTicker();
      _scheduleMidnightRefresh();
      // Schedule notifications if enabled
      final np = await _loadNotificationPrefs();
      try {
        await _scheduler.scheduleForTimes(times: times, prefs: np);
        dev.log('Successfully scheduled notifications for ${times.length} prayers', name: 'prayer_times');
      } catch (e) {
        // Log scheduling failures but don't break the UI
        dev.log(
          'Failed to schedule notifications: $e',
          name: 'prayer_times',
          level: 1000,
        );
      }
      final tzWarning = _hasTimezoneWarning(
        coords.longitude,
        resolved.source,
      );
      final staleLocation =
          resolved.source == PreferredLocationSource.cached;

      emit(
        state.copyWith(
          status: PrayerTimesStatus.loaded,
          nextPrayerName: nextName,
          nextPrayerTime: nextTime,
          times: times,
          locationName: (resolvedName != null && resolvedName.isNotEmpty)
              ? resolvedName
              : null,
          prefs: prefs,
          useDeviceLocation: usingDevice,
          latitude: coords.latitude,
          longitude: coords.longitude,
          locationSource: resolved.source,
          locationTimestamp: resolved.timestamp,
          clearLocationTimestamp: resolved.timestamp == null,
          staleLocation: staleLocation,
          timezoneWarning: tzWarning,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PrayerTimesStatus.error, error: e.toString()),
      );
    }
  }

  void refresh() => fetchToday();

  Future<void> updatePrefs(CalculationPrefs prefs) async {
    await _savePrefs(prefs);
    emit(state.copyWith(prefs: prefs));
    await fetchToday();
  }

  Future<NotificationPrefs> _loadNotificationPrefs() async {
    final sp = await SharedPreferences.getInstance();
    final overrides = <String, int>{};
    for (final prayer in _prayerNames) {
      final value = sp.getInt('notif_lead_${prayer.toLowerCase()}');
      if (value != null) {
        overrides[prayer] = value;
      }
    }
    return NotificationPrefs(
      enabled: sp.getBool('notif_enabled') ?? true,
      leadMinutes: sp.getInt('notif_lead') ?? 10,
      leadOverrides: overrides,
      fajr: sp.getBool('notif_fajr') ?? true,
      dhuhr: sp.getBool('notif_dhuhr') ?? true,
      asr: sp.getBool('notif_asr') ?? true,
      maghrib: sp.getBool('notif_maghrib') ?? true,
      isha: sp.getBool('notif_isha') ?? true,
      quietStart: sp.getInt('notif_qstart'),
      quietEnd: sp.getInt('notif_qend'),
      snoozeEnabled: sp.getBool('notif_snooze_enabled') ?? true,
      snoozeMinutes: sp.getInt('notif_snooze_minutes') ?? 5,
      azanVoice: sp.getString('notif_azan_voice') ?? 'default',
    );
  }

  Future<void> saveNotificationPrefs(NotificationPrefs p) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('notif_enabled', p.enabled);
    await sp.setInt('notif_lead', p.leadMinutes);
    await sp.setBool('notif_fajr', p.fajr);
    await sp.setBool('notif_dhuhr', p.dhuhr);
    await sp.setBool('notif_asr', p.asr);
    await sp.setBool('notif_maghrib', p.maghrib);
    await sp.setBool('notif_isha', p.isha);
    await sp.setString('notif_azan_voice', p.azanVoice);
    for (final prayer in _prayerNames) {
      final key = 'notif_lead_${prayer.toLowerCase()}';
      final override = p.leadOverrides[prayer];
      if (override != null) {
        await sp.setInt(key, override);
      } else {
        await sp.remove(key);
      }
    }
    if (p.quietStart != null) {
      await sp.setInt('notif_qstart', p.quietStart!);
    } else {
      await sp.remove('notif_qstart');
    }
    if (p.quietEnd != null) {
      await sp.setInt('notif_qend', p.quietEnd!);
    } else {
      await sp.remove('notif_qend');
    }
    await sp.setBool('notif_snooze_enabled', p.snoozeEnabled);
    await sp.setInt('notif_snooze_minutes', p.snoozeMinutes);
    // Re-schedule with current times if available
    if (state.times != null) {
      await _scheduler.scheduleForTimes(times: state.times!, prefs: p);
    }
  }

  Future<int?> snoozeNextPrayer() async {
    final name = state.nextPrayerName;
    final time = state.nextPrayerTime;
    if (name == null || time == null) return null;
    try {
      final prefs = await _loadNotificationPrefs();
      if (!prefs.snoozeEnabled) return null;
      await _scheduler.scheduleSnooze(
        prayer: name,
        nextPrayerTime: time,
        prefs: prefs,
      );
      return prefs.snoozeMinutes;
    } catch (e) {
      dev.log('Failed to schedule snooze: $e', name: 'prayer_times', level: 1000);
      return null;
    }
  }

  Future<void> scheduleTestNotification(NotificationPrefs prefs) async {
    await _scheduler.scheduleImmediateDemo(prefs.copyWith(leadMinutes: 0));
  }

  Future<NotificationPrefs> currentNotificationPrefs() =>
      _loadNotificationPrefs();

  void _startTicker() {
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.nextPrayerTime != null &&
          state.nextPrayerTime!.isBefore(DateTime.now())) {
        fetchToday();
      }
    });
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1, minutes: 5));
    final delay = nextMidnight.difference(now);
    _midnightTimer = Timer(delay, fetchToday);
  }

  Future<CalculationPrefs> _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    return CalculationPrefs(
      method: CalcMethod.values[sp.getInt('calc_method') ?? 0],
      madhab: MadhabPref.values[sp.getInt('calc_madhab') ?? 0],
      highLatitude: HighLatitudePref.values[sp.getInt('calc_highlat') ?? 0],
      use24h: sp.getBool('calc_24h') ?? false,
    );
  }

  Future<void> _savePrefs(CalculationPrefs prefs) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('calc_method', prefs.method.index);
    await sp.setInt('calc_madhab', prefs.madhab.index);
    await sp.setInt('calc_highlat', prefs.highLatitude.index);
    await sp.setBool('calc_24h', prefs.use24h);
  }

  Future<void> setFixedLocation({
    required double lat,
    required double lng,
    required String label,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble('fixed_lat', lat);
    await sp.setDouble('fixed_lng', lng);
    await sp.setString('fixed_label', label);
    await sp.setInt('fixed_ts', DateTime.now().millisecondsSinceEpoch);
    await fetchToday();
  }

  Future<void> useDeviceLocation() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('fixed_lat');
    await sp.remove('fixed_lng');
    await sp.remove('fixed_label');
    await sp.remove('fixed_ts');
    await fetchToday();
  }

  @override
  Future<void> close() {
    _tick?.cancel();
    _midnightTimer?.cancel();
    return super.close();
  }

  List<DailyPrayerTimes> previewDays(
    int dayCount, {
    CalculationPrefs? overridePrefs,
  }) {
    if (state.latitude == null || state.longitude == null) return const [];
    final coords = adhan.Coordinates(state.latitude!, state.longitude!);
    final prefs = overridePrefs ?? state.prefs;
    final now = DateTime.now();
    final results = <DailyPrayerTimes>[];
    for (var i = 0; i < dayCount; i++) {
      final date = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      final times = _calc.compute(
        lat: coords.latitude,
        lng: coords.longitude,
        date: date,
        prefs: prefs,
      );
      results.add(
        DailyPrayerTimes(
          date: date,
          times: {
            for (final entry in _buildTimesMap(times).entries)
              if (entry.value != null) entry.key: entry.value!,
          },
        ),
      );
    }
    return results;
  }
}

Future<void> _persistLastLocation({
  required double lat,
  required double lng,
  String? label,
}) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setDouble('last_lat', lat);
  await sp.setDouble('last_lng', lng);
  await sp.setInt('last_ts', DateTime.now().millisecondsSinceEpoch);
  if (label != null && label.isNotEmpty) {
    await sp.setString('last_label', label);
  }
}

bool _hasTimezoneWarning(
  double longitude,
  PreferredLocationSource source,
) {
  if (source == PreferredLocationSource.device) return false;
  final approxOffsetMinutes = (longitude / 15).round() * 60;
  final deviceOffsetMinutes = DateTime.now().timeZoneOffset.inMinutes;
  return (approxOffsetMinutes - deviceOffsetMinutes).abs() >= 120;
}

Map<String, DateTime?> _buildTimesMap(adhan.PrayerTimes times) {
  return {
    'Fajr': times.fajr,
    'Sunrise': times.sunrise,
    'Dhuhr': times.dhuhr,
    'Asr': times.asr,
    'Maghrib': times.maghrib,
    'Isha': times.isha,
  };
}
