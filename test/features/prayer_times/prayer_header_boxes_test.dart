import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/core/theme/locale_cubit.dart';
import 'package:azkar/core/theme/locale_state.dart';
import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/prayer_header_boxes.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('LocationBox', () {
    testWidgets('shows title and subtitle when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const LocationBox(title: 'Doha, Qatar', subtitle: 'Hijri 1446')),
      );

      expect(find.text('Doha, Qatar'), findsOneWidget);
      expect(find.text('Hijri 1446'), findsOneWidget);
    });
  });

  group('NextPrayerBox', () {
    testWidgets('displays formatted labels and values', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NextPrayerBox(
            timeText: '05:12',
            remainingText: 'in 1h 30m',
            label: 'Next',
            prayerName: 'Fajr',
            remainingLabel: 'Time remaining',
          ),
        ),
      );

      expect(find.textContaining('Next'), findsWidgets);
      expect(find.text('05:12'), findsOneWidget);
      expect(find.text('in 1h 30m'), findsOneWidget);
      expect(find.text('Time remaining'), findsOneWidget);
    });

    testWidgets('provides semantics summary label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NextPrayerBox(
            timeText: '05:12',
            remainingText: 'in 1h 30m',
            label: 'Next',
            prayerName: 'Fajr',
            remainingLabel: 'Time remaining',
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(NextPrayerBox));
      expect(semantics.hasFlag(SemanticsFlag.isHeader), isTrue);
      expect(semantics.label, contains('Next'));
    });
  });

  group('ActionRow', () {
    testWidgets('disables snooze button when next prayer is missing', (tester) async {
      final cubit = _TestPrayerTimesCubit();
      final localeCubit = _TestLocaleCubit();
      addTearDown(() {
        cubit.close();
        localeCubit.close();
      });

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<PrayerTimesCubit>.value(value: cubit),
              BlocProvider<LocaleCubit>.value(value: localeCubit),
            ],
            child: Scaffold(
              body: ActionRow(
                state: const PrayerTimesState(
                  nextPrayerName: null,
                  nextPrayerTime: null,
                  prefs: CalculationPrefs(),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Snooze'), findsOneWidget);
      final buttonFinder = find.ancestor(
        of: find.text('Snooze'),
        matching: find.byWidgetPredicate((widget) => widget is ButtonStyleButton),
      );
      final button = tester.widget<ButtonStyleButton>(buttonFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('tapping snooze invokes cubit and shows snackbar', (tester) async {
      final cubit = _TestPrayerTimesCubit(returnMinutes: 7);
      final localeCubit = _TestLocaleCubit();
      addTearDown(() {
        cubit.close();
        localeCubit.close();
      });
      final state = PrayerTimesState(
        nextPrayerName: 'Fajr',
        nextPrayerTime: DateTime.now().add(const Duration(hours: 1, minutes: 10)),
        prefs: const CalculationPrefs(),
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<PrayerTimesCubit>.value(value: cubit),
              BlocProvider<LocaleCubit>.value(value: localeCubit),
            ],
            child: Scaffold(
              body: ActionRow(state: state),
            ),
          ),
        ),
      );

      expect(find.text('Snooze'), findsOneWidget);
      final buttonFinder = find.ancestor(
        of: find.text('Snooze'),
        matching: find.byWidgetPredicate((widget) => widget is ButtonStyleButton),
      );
      await tester.tap(buttonFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(cubit.snoozeCalled, isTrue);
      expect(
        find.text('Reminder snoozed for 7 minutes.'),
        findsOneWidget,
      );
    });
  });
}

class _TestPrayerTimesCubit extends PrayerTimesCubit {
  _TestPrayerTimesCubit({this.returnMinutes = 5})
      : super(
          GetPreferredLocation(LocationService()),
          NotificationScheduler(NotificationService()),
        );

  final int returnMinutes;
  bool snoozeCalled = false;

  @override
  Future<int?> snoozeNextPrayer() async {
    snoozeCalled = true;
    return returnMinutes;
  }
}

class _TestLocaleCubit extends LocaleCubit {
  _TestLocaleCubit() : super();

  @override
  Future<void> setLocale(Locale? locale) async {
    emit(LocaleState(locale: locale));
  }
}
