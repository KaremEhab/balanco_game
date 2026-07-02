import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';

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

    // --- HEAVY METAL BEAM ---
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

    // 2. Main Metal Body (Brushed Steel)
    RRect bodyRRect = RRect.fromRectAndRadius(
      fullRect,
      const Radius.circular(10),
    );
    final Paint metalPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE0E0E0), // Bright metallic highlight
          Color(0xFF9E9E9E), // Mid steel
          Color(0xFF616161), // Dark steel core
          Color(0xFF212121), // Deep shadow edge
        ],
      ).createShader(fullRect);
    canvas.drawRRect(bodyRRect, metalPaint);

    // 3. Dark Gunmetal End Caps
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

    final Paint gunmetalPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFCFD8DC), // Bright rim
          Color(0xFF90A4AE), // Base blue-grey metal
          Color(0xFF546E7A), // Dark shadow
          Color(0xFF263238), // Almost black edge
        ],
      ).createShader(leftCap);

    canvas.drawRRect(leftCapRRect, gunmetalPaint);

    final Paint gunmetalPaintRight = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFCFD8DC),
          Color(0xFF90A4AE),
          Color(0xFF546E7A),
          Color(0xFF263238),
        ],
      ).createShader(rightCap);
    canvas.drawRRect(rightCapRRect, gunmetalPaintRight);

    // Add a dark separator line between metal caps and steel body
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

    // 5. Glossy Specular Highlight (The polished metal finish reflection)
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
