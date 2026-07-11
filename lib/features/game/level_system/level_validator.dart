import 'dart:math';

import 'package:balanco_game/features/game/level_system/level_definition.dart';

class LevelValidationResult {
  final bool isValid;
  final List<String> errors;

  const LevelValidationResult._(this.isValid, this.errors);

  const LevelValidationResult.valid() : this._(true, const []);
  const LevelValidationResult.invalid(List<String> errors)
    : this._(false, errors);
}

class LevelValidator {
  static const double _startClearanceY = 0.18;
  static const double _finishClearanceY = 0.18;
  static const double _minBombWarningSeconds = 2.25;

  LevelValidationResult validate(LevelDefinition level) {
    final errors = <String>[];

    if (level.id < 1 || level.id > 500) {
      errors.add('level id must be between 1 and 500');
    }
    if (level.worldHeight <= 0 || level.worldHeight > 8.0) {
      errors.add('world height is out of range');
    }
    if (level.safePath.length < 2) {
      errors.add('safe path must include start and finish points');
    }

    _validatePoints(level, errors);
    _validateIds(level, errors);
    _validateCounts(level, errors);
    _validateClearAreas(level, errors);
    _validateOverlap(level, errors);
    _validateTemporalHazards(level, errors);
    _validateTeleporters(level, errors);
    _validateDarkness(level, errors);
    _validateRoute(level, errors);

    return errors.isEmpty
        ? const LevelValidationResult.valid()
        : LevelValidationResult.invalid(errors);
  }

  void _validatePoints(LevelDefinition level, List<String> errors) {
    for (final point in level.safePath) {
      if (!_isFinite(point.x) || !_isFinite(point.y)) {
        errors.add('safe path has non-finite coordinate');
      }
      if (point.x < 0 ||
          point.x > 1 ||
          point.y < 0 ||
          point.y > level.worldHeight) {
        errors.add('safe path point is out of range');
      }
    }

    for (final obstacle in level.obstacles) {
      if (!_isFinite(obstacle.x) ||
          !_isFinite(obstacle.y) ||
          !_isFinite(obstacle.radius)) {
        errors.add('${obstacle.id} has non-finite coordinate');
      }
      if (obstacle.x < 0.04 ||
          obstacle.x > 0.96 ||
          obstacle.y < 0 ||
          obstacle.y > level.worldHeight ||
          obstacle.radius <= 0) {
        errors.add('${obstacle.id} is out of range');
      }
    }

    for (final pickup in level.pickups) {
      if (!_isFinite(pickup.x) || !_isFinite(pickup.y)) {
        errors.add('${pickup.id} has non-finite coordinate');
      }
      if (pickup.x < 0.04 ||
          pickup.x > 0.96 ||
          pickup.y < 0 ||
          pickup.y > level.worldHeight) {
        errors.add('${pickup.id} is out of range');
      }
    }
  }

  void _validateIds(LevelDefinition level, List<String> errors) {
    final ids = <String>{};
    for (final obstacle in level.obstacles) {
      if (!ids.add(obstacle.id)) errors.add('duplicate id ${obstacle.id}');
    }
    for (final pickup in level.pickups) {
      if (!ids.add(pickup.id)) errors.add('duplicate id ${pickup.id}');
    }
    for (final wave in level.bombWaves) {
      if (!ids.add(wave.id)) errors.add('duplicate id ${wave.id}');
    }
    for (final pair in level.teleportPairs) {
      if (!ids.add(pair.id)) errors.add('duplicate id ${pair.id}');
    }
  }

  void _validateCounts(LevelDefinition level, List<String> errors) {
    final stars = level.pickups.where((p) => p.type == 'star').length;
    if (stars != 3) {
      errors.add('campaign levels must have exactly 3 stars');
    }
    final visibleHazardLimit = max(
      8,
      (6 + level.difficulty * 12 + level.worldHeight * 1.5).round(),
    );
    final maxWindow = _maxHazardsInWindow(level, 1.0);
    if (maxWindow > visibleHazardLimit) {
      errors.add(
        'too many simultaneous hazards: $maxWindow > $visibleHazardLimit',
      );
    }
  }

  void _validateClearAreas(LevelDefinition level, List<String> errors) {
    for (final obstacle in level.obstacles) {
      final nearStart = obstacle.y <= _startClearanceY;
      final nearFinish = obstacle.y >= level.worldHeight - _finishClearanceY;
      if ((nearStart || nearFinish) && (obstacle.x - 0.5).abs() < 0.22) {
        errors.add('${obstacle.id} obstructs start or finish');
      }
    }
  }

