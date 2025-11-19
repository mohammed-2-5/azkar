// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Azkar';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navQiblah => 'Qiblah';

  @override
  String get navAzkar => 'Azkar';

  @override
  String get navQuran => 'Qur\'an';

  @override
  String get prayerTitle => 'Prayer Times';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get next => 'Next';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get calcTitle => 'Prayer Calculation';

  @override
  String get location => 'Location';

  @override
  String get useDevice => 'Use device';

  @override
  String get chooseCity => 'Choose city';

  @override
  String get method => 'Method';

  @override
  String get madhab => 'Madhab';

  @override
  String get highLatitude => 'High Latitude';

  @override
  String get hour24 => '24-hour clock';

  @override
  String previewTitle(Object days) {
    return 'Preview (next $days days)';
  }

  @override
  String get previewUnavailable =>
      'Preview unavailable. Set your location first.';

  @override
  String get perPrayerLeadTitle => 'Per-prayer lead times';

  @override
  String get perPrayerLeadInfo =>
      'Override the default reminder offset for specific prayers.';

  @override
  String get leadDefaultLabel => 'Use default';

  @override
  String get quietHours => 'Quiet hours';

  @override
  String get quietInfo =>
      'Mute reminders between these times (device local time).';

  @override
  String get quietStartLabel => 'Start';

  @override
  String get quietEndLabel => 'End';

  @override
  String get quietOff => 'Off';

  @override
  String get quietClear => 'Clear quiet hours';

  @override
  String cachedLocationWarning(Object date) {
    return 'Using cached location from $date. Refresh to update.';
  }

  @override
  String get timezoneWarning =>
      'Device timezone differs from this location. Verify your settings.';

  @override
  String get unknownDate => 'unknown date';

  @override
  String get snoozeLabel => 'Enable snooze button';

  @override
  String get snoozeInfo => 'Adds a quick snooze reminder for the next prayer.';

  @override
  String get snoozeMinutesLabel => 'Snooze duration';

  @override
  String get snoozeAction => 'Snooze';

  @override
  String snoozeScheduled(Object minutes) {
    return 'Snoozed for $minutes min.';
  }

  @override
  String get snoozeUnavailable => 'Turn on snooze reminders in settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableReminders => 'Enable prayer reminders';

  @override
  String get leadTime => 'Lead time';

  @override
  String minutes(Object m) {
    return '$m min';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get searchDuas => 'Search duas...';

  @override
  String get azkarNoResults => 'No duas match your filters.';

  @override
  String get azkarTitle => 'Azkar';

  @override
  String get qiblahTitle => 'Qiblah';

  @override
  String get qiblahSubtitle => 'Find the Kaaba direction';

  @override
  String get qiblahAlignmentStatus => 'Alignment';

  @override
  String get qiblahAligned => 'Perfectly aligned with Qiblah.';

  @override
  String qiblahRotateLeft(Object degrees) {
    return 'Rotate left $degrees°';
  }

  @override
  String qiblahRotateRight(Object degrees) {
    return 'Rotate right $degrees°';
  }

  @override
  String get qiblahCalibrationTips => 'Calibration tips';

  @override
  String get qiblahCalibrationBody =>
      'Move your phone in a figure 8 and keep away from metal objects to improve accuracy.';

  @override
  String get language => 'Language';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get appearanceTextScale => 'Text size';

  @override
  String get appearanceTextScaleDescription =>
      'Adjust the global text size used across the app.';

  @override
  String get appearancePreviewTitle => 'Preview';

  @override
  String get appearancePreviewBody =>
      'This card previews how your text will look with the selected size.';

  @override
  String get appearanceTelemetryTitle => 'Share anonymous diagnostics';

  @override
  String get appearanceTelemetryBody =>
      'Help us understand crashes and usage trends. We never collect personal data.';

  @override
  String get appearanceTelemetryCardTitle => 'Share anonymous diagnostics';

  @override
  String get appearanceTelemetryViewLogs => 'View diagnostics';

  @override
  String get save => 'Save';

  @override
  String get rescheduleNow => 'Reschedule Now';

  @override
  String get chooseCityTitle => 'Choose City';

  @override
  String get hubTitle => 'Supplications & Knowledge';

  @override
  String get hubSubtitle => 'Choose what you would like to explore today.';

  @override
  String get hubAzkarTitle => 'Daily Azkar';

  @override
  String get hubAzkarDescription =>
      'Browse the curated morning, evening, and post-prayer remembrances.';

  @override
  String get hubAzkarAction => 'Open Azkar';

  @override
  String get hubHadithTitle => 'Hadith Library';

  @override
  String get hubHadithDescription =>
      'Explore the authentic collections from Bukhari, Muslim, Malik, and Ahmad.';

  @override
  String get hubHadithAction => 'View collections';

  @override
  String get hubFortyTitle => 'Forty Hadith Sets';

  @override
  String get hubFortyDescription =>
      'Read the Nawawi, Qudsi, and Shah Waliullah curated forty hadith sets.';

  @override
  String get hubFortyAction => 'View forties';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get catMorning => 'Morning';

  @override
  String get catEvening => 'Evening';

  @override
  String get catAfterPrayer => 'After Prayer';

  @override
  String get catSleep => 'Sleep';

  @override
  String get catDoaa => 'Supplications';

  @override
  String todayHijri(Object date) {
    return 'Hijri: $date';
  }

  @override
  String qiblahLabel(Object deg) {
    return 'Qiblah $deg°';
  }

  @override
  String headingLabel(Object deg) {
    return 'Heading $deg°';
  }

  @override
  String get timeRemaining => 'Time remaining';

  @override
  String get progressLabel => 'Progress';

  @override
  String favoritesCount(Object count) {
    return 'Favorites ($count)';
  }

  @override
  String get favoritesScreenTitle => 'Favorites';

  @override
  String get noFavorites => 'No favorites yet.';

  @override
  String prayerForecast(Object days) {
    return 'Prayer times (next $days days)';
  }

  @override
  String get calibrationHint =>
      'Move phone in a figure-8 to calibrate if needed';

  @override
  String get qrToggleTr => 'Toggle translation';

  @override
  String get qrToggleTrans => 'Toggle transliteration';

  @override
  String get continueReading => 'Continue reading';

  @override
  String get search => 'Search...';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get viewMushaf => 'Mushaf view';

  @override
  String get viewTiles => 'Tile view';

  @override
  String get hadithCollectionsTitle => 'Hadith Collections';

  @override
  String get fortiesCollectionsTitle => 'Forty Hadith';

  @override
  String collectionLoadError(Object error) => 'Failed to load: $error';

  @override
  String collectionEntriesLoadError(Object error) =>
      'Failed to load entries: $error';

  @override
  String get collectionEmpty => 'No collections available.';

  @override
  String get collectionNotFound => 'Collection not found.';

  @override
  String get collectionSearchHint => 'Search narrations';

  @override
  String get collectionNoEntries => 'No entries match your search.';

  @override
  String collectionNarrationsLabel(Object count) => '$count narrations';

  @override
  String collectionChaptersLabel(Object count) => '$count chapters';
}
