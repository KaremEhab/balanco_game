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

    final bounds = Rect.fromLTWH(0, 0, game.size.x, game.size.y);
    canvas.saveLayer(bounds, Paint());
    canvas.drawRect(
      bounds,
      Paint()..color = Colors.black.withValues(alpha: opacity),
    );

    for (final ball in game.activeBalls.where((ball) => !ball.isDead)) {
      final screenPos = Offset(ball.pos2D.x, ball.pos2D.y - game.cameraOffsetY);
      final spotlight = Paint()
        ..blendMode = BlendMode.dstOut
        ..shader = const RadialGradient(
          colors: [Colors.black, Colors.black, Colors.transparent],
          stops: [0.0, 0.68, 1.0],
        ).createShader(Rect.fromCircle(center: screenPos, radius: radius));
      canvas.drawCircle(screenPos, radius, spotlight);
    }
    canvas.restore();
  }
}
