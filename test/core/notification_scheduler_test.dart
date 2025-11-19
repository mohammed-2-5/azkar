import 'package:azkar/core/services/notification_prefs.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azkar/core/telemetry/telemetry_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class _ScheduledCall {
  final int id;
  final String? title;
  final String? body;
  final tz.TZDateTime dateTime;
  final NotificationDetails details;
  final String? payload;
  _ScheduledCall({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.details,
    required this.payload,
  });
}

class _ChannelCall {
  final String channelId;
  final AndroidNotificationSound? sound;
  _ChannelCall(this.channelId, this.sound);
}

class _FakeNotificationService extends NotificationService {
  _FakeNotificationService() : super(plugin: FlutterLocalNotificationsPlugin());

  final List<_ScheduledCall> scheduled = [];
  final List<_ChannelCall> channels = [];
  int cancelAllCount = 0;
  int ensureCount = 0;

  @override
  Future<void> cancelAllNotifications() async {
    cancelAllCount++;
  }

  @override
  Future<void> ensurePrayerChannel({
    required String channelId,
    required String channelName,
    String? description,
    AndroidNotificationSound? sound,
  }) async {
    ensureCount++;
    channels.add(_ChannelCall(channelId, sound));
  }

  @override
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
    scheduled.add(
      _ScheduledCall(
        id: id,
        title: title,
        body: body,
        dateTime: dateTime,
        details: details,
        payload: payload,
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await NotificationScheduler.ensureTZ();
  });

  test('schedules notifications with custom azan voice sound', () async {
    final fake = _FakeNotificationService();
    final scheduler = NotificationScheduler(fake);
    final now = DateTime.now();
    final times = {'Fajr': now.add(const Duration(minutes: 30))};
    final prefs = const NotificationPrefs(azanVoice: 'adhan1', leadMinutes: 0);

    await scheduler.scheduleForTimes(times: times, prefs: prefs);

    expect(fake.cancelAllCount, 1);
    expect(fake.ensureCount, greaterThan(0));
    expect(fake.channels, isNotEmpty);
    final channelCall = fake.channels.first;
    expect(channelCall.channelId, 'prayer_times_channel_adhan1');
    expect(fake.scheduled, isNotEmpty);
    final scheduled = fake.scheduled.first;
    final android = scheduled.details.android!;
    final sound = android.sound as RawResourceAndroidNotificationSound;
    expect(sound.sound, 'adhan1');
  });

  test('quiet hours suppress notifications', () async {
    final fake = _FakeNotificationService();
    final scheduler = NotificationScheduler(fake);
    final now = DateTime.now();
    final times = {'Fajr': now.add(const Duration(minutes: 30))};
    final prefs = const NotificationPrefs(
      leadMinutes: 0,
      quietStart: 0,
      quietEnd: 1439,
    );

    await scheduler.scheduleForTimes(times: times, prefs: prefs);

    expect(fake.scheduled, isEmpty);
    expect(fake.cancelAllCount, 1);
  });

  test('scheduler emits telemetry events when provided', () async {
    SharedPreferences.setMockInitialValues({});
    final telemetry = TelemetryService();
    await telemetry.init();
    await telemetry.setEnabled(true);

    final fake = _FakeNotificationService();
    final scheduler = NotificationScheduler(
      fake,
      telemetryService: telemetry,
    );

    final now = DateTime.now();
    await scheduler.scheduleForTimes(
      times: {'Fajr': now.add(const Duration(minutes: 40))},
      prefs: const NotificationPrefs(leadMinutes: 0),
    );

    final labels = telemetry.entries.map((e) => e.label).toList();
    expect(labels, contains('notification_scheduled'));
  });
}
