import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QuranStorage {
  static const _kLastSurah = 'q_last_surah';
  static const _kLastAyah = 'q_last_ayah';
  static const _kBookmarks = 'q_bookmarks'; // JSON list of "surah:ayah"
  static const _kLayoutMode = 'q_layout_mode'; // 'tiles' | 'mushaf'
  static const _kRecents =
      'q_recents'; // JSON list of {'s':int,'a':int,'t':int}
  static const _kMemDeck = 'q_mem_deck'; // JSON list of memorization entries
  static const _kMemProfile = 'q_mem_profile'; // JSON object for stats

  Future<(int?, int?)> getLastRead() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getInt(_kLastSurah);
    final a = sp.getInt(_kLastAyah);
    return (s, a);
  }

  Future<void> setLastRead(int surah, int ayah) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kLastSurah, surah);
    await sp.setInt(_kLastAyah, ayah);
  }

  Future<Set<String>> getBookmarks() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kBookmarks);
    if (raw == null) return {};
    final list = (json.decode(raw) as List).cast<String>();
    return list.toSet();
  }

  Future<void> setBookmarks(Set<String> keys) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kBookmarks, json.encode(keys.toList()));
  }

  Future<String> getLayoutMode() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kLayoutMode) ?? 'tiles';
  }

  Future<void> setLayoutMode(String mode) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLayoutMode, mode);
  }

  Future<List<Map<String, dynamic>>> getRecents() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kRecents);
    if (raw == null) return [];
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    return list;
  }

  Future<void> addRecent(int surah, int ayah, {int max = 5}) async {
    final sp = await SharedPreferences.getInstance();
    final list = await getRecents();
    list.removeWhere((e) => e['s'] == surah && e['a'] == ayah);
    list.insert(0, {
      's': surah,
      'a': ayah,
      't': DateTime.now().millisecondsSinceEpoch,
    });
    while (list.length > max) {
      list.removeLast();
    }
    await sp.setString(_kRecents, json.encode(list));
  }

  Future<List<Map<String, dynamic>>> getMemDeckRaw() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kMemDeck);
    if (raw == null) return [];
    return (json.decode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> setMemDeckRaw(List<Map<String, dynamic>> list) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kMemDeck, json.encode(list));
  }

  Future<Map<String, dynamic>?> getMemProfileRaw() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kMemProfile);
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  Future<void> setMemProfileRaw(Map<String, dynamic> jsonMap) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kMemProfile, json.encode(jsonMap));
  }
}
