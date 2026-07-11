import 'dart:math';

import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/editor/mixins/editor_draggable.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/components/rocket_warning_component.dart';
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
    this.health = 8,
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
    AppSettings.playSound('bump.wav', volume: 0.45);
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
        if (!targetBall.isDead && !targetBall.isFallingInHole) {
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
    final biome = game.currentBiome;

    // Demonic base (darkened biome color)
    final baseColor = _hitFlash > 0 ? GameColors.white : biome.primaryColor;

    canvas.drawCircle(center, size.x * 0.45, Paint()..color = baseColor);
    if (_hitFlash <= 0) {
      canvas.drawCircle(
        center,
        size.x * 0.45,
        Paint()..color = GameColors.black.withValues(alpha: 0.7),
      );
    }

    // Glowing corrupted core
    if (_hitFlash <= 0) {
      final glow = Paint()
        ..color = GameColors.redAccent.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, size.x * 0.25, glow);

      // Core cracks
      final crackPaint = Paint()
        ..color = GameColors.redAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(
        Path()
          ..moveTo(center.dx - 10, center.dy - 10)
          ..lineTo(center.dx, center.dy)
          ..lineTo(center.dx + 15, center.dy - 5)
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx - 5, center.dy + 15),
        crackPaint,
      );
    }

    // Demonic Horns
    final hornPaint = Paint()..color = GameColors.black87;
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - size.x * 0.2, center.dy - size.y * 0.25)
        ..quadraticBezierTo(
          center.dx - size.x * 0.35,
          center.dy - size.y * 0.55,
          center.dx - size.x * 0.05,
          center.dy - size.y * 0.5,
        )
        ..quadraticBezierTo(
          center.dx - size.x * 0.1,
          center.dy - size.y * 0.3,
          center.dx - size.x * 0.05,
          center.dy - size.y * 0.25,
        )
        ..close(),
      hornPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + size.x * 0.2, center.dy - size.y * 0.25)
        ..quadraticBezierTo(
          center.dx + size.x * 0.35,
          center.dy - size.y * 0.55,
          center.dx + size.x * 0.05,
          center.dy - size.y * 0.5,
        )
        ..quadraticBezierTo(
          center.dx + size.x * 0.1,
          center.dy - size.y * 0.3,
          center.dx + size.x * 0.05,
          center.dy - size.y * 0.25,
        )
        ..close(),
      hornPaint,
    );

    // Evil Angular Eyes
    final eyePaint = Paint()..color = GameColors.redAccent;
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - size.x * 0.25, center.dy - size.y * 0.1)
        ..lineTo(center.dx - size.x * 0.05, center.dy - size.y * 0.02)
        ..lineTo(center.dx - size.x * 0.15, center.dy - size.y * 0.15)
        ..close(),
      eyePaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + size.x * 0.25, center.dy - size.y * 0.1)
        ..lineTo(center.dx + size.x * 0.05, center.dy - size.y * 0.02)
        ..lineTo(center.dx + size.x * 0.15, center.dy - size.y * 0.15)
        ..close(),
      eyePaint,
    );

    // Health Bar
    final barRect = Rect.fromLTWH(4, -14, size.x - 8, 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
      Paint()..color = GameColors.black87,
    );
    renderEditorHighlight(canvas);
  }
}
