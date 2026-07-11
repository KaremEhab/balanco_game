import 'dart:math';

import 'package:balanco_game/features/game/level_system/level_definition.dart';
import 'package:balanco_game/features/game/level_system/level_validator.dart';

class CampaignLevelGenerator {
  static const int firstGeneratedLevel = 16;
  static const int lastCampaignLevel = 500;
  static const int seedBase = 0xBA1A0000;
  static const int seedStride = 7919;

  final LevelValidator validator;

  CampaignLevelGenerator({LevelValidator? validator})
    : validator = validator ?? LevelValidator();

  static const List<ThemeDefinition> themes = [
    ThemeDefinition(
      id: 'beach',
      name: 'Tropical Beach',
      startLevel: 1,
      endLevel: 15,
    ),
    ThemeDefinition(
      id: 'egypt',
      name: 'Egyptian Pyramids',
      startLevel: 16,
      endLevel: 45,
    ),
    ThemeDefinition(
      id: 'jungle',
      name: 'Jungle Ruins',
      startLevel: 46,
      endLevel: 75,
    ),
    ThemeDefinition(
      id: 'ice',
      name: 'Frozen Kingdom',
      startLevel: 76,
      endLevel: 105,
    ),
    ThemeDefinition(
      id: 'volcano',
      name: 'Volcano',
      startLevel: 106,
      endLevel: 135,
    ),
    ThemeDefinition(
      id: 'neon_city',
      name: 'Neon City',
      startLevel: 136,
      endLevel: 165,
    ),
    ThemeDefinition(
      id: 'space',
      name: 'Outer Space',
      startLevel: 166,
      endLevel: 195,
    ),
    ThemeDefinition(
      id: 'underwater',
      name: 'Underwater',
      startLevel: 196,
      endLevel: 225,
    ),
    ThemeDefinition(
      id: 'candy',
      name: 'Candy World',
      startLevel: 226,
      endLevel: 255,
    ),
    ThemeDefinition(
      id: 'haunted',
      name: 'Haunted Mansion',
      startLevel: 256,
      endLevel: 285,
    ),
    ThemeDefinition(
      id: 'sky_temple',
      name: 'Sky Temple',
      startLevel: 286,
      endLevel: 315,
    ),
    ThemeDefinition(
      id: 'crystal_cavern',
      name: 'Crystal Cavern',
      startLevel: 316,
      endLevel: 345,
    ),
    ThemeDefinition(
      id: 'toy_factory',
      name: 'Toy Factory',
      startLevel: 346,
      endLevel: 375,
    ),
    ThemeDefinition(
      id: 'moon_base',
      name: 'Moon Base',
      startLevel: 376,
      endLevel: 405,
    ),
    ThemeDefinition(
      id: 'cyber_grid',
      name: 'Cyber Grid',
      startLevel: 406,
      endLevel: 435,
    ),
    ThemeDefinition(
      id: 'lost_city',
      name: 'Ancient Lost City',
      startLevel: 436,
      endLevel: 465,
    ),
    ThemeDefinition(
      id: 'eclipse',
      name: 'Eclipse Realm',
      startLevel: 466,
      endLevel: 495,
    ),
    ThemeDefinition(
      id: 'final_nightmare',
      name: 'Final Nightmare',
      startLevel: 496,
      endLevel: 500,
    ),
  ];

  static const List<String> patternTemplateIds = [
    'open_tutorial',
    'left_slalom',
    'right_slalom',
    'alternating_slalom',
    'double_hole_gate',
    'triple_gate',
    'moving_horizontal_sweep',
    'moving_vertical_timing',
    'suction_left',
    'suction_right',
    'double_suction_passage',
    'bumper_triangle',
    'bumper_pinball',
    'bomb_lane',
    'alternating_bomb_rhythm',
    'teleport_split',
    'teleport_recovery_lane',
    'dark_light_trail',
    'dark_hazard_gate',
    'star_risk_branch',
    'narrow_center_route',
    'wide_zigzag',
    'moving_static_combo',
    'suction_bumper_combo',
    'finale_portal_approach',
    'recovery_chunk',
    'offset_gate',
    'mirror_gate',
    'staggered_bumpers',
    'slow_sweep_pair',
    'fast_single_sweep',
    'side_pockets',
    'center_pressure',
    'late_star_branch',
    'early_helper_lane',
    'theme_finale_mix',
  ];

