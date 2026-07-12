import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SplashLoadingBarPainter extends CustomPainter {
  const SplashLoadingBarPainter({
    required this.progress,
    required this.shimmer,
  });

  final double progress;
  final double shimmer;

  @override
  void paint(Canvas canvas, Size size) {
    // Elegant, thin, rounded glowing progress bar
    final barHeight = 12.0;
    final barRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.9,
      height: barHeight,
    );

    final track = RRect.fromRectAndRadius(barRect, Radius.circular(barHeight / 2));

    // Outer glow / shadow
    canvas.drawRRect(
      track,
      Paint()
        ..color = const Color(0x66004B6B)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Track Background
    canvas.drawRRect(
      track,
      Paint()
        ..shader = ui.Gradient.linear(
          barRect.topCenter,
          barRect.bottomCenter,
          const [Color(0xFF021B35), Color(0xFF083C5C)],
        ),
    );

    final value = progress.clamp(0.0, 1.0);
    if (value > 0) {
      final fillWidth = barRect.width * value;
      final fillRect = Rect.fromLTWH(barRect.left, barRect.top, fillWidth, barHeight);
      final fillRRect = RRect.fromRectAndRadius(fillRect, Radius.circular(barHeight / 2));

      // Fill Gradient
      canvas.drawRRect(
        fillRRect,
        Paint()
          ..shader = ui.Gradient.linear(
            fillRect.centerLeft,
            fillRect.centerRight,
            const [Color(0xFF00E5FF), Color(0xFF007BFF), Color(0xFF00E5FF)],
            const [0.0, 0.5, 1.0],
          ),
      );

      // Inner Gloss
      final glossRect = Rect.fromLTWH(fillRect.left + 2, fillRect.top + 2, fillWidth - 4, barHeight * 0.4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(glossRect, Radius.circular(glossRect.height / 2)),
        Paint()..color = const Color(0x55FFFFFF),
      );

      // Shimmer effect
      if (shimmer > 0) {
        final glintX = barRect.left + (barRect.width * shimmer);
        canvas.save();
        canvas.clipRRect(fillRRect);
        canvas.drawRect(
          Rect.fromCenter(center: Offset(glintX, barRect.center.dy), width: 40, height: barHeight * 2),
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(glintX - 20, 0),
              Offset(glintX + 20, 0),
              const [Color(0x00FFFFFF), Color(0xDDFFFFFF), Color(0x00FFFFFF)],
            )
            ..blendMode = BlendMode.overlay,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(SplashLoadingBarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.shimmer != shimmer;
}
