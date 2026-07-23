import 'dart:math' as math;

import 'package:balanco_game/features/battle/domain/battle_race_state.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

typedef BattleTargetProvider = Vector2? Function();

class BattleWeaponEffectComponent extends PositionComponent {
  BattleWeaponEffectComponent({
    required this.weapon,
    required Vector2 sourcePosition,
    required this.targetProvider,
    this.onImpact,
  }) : _source = sourcePosition.clone(),
       super(priority: 30);

  final BattleWeaponDefinition weapon;
  final BattleTargetProvider targetProvider;
  final VoidCallback? onImpact;
  final Vector2 _source;
  final List<Vector2> _rocketTrail = [];

  double _elapsed = 0;
  double _trailAccumulator = 0;
  bool _impacted = false;
  bool _completed = false;
  Vector2? _lastTarget;
  Vector2? _impactPosition;

  @visibleForTesting
  bool get hasImpacted => _impacted;

  @visibleForTesting
  bool get isComplete => _completed;

  @visibleForTesting
  Vector2? get trackedTarget => _lastTarget?.clone();

  double get _warningDuration => switch (weapon.id) {
    'battle_rocket' => 0.12,
    'battle_bomb' => 0.42,
    'battle_nails' => 0.08,
    _ => 0.16,
  };

  double get _travelDuration => switch (weapon.id) {
    'battle_rocket' => 0.72,
    'battle_bomb' => 0.58,
    'battle_nails' => 0.46,
    _ => 0.42,
  };

  double get _impactDuration => switch (weapon.id) {
    'battle_rocket' => 0.52,
    'battle_bomb' => 0.62,
    'battle_nails' => 0.46,
    _ => 0.42,
  };

  double get _travelProgress =>
      ((_elapsed - _warningDuration) / _travelDuration).clamp(0.0, 1.0);

  double get _impactProgress =>
      ((_elapsed - _warningDuration - _travelDuration) / _impactDuration).clamp(
        0.0,
        1.0,
      );

