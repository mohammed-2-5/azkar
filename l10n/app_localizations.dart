import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get appTitle;

  /// No description provided for @navPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// No description provided for @navQiblah.
  ///
  /// In en, this message translates to:
  /// **'Qiblah'**
  String get navQiblah;

  /// No description provided for @navAzkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get navAzkar;

  /// No description provided for @navQuran.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an'**
  String get navQuran;

  /// No description provided for @prayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTitle;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @calcTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get calcTitle;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @useDevice.
  ///
  /// In en, this message translates to:
  /// **'Use device'**
  String get useDevice;

  /// No description provided for @chooseCity.
  ///
  /// In en, this message translates to:
  /// **'Choose city'**
  String get chooseCity;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @madhab.
  ///
  /// In en, this message translates to:
  /// **'Madhab'**
  String get madhab;

  /// No description provided for @highLatitude.
  ///
  /// In en, this message translates to:
  /// **'High Latitude'**
  String get highLatitude;

  /// No description provided for @hour24.
  ///
  /// In en, this message translates to:
  /// **'24-hour clock'**
  String get hour24;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview (next {days} days)'**
  String previewTitle(Object days);

  /// No description provided for @previewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview unavailable. Set your location first.'**
  String get previewUnavailable;

  /// No description provided for @perPrayerLeadTitle.
  ///
  /// In en, this message translates to:
  /// **'Per-prayer lead times'**
  String get perPrayerLeadTitle;

  /// No description provided for @perPrayerLeadInfo.
  ///
  /// In en, this message translates to:
  /// **'Override the default reminder offset for specific prayers.'**
  String get perPrayerLeadInfo;

  /// No description provided for @leadDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Use default'**
  String get leadDefaultLabel;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get quietHours;

  /// No description provided for @quietInfo.
  ///
  /// In en, this message translates to:
  /// **'Mute reminders between these times (device local time).'**
  String get quietInfo;

  /// No description provided for @quietStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get quietStartLabel;

  /// No description provided for @quietEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get quietEndLabel;

  /// No description provided for @quietOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get quietOff;

  /// No description provided for @quietClear.
  ///
  /// In en, this message translates to:
  /// **'Clear quiet hours'**
  String get quietClear;

  /// No description provided for @cachedLocationWarning.
  ///
  /// In en, this message translates to:
  /// **'Using cached location from {date}. Refresh to update.'**
  String cachedLocationWarning(Object date);

  /// No description provided for @timezoneWarning.
  ///
  /// In en, this message translates to:
  /// **'Device timezone differs from this location. Verify your settings.'**
  String get timezoneWarning;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'unknown date'**
  String get unknownDate;

  /// No description provided for @snoozeLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable snooze button'**
  String get snoozeLabel;

  /// No description provided for @snoozeInfo.
  ///
  /// In en, this message translates to:
  /// **'Adds a quick snooze reminder for the next prayer.'**
  String get snoozeInfo;

  /// No description provided for @snoozeMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze duration'**
  String get snoozeMinutesLabel;

  /// No description provided for @snoozeAction.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snoozeAction;

  /// No description provided for @snoozeScheduled.
  ///
  /// In en, this message translates to:
  /// **'Snoozed for {minutes} min.'**
  String snoozeScheduled(Object minutes);

  /// No description provided for @snoozeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Turn on snooze reminders in settings'**
  String get snoozeUnavailable;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable prayer reminders'**
  String get enableReminders;

  /// No description provided for @leadTime.
  ///
  /// In en, this message translates to:
  /// **'Lead time'**
  String get leadTime;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{m} min'**
  String minutes(Object m);

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @searchDuas.
  ///
  /// In en, this message translates to:
  /// **'Search duas...'**
  String get searchDuas;

  /// No description provided for @azkarNoResults.
  ///
  /// In en, this message translates to:
  /// **'No duas match your filters.'**
  String get azkarNoResults;

  /// No description provided for @azkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkarTitle;

  /// No description provided for @qiblahTitle.
  ///
  /// In en, this message translates to:
  /// **'Qiblah'**
  String get qiblahTitle;

  /// No description provided for @qiblahSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the Kaaba direction'**
  String get qiblahSubtitle;

  /// No description provided for @qiblahAlignmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get qiblahAlignmentStatus;

  /// No description provided for @qiblahAligned.
  ///
  /// In en, this message translates to:
  /// **'Perfectly aligned with Qiblah.'**
  String get qiblahAligned;

  /// No description provided for @qiblahRotateLeft.
  ///
  /// In en, this message translates to:
  /// **'Rotate left {degrees}°'**
  String qiblahRotateLeft(Object degrees);

  /// No description provided for @qiblahRotateRight.
  ///
  /// In en, this message translates to:
  /// **'Rotate right {degrees}°'**
  String qiblahRotateRight(Object degrees);

  /// No description provided for @qiblahCalibrationTips.
  ///
  /// In en, this message translates to:
  /// **'Calibration tips'**
  String get qiblahCalibrationTips;

  /// No description provided for @qiblahCalibrationBody.
  ///
  /// In en, this message translates to:
  /// **'Move your phone in a figure 8 and keep away from metal objects to improve accuracy.'**
  String get qiblahCalibrationBody;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @appearanceTextScale.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get appearanceTextScale;

  /// No description provided for @appearanceTextScaleDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust the global text size used across the app.'**
  String get appearanceTextScaleDescription;

  /// No description provided for @appearancePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get appearancePreviewTitle;

  /// No description provided for @appearancePreviewBody.
  ///
  /// In en, this message translates to:
  /// **'This card previews how your text will look with the selected size.'**
  String get appearancePreviewBody;

  /// No description provided for @appearanceTelemetryTitle.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous diagnostics'**
  String get appearanceTelemetryTitle;

  /// No description provided for @appearanceTelemetryBody.
  ///
  /// In en, this message translates to:
  /// **'Help us understand crashes and usage trends. We never collect personal data.'**
  String get appearanceTelemetryBody;

  /// No description provided for @appearanceTelemetryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous diagnostics'**
  String get appearanceTelemetryCardTitle;

  /// No description provided for @appearanceTelemetryViewLogs.
  ///
  /// In en, this message translates to:
  /// **'View diagnostics'**
  String get appearanceTelemetryViewLogs;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @rescheduleNow.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Now'**
  String get rescheduleNow;

  /// No description provided for @chooseCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose City'**
  String get chooseCityTitle;

  /// No description provided for @hubTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplications & Knowledge'**
  String get hubTitle;

  /// No description provided for @hubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you would like to explore today.'**
  String get hubSubtitle;

  /// No description provided for @hubAzkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Azkar'**
  String get hubAzkarTitle;

  /// No description provided for @hubAzkarDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse the curated morning, evening, and post-prayer remembrances.'**
  String get hubAzkarDescription;

  /// No description provided for @hubAzkarAction.
  ///
  /// In en, this message translates to:
  /// **'Open Azkar'**
  String get hubAzkarAction;

  /// No description provided for @hubHadithTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith Library'**
  String get hubHadithTitle;

  /// No description provided for @hubHadithDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore the authentic collections from Bukhari, Muslim, Malik, and Ahmad.'**
  String get hubHadithDescription;

  /// No description provided for @hubHadithAction.
  ///
  /// In en, this message translates to:
  /// **'View collections'**
  String get hubHadithAction;

  /// No description provided for @hubFortyTitle.
  ///
  /// In en, this message translates to:
  /// **'Forty Hadith Sets'**
  String get hubFortyTitle;

  /// No description provided for @hubFortyDescription.
  ///
  /// In en, this message translates to:
  /// **'Read the Nawawi, Qudsi, and Shah Waliullah curated forty hadith sets.'**
  String get hubFortyDescription;

  /// No description provided for @hubFortyAction.
  ///
  /// In en, this message translates to:
  /// **'View forties'**
  String get hubFortyAction;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @catMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get catMorning;

  /// No description provided for @catEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get catEvening;

  /// No description provided for @catAfterPrayer.
  ///
  /// In en, this message translates to:
  /// **'After Prayer'**
  String get catAfterPrayer;

  /// No description provided for @catSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get catSleep;

  /// No description provided for @catDoaa.
  ///
  /// In en, this message translates to:
  /// **'Supplications'**
  String get catDoaa;

  /// No description provided for @todayHijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri: {date}'**
  String todayHijri(Object date);

  /// No description provided for @qiblahLabel.
  ///
  /// In en, this message translates to:
  /// **'Qiblah {deg}°'**
  String qiblahLabel(Object deg);

  /// No description provided for @headingLabel.
  ///
  /// In en, this message translates to:
  /// **'Heading {deg}°'**
  String headingLabel(Object deg);

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get timeRemaining;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressLabel;

  /// No description provided for @favoritesCount.
  ///
  /// In en, this message translates to:
  /// **'Favorites ({count})'**
  String favoritesCount(Object count);

  /// No description provided for @favoritesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesScreenTitle;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get noFavorites;

  /// No description provided for @prayerForecast.
  ///
  /// In en, this message translates to:
  /// **'Prayer times (next {days} days)'**
  String prayerForecast(Object days);

  /// No description provided for @calibrationHint.
  ///
  /// In en, this message translates to:
  /// **'Move phone in a figure-8 to calibrate if needed'**
  String get calibrationHint;

  /// No description provided for @qrToggleTr.
  ///
  /// In en, this message translates to:
  /// **'Toggle translation'**
  String get qrToggleTr;

  /// No description provided for @qrToggleTrans.
  ///
  /// In en, this message translates to:
  /// **'Toggle transliteration'**
  String get qrToggleTrans;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get continueReading;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get bookmark;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @viewMushaf.
  ///
  /// In en, this message translates to:
  /// **'Mushaf view'**
  String get viewMushaf;

  /// No description provided for @viewTiles.
  ///
  /// In en, this message translates to:
  /// **'Tile view'**
  String get viewTiles;

  /// No description provided for @hadithCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith Collections'**
  String get hadithCollectionsTitle;

  /// No description provided for @fortiesCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Forty Hadith'**
  String get fortiesCollectionsTitle;

  /// No description provided for @collectionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String collectionLoadError(Object error);

  /// No description provided for @collectionEntriesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load entries: {error}'**
  String collectionEntriesLoadError(Object error);

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No collections available.'**
  String get collectionEmpty;

  /// No description provided for @collectionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Collection not found.'**
  String get collectionNotFound;

  /// No description provided for @collectionSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search narrations'**
  String get collectionSearchHint;

  /// No description provided for @collectionNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries match your search.'**
  String get collectionNoEntries;

  /// No description provided for @collectionNarrationsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} narrations'**
  String collectionNarrationsLabel(Object count);

  /// No description provided for @collectionChaptersLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} chapters'**
  String collectionChaptersLabel(Object count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
