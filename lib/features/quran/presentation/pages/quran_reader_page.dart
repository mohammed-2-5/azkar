import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/i18n/arabic_norm.dart';
import '../../data/quran_repository.dart';
import '../../data/quran_storage.dart';
import '../../data/quran_diagnostics.dart';
import '../../data/models/ayah.dart';
import '../../data/tafseer_repository.dart';
import '../../data/memorization_repository.dart';
import '../widgets/surah_header_card.dart';
import '../widgets/bismillah_banner.dart';
import '../widgets/verse_tile.dart';
import '../widgets/mushaf_body.dart';
import '../widgets/islamic_frame.dart';
import '../widgets/quick_jump_sheet.dart';
import '../widgets/tafseer_sheet.dart';
import '../widgets/word_by_word_sheet.dart';
import '../reading/scroll_registry.dart';
import '../reading/ayah_ref.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';

class QuranReaderPage extends StatelessWidget {
  const QuranReaderPage({super.key, required this.id, this.initialAyah});
  final int id;
  final int? initialAyah;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => QuranRepository()),
        RepositoryProvider(create: (_) => QuranStorage()),
        RepositoryProvider(create: (_) => TafseerRepository()),
        RepositoryProvider(
          create: (ctx) => MemorizationRepository(ctx.read<QuranStorage>()),
        ),
      ],
      child: BlocProvider(
        create: (ctx) => QuranCubit(
          ctx.read<QuranRepository>(),
          ctx.read<QuranStorage>(),
          ctx.read<TafseerRepository>(),
          ctx.read<MemorizationRepository>(),
        )..openSurah(id),
        child: _ReaderView(id: id, initialAyah: initialAyah),
      ),
    );
  }
}

class _ReaderView extends StatefulWidget {
  const _ReaderView({required this.id, this.initialAyah});
  final int id;
  final int? initialAyah;

