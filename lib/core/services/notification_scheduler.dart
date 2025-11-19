import 'dart:developer' as dev;

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../telemetry/telemetry_service.dart';
import 'notification_details_builder.dart';
import 'notification_prefs.dart';
import 'notification_service.dart';
import 'notification_timezone.dart';

class NotificationScheduler {
  NotificationScheduler(this._service, {TelemetryService? telemetryService})
    : _telemetry = telemetryService;

  final NotificationService _service;
  final TelemetryService? _telemetry;
  static const int _snoozeNotificationId = 9000;

  NotificationService get service => _service;

  static Future<void> ensureTZ() => NotificationTimezone.ensureInitialized();

  Future<void> cancelAll() async {
    await _service.cancelAllNotifications();
    // Also cancel any scheduled alarm sounds
    await _cancelAllAlarmSounds();
    _telemetry?.logEvent('notifications_cancel_all', const {});
  }

  Future<void> _scheduleAlarmSound(
    String prayerName,
    tz.TZDateTime when,
    String voiceId,
    int notificationId,
  ) async {
    try {
      final platform = const MethodChannel('azkar/alarm');
      await platform.invokeMethod('scheduleAlarmSound', {
        'time': when.millisecondsSinceEpoch,
        'prayer_name': prayerName,
        'voice_id': voiceId,
        'notification_id': notificationId,
      });
      dev.log(
        'Scheduled alarm sound for $prayerName at $when with voice $voiceId',
        name: 'notifications',
      );
      _telemetry?.logEvent('notification_sound_scheduled', {
        'prayer': prayerName,
        'voice': voiceId,
        'time': when.toIso8601String(),
      });
    } catch (e) {
      dev.log(
        'Failed to schedule alarm sound: $e',
        name: 'notifications',
        level: 900,
      );
      _telemetry?.logError(
        e,
        StackTrace.current,
        context: 'notification_sound',
      );
    }
  }

  Future<void> _cancelAllAlarmSounds() async {
    try {
      final platform = const MethodChannel('azkar/alarm');
      await platform.invokeMethod('cancelAllAlarms');
      dev.log('Cancelled all alarm sounds', name: 'notifications');
    } catch (e) {
      dev.log(
        'Failed to cancel alarm sounds: $e',
        name: 'notifications',
        level: 900,
      );
    }
  }

  Future<void> scheduleForTimes({
    required Map<String, DateTime> times,
    required NotificationPrefs prefs,
  }) async {
    if (!prefs.enabled) {
      await cancelAll();
      _telemetry?.logEvent('notifications_skip_disabled', const {});
      return;
    }
    await ensureTZ();
    await cancelAll();

    final builder = NotificationDetailsBuilder(_service, prefs);
    await builder.ensureChannel();

    final now = DateTime.now();
    int id = 100; // base id for today's set

    bool isQuiet(DateTime when) {
      if (prefs.quietStart == null || prefs.quietEnd == null) return false;
      final m = when.hour * 60 + when.minute;
      final qs = prefs.quietStart!;
      final qe = prefs.quietEnd!;
      if (qs == qe) return false; // disabled
      if (qs < qe) {
        return m >= qs && m < qe;
      } else {
        // crosses midnight
        return m >= qs || m < qe;
      }
    }

    Future<void> scheduleOne(String key, DateTime time) async {
      final enabled = prefs.perPrayerEnabled()[key] ?? false;
      if (!enabled) return;
      final leadMinutes = prefs.leadFor(key);
      final when = time.subtract(Duration(minutes: leadMinutes));
      if (when.isBefore(now)) return;
      if (isQuiet(when)) return;
      final tzTime = tz.TZDateTime.from(when, tz.local);
      final details = builder.forPrayer(
        key,
        time.toLocal(),
        leadMinutesOverride: leadMinutes,
      );

      // Create payload with voice ID for sound playback
      final payloadData = '{"prayer":"$key","voice":"${prefs.azanVoice}"}';

      try {
        await _service.scheduleNotification(
          id: id++,
          title: '$key Prayer',
          body: reminderBody(key, leadMinutes),
          dateTime: tzTime,
          details: details,
          payload: payloadData,
        );
        _telemetry?.logEvent('notification_scheduled', {
          'prayer': key,
          'time': time.toIso8601String(),
          'lead': leadMinutes,
        });

        // Also schedule alarm receiver for reliable sound playback
        if (prefs.azanVoice != 'default') {
          await _scheduleAlarmSound(key, tzTime, prefs.azanVoice, id - 1);
        }
      } catch (e, stack) {
        dev.log(
          'Failed to schedule notification for $key: $e',
          name: 'notifications',
          level: 1000,
        );
        _telemetry?.logError(e, stack, context: 'notification_schedule');
      }
    }

    // Today’s schedule
    for (final entry in times.entries) {
      if (entry.key == 'Sunrise') continue;
      await scheduleOne(entry.key, entry.value);
    }
  }

