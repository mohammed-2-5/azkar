import 'package:flutter/material.dart';

class BismillahBanner extends StatelessWidget {
  const BismillahBanner({super.key});

  static const _bismillah = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

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
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Text(
        _bismillah,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
