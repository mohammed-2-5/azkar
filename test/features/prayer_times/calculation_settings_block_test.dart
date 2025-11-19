import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:azkar/core/services/notification_scheduler.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/features/prayer_times/domain/calculation_prefs.dart';
import 'package:azkar/features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:azkar/features/prayer_times/presentation/widgets/calculation_settings_block.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _buildSubject({
    required PrayerTimesCubit cubit,
    required CalculationPrefs prefs,
    required ValueChanged<CalculationPrefs> onPrefsChanged,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<PrayerTimesCubit>.value(
        value: cubit,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: CalculationSettingsBlock(
              prefs: prefs,
              onPrefsChanged: onPrefsChanged,
            ),
          ),
        ),
      ),
    );
  }

  Finder _dropdownForValue(Object value) {
    return find.byWidgetPredicate(
      (widget) => widget is DropdownButton && widget.value == value,
    );
  }

  group('CalculationSettingsBlock', () {
    testWidgets('calls cubit.useDeviceLocation when tapping use device', (tester) async {
      final cubit = _RecordingPrayerTimesCubit();
      addTearDown(cubit.close);

      await tester.pumpWidget(
        _buildSubject(
          cubit: cubit,
          prefs: const CalculationPrefs(),
          onPrefsChanged: (_) {},
        ),
      );

      await tester.tap(find.text('Use device'));
      await tester.pump();

      expect(cubit.useDeviceRequested, isTrue);
    });

    testWidgets('setFixedLocation receives coordinates from choose city flow', (tester) async {
      final cubit = _RecordingPrayerTimesCubit();
      addTearDown(cubit.close);
      final navKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        _buildSubject(
          cubit: cubit,
          prefs: const CalculationPrefs(),
          onPrefsChanged: (_) {},
          navigatorKey: navKey,
        ),
      );

      await tester.tap(find.text('Choose city'));
      await tester.pump();

      navKey.currentState!.pop({'lat': 33.12, 'lng': 44.56, 'label': 'Testville'});
      await tester.pumpAndSettle();

      expect(cubit.lastFixedLocation, isNotNull);
      expect(cubit.lastFixedLocation!['lat'], 33.12);
      expect(cubit.lastFixedLocation!['lng'], 44.56);
      expect(cubit.lastFixedLocation!['label'], 'Testville');
    });

    testWidgets('dropdowns and switch emit updated prefs', (tester) async {
      final cubit = _RecordingPrayerTimesCubit();
      addTearDown(cubit.close);
      final emitted = <CalculationPrefs>[];

      await tester.pumpWidget(
        _buildSubject(
          cubit: cubit,
          prefs: const CalculationPrefs(),
          onPrefsChanged: emitted.add,
        ),
      );

      await tester.tap(_dropdownForValue(CalcMethod.muslimWorldLeague));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Egyptian Authority').last);
      await tester.pumpAndSettle();

      expect(emitted, isNotEmpty);
      expect(emitted.removeLast().method, CalcMethod.egyptian);

      await tester.tap(_dropdownForValue(MadhabPref.shafi));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hanafi').last);
      await tester.pumpAndSettle();

      expect(emitted, isNotEmpty);
      expect(emitted.removeLast().madhab, MadhabPref.hanafi);

      await tester.tap(_dropdownForValue(HighLatitudePref.middleOfTheNight));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Twilight angle').last);
      await tester.pumpAndSettle();

      expect(emitted, isNotEmpty);
      expect(
        emitted.removeLast().highLatitude,
        HighLatitudePref.twilightAngle,
      );

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(emitted, isNotEmpty);
      expect(emitted.removeLast().use24h, isTrue);
    });
  });
}

class _RecordingPrayerTimesCubit extends PrayerTimesCubit {
  _RecordingPrayerTimesCubit()
      : super(
          GetPreferredLocation(LocationService()),
          NotificationScheduler(NotificationService()),
        );

  bool useDeviceRequested = false;
  Map<String, Object?>? lastFixedLocation;

  @override
  Future<void> useDeviceLocation() async {
    useDeviceRequested = true;
  }

  @override
  Future<void> setFixedLocation({
    required double lat,
    required double lng,
    required String label,
  }) async {
    lastFixedLocation = {'lat': lat, 'lng': lng, 'label': label};
  }
}
