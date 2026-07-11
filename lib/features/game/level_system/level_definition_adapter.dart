import 'dart:math';

import 'package:flame/components.dart';

import 'package:balanco_game/features/game/level_system/level_definition.dart';
import 'package:balanco_game/features/game/models/level_data.dart';

extension LevelDefinitionAdapter on LevelDefinition {
  LevelData toLevelData() {
    final holes = <HoleData>[];
    final bumpers = <BumperData>[];

    for (final obstacle in obstacles) {
      final fractionalPosition = _toLegacyPosition(obstacle.x, obstacle.y);
      switch (obstacle.type) {
        case 'regularHole':
        case 'movingHole':
        case 'suckingHole':
        case 'pulseHole':
        case 'orbitingHole':
        case 'chasingHole':
        case 'splittingHole':
        case 'teleportingHole':
        case 'waveHole':
        case 'nailHole':
        case 'fakeHole':
        case 'spiralSuctionHole':
        case 'breathingVortex':
          final movement = obstacle.movement;
          final behavior = _behaviorFor(obstacle);
          final hasSuction =
              behavior == HoleBehavior.spiralSuction ||
              behavior == HoleBehavior.breathingVortex ||
              obstacle.type == 'suckingHole';
          final isMoving =
              behavior != HoleBehavior.staticHole &&
              behavior != HoleBehavior.pulse &&
              behavior != HoleBehavior.fake &&
              behavior != HoleBehavior.spiralSuction &&
              behavior != HoleBehavior.breathingVortex;
          holes.add(
            HoleData(
              fractionalPosition,
              obstacle.radius * 800.0,
              (seed % 6283) / 1000.0,
              hasSuction,
              (obstacle.suctionRadius ?? obstacle.radius * 3.2) * 400.0,
              isMovingHole: isMoving,
              moveRange: movement?.amplitude ?? 0.12,
              moveSpeed: movement == null
                  ? 2.2
                  : (2.0 * pi / movement.periodSeconds),
              moveAxis: movement?.axis ?? 'horizontal',
              behavior: behavior,
              warningDuration:
                  obstacle.warningDuration ??
                  (1.25 - difficulty * 0.6).clamp(0.62, 1.25),
              activeDuration: obstacle.activeDuration ?? 1.6,
              recoveryDuration: obstacle.recoveryDuration ?? 0.8,
              forceStrength: 150.0 + (obstacle.strength ?? 0.5) * 220.0,
            ),
          );
          break;
        case 'bumper':
          bumpers.add(BumperData(fractionalPosition, obstacle.radius * 400.0));
          break;
      }
    }

    final teleporters = <TeleporterData>[];
    for (final pair in teleportPairs) {
      teleporters.add(
        TeleporterData(
          _toLegacyPosition(pair.entry.x, pair.entry.y),
          pair.radius * 400.0,
          pair.pairId,
        ),
      );
      teleporters.add(
        TeleporterData(
          _toLegacyPosition(pair.exit.x, pair.exit.y),
          pair.radius * 400.0,
          pair.pairId,
        ),
      );
    }

    final stars = <Vector2>[];
    final hearts = <Vector2>[];
    final multiBalls = <Vector2>[];
    final magnets = <Vector2>[];

    for (final pickup in pickups) {
      final position = _toLegacyPosition(pickup.x, pickup.y);
      switch (pickup.type) {
        case 'star':
          stars.add(position);
          break;
        case 'heart':
          hearts.add(position);
          break;
        case 'extraBall':
          multiBalls.add(position);
          break;
        case 'magnet':
          magnets.add(position);
          break;
      }
    }

    return LevelData(
      holes: holes,
      stars: stars,
      hearts: hearts,
      timeLimitSeconds: timeLimitSeconds,
      bumpers: bumpers,
      teleporters: teleporters,
      multiBalls: multiBalls,
      magnets: magnets,
      shooterHelpers: _isBossLevel ? [Vector2(0.5, 0.18)] : const [],
      villains: _isBossLevel
          ? [
              VillainData(
                position: Vector2(0.5, 0.045),
                variant: _bossVariant,
                health: 7 + _bossVariant * 3,
              ),
            ]
          : const [],
      heightMultiplier: worldHeight,
      timerSeconds: timeLimitSeconds.toDouble(),
      hasBomb: bombWaves.isNotEmpty,
      bombCount: bombWaves.length,
      isDarkLevel: _isBossLevel ? false : isDark,
      themeId: themeId,
      generationSeed: seed,
      difficulty: difficulty,
      safePath: safePath.map((p) => _toLegacyPosition(p.x, p.y)).toList(),
      safeCorridorWidth: safeCorridorWidth,
      darknessLightRadius: (nightMode?.lightRadius ?? 0.16) * 400.0,
      darknessStartLitSeconds: nightMode?.startLitSeconds ?? 0.0,
      isNightmare: isNightmare,
    );
  }

  bool get _isBossLevel => id == 50 || id % 100 == 0;

  int get _bossVariant {
    if (id == 50) return 0;
    return (id ~/ 100).clamp(1, 5);
  }

  Vector2 _toLegacyPosition(double x, double y) {
    final normalizedY = 1.0 - (y / worldHeight);
    return Vector2(x.clamp(0.0, 1.0), normalizedY.clamp(0.0, 1.0));
  }

  HoleBehavior _behaviorFor(ObstacleDefinition obstacle) {
    if (obstacle.behavior != null) {
      return HoleBehavior.fromName(obstacle.behavior);
    }
    if (obstacle.type == 'movingHole') return HoleBehavior.pingPong;
    if (obstacle.type == 'suckingHole') return HoleBehavior.spiralSuction;

    const explicit = <String, HoleBehavior>{
      'pulseHole': HoleBehavior.pulse,
      'orbitingHole': HoleBehavior.orbit,
      'chasingHole': HoleBehavior.chase,
      'splittingHole': HoleBehavior.split,
      'teleportingHole': HoleBehavior.teleport,
      'waveHole': HoleBehavior.wave,
      'nailHole': HoleBehavior.nailLauncher,
      'fakeHole': HoleBehavior.fake,
      'spiralSuctionHole': HoleBehavior.spiralSuction,
      'breathingVortex': HoleBehavior.breathingVortex,
    };
    final named = explicit[obstacle.type];
    if (named != null) return named;

    // Existing baked levels gain the new mechanics progressively without
    // invalidating their deterministic layouts or safe-path validation.
    final unlocks = <HoleBehavior>[
      HoleBehavior.pulse,
      if (id >= 46) HoleBehavior.wave,
      if (id >= 51) HoleBehavior.nailLauncher,
      if (id >= 76) HoleBehavior.orbit,
      if (id >= 136) HoleBehavior.teleport,
      if (id >= 166) HoleBehavior.chase,
      if (id >= 226) HoleBehavior.split,
      if (id >= 256) HoleBehavior.fake,
      if (id >= 316) HoleBehavior.breathingVortex,
    ];
    final stableHash = obstacle.id.codeUnits.fold<int>(
      17,
      (hash, unit) => (hash * 31 + unit) & 0x7fffffff,
    );
    if (id < 16 || stableHash % 4 != 0) {
      return HoleBehavior.staticHole;
    }
    return unlocks[stableHash % unlocks.length];
  }
}
