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

    // --- PREMIUM CARVED WOOD & GOLD BAR ---
    double barHeight = 20.0;
    Rect fullRect = Rect.fromLTRB(0, -barHeight / 2, barLength, barHeight / 2);

    // 1. Drop shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    canvas.save();
    canvas.rotate(-angle); // Undo rotation to cast shadow straight down
    canvas.translate(0, 12);
    canvas.rotate(angle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fullRect, const Radius.circular(10)),
      shadowPaint,
    );
    canvas.restore();

    // 2. Main Wooden Body (Rich Dark Wood)
    RRect bodyRRect = RRect.fromRectAndRadius(
      fullRect,
      const Radius.circular(10),
    );
    final Paint woodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF8D6E63), // Light Wood edge
          Color(0xFF5D4037), // Mid Wood
          Color(0xFF3E2723), // Dark Wood core
          Color(0xFF1B0000), // Deep shadow
        ],
      ).createShader(fullRect);
    canvas.drawRRect(bodyRRect, woodPaint);

    // 3. Golden End Caps (Matches beach yellow/gold theme)
    double capWidth = 20.0;
    Rect leftCap = Rect.fromLTRB(0, -barHeight / 2, capWidth, barHeight / 2);
    Rect rightCap = Rect.fromLTRB(
      barLength - capWidth,
      -barHeight / 2,
      barLength,
      barHeight / 2,
    );

    RRect leftCapRRect = RRect.fromRectAndCorners(
      leftCap,
      topLeft: const Radius.circular(10),
      bottomLeft: const Radius.circular(10),
      topRight: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    RRect rightCapRRect = RRect.fromRectAndCorners(
      rightCap,
      topRight: const Radius.circular(10),
      bottomRight: const Radius.circular(10),
      topLeft: const Radius.circular(4),
      bottomLeft: const Radius.circular(4),
    );

    final Paint goldPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFE082), // Bright highlight
          Color(0xFFFFCA28), // Golden base
          Color(0xFFFF8F00), // Amber mid
          Color(0xFFBF360C), // Dark rust edge
        ],
      ).createShader(leftCap);

    canvas.drawRRect(leftCapRRect, goldPaint);

    final Paint goldPaintRight = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFE082),
          Color(0xFFFFCA28),
          Color(0xFFFF8F00),
          Color(0xFFBF360C),
        ],
      ).createShader(rightCap);
    canvas.drawRRect(rightCapRRect, goldPaintRight);

    // Add a dark separator line between gold caps and wood body
    final Paint separatorPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(capWidth, -barHeight / 2),
      Offset(capWidth, barHeight / 2),
      separatorPaint,
    );
    canvas.drawLine(
      Offset(barLength - capWidth, -barHeight / 2),
      Offset(barLength - capWidth, barHeight / 2),
      separatorPaint,
    );

    // 4. Glowing Cyan Groove (Matches the new shield button)
    Rect grooveRect = Rect.fromLTRB(
      capWidth + 12,
      -3.0,
      barLength - capWidth - 12,
      3.0,
    );
    final Paint groovePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF01579B), // Dark inner top
          Color(0xFF03A9F4), // Bright cyan glow
          Color(0xFFE1F5FE), // Pure white/cyan core at bottom
        ],
      ).createShader(grooveRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(grooveRect, const Radius.circular(3.0)),
      groovePaint,
    );

    // Outer highlight rim for the groove
    final Paint grooveRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(grooveRect, const Radius.circular(3.0)),
      grooveRimPaint,
    );

    // 5. Glossy Specular Highlight (The Glass/Epoxy finish reflection on wood)
    Rect specRect = Rect.fromLTRB(
      capWidth,
      -barHeight / 2 + 1,
      barLength - capWidth,
      -barHeight / 4,
    );
    final Paint specPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x77FFFFFF), // Strong white reflection
          Color(0x00FFFFFF), // Fades into wood
        ],
      ).createShader(specRect);
    canvas.drawRect(specRect, specPaint);

    canvas.restore();
  }
}
