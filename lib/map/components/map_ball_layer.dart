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
  final double ballOffsetY; // Separate offset for the ball jumping
  final bool drawPlatform;
  final bool drawBall;

  // Paints
  final Paint _dropShadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.5)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
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
    this.ballOffsetY = 0.0,
    this.drawPlatform = true,
    this.drawBall = true,
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
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
  }

  void _drawPlatform(Canvas canvas) {
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
      ..color = Colors.black.withValues(alpha: 0.5)
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
      ..color =
          const Color(0xFF2D1A11) // Solid very dark brown/black
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

    final Paint topFacePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE082), Color(0xFFFFCA28)], // Bright sandy wood top
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
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFB300), Color(0xFFFF8F00)], // Darker front edge
      ).createShader(Rect.fromLTRB(-frontW, frontY, frontW, frontBottomY));

    canvas.drawPath(frontFacePath, frontFacePaint);

    // 4. Creative Beach Details: Wood Planks on Top Face
    final Paint woodGrain = Paint()
      ..color = const Color(0xFFD84315).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw perspective lines for planks
    canvas.drawLine(Offset(-15, backY), Offset(-20, frontY), woodGrain);
    canvas.drawLine(Offset(15, backY), Offset(20, frontY), woodGrain);

    // 5. Creative Beach Details: Starfish on the front edge corner
    final Paint starfishPaint = Paint()
      ..color = const Color(0xFFFF5252); // Vibrant coral
    final Path starfishPath = Path();
    double cx = 38;
    double cy = 10;
    double rOut = 6.0;
    double rIn = 2.5;
    for (int i = 0; i < 10; i++) {
      double angle = i * 3.14159 / 5 - 3.14159 / 2;
      double r = (i % 2 == 0) ? rOut : rIn;
      double x = cx + r * cos(angle);
      double y = cy + r * sin(angle);
      if (i == 0) {
        starfishPath.moveTo(x, y);
      } else {
        starfishPath.lineTo(x, y);
      }
    }
    starfishPath.close();

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(0.3);
    canvas.translate(-cx, -cy);

    // Starfish drop shadow on the front face
    final Paint starfishShadow = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(starfishPath, starfishShadow);

    // Draw Starfish
    canvas.drawPath(starfishPath, starfishPaint);

    // Starfish inner details
    final Paint starfishDetail = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(cx, cy), 1.0, starfishDetail);

    canvas.restore();

    // 6. Highlight on the top front edge to make it pop
    final Paint edgeHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(-frontW + cornerRadius, frontY),
      Offset(frontW - cornerRadius, frontY),
      edgeHighlight,
    );
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

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapBallLayer oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.scale != scale ||
        oldDelegate.squashScaleX != squashScaleX ||
        oldDelegate.squashScaleY != squashScaleY ||
        oldDelegate.rotation != rotation ||
        oldDelegate.ballOffsetY != ballOffsetY;
  }
}
