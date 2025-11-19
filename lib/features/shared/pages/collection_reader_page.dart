import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../core/i18n/format.dart';
import '../data/collection_favorites_store.dart';
import '../models/text_collection_summary.dart';

typedef CollectionEntriesLoader = Future<List<TextCollectionEntry>> Function();

class CollectionReaderPage extends StatefulWidget {
  const CollectionReaderPage({
    super.key,
    required this.summary,
    required this.loadEntries,
  });

  final TextCollectionSummary summary;
  final CollectionEntriesLoader loadEntries;

  @override
  State<CollectionReaderPage> createState() => _CollectionReaderPageState();
}

class _CollectionReaderPageState extends State<CollectionReaderPage> {
  static const int _pageSize = 50;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<TextCollectionEntry> _entries = const [];
  List<TextCollectionEntry> _filtered = const [];
  int _visibleCount = 0;
  CollectionFavoritesStore? _favorites;
  bool _loading = true;
  String? _error;
  String _query = '';
  bool _isLoadingMore = false;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocus.dispose();
    _scrollController
      ..removeListener(_maybeLoadMore)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final entries = await widget.loadEntries();
      final favorites = await CollectionFavoritesStore.getInstance();
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _favorites = favorites;
        _loading = false;
        _applyFilters();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query == _query) return;
    setState(() {
      _query = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final base = _baseEntries();
    if (_query.isEmpty) {
      _filtered = base;
      _visibleCount = _initialVisibleCount(_filtered.length);
    } else {
      _filtered = base.where((entry) => entry.matches(_query)).toList();
    }
    if (_showFavoritesOnly) {
      _visibleCount = _filtered.length;
    }
  }

  List<TextCollectionEntry> _baseEntries() {
    if (!_showFavoritesOnly) return _entries;
    final ids = _favoriteIds();
    if (ids.isEmpty) return [];
    return _entries
        .where((entry) => ids.contains(entry.idInBook ?? entry.entryId))
        .toList();
  }

  Set<int> _favoriteIds() {
    final store = _favorites;
    if (store == null) return {};
    final prefix = '${widget.summary.id}:';
    final ids = <int>{};
    for (final key in store.keys) {
      if (!key.startsWith(prefix)) continue;
      final raw = key.substring(prefix.length);
      final parsed = int.tryParse(raw);
      if (parsed != null) ids.add(parsed);
    }
    return ids;
  }

  int _initialVisibleCount(int total) => total < _pageSize ? total : _pageSize;

  int get _effectiveLength => _query.isEmpty ? _visibleCount : _filtered.length;

  bool get _showLoadMore =>
      !_showFavoritesOnly && _query.isEmpty && _visibleCount < _filtered.length;

  void _maybeLoadMore() {
    if (_query.isNotEmpty || !_showLoadMore || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final threshold = position.maxScrollExtent - 200;
    if (position.pixels >= threshold) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore || !_showLoadMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _visibleCount = (_visibleCount + _pageSize).clamp(0, _filtered.length);
        _isLoadingMore = false;
      });
    });
  }

  Future<void> _toggleFavorite(TextCollectionEntry entry) async {
    final store = _favorites;
    if (store == null) return;
    final key = collectionFavoriteKey(
      widget.summary.id,
      entry.idInBook ?? entry.entryId,
    );
    await store.toggle(key);
    if (mounted) setState(() {});
  }

  bool _isFavorite(TextCollectionEntry entry) {
    final store = _favorites;
    if (store == null) return false;
    final key = collectionFavoriteKey(
      widget.summary.id,
      entry.idInBook ?? entry.entryId,
    );
    return store.isFavorite(key);
  }

  String _collectionTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ar' && (widget.summary.titleAr?.isNotEmpty ?? false)) {
      return widget.summary.titleAr!;
    }
    return widget.summary.title;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _collectionTitle(context);
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(l10n.collectionEntriesLoadError(_error!))),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.collectionSearchHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.collectionAllLabel),
                  selected: !_showFavoritesOnly,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _showFavoritesOnly = false;
                        _applyFilters();
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.favoritesScreenTitle),
                  selected: _showFavoritesOnly,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _showFavoritesOnly = true;
                        _applyFilters();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(child: Text(l10n.collectionNoEntries))
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: _effectiveLength + (_showLoadMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      if (_showLoadMore && index == _effectiveLength) {
                        return _LoadMoreIndicator(isLoading: _isLoadingMore);
                      }
                      final entry = _filtered[index];
                      final favorite = _isFavorite(entry);
                      final displayLabel = _localizedDisplayNumber(
                        context,
                        entry,
                      );
                      return _CollectionEntryTile(
                        entry: entry,
                        displayLabel: displayLabel,
                        favorite: favorite,
                        onFavorite: () => _toggleFavorite(entry),
                        onOpen: () => _showEntry(entry),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEntry(TextCollectionEntry entry) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  Text(
                    '${_localizedDisplayNumber(context, entry)} · ${entry.title}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (entry.narrator?.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.narrator!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (entry.arabic.isNotEmpty) ...[
                    Text(
                      entry.arabic,
                      textDirection: TextDirection.rtl,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    entry.body,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CollectionEntryTile extends StatelessWidget {
  const _CollectionEntryTile({
    required this.entry,
    required this.displayLabel,
    required this.favorite,
    required this.onFavorite,
    required this.onOpen,
  });

  final TextCollectionEntry entry;
  final String displayLabel;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onOpen,
        title: Text('$displayLabel · ${entry.title}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.arabic.isNotEmpty)
              Text(
                entry.arabic,
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            if (entry.arabic.isNotEmpty) const SizedBox(height: 6),
            Text(entry.snippet, maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.pinkAccent : null,
          ),
          onPressed: onFavorite,
        ),
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : const Icon(Icons.expand_more),
      ),
    );
  }
}

String _localizedDisplayNumber(
  BuildContext context,
  TextCollectionEntry entry,
) {
  final number = entry.idInBook ?? entry.entryId;
  return '#${localizedDigits(context, number.toString())}';
}
