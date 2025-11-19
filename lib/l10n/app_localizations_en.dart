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
  String get azkarTitle => 'Azkar';

  @override
  String get qiblahTitle => 'Qiblah';

  @override
  String get qiblahSubtitle => 'Find the Kaaba direction';

  @override
  String get language => 'Language';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get save => 'Save';

  @override
  String get rescheduleNow => 'Reschedule Now';

  @override
  String get chooseCityTitle => 'Choose City';

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
  String get calibrationHint => 'Move phone in a figure-8 to calibrate if needed';

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
  String get permissionTitle => 'Location Permission Needed';

  @override
  String get permissionAcquiring => 'Acquiring your current location...';

  @override
  String get permissionGps => 'Turn on Location Services (GPS) to continue.';

  @override
  String get permissionWhy => 'We use your location to compute accurate prayer times and Qiblah direction.';

  @override
  String get permissionLocationError => 'Unable to acquire location. Ensure GPS is on and try again.';

  @override
  String get permissionGrant => 'Grant Permission';

  @override
  String get permissionGetLocation => 'Get Current Location';

  @override
  String get permissionOpenSettings => 'Open Settings';

  @override
  String get permissionRetry => 'Retry';

  @override
  String get appearanceThemeMode => 'Theme mode';

  @override
  String get appearanceModeSystem => 'System';

  @override
  String get appearanceModeLight => 'Light';

  @override
  String get appearanceModeDark => 'Dark';

  @override
  String get appearanceColorDarkGrey => 'Dark Grey';

  @override
  String get appearanceColorEmerald => 'Emerald';

  @override
  String get appearanceColorTeal => 'Teal';

  @override
  String get appearanceColorIndigo => 'Indigo';

  @override
  String get appearanceColorPurple => 'Purple';

  @override
  String get appearanceColorAmber => 'Amber';

  @override
  String get appearanceColorPink => 'Pink';

  @override
  String get appearanceColorBrown => 'Brown';

  @override
  String get apply => 'Apply';

  @override
  String get prayerSettingsOpenNotifications => 'Notifications';

  @override
  String get notificationsSaved => 'Notification settings saved';

  @override
  String get notificationsTestScheduledTitle => 'Test Scheduled';

  @override
  String get notificationsTestScheduledBody => 'Notification and sound will play in 15 seconds.';

  @override
  String get notificationsTestScheduledSnack => 'Test scheduled! You should see a notification and hear the adhan in 15 seconds.';

  @override
  String get notificationsButtonTestScheduled => 'Test adhan notification (15s)';

  @override
  String get notificationsInstantTitle => 'Instant Test';

  @override
  String get notificationsInstantBody => 'If you see this, basic notifications work!';

  @override
  String get notificationsInstantSnack => 'Instant notification sent (no sound test).';

  @override
  String get notificationsButtonInstant => 'Test instant notification (now)';

  @override
  String get notificationsSoundPlaying => 'Playing sound directly (no notification).';

  @override
  String get notificationsSoundSelectVoice => 'Select a custom adhan voice first.';

  @override
  String notificationsSoundFailed(Object error) {
    return 'Failed to play: $error';
  }

  @override
  String get notificationsButtonSoundOnly => 'Test sound only (no notification)';

  @override
  String get notificationsPreviewUnavailable => 'System sound cannot be previewed.';

  @override
  String notificationsPreviewFailed(Object error) {
    return 'Preview failed: $error';
  }

  @override
  String get notificationsVoiceLabel => 'Adhan voice';

  @override
  String get notificationsPreview => 'Preview';

  @override
  String get notificationsStop => 'Stop';

  @override
  String get leadDefaultLabel => 'Use default';

  @override
  String get quietHours => 'Quiet hours';

  @override
  String get quietInfo => 'Mute reminders within the selected window.';

  @override
  String get quietStartLabel => 'Start';

  @override
  String get quietEndLabel => 'End';

  @override
  String get quietClear => 'Clear quiet hours';

  @override
  String get quietOff => 'Off';

  @override
  String get snoozeLabel => 'Snooze';

  @override
  String get snoozeInfo => 'Schedule a secondary reminder a few minutes later.';

  @override
  String get snoozeMinutesLabel => 'Snooze duration';

  @override
  String get telemetryTitle => 'Diagnostics';

  @override
  String get telemetryEnabledBody => 'Telemetry captures anonymized events and errors to help troubleshoot issues. Logs stay on your device unless you share them.';

  @override
  String get telemetryDisabledBody => 'Telemetry is disabled. Enable it in Appearance settings to capture diagnostics.';

  @override
  String get telemetryFilterAll => 'All';

  @override
  String get telemetryFilterEvents => 'Events';

  @override
  String get telemetryFilterErrors => 'Errors';

  @override
  String get telemetryEmpty => 'No logs captured yet.';

  @override
  String get telemetryEmptyFilter => 'No logs for this filter.';

  @override
  String get telemetryCopyLogs => 'Copy logs';

  @override
  String get telemetryClearLogs => 'Clear logs';

  @override
  String get telemetrySaveLogs => 'Save file';

  @override
  String get telemetryCopySuccess => 'Copied logs to clipboard';

  @override
  String get telemetryClearConfirmTitle => 'Clear diagnostics log?';

  @override
  String get telemetryClearConfirmBody => 'Logs are stored locally. Clearing will erase all captured events.';

  @override
  String get telemetryClearConfirmCancel => 'Cancel';

  @override
  String get telemetryClearConfirmAction => 'Clear';

  @override
  String get telemetryLogCleared => 'Diagnostics log cleared';

  @override
  String get telemetryNoData => 'No additional data';

  @override
  String get telemetryEntryCopied => 'Entry copied';

  @override
  String telemetrySaveSuccess(Object path) {
    return 'Saved log to $path';
  }

  @override
  String get telemetrySaveError => 'Couldn\'t save log';

  @override
  String get telemetryEnableTitle => 'Enable diagnostics?';

  @override
  String get telemetryEnableBody => 'Telemetry captures anonymized events and errors to help troubleshoot issues. Logs stay on your device unless you share them.';

  @override
  String get telemetryEnableAccept => 'Enable';

  @override
  String get telemetryEnableDecline => 'Not now';

  @override
  String get telemetryEnabled => 'Telemetry enabled';

  @override
  String get telemetryDisabled => 'Telemetry disabled';

  @override
  String get appearancePreviewTitle => 'Preview';

  @override
  String get appearancePreviewBody => 'See how headings and body text scale with your current settings.';

  @override
  String get appearanceTelemetryCardTitle => 'Diagnostics logging';

  @override
  String get appearanceTelemetryBody => 'Capture anonymized events to troubleshoot issues.';

  @override
  String get appearanceTelemetryViewLogs => 'View logs';

  @override
  String get appearanceTextScale => 'Text size';

  @override
  String get appearanceTextScaleDescription => 'Adjust the slider to change the size used across the app.';

  @override
  String get azkarNoResults => 'No azkar match your filters.';

  @override
  String cachedLocationWarning(Object label) {
    return 'Using cached location: $label. Update location for best accuracy.';
  }

  @override
  String get collectionAllLabel => 'All';

  @override
  String collectionChaptersLabel(Object count) {
    return '$count chapters';
  }

  @override
  String get collectionEmpty => 'No collections available right now.';

  @override
  String collectionEntriesLoadError(Object error) {
    return 'Couldn\'t load entries: $error';
  }

  @override
  String collectionLoadError(Object error) {
    return 'Couldn\'t load collections: $error';
  }

  @override
  String collectionNarrationsLabel(Object count) {
    return '$count narrations';
  }

  @override
  String get collectionNoEntries => 'No entries to show.';

  @override
  String get collectionNotFound => 'Collection not found.';

  @override
  String get collectionSearchHint => 'Search this collection...';

  @override
  String get fortiesCollectionsTitle => 'Forty Collections';

  @override
  String get hadithCollectionsTitle => 'Hadith Collections';

  @override
  String get hubTitle => 'Daily Essentials';

  @override
  String get hubSubtitle => 'Navigate between adhkar, hadith, and forty compilations.';

  @override
  String get hubAzkarTitle => 'Azkar';

  @override
  String get hubAzkarDescription => 'Morning and evening supplications with filters.';

  @override
  String get hubAzkarAction => 'Browse azkar';

  @override
  String get hubHadithTitle => 'Hadith collections';

  @override
  String get hubHadithDescription => 'Read curated hadith sets offline.';

  @override
  String get hubHadithAction => 'Open hadith';

  @override
  String get hubFortyTitle => 'Forty hadith';

  @override
  String get hubFortyDescription => 'Classic compilations of forty narrations.';

  @override
  String get hubFortyAction => 'Open forties';

  @override
  String get perPrayerLeadTitle => 'Per-prayer lead time';

  @override
  String get perPrayerLeadInfo => 'Override the default lead time for specific prayers.';

  @override
  String previewTitle(Object count) {
    return 'Preview (next $count days)';
  }

  @override
  String get previewUnavailable => 'Preview unavailable for this location.';

  @override
  String get qiblahAligned => 'You\'re aligned with the Qiblah.';

  @override
  String get qiblahAlignmentStatus => 'Alignment status';

  @override
  String get qiblahCalibrationBody => 'Move your phone in a figure-eight pattern to calibrate the compass.';

  @override
  String get qiblahCalibrationTips => 'Calibration tips';

  @override
  String qiblahRotateLeft(Object deg) {
    return 'Rotate left by $deg°';
  }

  @override
  String qiblahRotateRight(Object deg) {
    return 'Rotate right by $deg°';
  }

  @override
  String get snoozeAction => 'Snooze';

  @override
  String snoozeScheduled(Object minutes) {
    return 'Reminder snoozed for $minutes minutes.';
  }

  @override
  String get snoozeUnavailable => 'Snooze isn\'t available for this prayer.';

  @override
  String get timezoneWarning => 'Device timezone differs from the calculation timezone. Check Settings.';

  @override
  String get unknownDate => 'Unknown date';

  @override
  String get localeName => 'en';
}
