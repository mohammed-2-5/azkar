import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models/tafseer_entry.dart';
import '../presentation/reading/ayah_ref.dart';

class TafseerRepository {
  TafseerRepository({this.assetPath = 'assets/tafseer.json'});

  final String assetPath;
  Map<AyahRef, TafseerEntry>? _cache;

  Future<Map<AyahRef, TafseerEntry>> _loadAll() async {
    if (_cache != null) return _cache!;
    final data = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(data) as List<dynamic>;
    final Map<AyahRef, TafseerEntry> map = {};
    for (final raw in list.cast<Map<String, dynamic>>()) {
      final entry = TafseerEntry.fromJson(raw);
      map[entry.ref] = entry;
    }
    _cache = map;
    return map;
  }

  Future<TafseerEntry?> getEntry(int surah, int ayah) async {
    final map = await _loadAll();
    return map[AyahRef(surah, ayah)];
  }
}
