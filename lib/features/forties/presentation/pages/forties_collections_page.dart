import 'package:azkar/features/shared/widgets/collection_card.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/text_collection_summary.dart';
import '../../data/forties_repository.dart';

class FortiesCollectionsPage extends StatefulWidget {
  const FortiesCollectionsPage({super.key});

  @override
  State<FortiesCollectionsPage> createState() => _FortiesCollectionsPageState();
}

class _FortiesCollectionsPageState extends State<FortiesCollectionsPage> {
  late final Future<List<TextCollectionSummary>> _collections;
  final _repository = FortiesRepository();

  @override
  void initState() {
    super.initState();
    _collections = _repository.loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.fortiesCollectionsTitle)),
      body: FutureBuilder<List<TextCollectionSummary>>(
        future: _collections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final errorText =
                snapshot.error?.toString() ?? l10n.collectionNotFound;
            return Center(child: Text(l10n.collectionLoadError(errorText)));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return Center(child: Text(l10n.collectionEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => CollectionCard(
              summary: data[index],
              onTap: () => context.push(
                '/azkar/forties/${data[index].id}',
                extra: data[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
