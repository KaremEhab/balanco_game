import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class ShieldIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path shieldPath = Path();
    double cx = size.width / 2;
    double cy = size.height / 2;

    // We want the icon to take up the majority of the provided size
    double w = size.width * 0.8;
    double h = size.height * 0.9;

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
