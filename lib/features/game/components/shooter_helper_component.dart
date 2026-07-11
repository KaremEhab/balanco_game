import 'dart:math';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/editor/mixins/editor_draggable.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ShooterHelperComponent extends PositionComponent
    with
        HasGameReference<BalancoGame>,
        TapCallbacks,
        DragCallbacks,
        EditorDraggable {
  bool isCollected = false;
  double _time = 0;

  ShooterHelperComponent(Vector2 position)
    : super(position: position, size: Vector2.all(38), anchor: Anchor.center);

  void collect() {
    if (isCollected) return;
    isCollected = true;
    game.activateShooter();
    removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2 + sin(_time * 4) * 2);
    
    // Outer floating ring
    canvas.drawCircle(
      center, 
      18, 
      Paint()
        ..color = GameColors.cyanAccent.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
    );

    // Inner glowing core
    canvas.drawCircle(
      center, 
      12, 
      Paint()
        ..color = GameColors.cyanAccent
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    
    // Rotate slowly for cool effect
    canvas.rotate(_time * 1.5);
    
    // Turret base
    canvas.drawCircle(Offset.zero, 8, Paint()..color = GameColors.blueGrey);
    canvas.drawCircle(Offset.zero, 4, Paint()..color = GameColors.black87);
    
    // Turret barrels (3 barrels for sci-fi look)
    final barrelPaint = Paint()..color = GameColors.white;
    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.rotate(i * (2 * pi / 3));
      canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(4, -2, 10, 4), const Radius.circular(2)),
        barrelPaint
      );
      canvas.restore();
    }
    
    canvas.restore();
    renderEditorHighlight(canvas);
  }
}
