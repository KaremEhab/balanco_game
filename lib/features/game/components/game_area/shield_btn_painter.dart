import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class ShieldBtnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;

    // 1. Drop Shadow
    final Paint shadowPaint = Paint()
      ..color = GameColors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.translate(0, 4), const Radius.circular(16)),
      shadowPaint,
    );

    // 2. Glossy Button Base (Cyan/Teal)
    final Paint basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          // use light blue color combo
          GameColors.amber300, // Highlight
          GameColors.amber400, // Base
          GameColors.magnetPainterColor9, // Mid
          GameColors.amber800, // Shadow
        ],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      basePaint,
    );

    // 3. Inner Gloss/Specular
    Rect innerRect = rect.deflate(2);
    final Paint glossPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [GameColors.magnetPainterColor1, GameColors.whiteTransparent],
      ).createShader(innerRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, const Radius.circular(14)),
      glossPaint,
    );

    // 4. Shield Icon (Orange/White glowing)
    Path shieldPath = Path();
    double cx = size.width / 2;
    double cy = size.height / 2;
    double w = size.width * 0.45;
    double h = size.height * 0.55;

    shieldPath.moveTo(cx, cy - h / 2);
    shieldPath.lineTo(cx + w / 2, cy - h / 2 + h * 0.1);
    shieldPath.lineTo(cx + w / 2, cy + h * 0.1);
    shieldPath.quadraticBezierTo(cx + w / 2, cy + h * 0.4, cx, cy + h / 2);
    shieldPath.quadraticBezierTo(
      cx - w / 2,
      cy + h * 0.4,
      cx - w / 2,
      cy + h * 0.1,
    );
    shieldPath.lineTo(cx - w / 2, cy - h / 2 + h * 0.1);
    shieldPath.close();

    final Paint iconShadow = Paint()
      ..color = GameColors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(shieldPath.shift(const Offset(0, 2)), iconShadow);

    final Paint iconPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          Color.fromARGB(255, 197, 233, 255),
          Color.fromARGB(255, 40, 198, 255),
          Color.fromARGB(255, 0, 85, 255),
        ],
      ).createShader(shieldPath.getBounds());
    canvas.drawPath(shieldPath, iconPaint);

    // Inner shield glow
    final Paint iconStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = GameColors.white.withValues(alpha: 0.8);
    canvas.drawPath(shieldPath, iconStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
