import 'dart:ui';

import 'package:flutter/material.dart';

import '../../presentation/widgets/prayer_settings_sheet.dart';
import '../../../../core/theme/locale_cubit.dart';
import '../../../../core/theme/locale_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/l10n/app_localizations.dart';

import '../cubit/prayer_times_cubit.dart';
import '../cubit/prayer_times_state.dart';

class LocationBox extends StatelessWidget {
  const LocationBox({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return _GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }
}

class NextPrayerBox extends StatelessWidget {
  const NextPrayerBox({
    super.key,
    required this.timeText,
    required this.remainingText,
    required this.prayerName,
    required this.label,
    required this.remainingLabel,
  });

  final String timeText;
  final String remainingText;
  final String prayerName;
  final String label;
  final String remainingLabel;

  @override
  Widget build(BuildContext context) {
    return _GlassContainer(
      child: Row(
        children: [
          Column(
               spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label • $prayerName',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                  Text(
                    timeText,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    remainingLabel,
                    style: const TextStyle(color: Colors.white70,fontSize: 12),
                  ),
                  Text(
                    remainingText,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionRow extends StatelessWidget {
  const ActionRow({super.key, required this.state});
  final PrayerTimesState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _GlassContainer(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          Builder(
            builder: (context) {
              final canSnooze =
                  state.nextPrayerName != null && state.nextPrayerTime != null;
              return FilledButton.tonalIcon(
                icon: const Icon(Icons.snooze),
                onPressed: !canSnooze
                    ? null
                    : () async {
                        final minutes = await context
                            .read<PrayerTimesCubit>()
                            .snoozeNextPrayer();
                        final text = minutes == null
                            ? l10n.snoozeUnavailable
                            : l10n.snoozeScheduled(minutes);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(text)),
                        );
                      },
                label: Text(l10n.snoozeAction),
              );
            },
          ),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () => context.go('/notifications'),
            label: Text(l10n.notifications),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.settings_suggest_outlined),
            onPressed: () => showPrayerSettingsSheet(context, state.prefs),
            label: Text(l10n.settings),
          ),
          IconButton.filledTonal(
            onPressed: () => context.go('/appearance'),
            icon: const Icon(Icons.palette_outlined),
          ),
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, locState) {
              final lang = (locState.locale?.languageCode ??
                  Localizations.localeOf(context).languageCode);
              final isAr = lang == 'ar';
              return IconButton.filledTonal(
                onPressed: () {
                  final next = isAr ? const Locale('en') : const Locale('ar');
                  context.read<LocaleCubit>().setLocale(next);
                },
                icon: const Icon(Icons.language),
                tooltip: isAr ? 'EN' : 'AR',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  const _GlassContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        gradient: const LinearGradient(
          colors: [
            Color(0x660F172A),
            Color(0x330F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
