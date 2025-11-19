import 'dart:math';

import 'models/memorization_entry.dart';
import 'models/memorization_profile.dart';
import 'quran_storage.dart';

enum ReviewGrade { again, hard, good, easy }

class MemorizationRepository {
  MemorizationRepository(this._storage);

  final QuranStorage _storage;

  Future<List<MemorizationEntry>> loadDeck() async {
    final raw = await _storage.getMemDeckRaw();
    return raw.map(MemorizationEntry.fromJson).toList();
  }

  Future<void> saveDeck(List<MemorizationEntry> deck) async {
    await _storage.setMemDeckRaw(deck.map((e) => e.toJson()).toList());
  }

  Future<MemorizationProfile> loadProfile() async {
    final raw = await _storage.getMemProfileRaw();
    if (raw == null) return MemorizationProfile.initial();
    return MemorizationProfile.fromJson(raw);
  }

  Future<void> saveProfile(MemorizationProfile profile) async {
    await _storage.setMemProfileRaw(profile.toJson());
  }

  Future<MemorizationEntry> toggleEntry(int surah, int ayah) async {
    final deck = await loadDeck();
    final idx = deck.indexWhere((e) => e.surah == surah && e.ayah == ayah);
    if (idx >= 0) {
      deck.removeAt(idx);
      await saveDeck(deck);
      return MemorizationEntry(
        surah: surah,
        ayah: ayah,
        easeFactor: 2.3,
        intervalDays: 0,
        dueOn: DateTime.fromMillisecondsSinceEpoch(0),
        lastReviewed: null,
        streak: 0,
        repetitions: 0,
      );
    }
    final now = DateTime.now();
    final entry = MemorizationEntry(
      surah: surah,
      ayah: ayah,
      easeFactor: 2.3,
      intervalDays: 0,
      dueOn: now,
      lastReviewed: null,
      streak: 0,
      repetitions: 0,
    );
    deck.add(entry);
    await saveDeck(deck);
    return entry;
  }

  Future<MemorizationEntry> upsertEntry(MemorizationEntry entry) async {
    final deck = await loadDeck();
    final idx = deck.indexWhere(
      (e) => e.surah == entry.surah && e.ayah == entry.ayah,
    );
    if (idx >= 0) {
      deck[idx] = entry;
    } else {
      deck.add(entry);
    }
    await saveDeck(deck);
    return entry;
  }

  MemorizationEntry schedule(MemorizationEntry entry, ReviewGrade grade) {
    double ease = entry.easeFactor;
    int interval = entry.intervalDays;
    final now = DateTime.now();
    switch (grade) {
      case ReviewGrade.again:
        interval = 1;
        ease = max(1.3, ease - 0.3);
        break;
      case ReviewGrade.hard:
        interval = max(1, (interval * 0.5).round());
        ease = max(1.3, ease - 0.15);
        break;
      case ReviewGrade.good:
        interval = interval == 0 ? 1 : (interval * ease).round();
        break;
      case ReviewGrade.easy:
        interval = max(
          2,
          (interval == 0 ? 2 : (interval * (ease + 0.1))).round(),
        );
        ease = min(ease + 0.05, 3.0);
        break;
    }
    final streak = grade == ReviewGrade.again ? 0 : entry.streak + 1;
    return entry.copyWith(
      easeFactor: ease,
      intervalDays: interval,
      dueOn: now.add(Duration(days: interval)),
      lastReviewed: now,
      repetitions: entry.repetitions + 1,
      streak: streak,
    );
  }

  MemorizationProfile updateProfile(
    MemorizationProfile profile,
    ReviewGrade grade,
  ) {
    final today = DateTime.now();
    final dayKey = DateTime(today.year, today.month, today.day);
    final lastDay = profile.lastReviewDay == null
        ? null
        : DateTime(
            profile.lastReviewDay!.year,
            profile.lastReviewDay!.month,
            profile.lastReviewDay!.day,
          );
    int todayCount = profile.todayReviewed;
    int streak = profile.streak;
    if (lastDay == null || dayKey.isAfter(lastDay)) {
      todayCount = 0;
      if (lastDay != null && dayKey.difference(lastDay).inDays == 1) {
        streak += 1;
      } else if (lastDay == null) {
        streak = 1;
      } else {
        streak = 1;
      }
    }
    if (grade != ReviewGrade.again) {
      todayCount += 1;
    }
    return profile.copyWith(
      todayReviewed: todayCount,
      lastReviewDay: dayKey,
      streak: streak,
    );
  }
}