  List<LevelDefinition> generateCampaign() =>
      List.generate(lastCampaignLevel, (index) => generateLevel(index + 1));

  LevelDefinition generateLevel(int levelId) {
    if (levelId < 1 || levelId > lastCampaignLevel) {
      throw ArgumentError.value(levelId, 'levelId', 'Must be in 1..500');
    }

    final baseSeed = seedForLevel(levelId);
    for (var attempt = 1; attempt <= 24; attempt++) {
      final seed = baseSeed + attempt - 1;
      final random = Random(seed);
      final level = levelId <= 15
          ? _generateTutorialLevel(levelId, seed, random, attempt)
          : _generateProceduralLevel(levelId, seed, random, attempt);
      final result = validator.validate(level);
      if (result.isValid) return level;
    }

    final random = Random(baseSeed + 1000);
    return _generateRecoveryLevel(levelId, baseSeed + 1000, random, 25);
  }

  static int seedForLevel(int levelId) => seedBase + levelId * seedStride;

  static double campaignDifficulty(int level) {
    final progress = (level - 1) / 499.0;
    final trend = 0.04 + 0.88 * pow(progress, 1.20);
    final localStep = ((level - 1) % 5) / 4.0;
    final localWave = localStep * 0.045;
    final milestoneBonus = level % 30 == 0
        ? 0.07
        : level % 15 == 0
        ? 0.045
        : 0.0;
    final recovery = level > 15 && level % 5 == 1 ? -0.035 : 0.0;
    return (trend + localWave + milestoneBonus + recovery).clamp(0.0, 1.0);
  }

  static String themeIdForLevel(int level) => themes
      .firstWhere(
        (theme) => level >= theme.startLevel && level <= theme.endLevel,
      )
      .id;

  LevelDefinition _generateTutorialLevel(
    int levelId,
    int seed,
    Random random,
    int attempt,
  ) {
    final target = _tutorialTargets[levelId]!;
    return _buildLevel(
      levelId: levelId,
      seed: seed,
      random: random,
      attempt: attempt,
      worldHeight: target.worldHeight,
      regularHoles: target.regularHoles,
      movingHoles: target.movingHoles,
      suctionHoles: target.suctionHoles,
      bumpers: target.bumpers,
      bombWaves: target.bombWaves,
      teleportPairs: target.teleportPairs,
      magnets: target.magnets,
      extraBalls: target.extraBalls,
      hearts: target.hearts,
      shields: target.shields,
      lightPickups: target.lightPickups,
      dark: target.dark,
      patternIds: target.patternIds,
    );
  }

