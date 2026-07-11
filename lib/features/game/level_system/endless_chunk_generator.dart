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
    final pattern = recovery ? 'recovery_chunk' : _patternFor(chunkIndex);
    final safeX = 0.35 + random.nextDouble() * 0.3;
    final obstacles = <ObstacleDefinition>[];

    if (!recovery) {
      final behaviors = <String>[
        'pulse',
        if (difficulty > 0.18) 'wave',
        if (difficulty > 0.24) 'nailLauncher',
        if (difficulty > 0.32) 'orbit',
        if (difficulty > 0.48) 'teleport',
        if (difficulty > 0.62) 'split',
        if (difficulty > 0.74) 'chase',
      ];
      final primaryBehavior =
          behaviors[(chunkIndex + runSeed.abs()) % behaviors.length];
      obstacles.add(
        ObstacleDefinition(
          id: 'chunk_${chunkIndex}_hole_1',
          type: 'regularHole',
          x: safeX < 0.5 ? 0.78 : 0.22,
          y: 0.5,
          radius: 0.046 + difficulty * 0.01,
          behavior: primaryBehavior,
          warningDuration: (1.25 - difficulty * 0.6)
              .clamp(0.65, 1.25)
              .toDouble(),
          activeDuration: 1.8,
          recoveryDuration: 0.8,
          movement: switch (primaryBehavior) {
            'wave' ||
            'orbit' ||
            'teleport' ||
            'chase' => MovementDefinition(
              axis: 'compound',
              amplitude: min(0.1, 0.045 + difficulty * 0.04),
              periodSeconds: max(2.2, 3.8 - difficulty),
              phase: random.nextDouble(),
            ),
            _ => null,
          },
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
      if (difficulty > 0.5 && chunkIndex % 3 != 2 && random.nextBool()) {
        obstacles.add(
          ObstacleDefinition(
            id: 'chunk_${chunkIndex}_suction_1',
            type: 'suckingHole',
            x: safeX < 0.5 ? 0.18 : 0.82,
            y: 0.28,
            radius: 0.048,
            suctionRadius: min(0.24, 0.15 + difficulty * 0.07),
            strength: min(0.82, 0.48 + difficulty * 0.28),
            behavior: chunkIndex.isEven ? 'spiralSuction' : 'breathingVortex',
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

  String _patternFor(int chunkIndex) {
    final patterns = CampaignLevelGenerator.patternTemplateIds;
    final recent = <String>{};
    for (var offset = 1; offset <= 2; offset++) {
      if (chunkIndex - offset < 0) continue;
      final previousSeed = runSeed + (chunkIndex - offset) * 104729;
      recent.add(patterns[Random(previousSeed).nextInt(patterns.length)]);
    }
    final random = Random(runSeed + chunkIndex * 104729);
    for (var attempt = 0; attempt < patterns.length; attempt++) {
      final candidate = patterns[random.nextInt(patterns.length)];
      if (!recent.contains(candidate)) return candidate;
    }
    return patterns[chunkIndex % patterns.length];
  }
}
