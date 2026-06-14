import 'package:flutter/material.dart';

class MapBallLayer extends CustomPainter {
  final Offset position;
  final double scale;
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
    canvas.scale(scale, scale);

    // Drop shadow
    canvas.save();
    canvas.translate(4.0, 8.0); // shadow offset
    canvas.scale(1.0, 0.5);
    canvas.drawCircle(Offset.zero, radius, _dropShadowPaint);
    canvas.restore();

    // Base color
    canvas.drawCircle(Offset.zero, radius, _basePaint);

    // Rotating stripes
    canvas.save();
    canvas.rotate(rotation);
    canvas.drawLine(
      Offset(-radius, 0),
      Offset(radius, 0),
      _stripePaint,
    );
    canvas.drawLine(
      Offset(0, -radius),
      Offset(0, radius),
      _stripePaint,
    );
    canvas.drawCircle(Offset.zero, radius * 0.4, _stripePaint);
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
           oldDelegate.rotation != rotation;
  }
}
