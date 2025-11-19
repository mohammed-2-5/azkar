import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final Set<String> _createdChannels = <String>{};

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(initSettings);
    await ensurePrayerChannel(
      channelId: 'prayer_times_channel',
      channelName: 'Prayer Times',
      description: 'Prayer reminders and alerts',
      sound: null,
    );
    await _requestAndroid13PermissionIfNeeded();
    await _requestIOSPermissionIfNeeded();

    // Verify permission was granted
    final granted = await checkPermission();
    if (!granted) {
      dev.log(
        'Notification permission not granted. Notifications may not work.',
        name: 'notifications',
        level: 900,
      );
    } else {
      dev.log('Notification permission granted', name: 'notifications');
    }
  }

  Future<bool> checkPermission() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidImpl = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        if (androidImpl != null) {
          final granted = await androidImpl.areNotificationsEnabled();
          return granted ?? false;
        }
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosImpl = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        if (iosImpl != null) {
          final granted = await iosImpl.requestPermissions(
            alert: false,
            badge: false,
            sound: false,
          );
          return granted ?? false;
        }
      }
    } catch (e) {
      dev.log(
        'Failed to check notification permission: $e',
        name: 'notifications',
        level: 1000,
      );
    }
    return false;
  }

  Future<void> showInstant({int id = 0, String? title, String? body}) async {
    // Ensure default channel exists
    await ensurePrayerChannel(
      channelId: 'default_channel',
      channelName: 'General',
      description: 'General notifications',
      sound: null,
    );

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General',
      importance: Importance.max,
      priority: Priority.max,
      channelDescription: 'General notifications',
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _plugin.show(id, title, body, details);
    dev.log('Instant notification shown: id=$id, title=$title', name: 'notifications');
  }

  Future<void> ensurePrayerChannel({
    required String channelId,
    required String channelName,
    String? description,
    AndroidNotificationSound? sound,
  }) async {
    // Always delete and recreate to ensure sound settings are updated
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      // Delete old channel if it exists
      if (_createdChannels.contains(channelId)) {
        await androidImpl.deleteNotificationChannel(channelId);
        _createdChannels.remove(channelId);
        dev.log('Deleted old channel: $channelId', name: 'notifications');
        // Give Android time to process the deletion
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Create new channel with explicit audio settings
      final channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: description,
        importance: Importance.max,  // Changed to max for sound
        sound: sound,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );
      await androidImpl.createNotificationChannel(channel);
      _createdChannels.add(channelId);
      dev.log('Created channel: $channelId with sound: ${sound?.sound ?? "default"}, importance: max', name: 'notifications');
    }
  }

  Future<void> _requestAndroid13PermissionIfNeeded() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
    } catch (_) {}
  }

  Future<void> _requestIOSPermissionIfNeeded() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (_) {}
  }

  FlutterLocalNotificationsPlugin get raw => _plugin;

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> scheduleNotification({
    required int id,
    required String? title,
    required String? body,
    required tz.TZDateTime dateTime,
    required NotificationDetails details,
    String? payload,
    AndroidScheduleMode androidScheduleMode =
        AndroidScheduleMode.inexactAllowWhileIdle,
  }) async {
    dev.log(
      'Scheduling notification id=$id at $dateTime (mode=$androidScheduleMode)',
      name: 'notifications',
    );
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      dateTime,
      details,
      androidScheduleMode: androidScheduleMode,
      payload: payload,
    );
  }

  Future<bool> requestExactAlarmPermission() async {
    try {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidImpl == null) return false;
      final granted = await androidImpl.requestExactAlarmsPermission() ?? false;
      dev.log('Exact alarm permission result: $granted', name: 'notifications');
      return granted;
    } catch (e) {
      dev.log(
        'Exact alarm permission request failed: $e',
        name: 'notifications',
        level: 1000,
      );
      return false;
    }
  }
}
