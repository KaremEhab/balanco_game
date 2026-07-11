import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/components/bomb_component.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/models/ball_data.dart';

class BombWarningComponent extends PositionComponent with HasGameReference<BalancoGame> {
  double _timer = 0.0;
  bool _locked = false;
  BallData? targetBall;
  
  late final Paint _circlePaint;
  late final Paint _exclamationPaint;
  late final Paint _outlinePaint;
  
  BombWarningComponent() : super(size: Vector2.all(60), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _circlePaint = Paint()..color = GameColors.redAccent.withValues(alpha: 0.8);
    _outlinePaint = Paint()
      ..color = GameColors.whiteSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    _exclamationPaint = Paint()
      ..color = GameColors.whiteSolid
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    if (game.activeBalls.isNotEmpty) {
      targetBall = game.activeBalls.first;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isEditMode || game.isLevelCompleteOverlayShown || game.isSpawningLevel) {
      return;
    }

    _timer += dt;

    if (_timer < 4.0) {
      // Track ball
      if (targetBall != null && !targetBall!.isDead) {
        position.x = targetBall!.pos2D.x;
      } else if (game.activeBalls.isNotEmpty) {
        targetBall = game.activeBalls.first;
        position.x = targetBall!.pos2D.x;
      }
    } else if (!_locked) {
      // Lock position for the last 1 second
      _locked = true;
    }

    // Always keep it at the top of the visible screen
    position.y = game.cameraOffsetY + 50.0;

    if (_timer >= 5.0) {
      // Spawn bomb and remove warning
      game.levelContainer.add(BombComponent(Vector2(position.x, game.cameraOffsetY - 60.0))..priority = 100);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);

    // Pulsing effect
    double pulse = 1.0 + 0.15 * sin(_timer * 15.0);
    if (_locked) {
      // Faster pulse when locked
      pulse = 1.0 + 0.25 * sin(_timer * 30.0);
      
      // Flash white
      if (sin(_timer * 30.0) > 0.8) {
        canvas.drawCircle(Offset.zero, 25.0, Paint()..color = GameColors.whiteSolid.withValues(alpha: 0.5));
      }
    }
    
    canvas.scale(pulse, pulse);

    // Draw warning circle
    canvas.drawCircle(Offset.zero, 25.0, _circlePaint);
    canvas.drawCircle(Offset.zero, 25.0, _outlinePaint);

    // Draw exclamation mark
    canvas.drawLine(const Offset(0, -12), const Offset(0, 4), _exclamationPaint);
    canvas.drawCircle(const Offset(0, 12), 3.0, Paint()..color = GameColors.whiteSolid);

    canvas.restore();
  }
}
