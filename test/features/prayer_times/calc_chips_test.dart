import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_state.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/calc_chips.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpChips(
    WidgetTester tester, {
    required PrayerTimesState state,
    MediaQueryData? mediaQuery,
    Locale locale = const Locale('en'),
  }) async {
    final app = MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: CalcChips(state: state),
        ),
      ),
    );
    await tester.pumpWidget(
      mediaQuery != null ? MediaQuery(data: mediaQuery, child: app) : app,
    );
    await tester.pumpAndSettle();
  }

  final baseState = PrayerTimesState(
    status: PrayerTimesStatus.loaded,
    prefs: const CalculationPrefs(),
    locationName: 'Doha',
  );

  testWidgets('renders localized chip labels with semantics', (tester) async {
    await pumpChips(tester, state: baseState);

    expect(find.textContaining('Method'), findsOneWidget);
    final semanticsNode = tester.getSemantics(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label?.contains('Method') == true,
      ),
    );
    expect(semanticsNode.label, contains('Method'));
  });

  testWidgets('handles Arabic locale and large text scale', (tester) async {
    await pumpChips(
      tester,
      state: baseState,
      locale: const Locale('ar'),
      mediaQuery: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
    );

    expect(find.textContaining('طريقة الحساب'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
