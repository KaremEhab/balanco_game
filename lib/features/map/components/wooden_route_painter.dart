import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'dart:ui' as ui;
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';

class WoodenRoutePainter extends CustomPainter {
  final double transitionY;
  final double transitionRange;

  WoodenRoutePainter({
    this.transitionY = -1.0,
    this.transitionRange = 200.0,
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
    canvas.drawLine(Offset(size.width - 6, 0), Offset(size.width - 6, size.height), ropeShadowPaint);

    // If transitionY is set, draw ropes with a gradient!
    Paint ropePaint = Paint()
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
      
    if (transitionY > 0) {
      ropePaint.shader = ui.Gradient.linear(
        Offset(0, transitionY - transitionRange),
        Offset(0, transitionY + transitionRange),
        [
          BiomeConfig.crystalCave.pathColor, // Crystal Cave top
          BiomeConfig.tropicalBeach.pathColor, // Beach bottom
        ],
      );
    } else {
      ropePaint.color = BiomeConfig.tropicalBeach.pathColor;
    }

    canvas.drawLine(Offset(4, 0), Offset(4, size.height), ropePaint);
    canvas.drawLine(Offset(size.width - 4, 0), Offset(size.width - 4, size.height), ropePaint);

    // Draw repeating wooden planks
    for (double y = 0; y < size.height; y += step) {
      // Calculate Biome mix for this specific plank
      double p = 0.0;
      if (transitionY > 0) {
        if (y < transitionY - transitionRange) {
          p = 1.0; // Fully Crystal Cave
        } else if (y > transitionY + transitionRange) {
          p = 0.0; // Fully Beach
        } else {
          // Inside transition range
          p = 1.0 - ((y - (transitionY - transitionRange)) / (transitionRange * 2));
        }
      }

      // Base biome colors
      BiomeModel currentBiome = BiomeModel.lerp(
        BiomeConfig.tropicalBeach,
        BiomeConfig.crystalCave,
        p,
      );

      Color woodBaseColor = currentBiome.pathColor;
      Color woodHighlightColor = currentBiome.nodeUnlockedColor;
      Color woodShadowColor = currentBiome.primaryColor;
      Color nailColor = currentBiome.nodeUnlockedBorderColor;

      final Paint woodBase = Paint()..color = woodBaseColor;
      final Paint woodHighlight = Paint()..color = woodHighlightColor;
      final Paint woodShadow = Paint()..color = woodShadowColor;
      final Paint nailPaint = Paint()..color = nailColor;
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
}
