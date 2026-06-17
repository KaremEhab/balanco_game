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

    // --- BAMBOO TILTING BAR RENDER ---
    double barHeight = 22.0;
    Rect woodenBarRect = Rect.fromLTRB(
      0,
      -barHeight / 2,
      barLength,
      barHeight / 2,
    );

    // 1. Drop shadow for depth
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        woodenBarRect.translate(0, 8),
        const Radius.circular(11),
      ),
      shadowPaint,
    );

    // 2. Main Bamboo log (Gradient for 3D cylinder effect)
    final Paint woodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE8F5E9), // Highlight (light green-white)
          Color(0xFFAED581), // Base light green
          Color(0xFF689F38), // Base mid green
          Color(0xFF33691E), // Shadow green
        ],
        stops: [0.0, 0.3, 0.6, 1.0],
      ).createShader(woodenBarRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(woodenBarRect, const Radius.circular(11)),
      woodPaint,
    );

    // 3. Bamboo joints/nodes
    final Paint jointPaint = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint jointHighlightPaint = Paint()
      ..color = const Color(0xFFF1F8E9).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    int numJoints = 7;
    double segmentLength = barLength / numJoints;

    for (int i = 1; i < numJoints; i++) {
      double x = i * segmentLength;
      // Draw joint ring curve
      Path jointPath = Path();
      jointPath.moveTo(x - 2, -barHeight / 2);
      jointPath.quadraticBezierTo(x + 3, 0, x - 2, barHeight / 2);
      canvas.drawPath(jointPath, jointPaint);

      // Highlight right next to the joint curve
      Path highlightPath = Path();
      highlightPath.moveTo(x, -barHeight / 2 + 1);
      highlightPath.quadraticBezierTo(x + 5, 0, x, barHeight / 2 - 1);
      canvas.drawPath(highlightPath, jointHighlightPaint);

      // Tiny bamboo texture lines fading from the joint
      canvas.drawLine(
        Offset(x - 2, -barHeight / 4),
        Offset(x - 12, -barHeight / 4 + 1),
        Paint()
          ..color = const Color(0xFF1B5E20).withValues(alpha: 0.2)
          ..strokeWidth = 1.0,
      );
      canvas.drawLine(
        Offset(x - 1, barHeight / 4),
        Offset(x - 15, barHeight / 4 - 1),
        Paint()
          ..color = const Color(0xFF1B5E20).withValues(alpha: 0.2)
          ..strokeWidth = 1.0,
      );
    }

    // 4. Track groove (where the ball rolls)
    Rect grooveRect = Rect.fromLTRB(16, -1.5, barLength - 16, 1.5);
    final Paint groovePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(grooveRect, const Radius.circular(1.5)),
      groovePaint,
    );

    // 5. Draw safe structural metallic rivet bolts along the balance platform log
    final Paint rivetPaint = Paint()..color = const Color(0xFFB0BEC5);
    for (int r = 1; r <= 9; r++) {
      if (r == 5) continue; // Skip the center where the hole usually is
      canvas.drawCircle(Offset(r * (barLength / 10), 0), 2.5, rivetPaint);
    }

    canvas.restore();
  }
}
