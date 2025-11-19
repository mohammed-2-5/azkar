import 'dart:math' as math;

import 'package:flutter/material.dart';

class IslamicFrame extends StatelessWidget {
  const IslamicFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _FramePainter(Theme.of(context).colorScheme),
          child: Padding(padding: padding, child: child),
        );
      },
    );
  }
}

class _FramePainter extends CustomPainter {
  _FramePainter(this.scheme);
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    final inner = outer.deflate(10);

    final border1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = scheme.primary;
    final border2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = scheme.outlineVariant;

    // Soft background wash
    final wash = Paint()
      ..style = PaintingStyle.fill
      ..color = scheme.surfaceContainerHigh.withValues(alpha: 0.25);
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer.inflate(6), const Radius.circular(18)),
      wash,
    );

    // Borders
    canvas.drawRRect(
      RRect.fromRectAndRadius(outer, const Radius.circular(14)),
      border1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(inner, const Radius.circular(10)),
      border2,
    );

    // Corner ornaments (8-point star/rosette)
    final starSize = 18.0;
    final corners = <Offset>[
      Offset(outer.left + 4, outer.top + 4),
      Offset(outer.right - 4, outer.top + 4),
      Offset(outer.right - 4, outer.bottom - 4),
      Offset(outer.left + 4, outer.bottom - 4),
    ];
    for (var i = 0; i < corners.length; i++) {
      final c = corners[i];
      final path = _starPath(
        center: c,
        rOuter: starSize,
        rInner: starSize * .52,
      );
      // Fill + stroke
      final fill = Paint()..color = scheme.primaryContainer;
      canvas.save();
      // Position star fully inside the frame
      canvas.translate(
        i == 1 || i == 2 ? -starSize : starSize,
        i >= 2 ? -starSize : starSize,
      );
      canvas.drawPath(path, fill);
      canvas.drawPath(path, border1);
      canvas.restore();
    }
  }

  Path _starPath({
    required Offset center,
    required double rOuter,
    required double rInner,
  }) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final aOuter = (i * 45.0 - 22.5) * math.pi / 180.0;
      final aInner = (i * 45.0 + 22.5) * math.pi / 180.0;
      final p1 = Offset(
        center.dx + rOuter * math.cos(aOuter),
        center.dy + rOuter * math.sin(aOuter),
      );
      final p2 = Offset(
        center.dx + rInner * math.cos(aInner),
        center.dy + rInner * math.sin(aInner),
      );
      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.lineTo(p2.dx, p2.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
