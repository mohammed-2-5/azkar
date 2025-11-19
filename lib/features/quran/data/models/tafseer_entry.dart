import '../../presentation/reading/ayah_ref.dart';

class TafseerEntry {
  final int surah;
  final int ayah;
  final String text;

  const TafseerEntry({
    required this.surah,
    required this.ayah,
    required this.text,
  });

  factory TafseerEntry.fromJson(Map<String, dynamic> json) {
    return TafseerEntry(
      surah: int.parse(json['number'] as String),
      ayah: int.parse(json['aya'] as String),
      text: json['text'] as String? ?? '',
    );
  }

  AyahRef get ref => AyahRef(surah, ayah);

  Map<String, dynamic> toJson() => {
    'number': '$surah',
    'aya': '$ayah',
    'text': text,
  };
}