  LevelDefinition _generateProceduralLevel(
    int levelId,
    int seed,
    Random random,
    int attempt,
  ) {
    final difficulty = campaignDifficulty(levelId);
    final worldHeight = _worldHeightFor(levelId, difficulty);
    final budget = 3.0 + worldHeight * (2.0 + difficulty * 6.0);
    final isRecovery = levelId % 5 == 1;
    final isThemeFinale = levelId % 30 == 0 || levelId == 500;
    var remaining = budget;

    int take(double cost, double chance, int cap) {
      var count = 0;
      while (count < cap && remaining >= cost && random.nextDouble() < chance) {
        count++;
        remaining -= cost;
      }
      return count;
    }

    final suction = take(
      2.1,
      0.18 + difficulty * 0.52,
      1 + (difficulty * 4).floor(),
    );
    final moving = take(
      1.7,
      0.24 + difficulty * 0.58,
      1 + (difficulty * 5).floor(),
    );
    final bumpers = take(
      0.7,
      0.45 + difficulty * 0.35,
      2 + (difficulty * 7).floor(),
    );
    final bombs = take(2.2, 0.12 + difficulty * 0.42, isRecovery ? 1 : 4);
    final teleports =
        levelId >= 30 && random.nextDouble() < 0.12 + difficulty * 0.28
        ? (isThemeFinale ? 2 : 1)
        : 0;
    remaining -= teleports * 1.4;
    final regular = max(2, min(16, remaining.floor()));
    final dark =
        levelId >= 76 &&
        (levelId % 17 == 0 || isThemeFinale && difficulty > 0.35);
    final patternCount = max(2, min(6, worldHeight.ceil()));
    final patternIds = List.generate(patternCount, (_) {
      final offset = isRecovery
          ? 25
          : random.nextInt(patternTemplateIds.length);
      return patternTemplateIds[offset % patternTemplateIds.length];
    });

    return _buildLevel(
      levelId: levelId,
      seed: seed,
      random: random,
      attempt: attempt,
      worldHeight: worldHeight,
      regularHoles: regular,
      movingHoles: moving,
      suctionHoles: suction,
      bumpers: bumpers,
      bombWaves: bombs,
      teleportPairs: teleports,
      magnets: levelId >= 18 && random.nextDouble() < 0.18 ? 1 : 0,
      extraBalls: levelId >= 25 && random.nextDouble() < 0.12 ? 1 : 0,
      hearts: levelId >= 16 && (isRecovery || random.nextDouble() < 0.16)
          ? 1
          : 0,
      shields: levelId >= 40 && random.nextDouble() < 0.12 ? 1 : 0,
      lightPickups: dark ? (isThemeFinale ? 3 : 2) : 0,
      dark: dark,
      patternIds: patternIds,
    );
  }

  LevelDefinition _generateRecoveryLevel(
    int levelId,
    int seed,
    Random random,
    int attempt,
  ) {
    final difficulty = campaignDifficulty(levelId);
    return _buildLevel(
      levelId: levelId,
      seed: seed,
      random: random,
      attempt: attempt,
      worldHeight: _worldHeightFor(levelId, difficulty),
      regularHoles: 3 + (difficulty * 6).floor(),
      movingHoles: (difficulty * 2).floor(),
      suctionHoles: difficulty > 0.35 ? 1 : 0,
      bumpers: 2 + (difficulty * 3).floor(),
      bombWaves: difficulty > 0.65 ? 1 : 0,
      teleportPairs: 0,
      magnets: 0,
      extraBalls: 0,
      hearts: 1,
      shields: 0,
      lightPickups: 0,
      dark: false,
      patternIds: const ['recovery_chunk'],
    );
  }