  @override
  State<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<_ReaderView> {
  final _controller = ScrollController();
  final _registry = QuranScrollRegistry();
  final _mushafController = MushafPagerController();
  bool _pendingInitialScroll = true;

  void _openSearch(List items, void Function(int ayahId) onPick) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => _VerseSearchSheet(items: items, onPick: onPick),
    );
  }

  void _openReaderControls() {
    final storage = context.read<QuranStorage>();
    final cubit = context.read<QuranCubit>();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => RepositoryProvider.value(
        value: storage,
        child: BlocProvider.value(
          value: cubit,
          child: const _ReaderControlsSheet(),
        ),
      ),
    );
  }

  void _scrollToAyah(int ayahId) {
    final cubit = context.read<QuranCubit>();
    final sId = cubit.state.currentSurah?.id;
    if (sId == null) return;
    if (cubit.state.layoutMode == QuranLayoutMode.mushaf) {
      _mushafController.jumpToAyah(ayahId);
    } else {
      _registry.scrollTo(AyahRef(sId, ayahId));
    }
  }

  Future<void> _openTafsir(
    BuildContext context,
    int surahId,
    int ayahId,
    String title,
  ) async {
    final cubit = context.read<QuranCubit>();
    cubit.loadTafsir(surahId, ayahId);
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: TafseerSheet(ref: AyahRef(surahId, ayahId), title: title),
      ),
    );
    cubit.clearTafsir();
  }

  Future<void> _openWordByWord(BuildContext context, Ayah ayah) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => WordByWordSheet(ayah: ayah),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) =>
              Text(state.currentSurah?.transliteration ?? l10n.navQuran),
        ),
        actions: [
          IconButton(
            tooltip: l10n.search,
            icon: const Icon(Icons.search),
            onPressed: () {
              final items = context.read<QuranCubit>().state.currentAyat;
              _openSearch(items, (ayahId) {
                Navigator.of(context).maybePop();
                _scrollToAyah(ayahId);
              });
            },
          ),
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.tune),
            onPressed: _openReaderControls,
          ),
        ],
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          // Build content (debug labels removed)

          if (state.loading && state.currentAyat.isEmpty) {
            return const Center(child: LinearProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.currentAyat.isEmpty) {
            return _EmptyAyatState(
              onRetry: () => context.read<QuranCubit>().openSurah(widget.id),
              onDiag: () async {
                final res = await QuranDiagnostics.preflight();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Assets check — AR:${res.missingAr} EN:${res.missingEn}',
                    ),
                  ),
                );
              },
            );
          }

          final hasHeader = state.currentSurah != null;
          final hasBismillah = hasHeader && (state.currentSurah!.id != 9);
          final extra = (hasHeader ? 1 : 0) + (hasBismillah ? 1 : 0);

          if (_pendingInitialScroll &&
              widget.initialAyah != null &&
              state.currentAyat.isNotEmpty) {
            _pendingInitialScroll = false;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToAyah(widget.initialAyah!),
            );
          }

          if (state.layoutMode == QuranLayoutMode.mushaf) {
            final s = state.currentSurah;
            return IslamicFrame(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (s != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SurahHeaderCard(
                        title: s.transliteration,
                        subtitle: s.translation ?? '',
                        meta: '${s.type.toUpperCase()} • ${s.totalVerses}',
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: _FontControls(),
                  ),
                  Expanded(
                    child: MushafBody(
                      ayat: state.currentAyat,
                      fontScale: state.fontScale,
                      showBismillah: hasBismillah,
                      surahId: s?.id ?? 0,
                      controller: _mushafController,
                    ),
                  ),
                ],
              ),
            );
          }

          return IslamicFrame(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: _FontControls(),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.currentAyat.length + extra,
                    itemBuilder: (context, idx) {
                      int offset = 0;

                      if (hasHeader) {
                        if (idx == offset) {
                          final s = state.currentSurah!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SurahHeaderCard(
                              title: s.transliteration,
                              subtitle: s.translation ?? '',
                              meta:
                                  '${s.type.toUpperCase()} • ${s.totalVerses}',
                            ),
                          );
                        }
                        offset++;
                      }
                      if (hasBismillah) {
                        if (idx == offset) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: BismillahBanner(),
                          );
                        }
                        offset++;
                      }
                      final index = idx - offset;
                      if (index < 0 || index >= state.currentAyat.length) {
                        return const SizedBox.shrink();
                      }
                      try {
                        final a = state.currentAyat[index];
                        final surahId = state.currentSurah?.id ?? 0;
                        final isBookmarked = state.bookmarks.contains(
                          '$surahId:${a.id}',
                        );
                        final key = _registry.keyFor(AyahRef(surahId, a.id));
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: KeyedSubtree(
                            key: key,
                            child: VerseTile(
                              ayaNumber: a.id,
                              textAr: a.textAr,
                              transliteration: state.showTransliteration
                                  ? a.transliteration
                                  : null,
                              translation: state.showTranslation
                                  ? a.translationEn
                                  : null,
                              scale: state.fontScale,
                              bookmarked: isBookmarked,
                              memorized: state.memorizationDeck.containsKey(
                                '$surahId:${a.id}',
                              ),
                              onBookmark: () => context
                                  .read<QuranCubit>()
                                  .toggleBookmark(surahId, a.id),
                              onMemorize: () => context
                                  .read<QuranCubit>()
                                  .toggleMemorization(surahId, a.id),
                              onTap: () => context
                                  .read<QuranCubit>()
                                  .setLastRead(surahId, a.id),
                              onTafsir: () {
                                final title =
                                    state.currentSurah?.transliteration ??
                                    'Surah $surahId';
                                _openTafsir(context, surahId, a.id, title);
                              },
                              onWordByWord: () => _openWordByWord(context, a),
                            ),
                          ),
                        );
                      } catch (e) {
                        return ListTile(title: Text('Item error: $e'));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // bottom slider moved into body controls to avoid nested scaffold conflicts
    );
  }
}

// verse tile moved to widgets

class _VerseSearchSheet extends StatefulWidget {
  const _VerseSearchSheet({required this.items, required this.onPick});
  final List items; // of Ayah
  final void Function(int ayahId) onPick;

