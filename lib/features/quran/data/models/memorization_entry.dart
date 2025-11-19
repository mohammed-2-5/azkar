import 'package:equatable/equatable.dart';

class MemorizationEntry extends Equatable {
  final int surah;
  final int ayah;
  final double easeFactor; // SM-2 style ease (>=1.3)
  final int intervalDays;
  final DateTime dueOn;
  final DateTime? lastReviewed;
  final int streak;
  final int repetitions;

  const MemorizationEntry({
    required this.surah,
    required this.ayah,
    required this.easeFactor,
    required this.intervalDays,
    required this.dueOn,
    this.lastReviewed,
    required this.streak,
    required this.repetitions,
  });

  MemorizationEntry copyWith({
    double? easeFactor,
    int? intervalDays,
    DateTime? dueOn,
    DateTime? lastReviewed,
    int? streak,
    int? repetitions,
  }) {
    return MemorizationEntry(
      surah: surah,
      ayah: ayah,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      dueOn: dueOn ?? this.dueOn,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      streak: streak ?? this.streak,
      repetitions: repetitions ?? this.repetitions,
    );
  }

  Map<String, dynamic> toJson() => {
    's': surah,
    'a': ayah,
    'e': easeFactor,
    'i': intervalDays,
    'd': dueOn.millisecondsSinceEpoch,
    'l': lastReviewed?.millisecondsSinceEpoch,
    'st': streak,
    'r': repetitions,
  };

  factory MemorizationEntry.fromJson(Map<String, dynamic> json) {
    return MemorizationEntry(
      surah: (json['s'] ?? 0) as int,
      ayah: (json['a'] ?? 0) as int,
      easeFactor: (json['e'] as num?)?.toDouble() ?? 2.3,
      intervalDays: (json['i'] ?? 1) as int,
      dueOn: DateTime.fromMillisecondsSinceEpoch((json['d'] ?? 0) as int),
      lastReviewed: json['l'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['l'] as int),
      streak: (json['st'] ?? 0) as int,
      repetitions: (json['r'] ?? 0) as int,
    );
  }

  @override
  List<Object?> get props => [
    surah,
    ayah,
    easeFactor,
    intervalDays,
    dueOn,
    lastReviewed,
    streak,
    repetitions,
  ];
}
