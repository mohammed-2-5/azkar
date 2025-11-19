import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/prayer_times_grid.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpGrid(
    WidgetTester tester, {
    required List<DailyPrayerTimes> days,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Center(child: PrayerTimesGrid(days: days)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('PrayerTimesGrid', () {
    testWidgets('renders empty fallback when no days provided', (tester) async {
      await pumpGrid(tester, days: const []);

      expect(find.text('Prayer forecast unavailable.'), findsOneWidget);
    });

    testWidgets('shows forecast header and prayer rows', (tester) async {
      final day = DailyPrayerTimes(
        date: DateTime(2024, 1, 1),
        times: {
          'Fajr': DateTime(2024, 1, 1, 5, 15),
          'Dhuhr': DateTime(2024, 1, 1, 12, 30),
          'Maghrib': DateTime(2024, 1, 1, 18, 5),
          'Isha': DateTime(2024, 1, 1, 20, 40),
        },
      );

      await pumpGrid(tester, days: [day]);

      expect(find.text('Prayer times (next 1 days)'), findsOneWidget);
      expect(find.text('Fajr'), findsOneWidget);
      expect(find.text('5:15 AM'), findsOneWidget);
      expect(find.text('Maghrib'), findsOneWidget);
      expect(find.text('6:05 PM'), findsOneWidget);
      // Multiple prayers omitted from times should fallback to placeholders.
      expect(find.text('--:--'), findsWidgets);
    });

    testWidgets('localizes header and times for Arabic locale', (tester) async {
      final day = DailyPrayerTimes(
        date: DateTime(2024, 7, 10),
        times: {
          'Fajr': DateTime(2024, 7, 10, 4, 5),
          'Dhuhr': DateTime(2024, 7, 10, 12, 40),
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData.dark(),
          home: Scaffold(
            body: Center(child: PrayerTimesGrid(days: [day])),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('الصلاة'), findsOneWidget);
      expect(find.text('الفجر'), findsOneWidget);
    });

    testWidgets('day cards expose summary semantics label', (tester) async {
      final day = DailyPrayerTimes(
        date: DateTime(2024, 5, 1),
        times: {
          'Fajr': DateTime(2024, 5, 1, 4, 30),
        },
      );

      await pumpGrid(tester, days: [day]);

      final semanticsFinder = find
          .byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            (widget.properties.label?.contains('Fajr 4:30 AM') ?? false),
      )
          .first;
      final semanticsNode = tester.getSemantics(semanticsFinder);
      expect(semanticsNode.label, contains('Fajr 4:30 AM'));
    });

    testWidgets('grid handles large text scale', (tester) async {
      final day = DailyPrayerTimes(
        date: DateTime(2024, 3, 3),
        times: const {},
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.dark(),
            home: Scaffold(
              body: Center(child: PrayerTimesGrid(days: [day])),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
