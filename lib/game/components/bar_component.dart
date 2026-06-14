import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class BarComponent extends Component with HasGameReference<BalancoGame> {
  final Paint basePaint = Paint()..color = Colors.blueGrey.shade700;
  final Paint highlightPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.3);
  final Paint shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.4);
  final Paint rivetPaint = Paint()..color = Colors.blueGrey.shade300;
  final Paint capPaint = Paint()..color = Colors.blueGrey.shade900;

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

    double thickness = 16.0;

    // 1. Draw base bar
    Rect barRect = Rect.fromLTRB(0, -thickness / 2, barLength, thickness / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, const Radius.circular(8)),
      basePaint,
    );

    // 2. Draw top highlight (3D edge)
    Rect topHighlight = Rect.fromLTRB(
      4,
      -thickness / 2 + 1,
      barLength - 4,
      -thickness / 2 + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(topHighlight, const Radius.circular(2)),
      highlightPaint,
    );

    // 3. Draw bottom shadow
    Rect bottomShadow = Rect.fromLTRB(
      4,
      thickness / 2 - 4,
      barLength - 4,
      thickness / 2 - 1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bottomShadow, const Radius.circular(2)),
      shadowPaint,
    );

    // 4. Draw mechanical rivets evenly spaced
    int numRivets = 8;
    double spacing = barLength / numRivets;
    for (int i = 1; i < numRivets; i++) {
      // Shadow under rivet
      canvas.drawCircle(Offset(i * spacing, 1), 3, shadowPaint);
      // Rivet
      canvas.drawCircle(Offset(i * spacing, 0), 2.5, rivetPaint);
    }

    // 5. Draw end caps (rail connectors)
    double capWidth = 14.0;
    double capHeight = thickness + 8.0;
    // Left Cap
    canvas.drawRRect(
      RRect.fromLTRBR(
        -capWidth / 2,
        -capHeight / 2,
        capWidth / 2,
        capHeight / 2,
        const Radius.circular(4),
      ),
      capPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        -capWidth / 2 + 2,
        -capHeight / 2 + 2,
        capWidth / 2 - 2,
        -capHeight / 2 + 4,
        const Radius.circular(1),
      ),
      highlightPaint,
    );
    // Right Cap
    canvas.drawRRect(
      RRect.fromLTRBR(
        barLength - capWidth / 2,
        -capHeight / 2,
        barLength + capWidth / 2,
        capHeight / 2,
        const Radius.circular(4),
      ),
      capPaint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        barLength - capWidth / 2 + 2,
        -capHeight / 2 + 2,
        barLength + capWidth / 2 - 2,
        -capHeight / 2 + 4,
        const Radius.circular(1),
      ),
      highlightPaint,
    );

    canvas.restore();
  }
}
