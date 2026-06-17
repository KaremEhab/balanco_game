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

    // --- SLEEK POLISHED WOODEN BAR RENDER ---
    double barHeight = 14.0; // Decreased height
    Rect woodenBarRect = Rect.fromLTRB(
      0,
      -barHeight / 2,
      barLength,
      barHeight / 2,
    );

    // 1. Drop shadow for depth
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        woodenBarRect.translate(0, 6),
        const Radius.circular(7),
      ),
      shadowPaint,
    );

    // 2. Main Wooden Bar (Gradient for 3D polished effect)
    final Paint woodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFDECB2), // Bright top edge
          Color(0xFFE8BC79), // Main wood color
          Color(0xFFB57E40), // Shadowed wood
          Color(0xFF754C24), // Deep bottom edge
        ],
        stops: [0.0, 0.2, 0.7, 1.0],
      ).createShader(woodenBarRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(woodenBarRect, const Radius.circular(7)),
      woodPaint,
    );

    // 3. Inner Groove (Track for the ball)
    Rect grooveRect = Rect.fromLTRB(8, -2.0, barLength - 8, 2.0);
    final Paint groovePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF5E3A18), // Deep inset shadow
          Color(0xFF8A5A2B), // Bottom of groove
        ],
      ).createShader(grooveRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(grooveRect, const Radius.circular(2)),
      groovePaint,
    );

    // 4. Metallic End Caps
    final Paint metalPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0E0E0), Color(0xFF9E9E9E), Color(0xFF616161)],
      ).createShader(woodenBarRect);

    // Left Cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0, -barHeight / 2, 8, barHeight / 2),
        const Radius.circular(7),
      ),
      metalPaint,
    );
    // Right Cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(barLength - 8, -barHeight / 2, barLength, barHeight / 2),
        const Radius.circular(7),
      ),
      metalPaint,
    );
    
    // Add small rivets to end caps
    final Paint rivetPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawCircle(const Offset(4, 0), 1.5, rivetPaint);
    canvas.drawCircle(Offset(barLength - 4, 0), 1.5, rivetPaint);

    canvas.restore();
  }
}
