import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A subtle Islamic geometric pattern painter used as an overlay background.
class IslamicPattern extends StatelessWidget {
  const IslamicPattern({super.key, required this.opacity, this.color = Colors.white});
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: CustomPaint(
        painter: _PatternPainter(color.withOpacity(opacity)),
        size: Size.infinite,
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color;

    final double tile = 28;
    final starR = tile * 0.35;
    for (double y = 0; y < size.height + tile; y += tile) {
      for (double x = 0; x < size.width + tile; x += tile) {
        _drawEightPointStar(canvas, Offset(x, y), starR, paint);
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Offset c, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final a = (math.pi / 4) * i;
      final px = c.dx + math.cos(a) * r;
      final py = c.dy + math.sin(a) * r;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) => oldDelegate.color != color;
}

