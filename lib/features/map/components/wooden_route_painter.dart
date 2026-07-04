import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class WoodenRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double plankHeight = 16.0;
    final double gap = 4.0;
    final double step = plankHeight + gap;

    // Draw the two vertical supporting ropes/rails
    final Paint ropePaint = Paint()
      ..color = GameColors
          .routePainterSand // Light sandy rope color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final Paint ropeShadowPaint = Paint()
      ..color = GameColors.black.withValues(alpha: 0.4)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    // Ropes shadow
    canvas.drawLine(Offset(6, 0), Offset(6, size.height), ropeShadowPaint);
    canvas.drawLine(
      Offset(size.width - 6, 0),
      Offset(size.width - 6, size.height),
      ropeShadowPaint,
    );

    // Ropes
    canvas.drawLine(Offset(4, 0), Offset(4, size.height), ropePaint);
    canvas.drawLine(
      Offset(size.width - 4, 0),
      Offset(size.width - 4, size.height),
      ropePaint,
    );

    // Wood colors
    final Paint woodBase = Paint()
      ..color = GameColors.routePainterColor3; // Rich warm wood
    final Paint woodHighlight = Paint()
      ..color = GameColors.routePainterColor4; // Top edge light
    final Paint woodShadow = Paint()
      ..color = GameColors.routePainterColor2; // Bottom edge dark
    final Paint nailPaint = Paint()
      ..color = GameColors.routePainterColor1; // Dark nails

    // Draw repeating wooden planks
    for (double y = 0; y < size.height; y += step) {
      // The plank rectangle (slightly overlapping the ropes)
      final Rect plankRect = Rect.fromLTWH(2, y, size.width - 4, plankHeight);

      // Plank base with rounded corners
      canvas.drawRRect(
        RRect.fromRectAndRadius(plankRect, const Radius.circular(3)),
        woodBase,
      );

      // Top highlight for 3D effect
      canvas.drawLine(
        Offset(plankRect.left + 3, plankRect.top + 2),
        Offset(plankRect.right - 3, plankRect.top + 2),
        woodHighlight..strokeWidth = 1.5,
      );

      // Bottom shadow for depth
      canvas.drawLine(
        Offset(plankRect.left + 3, plankRect.bottom - 2),
        Offset(plankRect.right - 3, plankRect.bottom - 2),
        woodShadow..strokeWidth = 1.5,
      );

      // Iron nails
      canvas.drawCircle(
        Offset(plankRect.left + 6, plankRect.center.dy),
        2.0,
        nailPaint,
      );
      canvas.drawCircle(
        Offset(plankRect.right - 6, plankRect.center.dy),
        2.0,
        nailPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
