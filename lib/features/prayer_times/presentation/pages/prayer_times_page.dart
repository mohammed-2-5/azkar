import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../ui/widgets/decorated_header.dart';
import '../cubit/prayer_times_cubit.dart';
import '../cubit/prayer_times_state.dart';
import '../widgets/calc_chips.dart';
import '../widgets/prayer_header.dart';
import '../widgets/prayer_times_grid.dart';
import '../../../../core/telemetry/telemetry_cubit.dart';
import 'package:azkar/l10n/app_localizations.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PrayerTimesCubit>().fetchToday();
    context.read<TelemetryCubit>().logEvent('screen_prayer_times');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DecoratedBackgroundFill(),
          BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
            builder: (context, state) {
              if (state.status == PrayerTimesStatus.loading ||
                  state.status == PrayerTimesStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == PrayerTimesStatus.error) {
                return Center(child: Text(state.error ?? 'Error'));
              }
              final preview =
                  context.read<PrayerTimesCubit>().previewDays(4);
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<PrayerTimesCubit>().refresh(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: PrayerHeader(state: state)),
                    if (_buildWarnings(context, state).isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: _WarningCard(
                            messages: _buildWarnings(context, state),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: CalcChips(state: state),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PrayerTimesGrid(days: preview),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<String> _buildWarnings(BuildContext context, PrayerTimesState state) {
  final l10n = AppLocalizations.of(context)!;
  final warnings = <String>[];
  if (state.staleLocation) {
    final formatter = DateFormat.yMMMd(l10n.localeName);
    final label = state.locationTimestamp != null
        ? formatter.format(state.locationTimestamp!)
        : l10n.unknownDate;
    warnings.add(l10n.cachedLocationWarning(label));
  }
  if (state.timezoneWarning) {
    warnings.add(l10n.timezoneWarning);
  }
  return warnings;
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.messages});
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    final semanticsLabel =
        messages.isNotEmpty ? messages.join('. ') : null;
    final fallback = AppLocalizations.of(context)?.timezoneWarning ?? 'Warning';
    return Semantics(
      container: true,
      label: semanticsLabel ?? fallback,
      child: Card(
        color: Colors.orange.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(height: 8),
              for (final msg in messages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    msg,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.orange.shade200),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
