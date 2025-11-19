import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../models/text_collection_summary.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key, required this.summary, this.onTap});

  final TextCollectionSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final theme = Theme.of(context);
    final title = isArabic && (summary.titleAr?.isNotEmpty ?? false)
        ? summary.titleAr!
        : summary.title;
    final author = isArabic && (summary.authorAr?.isNotEmpty ?? false)
        ? summary.authorAr!
        : summary.author;
    final intro = isArabic && (summary.introductionAr?.isNotEmpty ?? false)
        ? summary.introductionAr
        : summary.introduction;
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                author,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.bookmark_added,
                    size: 18,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.collectionNarrationsLabel(summary.hadithCount),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.view_list, size: 18, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    l10n.collectionChaptersLabel(summary.chapterCount),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              if (intro?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  intro!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
