import 'package:equatable/equatable.dart';
import '../../../quran/data/models/surah.dart';
import '../../../quran/data/models/ayah.dart';
import '../../../quran/data/models/tafseer_entry.dart';
import '../../../quran/data/models/memorization_entry.dart';
import '../../../quran/data/models/memorization_profile.dart';
import '../reading/ayah_ref.dart';

enum QuranLayoutMode { tiles, mushaf }

class QuranState extends Equatable {
  final bool loading;
  final List<Surah> surahList;
  final Surah? currentSurah;
  final List<Ayah> currentAyat;
  final bool showTranslation;
  final bool showTransliteration;
  final double fontScale;
  final String? error;
  final String query;
  final int? lastSurahId;
  final int? lastAyah;
  final Set<String> bookmarks; // keys like 'surah:ayah'
  final QuranLayoutMode layoutMode;
  final TafseerEntry? tafsirEntry;
  final bool tafsirLoading;
  final String? tafsirError;
  final AyahRef? tafsirRef;
  final Map<String, MemorizationEntry> memorizationDeck;
  final MemorizationProfile memorizationProfile;
  final bool memorizationBusy;

  const QuranState({
    this.loading = false,
    this.surahList = const [],
    this.currentSurah,
    this.currentAyat = const [],
    this.showTranslation = true,
    this.showTransliteration = false,
    this.fontScale = 1.0,
    this.error,
    this.query = '',
    this.lastSurahId,
    this.lastAyah,
    this.bookmarks = const {},
    this.layoutMode = QuranLayoutMode.tiles,
    this.tafsirEntry,
    this.tafsirLoading = false,
    this.tafsirError,
    this.tafsirRef,
    this.memorizationDeck = const {},
    this.memorizationProfile = const MemorizationProfile(
      dailyTarget: 5,
      todayReviewed: 0,
      lastReviewDay: null,
      streak: 0,
    ),
    this.memorizationBusy = false,
  });

  QuranState copyWith({
    bool? loading,
    List<Surah>? surahList,
    Surah? currentSurah,
    List<Ayah>? currentAyat,
    bool? showTranslation,
    bool? showTransliteration,
    double? fontScale,
    String? error,
    String? query,
    int? lastSurahId,
    int? lastAyah,
    Set<String>? bookmarks,
    QuranLayoutMode? layoutMode,
    TafseerEntry? tafsirEntry,
    bool? tafsirLoading,
    String? tafsirError,
    AyahRef? tafsirRef,
    Map<String, MemorizationEntry>? memorizationDeck,
    MemorizationProfile? memorizationProfile,
    bool? memorizationBusy,
  }) {
    return QuranState(
      loading: loading ?? this.loading,
      surahList: surahList ?? this.surahList,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyat: currentAyat ?? this.currentAyat,
      showTranslation: showTranslation ?? this.showTranslation,
      showTransliteration: showTransliteration ?? this.showTransliteration,
      fontScale: fontScale ?? this.fontScale,
      error: error,
      query: query ?? this.query,
      lastSurahId: lastSurahId ?? this.lastSurahId,
      lastAyah: lastAyah ?? this.lastAyah,
      bookmarks: bookmarks ?? this.bookmarks,
      layoutMode: layoutMode ?? this.layoutMode,
      tafsirEntry: tafsirEntry ?? this.tafsirEntry,
      tafsirLoading: tafsirLoading ?? this.tafsirLoading,
      tafsirError: tafsirError,
      tafsirRef: tafsirRef ?? this.tafsirRef,
      memorizationDeck: memorizationDeck ?? this.memorizationDeck,
      memorizationProfile: memorizationProfile ?? this.memorizationProfile,
      memorizationBusy: memorizationBusy ?? this.memorizationBusy,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    surahList,
    currentSurah,
    currentAyat,
    showTranslation,
    showTransliteration,
    fontScale,
    error,
    query,
    lastSurahId,
    lastAyah,
    bookmarks,
    layoutMode,
    tafsirEntry,
    tafsirLoading,
    tafsirError,
    tafsirRef,
    memorizationDeck,
    memorizationProfile,
    memorizationBusy,
  ];
}
