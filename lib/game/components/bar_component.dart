import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class BarComponent extends Component with HasGameReference<BalancoGame> {
  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    Vector2 leftPoint = Vector2(game.barPadding, game.leftY);
    Vector2 rightPoint = Vector2(game.size.x - game.barPadding, game.rightY);

    double barLength = (rightPoint - leftPoint).length;
    double angle = atan2(
      rightPoint.y - leftPoint.y,
      rightPoint.x - leftPoint.x,
    );

    canvas.save();
    canvas.translate(leftPoint.x, leftPoint.y);
    canvas.rotate(angle);

    // --- RUSTIC WOODEN TILTING BAR RENDER ---
    double barHeight = 18.0;
    Rect woodenBarRect = Rect.fromLTRB(0, -barHeight / 2, barLength, barHeight / 2);

    // Draw main organic log wooden texture skin casing
    final Paint woodPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRRect(RRect.fromRectAndRadius(woodenBarRect, const Radius.circular(6)), woodPaint);

    // Add wooden bark visual line grain textures
    final Paint grainPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(barLength * 0.1, -2), Offset(barLength * 0.8, -2), grainPaint);
    canvas.drawLine(Offset(barLength * 0.3, 3), Offset(barLength * 0.9, 3), grainPaint);

    // Draw safe structural metallic rivet bolts along the balance platform log
    final Paint rivetPaint = Paint()..color = const Color(0xFFB0BEC5);
    for (int r = 1; r <= 9; r++) {
      if (r == 5) continue;
      canvas.drawCircle(Offset(r * (barLength / 10), 0), 2.5, rivetPaint);
    }

    canvas.restore();
  }
}
