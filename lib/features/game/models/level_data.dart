import 'package:flame/components.dart';

enum HoleBehavior {
  staticHole,
  pingPong,
  pulse,
  orbit,
  chase,
  split,
  teleport,
  wave,
  fake,
  spiralSuction,
  breathingVortex,
  nailLauncher;

  static HoleBehavior fromName(String? value) => values.firstWhere(
    (behavior) => behavior.name == value,
    orElse: () => HoleBehavior.staticHole,
  );
}

class HoleData {
  final Vector2 position;
  final double size;
  final double rotation;
  final bool isSuckingHole;
  final double suckRadius;
  final bool isMovingHole;
  final double moveRange;
  final double moveSpeed;
  final String moveAxis;
  final HoleBehavior behavior;
  final double warningDuration;
  final double activeDuration;
  final double recoveryDuration;
  final double forceStrength;

  HoleData(
    this.position,
    this.size,
    this.rotation,
    this.isSuckingHole,
    this.suckRadius, {
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
               : HoleBehavior.staticHole);

  Map<String, dynamic> toJson() => {
    'x': position.x,
    'y': position.y,
    'size': size,
    'rotation': rotation,
    'isSuckingHole': isSuckingHole,
    'suckRadius': suckRadius,
    'isMovingHole': isMovingHole,
    'moveRange': moveRange,
    'moveSpeed': moveSpeed,
    'moveAxis': moveAxis,
    'behavior': behavior.name,
    'warningDuration': warningDuration,
    'activeDuration': activeDuration,
    'recoveryDuration': recoveryDuration,
    'forceStrength': forceStrength,
  };

  factory HoleData.fromJson(Map<String, dynamic> json) => HoleData(
    Vector2(json['x'].toDouble(), json['y'].toDouble()),
    json['size'].toDouble(),
    json['rotation'].toDouble(),
    json['isSuckingHole'] ?? false,
    (json['suckRadius'] ?? 0.0).toDouble(),
    isMovingHole: json['isMovingHole'] ?? false,
    moveRange: (json['moveRange'] ?? 0.0).toDouble(),
    moveSpeed: (json['moveSpeed'] ?? 0.0).toDouble(),
    moveAxis: json['moveAxis'] ?? 'horizontal',
    behavior: HoleBehavior.fromName(json['behavior'] as String?),
    warningDuration: (json['warningDuration'] ?? 0.9).toDouble(),
    activeDuration: (json['activeDuration'] ?? 1.8).toDouble(),
    recoveryDuration: (json['recoveryDuration'] ?? 0.8).toDouble(),
    forceStrength: (json['forceStrength'] ?? 240.0).toDouble(),
  );
}

class TeleporterData {
  final Vector2 position;
  final double size;
  final int pairId;

  TeleporterData(this.position, this.size, this.pairId);

  Map<String, dynamic> toJson() => {
    'x': position.x,
    'y': position.y,
    'size': size,
    'pairId': pairId,
  };

  factory TeleporterData.fromJson(Map<String, dynamic> json) => TeleporterData(
    Vector2(json['x'].toDouble(), json['y'].toDouble()),
    json['size'].toDouble(),
    json['pairId'],
  );
}

class BumperData {
  final Vector2 position;
  final double size;

  BumperData(this.position, this.size);

  Map<String, dynamic> toJson() => {
    'x': position.x,
    'y': position.y,
    'size': size,
  };

  factory BumperData.fromJson(Map<String, dynamic> json) => BumperData(
    Vector2(json['x'].toDouble(), json['y'].toDouble()),
    json['size'].toDouble(),
  );
}

class VillainData {
  final Vector2 position;
  final double size;
  final int variant;
  final int health;

  const VillainData({
    required this.position,
    this.size = 88,
    this.variant = 0,
    this.health = 8,
  });

  Map<String, dynamic> toJson() => {
    'x': position.x,
    'y': position.y,
    'size': size,
    'variant': variant,
    'health': health,
  };

  factory VillainData.fromJson(Map<String, dynamic> json) => VillainData(
    position: Vector2(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    ),
    size: (json['size'] as num? ?? 88).toDouble(),
    variant: json['variant'] as int? ?? 0,
    health: json['health'] as int? ?? 8,
  );
}

class LevelData {
  final List<HoleData> holes;
  final List<Vector2> stars;
  final List<Vector2> hearts;
  final int timeLimitSeconds; // Added time limit
  final List<BumperData> bumpers;
  final List<TeleporterData> teleporters;
  final List<Vector2> multiBalls;
  final List<Vector2> magnets;
  final List<Vector2> shooterHelpers;
  final List<VillainData> villains;
  final double heightMultiplier;
  final double timerSeconds;
  final bool hasBomb;
  final int bombCount;
  final bool isDarkLevel;
  final String? themeId;
  final int? generationSeed;
  final double? difficulty;
  final List<Vector2> safePath;
  final double safeCorridorWidth;
  final double darknessLightRadius;
  final double darknessStartLitSeconds;
  final bool isNightmare;

