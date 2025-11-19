import 'dart:async';

import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../core/i18n/format.dart';
import '../../../../ui/widgets/decorated_header.dart';
import '../cubit/prayer_times_state.dart';
import '../widgets/prayer_header_boxes.dart';
import '../widgets/time_format.dart';
import 'calculation_labels.dart';

class PrayerHeader extends StatefulWidget {
  const PrayerHeader({super.key, required this.state});
  final PrayerTimesState state;

  @override
  State<PrayerHeader> createState() => _PrayerHeaderState();
}

class _PrayerHeaderState extends State<PrayerHeader> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nextNameKey = widget.state.nextPrayerName ?? '';
    final nextTime = widget.state.nextPrayerTime;
    final now = DateTime.now();
    final remaining = nextTime != null
        ? nextTime.difference(now)
        : Duration.zero;

    String hijri = '';
    try {
      final h = HijriCalendar.now();
      hijri = '${h.hDay} ${h.longMonthName} ${h.hYear}';
    } catch (_) {}

    return DecoratedHeader(
      height: 300,
      title: '',
      subtitle: '',
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        LocationBox(
                          title:
                              widget.state.locationName ?? l10n.currentLocation,
                          subtitle: hijri.isNotEmpty
                              ? l10n.todayHijri(hijri)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: NextPrayerBox(
                            timeText: nextTime == null
                                ? '--:--'
                                : localizedDigits(
                                    context,
                                    formatTimeOfDay(
                                      context,
                                      nextTime,
                                      use24h: widget.state.prefs.use24h,
                                    ),
                                  ),
                            remainingText: localizedDigits(
                              context,
                              humanizeDuration(remaining),
                            ),
                            label: l10n.next,
                            prayerName: localizedPrayerName(l10n, nextNameKey),
                            remainingLabel: l10n.timeRemaining,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: ActionRow(state: widget.state)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
