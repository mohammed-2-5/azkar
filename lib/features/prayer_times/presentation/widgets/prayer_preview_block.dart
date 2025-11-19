import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/format.dart';
import '../../domain/calculation_prefs.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/cubit/prayer_times_state.dart';
import 'calculation_labels.dart';
import 'time_format.dart';

class PrayerPreviewBlock extends StatelessWidget {
  const PrayerPreviewBlock({
    super.key,
    required this.prefs,
    required this.dayCount,
  });

  final CalculationPrefs prefs;
  final int dayCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = context.read<PrayerTimesCubit>().previewDays(
      dayCount,
      overridePrefs: prefs,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.previewTitle(dayCount),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        PrayerPreviewList(
          days: days,
          use24h: prefs.use24h,
          emptyLabel: l10n.previewUnavailable,
        ),
      ],
    );
  }
}

class PrayerPreviewList extends StatelessWidget {
  const PrayerPreviewList({
    super.key,
    required this.days,
    required this.use24h,
    required this.emptyLabel,
  });

  final List<DailyPrayerTimes> days;
  final bool use24h;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(emptyLabel, style: Theme.of(context).textTheme.bodySmall),
      );
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    final format = DateFormat.MMMd(locale);
    return Column(
      children: [
        for (final day in days)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedDigits(context, format.format(day.date)),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: day.times.entries
                        .map(
                          (entry) => PrayerPreviewEntry(
                            prayerKey: entry.key,
                            time: entry.value,
                            use24h: use24h,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class PrayerPreviewEntry extends StatelessWidget {
  const PrayerPreviewEntry({
    super.key,
    required this.prayerKey,
    required this.time,
    required this.use24h,
  });

  final String prayerKey;
  final DateTime time;
  final bool use24h;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizedPrayerName(l10n, prayerKey),
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            formatTimeOfDay(context, time, use24h: use24h),
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
