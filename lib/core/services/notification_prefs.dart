class NotificationPrefs {
  static const _sentinel = Object();

  final bool enabled;
  final int leadMinutes; // minutes before prayer (default)
  final Map<String, int> leadOverrides;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;
  final int? quietStart; // minutes from midnight (0..1439)
  final int? quietEnd; // minutes from midnight (0..1439)
  final bool snoozeEnabled;
  final int snoozeMinutes;
  final String azanVoice;

  const NotificationPrefs({
    this.enabled = true,
    this.leadMinutes = 10,
    this.leadOverrides = const {},
    this.fajr = true,
    this.dhuhr = true,
    this.asr = true,
    this.maghrib = true,
    this.isha = true,
    this.quietStart,
    this.quietEnd,
    this.snoozeEnabled = true,
    this.snoozeMinutes = 5,
    this.azanVoice = 'default',
  });

  NotificationPrefs copyWith({
    bool? enabled,
    int? leadMinutes,
    Map<String, int>? leadOverrides,
    bool? fajr,
    bool? dhuhr,
    bool? asr,
    bool? maghrib,
    bool? isha,
    Object? quietStart = _sentinel,
    Object? quietEnd = _sentinel,
    bool? snoozeEnabled,
    int? snoozeMinutes,
    String? azanVoice,
  }) {
    return NotificationPrefs(
      enabled: enabled ?? this.enabled,
      leadMinutes: leadMinutes ?? this.leadMinutes,
      leadOverrides: leadOverrides ?? this.leadOverrides,
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      quietStart: identical(quietStart, _sentinel)
          ? this.quietStart
          : quietStart as int?,
      quietEnd: identical(quietEnd, _sentinel)
          ? this.quietEnd
          : quietEnd as int?,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      azanVoice: azanVoice ?? this.azanVoice,
    );
  }

  NotificationPrefs setLeadOverride(String prayer, int? minutes) {
    final overrides = Map<String, int>.from(leadOverrides);
    if (minutes == null) {
      overrides.remove(prayer);
    } else {
      overrides[prayer] = minutes;
    }
    return copyWith(leadOverrides: overrides);
  }

  int leadFor(String prayer) => leadOverrides[prayer] ?? leadMinutes;

  Map<String, bool> perPrayerEnabled() => {
    'Fajr': fajr,
    'Dhuhr': dhuhr,
    'Asr': asr,
    'Maghrib': maghrib,
    'Isha': isha,
  };
}
