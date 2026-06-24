import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShieldBtnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;

    // 1. Drop Shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
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
          Color(0xFF80DEEA), // Highlight
          Color(0xFF00BCD4), // Base
          Color(0xFF0097A7), // Mid
          Color(0xFF004D40), // Shadow
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
        colors: [Color(0x99FFFFFF), Color(0x00FFFFFF)],
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
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(shieldPath.shift(const Offset(0, 2)), iconShadow);

    final Paint iconPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFFFB74D), Color(0xFFF57C00)],
      ).createShader(shieldPath.getBounds());
    canvas.drawPath(shieldPath, iconPaint);

    // Inner shield glow
    final Paint iconStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.8);
    canvas.drawPath(shieldPath, iconStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
