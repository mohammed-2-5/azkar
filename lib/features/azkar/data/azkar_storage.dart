import 'package:hive_flutter/hive_flutter.dart';

class AzkarStorage {
  static const _favBox = 'azkar_fav';
  static const _progressBox = 'azkar_progress'; // key: yyyymmdd -> Map<String,int>

  Future<Box> _open(String name) async => Hive.isBoxOpen(name) ? Hive.box(name) : Hive.openBox(name);

  Future<Set<String>> getFavorites() async {
    final box = await _open(_favBox);
    final list = (box.get('fav', defaultValue: <String>[]) as List).cast<String>();
    return Set<String>.from(list);
  }

  Future<void> toggleFavorite(String id) async {
    final box = await _open(_favBox);
    final set = Set<String>.from(((box.get('fav', defaultValue: <String>[]) as List).cast<String>()));
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    await box.put('fav', set.toList());
  }

  String _todayKey() {
    final d = DateTime.now();
    return '${d.year.toString().padLeft(4, '0')}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
  }

  Future<Map<String, int>> getTodayProgress() async {
    final box = await _open(_progressBox);
    final key = _todayKey();
    final map = (box.get(key, defaultValue: <String, int>{}) as Map).cast<String, int>();
    return Map<String, int>.from(map);
  }

  Future<void> setTodayProgress(Map<String, int> progress) async {
    final box = await _open(_progressBox);
    final key = _todayKey();
    await box.put(key, progress);
  }
}

