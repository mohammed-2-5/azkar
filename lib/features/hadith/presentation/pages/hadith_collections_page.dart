import 'package:azkar/features/shared/widgets/collection_card.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/text_collection_summary.dart';
import '../../data/hadith_collections_repository.dart';

class HadithCollectionsPage extends StatefulWidget {
  const HadithCollectionsPage({super.key});

  @override
  State<HadithCollectionsPage> createState() => _HadithCollectionsPageState();
}

class _HadithCollectionsPageState extends State<HadithCollectionsPage> {
  late final Future<List<TextCollectionSummary>> _collections;
  final _repository = HadithCollectionsRepository();

  @override
  void initState() {
    super.initState();
    _collections = _repository.loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.hadithCollectionsTitle)),
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
                '/azkar/hadith/${data[index].id}',
                extra: data[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
