import 'dart:math';
import 'package:flutter/material.dart';
import '../../map/components/tree_painter.dart';

class StaticTreesLayerPainter extends CustomPainter {
  StaticTreesLayerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Draw over the entire virtual map height
    double startY = -1000;
    double endY = size.height + 1000;

    List<CustomPainter> treePainters = [
      FirstTreePainter(),
      SecondTreePainter(),
      ThirdTreePainter(),
      ForthTreePainter(),
      FifthTreePainter(),
      SixthTreePainter(),
    ];
    
    // For trees, they are spaced every 220px. We must find the correct starting Y.
    double firstTreeY = (-1000 / 220).ceil() * 220.0;
    while (firstTreeY < startY) {
      firstTreeY += 220;
    }

    for (double y = firstTreeY; y <= endY; y += 220) {
      // Seed based on exactly this tree's Y slot to ensure stability!
      Random treeRandom = Random(y.toInt() + 42); 
      
      double noiseL = sin(y * 0.008) * 15.0 + cos(y * 0.015) * 8.0 + sin(y * 0.03) * 5.0;
      double noiseR = cos(y * 0.009) * 18.0 + sin(y * 0.014) * 9.0 + cos(y * 0.035) * 4.0;

      double leftEdge = 35.0 + noiseL;
      double rightEdge = size.width - 35.0 + noiseR;

      // 1. Try Left Shore
      if (treeRandom.nextDouble() > 0.4) {
        canvas.save();
        double xPos = treeRandom.nextDouble() * (leftEdge - 15.0).clamp(0.0, 100.0);
        double yPos = y + treeRandom.nextDouble() * 80.0;
        
        canvas.translate(xPos, yPos);
        
        double scale = 0.1 + treeRandom.nextDouble() * 0.04;
        if (treeRandom.nextBool()) canvas.scale(-scale, scale);
        else canvas.scale(scale, scale);
        
        canvas.translate(-370, -647); 
        CustomPainter selectedTreePainter = treePainters[treeRandom.nextInt(treePainters.length)];
        selectedTreePainter.paint(canvas, const Size(700, 750));
        _drawTreeBaseDetails(canvas, treeRandom);
        canvas.restore();
      }

      // 2. Try Right Shore
      if (treeRandom.nextDouble() > 0.4) {
        canvas.save();
        double xPos = rightEdge + 15.0 + treeRandom.nextDouble() * (size.width - rightEdge - 15.0).clamp(0.0, 100.0);
        double yPos = y + treeRandom.nextDouble() * 80.0;
        
        canvas.translate(xPos, yPos);
        
        double scale = 0.1 + treeRandom.nextDouble() * 0.04;
        if (treeRandom.nextBool()) canvas.scale(-scale, scale);
        else canvas.scale(scale, scale);
        
        canvas.translate(-370, -647); 
        CustomPainter selectedTreePainter = treePainters[treeRandom.nextInt(treePainters.length)];
        selectedTreePainter.paint(canvas, const Size(700, 750));
        _drawTreeBaseDetails(canvas, treeRandom);
        canvas.restore();
      }
    }
  }

  void _drawTreeBaseDetails(Canvas canvas, Random rnd) {
    int numStones = 3 + rnd.nextInt(4);
    for (int i = 0; i < numStones; i++) {
      int alpha = (255 * (0.7 + rnd.nextDouble() * 0.3)).toInt();
      Paint stonePaint = Paint()
        ..color = Color.fromARGB(alpha, 122, 122, 122)
        ..style = PaintingStyle.fill;
      
      double dx = 370 + (rnd.nextDouble() * 140 - 70); 
      double dy = 647 + (rnd.nextDouble() * 30 - 10);  
      double rx = 15 + rnd.nextDouble() * 20;
      double ry = 8 + rnd.nextDouble() * 12;

      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx, dy), width: rx * 2, height: ry * 2),
        stonePaint,
      );

      Paint highlightPaint = Paint()
        ..color = const Color.fromARGB(128, 170, 170, 170)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx - rx * 0.2, dy - ry * 0.2), width: rx, height: ry),
        highlightPaint,
      );
    }

    int numGrass = 6 + rnd.nextInt(7);
    Paint grassPaint = Paint()
      ..color = const Color(0xFF61840B) 
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < numGrass; i++) {
      double dx = 370 + (rnd.nextDouble() * 160 - 80);
      double dy = 647 + (rnd.nextDouble() * 25 - 5);

      Path grassPath = Path();
      grassPath.moveTo(dx, dy);
      double endX = dx + (rnd.nextDouble() * 30 - 15);
      double endY = dy - (20 + rnd.nextDouble() * 30);

      grassPath.quadraticBezierTo(
        dx + (rnd.nextDouble() * 15 - 7.5),
        dy - 10,
        endX,
        endY,
      );
      canvas.drawPath(grassPath, grassPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StaticTreesLayerPainter oldDelegate) {
    return false;
  }
}
