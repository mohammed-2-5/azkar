import 'package:flutter/material.dart';

class IslamicLabel extends StatelessWidget {
  const IslamicLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surface,
        shape: StadiumBorder(
          side: BorderSide(color: theme.colorScheme.primary, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Crescent(color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          _Crescent(color: theme.colorScheme.primary, flipped: true),
        ],
      ),
    );
  }
}

class _Crescent extends StatelessWidget {
  const _Crescent({required this.color, this.flipped = false});
  final Color color;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(14, 14),
      painter: _CrescentPainter(color, flipped: flipped),
    );
  }
}

class _CrescentPainter extends CustomPainter {
  _CrescentPainter(this.color, {required this.flipped});
  final Color color;
  final bool flipped;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withAlpha(180);
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);
    final dx = flipped ? -size.width * 0.18 : size.width * 0.18;
    canvas.drawCircle(
      center.translate(dx, 0),
      size.width / 2.2,
      Paint()..blendMode = BlendMode.clear,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
