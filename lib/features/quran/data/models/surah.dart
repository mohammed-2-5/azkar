import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  final int id;
  final String transliteration;
  final String? translation;
  final String type; // meccan/medinan
  final int totalVerses;

  const Surah({
    required this.id,
    required this.transliteration,
    required this.translation,
    required this.type,
    required this.totalVerses,
  });

  factory Surah.fromChapterJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] as int,
      transliteration: (json['transliteration'] ?? '') as String,
      translation: json['translation'] as String?,
      type: (json['type'] ?? '') as String,
      totalVerses: (json['total_verses'] ?? 0) as int,
    );
  }

  @override
  List<Object?> get props => [
    id,
    transliteration,
    translation,
    type,
    totalVerses,
  ];
}
