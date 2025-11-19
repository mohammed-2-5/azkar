import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/prayer_preview_block.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpPreviewBlock(
    WidgetTester tester, {
    required _TestPrayerTimesCubit cubit,
    required CalculationPrefs prefs,
    required int dayCount,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<PrayerTimesCubit>.value(
          value: cubit,
          child: Scaffold(
            body: PrayerPreviewBlock(
              prefs: prefs,
              dayCount: dayCount,
            ),
          ),
        ),
      ),
    );
  }

  DailyPrayerTimes buildDay(
    DateTime date,
    Map<String, DateTime> times,
  ) {
    return DailyPrayerTimes(date: date, times: times);
  }

  group('PrayerPreviewBlock', () {
    testWidgets('renders preview cards and uses override prefs', (tester) async {
      final cubit = _TestPrayerTimesCubit([
        buildDay(
          DateTime(2024, 1, 1),
          {
            'Fajr': DateTime(2024, 1, 1, 5, 5),
            'Maghrib': DateTime(2024, 1, 1, 18, 30),
          },
        ),
      ]);
      addTearDown(cubit.close);

      const prefs = CalculationPrefs(use24h: true);

      await pumpPreviewBlock(
        tester,
        cubit: cubit,
        prefs: prefs,
        dayCount: 1,
      );
      await tester.pumpAndSettle();

      expect(cubit.lastDayCount, 1);
      expect(cubit.lastOverride, same(prefs));
      expect(find.text('Preview (next 1 days)'), findsOneWidget);
      expect(find.text('Fajr'), findsOneWidget);
      expect(find.text('05:05'), findsOneWidget);
      expect(find.text('Maghrib'), findsOneWidget);
      expect(find.text('18:30'), findsOneWidget);
    });

    testWidgets('uses 12-hour format when disabled', (tester) async {
      final cubit = _TestPrayerTimesCubit([
        buildDay(
          DateTime(2024, 2, 2),
          {
            'Dhuhr': DateTime(2024, 2, 2, 12, 0),
            'Isha': DateTime(2024, 2, 2, 21, 45),
          },
        ),
      ]);
      addTearDown(cubit.close);

      const prefs = CalculationPrefs(use24h: false);

      await pumpPreviewBlock(
        tester,
        cubit: cubit,
        prefs: prefs,
        dayCount: 2,
      );
      await tester.pumpAndSettle();

      expect(find.text('Preview (next 2 days)'), findsOneWidget);
      expect(find.text('12:00 PM'), findsOneWidget);
      expect(find.text('9:45 PM'), findsOneWidget);
    });

    testWidgets('shows empty message when cubit has no preview days', (tester) async {
      final cubit = _TestPrayerTimesCubit(const <DailyPrayerTimes>[]);
      addTearDown(cubit.close);

      await pumpPreviewBlock(
        tester,
        cubit: cubit,
        prefs: const CalculationPrefs(),
        dayCount: 5,
      );
      await tester.pumpAndSettle();

      expect(cubit.lastDayCount, 5);
      expect(
        find.text('Preview unavailable for this location.'),
        findsOneWidget,
      );
      expect(find.byType(Card), findsNothing);
    });
  });
}

class _TestPrayerTimesCubit extends PrayerTimesCubit {
  _TestPrayerTimesCubit(this._days)
      : super(
          GetPreferredLocation(LocationService()),
          NotificationScheduler(NotificationService()),
        );

  final List<DailyPrayerTimes> _days;
  int? lastDayCount;
  CalculationPrefs? lastOverride;

  @override
  List<DailyPrayerTimes> previewDays(
    int dayCount, {
    CalculationPrefs? overridePrefs,
  }) {
    lastDayCount = dayCount;
    lastOverride = overridePrefs;
    return _days;
  }
}
