import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:flame/events.dart';
import 'package:balanco_game/features/editor/mixins/editor_draggable.dart';
import 'package:balanco_game/features/game/components/nail_projectile_component.dart';

enum HazardPhase { dormant, warning, active, recovery }

class HoleComponent extends PositionComponent
    with
        HasGameReference<BalancoGame>,
        TapCallbacks,
        DragCallbacks,
        EditorDraggable {
  Vector2 fractionalPosition;
  double _rotation = 0.0;
  double _pulseTime = 0.0;
  bool isPassed = false;

  final bool isSuckingHole;
  double suckRadius;
  final bool isMovingHole;
  double moveRange;
  double moveSpeed;
  String moveAxis;
  final HoleBehavior behavior;
  final double warningDuration;
  final double activeDuration;
  final double recoveryDuration;
  final double forceStrength;

  double _originalFractionalX = 0.0;
  double _originalFractionalY = 0.0;
  double _timeAccumulator = 0.0;
  HazardPhase _phase = HazardPhase.active;
  double _phaseProgress = 1.0;
  bool _fakeSafe = false;
  int _teleportIndex = 0;
  double _nailTimer = 0.0;

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
  late final int nailsCount;

  late final Paint _glowPaint;
  late final Paint _splashPaint;
  late final Paint _dropPaint;

  double get _radius => size.x / 2;
  double get _trapInnerRadius => _radius * 0.60;
  double get _innerRadius => _radius - 5.0;

  HoleComponent(
    this.fractionalPosition,
    double holeSize,
    double rotation, {
    this.isSuckingHole = false,
    double suckRadius = 0.0,
    this.isMovingHole = false,
    this.moveRange = 0.0,
    this.moveSpeed = 0.0,
    this.moveAxis = 'horizontal',
    HoleBehavior? behavior,
    this.warningDuration = 0.9,
    this.activeDuration = 1.8,
    this.recoveryDuration = 0.8,
    this.forceStrength = 240.0,
  }) : behavior =
           behavior ??
           (isSuckingHole
               ? HoleBehavior.spiralSuction
               : isMovingHole
               ? HoleBehavior.pingPong
               : HoleBehavior.staticHole),
       suckRadius = suckRadius > 0.0 ? suckRadius : holeSize * 2.0,
       super(size: Vector2.all(holeSize), anchor: Anchor.center, angle: 0) {
    _rotation = rotation;
    _originalFractionalX = fractionalPosition.x;
    _originalFractionalY = fractionalPosition.y;
  }

  bool get isDangerous {
    if (_fakeSafe) return false;
    return switch (behavior) {
      HoleBehavior.pulse ||
      HoleBehavior.teleport => _phase == HazardPhase.active,
      _ => true,
    };
  }

  bool get hasForceField =>
      isSuckingHole ||
      behavior == HoleBehavior.spiralSuction ||
      behavior == HoleBehavior.breathingVortex;

  double get currentSuckRadius {
    if (behavior != HoleBehavior.breathingVortex) return suckRadius;
    return suckRadius * (0.58 + 0.42 * ((sin(_timeAccumulator * 2.4) + 1) / 2));
  }

  List<Vector2> get collisionCenters {
    if (behavior == HoleBehavior.split && _phase == HazardPhase.active) {
      final separation = _radius * (sin(_phaseProgress * pi) * 1.5);
      return [
        position + Vector2(-separation, 0),
        position + Vector2(separation, 0),
      ];
    }
    return [position];
  }

  Vector2 forceAt(Vector2 point) {
    if (!hasForceField || !isDangerous) return Vector2.zero();
    final delta = position - point;
    final distance = delta.length;
    final radius = currentSuckRadius * scale.x;
    if (distance <= 0.001 || distance >= radius) return Vector2.zero();
    final radial = delta / distance;
    final falloff = 1.0 - distance / radius;
    if (behavior == HoleBehavior.spiralSuction) {
      final tangent = Vector2(-radial.y, radial.x);
      return (radial * 0.78 + tangent * 0.42) * forceStrength * falloff;
    }
    return radial * forceStrength * falloff;
  }

  void updateSuckRadius(double newRadius) {
    suckRadius = newRadius;
    _createWindShader();
  }

  void _createWindShader() {
    final currentBiome = game.currentBiome;
    _windAreaPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          currentBiome.primaryColor.withValues(alpha: 0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: suckRadius));
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if (!game.isEditMode) {
      if (behavior != HoleBehavior.staticHole &&
          behavior != HoleBehavior.pingPong &&
          behavior != HoleBehavior.spiralSuction) {
        game.queueTutorial('hole_${behavior.name}');
      } else if (isSuckingHole) {
        game.queueTutorial('sucking_hole');
      } else if (isMovingHole) {
        game.queueTutorial('moving_hole');
      } else {
        game.queueTutorial('hole');
      }
    }

    final currentBiome = game.currentBiome;

    _createWindShader();

    _suckParticlePaint = Paint()
      ..color = currentBiome.primaryColor.withValues(alpha: 0.5);

    List<Color> holeColors = isSuckingHole
        ? [
            currentBiome.primaryColor,
            currentBiome.secondaryColor,
            currentBiome.nodeUnlockedBorderColor,
            currentBiome.nodeLockedBorderColor,
            GameColors.blackSolid,
          ]
        : [
            currentBiome.nodeUnlockedColor,
            currentBiome.primaryColor,
            currentBiome.secondaryColor,
            currentBiome.nodeUnlockedBorderColor,
            currentBiome.nodeLockedBorderColor,
            GameColors.blackSolid,
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

    // Replica obstacles are positioned by authoritative snapshots. Running
    // movement here as well makes them oscillate locally and then get pulled
    // back to the sender's position, which appears as visible shaking.
    if (game.isCoopReplica) {
      _timeAccumulator += dt;
      _updatePhase();
      _rotation -= dt;
      _pulseTime += dt * 1.5;
      return;
    }

    _timeAccumulator += dt;
    _updatePhase();
    _updateNailLauncher(dt);

    if (game.isInfinityMode) {
      // In infinity mode: fractionalPosition stores the ABSOLUTE pixel center
      if (isMovingHole && !game.isSpawningLevel) {
        _updateInfinityMovement(dt);
      } else {
        position.x = fractionalPosition.x;
      }
      // position.y is already set at spawn and stays fixed
      return;
    }

    if (!game.isSpawningLevel) {
      _updateMovement(dt);
    }

    if (!game.isEditMode &&
        !game.isSpawningLevel &&
        game.size.x > 0 &&
        game.size.y > 0) {
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

  void _updateInfinityMovement(double dt) {
    final speed = moveSpeed == 0 ? 2.2 : moveSpeed * 0.02;
    final range = moveRange == 0 ? 50.0 : moveRange;
    switch (behavior) {
      case HoleBehavior.orbit:
        position.x =
            _originalFractionalX + cos(_timeAccumulator * speed) * range;
        position.y =
            _originalFractionalY + sin(_timeAccumulator * speed) * range * 0.55;
      case HoleBehavior.wave:
        position.x =
            _originalFractionalX + sin(_timeAccumulator * speed) * range;
        position.y =
            _originalFractionalY +
            cos(_timeAccumulator * speed * 0.5) * range * 0.45;
      case HoleBehavior.chase:
        if (game.activeBalls.isNotEmpty) {
          final targetX = game.activeBalls.first.pos2D.x;
          final maxStep = 55.0 * dt;
          position.x += (targetX - position.x).clamp(-maxStep, maxStep);
        }
      case HoleBehavior.teleport:
        position.x =
            (_originalFractionalX + (_teleportIndex.isEven ? -range : range))
                .clamp(
                  game.barPadding + _radius,
                  game.size.x - game.barPadding - _radius,
                );
      default:
        final offset = sin(_timeAccumulator * speed) * range;
        if (moveAxis == 'vertical') {
          position.y = _originalFractionalY + offset;
        } else {
          position.x = _originalFractionalX + offset;
        }
    }
  }

  void _updatePhase() {
    final usesPhases =
        behavior == HoleBehavior.pulse ||
        behavior == HoleBehavior.teleport ||
        behavior == HoleBehavior.split ||
        behavior == HoleBehavior.nailLauncher;
    if (!usesPhases) {
      _phase = HazardPhase.active;
      _phaseProgress = 1.0;
    } else {
      const dormantDuration = 0.65;
      final cycle =
          dormantDuration + warningDuration + activeDuration + recoveryDuration;
      var cursor = _timeAccumulator % cycle;
      if (cursor < dormantDuration) {
        _phase = HazardPhase.dormant;
        _phaseProgress = cursor / dormantDuration;
      } else if ((cursor -= dormantDuration) < warningDuration) {
        _phase = HazardPhase.warning;
        _phaseProgress = cursor / warningDuration;
      } else if ((cursor -= warningDuration) < activeDuration) {
        _phase = HazardPhase.active;
        _phaseProgress = cursor / activeDuration;
      } else {
        cursor -= activeDuration;
        _phase = HazardPhase.recovery;
        _phaseProgress = cursor / recoveryDuration;
      }
    }

    if (behavior == HoleBehavior.fake && game.activeBalls.isNotEmpty) {
      final nearest = game.activeBalls
          .map((ball) => ball.pos2D.distanceTo(position))
          .reduce(min);
      _fakeSafe = nearest < _radius * 2.4;
    } else {
      _fakeSafe = false;
    }
  }

  void _updateMovement(double dt) {
    final speed = moveSpeed == 0 ? 2.2 : moveSpeed;
    final range = moveRange == 0 ? 0.12 : moveRange;
    switch (behavior) {
      case HoleBehavior.pingPong:
        final offset = sin(_timeAccumulator * speed) * range;
        if (moveAxis == 'vertical') {
          fractionalPosition.y = _originalFractionalY + offset;
        } else {
          fractionalPosition.x = _originalFractionalX + offset;
        }
      case HoleBehavior.orbit:
        fractionalPosition.x =
            _originalFractionalX + cos(_timeAccumulator * speed) * range;
        fractionalPosition.y =
            _originalFractionalY + sin(_timeAccumulator * speed) * range * 0.55;
      case HoleBehavior.wave:
        fractionalPosition.x =
            _originalFractionalX + sin(_timeAccumulator * speed) * range;
        fractionalPosition.y =
            _originalFractionalY +
            cos(_timeAccumulator * speed * 0.5) * range * 0.45;
      case HoleBehavior.chase:
        if (fractionalPosition.y > 0.12 &&
            game.activeBalls.isNotEmpty &&
            game.size.x > 0) {
          final targetX = game.activeBalls.first.pos2D.x / game.size.x;
          final maxStep = 0.075 * dt;
          final error = (targetX - fractionalPosition.x).clamp(
            -maxStep,
            maxStep,
          );
          fractionalPosition.x = (fractionalPosition.x + error).clamp(
            0.08,
            0.92,
          );
        }
      case HoleBehavior.teleport:
        final nextIndex =
            (_timeAccumulator /
                    (0.65 +
                        warningDuration +
                        activeDuration +
                        recoveryDuration))
                .floor();
        if (nextIndex != _teleportIndex) _teleportIndex = nextIndex;
        fractionalPosition.x =
            (_originalFractionalX + (_teleportIndex.isEven ? -range : range))
                .clamp(0.08, 0.92);
      default:
        break;
    }
  }

  void _updateNailLauncher(double dt) {
    if (behavior != HoleBehavior.nailLauncher ||
        game.isEditMode ||
        game.isSpawningLevel ||
        _phase != HazardPhase.active) {
      return;
    }
    _nailTimer += dt;
    if (_nailTimer < 1.35) return;
    _nailTimer = 0.0;
    final targets = game.activeBalls.where((ball) => !ball.isDead).toList();
    if (targets.isEmpty) return;
    final target = targets.reduce(
      (a, b) =>
          a.pos2D.distanceTo(position) < b.pos2D.distanceTo(position) ? a : b,
    );
    final direction = target.pos2D - position;
    if (direction.length2 == 0) return;
    direction.normalize();
    game.levelContainer.add(
      NailProjectileComponent(position: position.clone(), direction: direction)
        ..priority = 80,
    );
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;

    canvas.save();
    canvas.translate(_radius, _radius);

    final phaseVisualScale = switch (_phase) {
      HazardPhase.dormant => 0.12,
      HazardPhase.warning => 0.12 + _phaseProgress * 0.88,
      HazardPhase.active => 1.0,
      HazardPhase.recovery => 1.0 - _phaseProgress * 0.88,
    };
    final visualScale = _fakeSafe ? 0.42 : phaseVisualScale;
    canvas.scale(visualScale);

    if (_phase == HazardPhase.warning) {
      final warningPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = GameColors.orangeAccent.withValues(
          alpha: 0.45 + _phaseProgress * 0.55,
        );
      canvas.drawCircle(
        Offset.zero,
        _radius * (1.35 - _phaseProgress * 0.2),
        warningPaint,
      );
    }

    final activeBall = game.activeBalls.cast<BallData?>().firstWhere(
      (b) => b?.activeHole == this,
      orElse: () => null,
    );

    if (behavior == HoleBehavior.split && _phase == HazardPhase.active) {
      final separation = _radius * (sin(_phaseProgress * pi) * 1.5);

      canvas.save();
      canvas.translate(-separation, 0);
      _drawSingleHole(canvas, activeBall);
      canvas.restore();

      canvas.save();
      canvas.translate(separation, 0);
      _drawSingleHole(canvas, activeBall);
      canvas.restore();
    } else {
      _drawSingleHole(canvas, activeBall);
    }

    canvas.restore();

    if (behavior == HoleBehavior.teleport &&
        (_phase == HazardPhase.warning || _phase == HazardPhase.recovery)) {
      final range = moveRange == 0
          ? (game.isInfinityMode ? 50.0 : game.size.x * 0.12)
          : (game.isInfinityMode ? moveRange : moveRange * game.size.x);
      final nextDirection = _teleportIndex.isEven ? 1.0 : -1.0;
      final destinationPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = GameColors.cyanAccent.withValues(
          alpha: 0.35 + _phaseProgress * 0.6,
        );
      canvas.drawCircle(
        Offset(_radius + nextDirection * range * 2, _radius),
        _radius * (0.75 + _phaseProgress * 0.2),
        destinationPaint,
      );
    }

    if (behavior == HoleBehavior.nailLauncher) {
      final nailPaint = Paint()..color = GameColors.blueGrey.shade200;
      for (var index = 0; index < 8; index++) {
        final angle = index * pi / 4 + _rotation * 0.25;
        canvas.save();
        canvas.translate(
          _radius + cos(angle) * _radius * 0.68,
          _radius + sin(angle) * _radius * 0.68,
        );
        canvas.rotate(angle);
        canvas.drawPath(
          Path()
            ..moveTo(-2, -3)
            ..lineTo(_radius * 0.42, 0)
            ..lineTo(-2, 3)
            ..close(),
          nailPaint,
        );
        canvas.restore();
      }
    }
    renderEditorHighlight(canvas);
  }

  void _drawSingleHole(Canvas canvas, BallData? activeBall) {
    // --- 1. Outer Wind/Sucking Effect (if applicable) ---
    if (hasForceField) {
      canvas.drawCircle(Offset.zero, currentSuckRadius, _windAreaPaint);

      for (int i = 0; i < 12; i++) {
        double t = ((_pulseTime * 0.3) + (i / 12.0)) % 1.0; // 0 to 1
        double pRadius =
            _innerRadius + (currentSuckRadius - _innerRadius) * (1.0 - t);
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
  }
}
