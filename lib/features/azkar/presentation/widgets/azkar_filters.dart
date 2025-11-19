import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/l10n/app_localizations.dart';

import '../../presentation/cubit/azkar_cubit.dart';
import '../../presentation/cubit/azkar_state.dart';

class AzkarFilters extends StatelessWidget {
  const AzkarFilters({super.key, required this.state});
  final AzkarState state;

  static const _icons = {
    'Morning': Icons.wb_sunny_outlined,
    'Evening': Icons.nightlight_round,
    'After Prayer': Icons.mosque_outlined,
    'Sleep': Icons.nights_stay_outlined,
    'Doaa': Icons.favorite_border,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = state.byCategory.keys.toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = state.selectedCategory == category;
              final count = state.byCategory[category]?.length ?? 0;
              return GestureDetector(
                onTap: () => context.read<AzkarCubit>().selectCategory(category),
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: selected
                          ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                          : const [Color(0x331E293B), Color(0x221E293B)],
                    ),
                    border: Border.all(
                      color: selected ? Colors.white70 : Colors.white30,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Icon(_icons[category] ?? Icons.auto_awesome, color: Colors.white),
                          Text(
                            _localized(l10n, category),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            '$count',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: l10n.searchDuas,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => context.read<AzkarCubit>().setSearchQuery(v),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(l10n.favorites),
                selected: state.showFavoritesOnly,
                onSelected: (v) => context.read<AzkarCubit>().setShowFavorites(v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _localized(AppLocalizations l10n, String key) {
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
}
