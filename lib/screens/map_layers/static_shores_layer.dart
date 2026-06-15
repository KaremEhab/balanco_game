import 'dart:math';
import 'package:flutter/material.dart';

class StaticShoresLayerPainter extends CustomPainter {
  StaticShoresLayerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Draw over the entire virtual map height
    double startY = -1000;
    double endY = size.height + 1000;

    // 1. Draw Shores (Beach / Sand) on both sides
    Paint sandPaint = Paint()
      ..color = const Color(0xFFFFE4B5); // Moccasin / light sand
    Paint wetSandPaint = Paint()
      ..color = const Color(0xFFDEB887); // Burlywood / wet sand
    Paint shoreFoamPaint = Paint()
      ..color = const Color(0x99FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path leftWetSand = Path();
    Path leftSand = Path();
    Path rightWetSand = Path();
    Path rightSand = Path();

    leftWetSand.moveTo(0, startY);
    leftSand.moveTo(0, startY);
    rightWetSand.moveTo(size.width, startY);
    rightSand.moveTo(size.width, startY);

    // Snap to absolute 30px grid to prevent jitter/animation while scrolling
    double firstShoreY = (startY / 30.0).floor() * 30.0;

    for (double y = firstShoreY; y <= endY; y += 30) {
      double noiseL =
          sin(y * 0.008) * 15.0 + cos(y * 0.015) * 8.0 + sin(y * 0.03) * 5.0;
      double noiseR =
          cos(y * 0.009) * 18.0 + sin(y * 0.014) * 9.0 + cos(y * 0.035) * 4.0;

      double baseLeft = 35.0;
      double baseRight = size.width - 35.0;

      leftWetSand.lineTo(baseLeft + noiseL + 10.0, y);
      leftSand.lineTo(baseLeft + noiseL, y);

      rightWetSand.lineTo(baseRight + noiseR - 10.0, y);
      rightSand.lineTo(baseRight + noiseR, y);
    }

    leftWetSand.lineTo(0, endY);
    leftWetSand.close();
    leftSand.lineTo(0, endY);
    leftSand.close();

    rightWetSand.lineTo(size.width, endY);
    rightWetSand.close();
    rightSand.lineTo(size.width, endY);
    rightSand.close();

    canvas.drawPath(leftWetSand, wetSandPaint);
    canvas.drawPath(leftWetSand, shoreFoamPaint);
    canvas.drawPath(leftSand, sandPaint);

    canvas.drawPath(rightWetSand, wetSandPaint);
    canvas.drawPath(rightWetSand, shoreFoamPaint);
    canvas.drawPath(rightSand, sandPaint);

    // 2. Draw Real Sand Textures (Grainy dots)
    Paint sandTexturePaint1 = Paint()
      ..color = const Color(0xFFD6C684)
      ..style = PaintingStyle.fill;
    Paint sandTexturePaint2 = Paint()
      ..color = const Color(0xFFF7EAC1)
      ..style = PaintingStyle.fill;

    // To ensure consistency, we must fast-forward the Random number generator
    // to the correct state based on startY. Alternatively, use a mathematical hash based on Y.
    // To make it simple and perfectly consistent without skipping, we can use a hash-based approach,
    // but fast-forwarding is fine because we clamped to 10px steps.
    // Wait, fast forwarding Random is expensive if startY is large.
    // Let's just generate deterministically based on Y!

    // Snap to absolute 10px grid to prevent dots from moving/animating while scrolling
    double firstSandY = (startY / 10.0).floor() * 10.0;

    for (double y = firstSandY; y <= endY; y += 10) {
      double noiseL =
          sin(y * 0.008) * 15.0 + cos(y * 0.015) * 8.0 + sin(y * 0.03) * 5.0;
      double noiseR =
          cos(y * 0.009) * 18.0 + sin(y * 0.014) * 9.0 + cos(y * 0.035) * 4.0;

      double leftEdge = 35.0 + noiseL;
      double rightEdge = size.width - 35.0 + noiseR;

      // Seed based on Y coordinate to be purely deterministic per row
      Random rowRnd = Random(y.toInt() + 123);

      // Left sand dots
      for (int k = 0; k < 4; k++) {
        double dx = rowRnd.nextDouble() * leftEdge;
        double dy = y + rowRnd.nextDouble() * 10;
        canvas.drawCircle(
          Offset(dx, dy),
          0.8 + rowRnd.nextDouble() * 1.5,
          rowRnd.nextBool() ? sandTexturePaint1 : sandTexturePaint2,
        );
      }

      // Right sand dots
      for (int k = 0; k < 4; k++) {
        double dx = rightEdge + rowRnd.nextDouble() * (size.width - rightEdge);
        double dy = y + rowRnd.nextDouble() * 10;
        canvas.drawCircle(
          Offset(dx, dy),
          0.8 + rowRnd.nextDouble() * 1.5,
          rowRnd.nextBool() ? sandTexturePaint1 : sandTexturePaint2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant StaticShoresLayerPainter oldDelegate) {
    return false;
  }
}
