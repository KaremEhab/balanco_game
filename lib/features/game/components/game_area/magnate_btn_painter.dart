import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/components/game_area/magnate_painter.dart';

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
          Color(0xFFFFE082), // Highlight
          Color(0xFFFFCA28), // Base
          Color(0xFFFFB300), // Mid
          Color(0xFFFF8F00), // Shadow
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

    // 4. Magnet Icon (Using custom MagnatePainter)
    canvas.save();

    // The visual bounds of the magnet inside MagnatePainter
    // X ranges from ~1.0 to ~33.0 (width ~ 32.0)
    // Y ranges from ~20.0 to ~53.0 (height ~ 33.0)
    const double visualW = 32.0;
    const double visualCX = 17.0;
    const double visualCY = 36.5;

    // We want the icon to take up about 60% of the button's size
    double targetIconSize = size.width * 0.60;

    double iconScale = targetIconSize / visualW;

    // Center icon perfectly based on its visual center
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(iconScale, iconScale);
    canvas.translate(-visualCX, -visualCY);

    MagnatePainter().paint(canvas, const Size(100, 100));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
