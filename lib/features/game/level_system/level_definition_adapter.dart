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
          final movement = obstacle.movement;
          holes.add(
            HoleData(
              fractionalPosition,
              obstacle.radius * 800.0,
              (seed % 6283) / 1000.0,
              obstacle.type == 'suckingHole',
              (obstacle.suctionRadius ?? obstacle.radius * 3.2) * 400.0,
              isMovingHole: obstacle.type == 'movingHole',
              moveRange: movement?.amplitude ?? 0.0,
              moveSpeed: movement == null
                  ? 0.0
                  : (2.0 * pi / movement.periodSeconds),
              moveAxis: movement?.axis ?? 'horizontal',
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
      heightMultiplier: worldHeight,
      timerSeconds: timeLimitSeconds.toDouble(),
      hasBomb: bombWaves.isNotEmpty,
      bombCount: bombWaves.length,
      isDarkLevel: isDark,
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

  Vector2 _toLegacyPosition(double x, double y) {
    final normalizedY = 1.0 - (y / worldHeight);
    return Vector2(x.clamp(0.0, 1.0), normalizedY.clamp(0.0, 1.0));
  }
}
