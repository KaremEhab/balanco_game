import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/core/data/app_settings.dart';

class BombComponent extends PositionComponent with HasGameReference<BalancoGame> {
  final Vector2 startPosition;
  double dropSpeed = 500.0;
  bool _exploded = false;
  
  late final Paint _bodyPaint;
  late final Paint _highlightPaint;
  late final Paint _fusePaint;
  
  double _fuseTimer = 0.0;

  BombComponent(this.startPosition) : super(size: Vector2.all(40), anchor: Anchor.center) {
    position = startPosition;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
        colors: [GameColors.blueGrey.shade800, GameColors.black],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 20));

    _highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = GameColors.whiteSolid.withValues(alpha: 0.3);

    _fusePaint = Paint()
      ..color = GameColors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isLevelCompleteOverlayShown || game.isSpawningLevel) return;

    position.y += dropSpeed * dt;
    _fuseTimer += dt;
    
    // Check if off screen
    if (position.y > game.cameraOffsetY + game.size.y + 50) {
      removeFromParent();
      return;
    }
    
    if (_exploded) return;
    
    // Check collisions
    for (var ball in game.activeBalls) {
      if (ball.isDead || ball.isShattering || ball.isRespawningFromEdge || ball.isRespawningFromHole) continue;
      
      if (position.distanceTo(ball.pos2D) < 20 + game.ballRadius) {
        _explode(ball);
        break; // Only explode once
      }
    }
  }
  
  void _explode(BallData ball) {
    _exploded = true;
    
    if (game.isShieldActive) {
      // Shield absorbs the bomb
      game.shieldTimer = 0.0;
      game.shieldTimerNotifier.value = 0.0;
      try {
        AppSettings.playSound('bump.wav', volume: 0.8);
      } catch (_) {}
    } else {
      // Shatter the ball
      ball.isShattering = true;
      ball.shatterTimer = 0.0;
    }
    
    // We could add a blast particle effect component here
    
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);

    // Fuse
    final path = Path()
      ..moveTo(0, -20)
      ..quadraticBezierTo(10, -30, 5 + 5 * sin(_fuseTimer * 10), -40);
      
    canvas.drawPath(path, _fusePaint);
    
    // Spark on fuse
    canvas.drawCircle(Offset(5 + 5 * sin(_fuseTimer * 10), -40), 3 + 2 * sin(_fuseTimer * 30), Paint()..color = GameColors.orange);

    // Body
    canvas.drawCircle(Offset.zero, 20.0, _bodyPaint);
    canvas.drawCircle(Offset.zero, 20.0, _highlightPaint);
    
    // Cap
    canvas.drawRect(Rect.fromCenter(center: const Offset(0, -18), width: 12, height: 6), Paint()..color = GameColors.blueGrey.shade900);

    canvas.restore();
  }
}
