import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/theme/theme_tokens.dart';

class DecoratedHeader extends StatelessWidget {
  const DecoratedHeader({
    super.key,
    required this.height,
    required this.title,
    this.subtitle,
    this.child,
  });

  final double height;
  final String title;
  final String? subtitle;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: ThemeTokens.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Optional overlay image (mosque/minaret), if provided in assets.
          // Add your own image at assets/images/mosque_header.png
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.15),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          // Silhouette of mosque skyline
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _MosqueSilhouettePainter(color: Colors.black.withOpacity(0.15)),
            ),
          ),
          // Subtle blur panel for texts
          Positioned(
            left: 16,
            right: 16,
            top: 24 + MediaQuery.of(context).padding.top,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.all(16),
                 // color: Colors.white.withOpacity(0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(subtitle!, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class DecoratedBackgroundFill extends StatelessWidget {
  const DecoratedBackgroundFill({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: ThemeTokens.heroGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.25,
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.15),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomPaint(
            size: const Size(double.infinity, 160),
            painter: _MosqueSilhouettePainter(color: Colors.black.withOpacity(0.15)),
          ),
        ),
      ],
    );
  }
}

class _MosqueSilhouettePainter extends CustomPainter {
  _MosqueSilhouettePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final h = size.height;
    final w = size.width;

    Path dome(double x, double baseY, double radius) {
      final p = Path();
      p.moveTo(x - radius, baseY);
      p.quadraticBezierTo(x, baseY - radius * 1.2, x + radius, baseY);
      p.close();
      return p;
    }

    void minaret(double x, double baseY, double height, double width) {
      final rect = Rect.fromLTWH(x - width / 2, baseY - height, width, height);
      canvas.drawRect(rect, paint);
      canvas.drawCircle(Offset(x, baseY - height - width * 0.3), width * 0.6, paint);
    }

    // Ground
    final ground = Rect.fromLTWH(0, h - 24, w, 24);
    canvas.drawRect(ground, paint);

    // Central mosque body
    final baseY = h - 24;
    canvas.drawPath(dome(w * 0.35, baseY, 36), paint);
    canvas.drawPath(dome(w * 0.55, baseY, 44), paint);
    canvas.drawPath(dome(w * 0.75, baseY, 28), paint);
    canvas.drawPath(dome(w * 0.20, baseY, 24), paint);

    // Minarets
    minaret(w * 0.12, baseY, 70, 10);
    minaret(w * 0.30, baseY, 60, 8);
    minaret(w * 0.68, baseY, 80, 10);
    minaret(w * 0.88, baseY, 65, 8);
  }

  @override
  bool shouldRepaint(covariant _MosqueSilhouettePainter oldDelegate) => oldDelegate.color != color;
}
