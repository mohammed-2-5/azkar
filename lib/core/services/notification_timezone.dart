import 'dart:developer' as dev;

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Handles resolution and initialization of the timezone database for alarms.
class NotificationTimezone {
  const NotificationTimezone._();

  static Future<void> ensureInitialized() async {
    try {
      tz.initializeTimeZones();
      final tzName = await _resolveTimezoneName();
      tz.setLocalLocation(tz.getLocation(tzName));
      dev.log('Initialized timezone: $tzName', name: 'notifications');
    } catch (e) {
      dev.log(
        'Failed to initialize timezone: $e. Falling back to UTC.',
        name: 'notifications',
        level: 900,
      );
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  static Future<String> _resolveTimezoneName() async {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    final tzName = now.timeZoneName;
    if (tz.timeZoneDatabase.locations.containsKey(tzName)) {
      dev.log('Using timezone from system: $tzName', name: 'notifications');
      return tzName;
    }

    final offsetHours = offset.inHours;
    final Map<int, List<String>> offsetToTimezone = {
      -12: ['Etc/GMT+12'],
      -11: ['Pacific/Midway', 'Pacific/Niue', 'Pacific/Pago_Pago'],
      -10: ['Pacific/Honolulu', 'Pacific/Tahiti'],
      -9: ['America/Anchorage', 'America/Juneau'],
      -8: ['America/Los_Angeles', 'America/Vancouver'],
      -7: ['America/Denver', 'America/Phoenix'],
      -6: ['America/Chicago', 'America/Mexico_City'],
      -5: ['America/New_York', 'America/Toronto'],
      -4: ['America/Halifax', 'America/Caracas'],
      -3: ['America/Sao_Paulo', 'America/Argentina/Buenos_Aires'],
      -2: ['America/Noronha', 'Atlantic/South_Georgia'],
      -1: ['Atlantic/Azores', 'Atlantic/Cape_Verde'],
      0: ['UTC', 'Europe/London', 'Africa/Casablanca'],
      1: ['Europe/Paris', 'Europe/Berlin', 'Africa/Lagos'],
      2: ['Europe/Athens', 'Africa/Cairo', 'Asia/Jerusalem'],
      3: ['Europe/Moscow', 'Asia/Riyadh', 'Africa/Nairobi'],
      4: ['Asia/Dubai', 'Asia/Baku'],
      5: ['Asia/Karachi', 'Asia/Tashkent'],
      6: ['Asia/Dhaka', 'Asia/Almaty'],
      7: ['Asia/Bangkok', 'Asia/Jakarta'],
      8: ['Asia/Singapore', 'Asia/Shanghai', 'Asia/Hong_Kong'],
      9: ['Asia/Tokyo', 'Asia/Seoul'],
      10: ['Australia/Sydney', 'Australia/Melbourne'],
      11: ['Pacific/Noumea', 'Asia/Magadan'],
      12: ['Pacific/Fiji', 'Pacific/Auckland'],
    };

    if (offsetToTimezone.containsKey(offsetHours)) {
      final candidates = offsetToTimezone[offsetHours]!;
      for (final candidate in candidates) {
        if (tz.timeZoneDatabase.locations.containsKey(candidate)) {
          dev.log(
            'Using timezone from offset ($offsetHours): $candidate',
            name: 'notifications',
          );
          return candidate;
        }
      }
    }

    for (final location in tz.timeZoneDatabase.locations.values) {
      final testTime = tz.TZDateTime.now(location);
      if (testTime.timeZoneOffset == offset) {
        dev.log(
          'Using matched timezone by offset: ${location.name}',
          name: 'notifications',
        );
        return location.name;
      }
    }

    dev.log(
      'Could not determine timezone, falling back to UTC',
      name: 'notifications',
      level: 900,
    );
    return 'UTC';
  }
}
