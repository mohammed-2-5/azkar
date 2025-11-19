class TextCollectionSummary {
  const TextCollectionSummary({
    required this.id,
    required this.assetPath,
    required this.title,
    required this.author,
    required this.hadithCount,
    required this.chapterCount,
    this.introduction,
    this.titleAr,
    this.authorAr,
    this.introductionAr,
  });

  final String id;
  final String assetPath;
  final String title;
  final String author;
  final int hadithCount;
  final int chapterCount;
  final String? introduction;
  final String? titleAr;
  final String? authorAr;
  final String? introductionAr;
}

class TextCollectionEntry {
  const TextCollectionEntry({
    required this.entryId,
    required this.title,
    required this.body,
    required this.arabic,
    required this.snippet,
    required this.searchText,
    this.idInBook,
    this.chapterId,
    this.narrator,
  });

  final int entryId;
  final int? idInBook;
  final int? chapterId;
  final String title;
  final String body;
  final String arabic;
  final String snippet;
  final String searchText;
  final String? narrator;

  String get displayNumber => '#${idInBook ?? entryId}';

  bool matches(String query) => searchText.contains(query);
}
