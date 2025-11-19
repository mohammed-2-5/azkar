import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/core/theme/locale_cubit.dart';
import 'package:azkar/core/theme/locale_state.dart';
import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/prayer_header.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _wrap({
    required Widget child,
    required PrayerTimesCubit cubit,
    required LocaleCubit localeCubit,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PrayerTimesCubit>.value(value: cubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
        ],
        child: Scaffold(body: child),
      ),
    );
  }

  group('PrayerHeader', () {
    testWidgets('renders location info and next prayer time in 24h format', (tester) async {
      final cubit = _StubPrayerTimesCubit();
      final localeCubit = _StubLocaleCubit();
      addTearDown(() {
        cubit.close();
        localeCubit.close();
      });
      final state = PrayerTimesState(
        locationName: 'Test City',
        nextPrayerName: 'Maghrib',
        nextPrayerTime: DateTime(2024, 1, 1, 17, 30),
        prefs: const CalculationPrefs(use24h: true),
      );

      await tester.pumpWidget(
        _wrap(
          child: PrayerHeader(state: state),
          cubit: cubit,
          localeCubit: localeCubit,
        ),
      );

      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('17:30'), findsOneWidget);
      expect(find.textContaining('Maghrib'), findsWidgets);
      expect(find.text('Snooze'), findsOneWidget);
    });

    testWidgets('falls back to localized current location label', (tester) async {
      final cubit = _StubPrayerTimesCubit();
      final localeCubit = _StubLocaleCubit();
      addTearDown(() {
        cubit.close();
        localeCubit.close();
      });
      final state = PrayerTimesState(
        locationName: null,
        nextPrayerName: 'Fajr',
        nextPrayerTime: DateTime(2024, 1, 1, 5, 0),
        prefs: const CalculationPrefs(),
      );

      await tester.pumpWidget(
        _wrap(
          child: PrayerHeader(state: state),
          cubit: cubit,
          localeCubit: localeCubit,
        ),
      );

      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('Snooze'), findsOneWidget);
    });

    testWidgets('localizes current location and digits for Arabic locale', (tester) async {
      final cubit = _StubPrayerTimesCubit();
      final localeCubit = _StubLocaleCubit();
      addTearDown(() {
        cubit.close();
        localeCubit.close();
      });
      final state = PrayerTimesState(
        locationName: null,
        nextPrayerName: 'Fajr',
        nextPrayerTime: DateTime(2024, 1, 1, 5, 0),
        prefs: const CalculationPrefs(use24h: true),
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<PrayerTimesCubit>.value(value: cubit),
              BlocProvider<LocaleCubit>.value(value: localeCubit),
            ],
            child: Scaffold(body: PrayerHeader(state: state)),
          ),
        ),
      );

      expect(find.text('الموقع الحالي'), findsOneWidget);
      expect(find.text('٠٥:٠٠'), findsOneWidget);
    });
  });
}

class _StubPrayerTimesCubit extends PrayerTimesCubit {
  _StubPrayerTimesCubit()
      : super(
          GetPreferredLocation(LocationService()),
          NotificationScheduler(NotificationService()),
        );

  @override
  Future<int?> snoozeNextPrayer() async => 5;
}

class _StubLocaleCubit extends LocaleCubit {
  _StubLocaleCubit() : super();

  @override
  Future<void> setLocale(Locale? locale) async {
    emit(LocaleState(locale: locale));
  }
}
