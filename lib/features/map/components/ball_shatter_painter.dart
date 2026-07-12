import 'dart:math';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';

/// Draws the ball as shattered wedge shards flying outward.
/// [progress] goes from 0.0 (fully intact) to 1.0 (fully scattered).
class BallShatterPainter extends CustomPainter {
  final double progress;
  final BiomeModel biome;
  final double radius;

  static const int _shardCount = 8;

  // Pre-baked per-shard multipliers so every run looks the same
  static const List<double> _flyMultipliers = [
    1.0,
    1.3,
    0.9,
    1.4,
    1.1,
    0.8,
    1.2,
    1.0,
  ];
  static const List<double> _spinMultipliers = [
    0.4,
    -0.6,
    0.7,
    -0.5,
    0.9,
    -0.4,
    0.6,
    -0.8,
  ];

  const BallShatterPainter({
    required this.progress,
    required this.biome,
    this.radius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final sweepAngle = (2 * pi / _shardCount) - 0.06;
    final maxFly = radius * 4.5;

    // Flash at center
    if (progress < 0.3) {
      final flashProgress = 1.0 - (progress / 0.3);
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: flashProgress * 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, radius * (0.5 + progress * 2), flashPaint);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < _shardCount; i++) {
      final startAngle = (2 * pi * i) / _shardCount;
      final midAngle = startAngle + sweepAngle / 2;

      final flyDist = maxFly * progress * _flyMultipliers[i];
      final spin = progress * _spinMultipliers[i] * pi;

      canvas.save();
      canvas.translate(cos(midAngle) * flyDist, sin(midAngle) * flyDist);
      canvas.rotate(spin);

      final innerR = radius * 0.15;
      final outerR = radius * (1.0 - progress * 0.2);

      final path = Path()
        ..moveTo(cos(startAngle) * innerR, sin(startAngle) * innerR)
        ..arcTo(
          Rect.fromCircle(center: Offset.zero, radius: outerR),
          startAngle,
          sweepAngle,
          false,
        )
        ..lineTo(
          cos(startAngle + sweepAngle) * innerR,
          sin(startAngle + sweepAngle) * innerR,
        )
        ..arcTo(
          Rect.fromCircle(center: Offset.zero, radius: innerR),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        )
        ..close();

      final baseColor = i.isEven ? biome.primaryColor : biome.secondaryColor;

      canvas.drawPath(
        path,
        Paint()
          ..color = baseColor.withValues(alpha: opacity)
          ..style = PaintingStyle.fill,
      );

      final highlightGradient = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.8,
        colors: [
          Colors.white.withValues(alpha: opacity * 0.55),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: outerR));

      canvas.drawPath(
        path,
        Paint()
          ..shader = highlightGradient
          ..style = PaintingStyle.fill,
      );

      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: opacity * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(BallShatterPainter old) => old.progress != progress;
}
