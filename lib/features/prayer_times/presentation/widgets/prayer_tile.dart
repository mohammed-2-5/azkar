import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'prayer_accessibility.dart';

class PrayerTile extends StatelessWidget {
  const PrayerTile({
    super.key,
    required this.name,
    required this.timeText,
    required this.relativeText,
    required this.icon,
    required this.colors,
    this.isNext = false,
    this.compact = false,
    this.onTap,
    this.trailing,
  });

  final String name;
  final String timeText;
  final String relativeText;
  final IconData icon;
  final List<Color> colors;
  final bool isNext;
  final bool compact;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final semanticsLabel = buildPrayerSummaryLabel(
      l10n,
      prayerName: name,
      timeText: timeText,
      relativeText: relativeText,
      isNext: isNext,
    );
    final accent = colors.isNotEmpty ? colors.first : const Color(0xFF6F4E37);
    final ornamentColor = accent.withOpacity(0.5);
    final padding = compact ? const EdgeInsets.all(12) : const EdgeInsets.all(16);

    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticsLabel,
      child: AspectRatio(
        aspectRatio: compact ? 2.4 : 2.0,
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFDF5EC),
                    Color(0xFFF1E2CE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: accent.withOpacity(0.2)),
                boxShadow: [
                  if (isNext)
                    BoxShadow(
                      color: accent.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: CustomPaint(
                painter: _MosqueFramePainter(color: ornamentColor),
                child: Padding(
                  padding: padding,
                  child: Row(
                    children: [
                      _MiniMinaret(icon: icon, accent: accent, next: isNext),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PrayerInfo(
                          name: name,
                          timeText: timeText,
                          relativeText: relativeText,
                          trailing: trailing,
                          compact: compact,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerInfo extends StatelessWidget {
  const _PrayerInfo({
    required this.name,
    required this.timeText,
    required this.relativeText,
    required this.trailing,
    required this.compact,
  });

  final String name;
  final String timeText;
  final String relativeText;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: const Color(0xFF3E2C1C),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          timeText,
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFF1F130A),
            fontWeight: FontWeight.w600,
            fontSize: compact ? 18 : 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.schedule, size: 14, color: Colors.brown.withOpacity(0.7)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                relativeText,
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.brown.withOpacity(0.7)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ],
    );
  }
}

class _MiniMinaret extends StatelessWidget {
  const _MiniMinaret({required this.icon, required this.accent, required this.next});
  final IconData icon;
  final Color accent;
  final bool next;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                accent.withOpacity(0.45),
                accent.withOpacity(0.1),
              ],
            ),
            border: Border.all(color: accent.withOpacity(0.4)),
          ),
          child: Icon(icon, color: accent),
        ),
        if (next)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MosqueFramePainter extends CustomPainter {
  const _MosqueFramePainter({required this.color});
  final Color color;


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(12, size.height - 12)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.6, size.width - 12, size.height - 12);

    canvas.drawPath(path, paint);

    final domePaint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final domes = [
      Rect.fromCircle(center: Offset(size.width * 0.2, size.height * 0.35), radius: 6),
      Rect.fromCircle(center: Offset(size.width * 0.4, size.height * 0.25), radius: 8),
      Rect.fromCircle(center: Offset(size.width * 0.6, size.height * 0.3), radius: 6),
      Rect.fromCircle(center: Offset(size.width * 0.8, size.height * 0.2), radius: 7),
    ];

    for (final dome in domes) {
      canvas.drawArc(dome, 0, 3.14, false, domePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
