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
        120.0 + fractionalPosition.y * (game.size.y - 320.0),
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
      Paint particlePaint = Paint()..color = Colors.purpleAccent.withValues(alpha: 0.5);
      for (int i = 0; i < 12; i++) {
        double t = ((_pulseTime * 0.3) + (i / 12.0)) % 1.0; // 0 to 1
        double pRadius = innerRadius + (suckRadius - innerRadius) * (1.0 - t);
        double ang = _rotation * 0.5 + (i * pi / 6) + (t * pi * 2);
        canvas.drawCircle(Offset(cos(ang) * pRadius, sin(ang) * pRadius), 2.5 * (1.0 - t), particlePaint);
      }
    }

    // --- 2. The Physical Hole Border (Sleek 3D Glossy Ring) ---
    // Outer drop shadow for the floating ring
    Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(Offset.zero, radius, shadowPaint);

    // The glossy 3D donut ring
    Paint ringPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: isSuckingHole
            ? const [Color(0xFFE1BEE7), Color(0xFFBA68C8), Color(0xFF4A148C)] // Purple glossy
            : const [Color(0xFFFFF3E0), Color(0xFFFFB74D), Color(0xFFE65100)], // Orange glossy
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    
    // Draw thick outer ring
    Path ringPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius))
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: innerRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(ringPath, ringPaint);

    // Glossy Specular Highlight on the ring
    Paint specularPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white70, Colors.transparent],
        stops: [0.0, 0.5],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    canvas.drawCircle(Offset.zero, radius - 2.0, specularPaint);

    // Inner rim shadow (to show depth inside the hole)
    Paint innerRimShadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
        stops: const [0.8, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: innerRadius + 1.5));
    canvas.drawCircle(Offset.zero, innerRadius, innerRimShadow);

    // --- 3. The Water Base ---
    Paint waterBase = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.3), // slight offset for realistic lighting
        radius: 0.9,
        colors: isSuckingHole
            ? [const Color(0xFF280659), const Color(0xFF12002b)] // Deep purple hole
            : [const Color(0xFF003366), const Color(0xFF001133)], // Deep blue hole
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: innerRadius));
    
    canvas.drawCircle(Offset.zero, innerRadius, waterBase);

    // --- Clip everything else to stay inside the water area ---
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: innerRadius)));

    // --- 4. Dynamic Water Ripples / Caustics ---
    Paint ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw 3 expanding rippled rings
    for (int i = 0; i < 3; i++) {
      double t = ((_pulseTime * 0.4) + (i / 3.0)) % 1.0; 
      double ripRadius = t * innerRadius;
      double alpha = (1.0 - t) * 0.7; // fades out as it expands
      
      ripplePaint.color = (isSuckingHole ? Colors.purpleAccent : Colors.cyanAccent).withValues(alpha: alpha);
      
      Path ripPath = Path();
      for (int j = 0; j <= 50; j++) {
        double ang = (j / 50.0) * pi * 2;
        // Wavy distortion that gets more intense as the ring expands
        double distortion = sin(ang * 5 + _rotation * 2) * 2.0 * t + cos(ang * 3 - _pulseTime) * 1.5 * t;
        double r = ripRadius + distortion; 
        
        if (j == 0) {
          ripPath.moveTo(cos(ang) * r, sin(ang) * r);
        } else {
          ripPath.lineTo(cos(ang) * r, sin(ang) * r);
        }
      }
      ripPath.close();
      canvas.drawPath(ripPath, ripplePaint);
    }

    // --- 5. Surface Light Highlight ---
    // A soft, semi-transparent white shape near the top to look like water reflection
    Paint surfaceHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    
    Path highlightPath = Path();
    double hOffset = sin(_pulseTime * 0.5) * 4.0;
    highlightPath.addOval(Rect.fromLTWH(-innerRadius * 0.6 + hOffset, -innerRadius * 0.8, innerRadius * 1.2, innerRadius * 0.5));
    
    canvas.save();
    canvas.rotate(-0.2); // angled reflection
    canvas.drawPath(highlightPath, surfaceHighlight);
    canvas.restore();

    canvas.restore(); // restore clipping

    // --- 6. Splash Effect when Ball Falls In ---
    if (game.activeHole == this && (game.isFallingInHole || game.isRespawningFromHole)) {
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
        canvas.drawCircle(Offset.zero, innerRadius * splashProgress, splashPaint);
        
        // Splash droplet particles flying outward
        Paint dropPaint = Paint()..color = Colors.white.withValues(alpha: 0.7 * (1.0 - splashProgress));
        for(int i = 0; i < 8; i++) {
            double ang = i * pi / 4 + _pulseTime * 2;
            double dR = innerRadius * splashProgress + 4.0 + sin(i * 123) * 6.0;
            if (dR <= innerRadius) {
                canvas.drawCircle(Offset(cos(ang) * dR, sin(ang) * dR), 1.5, dropPaint);
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

