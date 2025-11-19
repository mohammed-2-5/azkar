import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/text_collection_summary.dart';
import '../../../shared/pages/collection_reader_page.dart';
import '../../data/forties_repository.dart';

class FortiesReaderPage extends StatefulWidget {
  const FortiesReaderPage({
    super.key,
    required this.collectionId,
    this.initialSummary,
  });

  final String collectionId;
  final TextCollectionSummary? initialSummary;

  @override
  State<FortiesReaderPage> createState() => _FortiesReaderPageState();
}

class _FortiesReaderPageState extends State<FortiesReaderPage> {
  final _repository = FortiesRepository();
  TextCollectionSummary? _summary;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _summary = widget.initialSummary;
    if (_summary == null) {
      _loadSummary();
    }
  }

  Future<void> _loadSummary() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context)!;
    try {
      final summary = await _repository.loadSummaryById(widget.collectionId);
      if (!mounted) return;
      if (summary == null) {
        setState(() {
          _error = l10n.collectionNotFound;
          _loading = false;
        });
      } else {
        setState(() {
          _summary = summary;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = l10n.collectionLoadError(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_summary != null) {
      return CollectionReaderPage(
        summary: _summary!,
        loadEntries: () => _repository.loadEntries(_summary!),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.fortiesCollectionsTitle)),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Text(_error ?? l10n.collectionNotFound),
      ),
    );
  }
}
