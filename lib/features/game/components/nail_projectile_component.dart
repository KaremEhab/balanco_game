import 'dart:math';

import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NailProjectileComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 direction;
  final double speed;
  double _life = 0;

  NailProjectileComponent({
    required Vector2 position,
    required this.direction,
    this.speed = 310,
  }) : super(
         position: position,
         size: Vector2(28, 10),
         anchor: Anchor.center,
         angle: atan2(direction.y, direction.x),
       );

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isLevelCompleteOverlayShown) {
      removeFromParent();
      return;
    }
    _life += dt;
    position += direction * speed * dt;
    if (_life > 4 ||
        position.x < -60 ||
        position.x > game.size.x + 60 ||
        position.y < game.cameraOffsetY - 80 ||
        position.y > game.cameraOffsetY + game.size.y + 80) {
      removeFromParent();
      return;
    }

    for (final ball in game.activeBalls) {
      if (ball.isDead || ball.isShattering || ball.spawnTimer > 0) continue;
      if (position.distanceTo(ball.pos2D) > game.ballRadius + 8) continue;
      if (game.isShieldActive) {
        game.shieldTimer = 0;
        game.shieldTimerNotifier.value = 0;
        AppSettings.playSound('bump.wav', volume: 0.7);
      } else {
        ball.isShattering = true;
        ball.shatterTimer = 0;
        HapticFeedback.heavyImpact();
        AppSettings.playSound('fall.wav', volume: 0.8);
      }
      removeFromParent();
      return;
    }
  }

  @override
  void render(Canvas canvas) {
    final metal = Paint()
      ..shader = const LinearGradient(
        colors: [GameColors.white, GameColors.blueGrey, GameColors.black54],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    final path = Path()
      ..moveTo(0, size.y / 2)
      ..lineTo(size.x * 0.72, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x * 0.72, size.y)
      ..close();
    canvas.drawPath(path, metal);
    canvas.drawCircle(
      Offset(size.x * 0.18, size.y / 2),
      size.y * 0.48,
      Paint()..color = GameColors.blueGrey.shade700,
    );
  }
}
