import 'package:equatable/equatable.dart';

import '../../data/models/memorization_entry.dart';
import '../../data/models/memorization_profile.dart';
import '../../data/models/ayah.dart';

class MemorizationCard extends Equatable {
  final MemorizationEntry entry;
  final Ayah ayah;

  const MemorizationCard({required this.entry, required this.ayah});

  @override
  List<Object?> get props => [entry, ayah];
}

class MemorizationState extends Equatable {
  final bool loading;
  final bool busy;
  final List<MemorizationEntry> deck;
  final MemorizationProfile profile;
  final List<MemorizationCard> sessionQueue;
  final int currentIndex;
  final String? error;

  const MemorizationState({
    this.loading = false,
    this.busy = false,
    this.deck = const [],
    this.profile = const MemorizationProfile(
      dailyTarget: 5,
      todayReviewed: 0,
      lastReviewDay: null,
      streak: 0,
    ),
    this.sessionQueue = const [],
    this.currentIndex = 0,
    this.error,
  });

  MemorizationCard? get currentCard =>
      currentIndex >= 0 && currentIndex < sessionQueue.length
      ? sessionQueue[currentIndex]
      : null;

  bool get hasSession => sessionQueue.isNotEmpty;

  MemorizationState copyWith({
    bool? loading,
    bool? busy,
    List<MemorizationEntry>? deck,
    MemorizationProfile? profile,
    List<MemorizationCard>? sessionQueue,
    int? currentIndex,
    String? error,
  }) {
    return MemorizationState(
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      deck: deck ?? this.deck,
      profile: profile ?? this.profile,
      sessionQueue: sessionQueue ?? this.sessionQueue,
      currentIndex: currentIndex ?? this.currentIndex,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    busy,
    deck,
    profile,
    sessionQueue,
    currentIndex,
    error,
  ];
}
