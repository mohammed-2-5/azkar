import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import 'islamic_medallion.dart';

class VerseTile extends StatelessWidget {
  const VerseTile({
    super.key,
    required this.ayaNumber,
    required this.textAr,
    this.translation,
    this.transliteration,
    required this.scale,
    this.bookmarked = false,
    this.memorized = false,
    this.onBookmark,
    this.onTap,
    this.onTafsir,
    this.onWordByWord,
    this.onMemorize,
  });

  final int ayaNumber;
  final String textAr;
  final String? translation;
  final String? transliteration;
  final double scale;
  final bool bookmarked;
  final bool memorized;
  final VoidCallback? onBookmark;
  final VoidCallback? onTap;
  final VoidCallback? onTafsir;
  final VoidCallback? onWordByWord;
  final VoidCallback? onMemorize;

  Future<void> _copy(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final buffer = StringBuffer()
      ..writeln(textAr)
      ..writeln()
      ..writeln(translation ?? '');
    await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    messenger.showSnackBar(SnackBar(content: Text(l10n.copied)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _copy(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                textAr,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22 * scale,
                  height: 1.6,
                ),
              ),
              if (transliteration != null) ...[
                const SizedBox(height: 8),
                Text(
                  transliteration!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
              if (translation != null) ...[
                const SizedBox(height: 8),
                Text(
                  translation!,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      bookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    ),
                    onPressed: onBookmark,
                    tooltip: AppLocalizations.of(context)!.bookmark,
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.copy_all_outlined),
                    onPressed: () => _copy(context),
                    tooltip: AppLocalizations.of(context)!.copy,
                  ),
                  if (onMemorize != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: Icon(memorized ? Icons.flag : Icons.outlined_flag),
                      onPressed: onMemorize,
                      tooltip: 'Memorize',
                    ),
                  ],
                  if (onTafsir != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.menu_book_outlined),
                      onPressed: onTafsir,
                      tooltip: 'Tafsir',
                    ),
                  ],
                  if (onWordByWord != null) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.translate),
                      onPressed: onWordByWord,
                      tooltip: 'Word-by-word',
                    ),
                  ],
                  const Spacer(),
                  IslamicMedallion(number: ayaNumber),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
