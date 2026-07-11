import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/components/villain_component.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShooterProjectileComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 direction;
  double _life = 0;

  ShooterProjectileComponent({required Vector2 position, required this.direction})
    : super(position: position, size: Vector2.all(12), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _life += dt;
    if (_life > 3) {
      removeFromParent();
      return;
    }
    
    for (final villain in game.villains) {
      if (villain.isDefeated) continue;
      final delta = villain.position - position;
      if (delta.length < villain.size.x * 0.38) {
        villain.hit();
        removeFromParent();
        return;
      }
    }
    
    position += direction * 550 * dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      6,
      Paint()..color = GameColors.goldenYellow,
    );
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      10,
      Paint()
        ..color = GameColors.cyanAccent.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }
}
