import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/resolved_location.dart';
import '../../../prayer_times/domain/calculation_prefs.dart';

enum PrayerTimesStatus { initial, loading, loaded, error }

class PrayerTimesState extends Equatable {
  final PrayerTimesStatus status;
  final DateTime? nextPrayerTime;
  final String? nextPrayerName;
  final Map<String, DateTime>? times;
  final String? locationName;
  final CalculationPrefs prefs;
  final bool useDeviceLocation;
  final PreferredLocationSource locationSource;
  final DateTime? locationTimestamp;
  final bool staleLocation;
  final bool timezoneWarning;
  final String? error;
  final double? latitude;
  final double? longitude;

  const PrayerTimesState({
    this.status = PrayerTimesStatus.initial,
    this.nextPrayerTime,
    this.nextPrayerName,
    this.times,
    this.locationName,
    this.prefs = const CalculationPrefs(),
    this.useDeviceLocation = true,
    this.locationSource = PreferredLocationSource.device,
    this.locationTimestamp,
    this.staleLocation = false,
    this.timezoneWarning = false,
    this.error,
    this.latitude,
    this.longitude,
  });

  PrayerTimesState copyWith({
    PrayerTimesStatus? status,
    DateTime? nextPrayerTime,
    String? nextPrayerName,
    Map<String, DateTime>? times,
    String? locationName,
    CalculationPrefs? prefs,
    bool? useDeviceLocation,
    PreferredLocationSource? locationSource,
    DateTime? locationTimestamp,
    bool clearLocationTimestamp = false,
    bool? staleLocation,
    bool? timezoneWarning,
    String? error,
    double? latitude,
    double? longitude,
  }) => PrayerTimesState(
    status: status ?? this.status,
    nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
    nextPrayerName: nextPrayerName ?? this.nextPrayerName,
    times: times ?? this.times,
    locationName: locationName ?? this.locationName,
    prefs: prefs ?? this.prefs,
    useDeviceLocation: useDeviceLocation ?? this.useDeviceLocation,
    locationSource: locationSource ?? this.locationSource,
    locationTimestamp: clearLocationTimestamp
        ? null
        : locationTimestamp ?? this.locationTimestamp,
    staleLocation: staleLocation ?? this.staleLocation,
    timezoneWarning: timezoneWarning ?? this.timezoneWarning,
    error: error ?? this.error,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );

  @override
  List<Object?> get props => [
    status,
    nextPrayerTime,
    nextPrayerName,
    times,
    locationName,
    prefs,
    useDeviceLocation,
    locationSource,
    locationTimestamp,
    staleLocation,
    timezoneWarning,
    error,
    latitude,
    longitude,
  ];
}

class DailyPrayerTimes {
  DailyPrayerTimes({required this.date, required this.times});

  final DateTime date;
  final Map<String, DateTime> times;
}
