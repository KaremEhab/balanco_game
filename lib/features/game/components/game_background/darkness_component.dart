import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';

class DarknessComponent extends Component with HasGameReference<BalancoGame> {
  DarknessComponent() {
    priority = 90; // Ensure it renders above the world but below bomb warnings
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final opacity = game.darknessOpacityNotifier.value;
    if (opacity <= 0.0) return;

    final radius = game.lightRadiusNotifier.value;

    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, game.size.x, game.size.y));

    final Path holesPath = Path();
    for (final ball in game.activeBalls) {
      final screenPos = Offset(ball.pos2D.x, ball.pos2D.y - game.cameraOffsetY);
      holesPath.addOval(Rect.fromCircle(center: screenPos, radius: radius));
    }

    final Path darknessPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holesPath,
    );

    final Paint paint = Paint()..color = Colors.black.withValues(alpha: opacity);
    canvas.drawPath(darknessPath, paint);
  }
}
