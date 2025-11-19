import 'package:flutter/material.dart';

import '../../../../core/theme/theme_tokens.dart';
import '../../data/models/azkar_item.dart';

class AzkarCard extends StatelessWidget {
  const AzkarCard({
    super.key,
    required this.item,
    required this.favorite,
    required this.remaining,
    required this.onFavorite,
    required this.onOpen,
  });

  final AzkarItem item;
  final bool favorite;
  final int remaining;
  final VoidCallback onFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: ThemeTokens.elevatedShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      color: favorite ? Colors.pinkAccent : Colors.white70,
                    ),
                    onPressed: onFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _Badge(
                    icon: Icons.repeat,
                    label: 'x${item.repeat}',
                  ),
                  const SizedBox(width: 12),
                  _Badge(
                    icon: Icons.hourglass_bottom,
                    label: 'Remaining: $remaining',
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: onOpen,
                    child: const Text('Open'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
