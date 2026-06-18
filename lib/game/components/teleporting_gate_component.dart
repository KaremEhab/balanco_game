import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../game_area.dart';

class TeleportingGateComponent extends PositionComponent with HasGameRef<BalancoGame> {
  bool isClosing = false;
  bool isOpening = false;
  bool isClosed = false;
  double _time = 0;
  double _doorProgress = 0.0;

  TeleportingGateComponent() {
    size = Vector2(100, 100);
    anchor = Anchor.center;
  }

  void reset() {
    isClosing = false;
    isOpening = false;
    isClosed = false;
    _doorProgress = 0.0;
  }
  
  void startClosed() {
    isClosing = false;
    isOpening = false;
    isClosed = true;
    _doorProgress = 1.0;
  }
  
  void open() {
    isClosing = false;
    isOpening = true;
    isClosed = false;
  }

  @override
  void update(double dt) {
    _time += dt;
    if (isClosing) {
      _doorProgress += dt * 1.5; // Closes in ~0.66 seconds
      if (_doorProgress >= 1.0) {
        _doorProgress = 1.0;
        isClosing = false;
        isClosed = true;
      }
    } else if (isOpening) {
      _doorProgress -= dt * 1.5;
      if (_doorProgress <= 0.0) {
        _doorProgress = 0.0;
        isOpening = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (size.x <= 0) return;

    // 1. Draw outer gate ring
    final Paint ringPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
      
    final Paint ringInnerPaint = Paint()
      ..color = const Color(0xFF7F8C8D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 40, ringPaint);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 40, ringInnerPaint);

    // 2. Draw jelly/water portal inside
    if (_doorProgress < 1.0) {
      canvas.save();
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(size.x / 2, size.y / 2), radius: 35)));
      
      final Paint portalPaint = Paint()
        ..color = const Color(0xFF9B59B6).withOpacity(0.8) // Purple jelly
        ..style = PaintingStyle.fill;
        
      final Paint swirlPaint = Paint()
        ..color = const Color(0xFF8E44AD).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      // Draw pulsating jelly base
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), 35, portalPaint);
      
      // Draw swirls
      for (int i = 0; i < 5; i++) {
        double radius = 5 + (i * 8) + sin(_time * 3 + i) * 5;
        canvas.drawCircle(Offset(size.x / 2, size.y / 2), radius, swirlPaint);
      }
      
      // Draw closing iris/doors over the portal
      if (_doorProgress > 0) {
        final Paint doorPaint = Paint()
          ..color = const Color(0xFF34495E)
          ..style = PaintingStyle.fill;
          
        double closeAmount = _doorProgress * 40; // 0 to 40 (full radius)
        
        // Top door
        canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y / 2 - 35 + closeAmount), doorPaint);
        // Bottom door
        canvas.drawRect(Rect.fromLTWH(0, size.y / 2 + 35 - closeAmount, size.x, size.y / 2), doorPaint);
      }
      
      canvas.restore();
    } else {
      // Fully closed doors
      final Paint doorPaint = Paint()
        ..color = const Color(0xFF34495E)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), 35, doorPaint);
      
      // Door seam
      final Paint seamPaint = Paint()
        ..color = Colors.black45
        ..strokeWidth = 2;
      canvas.drawLine(Offset(size.x / 2 - 35, size.y / 2), Offset(size.x / 2 + 35, size.y / 2), seamPaint);
    }
  }
}