  LevelData({
    required this.holes,
    required this.stars,
    required this.hearts,
    this.timeLimitSeconds = 60, // Default to 60 seconds
    this.bumpers = const [],
    this.teleporters = const [],
    this.multiBalls = const [],
    this.magnets = const [],
    this.shooterHelpers = const [],
    this.villains = const [],
    this.heightMultiplier = 1.0,
    this.timerSeconds = 120.0,
    this.hasBomb = false,
    this.bombCount = 0,
    this.isDarkLevel = false,
    this.themeId,
    this.generationSeed,
    this.difficulty,
    this.safePath = const [],
    this.safeCorridorWidth = 0.3,
    this.darknessLightRadius = 65.0,
    this.darknessStartLitSeconds = 0.0,
    this.isNightmare = false,
  });

  Map<String, dynamic> toJson() => {
    'holes': holes.map((e) => e.toJson()).toList(),
    'stars': stars.map((e) => {'x': e.x, 'y': e.y}).toList(),
    'hearts': hearts.map((e) => {'x': e.x, 'y': e.y}).toList(),
    'timeLimitSeconds': timeLimitSeconds,

    'bumpers': bumpers.map((e) => e.toJson()).toList(),
    'teleporters': teleporters.map((e) => e.toJson()).toList(),
    'multiBalls': multiBalls.map((e) => {'x': e.x, 'y': e.y}).toList(),
    'magnets': magnets.map((e) => {'x': e.x, 'y': e.y}).toList(),
    'shooterHelpers': shooterHelpers.map((e) => {'x': e.x, 'y': e.y}).toList(),
    'villains': villains.map((e) => e.toJson()).toList(),
    'heightMultiplier': heightMultiplier,
    'timerSeconds': timerSeconds,
    'hasBomb': hasBomb,
    'bombCount': bombCount,
    'isDarkLevel': isDarkLevel,
    if (themeId != null) 'themeId': themeId,
    if (generationSeed != null) 'generationSeed': generationSeed,
    if (difficulty != null) 'difficulty': difficulty,
    'safePath': safePath.map((e) => {'x': e.x, 'y': e.y}).toList(),
    'safeCorridorWidth': safeCorridorWidth,
    'darknessLightRadius': darknessLightRadius,
    'darknessStartLitSeconds': darknessStartLitSeconds,
    'isNightmare': isNightmare,
  };

  factory LevelData.fromJson(Map<String, dynamic> json) => LevelData(
    holes:
        (json['holes'] as List?)?.map((e) => HoleData.fromJson(e)).toList() ??
        [],
    stars:
        (json['stars'] as List?)
            ?.map((e) => Vector2(e['x'].toDouble(), e['y'].toDouble()))
            .toList() ??
        [],
    hearts:
        (json['hearts'] as List?)
            ?.map((e) => Vector2(e['x'].toDouble(), e['y'].toDouble()))
            .toList() ??
        [],
    timeLimitSeconds: json['timeLimitSeconds'] as int? ?? 60,
    bumpers:
        (json['bumpers'] as List?)
            ?.map((e) => BumperData.fromJson(e))
            .toList() ??
        [],
    teleporters:
        (json['teleporters'] as List?)
            ?.map((e) => TeleporterData.fromJson(e))
            .toList() ??
        [],
    multiBalls:
        (json['multiBalls'] as List?)
            ?.map((e) => Vector2(e['x'].toDouble(), e['y'].toDouble()))
            .toList() ??
        [],
    magnets:
        (json['magnets'] as List?)
            ?.map((e) => Vector2(e['x'].toDouble(), e['y'].toDouble()))
            .toList() ??
        [],
    shooterHelpers:
        (json['shooterHelpers'] as List?)
            ?.map((e) => Vector2(e['x'].toDouble(), e['y'].toDouble()))
            .toList() ??
        [],
    villains:
        (json['villains'] as List?)
            ?.map((e) => VillainData.fromJson(e))
            .toList() ??
        [],
    heightMultiplier: (json['heightMultiplier'] ?? 1.0).toDouble(),
    timerSeconds: (json['timerSeconds'] ?? 120.0).toDouble(),
    hasBomb: json['hasBomb'] ?? false,
    bombCount: json['bombCount'] as int? ?? (json['hasBomb'] == true ? 1 : 0),
    isDarkLevel: json['isDarkLevel'] ?? false,
    themeId: json['themeId'] as String?,
    generationSeed: json['generationSeed'] as int?,
    difficulty: (json['difficulty'] as num?)?.toDouble(),
    safePath:
        (json['safePath'] as List?)
            ?.map((e) => Vector2(e['x'].toDouble(), e['y'].toDouble()))
            .toList() ??
        [],
    safeCorridorWidth: (json['safeCorridorWidth'] ?? 0.3).toDouble(),
    darknessLightRadius: (json['darknessLightRadius'] ?? 65.0).toDouble(),
    darknessStartLitSeconds: (json['darknessStartLitSeconds'] ?? 0.0)
        .toDouble(),
    isNightmare: json['isNightmare'] ?? false,
  );
}
