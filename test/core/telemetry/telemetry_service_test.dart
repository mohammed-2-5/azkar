import 'package:azkar/core/telemetry/telemetry_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('logEvent records entries only when enabled', () async {
    final service = TelemetryService();
    await service.init();

    service.logEvent('test-event');
    expect(service.entries, isEmpty);

    await service.setEnabled(true);
    service.logEvent('test-event', {'foo': 'bar'});

    expect(service.entries, hasLength(1));
    final entry = service.entries.first;
    expect(entry.type, TelemetryEntryType.event);
    expect(entry.label, 'test-event');
    expect(entry.data, {'foo': 'bar'});
  });

  test('logError stores error entries with context', () async {
    final service = TelemetryService();
    await service.init();
    await service.setEnabled(true);

    service.logError(Exception('boom'), StackTrace.empty, context: 'ctx');

    expect(service.entries, isNotEmpty);
    final entry = service.entries.first;
    expect(entry.type, TelemetryEntryType.error);
    expect(entry.label, 'ctx');
    expect(entry.data?['error'], contains('boom'));
  });

  test('exportLog returns formatted text', () async {
    final service = TelemetryService();
    await service.init();
    await service.setEnabled(true);

    service.logEvent('alpha');
    final export = service.exportLog();

    expect(export, contains('alpha'));
  });
}
