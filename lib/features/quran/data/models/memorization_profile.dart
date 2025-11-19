import 'package:equatable/equatable.dart';

class MemorizationProfile extends Equatable {
  final int dailyTarget;
  final int todayReviewed;
  final DateTime? lastReviewDay;
  final int streak;

  const MemorizationProfile({
    required this.dailyTarget,
    required this.todayReviewed,
    required this.lastReviewDay,
    required this.streak,
  });

  factory MemorizationProfile.initial() => MemorizationProfile(
    dailyTarget: 5,
    todayReviewed: 0,
    lastReviewDay: null,
    streak: 0,
  );

  MemorizationProfile copyWith({
    int? dailyTarget,
    int? todayReviewed,
    DateTime? lastReviewDay,
    int? streak,
  }) {
    return MemorizationProfile(
      dailyTarget: dailyTarget ?? this.dailyTarget,
      todayReviewed: todayReviewed ?? this.todayReviewed,
      lastReviewDay: lastReviewDay ?? this.lastReviewDay,
      streak: streak ?? this.streak,
    );
  }

  Map<String, dynamic> toJson() => {
    'dailyTarget': dailyTarget,
    'todayReviewed': todayReviewed,
    'lastReviewDay': lastReviewDay?.millisecondsSinceEpoch,
    'streak': streak,
  };

  factory MemorizationProfile.fromJson(Map<String, dynamic> json) {
    return MemorizationProfile(
      dailyTarget: (json['dailyTarget'] ?? 5) as int,
      todayReviewed: (json['todayReviewed'] ?? 0) as int,
      lastReviewDay: json['lastReviewDay'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['lastReviewDay'] as int),
      streak: (json['streak'] ?? 0) as int,
    );
  }

  @override
  List<Object?> get props => [
    dailyTarget,
    todayReviewed,
    lastReviewDay,
    streak,
  ];
}
