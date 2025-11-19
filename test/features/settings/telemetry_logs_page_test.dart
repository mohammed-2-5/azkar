import 'dart:async';

import 'package:azkar/core/telemetry/telemetry_cubit.dart';
import 'package:azkar/core/telemetry/telemetry_service.dart';
import 'package:azkar/features/settings/telemetry_logs_page.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<TelemetryCubit> _buildCubit({bool withEntries = false}) async {
    final service = TelemetryService();
    await service.init();
    await service.setEnabled(true);
    if (withEntries) {
      service.logEvent('alpha', {'foo': 'bar'});
      service.logError(Exception('boom'), StackTrace.empty, context: 'ctx');
    }
    return TelemetryCubit(service);
  }

  Widget _wrap(TelemetryCubit cubit) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: const TelemetryLogsPage()),
    );
  }

  testWidgets('shows empty message when no logs collected', (tester) async {
    final cubit = await _buildCubit();
    addTearDown(cubit.close);
    final l10n = AppLocalizationsEn();

    await tester.pumpWidget(_wrap(cubit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.telemetryEmpty), findsOneWidget);
  });

  testWidgets('filters error entries when tapping the Errors chip', (
    tester,
  ) async {
    final cubit = await _buildCubit(withEntries: true);
    addTearDown(cubit.close);
    final l10n = AppLocalizationsEn();

    await tester.pumpWidget(_wrap(cubit));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(2));

    await tester.tap(find.text(l10n.telemetryFilterErrors));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.textContaining('ctx'), findsOneWidget);
  });
}
