import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class HoleComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 fractionalPosition;
  double _rotation = 0.0;
  double _pulseTime = 0.0;

  final bool isSuckingHole;
  final double suckRadius;

  // Cached Paints
  late final Paint _darkHolePaint;
  late final Paint _wallGradientPaint;
  late final Paint _rimPaint;
  late final Paint _rimHighlightPaint;
  late final Paint _rimShadowPaint;
  late final Paint _teethPaint;
  late final Paint _rivetShadowPaint;
  late final Paint _rivetMetalPaint;
  late final Paint _glowPaint;

  // Sucking hole specific paints
  late final Paint _boundaryPaint;
  late final Paint _windStreakPaint;
  late final Paint _windAreaPaint;

  // Cached Paths
  final List<Path> _teethPaths = [];
  final List<Path> _windStreakPaths = [];

  HoleComponent(
    this.fractionalPosition,
    double holeSize,
    double rotation, {
    this.isSuckingHole = false,
    this.suckRadius = 0.0,
  }) : super(size: Vector2.all(holeSize), anchor: Anchor.center, angle: 0) {
    _rotation = rotation;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    double radius = size.x / 2;

    _darkHolePaint = Paint()..color = Colors.black;

    _wallGradientPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.9,
        colors: isSuckingHole
            ? [Colors.red.shade900, Colors.black87, Colors.black]
            : [Colors.black54, Colors.black87, Colors.black],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    _rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = isSuckingHole ? Colors.red.shade900 : Colors.blueGrey.shade800;

    _rimHighlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader =
          RadialGradient(
            center: const Alignment(-0.5, -0.5),
            radius: 1.0,
            colors: [Colors.white.withValues(alpha: 0.4), Colors.transparent],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: radius + 3.0),
          );

    _rimShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader =
          RadialGradient(
            center: const Alignment(0.5, 0.5),
            radius: 1.0,
            colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: radius + 3.0),
          );

    _teethPaint = Paint()..color = Colors.blueGrey.shade900;
    _rivetShadowPaint = Paint()..color = Colors.black54;
    _rivetMetalPaint = Paint()..color = Colors.blueGrey.shade400;

    _glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: const [Colors.redAccent, Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    if (isSuckingHole) {
      _boundaryPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      _windStreakPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      _windAreaPaint = Paint()
        ..shader =
            RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                Colors.cyanAccent.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(center: Offset.zero, radius: suckRadius),
            );
    }

    // Initialize 8 empty paths for teeth to avoid allocating inside render
    for (int i = 0; i < 8; i++) {
      _teethPaths.add(Path());
    }

    // Initialize empty paths for wind streaks
    if (isSuckingHole) {
      for (int i = 0; i < 6; i++) {
        _windStreakPaths.add(Path());
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.size.x > 0 && game.size.y > 0) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        fractionalPosition.y * game.size.y,
      );
    }

    if (game.activeHole == this) {
      _rotation -= dt * 15.0;
      _pulseTime += dt * 15.0;
    } else {
      _rotation -= dt * 1.5;
      _pulseTime += dt * 2.0;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    double radius = size.x / 2;
    canvas.save();
    canvas.translate(radius, radius);

    if (isSuckingHole) {
      _boundaryPaint.color = Colors.cyanAccent.withValues(
        alpha: 0.2 + 0.1 * sin(_pulseTime),
      );
      canvas.drawCircle(Offset.zero, suckRadius, _boundaryPaint);

      double t = (_pulseTime % 1.0);
      _windStreakPaint.color = Colors.cyanAccent.withValues(alpha: 1.0 - t);

      for (int i = 0; i < 6; i++) {
        double ang = _rotation * 0.5 + (i * pi / 3) + (t * pi / 4);
        double currentDist = suckRadius - (t * (suckRadius - radius));
        double tailDist = currentDist + 12.0;

        Path streak = _windStreakPaths[i];
        streak.reset();
        streak.moveTo(cos(ang - 0.1) * tailDist, sin(ang - 0.1) * tailDist);
        streak.quadraticBezierTo(
          cos(ang - 0.05) * (currentDist + 6.0),
          sin(ang - 0.05) * (currentDist + 6.0),
          cos(ang) * currentDist,
          sin(ang) * currentDist,
        );

        canvas.drawPath(streak, _windStreakPaint);
      }

      canvas.drawCircle(Offset.zero, suckRadius, _windAreaPaint);
    }

    canvas.drawCircle(Offset.zero, radius, _darkHolePaint);
    canvas.drawCircle(Offset.zero, radius, _wallGradientPaint);
    canvas.drawCircle(Offset.zero, radius + 3.0, _rimPaint);
    canvas.drawCircle(Offset.zero, radius + 3.0, _rimHighlightPaint);
    canvas.drawCircle(Offset.zero, radius + 3.0, _rimShadowPaint);

    canvas.save();
    canvas.rotate(_rotation);

    double teethLength = 8.0;
    double teethWidth = 0.1;

    if (game.activeHole == this && game.isFallingInHole) {
      double closingProgress = 1.0 - game.ballScale;
      double teethProgress = ((closingProgress - 0.6) * 2.5).clamp(0.0, 1.0);

      teethLength = 8.0 + teethProgress * (radius + 2.0);
      teethWidth = 0.1 + (teethProgress * 0.3);
    }

    for (int i = 0; i < 8; i++) {
      double ang = i * pi / 4;
      Path tooth = _teethPaths[i];
      tooth.reset();
      tooth.moveTo(
        cos(ang - teethWidth) * radius,
        sin(ang - teethWidth) * radius,
      );
      tooth.lineTo(
        cos(ang + teethWidth) * radius,
        sin(ang + teethWidth) * radius,
      );
      tooth.lineTo(
        cos(ang) * (radius - teethLength),
        sin(ang) * (radius - teethLength),
      );
      tooth.close();
      canvas.drawPath(tooth, _teethPaint);
    }

    for (int i = 0; i < 4; i++) {
      double ang = i * pi / 2;
      double rx = cos(ang) * (radius + 3.0);
      double ry = sin(ang) * (radius + 3.0);
      canvas.drawCircle(Offset(rx, ry + 1), 2.5, _rivetShadowPaint);
      canvas.drawCircle(Offset(rx, ry), 1.5, _rivetMetalPaint);
    }
    canvas.restore();

    if (game.activeHole == this) {
      double glowAlpha = (0.3 + 0.7 * sin(_pulseTime)).clamp(0.0, 1.0);
      _glowPaint.color = Colors.white.withValues(alpha: glowAlpha);
      // Flame handles setting Paint.color alpha as a multiplier on Shader colors natively.
      canvas.drawCircle(Offset.zero, radius, _glowPaint);
    }

    canvas.restore();
  }
}
