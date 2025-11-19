import 'package:flutter/material.dart';
import 'dart:math' as math;

class IslamicMedallion extends StatelessWidget {
  const IslamicMedallion({super.key, required this.number, this.size = 28});
  final int number;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
      painter: _StarPainter(
        stroke: theme.colorScheme.primary,
        fill: theme.colorScheme.primaryContainer,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            '$number',
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.stroke, required this.fill});
  final Color stroke;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r1 = w * 0.48; // outer radius
    final r2 = w * 0.24; // inner radius

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final aOuter = (i * 45.0 - 22.5) * math.pi / 180.0;
      final aInner = (i * 45.0 + 22.5) * math.pi / 180.0;
      final x1 = cx + r1 * math.cos(aOuter);
      final y1 = cy + r1 * math.sin(aOuter);
      final x2 = cx + r2 * math.cos(aInner);
      final y2 = cy + r2 * math.sin(aInner);
      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();

    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
