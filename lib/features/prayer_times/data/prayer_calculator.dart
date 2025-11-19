import 'package:adhan/adhan.dart' as adhan;

import '../domain/calculation_prefs.dart';

class PrayerCalculator {
  adhan.CalculationParameters _paramsFromPrefs(CalculationPrefs prefs) {
    // 1) Map your prefs.method to the Dart enum (no function calls)
    final adhan.CalculationMethod method = switch (prefs.method) {
      CalcMethod.muslimWorldLeague => adhan.CalculationMethod.muslim_world_league,
      CalcMethod.egyptian         => adhan.CalculationMethod.egyptian,
      CalcMethod.karachi          => adhan.CalculationMethod.karachi,
      CalcMethod.ummAlQura        => adhan.CalculationMethod.umm_al_qura,
      CalcMethod.dubai            => adhan.CalculationMethod.dubai,
      CalcMethod.kuwait           => adhan.CalculationMethod.kuwait,
      CalcMethod.qatar            => adhan.CalculationMethod.qatar,
      CalcMethod.singapore        => adhan.CalculationMethod.singapore,
      CalcMethod.moonsighting     => adhan.CalculationMethod.moon_sighting_committee,
      CalcMethod.turkey           => adhan.CalculationMethod.turkey,
      CalcMethod.tehran           => adhan.CalculationMethod.tehran,
      CalcMethod.northAmerica     => adhan.CalculationMethod.north_america,
    };

    // 2) Get default parameters from the method
    final p = method.getParameters()
      ..madhab = (prefs.madhab == MadhabPref.shafi)
          ? adhan.Madhab.shafi
          : adhan.Madhab.hanafi
      ..highLatitudeRule = switch (prefs.highLatitude) {
        HighLatitudePref.middleOfTheNight => adhan.HighLatitudeRule.middle_of_the_night,
        HighLatitudePref.seventhOfTheNight => adhan.HighLatitudeRule.seventh_of_the_night,
        HighLatitudePref.twilightAngle => adhan.HighLatitudeRule.twilight_angle,
      };

    return p;
  }

  adhan.PrayerTimes compute({
    required double lat,
    required double lng,
    required DateTime date,
    required CalculationPrefs prefs,
  }) {
    final params = _paramsFromPrefs(prefs);
    final coords = adhan.Coordinates(lat, lng);
    final dc = adhan.DateComponents.from(date);
    return adhan.PrayerTimes(coords, dc, params);
  }
}
