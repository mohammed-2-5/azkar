import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/core/telemetry/telemetry_cubit.dart';
import 'package:azkar/core/telemetry/telemetry_service.dart';
import 'package:azkar/core/theme/locale_cubit.dart';
import 'package:azkar/core/theme/locale_state.dart';
import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'package:azkar/features/prayer_times/presentation/pages/prayer_times_page.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/prayer_times_grid.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PrayerTimesPage renders warnings, grid, and triggers refresh with telemetry logging', (tester) async {
    final preview = [
      DailyPrayerTimes(
        date: DateTime(2024, 1, 1),
        times: {
          'Fajr': DateTime(2024, 1, 1, 5, 0),
          'Dhuhr': DateTime(2024, 1, 1, 12, 30),
        },
      ),
      DailyPrayerTimes(
        date: DateTime(2024, 1, 2),
        times: {
          'Fajr': DateTime(2024, 1, 2, 5, 1),
          'Dhuhr': DateTime(2024, 1, 2, 12, 31),
        },
      ),
    ];
    final loaded = PrayerTimesState(
      status: PrayerTimesStatus.loaded,
      locationName: 'Doha',
      nextPrayerName: 'Asr',
      nextPrayerTime: DateTime(2024, 1, 1, 15, 30),
      prefs: const CalculationPrefs(),
      staleLocation: true,
      timezoneWarning: true,
      locationTimestamp: DateTime(2023, 12, 31),
    );
    final cubit = _FakePrayerTimesCubit(
      loadedState: loaded,
      preview: preview,
    );
    final telemetryService = _SpyTelemetryService();
    final telemetryCubit = TelemetryCubit(telemetryService);
    final localeCubit = _StubLocaleCubit();
    addTearDown(() async {
      await cubit.close();
      await telemetryCubit.close();
      await localeCubit.close();
    });

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PrayerTimesCubit>.value(value: cubit),
          BlocProvider<TelemetryCubit>.value(value: telemetryCubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PrayerTimesPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Doha'), findsOneWidget);
    expect(
      find.textContaining('Using cached location'),
      findsOneWidget,
    );
    final warningNode = tester.getSemantics(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label?.contains('Using cached location') == true,
      ),
    );
    expect(warningNode.label, contains('Using cached location'));
    expect(
      find.text('Device timezone differs from the calculation timezone. Check Settings.'),
      findsOneWidget,
    );

    final indicator = tester.widget<RefreshIndicator>(
      find.byType(RefreshIndicator),
    );
    await indicator.onRefresh();
    await tester.pump();

    expect(cubit.refreshCalled, isTrue);
    expect(
      telemetryService.events,
      contains('screen_prayer_times'),
    );
  });
}

class _FakePrayerTimesCubit extends PrayerTimesCubit {
  _FakePrayerTimesCubit({
    required this.loadedState,
    required this.preview,
  }) : super(
          GetPreferredLocation(LocationService()),
          NotificationScheduler(NotificationService()),
        );

  final PrayerTimesState loadedState;
  final List<DailyPrayerTimes> preview;
  bool refreshCalled = false;

  @override
  Future<void> fetchToday() async {
    emit(loadedState);
  }

  @override
  List<DailyPrayerTimes> previewDays(
    int dayCount, {
    CalculationPrefs? overridePrefs,
  }) =>
      preview;

  @override
  Future<void> refresh() async {
    refreshCalled = true;
    emit(loadedState);
  }
}

class _SpyTelemetryService extends TelemetryService {
  final List<String> events = [];

  @override
  bool get enabled => true;

  @override
  void logEvent(String name, [Map<String, dynamic>? params]) {
    events.add(name);
  }

  @override
  Future<void> setEnabled(bool value) async {}

  @override
  List<TelemetryEntry> get entries => const [];
}

class _StubLocaleCubit extends LocaleCubit {
  _StubLocaleCubit() : super();

  @override
  Future<void> setLocale(Locale? locale) async {
    emit(LocaleState(locale: locale ?? const Locale('en')));
  }
}
