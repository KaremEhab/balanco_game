import 'dart:math';
import 'package:flutter/material.dart';
import '../../game/components/ball_component.dart';

class MapBallLayer extends CustomPainter {
  final Offset position;
  final double scale;
  final double squashScaleX;
  final double squashScaleY;
  final double rotation;
  final double radius;

  // Paints
  final Paint _basePaint = Paint()..color = Colors.redAccent;
  final Paint _dropShadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.5)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
  final Paint _stripePaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.7)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  late final Paint _highlightPaint;
  final Paint _borderPaint = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  MapBallLayer({
    required this.position,
    required this.scale,
    this.squashScaleX = 1.0,
    this.squashScaleY = 1.0,
    required this.rotation,
    this.radius = 16.0, // Base map ball radius
  }) {
    _highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
        colors: [
          Colors.white.withValues(alpha: 0.6),
          Colors.transparent,
          Colors.black.withValues(alpha: 0.6),
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(
        Rect.fromCircle(center: Offset.zero, radius: radius),
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (scale <= 0) return;

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.scale(scale * squashScaleX, scale * squashScaleY);

    // Drop shadow
    canvas.save();
    canvas.translate(4.0, 8.0); // shadow offset
    canvas.scale(1.0, 0.5);
    canvas.drawCircle(Offset.zero, radius, _dropShadowPaint);
    canvas.restore();

    // Draw rotating BallPainter graphic from gameplay
    canvas.save();
    canvas.rotate(rotation);

    // Scale BallPainter (41.46x42.056) to fit within radius * 2
    double ballScale = (radius * 2) / 42.0;
    canvas.scale(ballScale, ballScale);
    canvas.translate(-20.73, -21.028);

    BallPainter().paint(canvas, const Size(42.0, 42.0));
    canvas.restore();

    // 3D Highlight
    canvas.drawCircle(Offset.zero, radius, _highlightPaint);

    // Border
    canvas.drawCircle(Offset.zero, radius, _borderPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapBallLayer oldDelegate) {
    return oldDelegate.position != position ||
           oldDelegate.scale != scale ||
           oldDelegate.squashScaleX != squashScaleX ||
           oldDelegate.squashScaleY != squashScaleY ||
           oldDelegate.rotation != rotation;
  }
}
