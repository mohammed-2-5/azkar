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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
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

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Needed'**
  String get permissionTitle;

  /// No description provided for @permissionAcquiring.
  ///
  /// In en, this message translates to:
  /// **'Acquiring your current location...'**
  String get permissionAcquiring;

  /// No description provided for @permissionGps.
  ///
  /// In en, this message translates to:
  /// **'Turn on Location Services (GPS) to continue.'**
  String get permissionGps;

  /// No description provided for @permissionWhy.
  ///
  /// In en, this message translates to:
  /// **'We use your location to compute accurate prayer times and Qiblah direction.'**
  String get permissionWhy;

  /// No description provided for @permissionLocationError.
  ///
  /// In en, this message translates to:
  /// **'Unable to acquire location. Ensure GPS is on and try again.'**
  String get permissionLocationError;

  /// No description provided for @permissionGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get permissionGrant;

  /// No description provided for @permissionGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get permissionGetLocation;

  /// No description provided for @permissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permissionOpenSettings;

  /// No description provided for @permissionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get permissionRetry;

  /// No description provided for @appearanceThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get appearanceThemeMode;

  /// No description provided for @appearanceModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceModeSystem;

  /// No description provided for @appearanceModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceModeLight;

  /// No description provided for @appearanceModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceModeDark;

  /// No description provided for @appearanceColorDarkGrey.
  ///
  /// In en, this message translates to:
  /// **'Dark Grey'**
  String get appearanceColorDarkGrey;

  /// No description provided for @appearanceColorEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get appearanceColorEmerald;

  /// No description provided for @appearanceColorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get appearanceColorTeal;

  /// No description provided for @appearanceColorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get appearanceColorIndigo;

  /// No description provided for @appearanceColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get appearanceColorPurple;

  /// No description provided for @appearanceColorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get appearanceColorAmber;

  /// No description provided for @appearanceColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get appearanceColorPink;

  /// No description provided for @appearanceColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get appearanceColorBrown;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @prayerSettingsOpenNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get prayerSettingsOpenNotifications;

  /// No description provided for @notificationsSaved.
  ///
  /// In en, this message translates to:
  /// **'Notification settings saved'**
  String get notificationsSaved;

  /// No description provided for @notificationsTestScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Scheduled'**
  String get notificationsTestScheduledTitle;

  /// No description provided for @notificationsTestScheduledBody.
  ///
  /// In en, this message translates to:
  /// **'Notification and sound will play in 15 seconds.'**
  String get notificationsTestScheduledBody;

  /// No description provided for @notificationsTestScheduledSnack.
  ///
  /// In en, this message translates to:
  /// **'Test scheduled! You should see a notification and hear the adhan in 15 seconds.'**
  String get notificationsTestScheduledSnack;

  /// No description provided for @notificationsButtonTestScheduled.
  ///
  /// In en, this message translates to:
  /// **'Test adhan notification (15s)'**
  String get notificationsButtonTestScheduled;

  /// No description provided for @notificationsInstantTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant Test'**
  String get notificationsInstantTitle;

  /// No description provided for @notificationsInstantBody.
  ///
  /// In en, this message translates to:
  /// **'If you see this, basic notifications work!'**
  String get notificationsInstantBody;

  /// No description provided for @notificationsInstantSnack.
  ///
  /// In en, this message translates to:
  /// **'Instant notification sent (no sound test).'**
  String get notificationsInstantSnack;

  /// No description provided for @notificationsButtonInstant.
  ///
  /// In en, this message translates to:
  /// **'Test instant notification (now)'**
  String get notificationsButtonInstant;

  /// No description provided for @notificationsSoundPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing sound directly (no notification).'**
  String get notificationsSoundPlaying;

  /// No description provided for @notificationsSoundSelectVoice.
  ///
  /// In en, this message translates to:
  /// **'Select a custom adhan voice first.'**
  String get notificationsSoundSelectVoice;

  /// No description provided for @notificationsSoundFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to play: {error}'**
  String notificationsSoundFailed(Object error);

  /// No description provided for @notificationsButtonSoundOnly.
  ///
  /// In en, this message translates to:
  /// **'Test sound only (no notification)'**
  String get notificationsButtonSoundOnly;

  /// No description provided for @notificationsPreviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'System sound cannot be previewed.'**
  String get notificationsPreviewUnavailable;

  /// No description provided for @notificationsPreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Preview failed: {error}'**
  String notificationsPreviewFailed(Object error);

  /// No description provided for @notificationsVoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Adhan voice'**
  String get notificationsVoiceLabel;

  /// No description provided for @notificationsPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get notificationsPreview;

  /// No description provided for @notificationsStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get notificationsStop;

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
  /// **'Mute reminders within the selected window.'**
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

  /// No description provided for @quietClear.
  ///
  /// In en, this message translates to:
  /// **'Clear quiet hours'**
  String get quietClear;

  /// No description provided for @quietOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get quietOff;

  /// No description provided for @snoozeLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snoozeLabel;

  /// No description provided for @snoozeInfo.
  ///
  /// In en, this message translates to:
  /// **'Schedule a secondary reminder a few minutes later.'**
  String get snoozeInfo;

  /// No description provided for @snoozeMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze duration'**
  String get snoozeMinutesLabel;

  /// No description provided for @telemetryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get telemetryTitle;

  /// No description provided for @telemetryEnabledBody.
  ///
  /// In en, this message translates to:
  /// **'Telemetry captures anonymized events and errors to help troubleshoot issues. Logs stay on your device unless you share them.'**
  String get telemetryEnabledBody;

  /// No description provided for @telemetryDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Telemetry is disabled. Enable it in Appearance settings to capture diagnostics.'**
  String get telemetryDisabledBody;

  /// No description provided for @telemetryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get telemetryFilterAll;

  /// No description provided for @telemetryFilterEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get telemetryFilterEvents;

  /// No description provided for @telemetryFilterErrors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get telemetryFilterErrors;

  /// No description provided for @telemetryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No logs captured yet.'**
  String get telemetryEmpty;

  /// No description provided for @telemetryEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No logs for this filter.'**
  String get telemetryEmptyFilter;

  /// No description provided for @telemetryCopyLogs.
  ///
  /// In en, this message translates to:
  /// **'Copy logs'**
  String get telemetryCopyLogs;

  /// No description provided for @telemetryClearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear logs'**
  String get telemetryClearLogs;

  /// No description provided for @telemetrySaveLogs.
  ///
  /// In en, this message translates to:
  /// **'Save file'**
  String get telemetrySaveLogs;

  /// No description provided for @telemetryCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Copied logs to clipboard'**
  String get telemetryCopySuccess;

  /// No description provided for @telemetryClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear diagnostics log?'**
  String get telemetryClearConfirmTitle;

  /// No description provided for @telemetryClearConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Logs are stored locally. Clearing will erase all captured events.'**
  String get telemetryClearConfirmBody;

  /// No description provided for @telemetryClearConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get telemetryClearConfirmCancel;

  /// No description provided for @telemetryClearConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get telemetryClearConfirmAction;

  /// No description provided for @telemetryLogCleared.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics log cleared'**
  String get telemetryLogCleared;

  /// No description provided for @telemetryNoData.
  ///
  /// In en, this message translates to:
  /// **'No additional data'**
  String get telemetryNoData;

  /// No description provided for @telemetryEntryCopied.
  ///
  /// In en, this message translates to:
  /// **'Entry copied'**
  String get telemetryEntryCopied;

  /// No description provided for @telemetrySaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved log to {path}'**
  String telemetrySaveSuccess(Object path);

  /// No description provided for @telemetrySaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save log'**
  String get telemetrySaveError;

  /// No description provided for @telemetryEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable diagnostics?'**
  String get telemetryEnableTitle;

  /// No description provided for @telemetryEnableBody.
  ///
  /// In en, this message translates to:
  /// **'Telemetry captures anonymized events and errors to help troubleshoot issues. Logs stay on your device unless you share them.'**
  String get telemetryEnableBody;

  /// No description provided for @telemetryEnableAccept.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get telemetryEnableAccept;

  /// No description provided for @telemetryEnableDecline.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get telemetryEnableDecline;

  /// No description provided for @telemetryEnabled.
  ///
  /// In en, this message translates to:
  /// **'Telemetry enabled'**
  String get telemetryEnabled;

  /// No description provided for @telemetryDisabled.
  ///
  /// In en, this message translates to:
  /// **'Telemetry disabled'**
  String get telemetryDisabled;

  /// No description provided for @appearancePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get appearancePreviewTitle;

  /// No description provided for @appearancePreviewBody.
  ///
  /// In en, this message translates to:
  /// **'See how headings and body text scale with your current settings.'**
  String get appearancePreviewBody;

  /// No description provided for @appearanceTelemetryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics logging'**
  String get appearanceTelemetryCardTitle;

  /// No description provided for @appearanceTelemetryBody.
  ///
  /// In en, this message translates to:
  /// **'Capture anonymized events to troubleshoot issues.'**
  String get appearanceTelemetryBody;

  /// No description provided for @appearanceTelemetryViewLogs.
  ///
  /// In en, this message translates to:
  /// **'View logs'**
  String get appearanceTelemetryViewLogs;

  /// No description provided for @appearanceTextScale.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get appearanceTextScale;

  /// No description provided for @appearanceTextScaleDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust the slider to change the size used across the app.'**
  String get appearanceTextScaleDescription;

  /// No description provided for @azkarNoResults.
  ///
  /// In en, this message translates to:
  /// **'No azkar match your filters.'**
  String get azkarNoResults;

  /// No description provided for @cachedLocationWarning.
  ///
  /// In en, this message translates to:
  /// **'Using cached location: {label}. Update location for best accuracy.'**
  String cachedLocationWarning(Object label);

  /// No description provided for @collectionAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get collectionAllLabel;

  /// No description provided for @collectionChaptersLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} chapters'**
  String collectionChaptersLabel(Object count);

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No collections available right now.'**
  String get collectionEmpty;

  /// No description provided for @collectionEntriesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load entries: {error}'**
  String collectionEntriesLoadError(Object error);

  /// No description provided for @collectionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load collections: {error}'**
  String collectionLoadError(Object error);

  /// No description provided for @collectionNarrationsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} narrations'**
  String collectionNarrationsLabel(Object count);

  /// No description provided for @collectionNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries to show.'**
  String get collectionNoEntries;

  /// No description provided for @collectionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Collection not found.'**
  String get collectionNotFound;

  /// No description provided for @collectionSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search this collection...'**
  String get collectionSearchHint;

  /// No description provided for @fortiesCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Forty Collections'**
  String get fortiesCollectionsTitle;

  /// No description provided for @hadithCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith Collections'**
  String get hadithCollectionsTitle;

  /// No description provided for @hubTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Essentials'**
  String get hubTitle;

  /// No description provided for @hubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Navigate between adhkar, hadith, and forty compilations.'**
  String get hubSubtitle;

  /// No description provided for @hubAzkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get hubAzkarTitle;

  /// No description provided for @hubAzkarDescription.
  ///
  /// In en, this message translates to:
  /// **'Morning and evening supplications with filters.'**
  String get hubAzkarDescription;

  /// No description provided for @hubAzkarAction.
  ///
  /// In en, this message translates to:
  /// **'Browse azkar'**
  String get hubAzkarAction;

  /// No description provided for @hubHadithTitle.
  ///
  /// In en, this message translates to:
  /// **'Hadith collections'**
  String get hubHadithTitle;

  /// No description provided for @hubHadithDescription.
  ///
  /// In en, this message translates to:
  /// **'Read curated hadith sets offline.'**
  String get hubHadithDescription;

  /// No description provided for @hubHadithAction.
  ///
  /// In en, this message translates to:
  /// **'Open hadith'**
  String get hubHadithAction;

  /// No description provided for @hubFortyTitle.
  ///
  /// In en, this message translates to:
  /// **'Forty hadith'**
  String get hubFortyTitle;

  /// No description provided for @hubFortyDescription.
  ///
  /// In en, this message translates to:
  /// **'Classic compilations of forty narrations.'**
  String get hubFortyDescription;

  /// No description provided for @hubFortyAction.
  ///
  /// In en, this message translates to:
  /// **'Open forties'**
  String get hubFortyAction;

  /// No description provided for @perPrayerLeadTitle.
  ///
  /// In en, this message translates to:
  /// **'Per-prayer lead time'**
  String get perPrayerLeadTitle;

  /// No description provided for @perPrayerLeadInfo.
  ///
  /// In en, this message translates to:
  /// **'Override the default lead time for specific prayers.'**
  String get perPrayerLeadInfo;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview (next {count} days)'**
  String previewTitle(Object count);

  /// No description provided for @previewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview unavailable for this location.'**
  String get previewUnavailable;

  /// No description provided for @qiblahAligned.
  ///
  /// In en, this message translates to:
  /// **'You\'re aligned with the Qiblah.'**
  String get qiblahAligned;

  /// No description provided for @qiblahAlignmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Alignment status'**
  String get qiblahAlignmentStatus;

  /// No description provided for @qiblahCalibrationBody.
  ///
  /// In en, this message translates to:
  /// **'Move your phone in a figure-eight pattern to calibrate the compass.'**
  String get qiblahCalibrationBody;

  /// No description provided for @qiblahCalibrationTips.
  ///
  /// In en, this message translates to:
  /// **'Calibration tips'**
  String get qiblahCalibrationTips;

  /// No description provided for @qiblahRotateLeft.
  ///
  /// In en, this message translates to:
  /// **'Rotate left by {deg}°'**
  String qiblahRotateLeft(Object deg);

  /// No description provided for @qiblahRotateRight.
  ///
  /// In en, this message translates to:
  /// **'Rotate right by {deg}°'**
  String qiblahRotateRight(Object deg);

  /// No description provided for @snoozeAction.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snoozeAction;

  /// No description provided for @snoozeScheduled.
  ///
  /// In en, this message translates to:
  /// **'Reminder snoozed for {minutes} minutes.'**
  String snoozeScheduled(Object minutes);

  /// No description provided for @snoozeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Snooze isn\'t available for this prayer.'**
  String get snoozeUnavailable;

  /// No description provided for @timezoneWarning.
  ///
  /// In en, this message translates to:
  /// **'Device timezone differs from the calculation timezone. Check Settings.'**
  String get timezoneWarning;

  /// No description provided for @unknownDate.
  ///
  /// In en, this message translates to:
  /// **'Unknown date'**
  String get unknownDate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
