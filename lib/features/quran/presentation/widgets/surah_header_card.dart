import 'package:flutter/material.dart';
import 'islamic_label.dart';

class SurahHeaderCard extends StatelessWidget {
  const SurahHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
  });
  final String title;
  final String subtitle;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [IslamicLabel(text: title)],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.menu_book_outlined, size: 18),
              const SizedBox(width: 6),
              Text(meta, style: theme.textTheme.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}
