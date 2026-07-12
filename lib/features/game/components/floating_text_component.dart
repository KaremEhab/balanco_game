import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingTextComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final String text;
  final Color color;
  final double fontSize;

  late TextComponent _textComponent;
  late TextComponent _shadowComponent;
  late TextComponent _dropShadowComponent;

  double _lifeTime = 0.0;
  final double maxLifeTime = 1.2;

  FloatingTextComponent({
    required this.text,
    required Vector2 position,
    this.color = GameColors.white,
    this.fontSize = 26,
  }) {
    this.position = position;
    anchor = Anchor.center;
    priority = 100; // Always render on top
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final fontFamily = GoogleFonts.luckiestGuy().fontFamily;

    final dropShadowPaint = TextPaint(
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: GameColors.black54,
      ),
    );

    final strokePaint = TextPaint(
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = GameColors.brownDarkUi,
      ),
    );

    final textPaint = TextPaint(
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
      ),
    );

    _dropShadowComponent = TextComponent(
      text: text,
      textRenderer: dropShadowPaint,
      anchor: Anchor.center,
      position: Vector2(2, 4), // Drop shadow offset
    );

    _shadowComponent = TextComponent(
      text: text,
      textRenderer: strokePaint,
      anchor: Anchor.center,
    );

    _textComponent = TextComponent(
      text: text,
      textRenderer: textPaint,
      anchor: Anchor.center,
    );

    add(_dropShadowComponent);
    add(_shadowComponent);
    add(_textComponent);

    // Start small for pop effect
    scale = Vector2.all(0.1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _lifeTime += dt;

    if (_lifeTime > maxLifeTime) {
      removeFromParent();
      return;
    }

    // Pop animation: scale up to 1.2 then settle to 1.0
    if (_lifeTime < 0.2) {
      double s = 0.1 + (1.1 * (_lifeTime / 0.2));
      scale = Vector2.all(s);
    } else if (_lifeTime < 0.3) {
      double s = 1.2 - (0.2 * ((_lifeTime - 0.2) / 0.1));
      scale = Vector2.all(s);
    }

    // Float upwards slowly
    position.y -= dt * 60;

    // Fade out in second half
    if (_lifeTime > maxLifeTime * 0.5) {
      final opacity =
          1.0 - ((_lifeTime - maxLifeTime * 0.5) / (maxLifeTime * 0.5));
      final clamped = opacity.clamp(0.0, 1.0);

      final fontFamily = GoogleFonts.luckiestGuy().fontFamily;

      _textComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: color.withValues(alpha: clamped),
        ),
      );
      _shadowComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = GameColors.brownDarkUi.withValues(alpha: clamped),
        ),
      );
      _dropShadowComponent.textRenderer = TextPaint(
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: GameColors.black54.withValues(alpha: clamped),
        ),
      );
    }
  }
}
