import 'package:flutter/material.dart';
import 'dart:math';

// ==========================================
// PARALLAX MESH & PARTICLE ENGINE
// ==========================================
class AtmospherePainter extends CustomPainter {
  final double progress;

  AtmospherePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Fixed seed guarantees the stars and orbs stay exactly in the same place every frame
    final Random rand = Random(42); 

    double virtualHeight = size.height * 3.0;

    // 1. Glowing Mesh Orbs (Lava-lamp effect)
    for (int i = 0; i < 15; i++) {
      double orbX = rand.nextDouble() * size.width;
      double orbY = rand.nextDouble() * virtualHeight;
      double orbRadius = 100.0 + rand.nextDouble() * 150.0;
      
      Color orbColor;
      if (orbY < virtualHeight * 0.25) {
        orbColor = const Color(0xFF8B5CF6); // Soft Purple (Space)
      } else if (orbY < virtualHeight * 0.5) {
        orbColor = const Color(0xFFF472B6); // Soft Pink (Stratosphere)
      } else if (orbY < virtualHeight * 0.75) {
        orbColor = const Color(0xFF2DD4BF); // Soft Teal (Low Sky)
      } else {
        orbColor = const Color(0xFF34D399); // Soft Green (Ground)
      }

      // Parallax speed for orbs
      double parallaxY = orbY - (progress * virtualHeight * 0.8);
      
      if (parallaxY > -orbRadius && parallaxY < size.height + orbRadius) {
        Paint orbPaint = Paint()
          ..color = orbColor.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100.0);
        canvas.drawCircle(Offset(orbX, parallaxY), orbRadius, orbPaint);
      }
    }

    // 2. Distant Starfield (Moves Very Slowly)
    Paint farStarPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    for (int i = 0; i < 150; i++) {
      double x = rand.nextDouble() * size.width;
      double y = rand.nextDouble() * virtualHeight;
      double radius = 0.5 + rand.nextDouble() * 1.0;
      
      double parallaxY = y - (progress * virtualHeight * 0.3); 
      if (parallaxY > -10 && parallaxY < size.height + 10) {
        canvas.drawCircle(Offset(x, parallaxY), radius, farStarPaint);
      }
    }

    // 3. Near Particles / Bright Stars (Moves Fast)
    Paint nearStarPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    // Scatter near particles over a much larger virtual area because they scroll so fast
    double massiveHeight = size.height * 6.0; 
    for (int i = 0; i < 80; i++) {
      double x = rand.nextDouble() * size.width;
      double y = rand.nextDouble() * massiveHeight;
      double radius = 1.0 + rand.nextDouble() * 2.0;
      
      double parallaxY = y - (progress * size.height * 5.0); 

      if (parallaxY > -10 && parallaxY < size.height + 10) {
        // Subtle glow for near particles
        Paint glowPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        canvas.drawCircle(Offset(x, parallaxY), radius + 2, glowPaint);
        
        canvas.drawCircle(Offset(x, parallaxY), radius, nearStarPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AtmospherePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
