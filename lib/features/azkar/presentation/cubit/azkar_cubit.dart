import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/azkar_repository.dart';
import '../../data/azkar_storage.dart';
import '../../data/models/azkar_item.dart';
import 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit(this._repo, this._storage) : super(const AzkarState());

  final AzkarRepository _repo;
  final AzkarStorage _storage;

  Future<void> load() async {
    emit(state.copyWith(status: AzkarStatus.loading));
    try {
      final map = await _repo.loadAll();
      final fav = await _storage.getFavorites();
      final prog = await _storage.getTodayProgress();
      final selected = map.containsKey(state.selectedCategory)
          ? state.selectedCategory
          : (map.keys.isNotEmpty ? map.keys.first : state.selectedCategory);
      emit(
        state.copyWith(
          status: AzkarStatus.loaded,
          byCategory: map,
          favorites: fav,
          progressRemaining: prog,
          selectedCategory: selected,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AzkarStatus.error, error: e.toString()));
    }
  }

  void selectCategory(String name) {
    emit(state.copyWith(selectedCategory: name));
  }

  Future<void> toggleFavorite(String id) async {
    await _storage.toggleFavorite(id);
    final updated = await _storage.getFavorites();
    emit(state.copyWith(favorites: updated));
  }

  Future<void> decrement(AzkarItem item) async {
    final current = Map<String, int>.from(state.progressRemaining);
    final remaining = (current[item.id] ?? item.repeat);
    if (remaining > 0) {
      current[item.id] = remaining - 1;
      await _storage.setTodayProgress(current);
      emit(state.copyWith(progressRemaining: current));
    }
  }

  void setShowFavorites(bool value) {
    emit(state.copyWith(showFavoritesOnly: value));
  }

  void setSearchQuery(String q) {
    emit(state.copyWith(searchQuery: q));
  }
}
