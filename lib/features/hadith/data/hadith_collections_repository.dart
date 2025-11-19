import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:azkar/generated/assets.gen.dart';
import '../../shared/models/text_collection_summary.dart';

class HadithCollectionsRepository {
  static final _sources = [
    _HadithSource(id: 'bukhari', asset: Assets.hadith.bukhari),
    _HadithSource(id: 'muslim', asset: Assets.hadith.muslim),
    _HadithSource(id: 'malik', asset: Assets.hadith.malik),
    _HadithSource(id: 'ahmed', asset: Assets.hadith.ahmed),
  ];

  Future<List<TextCollectionSummary>> loadCollections() async {
    final results = await Future.wait(_sources.map(_loadCollection));
    results.sort((a, b) => a.title.compareTo(b.title));
    return results;
  }

  Future<TextCollectionSummary?> loadSummaryById(String id) async {
    final source = _sources.firstWhere(
      (src) => src.id == id,
      orElse: () => _HadithSource.empty,
    );
    if (source == _HadithSource.empty) return null;
    return _loadCollection(source);
  }

  Future<List<TextCollectionEntry>> loadEntries(
    TextCollectionSummary summary,
  ) async {
    final raw = await rootBundle.loadString(summary.assetPath);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final hadiths = data['hadiths'] as List<dynamic>? ?? [];
    return hadiths.map((entry) => _mapEntry(entry)).toList(growable: false);
  }

  Future<TextCollectionSummary> _loadCollection(_HadithSource source) async {
    final raw = await rootBundle.loadString(source.asset);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final metadata = data['metadata'] as Map<String, dynamic>? ?? {};
    final english = metadata['english'] as Map<String, dynamic>? ?? {};
    final arabicMeta = metadata['arabic'] as Map<String, dynamic>? ?? {};
    final hadiths = data['hadiths'] as List<dynamic>? ?? [];
    final chapters = data['chapters'] as List<dynamic>? ?? [];
    return TextCollectionSummary(
      id: source.id,
      assetPath: source.asset,
      title: english['title'] as String? ?? source.id,
      author: english['author'] as String? ?? 'Unknown',
      introduction: english['introduction'] as String?,
      titleAr: arabicMeta['title'] as String?,
      authorAr: arabicMeta['author'] as String?,
      introductionAr: arabicMeta['introduction'] as String?,
      hadithCount: hadiths.length,
      chapterCount: chapters.length,
    );
  }

  TextCollectionEntry _mapEntry(dynamic raw) {
    final map = raw as Map<String, dynamic>? ?? {};
    final english = map['english'] as Map<String, dynamic>? ?? {};
    final arabic = (map['arabic'] as String?)?.trim() ?? '';
    final narrator = (english['narrator'] as String?)?.trim();
    final text = (english['text'] as String?)?.trim() ?? '';
    final heading = narrator?.isNotEmpty == true ? narrator! : 'Narration';
    final snippet = _buildSnippet(text);
    final search = '$heading $text $arabic'.toLowerCase();
    return TextCollectionEntry(
      entryId: map['id'] as int? ?? map['idInBook'] as int? ?? 0,
      idInBook: map['idInBook'] as int?,
      chapterId: map['chapterId'] as int?,
      title: heading,
      body: text,
      arabic: arabic,
      snippet: snippet,
      searchText: search,
      narrator: narrator,
    );
  }

  String _buildSnippet(String text) {
    final clean = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (clean.length <= 160) return clean;
    return '${clean.substring(0, 160)}…';
  }
}

class _HadithSource {
  const _HadithSource({required this.id, required this.asset});
  static const empty = _HadithSource(id: '_', asset: '');
  final String id;
  final String asset;
}