  Future<void> scheduleImmediateDemo(NotificationPrefs prefs) async {
    if (!prefs.enabled) return;
    await ensureTZ();
    final builder = NotificationDetailsBuilder(_service, prefs);
    await builder.ensureChannel();

    tz.TZDateTime targetTime() =>
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));

    Future<void> schedule(AndroidScheduleMode mode) async {
      final target = targetTime();
      dev.log(
        'Scheduling demo notification id=999 at $target (mode=$mode)',
        name: 'notifications',
      );

      // Create notification details with explicit settings
      final details = builder.forPrayer(
        'Demo',
        target.toLocal(),
        leadMinutesOverride: 0,
      );

      try {
        await _service.scheduleNotification(
          id: 999,
          title: 'Demo Prayer',
          body: 'This is how your adhan alert will sound.',
          dateTime: target,
          details: details,
          payload: 'Demo',
          androidScheduleMode: mode,
        );
        dev.log('Notification scheduled successfully', name: 'notifications');
        _telemetry?.logEvent('notification_demo_scheduled', {
          'mode': mode.name,
          'voice': prefs.azanVoice,
        });
      } catch (e) {
        dev.log(
          'Failed to schedule notification: $e',
          name: 'notifications',
          level: 1000,
        );
        _telemetry?.logError(
          e,
          StackTrace.current,
          context: 'notification_demo',
        );
      }

      // Also schedule alarm sound for reliable playback
      if (prefs.azanVoice != 'default') {
        try {
          await _scheduleAlarmSound('Demo', target, prefs.azanVoice, 999);
          dev.log('Alarm sound scheduled successfully', name: 'notifications');
        } catch (e) {
          dev.log(
            'Failed to schedule alarm sound: $e',
            name: 'notifications',
            level: 1000,
          );
          _telemetry?.logError(
            e,
            StackTrace.current,
            context: 'notification_demo_sound',
          );
        }
      }

      dev.log(
        'Demo scheduling complete (notification + alarm)',
        name: 'notifications',
      );
    }

    try {
      await schedule(AndroidScheduleMode.exactAllowWhileIdle);
      return;
    } on PlatformException catch (e) {
      dev.log(
        'Exact alarm rejected: ${e.message}. Requesting permission...',
        name: 'notifications',
        level: 900,
      );
      final granted = await _service.requestExactAlarmPermission();
      if (granted) {
        try {
          await schedule(AndroidScheduleMode.exactAllowWhileIdle);
          return;
        } on PlatformException catch (e2) {
          dev.log(
            'Exact alarm still rejected after permission: ${e2.message}',
            name: 'notifications',
            level: 1000,
          );
          _telemetry?.logError(
            e2,
            StackTrace.current,
            context: 'notification_demo_permission',
          );
        }
      }
      try {
        await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
        return;
      } catch (fallbackError) {
        dev.log(
          'Inexact schedule failed: $fallbackError',
          name: 'notifications',
          level: 1000,
        );
        _telemetry?.logError(
          fallbackError,
          StackTrace.current,
          context: 'notification_demo_inexact',
        );
      }
    } catch (e) {
      dev.log(
        'Unexpected error scheduling demo: $e',
        name: 'notifications',
        level: 1000,
      );
      _telemetry?.logError(e, StackTrace.current, context: 'notification_demo');
    }

    dev.log('Falling back to instant notification demo', name: 'notifications');
    await _service.showInstant(
      id: 1000,
      title: 'Demo Prayer',
      body: 'This is how your adhan alert will sound.',
    );
    _telemetry?.logEvent('notification_demo_instant', const {});
  }

  Future<NotificationDetails> buildNotificationDetails(
    NotificationPrefs prefs,
  ) async {
    final builder = NotificationDetailsBuilder(_service, prefs);
    await builder.ensureChannel();
    return builder.generic();
  }

  Future<void> scheduleSnooze({
    required String prayer,
    required DateTime nextPrayerTime,
    required NotificationPrefs prefs,
  }) async {
    if (!prefs.enabled || !prefs.snoozeEnabled) return;
    await ensureTZ();
    final builder = NotificationDetailsBuilder(_service, prefs);
    await builder.ensureChannel();

    final now = DateTime.now();
    var target = now.add(Duration(minutes: prefs.snoozeMinutes));
    final guard = nextPrayerTime.subtract(const Duration(seconds: 30));
    if (target.isAfter(guard)) {
      target = guard;
    }
    if (!target.isAfter(now)) {
      target = now.add(const Duration(seconds: 30));
    }
    final tzTime = tz.TZDateTime.from(target, tz.local);

    try {
      await _service.cancelNotification(_snoozeNotificationId);
      final details = builder.forPrayer(
        prayer,
        nextPrayerTime.toLocal(),
        leadMinutesOverride: 0,
      );
      await _service.scheduleNotification(
        id: _snoozeNotificationId,
        title: '$prayer Prayer',
        body: 'Snoozed reminder',
        dateTime: tzTime,
        details: details,
        payload: '{"prayer":"$prayer","voice":"${prefs.azanVoice}"}',
      );
      _telemetry?.logEvent('notification_snooze_scheduled', {
        'prayer': prayer,
        'minutes': prefs.snoozeMinutes,
      });
      if (prefs.azanVoice != 'default') {
        await _scheduleAlarmSound(
          prayer,
          tzTime,
          prefs.azanVoice,
          _snoozeNotificationId,
        );
      }
    } catch (e, stack) {
      dev.log(
        'Failed to schedule snooze: $e',
        name: 'notifications',
        level: 1000,
      );
      _telemetry?.logError(e, stack, context: 'notification_snooze');
    }
  }
}
