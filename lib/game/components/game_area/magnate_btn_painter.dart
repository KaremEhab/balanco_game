

import 'package:flutter/material.dart';

class MagnateBtnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;

    // 1. Drop Shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.translate(0, 4), const Radius.circular(16)),
      shadowPaint,
    );

    // 2. Glossy Button Base (Orange)
    final Paint basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFF3E0), // Highlight
          Color(0xFFFFB74D), // Base
          Color(0xFFF57C00), // Mid
          Color(0xFFE65100), // Shadow
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

    // 4. Magnet Icon (Metallic/Cyan)
    double cx = size.width / 2;
    double cy = size.height / 2;
    double w = size.width * 0.45;
    double h = size.height * 0.5;

    // Outer Horseshoe
    Path magPath = Path();
    magPath.moveTo(cx - w / 2, cy + h / 2);
    magPath.lineTo(cx - w / 2, cy);
    magPath.arcToPoint(
      Offset(cx + w / 2, cy),
      radius: Radius.circular(w / 2),
      clockwise: true,
    );
    magPath.lineTo(cx + w / 2, cy + h / 2);
    magPath.lineTo(cx + w / 4, cy + h / 2);
    magPath.lineTo(cx + w / 4, cy);
    magPath.arcToPoint(
      Offset(cx - w / 4, cy),
      radius: Radius.circular(w / 4),
      clockwise: false,
    );
    magPath.lineTo(cx - w / 4, cy + h / 2);
    magPath.close();

    final Paint iconShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(magPath.shift(const Offset(0, 2)), iconShadow);

    final Paint iconPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F7FA), Color(0xFF00BCD4), Color(0xFF006064)],
      ).createShader(magPath.getBounds());
    canvas.drawPath(magPath, iconPaint);

    // Magnet Poles (Red/Dark Red)
    Rect leftPole = Rect.fromLTRB(
      cx - w / 2,
      cy + h / 2 - h * 0.2,
      cx - w / 4,
      cy + h / 2,
    );
    Rect rightPole = Rect.fromLTRB(
      cx + w / 4,
      cy + h / 2 - h * 0.2,
      cx + w / 2,
      cy + h / 2,
    );
    final Paint polePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF5252), Color(0xFFB71C1C)],
      ).createShader(leftPole);

    canvas.drawRect(leftPole, polePaint);
    canvas.drawRect(rightPole, polePaint);

    // Inner outline
    final Paint iconStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawPath(magPath, iconStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
