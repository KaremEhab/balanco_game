import 'dart:convert';

class LevelPoint {
  final double x;
  final double y;

  const LevelPoint({required this.x, required this.y});

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory LevelPoint.fromJson(Map<String, dynamic> json) => LevelPoint(
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
  );
}

class MovementDefinition {
  final String axis;
  final double amplitude;
  final double periodSeconds;
  final double phase;

  const MovementDefinition({
    required this.axis,
    required this.amplitude,
    required this.periodSeconds,
    required this.phase,
  });

  Map<String, dynamic> toJson() => {
    'axis': axis,
    'amplitude': amplitude,
    'periodSeconds': periodSeconds,
    'phase': phase,
  };

  factory MovementDefinition.fromJson(Map<String, dynamic> json) =>
      MovementDefinition(
        axis: json['axis'] as String? ?? 'horizontal',
        amplitude: (json['amplitude'] as num? ?? 0.0).toDouble(),
        periodSeconds: (json['periodSeconds'] as num? ?? 3.0).toDouble(),
        phase: (json['phase'] as num? ?? 0.0).toDouble(),
      );
}

class ObstacleDefinition {
  final String id;
  final String type;
  final double x;
  final double y;
  final double radius;
  final MovementDefinition? movement;
  final double? suctionRadius;
  final double? strength;
  final double? bumperForce;

