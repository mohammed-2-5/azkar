import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/services.dart' show rootBundle;

import 'models/surah.dart';
import 'models/ayah.dart';

class QuranRepository {
  final Map<int, Surah> _surahCache = {};
  final Map<int, List<Ayah>> _ayahCache = {};

  Future<Surah> loadSurahHeader(int id) async {
    if (_surahCache.containsKey(id)) return _surahCache[id]!;
    Map<String, dynamic> jsonMap;
    try {
      final data = await rootBundle.loadString(
        'assets/quran/chapters/en/$id.json',
      );
      jsonMap = json.decode(data) as Map<String, dynamic>;
      dev.log('Loaded EN header for surah $id', name: 'quran.repo');
    } catch (_) {
      // Fallback to Arabic header if EN not present
      final data = await rootBundle.loadString(
        'assets/quran/chapters/ar/$id.json',
      );
      jsonMap = json.decode(data) as Map<String, dynamic>;
      dev.log('Loaded AR header fallback for surah $id', name: 'quran.repo');
    }
    final surah = Surah.fromChapterJson(jsonMap);
    _surahCache[id] = surah;
    return surah;
  }

  Future<List<Surah>> loadAllSurahHeaders() async {
    final List<Surah> result = [];
    for (int i = 1; i <= 114; i++) {
      result.add(await loadSurahHeader(i));
    }
    return result;
  }

  Future<List<Ayah>> loadSurahAyat(int id) async {
    if (_ayahCache.containsKey(id)) return _ayahCache[id]!;
    final arData = await rootBundle.loadString(
      'assets/quran/chapters/ar/$id.json',
    );
    Map<String, dynamic>? enMap;
    try {
      final enData = await rootBundle.loadString(
        'assets/quran/chapters/en/$id.json',
      );
      enMap = json.decode(enData) as Map<String, dynamic>;
      dev.log('Loaded EN verses for surah $id', name: 'quran.repo');
    } catch (_) {
      enMap = null; // fallback to Arabic only
      dev.log(
        'No EN verses for surah $id, using AR only',
        level: 800,
        name: 'quran.repo',
      );
    }
    final arMap = json.decode(arData) as Map<String, dynamic>;
    final arVerses = (arMap['verses'] as List).cast<Map<String, dynamic>>();
    final enVerses = enMap == null
        ? const <Map<String, dynamic>>[]
        : (enMap['verses'] as List).cast<Map<String, dynamic>>();
    final List<Ayah> ayat = [];
    for (int i = 0; i < arVerses.length; i++) {
      final ar = arVerses[i];
      final en = i < enVerses.length ? enVerses[i] : const {};
      ayat.add(
        Ayah(
          id: (ar['id'] ?? (i + 1)) as int,
          textAr: (ar['text'] ?? '') as String,
          transliteration:
              (en['transliteration'] ?? ar['transliteration']) as String?,
          translationEn: en['translation'] as String?,
        ),
      );
    }
    _ayahCache[id] = ayat;
    dev.log('Prepared ${ayat.length} ayat for surah $id', name: 'quran.repo');
    return ayat;
  }
}
