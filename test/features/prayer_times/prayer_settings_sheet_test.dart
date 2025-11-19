import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:azkar/core/services/notification_prefs.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/prayer_settings_sheet.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrayerSettingsSheet', () {
    testWidgets(' Apply saves updated calculation prefs and notification settings', (tester) async {
      final cubit = _SpyPrayerTimesCubit(
        initialNotificationPrefs: const NotificationPrefs(enabled: true),
      );
      addTearDown(cubit.close);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<PrayerTimesCubit>.value(
            value: cubit,
            child: const _SheetLauncher(),
          ),
        ),
      );

      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('24-hour clock'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enable prayer reminders'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(cubit.updatedPrefs, isNotEmpty);
      expect(cubit.updatedPrefs.last.use24h, isTrue);
      expect(cubit.savedNotificationPrefs, isNotNull);
      expect(cubit.savedNotificationPrefs!.enabled, isFalse);
    });
  });
}

class _SheetLauncher extends StatelessWidget {
  const _SheetLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showPrayerSettingsSheet(
            context,
            const CalculationPrefs(),
          ),
          child: const Text('Open settings'),
        ),
      ),
    );
  }
}

class _SpyPrayerTimesCubit extends PrayerTimesCubit {
  _SpyPrayerTimesCubit({required this.initialNotificationPrefs})
      : super(
          GetPreferredLocation(LocationService()),
          NotificationScheduler(NotificationService()),
        );

  final NotificationPrefs initialNotificationPrefs;
  final List<CalculationPrefs> updatedPrefs = [];
  NotificationPrefs? savedNotificationPrefs;

  @override
  Future<NotificationPrefs> currentNotificationPrefs() async =>
      initialNotificationPrefs;

  @override
  Future<void> updatePrefs(CalculationPrefs prefs) async {
    updatedPrefs.add(prefs);
  }

  @override
  Future<void> saveNotificationPrefs(NotificationPrefs prefs) async {
    savedNotificationPrefs = prefs;
  }
}
