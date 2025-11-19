import 'package:shared_preferences/shared_preferences.dart';

class CollectionFavoritesStore {
  CollectionFavoritesStore._(this._prefs, Set<String> keys) : _favorites = keys;

  static const _prefsKey = 'collection_favorites';
  static CollectionFavoritesStore? _instance;

  final SharedPreferences _prefs;
  final Set<String> _favorites;

  static Future<CollectionFavoritesStore> getInstance() async {
    if (_instance != null) return _instance!;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? <String>[];
    final store = CollectionFavoritesStore._(prefs, stored.toSet());
    _instance = store;
    return store;
  }

  bool isFavorite(String key) => _favorites.contains(key);

  Set<String> get keys => Set.unmodifiable(_favorites);

  Future<void> toggle(String key) async {
    if (_favorites.contains(key)) {
      _favorites.remove(key);
    } else {
      _favorites.add(key);
    }
    await _prefs.setStringList(_prefsKey, _favorites.toList());
  }
}

String collectionFavoriteKey(String collectionId, int entryId) =>
    '$collectionId:$entryId';
