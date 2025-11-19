import 'package:flutter/material.dart';

class OrnamentPainter extends CustomPainter {
  OrnamentPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(12, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.1,
        size.width - 12,
        size.height * 0.3,
      );
    canvas.drawPath(path, paint);

    final base = size.height - 16;
    final wave = Path()
      ..moveTo(12, base)
      ..lineTo(size.width * 0.25, base - 10)
      ..lineTo(size.width * 0.5, base)
      ..lineTo(size.width * 0.75, base - 10)
      ..lineTo(size.width - 12, base);
    canvas.drawPath(wave, paint);

    for (var i = 0; i < 4; i++) {
      final center = Offset(size.width * (0.2 + i * 0.2), size.height * 0.2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: 8),
        0.5,
        2.1,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
