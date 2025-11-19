import 'package:azkar/features/prayer_times/presentation/widgets/prayer_tile.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _wrap(Widget child, {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: SizedBox(width: 300, child: child)),
      ),
    );
  }

  group('PrayerTile', () {
    testWidgets('renders labels, relative text, and trailing widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PrayerTile(
            name: 'Asr',
            timeText: '3:15 PM',
            relativeText: 'in 45m',
            icon: Icons.sunny,
            colors: const [Colors.orange],
            trailing: const Icon(Icons.push_pin, key: Key('pin')),
          ),
        ),
      );

      expect(find.text('Asr'), findsOneWidget);
      expect(find.text('3:15 PM'), findsOneWidget);
      expect(find.text('in 45m'), findsOneWidget);
      expect(find.byKey(const Key('pin')), findsOneWidget);
    });

    testWidgets('shows NEXT badge and triggers onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          PrayerTile(
            name: 'Maghrib',
            timeText: '6:05 PM',
            relativeText: 'in 2h',
            icon: Icons.dark_mode,
            colors: const [Colors.deepPurple],
            isNext: true,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('NEXT'), findsOneWidget);
      await tester.tap(find.byType(PrayerTile));
      expect(tapped, isTrue);
    });

    testWidgets('exposes localized semantics label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PrayerTile(
            name: 'Fajr',
            timeText: '05:00',
            relativeText: 'in 1h',
            icon: Icons.nightlight,
            colors: const [Colors.blueGrey],
            isNext: true,
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(PrayerTile));
      expect(semantics.label, contains('Next'));
    });

    testWidgets('adapts layout for large text scale', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: _wrap(
            PrayerTile(
              name: 'Isha',
              timeText: '10:30 PM',
              relativeText: 'in 30m',
              icon: Icons.nights_stay,
              colors: const [Colors.deepPurpleAccent],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
