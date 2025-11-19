import 'package:azkar/l10n/app_localizations.dart';

String buildPrayerSummaryLabel(
  AppLocalizations l10n, {
  required String prayerName,
  required String timeText,
  required String relativeText,
  bool isNext = false,
}) {
  final segments = <String>[];
  if (isNext) {
    segments.add(l10n.next);
  }
  segments.add('$prayerName $timeText');
  segments.add('${l10n.timeRemaining}: $relativeText');
  return segments.join('. ');
}

String buildDailyForecastLabel(
  AppLocalizations l10n, {
  required String dateLabel,
  required Map<String, String> localizedTimes,
}) {
  final buffer = StringBuffer(dateLabel);
  for (final entry in localizedTimes.entries) {
    buffer.write('. ${entry.key} ${entry.value}');
  }
  return buffer.toString();
}
