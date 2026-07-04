import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class HoleComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  Vector2 fractionalPosition;
  double _rotation = 0.0;
  double _pulseTime = 0.0;

  final bool isSuckingHole;
  final double suckRadius;
  final bool isMovingHole;
  final double moveRange;
  final double moveSpeed;

  double _originalFractionalX = 0.0;
  double _timeAccumulator = 0.0;

  // Cached Paints
  late final Paint _windAreaPaint;
  late final Paint _suckParticlePaint;
  late final List<Paint> _holePaints;
  late final Path _teethPath;
  late final Paint _teethPaint;
  late final Paint _teethShadow;
  late final Paint _ringShadow;
  late final Paint _ringPaint;
  late final Path _ringPath;
  late final Paint _outerEdgePaint;
  late final Paint _innerEdgePaint;
  late final Paint _rivetBasePaint;
  late final Paint _rivetHighlightPaint;
  late final Paint _splashPaint;
  late final Paint _dropPaint;
  late final Paint _glowPaint;

  double get _radius => size.x / 2;
  double get _trapInnerRadius => _radius * 0.60;
  double get _innerRadius => _radius - 5.0;

  HoleComponent(
    this.fractionalPosition,
    double holeSize,
    double rotation, {
    this.isSuckingHole = false,
    this.suckRadius = 0.0,
    this.isMovingHole = false,
    this.moveRange = 0.0,
    this.moveSpeed = 0.0,
  }) : super(size: Vector2.all(holeSize), anchor: Anchor.center, angle: 0) {
    _rotation = rotation;
    _originalFractionalX = fractionalPosition.x;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _windAreaPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          GameColors.purpleAccent.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: suckRadius));

    _suckParticlePaint = Paint()
      ..color = GameColors.purpleAccent.withValues(alpha: 0.5);

    List<Color> holeColors = isSuckingHole
        ? const [
            GameColors.holeDarkPurple,
            GameColors.holeDeepPurple,
            GameColors.holeIndigo,
            GameColors.holeVeryDark,
            GameColors.blackSolid,
          ]
        : const [
            GameColors.woodLight,
            GameColors.woodMedium,
            GameColors.woodMediumDark,
            GameColors.woodDark,
            GameColors.woodVeryDark,
            GameColors.woodDeep,
          ];

    _holePaints = holeColors.map((c) => Paint()..color = c).toList();

    int numTeeth = 8;
    double toothAngle = (2 * pi) / numTeeth;
    double toothBaseHalfWidth = 0.15; // Radians

    _teethPath = Path();
    for (int i = 0; i < numTeeth; i++) {
      double angle = i * toothAngle;
      double startAngle = angle - toothBaseHalfWidth;
      double endAngle = angle + toothBaseHalfWidth;

      _teethPath.moveTo(
        cos(startAngle) * _trapInnerRadius,
        sin(startAngle) * _trapInnerRadius,
      );
      _teethPath.lineTo(
        cos(angle) * (_trapInnerRadius * 0.25),
        sin(angle) * (_trapInnerRadius * 0.25),
      );
      _teethPath.lineTo(
        cos(endAngle) * _trapInnerRadius,
        sin(endAngle) * _trapInnerRadius,
      );
    }

    _teethPaint = Paint()
      ..color = isSuckingHole ? GameColors.purple500 : GameColors.peachPuff;

    _teethShadow = Paint()
      ..shader =
          RadialGradient(
            colors: const [GameColors.black87, Colors.transparent],
            stops: const [0.2, 1.0],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: _trapInnerRadius),
          );

    _ringShadow = Paint()
      ..color = GameColors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    _ringPaint = Paint();
    if (isSuckingHole) {
      _ringPaint.color = GameColors.purple300;
    } else {
      _ringPaint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [GameColors.goldenYellow, GameColors.goldenBrown],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: _radius));
    }

    _ringPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: _radius))
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: _trapInnerRadius))
      ..fillType = PathFillType.evenOdd;

    _outerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = isSuckingHole ? GameColors.purple100 : GameColors.lightGold;

    _innerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = GameColors.black38;

    _rivetBasePaint = Paint()
      ..color = isSuckingHole ? GameColors.purple800 : GameColors.darkGold;

    _rivetHighlightPaint = Paint()..color = GameColors.white54;

    _splashPaint = Paint();
    _dropPaint = Paint();

    _glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: isSuckingHole
            ? const [GameColors.purpleAccent, Colors.transparent]
            : const [GameColors.cyanAccent, Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: _radius));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isMovingHole && !game.isSpawningLevel) {
      _timeAccumulator += dt;
      fractionalPosition.x =
          _originalFractionalX + sin(_timeAccumulator * moveSpeed) * moveRange;
    }

    if (!game.isSpawningLevel && game.size.x > 0 && game.size.y > 0) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        120.0 + fractionalPosition.y * (game.levelHeight - 320.0),
      );
    }

    bool isActive = game.activeBalls.any((b) => b.activeHole == this);
    if (isActive) {
      _rotation -= dt * 5.0; // Swirls faster when active
      _pulseTime += dt * 4.0;
    } else {
      _rotation -= dt * 1.0;
      _pulseTime += dt * 1.5;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;

    canvas.save();
    canvas.translate(_radius, _radius);

    // --- 1. Outer Wind/Sucking Effect (if applicable) ---
    if (isSuckingHole) {
      canvas.drawCircle(Offset.zero, suckRadius, _windAreaPaint);

      for (int i = 0; i < 12; i++) {
        double t = ((_pulseTime * 0.3) + (i / 12.0)) % 1.0; // 0 to 1
        double pRadius = _innerRadius + (suckRadius - _innerRadius) * (1.0 - t);
        double ang = _rotation * 0.5 + (i * pi / 6) + (t * pi * 2);
        canvas.drawCircle(
          Offset(cos(ang) * pRadius, sin(ang) * pRadius),
          2.5 * (1.0 - t),
          _suckParticlePaint,
        );
      }
    }

    // --- 2. The Rotating Mechanical Trap ---
    canvas.save();
    canvas.rotate(_rotation);

    // 2a. The Deep Hole Background
    double step = _trapInnerRadius / _holePaints.length;
    for (int i = 0; i < _holePaints.length; i++) {
      canvas.drawCircle(
        Offset.zero,
        _trapInnerRadius - (i * step),
        _holePaints[i],
      );
    }

    // 2b. The Spikes (Teeth)
    canvas.drawPath(_teethPath, _teethPaint);
    canvas.drawCircle(Offset.zero, _trapInnerRadius, _teethShadow);

    // 2c. The Brass/Gold Ring
    canvas.drawCircle(Offset.zero, _radius, _ringShadow);
    canvas.drawPath(_ringPath, _ringPaint);
    canvas.drawCircle(Offset.zero, _radius - 1.0, _outerEdgePaint);
    canvas.drawCircle(Offset.zero, _trapInnerRadius, _innerEdgePaint);

    // 2d. The Rivets
    double rivetDistance = (_radius + _trapInnerRadius) / 2;
    double rivetRadius = (_radius - _trapInnerRadius) * 0.18;
    double toothAngle = (2 * pi) / 8; // numTeeth is 8

    for (int i = 0; i < 8; i++) {
      double angle = (i * toothAngle) + (toothAngle / 2);
      Offset rivetCenter = Offset(
        cos(angle) * rivetDistance,
        sin(angle) * rivetDistance,
      );

      canvas.drawCircle(rivetCenter, rivetRadius, _rivetBasePaint);
      canvas.drawCircle(
        rivetCenter + Offset(-rivetRadius * 0.3, -rivetRadius * 0.3),
        rivetRadius * 0.4,
        _rivetHighlightPaint,
      );
    }

    canvas.restore(); // Restore mechanical rotation

    // --- 6. Splash Effect when Ball Falls In ---
    final activeBall = game.activeBalls.cast<BallData?>().firstWhere(
      (b) => b?.activeHole == this,
      orElse: () => null,
    );

    if (activeBall != null &&
        (activeBall.isFallingInHole || activeBall.isRespawningFromHole)) {
      double splashProgress = 0.0;
      if (activeBall.isFallingInHole) {
        double closingProgress = 1.0 - activeBall.scale;
        splashProgress = ((closingProgress - 0.6) * 2.5).clamp(0.0, 1.0);
      } else {
        splashProgress = (1.0 - (activeBall.scale * 2.0)).clamp(0.0, 1.0);
      }

      if (splashProgress > 0) {
        _splashPaint.color =
            (isSuckingHole ? GameColors.purpleAccent : GameColors.white)
                .withValues(alpha: 0.85 * splashProgress);
        canvas.drawCircle(
          Offset.zero,
          _innerRadius * splashProgress,
          _splashPaint,
        );

        _dropPaint.color = GameColors.white.withValues(
          alpha: 0.7 * (1.0 - splashProgress),
        );
        for (int i = 0; i < 8; i++) {
          double ang = i * pi / 4 + _pulseTime * 2;
          double dR = _innerRadius * splashProgress + 4.0 + sin(i * 123) * 6.0;
          if (dR <= _radius * 0.45) {
            canvas.drawCircle(
              Offset(cos(ang) * dR, sin(ang) * dR),
              1.5,
              _dropPaint,
            );
          }
        }
      }
    }

    // --- 7. Outer Glow for Active/Sucking Hole ---
    if (activeBall != null) {
      double glowAlpha = (0.3 + 0.7 * sin(_pulseTime * 2)).clamp(0.0, 1.0);
      canvas.saveLayer(
        Rect.fromCircle(center: Offset.zero, radius: _radius),
        Paint()..color = GameColors.white.withValues(alpha: glowAlpha),
      );
      canvas.drawCircle(Offset.zero, _radius, _glowPaint);
      canvas.restore();
    }

    canvas.restore(); // restore main translation
  }
}
