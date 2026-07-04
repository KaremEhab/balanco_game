import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/features/game/components/ball_component.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class MultiBallItem extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 fractionalPosition;
  final int ballCount;
  double _pulseTime = 0.0;
  bool isCollected = false;

  late final Paint _glowPaint;
  late final Paint _corePaint;
  late final Paint _innerRingPaint;
  late final Paint _miniGlow;
  late final Paint _miniCore;
  late final Paint _miniShiny;
  late final Paint _ringPaint;

  Color get primaryColor =>
      ballCount == 2 ? GameColors.purpleAccent : GameColors.cyanAccent;
  Color get secondaryColor =>
      ballCount == 2 ? GameColors.deepPurpleAccent : GameColors.blueAccent;

  MultiBallItem(this.fractionalPosition, {this.ballCount = 1})
    : super(size: Vector2.all(30.0), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final double r = size.x / 2;

    _glowPaint = Paint()..style = PaintingStyle.fill;

    _corePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          GameColors.magnetDarkBlue.withValues(alpha: 0.95),
          GameColors.magnetMediumBlue.withValues(alpha: 0.98),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r * 0.85));

    _innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = primaryColor.withValues(alpha: 0.5);

    _miniGlow = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withValues(alpha: 0.4);

    _miniCore = Paint()
      ..style = PaintingStyle.fill
      ..color = GameColors.white;

    _miniShiny = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor;

    _ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = SweepGradient(
        colors: [primaryColor, secondaryColor, GameColors.white, primaryColor],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isCollected) return;

    if (!game.isSpawningLevel && game.size.x > 0 && game.size.y > 0) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        120.0 + fractionalPosition.y * (game.levelHeight - 320.0),
      );
    }

    _pulseTime += dt * 3.0;

    // Check collision with any active ball
    if (!game.isSpawningLevel) {
      for (var ball in game.activeBalls) {
        bool onBar =
            !ball.isFreeFalling &&
            !ball.isFalling &&
            !ball.isRespawningFromHole &&
            !ball.isRespawningFromEdge &&
            ball.spawnTimer <= 0 &&
            ball.bounceTimer <= 0;
        if (onBar &&
            !ball.isDead &&
            ball.pos2D.distanceTo(position) < game.ballRadius + 15.0) {
          collect();
          break;
        }
      }
    }
  }

  void collect() {
    isCollected = true;
    HapticFeedback.heavyImpact();

    // Calculate how many balls are currently active and alive
    int aliveBalls = game.activeBalls.where((b) => !b.isDead).length;
    // Cap total balls to 3
    int spawnCount = min(ballCount, 3 - aliveBalls).clamp(0, ballCount).toInt();

    for (int i = 0; i < spawnCount; i++) {
      BallData newBall = BallData();
      newBall.isFreeFalling = true;
      newBall.pos2D = game.teleportingGateComponent.position.clone();
      // Give them a slight random horizontal velocity so they don't fall perfectly stacked
      newBall.freeFallVelocity = Vector2(
        (Random().nextDouble() - 0.5) * 150,
        0,
      );
      newBall.scale = 1.0;
      newBall.p = (game.size.x - 2 * game.barPadding) / 2.0;

      game.activeBalls.add(newBall);
      BallComponent bc = BallComponent(newBall)..priority = 20;
      game.activeBallComponents.add(bc);
      game.levelContainer.add(bc);
    }

    // Effect
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.2, curve: Curves.easeIn),
        onComplete: () => removeFromParent(),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    if (isCollected || game.isBoardHidden) return;

    final double r = size.x / 2;
    final double pulse = sin(_pulseTime);

    canvas.save();
    canvas.translate(r, r);

    // 1. Soft Outer Glow
    _glowPaint.shader = RadialGradient(
      colors: [
        primaryColor.withValues(alpha: 0.35 + pulse * 0.1),
        secondaryColor.withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: r + 10.0));
    canvas.drawCircle(Offset.zero, r + 10.0, _glowPaint);

    // 2. Glassmorphic Dark Core
    canvas.drawCircle(Offset.zero, r * 0.85, _corePaint);

    // 3. Inner Ring Overlay
    canvas.drawCircle(Offset.zero, r * 0.7, _innerRingPaint);

    // 4. Rotating Orbiting Mini Balls (representing the ballCount)
    final double angleOffset = _pulseTime * 1.5;
    final double orbitRadius = r * 0.42;

    for (int i = 0; i < ballCount; i++) {
      // If ballCount is 1, it orbits in the center. If 2, they orbit 180 degrees apart.
      final double angle = ballCount == 1
          ? angleOffset
          : angleOffset + (i * pi);
      final double bx = cos(angle) * orbitRadius;
      final double by = sin(angle) * orbitRadius;

      // Draw mini ball trail/glow
      canvas.drawCircle(Offset(bx, by), 5.5, _miniGlow);

      // Draw mini ball solid core
      canvas.drawCircle(Offset(bx, by), 3.5, _miniCore);

      // Draw shiny dot on the mini ball
      canvas.drawCircle(Offset(bx - 1, by - 1), 1.0, _miniShiny);
    }

    // 5. Outer Metallic Ring
    canvas.save();
    canvas.rotate(_pulseTime * 0.5);
    canvas.drawCircle(Offset.zero, r, _ringPaint);
    canvas.restore();

    canvas.restore();
  }
}
