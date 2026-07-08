import 'dart:math';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:flutter/material.dart';

class CartoonStar extends StatelessWidget {
  final double size;
  final bool isCollected;

  const CartoonStar({super.key, required this.size, required this.isCollected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: CartoonStarPainter(isCollected: isCollected)),
    );
  }
}

class CartoonStarPainter extends CustomPainter {
  final bool isCollected;

  CartoonStarPainter({required this.isCollected});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    // We make the radius slightly smaller than w/2 to leave room for the thick stroke
    final double strokeWidth = w * 0.18;
    final double outerRadius = (w / 2) - (strokeWidth / 2);
    final double innerRadius = outerRadius * 0.45; // Puffy cartoon proportions

    final Path starPath = Path();
    const int points = 5;
    const double angleOffset = -pi / 2;

    for (int i = 0; i < points * 2; i++) {
      double radius = i.isEven ? outerRadius : innerRadius;
      double angle = angleOffset + (i * pi / points);

      double x = cx + cos(angle) * radius;
      double y = cy + sin(angle) * radius;

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    // 1. Shadow (Optional but adds to cartoon depth)
    final Paint shadowPaint = Paint()
      ..color = GameColors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.translate(0, h * 0.1); // Drop shadow down slightly
    canvas.drawPath(starPath, shadowPaint);
    canvas.restore();

    // 2. Thick Outline
    final Paint outlinePaint = Paint()
      ..color = isCollected
          ? const Color(0xFF7A4A1B)
          : GameColors.mapScreenColor3.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(starPath, outlinePaint);

    // 3. Fill
    final Paint fillPaint = Paint()
      ..color = isCollected
          ? const Color(0xFFFFD54F)
          : GameColors.mapScreenColor3
      ..style = PaintingStyle.fill;

    canvas.drawPath(starPath, fillPaint);

    // 4. Highlight (Inner reflection)
    if (isCollected) {
      final Paint highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      // Draw a small bright circle/oval at the top-left of the center
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - w * 0.15, cy - h * 0.15),
          width: w * 0.2,
          height: h * 0.15,
        ),
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CartoonStarPainter oldDelegate) {
    return oldDelegate.isCollected != isCollected;
  }
}
