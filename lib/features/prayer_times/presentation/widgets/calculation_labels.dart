import 'package:azkar/l10n/app_localizations.dart';

import '../../domain/calculation_prefs.dart';

bool _isArabic(AppLocalizations l10n) =>
    l10n.localeName.toLowerCase().startsWith('ar');

String calcMethodLabel(AppLocalizations l10n, CalcMethod method) {
  final labels = _isArabic(l10n) ? _methodLabelsAr : _methodLabelsEn;
  return labels[method] ?? method.name;
}

String madhabLabel(AppLocalizations l10n, MadhabPref madhab) {
  final labels = _isArabic(l10n) ? _madhabLabelsAr : _madhabLabelsEn;
  return labels[madhab] ?? madhab.name;
}

String highLatitudeLabel(AppLocalizations l10n, HighLatitudePref pref) {
  final labels = _isArabic(l10n)
      ? _highLatitudeLabelsAr
      : _highLatitudeLabelsEn;
  return labels[pref] ?? pref.name;
}

String localizedPrayerName(AppLocalizations l10n, String prayerKey) {
  switch (prayerKey) {
    case 'Fajr':
      return l10n.fajr;
    case 'Sunrise':
      return l10n.sunrise;
    case 'Dhuhr':
      return l10n.dhuhr;
    case 'Asr':
      return l10n.asr;
    case 'Maghrib':
      return l10n.maghrib;
    case 'Isha':
      return l10n.isha;
    default:
      return prayerKey;
  }
}

const Map<CalcMethod, String> _methodLabelsEn = {
  CalcMethod.muslimWorldLeague: 'Muslim World League',
  CalcMethod.egyptian: 'Egyptian Authority',
  CalcMethod.karachi: 'Karachi',
  CalcMethod.ummAlQura: 'Umm Al-Qura (Makkah)',
  CalcMethod.dubai: 'Dubai',
  CalcMethod.kuwait: 'Kuwait',
  CalcMethod.qatar: 'Qatar',
  CalcMethod.singapore: 'Singapore',
  CalcMethod.moonsighting: 'Moonsighting Committee',
  CalcMethod.turkey: 'Turkey (Diyanet)',
  CalcMethod.tehran: 'Tehran',
  CalcMethod.northAmerica: 'North America (ISNA)',
};

const Map<CalcMethod, String> _methodLabelsAr = {
  CalcMethod.muslimWorldLeague: 'رابطة العالم الإسلامي',
  CalcMethod.egyptian: 'الهيئة المصرية',
  CalcMethod.karachi: 'كراتشي',
  CalcMethod.ummAlQura: 'أم القرى (مكة)',
  CalcMethod.dubai: 'دبي',
  CalcMethod.kuwait: 'الكويت',
  CalcMethod.qatar: 'قطر',
  CalcMethod.singapore: 'سنغافورة',
  CalcMethod.moonsighting: 'لجنة تحري الهلال',
  CalcMethod.turkey: 'تركيا (ديانات)',
  CalcMethod.tehran: 'طهران',
  CalcMethod.northAmerica: 'أمريكا الشمالية (ISNA)',
};

const Map<MadhabPref, String> _madhabLabelsEn = {
  MadhabPref.shafi: 'Shafi’i',
  MadhabPref.hanafi: 'Hanafi',
};

const Map<MadhabPref, String> _madhabLabelsAr = {
  MadhabPref.shafi: 'شافعي',
  MadhabPref.hanafi: 'حنفي',
};

const Map<HighLatitudePref, String> _highLatitudeLabelsEn = {
  HighLatitudePref.middleOfTheNight: 'Middle of the night',
  HighLatitudePref.seventhOfTheNight: 'Seventh of the night',
  HighLatitudePref.twilightAngle: 'Twilight angle',
};

const Map<HighLatitudePref, String> _highLatitudeLabelsAr = {
  HighLatitudePref.middleOfTheNight: 'منتصف الليل',
  HighLatitudePref.seventhOfTheNight: 'سبع الليل',
  HighLatitudePref.twilightAngle: 'زاوية الشفق',
};
