import 'dart:math';

import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/editor/mixins/editor_draggable.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/components/rocket_warning_component.dart';
import 'package:balanco_game/features/game/components/villains/demonic_gatekeeper_painter.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class VillainComponent extends PositionComponent
    with
        HasGameReference<BalancoGame>,
        TapCallbacks,
        DragCallbacks,
        EditorDraggable {
  final int variant;
  final int maxHealth;
  int health;
  double _time = 0;
  double _hitFlash = 0;
  double _attackTimer = 0;
  bool isDefeated = false;

  VillainComponent({
    required Vector2 position,
    required double size,
    this.variant = 0,
    this.health = 30,
  }) : maxHealth = health,
       super(
         position: position,
         size: Vector2.all(size),
         anchor: Anchor.center,
       );

  void hit([int damage = 1]) {
    if (isDefeated) return;
    health = max(0, health - damage);
    _hitFlash = 0.14;
    AppSettings.playSound('getting-hit-sound.wav', volume: 0.45);
    if (health == 0) {
      isDefeated = true;
      game.onVillainDefeated(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    _hitFlash = max(0, _hitFlash - dt);
    if (!game.isEditMode &&
        !game.isSpawningLevel &&
        !isDefeated &&
        game.activeBalls.isNotEmpty) {
      _attackTimer += dt;
      final interval = max(1.4, 3.0 - variant * 0.2);
      if (_attackTimer >= interval) {
        _attackTimer = 0;

        final targetBall = game.activeBalls.first;
        if (!targetBall.isDead &&
            !targetBall.isFallingInHole &&
            !targetBall.isRespawningFromHole &&
            !targetBall.isRespawningFromEdge) {
          Vector2 predictedPos = targetBall.pos2D.clone();

          game.levelContainer.add(
            RocketWarningComponent(
              position: predictedPos,
              duration: max(1.2, 1.8 - variant * 0.1),
            )..priority = 80,
          );
        }
      }
    }
    if (isDefeated) {
      scale -= Vector2.all(dt * 1.4);
      angle += dt * 5;
      if (scale.x <= 0.05) removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2 + sin(_time * 3) * 3);

    if (_hitFlash > 0) {
      canvas.drawCircle(
        center,
        size.x * 0.45,
        Paint()..color = GameColors.white.withValues(alpha: 0.8),
      );
    } else {
      canvas.save();
      // the painter draws relative to 0,0 and assumes canvas size is 1x1.
      // We translate to the top-left of the bounding box and scale to size.
      canvas.translate(center.dx - size.x / 2, center.dy - size.y / 2);

      final painter = DemonicGatekeeperPainter();
      painter.paint(canvas, Size(size.x, size.y));

      canvas.restore();
    }

    // Health Bar
    final barRect = Rect.fromLTWH(4, -14, size.x - 8, 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
      Paint()..color = GameColors.black87,
    );

    // Adaptive blood bar
    if (health > 0) {
      final healthPct = health / maxHealth;
      final healthRect = Rect.fromLTWH(4, -14, (size.x - 8) * healthPct, 10);
      canvas.drawRRect(
        RRect.fromRectAndRadius(healthRect, const Radius.circular(6)),
        Paint()..color = GameColors.red,
      );
    }

    renderEditorHighlight(canvas);
  }
}
