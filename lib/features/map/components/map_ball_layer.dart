import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:balanco_game/features/game/components/ball_component.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';

class MapBallLayer extends CustomPainter {
  final Offset position;
  final double scale;
  final double squashScaleX;
  final double squashScaleY;
  final double rotation;
  final double radius;
  final double ballOffsetY; // Separate offset for the ball jumping
  final bool drawPlatform;
  final bool drawBall;
  final bool isLocked;
  final BiomeModel biome;
  final BiomeModel? platformBiome;
  final double ballOpacity;
  final double ballScaleModifier;
  final double platformTransitionProgress; // 0→1: lava crack wipe of new color
  final BiomeModel? platformNewBiome; // the incoming biome color

  // Paints
  final Paint _dropShadowPaint = Paint()
    ..color = GameColors.black.withValues(alpha: 0.5)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
  late final Paint _highlightPaint;
  final Paint _borderPaint = Paint()
    ..color = GameColors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  MapBallLayer({
    required this.position,
    required this.scale,
    this.squashScaleX = 1.0,
    this.squashScaleY = 1.0,
    required this.rotation,
    this.radius = 16.0, // Base map ball radius
    this.ballOffsetY = 0.0,
    this.drawPlatform = true,
    this.drawBall = true,
    this.isLocked = false,
    required this.biome,
    this.platformBiome,
    this.ballOpacity = 1.0,
    this.ballScaleModifier = 1.0,
    this.platformTransitionProgress = 0.0,
    this.platformNewBiome,
  }) {
    _highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
        colors: [
          GameColors.white.withValues(alpha: 0.6),
          Colors.transparent,
          GameColors.black.withValues(alpha: 0.6),
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
  }

  void _drawPlatform(Canvas canvas) {
    if (isLocked) {
      final paint = Paint()
        ..colorFilter = const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
      canvas.saveLayer(null, paint);
    }

    // Platform coordinates
    // Top face (trapezoid to give 3D perspective)
    final double backY = -6.0;
    final double frontY = 8.0;
    final double backW = 38.0; // Half width at the back
    final double frontW = 50.0; // Half width at the front
    final double frontBottomY = 20.0; // Bottom edge of the front face
    final double cornerRadius = 4.0;

    // 1. Heavy Black Blurred Material (Shadow) on Level Button
    final Paint deepShadowPaint = Paint()
      ..color = GameColors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);

    // Draw a wide elliptical heavy shadow at the base of the platform
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, frontBottomY + 2),
        width: frontW * 2 + 20,
        height: 28,
      ),
      deepShadowPaint,
    );

    // 1.5 Solid Dark Base ("Black Container") underneath the platform
    final double baseBottomY = frontBottomY + 8.0; // 8 pixels thick
    final double baseW = frontW - 4.0; // Decrease width slightly

    final Path basePath = Path()
      ..moveTo(-baseW, frontY)
      ..lineTo(baseW, frontY)
      ..lineTo(baseW, baseBottomY - cornerRadius)
      ..quadraticBezierTo(baseW, baseBottomY, baseW - cornerRadius, baseBottomY)
      ..lineTo(-baseW + cornerRadius, baseBottomY)
      ..quadraticBezierTo(
        -baseW,
        baseBottomY,
        -baseW,
        baseBottomY - cornerRadius,
      )
      ..close();

    final Paint basePaint = Paint()
      ..color = biome.nodeUnlockedInnerColors.last
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        4.0,
      ); // Layer blur effect

    canvas.drawPath(basePath, basePaint);

    // 2. Top Face (The surface the ball bounces on)
    final Path topFacePath = Path()
      ..moveTo(-backW + cornerRadius, backY)
      ..lineTo(backW - cornerRadius, backY)
      ..quadraticBezierTo(
        backW,
        backY,
        backW + (frontW - backW) * 0.1,
        backY + (frontY - backY) * 0.1,
      ) // Top right curve
      ..lineTo(frontW - cornerRadius * 0.5, frontY - cornerRadius)
      ..quadraticBezierTo(
        frontW,
        frontY,
        frontW - cornerRadius,
        frontY,
      ) // Front right curve
      ..lineTo(-frontW + cornerRadius, frontY)
      ..quadraticBezierTo(
        -frontW,
        frontY,
        -frontW + cornerRadius * 0.5,
        frontY - cornerRadius,
      ) // Front left curve
      ..lineTo(-backW - (frontW - backW) * 0.1, backY + (frontY - backY) * 0.1)
      ..quadraticBezierTo(
        -backW,
        backY,
        -backW + cornerRadius,
        backY,
      ) // Top left curve
      ..close();

    final currentPlatformBiome = platformBiome ?? biome;

    final Paint topFacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          currentPlatformBiome.nodeUnlockedColor,
          currentPlatformBiome.nodeUnlockedBorderColor,
        ],
      ).createShader(Rect.fromLTRB(-frontW, backY, frontW, frontY));

    canvas.drawPath(topFacePath, topFacePaint);

    // 3. Front Face (The thickness of the platform)
    final Path frontFacePath = Path()
      ..moveTo(-frontW, frontY)
      ..lineTo(frontW, frontY)
      ..lineTo(frontW, frontBottomY - cornerRadius)
      ..quadraticBezierTo(
        frontW,
        frontBottomY,
        frontW - cornerRadius,
        frontBottomY,
      )
      ..lineTo(-frontW + cornerRadius, frontBottomY)
      ..quadraticBezierTo(
        -frontW,
        frontBottomY,
        -frontW,
        frontBottomY - cornerRadius,
      )
      ..close();

    final Paint frontFacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          currentPlatformBiome.nodeUnlockedBorderColor,
          currentPlatformBiome.nodeUnlockedRivetColor,
        ],
      ).createShader(Rect.fromLTRB(-frontW, frontY, frontW, frontBottomY));

    canvas.drawPath(frontFacePath, frontFacePaint);

    // 4. Metallic details: Panel lines on Top Face
    final Paint panelLine = Paint()
      ..color = GameColors.black.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw perspective lines for metal panels
    canvas.drawLine(Offset(-15, backY), Offset(-20, frontY), panelLine);
    canvas.drawLine(Offset(15, backY), Offset(20, frontY), panelLine);

    // 5. Sci-Fi Details: Glowing cyan indicator on the front edge corner
    double cx = 38;
    double cy = 13;

    // Glowing cyan dot
    final Paint glowPaint = Paint()
      ..color = GameColors.lightBlue.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    final Paint corePaint = Paint()..color = GameColors.lightBlue50;

    canvas.drawCircle(Offset(cx, cy), 3.0, glowPaint);
    canvas.drawCircle(Offset(cx, cy), 1.5, corePaint);

    // Add some "rivets" on the front face
    final Paint rivetPaint = Paint()
      ..color = GameColors.black.withValues(alpha: 0.5);
    canvas.drawCircle(Offset(-38, cy), 1.5, rivetPaint);
    canvas.drawCircle(Offset(-25, cy), 1.5, rivetPaint);
    canvas.drawCircle(Offset(25, cy), 1.5, rivetPaint);

    // 6. Highlight on the top front edge to make it pop
    final Paint edgeHighlight = Paint()
      ..color = GameColors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(-frontW + cornerRadius, frontY),
      Offset(frontW - cornerRadius, frontY),
      edgeHighlight,
    );

    if (isLocked) {
      canvas.restore();
    }
  }

  /// Draws the "lava crack" color reveal when a new biome floods in.
  /// [p] is 0→1 progress. Colors spread from center outward; glowing edge + sparks at wavefront.
  void _drawLavaCrackOverlay(Canvas canvas, BiomeModel newBiome, double p) {
    const double backY = -6.0;
    const double frontY = 8.0;
    const double backW = 38.0;
    const double frontW = 50.0;
    const double frontBottomY = 20.0;
    const double cornerRadius = 4.0;

    final double sweepX = frontW * p;

    // 1. New-color top + front face clipped to expanding centre strip
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(-sweepX, backY - 1, sweepX, frontBottomY + 1),
    );

    final topPath = Path()
      ..moveTo(-backW + cornerRadius, backY)
      ..lineTo(backW - cornerRadius, backY)
      ..quadraticBezierTo(
        backW,
        backY,
        backW + (frontW - backW) * 0.1,
        backY + (frontY - backY) * 0.1,
      )
      ..lineTo(frontW - cornerRadius * 0.5, frontY - cornerRadius)
      ..quadraticBezierTo(frontW, frontY, frontW - cornerRadius, frontY)
      ..lineTo(-frontW + cornerRadius, frontY)
      ..quadraticBezierTo(
        -frontW,
        frontY,
        -frontW + cornerRadius * 0.5,
        frontY - cornerRadius,
      )
      ..lineTo(-backW - (frontW - backW) * 0.1, backY + (frontY - backY) * 0.1)
      ..quadraticBezierTo(-backW, backY, -backW + cornerRadius, backY)
      ..close();

    canvas.drawPath(
      topPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            newBiome.nodeUnlockedColor,
            newBiome.nodeUnlockedBorderColor,
          ],
        ).createShader(Rect.fromLTRB(-frontW, backY, frontW, frontY)),
    );

    final frontPath = Path()
      ..moveTo(-frontW, frontY)
      ..lineTo(frontW, frontY)
      ..lineTo(frontW, frontBottomY - cornerRadius)
      ..quadraticBezierTo(
        frontW,
        frontBottomY,
        frontW - cornerRadius,
        frontBottomY,
      )
      ..lineTo(-frontW + cornerRadius, frontBottomY)
      ..quadraticBezierTo(
        -frontW,
        frontBottomY,
        -frontW,
        frontBottomY - cornerRadius,
      )
      ..close();

    canvas.drawPath(
      frontPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            newBiome.nodeUnlockedBorderColor,
            newBiome.nodeUnlockedRivetColor,
          ],
        ).createShader(Rect.fromLTRB(-frontW, frontY, frontW, frontBottomY)),
    );

    canvas.restore();

    // 2. Glowing molten-edge cracks at the wavefront (only while still sweeping)
    if (p < 1.0) {
      for (final double edgeX in [-sweepX, sweepX]) {
        // Blurred heat glow
        canvas.drawLine(
          Offset(edgeX, backY),
          Offset(edgeX, frontBottomY),
          Paint()
            ..color = newBiome.primaryColor.withValues(alpha: 0.85)
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0),
        );
        // Bright core line
        canvas.drawLine(
          Offset(edgeX, backY),
          Offset(edgeX, frontBottomY),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.75)
            ..strokeWidth = 1.2
            ..style = PaintingStyle.stroke,
        );

        // 3. Sparks flying upward from wavefront
        const List<double> sparkAngles = [-1.1, -0.7, -0.4, 0.0, 0.5, 0.9, 1.2];
        const List<double> sparkLengths = [
          10.0,
          7.0,
          12.0,
          8.0,
          11.0,
          6.0,
          9.0,
        ];
        for (int i = 0; i < sparkAngles.length; i++) {
          final double delay = i * 0.06;
          final double sp = ((p - delay) / 0.4).clamp(0.0, 1.0);
          if (sp <= 0 || sp >= 1.0) continue;

          final double len = sparkLengths[i % sparkLengths.length];
          // bias sparks upward
          final double angle =
              sparkAngles[i % sparkAngles.length] - math.pi / 2;
          final double sparkOpacity = (1.0 - sp) * 0.9;

          canvas.drawLine(
            Offset(edgeX, backY),
            Offset(
              edgeX + math.cos(angle) * len * sp,
              backY + math.sin(angle) * len * sp,
            ),
            Paint()
              ..color = newBiome.secondaryColor.withValues(alpha: sparkOpacity)
              ..strokeWidth = 1.5
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round,
          );
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(position.dx, position.dy);

    // Draw the static platform under the ball
    if (drawPlatform) {
      canvas.save();
      // Shift platform down so its top surface sits at the bottom of the ball (y = radius).
      // The platform's top surface center is visually at y = -2. So we shift by radius + 2.
      canvas.translate(0.0, radius + 2.0);
      _drawPlatform(canvas);

      // Lava crack wipe: new biome color floods from center outward
      if (platformTransitionProgress > 0.0 && platformNewBiome != null) {
        _drawLavaCrackOverlay(
          canvas,
          platformNewBiome!,
          platformTransitionProgress,
        );
      }

      canvas.restore();
    }

    if (drawBall && scale > 0) {
      canvas.save();
      // Ball coordinate system (handles jumping independently of the platform)
      canvas.translate(0.0, ballOffsetY);

      // Drop shadow (scales with distance if jumping)
      canvas.save();
      // Shadow is drawn relative to the ball's center. We want it to stay near the platform ground.
      canvas.translate(4.0, radius + 4.0 - (ballOffsetY * 0.2));
      canvas.scale(1.0, 0.5);
      canvas.drawCircle(Offset.zero, radius, _dropShadowPaint);
      canvas.restore();

      // Apply Z-scale (jumping towards camera)
      canvas.scale(scale, scale);

      // Apply squash and stretch pivoting at the bottom of the ball
      canvas.translate(0.0, radius);
      canvas.scale(squashScaleX, squashScaleY);
      canvas.translate(0.0, -radius);

      // Apply custom modifier scale (for explosion/pop effect)
      if (ballScaleModifier != 1.0) {
        canvas.scale(ballScaleModifier, ballScaleModifier);
      }

      // If opacity is less than 1.0, save a layer with opacity
      if (ballOpacity < 1.0) {
        final opacityPaint = Paint()
          ..color = Color.fromRGBO(0, 0, 0, ballOpacity);
        canvas.saveLayer(null, opacityPaint);
      }

      // Draw rotating BallPainter graphic from gameplay
      canvas.save();

      if (isLocked) {
        final paint = Paint()
          ..colorFilter = const ColorFilter.matrix(<double>[
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]);
        canvas.saveLayer(
          Rect.fromCircle(center: Offset.zero, radius: radius * 2),
          paint,
        );
      } else {
        // We no longer need a tinting ColorFilter because BallPainter handles dynamic biome colors natively!
        canvas.save();
      }

      canvas.rotate(rotation);

      // Scale BallPainter (41.46x42.056) to fit within radius * 2
      double ballScale = (radius * 2) / 42.0;
      canvas.scale(ballScale, ballScale);
      canvas.translate(-20.73, -21.028);

      BallPainter(biome: biome).paint(canvas, const Size(42.0, 42.0));

      // Always restore since we saveLayer for both locked and unlocked
      canvas.restore();

      if (ballOpacity < 1.0) {
        canvas.restore(); // Restore opacity layer
      }

      canvas.restore();

      // 3D Highlight
      canvas.drawCircle(Offset.zero, radius, _highlightPaint);

      // Border
      canvas.drawCircle(Offset.zero, radius, _borderPaint);

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapBallLayer oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.scale != scale ||
        oldDelegate.squashScaleX != squashScaleX ||
        oldDelegate.squashScaleY != squashScaleY ||
        oldDelegate.rotation != rotation ||
        oldDelegate.ballOffsetY != ballOffsetY ||
        oldDelegate.isLocked != isLocked ||
        oldDelegate.biome != biome ||
        oldDelegate.platformBiome != platformBiome ||
        oldDelegate.platformNewBiome != platformNewBiome ||
        oldDelegate.platformTransitionProgress != platformTransitionProgress;
  }
}
