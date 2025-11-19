enum CalcMethod {
  muslimWorldLeague,
  egyptian,
  karachi,
  ummAlQura,
  dubai,
  kuwait,
  qatar,
  singapore,
  moonsighting,
  turkey,
  tehran,
  northAmerica,
}

enum MadhabPref { shafi, hanafi }

enum HighLatitudePref { middleOfTheNight, seventhOfTheNight, twilightAngle }

class CalculationPrefs {
  final CalcMethod method;
  final MadhabPref madhab;
  final HighLatitudePref highLatitude;
  final bool use24h;

  const CalculationPrefs({
    this.method = CalcMethod.muslimWorldLeague,
    this.madhab = MadhabPref.shafi,
    this.highLatitude = HighLatitudePref.middleOfTheNight,
    this.use24h = false,
  });

  CalculationPrefs copyWith({
    CalcMethod? method,
    MadhabPref? madhab,
    HighLatitudePref? highLatitude,
    bool? use24h,
  }) => CalculationPrefs(
        method: method ?? this.method,
        madhab: madhab ?? this.madhab,
        highLatitude: highLatitude ?? this.highLatitude,
        use24h: use24h ?? this.use24h,
      );
}