  LevelDefinition _buildLevel({
    required int levelId,
    required int seed,
    required Random random,
    required int attempt,
    required double worldHeight,
    required int regularHoles,
    required int movingHoles,
    required int suctionHoles,
    required int bumpers,
    required int bombWaves,
    required int teleportPairs,
    required int magnets,
    required int extraBalls,
    required int hearts,
    required int shields,
    required int lightPickups,
    required bool dark,
    required List<String> patternIds,
  }) {
    final difficulty = campaignDifficulty(levelId);
    final safePath = _makeSafePath(worldHeight, random, levelId);
    final corridor = _corridorWidth(levelId, difficulty);
    final obstacles = <ObstacleDefinition>[];
    final pickups = <PickupDefinition>[];
    final bombs = <BombWaveDefinition>[];
    final teleports = <TeleportPairDefinition>[];
    var obstacleIndex = 0;

    void addHazard(String type, {MovementDefinition? movement}) {
      final position = _findHazardPosition(
        random: random,
        worldHeight: worldHeight,
        safePath: safePath,
        corridor: corridor,
        existing: obstacles,
      );
      final radius = switch (type) {
        'bumper' => 0.034 + difficulty * 0.006,
        'suckingHole' => 0.044 + difficulty * 0.011,
        'movingHole' => 0.043 + difficulty * 0.009,
        _ => 0.047 + difficulty * 0.011,
      };
      obstacleIndex++;
      obstacles.add(
        ObstacleDefinition(
          id: '${type}_$obstacleIndex',
          type: type,
          x: position.x,
          y: position.y,
          radius: radius,
          movement: movement,
          suctionRadius: type == 'suckingHole'
              ? 0.14 + difficulty * 0.08
              : null,
          strength: type == 'suckingHole' ? 0.45 + difficulty * 0.32 : null,
          bumperForce: type == 'bumper' ? 320.0 + difficulty * 120.0 : null,
        ),
      );
    }

    for (var i = 0; i < regularHoles; i++) {
      addHazard('regularHole');
    }
    for (var i = 0; i < movingHoles; i++) {
      addHazard(
        'movingHole',
        movement: MovementDefinition(
          axis: i.isEven ? 'horizontal' : 'vertical',
          amplitude: 0.08 + random.nextDouble() * (0.13 + difficulty * 0.08),
          periodSeconds: 2.4 + random.nextDouble() * 1.8,
          phase: random.nextDouble(),
        ),
      );
    }
    for (var i = 0; i < suctionHoles; i++) {
      addHazard('suckingHole');
    }
    for (var i = 0; i < bumpers; i++) {
      addHazard('bumper');
    }

    for (var i = 0; i < 3; i++) {
      final y = worldHeight * (0.22 + i * 0.27);
      final pathX = _safeXAt(safePath, y);
      final branch = (i == 0
          ? 0.0
          : (random.nextBool() ? 1 : -1) * corridor * 0.22);
      pickups.add(
        PickupDefinition(
          id: 'star_${i + 1}',
          type: 'star',
          x: (pathX + branch).clamp(0.08, 0.92),
          y: y.clamp(0.16, worldHeight - 0.18),
        ),
      );
    }

    void addPickup(String type, int count) {
      for (var i = 0; i < count; i++) {
        final y = worldHeight * (0.25 + (i + 1) / (count + 2) * 0.55);
        pickups.add(
          PickupDefinition(
            id: '${type}_${i + 1}',
            type: type,
            x: _safeXAt(safePath, y).clamp(0.1, 0.9),
            y: y,
          ),
        );
      }
    }

    addPickup('magnet', magnets);
    addPickup('extraBall', extraBalls);
    addPickup('heart', hearts);
    addPickup('shield', shields);

    for (var i = 0; i < bombWaves; i++) {
      final y = worldHeight * (0.24 + (i + 1) / (bombWaves + 2) * 0.56);
      bombs.add(
        BombWaveDefinition(
          id: 'bomb_${i + 1}',
          x: _safeXAt(safePath, y),
          y: y,
          dropTimeSeconds: 8.0 + i * 6.0,
          warningDuration: max(2.4, 4.2 - difficulty * 0.9),
          impactRadius: 0.08,
        ),
      );
    }

    for (var i = 0; i < teleportPairs; i++) {
      final entryY = worldHeight * (0.28 + i * 0.18);
      final exitY = min(worldHeight - 0.24, entryY + worldHeight * 0.22);
      teleports.add(
        TeleportPairDefinition(
          id: 'teleport_${i + 1}',
          pairId: i,
          entry: LevelPoint(x: _safeXAt(safePath, entryY), y: entryY),
          exit: LevelPoint(x: _safeXAt(safePath, exitY), y: exitY),
          radius: 0.05,
        ),
      );
    }

    NightModeDefinition? nightMode;
    if (dark) {
      final lights = List.generate(lightPickups, (i) {
        final y = worldHeight * (0.12 + i / max(1, lightPickups) * 0.66);
        return LevelPoint(x: _safeXAt(safePath, y), y: y);
      });
      nightMode = NightModeDefinition(
        enabled: true,
        opacity: 0.68 + difficulty * 0.12,
        lightRadius: 0.23,
        lightPickups: lights,
      );
    }

    return LevelDefinition(
      id: levelId,
      seed: seed,
      themeId: themeIdForLevel(levelId),
      difficulty: difficulty,
      worldHeight: worldHeight,
      timeLimitSeconds: (42 + worldHeight * 17 + difficulty * 18).round(),
      scrollSpeedMultiplier: 1.0 + difficulty * 0.32,
      safeCorridorWidth: corridor,
      safePath: safePath,
      obstacles: obstacles,
      pickups: pickups,
      bombWaves: bombs,
      teleportPairs: teleports,
      nightMode: nightMode,
      validationAttempts: attempt,
      patternIds: patternIds,
    );
  }

