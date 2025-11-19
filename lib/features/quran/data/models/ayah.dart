import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  final int id; // number in surah
  final String textAr;
  final String? translationEn;
  final String? transliteration;

  const Ayah({
    required this.id,
    required this.textAr,
    this.translationEn,
    this.transliteration,
  });

  @override
  List<Object?> get props => [id, textAr, translationEn, transliteration];
}
