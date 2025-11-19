import 'dart:ui';

import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/format.dart';
import '../cubit/prayer_times_state.dart';
import 'calculation_labels.dart';
import 'ornament_painter.dart';

class PrayerTimesGrid extends StatelessWidget {
  const PrayerTimesGrid({super.key, required this.days});
  final List<DailyPrayerTimes> days;

  static const _prayerKeys = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.15),
        ),
        child: const Center(child: Text('Prayer forecast unavailable.')),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            l10n.prayerForecast(days.length),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < days.length; i++) ...[
                _DayCard(day: days[i], highlight: i == 0),
                if (i != days.length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day, required this.highlight});
  final DailyPrayerTimes day;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateLabel = localizedDigits(
      context,
      DateFormat('EEE, MMM d', locale).format(day.date),
    );
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black.withOpacity(0.25),
        border: Border.all(
          color: Colors.white.withOpacity(highlight ? 0.35 : 0.15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: CustomPaint(
            painter: OrnamentPainter(color: Colors.white.withOpacity(0.12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final prayer in PrayerTimesGrid._prayerKeys)
                    _PrayerEntry(prayer: prayer, time: day.times[prayer]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerEntry extends StatelessWidget {
  const _PrayerEntry({required this.prayer, required this.time});
  final String prayer;
  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              localizedPrayerName(l10n, prayer),
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const Spacer(),
          Text(
            time == null
                ? '--:--'
                : localizedDigits(
                    context,
                    TimeOfDay.fromDateTime(time!).format(context),
                  ),
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