  List<LevelPoint> _makeSafePath(
    double worldHeight,
    Random random,
    int levelId,
  ) {
    final count = max(4, worldHeight.ceil() + 2);
    final points = <LevelPoint>[];
    for (var i = 0; i < count; i++) {
      final t = i / (count - 1);
      final wave = sin(t * pi * (levelId.isEven ? 1.6 : 2.1));
      final drift = (random.nextDouble() - 0.5) * 0.22;
      points.add(
        LevelPoint(
          x: (0.5 + wave * 0.18 + drift).clamp(0.25, 0.75),
          y: (worldHeight * t).clamp(0.08, worldHeight - 0.08),
        ),
      );
    }
    return points;
  }

  LevelPoint _findHazardPosition({
    required Random random,
    required double worldHeight,
    required List<LevelPoint> safePath,
    required double corridor,
    required List<ObstacleDefinition> existing,
  }) {
    for (var attempt = 0; attempt < 120; attempt++) {
      final y = 0.22 + random.nextDouble() * (worldHeight - 0.44);
      final safeX = _safeXAt(safePath, y);
      final side = random.nextBool() ? 1.0 : -1.0;
      final minOffset = corridor * 0.78 + 0.08;
      var x = (safeX + side * (minOffset + random.nextDouble() * 0.22)).clamp(
        0.08,
        0.92,
      );
      if ((x - safeX).abs() < minOffset) {
        x = safeX < 0.5 ? 0.92 : 0.08;
      }
      var clear = true;
      for (final obstacle in existing) {
        final dy = (obstacle.y - y) * 0.5;
        final dx = obstacle.x - x;
        if (sqrt(dx * dx + dy * dy) < obstacle.radius + 0.075) {
          clear = false;
          break;
        }
      }
      if (clear) return LevelPoint(x: x, y: y);
    }

    for (var attempt = 0; attempt < 160; attempt++) {
      final slot = existing.length + attempt;
      final y = 0.24 + ((slot * 0.173) % (worldHeight - 0.48));
      final x = slot.isEven ? 0.08 : 0.92;
      var clear = true;
      for (final obstacle in existing) {
        final dy = (obstacle.y - y) * 0.5;
        final dx = obstacle.x - x;
        if (sqrt(dx * dx + dy * dy) < obstacle.radius + 0.075) {
          clear = false;
          break;
        }
      }
      if (clear) return LevelPoint(x: x, y: y);
    }

    final y = 0.24 + ((existing.length * 0.211) % (worldHeight - 0.48));
    return LevelPoint(x: existing.length.isEven ? 0.08 : 0.92, y: y);
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

  double _worldHeightFor(int levelId, double difficulty) {
    if (levelId <= 15) return _tutorialTargets[levelId]!.worldHeight;
    final base = 2.6 + difficulty * 2.7;
    final themeFinale = levelId % 30 == 0 || levelId == 500 ? 0.45 : 0.0;
    return (base + themeFinale).clamp(2.2, 5.8);
  }

  double _corridorWidth(int levelId, double difficulty) {
    if (levelId <= 15) return 0.38 - difficulty * 0.04;
    if (levelId <= 75) return 0.34 - difficulty * 0.05;
    if (levelId <= 195) return 0.30 - difficulty * 0.06;
    if (levelId <= 345) return 0.26 - difficulty * 0.05;
    return 0.23 - difficulty * 0.045;
  }
}

class _TutorialTarget {
  final double worldHeight;
  final int regularHoles;
  final int movingHoles;
  final int suctionHoles;
  final int bumpers;
  final int bombWaves;
  final int teleportPairs;
  final int magnets;
  final int extraBalls;
  final int hearts;
  final int shields;
  final int lightPickups;
  final bool dark;
  final List<String> patternIds;

