import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'dart:ui' as ui;
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';

class WoodenRoutePainter extends CustomPainter {
  final double transitionY;
  final double transitionRange;
  final int totalLevels;

  WoodenRoutePainter({
    this.transitionY = -1.0,
    this.transitionRange = 200.0,
    this.totalLevels = 500,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double plankHeight = 16.0;
    final double gap = 4.0;
    final double step = plankHeight + gap;

    // --- Ropes ---
    final Paint ropeShadowPaint = Paint()
      ..color = GameColors.black.withValues(alpha: 0.4)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(6, 0), Offset(6, size.height), ropeShadowPaint);
    canvas.drawLine(
      Offset(size.width - 6, 0),
      Offset(size.width - 6, size.height),
      ropeShadowPaint,
    );

    Paint ropePaint = Paint()
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    ropePaint.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.height),
      _routeGradientColors(),
      _routeGradientStops(),
    );

    canvas.drawLine(Offset(4, 0), Offset(4, size.height), ropePaint);
    canvas.drawLine(
      Offset(size.width - 4, 0),
      Offset(size.width - 4, size.height),
      ropePaint,
    );

    final ui.Gradient baseShader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.height),
      _gradientColors((b) => b.pathColor),
      _routeGradientStops(),
    );
    final ui.Gradient highlightShader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.height),
      _gradientColors((b) => b.nodeUnlockedColor),
      _routeGradientStops(),
    );
    final ui.Gradient shadowShader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.height),
      _gradientColors((b) => b.primaryColor),
      _routeGradientStops(),
    );
    final ui.Gradient nailShader = ui.Gradient.linear(
      Offset.zero,
      Offset(0, size.height),
      _gradientColors((b) => b.nodeUnlockedBorderColor),
      _routeGradientStops(),
    );

    final Paint woodBase = Paint()..shader = baseShader;
    final Paint woodHighlight = Paint()..shader = highlightShader;
    final Paint woodShadow = Paint()..shader = shadowShader;
    final Paint nailPaint = Paint()..shader = nailShader;

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

  List<Color> _gradientColors(Color Function(BiomeModel) selector) {
    final colors = <Color>[];
    for (final biome in BiomeConfig.biomes.reversed) {
      colors.add(selector(biome));
      colors.add(selector(biome));
    }
    return colors;
  }

  List<Color> _routeGradientColors() {
    return _gradientColors((b) => b.pathColor);
  }

  List<double> _routeGradientStops() {
    if (BiomeConfig.biomes.length == 1) return const [0.0, 1.0];
    final stops = <double>[];
    for (final biome in BiomeConfig.biomes.reversed) {
      final double progressStart = (biome.startLevel - 1) / (totalLevels - 1);
      final double progressEnd = (biome.endLevel - 1) / (totalLevels - 1);
      
      stops.add((1.0 - progressEnd).clamp(0.0, 1.0));
      stops.add((1.0 - progressStart).clamp(0.0, 1.0));
    }
    
    // Sort just in case, though they should be generally ordered
    stops.sort();
    return stops;
  }
}
