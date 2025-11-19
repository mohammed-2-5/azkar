import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/services.dart' show rootBundle;

import 'models/azkar_item.dart';

class _AzkarSource {
  const _AzkarSource({
    required this.category,
    required this.asset,
    this.idPrefix,
  });

  final String category;
  final String asset;
  final String? idPrefix;
}

class AzkarRepository {
  static const List<_AzkarSource> _sources = [
    _AzkarSource(category: 'Morning', asset: 'assets/azkar/azkar-sabah.json'),
    _AzkarSource(category: 'Evening', asset: 'assets/azkar/azkar-masaa.json'),
    _AzkarSource(
      category: 'After Prayer',
      asset: 'assets/azkar/after_prayer.json',
    ),
    _AzkarSource(category: 'Sleep', asset: 'assets/azkar/sleep.json'),
    _AzkarSource(
      category: 'Morning',
      asset: 'assets/azkar/morning_evening.json',
      idPrefix: 'morning',
    ),
    _AzkarSource(
      category: 'Evening',
      asset: 'assets/azkar/morning_evening.json',
      idPrefix: 'evening',
    ),
    _AzkarSource(
      category: 'Doaa',
      asset: 'assets/azkar/doaa-for-dead-person.json',
    ),
    _AzkarSource(
      category: 'Doaa',
      asset: 'assets/azkar/doaa-for-all-death-people.json',
    ),
  ];

  Future<Map<String, List<AzkarItem>>> loadAll() async {
    final result = LinkedHashMap<String, List<AzkarItem>>();

    for (final source in _sources) {
      try {
        final items = await _loadSource(source);
        if (items.isEmpty) continue;
        result.putIfAbsent(source.category, () => []).addAll(items);
      } catch (e, st) {
        dev.log(
          'Failed to load ${source.asset}',
          error: e,
          stackTrace: st,
          name: 'azkar.repo',
        );
      }
    }

    return result;
  }

  Future<List<AzkarItem>> _loadSource(_AzkarSource source) async {
    final raw = await rootBundle.loadString(source.asset);
    Iterable<Map<String, dynamic>> list =
        (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    if (source.idPrefix != null) {
      list = list.where((entry) {
        final id = entry['id'] as String?;
        return id != null && id.startsWith(source.idPrefix!);
      });
    }
    return list.map((json) => _mapToItem(json, source)).toList(growable: false);
  }

  AzkarItem _mapToItem(Map<String, dynamic> json, _AzkarSource source) {
    final repeat = _readRepeat(json);
    final id = (json['id'] as String?) ?? _buildId(source, json);

    if (json.containsKey('content')) {
      final content = (json['content'] as String? ?? '').trim();
      final title = (json['title'] as String?)?.trim();
      return AzkarItem(
        id: id,
        title: title?.isNotEmpty == true ? title! : _preview(content),
        content: content,
        repeat: repeat,
        category: source.category,
      );
    }

    final zekr = (json['zekr'] as String? ?? '').trim();
    final bless = (json['bless'] as String?)?.trim();
    final combined = (bless?.isNotEmpty ?? false) ? '$zekr\n\n$bless' : zekr;
    final title = (json['title'] as String?)?.trim();
    return AzkarItem(
      id: id,
      title: title?.isNotEmpty == true ? title! : _preview(zekr),
      content: combined,
      repeat: repeat,
      category: source.category,
    );
  }

  int _readRepeat(Map<String, dynamic> json) {
    final raw = json['repeat'];
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw) ?? 1;
    return 1;
  }

  String _buildId(_AzkarSource source, Map<String, dynamic> json) {
    final candidate = (json['title'] ?? json['zekr'] ?? source.category)
        .toString();
    final hash = candidate.hashCode.toUnsigned(32).toRadixString(16);
    final prefix = source.category.replaceAll(' ', '_').toLowerCase();
    return '${prefix}_$hash';
  }

  String _preview(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 'أذكار';
    const max = 48;
    return trimmed.length <= max ? trimmed : '${trimmed.substring(0, max)}…';
  }
}
