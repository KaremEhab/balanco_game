import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RocketWarningComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final double duration;
  final double blastRadius;
  double _time = 0;

  RocketWarningComponent({
    required Vector2 position,
    this.duration = 1.5,
    this.blastRadius = 38.0,
  }) : super(
         position: position,
         size: Vector2.all(blastRadius * 2),
         anchor: Anchor.center,
       );

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isLevelCompleteOverlayShown) {
      removeFromParent();
      return;
    }
    _time += dt;
    if (_time >= duration) {
      // Explode!
      _explode();
      removeFromParent();
    }
  }

  void _explode() {
    HapticFeedback.heavyImpact();
    AppSettings.playSound('bomb.wav', volume: 0.7);

    for (final ball in game.activeBalls) {
      if (ball.isDead || ball.isShattering || ball.spawnTimer > 0) continue;

      if (position.distanceTo(ball.pos2D) <= blastRadius + game.ballRadius) {
        if (game.isShieldActive) {
          game.shieldTimer = 0;
          game.shieldTimerNotifier.value = 0;
          AppSettings.playSound('bump.wav', volume: 0.7);
        } else {
          ball.isShattering = true;
          ball.shatterTimer = 0;
          AppSettings.playSound('fall.wav', volume: 0.8);
        }
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final progress = (_time / duration).clamp(0.0, 1.0);

    // Draw the target zone
    canvas.drawCircle(
      center,
      blastRadius,
      Paint()
        ..color = GameColors.redAccent.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      blastRadius,
      Paint()
        ..color = GameColors.redAccent.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw the shrinking indicator (simulating incoming rocket)
    final shrinkRadius = blastRadius * (1.0 - progress);
    canvas.drawCircle(
      center,
      shrinkRadius,
      Paint()
        ..color = GameColors.redAccent.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill,
    );

    // Crosshair lines
    final crossPaint = Paint()
      ..color = GameColors.redAccent.withValues(alpha: 0.6)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(center.dx - blastRadius, center.dy),
      Offset(center.dx + blastRadius, center.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - blastRadius),
      Offset(center.dx, center.dy + blastRadius),
      crossPaint,
    );
  }
}
