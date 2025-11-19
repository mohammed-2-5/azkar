class AzkarItem {
  final String id;
  final String title;
  final String content;
  final int repeat;
  final String category; // e.g., Morning, Evening, AfterPrayer, Sleep

  AzkarItem({
    required this.id,
    required this.title,
    required this.content,
    required this.repeat,
    required this.category,
  });

  factory AzkarItem.fromJson(
    Map<String, dynamic> json, {
    required String category,
    String? idPrefix,
  }) {
    final title = json['title'] as String;
    final content = json['content'] as String;
    final repeat = (json['repeat'] as num).toInt();
    final prefix = idPrefix ?? category;
    final id =
        (json['id'] as String?) ?? '${prefix}_$title'.replaceAll(' ', '_');
    return AzkarItem(
      id: id,
      title: title,
      content: content,
      repeat: repeat,
      category: category,
    );
  }
}