  @override
  void update(double dt) {
    super.update(dt);
    if (_completed) return;
    _elapsed += dt;
    final target = targetProvider();
    if (target != null) _lastTarget = target.clone();
    final tracked = _lastTarget;
    if (tracked == null) return;

    if (weapon.id == BattleWeaponCatalog.rocket.id &&
        _elapsed >= _warningDuration &&
        !_impacted) {
      _trailAccumulator += dt;
      if (_trailAccumulator >= 0.035) {
        _trailAccumulator = 0;
        _rocketTrail.add(_rocketPosition(_travelProgress, tracked));
        if (_rocketTrail.length > 12) _rocketTrail.removeAt(0);
      }
    }

    if (!_impacted && _elapsed >= _warningDuration + _travelDuration) {
      _impacted = true;
      _impactPosition = tracked.clone();
      onImpact?.call();
    }
    if (_elapsed >= _warningDuration + _travelDuration + _impactDuration) {
      _completed = true;
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final target = _lastTarget ?? targetProvider();
    if (target == null) return;
    if (_impacted) {
      _renderImpact(canvas, _impactPosition ?? target);
      return;
    }

    switch (weapon.id) {
      case 'battle_rocket':
        _renderRocket(canvas, target);
      case 'battle_bomb':
        _renderBomb(canvas, target);
      case 'battle_nails':
        _renderNails(canvas, target);
      default:
        _renderHeatWave(canvas, target);
    }
  }

  Vector2 _rocketPosition(double progress, Vector2 target) {
    final eased = Curves.easeInOutCubic.transform(progress);
    final delta = target - _source;
    final length = math.max(1.0, delta.length);
    final perpendicular = Vector2(-delta.y / length, delta.x / length);
    final arc = math.sin(progress * math.pi) * math.min(70.0, length * 0.22);
    return _source + delta * eased + perpendicular * arc;
  }

  void _renderRocket(Canvas canvas, Vector2 target) {
    if (_elapsed < _warningDuration) {
      _renderTargetLock(canvas, target, const Color(0xFFFF6659));
      return;
    }
    final progress = _travelProgress;
    final rocket = _rocketPosition(progress, target);
    final future = _rocketPosition(math.min(1.0, progress + 0.025), target);
    final angle = math.atan2(future.y - rocket.y, future.x - rocket.x);

    for (var index = 0; index < _rocketTrail.length; index++) {
      final point = _rocketTrail[index];
      final opacity = (index + 1) / (_rocketTrail.length + 1);
      canvas.drawCircle(
        point.toOffset(),
        3 + opacity * 5,
        Paint()
          ..color = Colors.white.withValues(alpha: opacity * 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }

    canvas.save();
    canvas.translate(rocket.x, rocket.y);
    canvas.rotate(angle);
    final flameLength = 15 + math.sin(_elapsed * 35) * 4;
    final flame = Path()
      ..moveTo(-15, 0)
      ..quadraticBezierTo(-18 - flameLength, -7, -15 - flameLength, 0)
      ..quadraticBezierTo(-18 - flameLength, 7, -15, 0);
    canvas.drawPath(
      flame,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFF176), Color(0xFFFF5722)],
        ).createShader(const Rect.fromLTWH(-40, -9, 30, 18)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-8, -7)
        ..lineTo(-16, -14)
        ..lineTo(-14, -3)
        ..close()
        ..moveTo(-8, 7)
        ..lineTo(-16, 14)
        ..lineTo(-14, 3)
        ..close(),
      Paint()..color = const Color(0xFF40C4FF),
    );
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-15, -7, 28, 14),
      const Radius.circular(7),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFB0BEC5), Color(0xFF607D8B)],
        ).createShader(const Rect.fromLTWH(-15, -7, 28, 14)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(13, -7)
        ..quadraticBezierTo(27, 0, 13, 7)
        ..close(),
      Paint()..color = const Color(0xFFFF5148),
    );
    canvas.drawCircle(
      const Offset(2, 0),
      3.2,
      Paint()..color = const Color(0xFF182A61),
    );
    canvas.restore();
  }

  void _renderBomb(Canvas canvas, Vector2 target) {
    _renderTargetLock(canvas, target, const Color(0xFFFFC247));
    if (_elapsed < _warningDuration) return;

    final progress = Curves.easeInCubic.transform(_travelProgress);
    final start = Vector2(target.x, math.max(20.0, target.y - 220));
    final bomb = Vector2(
      start.x + (target.x - start.x) * progress,
      start.y + (target.y - start.y) * progress,
    );
    canvas.drawLine(
      Offset(bomb.x, math.max(0, bomb.y - 56)),
      bomb.toOffset(),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.28)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.save();
    canvas.translate(bomb.x, bomb.y);
    canvas.rotate(_elapsed * 5.5);
    canvas.drawCircle(
      Offset.zero,
      16,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.35),
          colors: [Color(0xFF7384A6), Color(0xFF1D2740), Colors.black],
        ).createShader(const Rect.fromLTWH(-16, -16, 32, 32)),
    );
    canvas.drawCircle(
      Offset.zero,
      16,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      const Offset(7, -12),
      const Offset(13, -21),
      Paint()
        ..color = const Color(0xFF7C4A2E)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    final spark = 4 + math.sin(_elapsed * 42).abs() * 4;
    canvas.drawCircle(
      const Offset(14, -22),
      spark,
      Paint()
        ..color = const Color(0xFFFFC107)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.restore();
  }

  void _renderNails(Canvas canvas, Vector2 target) {
    if (_elapsed < _warningDuration) {
      _renderTargetLock(canvas, target, const Color(0xFFD6E4F5));
      return;
    }
    final delta = target - _source;
    final angle = math.atan2(delta.y, delta.x);
    final perpendicular = Vector2(-math.sin(angle), math.cos(angle));
    for (var index = 0; index < 7; index++) {
      final progress = (_travelProgress * 1.30 - index * 0.055).clamp(0.0, 1.0);
      if (progress <= 0) continue;
      final spread = (index - 3) * 5.5 * math.sin(progress * math.pi);
      final point =
          _source +
          delta * Curves.easeOutCubic.transform(progress) +
          perpendicular * spread;
      canvas.save();
      canvas.translate(point.x, point.y);
      canvas.rotate(angle + (index - 3) * 0.018);
      canvas.drawLine(
        const Offset(-15, 0),
        const Offset(-4, 0),
        Paint()
          ..color = const Color(0x8035DFFF)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
      final nail = Path()
        ..moveTo(-6, -2.5)
        ..lineTo(10, -1.5)
        ..lineTo(17, 0)
        ..lineTo(10, 1.5)
        ..lineTo(-6, 2.5)
        ..close();
      canvas.drawPath(
        nail,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFF90A4AE), Color(0xFF455A64)],
          ).createShader(const Rect.fromLTWH(-6, -3, 23, 6)),
      );
      canvas.drawRect(
        const Rect.fromLTWH(-9, -5, 3, 10),
        Paint()..color = const Color(0xFFCFD8DC),
      );
      canvas.restore();
    }
  }

  void _renderHeatWave(Canvas canvas, Vector2 target) {
    final progress = _elapsed < _warningDuration ? 0.0 : _travelProgress;
    final delta = target - _source;
    final angle = math.atan2(delta.y, delta.x);
    final distance = delta.length * Curves.easeOutCubic.transform(progress);
    canvas.save();
    canvas.translate(_source.x, _source.y);
    canvas.rotate(angle);
    for (var index = 0; index < 4; index++) {
      final x = math.max(0.0, distance - index * 25);
      final alpha = (1 - index / 5) * (0.45 + progress * 0.45);
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(x, 0),
          width: 24 + index * 9,
          height: 52 + index * 14,
        ),
        -math.pi / 2,
        math.pi,
        false,
        Paint()
          ..color = const Color(0xFFFF7043).withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5 - index * 0.6
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.restore();
  }

  void _renderTargetLock(Canvas canvas, Vector2 target, Color color) {
    final pulse = 0.5 + math.sin(_elapsed * 28).abs() * 0.5;
    final radius = 24 + pulse * 8;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55 + pulse * 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(target.toOffset(), radius, paint);
    for (var index = 0; index < 4; index++) {
      final angle = index * math.pi / 2;
      final inner = Offset(
        target.x + math.cos(angle) * (radius - 7),
        target.y + math.sin(angle) * (radius - 7),
      );
      final outer = Offset(
        target.x + math.cos(angle) * (radius + 7),
        target.y + math.sin(angle) * (radius + 7),
      );
      canvas.drawLine(inner, outer, paint);
    }
  }

  void _renderImpact(Canvas canvas, Vector2 target) {
    final progress = _impactProgress;
    final fade = 1 - progress;
    final color = switch (weapon.id) {
      'battle_rocket' => const Color(0xFFFF5A4F),
      'battle_bomb' => const Color(0xFFFFB52E),
      'battle_nails' => const Color(0xFFB9D8EE),
      _ => const Color(0xFFFF7043),
    };
    final radius = switch (weapon.id) {
      'battle_bomb' => 24 + progress * 72,
      'battle_rocket' => 18 + progress * 54,
      'battle_nails' => 14 + progress * 38,
      _ => 20 + progress * 58,
    };
    canvas.drawCircle(
      target.toOffset(),
      radius,
      Paint()
        ..color = color.withValues(alpha: fade * 0.32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8 * fade + 1,
    );
    canvas.drawCircle(
      target.toOffset(),
      radius * 0.52,
      Paint()
        ..color = Colors.white.withValues(alpha: fade * 0.72)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final shardCount = weapon.id == BattleWeaponCatalog.nails.id ? 12 : 9;
    for (var index = 0; index < shardCount; index++) {
      final angle =
          index * math.pi * 2 / shardCount + (index.isEven ? 0.14 : -0.08);
      final distance = 10 + progress * (42 + (index % 3) * 12);
      final center = Offset(
        target.x + math.cos(angle) * distance,
        target.y + math.sin(angle) * distance,
      );
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle + progress * 3);
      final shard = Path()
        ..moveTo(9 * fade + 2, 0)
        ..lineTo(-4, -3.5 * fade)
        ..lineTo(-2, 4 * fade)
        ..close();
      canvas.drawPath(
        shard,
        Paint()..color = color.withValues(alpha: fade * 0.95),
      );
      canvas.restore();
    }

    if (weapon.id == BattleWeaponCatalog.rocket.id ||
        weapon.id == BattleWeaponCatalog.nails.id) {
      for (var index = -1; index <= 1; index++) {
        canvas.drawLine(
          Offset(target.x - 18, target.y + index * 7 - 5),
          Offset(target.x + 18, target.y + index * 7 + 5),
          Paint()
            ..color = Colors.white.withValues(alpha: fade * 0.9)
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }
}