  @override
  State<_VerseSearchSheet> createState() => _VerseSearchSheetState();
}

class _EmptyAyatState extends StatelessWidget {
  const _EmptyAyatState({required this.onRetry, required this.onDiag});
  final VoidCallback onRetry;
  final VoidCallback onDiag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text('No verses loaded', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Tap Retry to load again or run asset diagnostics.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onDiag,
              child: const Text('Run Diagnostics'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerseSearchSheetState extends State<_VerseSearchSheet> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Normalize Arabic and Latin for diacritics-insensitive search
    List results = const [];
    if (q.isNotEmpty) {
      final normQ = normalizeArabic(q);
      results = widget.items.where((a) {
        final ar = normalizeArabic(a.textAr as String);
        final tr = (a.translationEn as String?) ?? '';
        return ar.contains(normQ) || tr.toLowerCase().contains(q.toLowerCase());
      }).toList();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: l10n.search,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => q = v.trim()),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final a = results[i];
                final title = _highlightArabic(a.textAr as String, q);
                final sub = a.translationEn == null
                    ? null
                    : _highlightLatin(a.translationEn as String, q);
                return ListTile(
                  title: title,
                  subtitle: sub,
                  onTap: () => widget.onPick(a.id as int),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightArabic(String text, String query) {
    if (query.isEmpty) {
      return Text(
        text,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      );
    }
    final normText = normalizeArabic(text);
    final normQ = normalizeArabic(query);
    final idx = normText.indexOf(normQ);
    if (idx < 0) {
      return Text(
        text,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      );
    }
    // Fallback simple highlight using original text ranges
    final start = idx;
    final end = idx + normQ.length;
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(end)),
        ],
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }

  Widget _highlightLatin(String text, String query) {
    if (query.isEmpty) return Text(text);
    final t = text.toLowerCase();
    final ql = query.toLowerCase();
    final idx = t.indexOf(ql);
    if (idx < 0) return Text(text);
    final start = idx;
    final end = idx + ql.length;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(end)),
        ],
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }
}

class _FontControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scale = context.watch<QuranCubit>().state.fontScale;
    return Row(
      children: [
        const Text('A-'),
        Expanded(
          child: Slider(
            value: scale,
            min: 0.8,
            max: 1.6,
            onChanged: (v) => context.read<QuranCubit>().setFontScale(v),
          ),
        ),
        const Text('A+'),
      ],
    );
  }
}

class _ReaderControlsSheet extends StatelessWidget {
  const _ReaderControlsSheet();

  void _openQuickJump(BuildContext context) {
    Navigator.of(context).maybePop();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) {
        final storage = context.read<QuranStorage>();
        final cubit = context.read<QuranCubit>();
        return RepositoryProvider.value(
          value: storage,
          child: BlocProvider.value(
            value: cubit,
            child: const DefaultTabController(
              length: 2,
              child: QuickJumpSheet(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final cubit = context.read<QuranCubit>();
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text('Reader options', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                title: const Text('Show transliteration'),
                value: state.showTransliteration,
                onChanged: (v) => cubit.toggleTransliteration(v),
              ),
              SwitchListTile.adaptive(
                title: const Text('Show translation'),
                value: state.showTranslation,
                onChanged: (v) => cubit.toggleTranslation(v),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Layout'),
                subtitle: SegmentedButton<QuranLayoutMode>(
                  segments: const [
                    ButtonSegment(
                      value: QuranLayoutMode.tiles,
                      label: Text('Tiles'),
                      icon: Icon(Icons.view_agenda),
                    ),
                    ButtonSegment(
                      value: QuranLayoutMode.mushaf,
                      label: Text('Mushaf'),
                      icon: Icon(Icons.chrome_reader_mode),
                    ),
                  ],
                  selected: {state.layoutMode},
                  onSelectionChanged: (selection) {
                    cubit.setLayoutMode(selection.first);
                  },
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _openQuickJump(context),
                icon: const Icon(Icons.rocket_launch_outlined),
                label: const Text('Quick jump'),
              ),
            ],
          );
        },
      ),
    );
  }
}
