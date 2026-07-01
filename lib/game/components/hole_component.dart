import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class HoleComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 fractionalPosition;
  double _rotation = 0.0;
  double _pulseTime = 0.0;

  final bool isSuckingHole;
  final double suckRadius;

  HoleComponent(
    this.fractionalPosition,
    double holeSize,
    double rotation, {
    this.isSuckingHole = false,
    this.suckRadius = 0.0,
  }) : super(size: Vector2.all(holeSize), anchor: Anchor.center, angle: 0) {
    _rotation = rotation;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isSpawningLevel && game.size.x > 0 && game.size.y > 0) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        120.0 + fractionalPosition.y * (game.levelHeight - 320.0),
      );
    }

    if (game.activeHole == this) {
      _rotation -= dt * 5.0; // Swirls faster when active
      _pulseTime += dt * 4.0;
    } else {
      _rotation -= dt * 1.0;
      _pulseTime += dt * 1.5;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    double radius = size.x / 2;
    double innerRadius = radius - 5.0; // 5px border for the hole rim

    canvas.save();
    canvas.translate(radius, radius);

    // --- 1. Outer Wind/Sucking Effect (if applicable) ---
    if (isSuckingHole) {
      Paint windAreaPaint = Paint()
        ..shader =
            RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                Colors.purpleAccent.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: Offset.zero, radius: suckRadius),
            );
      canvas.drawCircle(Offset.zero, suckRadius, windAreaPaint);

      // Sucking particles spinning inward
      Paint particlePaint = Paint()
        ..color = Colors.purpleAccent.withValues(alpha: 0.5);
      for (int i = 0; i < 12; i++) {
        double t = ((_pulseTime * 0.3) + (i / 12.0)) % 1.0; // 0 to 1
        double pRadius = innerRadius + (suckRadius - innerRadius) * (1.0 - t);
        double ang = _rotation * 0.5 + (i * pi / 6) + (t * pi * 2);
        canvas.drawCircle(
          Offset(cos(ang) * pRadius, sin(ang) * pRadius),
          2.5 * (1.0 - t),
          particlePaint,
        );
      }
    }

    // --- 2. The Rotating Mechanical Trap ---
    canvas.save();
    canvas.rotate(_rotation); // The gear/teeth spin mechanically!

    double trapInnerRadius = radius * 0.60; // Thick outer ring (wider sides)

    // 2a. The Deep Hole Background (Stepped Concentric Circles)
    List<Color> holeColors = isSuckingHole
        ? [
            const Color(0xFF4A148C),
            const Color(0xFF311B92),
            const Color(0xFF1A237E),
            const Color(0xFF111111),
            const Color(0xFF000000),
          ]
        : [
            const Color(0xFFA18764),
            const Color(0xFF8A7456),
            const Color(0xFF7B674D),
            const Color(0xFF6F5E46),
            const Color(0xFF665640),
            const Color(0xFF58493A),
          ];

    double step = trapInnerRadius / holeColors.length;
    for (int i = 0; i < holeColors.length; i++) {
      Paint circlePaint = Paint()..color = holeColors[i];
      canvas.drawCircle(Offset.zero, trapInnerRadius - (i * step), circlePaint);
    }

    // 2b. The Spikes (Teeth)
    int numTeeth = 8;
    double toothAngle = (2 * pi) / numTeeth;
    double toothBaseHalfWidth = 0.15; // Radians

    Path teethPath = Path();
    for (int i = 0; i < numTeeth; i++) {
      double angle = i * toothAngle;
      double startAngle = angle - toothBaseHalfWidth;
      double endAngle = angle + toothBaseHalfWidth;

      teethPath.moveTo(
        cos(startAngle) * trapInnerRadius,
        sin(startAngle) * trapInnerRadius,
      );
      // Tip of the tooth pointing inward
      teethPath.lineTo(
        cos(angle) * (trapInnerRadius * 0.25),
        sin(angle) * (trapInnerRadius * 0.25),
      );
      teethPath.lineTo(
        cos(endAngle) * trapInnerRadius,
        sin(endAngle) * trapInnerRadius,
      );
    }

    Paint teethPaint = Paint();
    if (isSuckingHole) {
      teethPaint.color = const Color(0xFF9C27B0);
    } else {
      teethPaint.color = const Color(0xFFFFDCB4);
    }
    canvas.drawPath(teethPath, teethPaint);

    // Dark radial shadow to make teeth fade into the deep hole
    Paint teethShadow = Paint()
      ..shader =
          RadialGradient(
            colors: [Colors.black87, Colors.transparent],
            stops: const [0.2, 1.0],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: trapInnerRadius),
          );
    canvas.drawCircle(Offset.zero, trapInnerRadius, teethShadow);

    // 2c. The Brass/Gold Ring
    Paint ringShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(Offset.zero, radius, ringShadow); // Outer drop shadow

    Paint ringPaint = Paint();
    if (isSuckingHole) {
      ringPaint.color = const Color(0xFFBA68C8);
    } else {
      ringPaint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFDF7E), Color(0xFFB57D38)],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    }

    Path ringPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius))
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: trapInnerRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(ringPath, ringPaint);

    // Bright outer edge
    Paint outerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = isSuckingHole
          ? const Color(0xFFE1BEE7)
          : const Color(0xFFFDEB82);
    canvas.drawCircle(Offset.zero, radius - 1.0, outerEdgePaint);

    // Subtle inner dark edge
    Paint innerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.black38;
    canvas.drawCircle(Offset.zero, trapInnerRadius, innerEdgePaint);

    // 2d. The Rivets
    double rivetDistance = (radius + trapInnerRadius) / 2;
    double rivetRadius = (radius - trapInnerRadius) * 0.18;

    Paint rivetBasePaint = Paint()
      ..color = isSuckingHole
          ? const Color(0xFF6A1B9A)
          : const Color(0xFF9E7730);
    Paint rivetHighlightPaint = Paint()..color = Colors.white54;

    for (int i = 0; i < numTeeth; i++) {
      // Offset the rivets to sit exactly between the teeth
      double angle = (i * toothAngle) + (toothAngle / 2);
      Offset rivetCenter = Offset(
        cos(angle) * rivetDistance,
        sin(angle) * rivetDistance,
      );

      canvas.drawCircle(rivetCenter, rivetRadius, rivetBasePaint);
      // Bright highlight for a 3D spherical bump look
      canvas.drawCircle(
        rivetCenter + Offset(-rivetRadius * 0.3, -rivetRadius * 0.3),
        rivetRadius * 0.4,
        rivetHighlightPaint,
      );
    }

    canvas.restore(); // Restore mechanical rotation

    // --- 6. Splash Effect when Ball Falls In ---
    if (game.activeHole == this &&
        (game.isFallingInHole || game.isRespawningFromHole)) {
      double splashProgress = 0.0;
      if (game.isFallingInHole) {
        double closingProgress = 1.0 - game.ballScale;
        splashProgress = ((closingProgress - 0.6) * 2.5).clamp(0.0, 1.0);
      } else {
        splashProgress = (1.0 - (game.ballScale * 2.0)).clamp(0.0, 1.0);
      }

      if (splashProgress > 0) {
        // Main splash circle swallowing the ball
        Paint splashPaint = Paint()
          ..color = (isSuckingHole ? Colors.purpleAccent : Colors.white)
              .withValues(alpha: 0.85 * splashProgress);
        canvas.drawCircle(
          Offset.zero,
          innerRadius * splashProgress,
          splashPaint,
        );

        // Splash droplet particles flying outward
        Paint dropPaint = Paint()
          ..color = Colors.white.withValues(
            alpha: 0.7 * (1.0 - splashProgress),
          );
        for (int i = 0; i < 8; i++) {
          double ang = i * pi / 4 + _pulseTime * 2;
          double dR = innerRadius * splashProgress + 4.0 + sin(i * 123) * 6.0;
          if (dR <= radius * 0.45) {
            // Clip splash to inner hole
            canvas.drawCircle(
              Offset(cos(ang) * dR, sin(ang) * dR),
              1.5,
              dropPaint,
            );
          }
        }
      }
    }

    // --- 7. Outer Glow for Active/Sucking Hole ---
    if (game.activeHole == this) {
      Paint glowPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: isSuckingHole
              ? const [Colors.purpleAccent, Colors.transparent]
              : const [Colors.cyanAccent, Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

      double glowAlpha = (0.3 + 0.7 * sin(_pulseTime * 2)).clamp(0.0, 1.0);
      glowPaint.color = Colors.white.withValues(alpha: glowAlpha);
      canvas.drawCircle(Offset.zero, radius, glowPaint);
    }

    canvas.restore(); // restore main translation
  }
}
