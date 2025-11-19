import 'package:azkar/core/services/notification_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/notification_settings_block.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets('toggling reminders switch updates prefs', (tester) async {
    NotificationPrefs? updated;

    await tester.pumpWidget(
      _wrap(
        NotificationSettingsBlock(
          prefs: const NotificationPrefs(enabled: true),
          prayers: const ['Fajr'],
          leadOptions: const [0, 5, 10],
          snoozeOptions: const [3, 5],
          onPrefsChanged: (value) => updated = value,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();

    expect(updated, isNotNull);
    expect(updated!.enabled, isFalse);
  });

  testWidgets('filter chips toggle per-prayer flags', (tester) async {
    NotificationPrefs? updated;

    await tester.pumpWidget(
      _wrap(
        NotificationSettingsBlock(
          prefs: const NotificationPrefs(fajr: true),
          prayers: const ['Fajr'],
          leadOptions: const [0, 5, 10],
          snoozeOptions: const [3, 5],
          onPrefsChanged: (value) => updated = value,
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilterChip).first);
    await tester.pumpAndSettle();

    expect(updated, isNotNull);
    expect(updated!.fajr, isFalse);
  });
}
