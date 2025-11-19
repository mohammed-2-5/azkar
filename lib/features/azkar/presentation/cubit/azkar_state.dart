import 'package:equatable/equatable.dart';
import '../../data/models/azkar_item.dart';

enum AzkarStatus { initial, loading, loaded, error }

class AzkarState extends Equatable {
  final AzkarStatus status;
  final Map<String, List<AzkarItem>> byCategory;
  final String selectedCategory;
  final Set<String> favorites;
  final Map<String, int> progressRemaining; // id -> remaining count today
  final bool showFavoritesOnly;
  final String searchQuery;
  final String? error;

  const AzkarState({
    this.status = AzkarStatus.initial,
    this.byCategory = const {},
    this.selectedCategory = 'Morning',
    this.favorites = const {},
    this.progressRemaining = const {},
    this.showFavoritesOnly = false,
    this.searchQuery = '',
    this.error,
  });

  List<AzkarItem> get items => byCategory[selectedCategory] ?? const [];

  List<AzkarItem> get filteredItems => _applyFilters(items);

  Map<String, List<AzkarItem>> get filteredByCategory {
    final query = searchQuery.trim();
    final bool includeAllCategories =
        query.isNotEmpty || showFavoritesOnly;
    final Iterable<String> categories = includeAllCategories
        ? byCategory.keys
        : [selectedCategory];
    final result = <String, List<AzkarItem>>{};
    for (final category in categories) {
      final source = byCategory[category] ?? const [];
      final filtered = _applyFilters(source);
      if (filtered.isNotEmpty) {
        result[category] = filtered;
      }
    }
    return result;
  }

  List<AzkarItem> _applyFilters(List<AzkarItem> list) {
    Iterable<AzkarItem> filtered = list;
    if (showFavoritesOnly) {
      filtered = filtered.where((item) => favorites.contains(item.id));
    }
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where(
        (item) =>
            item.title.toLowerCase().contains(query) ||
            item.content.toLowerCase().contains(query),
      );
    }
    return filtered.toList(growable: false);
  }

  AzkarState copyWith({
    AzkarStatus? status,
    Map<String, List<AzkarItem>>? byCategory,
    String? selectedCategory,
    Set<String>? favorites,
    Map<String, int>? progressRemaining,
    bool? showFavoritesOnly,
    String? searchQuery,
    String? error,
  }) {
    return AzkarState(
      status: status ?? this.status,
      byCategory: byCategory ?? this.byCategory,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      favorites: favorites ?? this.favorites,
      progressRemaining: progressRemaining ?? this.progressRemaining,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    byCategory,
    selectedCategory,
    favorites,
    progressRemaining,
    showFavoritesOnly,
    searchQuery,
    error,
  ];
}