  const ObstacleDefinition({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.radius,
    this.movement,
    this.suctionRadius,
    this.strength,
    this.bumperForce,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'x': x,
    'y': y,
    'radius': radius,
    if (movement != null) 'movement': movement!.toJson(),
    if (suctionRadius != null) 'suctionRadius': suctionRadius,
    if (strength != null) 'strength': strength,
    if (bumperForce != null) 'bumperForce': bumperForce,
  };

  factory ObstacleDefinition.fromJson(Map<String, dynamic> json) =>
      ObstacleDefinition(
        id: json['id'] as String,
        type: json['type'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        radius: (json['radius'] as num).toDouble(),
        movement: json['movement'] == null
            ? null
            : MovementDefinition.fromJson(
                (json['movement'] as Map).cast<String, dynamic>(),
              ),
        suctionRadius: (json['suctionRadius'] as num?)?.toDouble(),
        strength: (json['strength'] as num?)?.toDouble(),
        bumperForce: (json['bumperForce'] as num?)?.toDouble(),
      );
}

class PickupDefinition {
  final String id;
  final String type;
  final double x;
  final double y;
  final double? radius;

  const PickupDefinition({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.radius,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'x': x,
    'y': y,
    if (radius != null) 'radius': radius,
  };

  factory PickupDefinition.fromJson(
    Map<String, dynamic> json,
  ) => PickupDefinition(
    id: json['id'] as String? ?? '${json['type']}_${json['x']}_${json['y']}',
    type: json['type'] as String,
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
    radius: (json['radius'] as num?)?.toDouble(),
  );
}

class BombWaveDefinition {
  final String id;
  final double x;
  final double y;
  final double dropTimeSeconds;
  final double warningDuration;
  final double impactRadius;

  const BombWaveDefinition({
    required this.id,
    required this.x,
    required this.y,
    required this.dropTimeSeconds,
    required this.warningDuration,
    required this.impactRadius,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'dropTimeSeconds': dropTimeSeconds,
    'warningDuration': warningDuration,
    'impactRadius': impactRadius,
  };

  factory BombWaveDefinition.fromJson(Map<String, dynamic> json) =>
      BombWaveDefinition(
        id: json['id'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        dropTimeSeconds: (json['dropTimeSeconds'] as num).toDouble(),
        warningDuration: (json['warningDuration'] as num).toDouble(),
        impactRadius: (json['impactRadius'] as num).toDouble(),
      );
}

class TeleportPairDefinition {
  final String id;
  final int pairId;
  final LevelPoint entry;
  final LevelPoint exit;
  final double radius;

  const TeleportPairDefinition({
    required this.id,
    required this.pairId,
    required this.entry,
    required this.exit,
    required this.radius,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'pairId': pairId,
    'entry': entry.toJson(),
    'exit': exit.toJson(),
    'radius': radius,
  };

  factory TeleportPairDefinition.fromJson(
    Map<String, dynamic> json,
  ) => TeleportPairDefinition(
    id: json['id'] as String,
    pairId: json['pairId'] as int,
    entry: LevelPoint.fromJson((json['entry'] as Map).cast<String, dynamic>()),
    exit: LevelPoint.fromJson((json['exit'] as Map).cast<String, dynamic>()),
    radius: (json['radius'] as num).toDouble(),
  );
}

class NightModeDefinition {
  final bool enabled;
  final double opacity;
  final double lightRadius;
  final double startLitSeconds;
  final List<LevelPoint> lightPickups;

  const NightModeDefinition({
    required this.enabled,
    this.opacity = 0.72,
    this.lightRadius = 0.22,
    this.startLitSeconds = 0.0,
    this.lightPickups = const [],
  });

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'opacity': opacity,
    'lightRadius': lightRadius,
    'startLitSeconds': startLitSeconds,
    'lightPickups': lightPickups.map((e) => e.toJson()).toList(),
  };

  factory NightModeDefinition.fromJson(Map<String, dynamic> json) =>
      NightModeDefinition(
        enabled: json['enabled'] as bool? ?? false,
        opacity: (json['opacity'] as num? ?? 0.72).toDouble(),
        lightRadius: (json['lightRadius'] as num? ?? 0.22).toDouble(),
        startLitSeconds: (json['startLitSeconds'] as num? ?? 0.0).toDouble(),
        lightPickups:
            (json['lightPickups'] as List?)
                ?.map(
                  (e) =>
                      LevelPoint.fromJson((e as Map).cast<String, dynamic>()),
                )
                .toList() ??
            const [],
      );
}

class ThemeDefinition {
  final String id;
  final String name;
  final int startLevel;
  final int endLevel;

  const ThemeDefinition({
    required this.id,
    required this.name,
    required this.startLevel,
    required this.endLevel,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startLevel': startLevel,
    'endLevel': endLevel,
  };
}

class LevelDefinition {
  final int id;
  final int seed;
  final String themeId;
  final double difficulty;
  final double worldHeight;
  final int timeLimitSeconds;
  final double scrollSpeedMultiplier;
  final double safeCorridorWidth;
  final List<LevelPoint> safePath;
  final List<ObstacleDefinition> obstacles;
  final List<PickupDefinition> pickups;
  final List<BombWaveDefinition> bombWaves;
  final List<TeleportPairDefinition> teleportPairs;
  final NightModeDefinition? nightMode;
  final bool isNightmare;
  final int validationAttempts;
  final List<String> patternIds;

  const LevelDefinition({
    required this.id,
    required this.seed,
    required this.themeId,
    required this.difficulty,
    required this.worldHeight,
    required this.timeLimitSeconds,
    required this.scrollSpeedMultiplier,
    required this.safeCorridorWidth,
    required this.safePath,
    required this.obstacles,
    required this.pickups,
    this.bombWaves = const [],
    this.teleportPairs = const [],
    this.nightMode,
    this.isNightmare = false,
    this.validationAttempts = 1,
    this.patternIds = const [],
  });

  bool get isDark => nightMode?.enabled ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'seed': seed,
    'themeId': themeId,
    'difficulty': difficulty,
    'worldHeight': worldHeight,
    'timeLimitSeconds': timeLimitSeconds,
    'scrollSpeedMultiplier': scrollSpeedMultiplier,
    'safeCorridorWidth': safeCorridorWidth,
    'safePath': safePath.map((e) => e.toJson()).toList(),
    'obstacles': obstacles.map((e) => e.toJson()).toList(),
    'pickups': pickups.map((e) => e.toJson()).toList(),
    'bombWaves': bombWaves.map((e) => e.toJson()).toList(),
    'teleportPairs': teleportPairs.map((e) => e.toJson()).toList(),
    if (nightMode != null) 'nightMode': nightMode!.toJson(),
    'isNightmare': isNightmare,
    'validationAttempts': validationAttempts,
    'patternIds': patternIds,
  };

  String toJsonString() => jsonEncode(toJson());

  factory LevelDefinition.fromJson(
    Map<String, dynamic> json,
  ) => LevelDefinition(
    id: json['id'] as int,
    seed: json['seed'] as int,
    themeId: json['themeId'] as String,
    difficulty: (json['difficulty'] as num).toDouble(),
    worldHeight: (json['worldHeight'] as num).toDouble(),
    timeLimitSeconds: json['timeLimitSeconds'] as int,
    scrollSpeedMultiplier: (json['scrollSpeedMultiplier'] as num? ?? 1.0)
        .toDouble(),
    safeCorridorWidth: (json['safeCorridorWidth'] as num? ?? 0.3).toDouble(),
    safePath: (json['safePath'] as List)
        .map((e) => LevelPoint.fromJson((e as Map).cast<String, dynamic>()))
        .toList(),
    obstacles: (json['obstacles'] as List)
        .map(
          (e) =>
              ObstacleDefinition.fromJson((e as Map).cast<String, dynamic>()),
        )
        .toList(),
    pickups: (json['pickups'] as List)
        .map(
          (e) => PickupDefinition.fromJson((e as Map).cast<String, dynamic>()),
        )
        .toList(),
    bombWaves:
        (json['bombWaves'] as List?)
            ?.map(
              (e) => BombWaveDefinition.fromJson(
                (e as Map).cast<String, dynamic>(),
              ),
            )
            .toList() ??
        const [],
    teleportPairs:
        (json['teleportPairs'] as List?)
            ?.map(
              (e) => TeleportPairDefinition.fromJson(
                (e as Map).cast<String, dynamic>(),
              ),
            )
            .toList() ??
        const [],
    nightMode: json['nightMode'] == null
        ? null
        : NightModeDefinition.fromJson(
            (json['nightMode'] as Map).cast<String, dynamic>(),
          ),
    isNightmare: json['isNightmare'] as bool? ?? false,
    validationAttempts: json['validationAttempts'] as int? ?? 1,
    patternIds:
        (json['patternIds'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
  );
}
