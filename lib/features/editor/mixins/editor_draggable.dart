import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';

mixin EditorDraggable on PositionComponent, HasGameReference<BalancoGame>, TapCallbacks, DragCallbacks {
  @override
  void onTapDown(TapDownEvent event) {
    if (game.isEditMode) {
      game.selectedEditComponent.value = this;
      event.handled = true;
    }
    super.onTapDown(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (game.isEditMode) {
      game.selectedEditComponent.value = this;
      event.handled = true;
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (game.isEditMode) {
      position.add(event.localDelta);
      event.handled = true;
    }
    super.onDragUpdate(event);
  }

  void renderEditorHighlight(Canvas canvas) {
    if (game.isEditMode && game.selectedEditComponent.value == this) {
      final paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      final rect = Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: size.x + 10,
        height: size.y + 10,
      );
      canvas.drawRect(rect, paint);
    }
  }
}
