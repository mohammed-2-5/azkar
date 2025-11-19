import 'package:azkar/ui/widgets/decorated_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/core/telemetry/telemetry_cubit.dart';

import '../cubit/azkar_cubit.dart';
import '../cubit/azkar_state.dart';
import '../../data/models/azkar_item.dart';
import '../widgets/azkar_header.dart';
import '../widgets/azkar_filters.dart';
import '../widgets/azkar_card.dart';
import '../widgets/azkar_detail_sheet.dart';
import 'azkar_favorites_page.dart';

class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  @override
  void initState() {
    super.initState();
    context.read<AzkarCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DecoratedBackgroundFill(),
          BlocBuilder<AzkarCubit, AzkarState>(
            builder: (context, state) {
              if (state.status == AzkarStatus.loading ||
                  state.status == AzkarStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == AzkarStatus.error) {
                return Center(child: Text(state.error ?? 'Error'));
              }
              final l10n = AppLocalizations.of(context)!;
              final sections = state.filteredByCategory.entries.toList();
              final hasResults = sections.isNotEmpty;
              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: AzkarHeader()),
                  SliverToBoxAdapter(child: AzkarFilters(state: state)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: _AzkarSummary(state: state),
                    ),
                  ),
                  if (!hasResults)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Text(
                          l10n.azkarNoResults,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                        final entry = sections[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: _AzkarSection(
                            title: _localizedCategory(l10n, entry.key),
                            items: entry.value,
                            state: state,
                          ),
                        );
                      },
                      childCount: sections.length,
                    ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AzkarSection extends StatelessWidget {
  const _AzkarSection({
    required this.title,
    required this.items,
    required this.state,
  });

  final String title;
  final List<AzkarItem> items;
  final AzkarState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            for (final item in items) ...[
              Builder(
                builder: (context) {
                  return AzkarCard(
                    item: item,
                    favorite: state.favorites.contains(item.id),
                    remaining: state.progressRemaining[item.id] ?? item.repeat,
                    onFavorite: () {
                      context.read<AzkarCubit>().toggleFavorite(item.id);
                      context.read<TelemetryCubit>().logEvent(
                        'azkar_favorite_toggle',
                        {
                          'id': item.id,
                          'category': item.category,
                          'favorite':
                              (!state.favorites.contains(item.id)).toString(),
                        },
                      );
                    },
                    onOpen: () => showAzkarDetailSheet(
                      context,
                      item,
                      state.progressRemaining[item.id] ?? item.repeat,
                    ),
                  );
                },
              ),
              if (item != items.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ],
    );
  }
}

String _localizedCategory(AppLocalizations l10n, String key) {
  switch (key) {
    case 'Morning':
      return l10n.catMorning;
    case 'Evening':
      return l10n.catEvening;
    case 'After Prayer':
      return l10n.catAfterPrayer;
    case 'Sleep':
      return l10n.catSleep;
    case 'Doaa':
      return l10n.catDoaa;
    default:
      return key;
  }
}

class _AzkarSummary extends StatelessWidget {
  const _AzkarSummary({required this.state});
  final AzkarState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = state.items;
    final total = items.fold<int>(0, (sum, item) => sum + item.repeat);
    final completed = items.fold<int>(0, (sum, item) {
      final remaining = state.progressRemaining[item.id] ?? item.repeat;
      return sum + (item.repeat - remaining.clamp(0, item.repeat));
    });
    final favoritesCount = state.favorites.length;
    return Row(
      children: [
        Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.07),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.progressLabel, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text(
                  '$completed / $total',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: total == 0 ? 0 : (completed / total).clamp(0, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AzkarCubit>(),
                    child: const AzkarFavoritesPage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            label: Text(l10n.favoritesCount(favoritesCount)),
          ),
        ),
      ],
    );
  }
}
