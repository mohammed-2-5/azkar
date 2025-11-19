import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/memorization_repository.dart';
import '../../data/quran_repository.dart';
import '../../data/models/memorization_entry.dart';
import '../../data/models/ayah.dart';
import 'memorization_state.dart';
import 'quran_cubit.dart';

class MemorizationCubit extends Cubit<MemorizationState> {
  MemorizationCubit(this._memRepo, this._quranRepo, this._quranCubit)
    : super(const MemorizationState());

  final MemorizationRepository _memRepo;
  final QuranRepository _quranRepo;
  final QuranCubit _quranCubit;
  final Map<int, List<Ayah>> _surahCache = {};

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final deck = await _memRepo.loadDeck();
      final profile = await _memRepo.loadProfile();
      emit(state.copyWith(loading: false, deck: deck, profile: profile));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> refreshDeck() async {
    final deck = await _memRepo.loadDeck();
    emit(state.copyWith(deck: deck));
  }

  Future<void> setDailyTarget(int target) async {
    final profile = state.profile.copyWith(dailyTarget: target);
    await _memRepo.saveProfile(profile);
    emit(state.copyWith(profile: profile));
  }

  Future<void> removeEntry(MemorizationEntry entry) async {
    final deck = [...state.deck]
      ..removeWhere((e) => e.surah == entry.surah && e.ayah == entry.ayah);
    await _memRepo.saveDeck(deck);
    emit(state.copyWith(deck: deck));
    await _quranCubit.refreshMemorization();
  }

  Future<void> startSession() async {
    emit(state.copyWith(busy: true, error: null));
    try {
      final now = DateTime.now();
      final due = state.deck.where((e) => !e.dueOn.isAfter(now)).toList()
        ..sort((a, b) => a.dueOn.compareTo(b.dueOn));
      if (due.isEmpty) {
        emit(
          state.copyWith(
            busy: false,
            error: 'No ayat due right now. Add more or wait until next review.',
            sessionQueue: [],
          ),
        );
        return;
      }
      final cards = <MemorizationCard>[];
      for (final entry in due) {
        final ayah = await _loadAyah(entry.surah, entry.ayah);
        if (ayah != null) {
          cards.add(MemorizationCard(entry: entry, ayah: ayah));
        }
      }
      emit(
        state.copyWith(
          busy: false,
          sessionQueue: cards,
          currentIndex: 0,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(busy: false, error: e.toString()));
    }
  }

  void stopSession() {
    emit(state.copyWith(sessionQueue: [], currentIndex: 0));
  }

  Future<void> gradeCurrent(ReviewGrade grade) async {
    final card = state.currentCard;
    if (card == null) return;
    emit(state.copyWith(busy: true));
    var deck = [...state.deck];
    final idx = deck.indexWhere(
      (e) => e.surah == card.entry.surah && e.ayah == card.entry.ayah,
    );
    if (idx < 0) {
      emit(state.copyWith(busy: false));
      return;
    }
    final updatedEntry = _memRepo.schedule(card.entry, grade);
    deck[idx] = updatedEntry;
    await _memRepo.saveDeck(deck);
    var profile = state.profile;
    profile = _memRepo.updateProfile(profile, grade);
    await _memRepo.saveProfile(profile);
    final queue = [...state.sessionQueue];
    queue.removeAt(state.currentIndex);
    final nextIndex = state.currentIndex >= queue.length
        ? 0
        : state.currentIndex;
    emit(
      state.copyWith(
        busy: false,
        deck: deck,
        profile: profile,
        sessionQueue: queue,
        currentIndex: nextIndex,
      ),
    );
    await _quranCubit.refreshMemorization();
  }

  Future<Ayah?> _loadAyah(int surah, int ayah) async {
    if (!_surahCache.containsKey(surah)) {
      final list = await _quranRepo.loadSurahAyat(surah);
      _surahCache[surah] = list;
    }
    final list = _surahCache[surah]!;
    try {
      return list.firstWhere((element) => element.id == ayah);
    } catch (_) {
      return null;
    }
  }
}
