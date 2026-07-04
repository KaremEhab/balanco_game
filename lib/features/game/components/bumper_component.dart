import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class BumperComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 fractionalPosition;
  final double radius;

  // Animation state
  double _wobbleTime = 0.0;
  bool _isWobbling = false;

  // Cached Paints
  late final Paint _basePaint;
  late final Paint _domePaint;
  late final Paint _rimPaint;
  late final Paint _highlightPaint;
  late final Paint _shadowPaint;

  BumperComponent(this.fractionalPosition, this.radius)
    : super(size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Metallic base ring
    _basePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.9,
        colors: [GameColors.blueGrey.shade400, GameColors.blueGrey.shade900],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    // Rubbery neon dome
    _domePaint = Paint()
      ..shader =
          RadialGradient(
            center: const Alignment(-0.2, -0.2),
            radius: 0.8,
            colors: [
              GameColors.purpleAccent.shade100,
              GameColors.deepPurpleAccent.shade700,
            ],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: radius * 0.8),
          );

    // Metallic Rim edge
    _rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = GameColors.blueGrey.shade800;

    // Highlight
    _highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        radius: 1.0,
        colors: [GameColors.white.withValues(alpha: 0.6), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    // Drop shadow on the floor
    _shadowPaint = Paint()
      ..color = GameColors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
  }

  void hit() {
    _isWobbling = true;
    _wobbleTime = 0.0; // reset animation
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isSpawningLevel && game.size.x > 0 && game.size.y > 0) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        120.0 + fractionalPosition.y * (game.levelHeight - 320.0),
      );
    }

    if (_isWobbling) {
      _wobbleTime += dt;
      // After ~0.6 seconds, the damping kills the animation
      if (_wobbleTime > 0.6) {
        _isWobbling = false;
        _wobbleTime = 0.0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(radius, radius);

    // Drop shadow (offset)
    canvas.save();
    canvas.translate(4.0, 6.0);
    canvas.drawCircle(Offset.zero, radius, _shadowPaint);
    canvas.restore();

    // Base metal ring
    canvas.drawCircle(Offset.zero, radius, _basePaint);
    canvas.drawCircle(Offset.zero, radius, _rimPaint);
    canvas.drawCircle(Offset.zero, radius, _highlightPaint);

    // Jelly Dome
    canvas.save();

    // Wobble effect: damped sine wave
    if (_isWobbling) {
      // Damped harmonic oscillator
      // scale = 1.0 + amplitude * e^(-damping * t) * sin(frequency * t)
      double amplitude = 0.3;
      double damping = 8.0;
      double freq = 40.0;

      double scaleMod =
          amplitude * exp(-damping * _wobbleTime) * sin(freq * _wobbleTime);

      // We squash and stretch (scale X inversely to scale Y)
      canvas.scale(1.0 + scaleMod, 1.0 - scaleMod * 0.5);
    }

    canvas.drawCircle(Offset.zero, radius * 0.8, _domePaint);
    canvas.restore();

    canvas.restore();
  }
}
