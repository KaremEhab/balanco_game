import 'dart:math';

import 'package:balanco_game/features/game/level_system/campaign_level_generator.dart';
import 'package:balanco_game/features/game/level_system/level_definition.dart';

class EndlessChunkGenerator {
  final int runSeed;

  const EndlessChunkGenerator({required this.runSeed});

  static double endlessDifficulty({
    required int score,
    required double elapsedMinutes,
  }) {
    final scoreDifficulty = 1.0 - exp(-score / 900.0);
    final timePressure = min(elapsedMinutes * 0.012, 0.12);
    return (0.03 + scoreDifficulty * 0.87 + timePressure).clamp(0.0, 1.0);
  }

  LevelDefinition generateChunk({
    required int chunkIndex,
    required int score,
    required double elapsedMinutes,
  }) {
    final difficulty = endlessDifficulty(
      score: score,
      elapsedMinutes: elapsedMinutes,
    );
    final seed = runSeed + chunkIndex * 104729;
    final random = Random(seed);
    final recovery = chunkIndex % (difficulty > 0.8 ? 5 : 4) == 3;
    final pattern = recovery
        ? 'recovery_chunk'
        : CampaignLevelGenerator.patternTemplateIds[random.nextInt(
            CampaignLevelGenerator.patternTemplateIds.length,
          )];
    final safeX = 0.35 + random.nextDouble() * 0.3;
    final obstacles = <ObstacleDefinition>[];

    if (!recovery) {
      obstacles.add(
        ObstacleDefinition(
          id: 'chunk_${chunkIndex}_hole_1',
          type: 'regularHole',
          x: safeX < 0.5 ? 0.78 : 0.22,
          y: 0.5,
          radius: 0.046 + difficulty * 0.01,
        ),
      );
      if (difficulty > 0.25) {
        obstacles.add(
          ObstacleDefinition(
            id: 'chunk_${chunkIndex}_moving_1',
            type: 'movingHole',
            x: 1.0 - safeX,
            y: 0.72,
            radius: 0.044,
            movement: MovementDefinition(
              axis: 'horizontal',
              amplitude: min(0.24, 0.08 + difficulty * 0.16),
              periodSeconds: max(1.9, 3.4 - difficulty),
              phase: random.nextDouble(),
            ),
          ),
        );
      }
      if (difficulty > 0.5 && random.nextBool()) {
        obstacles.add(
          ObstacleDefinition(
            id: 'chunk_${chunkIndex}_suction_1',
            type: 'suckingHole',
            x: safeX < 0.5 ? 0.18 : 0.82,
            y: 0.28,
            radius: 0.048,
            suctionRadius: min(0.24, 0.15 + difficulty * 0.07),
            strength: min(0.82, 0.48 + difficulty * 0.28),
          ),
        );
      }
    }

    return LevelDefinition(
      id: chunkIndex,
      seed: seed,
      themeId: 'endless',
      difficulty: difficulty,
      worldHeight: 1.0,
      timeLimitSeconds: 0,
      scrollSpeedMultiplier: 1.0 + difficulty * 0.45,
      safeCorridorWidth: (0.32 - difficulty * 0.12).clamp(0.18, 0.32),
      safePath: [
        LevelPoint(x: 0.5, y: 0.0),
        LevelPoint(x: safeX, y: 0.5),
        LevelPoint(x: 0.5, y: 1.0),
      ],
      obstacles: obstacles,
      pickups: [
        PickupDefinition(
          id: 'chunk_${chunkIndex}_star_1',
          type: 'star',
          x: safeX,
          y: 0.42,
        ),
        PickupDefinition(
          id: 'chunk_${chunkIndex}_star_2',
          type: 'star',
          x: safeX,
          y: 0.62,
        ),
        PickupDefinition(
          id: 'chunk_${chunkIndex}_star_3',
          type: 'star',
          x: safeX,
          y: 0.82,
        ),
      ],
      patternIds: [pattern],
    );
  }
}