  void _validateOverlap(LevelDefinition level, List<String> errors) {
    final hazards = level.obstacles
        .where(
          (o) =>
              o.type == 'regularHole' ||
              o.type == 'movingHole' ||
              o.type == 'suckingHole' ||
              o.type == 'bumper',
        )
        .toList();
    for (var i = 0; i < hazards.length; i++) {
      for (var j = i + 1; j < hazards.length; j++) {
        final a = hazards[i];
        final b = hazards[j];
        final dy = (a.y - b.y) * 0.5;
        final dx = a.x - b.x;
        final distance = sqrt(dx * dx + dy * dy);
        if (distance < a.radius + b.radius + 0.025) {
          errors.add('${a.id} overlaps ${b.id}');
        }
      }
    }

    for (final pickup in level.pickups.where((p) => p.type == 'star')) {
      for (final hazard in hazards) {
        final dy = (pickup.y - hazard.y) * 0.5;
        final dx = pickup.x - hazard.x;
        if (sqrt(dx * dx + dy * dy) < hazard.radius + 0.045) {
          errors.add('${pickup.id} overlaps ${hazard.id}');
        }
      }
    }
  }

  void _validateTemporalHazards(LevelDefinition level, List<String> errors) {
    var suctionStrength = 0.0;
    for (final obstacle in level.obstacles) {
      final movement = obstacle.movement;
      if (movement != null) {
        if (movement.amplitude > 0.28 || movement.periodSeconds < 1.7) {
          errors.add('${obstacle.id} movement is too aggressive');
        }
      }
      if (obstacle.type == 'suckingHole') {
        final strength = obstacle.strength ?? 0.55;
        suctionStrength += strength;
        if (strength > 0.9 || (obstacle.suctionRadius ?? 0) > 0.26) {
          errors.add('${obstacle.id} suction exceeds fair caps');
        }
      }
    }
    if (suctionStrength > 8.0) {
      errors.add('combined suction strength is too high');
    }

    for (final bomb in level.bombWaves) {
      if (bomb.warningDuration < _minBombWarningSeconds) {
        errors.add('${bomb.id} warning is too short');
      }
    }
  }

  void _validateTeleporters(LevelDefinition level, List<String> errors) {
    final pairIds = <int>{};
    for (final pair in level.teleportPairs) {
      if (!pairIds.add(pair.pairId)) {
        errors.add('duplicate teleport pair ${pair.pairId}');
      }
      if (_pointUnsafe(level, pair.exit, pair.radius + 0.08)) {
        errors.add('${pair.id} exits into an unsafe area');
      }
    }
  }

  void _validateDarkness(LevelDefinition level, List<String> errors) {
    final night = level.nightMode;
    if (night == null || !night.enabled) return;
    if (night.lightPickups.isEmpty) {
      errors.add('dark level has no light pickups');
      return;
    }
    final firstLight = night.lightPickups.reduce((a, b) => a.y < b.y ? a : b);
    if (firstLight.y > level.worldHeight * 0.35) {
      errors.add('first light pickup is too late in dark level');
    }
  }

  void _validateRoute(LevelDefinition level, List<String> errors) {
    final samples = max(10, (level.worldHeight * 8).ceil());
    for (var i = 0; i <= samples; i++) {
      final y = level.worldHeight * i / samples;
      final x = _safeXAt(level.safePath, y);
      if (_pointUnsafe(
        level,
        LevelPoint(x: x, y: y),
        level.safeCorridorWidth * 0.18,
      )) {
        errors.add('safe route blocked near y=${y.toStringAsFixed(2)}');
        return;
      }
    }
  }

  bool _pointUnsafe(LevelDefinition level, LevelPoint point, double clearance) {
    for (final obstacle in level.obstacles) {
      final dy = (point.y - obstacle.y) * 0.5;
      final dx = point.x - obstacle.x;
      final movementBuffer = (obstacle.movement?.amplitude ?? 0.0) * 0.35;
      final radius = obstacle.radius + movementBuffer + clearance;
      if (sqrt(dx * dx + dy * dy) < radius) return true;
    }
    return false;
  }

  int _maxHazardsInWindow(LevelDefinition level, double windowHeight) {
    var maxCount = 0;
    for (double y = 0; y <= level.worldHeight; y += 0.25) {
      final count = level.obstacles
          .where((o) => o.y >= y && o.y <= y + windowHeight)
          .length;
      maxCount = max(maxCount, count);
    }
    return maxCount;
  }

  double _safeXAt(List<LevelPoint> path, double y) {
    if (path.isEmpty) return 0.5;
    if (y <= path.first.y) return path.first.x;
    for (var i = 0; i < path.length - 1; i++) {
      final a = path[i];
      final b = path[i + 1];
      if (y >= a.y && y <= b.y) {
        final t = (y - a.y) / (b.y - a.y);
        final smooth = t * t * (3.0 - 2.0 * t);
        return a.x + (b.x - a.x) * smooth;
      }
    }
    return path.last.x;
  }

  bool _isFinite(double value) => !value.isNaN && value.isFinite;
}