  const _TutorialTarget({
    required this.worldHeight,
    required this.regularHoles,
    this.movingHoles = 0,
    this.suctionHoles = 0,
    this.bumpers = 0,
    this.bombWaves = 0,
    this.teleportPairs = 0,
    this.magnets = 0,
    this.extraBalls = 0,
    this.hearts = 0,
    this.shields = 0,
    this.lightPickups = 0,
    this.dark = false,
    this.patternIds = const ['open_tutorial'],
  });
}

const Map<int, _TutorialTarget> _tutorialTargets = {
  1: _TutorialTarget(worldHeight: 1.2, regularHoles: 1),
  2: _TutorialTarget(
    worldHeight: 1.4,
    regularHoles: 3,
    patternIds: ['left_slalom'],
  ),
  3: _TutorialTarget(
    worldHeight: 1.6,
    regularHoles: 4,
    bumpers: 1,
    patternIds: ['bumper_triangle'],
  ),
  4: _TutorialTarget(
    worldHeight: 1.8,
    regularHoles: 4,
    movingHoles: 1,
    bumpers: 1,
    patternIds: ['moving_horizontal_sweep'],
  ),
  5: _TutorialTarget(
    worldHeight: 2.0,
    regularHoles: 5,
    movingHoles: 1,
    bumpers: 2,
    patternIds: ['alternating_slalom'],
  ),
  6: _TutorialTarget(
    worldHeight: 2.0,
    regularHoles: 4,
    suctionHoles: 1,
    bumpers: 2,
    patternIds: ['suction_left'],
  ),
  7: _TutorialTarget(
    worldHeight: 2.2,
    regularHoles: 5,
    movingHoles: 1,
    suctionHoles: 1,
    bumpers: 2,
    bombWaves: 2,
    hearts: 1,
    patternIds: ['bomb_lane'],
  ),
  8: _TutorialTarget(
    worldHeight: 2.5,
    regularHoles: 6,
    movingHoles: 1,
    suctionHoles: 2,
    bumpers: 4,
    magnets: 1,
    patternIds: ['suction_bumper_combo'],
  ),
  9: _TutorialTarget(
    worldHeight: 2.7,
    regularHoles: 7,
    movingHoles: 2,
    suctionHoles: 1,
    bumpers: 4,
    bombWaves: 2,
    extraBalls: 1,
    hearts: 1,
    patternIds: ['bumper_pinball'],
  ),
  10: _TutorialTarget(
    worldHeight: 3.2,
    regularHoles: 6,
    movingHoles: 1,
    suctionHoles: 2,
    bumpers: 3,
    bombWaves: 2,
    teleportPairs: 1,
    patternIds: ['teleport_split'],
  ),
  11: _TutorialTarget(
    worldHeight: 2.8,
    regularHoles: 5,
    movingHoles: 1,
    suctionHoles: 2,
    bumpers: 2,
    lightPickups: 2,
    dark: true,
    patternIds: ['dark_light_trail'],
  ),
  12: _TutorialTarget(
    worldHeight: 3.2,
    regularHoles: 6,
    movingHoles: 2,
    suctionHoles: 2,
    bumpers: 3,
    bombWaves: 3,
    shields: 1,
    patternIds: ['moving_static_combo'],
  ),
  13: _TutorialTarget(
    worldHeight: 3.5,
    regularHoles: 7,
    movingHoles: 2,
    suctionHoles: 2,
    bumpers: 4,
    bombWaves: 3,
    teleportPairs: 2,
    magnets: 1,
    patternIds: ['teleport_recovery_lane'],
  ),
  14: _TutorialTarget(
    worldHeight: 3.8,
    regularHoles: 8,
    movingHoles: 3,
    suctionHoles: 3,
    bumpers: 4,
    bombWaves: 4,
    lightPickups: 3,
    shields: 1,
    dark: true,
    patternIds: ['dark_hazard_gate'],
  ),
  15: _TutorialTarget(
    worldHeight: 4.2,
    regularHoles: 10,
    movingHoles: 3,
    suctionHoles: 3,
    bumpers: 5,
    bombWaves: 5,
    teleportPairs: 2,
    shields: 1,
    extraBalls: 1,
    patternIds: ['theme_finale_mix'],
  ),
};
