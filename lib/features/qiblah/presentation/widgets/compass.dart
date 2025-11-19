import 'dart:math' as math;
import 'package:flutter/material.dart';

class QiblahCompass extends StatelessWidget {
  const QiblahCompass({super.key, required this.heading, required this.qiblah});
  final double heading;
  final double qiblah;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _CompassPainter(heading: heading, qiblah: qiblah),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  _CompassPainter({required this.heading, required this.qiblah});
  final double heading;
  final double qiblah;

  double get _deg2Rad => math.pi / 180;
  double _toCanvasAngle(double bearing) => (bearing - 90) * _deg2Rad;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final canvasRadius = size.shortestSide / 2;
    const circlePadding = 30.0;
    final circleRadius = canvasRadius - circlePadding;

    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: circleRadius));
    canvas.drawCircle(center, circleRadius, bgPaint);

    final outerStroke = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, circleRadius - 6, outerStroke);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final tickRadius = circleRadius - 10;
    final labelRadius = circleRadius - 30;
    final pointerRadius = circleRadius - 34;

    _drawTicks(canvas, tickRadius);
    _drawDirectionLabels(canvas, labelRadius);
    _drawKaabaMarker(canvas, circleRadius + 12);
    _drawHeadingPointer(canvas, pointerRadius);

    canvas.restore();
  }

  void _drawTicks(Canvas canvas, double radius) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 360; i += 5) {
      final length = (i % 30 == 0) ? 14.0 : 7.0;
      final angle = _toCanvasAngle(i.toDouble());
      final p1 = Offset(math.cos(angle) * (radius - length), math.sin(angle) * (radius - length));
      final p2 = Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _drawDirectionLabels(Canvas canvas, double radius) {
    const directions = <String, double>{
      'N': 0,
      'NE': 45,
      'E': 90,
      'SE': 135,
      'S': 180,
      'SW': 225,
      'W': 270,
      'NW': 315,
    };
    directions.forEach((text, angleDeg) {
      final angle = _toCanvasAngle(angleDeg);
      final pos = Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, pos - Offset(painter.width / 2, painter.height / 2));
    });
  }

  void _drawKaabaMarker(Canvas canvas, double distance) {
    final angle = _toCanvasAngle(qiblah);
    final position = Offset(math.cos(angle) * distance, math.sin(angle) * distance);
    final markerPaint = Paint()
      ..color = const Color(0xFFF4E4B2)
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rect = Rect.fromCenter(center: position, width: 20, height: 20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      markerPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      border,
    );

    final connectorPaint = Paint()
      ..color = const Color(0xFFF4E4B2).withOpacity(0.7)
      ..strokeWidth = 2;
    canvas.drawLine(Offset.zero, position, connectorPaint);
  }

  void _drawHeadingPointer(Canvas canvas, double radius) {
    final angle = _toCanvasAngle(heading);
    final dir = Offset(math.cos(angle), math.sin(angle));
    final tip = dir * (radius - 12);
    final base = Offset.zero;

    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..lineTo(tip.dx, tip.dy);
    final paint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = Colors.greenAccent;
    canvas.drawPath(path, paint);

    canvas.drawCircle(tip, 7, Paint()..color = Colors.white);
    canvas.drawCircle(tip, 5, Paint()..color = Colors.greenAccent);
  }

  @override
  bool shouldRepaint(_CompassPainter oldDelegate) {
    return oldDelegate.heading != heading || oldDelegate.qiblah != qiblah;
  }
}
