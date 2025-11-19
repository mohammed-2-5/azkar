import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../audio/azan_voice.dart';
import 'notification_prefs.dart';
import 'notification_service.dart';

class NotificationDetailsBuilder {
  NotificationDetailsBuilder(this._service, this._prefs);

  final NotificationService _service;
  final NotificationPrefs _prefs;

  late final AzanVoice _voice = AzanVoice.byId(_prefs.azanVoice);
  late final String _channelId = _voice.id == 'default'
      ? 'prayer_times_channel'
      : 'prayer_times_channel_${_voice.id}';
  late final String _channelName = _voice.id == 'default'
      ? 'Prayer Times'
      : 'Prayer Times (${_voice.label})';
  late final AndroidNotificationSound? _androidSound = _voice.id == 'default'
      ? null
      : RawResourceAndroidNotificationSound(_voice.id);
  final DateFormat _timeFormat = DateFormat('h:mm a');

  Future<void> ensureChannel() async {
    await _service.ensurePrayerChannel(
      channelId: _channelId,
      channelName: _channelName,
      description: 'Prayer reminders and alerts',
      sound: _androidSound,
    );
  }

  NotificationDetails forPrayer(
    String prayer,
    DateTime localTime, {
    int? leadMinutesOverride,
  }) {
    final formatted = _timeFormat.format(localTime);
    final lead = leadMinutesOverride ?? _prefs.leadFor(prayer);
    final summary = reminderBody(prayer, lead);
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Prayer reminders and alerts',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        sound: _androidSound,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        styleInformation: BigTextStyleInformation(
          '$prayer at $formatted',
          contentTitle: '$prayer Prayer',
          summaryText: summary,
        ),
      ),
      iOS: DarwinNotificationDetails(
        subtitle: 'Adhan at $formatted',
        threadIdentifier: 'prayer_reminders',
        sound: _voice.id == 'default' ? null : _voice.assetPath,
      ),
    );
  }

  NotificationDetails generic() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Prayer reminders and alerts',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        sound: _androidSound,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      iOS: DarwinNotificationDetails(
        sound: _voice.id == 'default' ? null : _voice.assetPath,
      ),
    );
  }
}

String reminderBody(String prayer, int minutes) {
  if (minutes <= 0) return 'Reminder for $prayer';
  return 'Reminder $minutes min before $prayer';
}
