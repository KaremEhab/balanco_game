import 'dart:math';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/editor/mixins/editor_draggable.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ShieldPickupComponent extends PositionComponent
    with
        HasGameReference<BalancoGame>,
        TapCallbacks,
        DragCallbacks,
        EditorDraggable {
  ShieldPickupComponent(this.fractionalPosition)
    : super(size: Vector2.all(36), anchor: Anchor.center);

  final Vector2 fractionalPosition;
  bool isCollected = false;
  double _time = 0;
  double _collectedTime = 0;

  void reset() {
    isCollected = false;
    _collectedTime = 0;
    scale = Vector2.all(1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isEditMode &&
        !game.isSpawningLevel &&
        !game.isInfinityMode &&
        game.size.x > 0 &&
        game.size.y > 0 &&
        !isCollected) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        120 + fractionalPosition.y * (game.levelHeight - 320),
      );
    }
    if (isCollected) {
      _collectedTime += dt;
    } else {
      _time += dt;
    }
  }

  void collect() {
    if (isCollected) return;
    isCollected = true;
    _collectedTime = 0;
  }

  @override
  void render(Canvas canvas) {
    if (isCollected && _collectedTime >= 0.45) return;

    final collectedProgress = isCollected ? (_collectedTime / 0.45) : 0.0;
    final pulse = 1 + sin(_time * 4) * 0.08 + collectedProgress * 0.55;
    final opacity = (1 - collectedProgress).clamp(0.0, 1.0);
    final center = Offset(size.x / 2, size.y / 2 - collectedProgress * 24);
    final path = Path()
      ..moveTo(center.dx, center.dy - 14 * pulse)
      ..lineTo(center.dx + 12 * pulse, center.dy - 9 * pulse)
      ..lineTo(center.dx + 10 * pulse, center.dy + 5 * pulse)
      ..quadraticBezierTo(
        center.dx + 7 * pulse,
        center.dy + 13 * pulse,
        center.dx,
        center.dy + 17 * pulse,
      )
      ..quadraticBezierTo(
        center.dx - 7 * pulse,
        center.dy + 13 * pulse,
        center.dx - 10 * pulse,
        center.dy + 5 * pulse,
      )
      ..lineTo(center.dx - 12 * pulse, center.dy - 9 * pulse)
      ..close();

    canvas.drawCircle(
      center,
      21 * pulse,
      Paint()
        ..color = GameColors.cyanAccent.withValues(alpha: 0.2 * opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            GameColors.lightBlue200.withValues(alpha: opacity),
            GameColors.lightBlue600.withValues(alpha: opacity),
          ],
        ).createShader(path.getBounds()),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = GameColors.white.withValues(alpha: opacity),
    );
    renderEditorHighlight(canvas);
  }
}
