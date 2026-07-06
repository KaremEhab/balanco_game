import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

// Uses plain TextPaint (no GoogleFonts inside Flame) to avoid AssetManifest.bin error.
class FloatingTextComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final String text;
  final Color color;

  late TextComponent _textComponent;
  late TextComponent _shadowComponent;

  double _lifeTime = 0.0;
  final double maxLifeTime = 1.2;

  FloatingTextComponent({
    required this.text,
    required Vector2 position,
    this.color = GameColors.white,
  }) {
    this.position = position;
    anchor = Anchor.center;
    priority = 100; // Always render on top
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final shadowPaint = TextPaint(
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = GameColors.brownDarkUi,
      ),
    );

    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: color,
      ),
    );

    _shadowComponent = TextComponent(
      text: text,
      textRenderer: shadowPaint,
      anchor: Anchor.center,
    );

    _textComponent = TextComponent(
      text: text,
      textRenderer: textPaint,
      anchor: Anchor.center,
    );

    add(_shadowComponent);
    add(_textComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _lifeTime += dt;

    if (_lifeTime > maxLifeTime) {
      removeFromParent();
      return;
    }

    // Float upwards
    position.y -= dt * 70;

    // Fade out in second half
    if (_lifeTime > maxLifeTime * 0.5) {
      final opacity =
          1.0 - ((_lifeTime - maxLifeTime * 0.5) / (maxLifeTime * 0.5));
      final clamped = opacity.clamp(0.0, 1.0);
      _textComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: color.withValues(alpha: clamped),
        ),
      );
      _shadowComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = GameColors.brownDarkUi.withValues(alpha: clamped),
        ),
      );
    }
  }
}
