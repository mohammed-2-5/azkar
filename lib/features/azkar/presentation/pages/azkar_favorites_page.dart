import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/core/telemetry/telemetry_cubit.dart';

import '../cubit/azkar_cubit.dart';
import '../cubit/azkar_state.dart';
import '../widgets/azkar_card.dart';
import '../widgets/azkar_detail_sheet.dart';

class AzkarFavoritesPage extends StatelessWidget {
  const AzkarFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesScreenTitle)),
      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (context, state) {
          final favIds = state.favorites;
          final items = state.byCategory.values.expand((list) => list).where(
                (item) => favIds.contains(item.id),
              );
          final favorites = items.toList();
          if (favorites.isEmpty) {
            return Center(child: Text(l10n.noFavorites));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = favorites[index];
              final remaining =
                  state.progressRemaining[item.id] ?? item.repeat;
              return AzkarCard(
                item: item,
                favorite: true,
                remaining: remaining,
                onFavorite: () {
                  context.read<AzkarCubit>().toggleFavorite(item.id);
                  context.read<TelemetryCubit>().logEvent(
                    'azkar_favorite_toggle',
                    {
                      'id': item.id,
                      'category': item.category,
                      'favorite': 'false',
                    },
                  );
                },
                onOpen: () =>
                    showAzkarDetailSheet(context, item, remaining),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: favorites.length,
          );
        },
      ),
    );
  }
}
