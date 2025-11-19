import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;

import '../../../quran/data/quran_repository.dart';
import '../../../quran/data/quran_storage.dart';
import '../../../quran/data/tafseer_repository.dart';
import '../../../quran/data/memorization_repository.dart';
import '../../../quran/data/models/memorization_entry.dart';
import '../reading/ayah_ref.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(
    this._repo,
    this._storage,
    this._tafseerRepository,
    this._memorizationRepository,
  ) : super(const QuranState());
  final QuranRepository _repo;
  final QuranStorage _storage;
  final TafseerRepository _tafseerRepository;
  final MemorizationRepository _memorizationRepository;

  Map<String, MemorizationEntry> _deckToMap(List<MemorizationEntry> deck) {
    return {for (final entry in deck) '${entry.surah}:${entry.ayah}': entry};
  }

  Future<void> _hydrateMemorization() async {
    final deck = await _memorizationRepository.loadDeck();
    final profile = await _memorizationRepository.loadProfile();
    emit(
      state.copyWith(
        memorizationDeck: _deckToMap(deck),
        memorizationProfile: profile,
      ),
    );
  }

  Future<void> loadIndex() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await _repo.loadAllSurahHeaders();
      final last = await _storage.getLastRead();
      final layout = await _storage.getLayoutMode();
      await _hydrateMemorization();
      emit(
        state.copyWith(
          loading: false,
          surahList: list,
          lastSurahId: last.$1,
          lastAyah: last.$2,
          layoutMode: layout == 'mushaf'
              ? QuranLayoutMode.mushaf
              : QuranLayoutMode.tiles,
        ),
      );
      dev.log(
        'Index loaded: ${list.length} surahs, last=${last.$1}:${last.$2}',
        name: 'quran.cubit',
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
      dev.log('Index load error: $e', level: 1000, name: 'quran.cubit');
    }
  }

  Future<void> openSurah(int id) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final header = await _repo.loadSurahHeader(id);
      final ayat = await _repo.loadSurahAyat(id);
      final bookmarks = await _storage.getBookmarks();
      await _hydrateMemorization();
      emit(
        state.copyWith(
          loading: false,
          currentSurah: header,
          currentAyat: ayat,
          bookmarks: bookmarks,
        ),
      );
      dev.log(
        'Open surah ${header.id}: ${ayat.length} ayat, bookmarks=${bookmarks.length}',
        name: 'quran.cubit',
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
      dev.log('Open surah error: $e', level: 1000, name: 'quran.cubit');
    }
  }

  void toggleTranslation(bool v) => emit(state.copyWith(showTranslation: v));
  void toggleTransliteration(bool v) =>
      emit(state.copyWith(showTransliteration: v));
  void setFontScale(double s) => emit(state.copyWith(fontScale: s));

  void setQuery(String q) => emit(state.copyWith(query: q));

  Future<void> setLastRead(int surah, int ayah) async {
    await _storage.setLastRead(surah, ayah);
    await _storage.addRecent(surah, ayah);
    emit(state.copyWith(lastSurahId: surah, lastAyah: ayah));
    dev.log('Set last-read $surah:$ayah', name: 'quran.cubit');
  }

  Future<void> toggleBookmark(int surah, int ayah) async {
    final key = '$surah:$ayah';
    final next = {...state.bookmarks};
    bool active;
    if (next.contains(key)) {
      next.remove(key);
      active = false;
    } else {
      next.add(key);
      active = true;
    }
    await _storage.setBookmarks(next);
    emit(state.copyWith(bookmarks: next));
    dev.log('Bookmark toggled $surah:$ayah => $active', name: 'quran.cubit');
  }

  Future<void> setLayoutMode(QuranLayoutMode mode) async {
    await _storage.setLayoutMode(
      mode == QuranLayoutMode.mushaf ? 'mushaf' : 'tiles',
    );
    emit(state.copyWith(layoutMode: mode));
  }

  Future<void> toggleMemorization(int surah, int ayah) async {
    emit(state.copyWith(memorizationBusy: true));
    await _memorizationRepository.toggleEntry(surah, ayah);
    await _hydrateMemorization();
    emit(state.copyWith(memorizationBusy: false));
    dev.log('Memorization toggled $surah:$ayah', name: 'quran.cubit');
  }

  Future<void> loadTafsir(int surah, int ayah) async {
    emit(
      state.copyWith(
        tafsirLoading: true,
        tafsirError: null,
        tafsirRef: AyahRef(surah, ayah),
      ),
    );
    try {
      final entry = await _tafseerRepository.getEntry(surah, ayah);
      emit(state.copyWith(tafsirLoading: false, tafsirEntry: entry));
      if (entry == null) {
        dev.log('No tafsir for $surah:$ayah', name: 'quran.cubit', level: 800);
      } else {
        dev.log('Loaded tafsir for $surah:$ayah', name: 'quran.cubit');
      }
    } catch (e) {
      emit(state.copyWith(tafsirLoading: false, tafsirError: e.toString()));
      dev.log('Tafsir load error: $e', level: 1000, name: 'quran.cubit');
    }
  }

  void clearTafsir() => emit(
    state.copyWith(tafsirEntry: null, tafsirError: null, tafsirRef: null),
  );

  Future<void> refreshMemorization() async {
    await _hydrateMemorization();
  }
}
