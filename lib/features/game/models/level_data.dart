import 'package:flame/components.dart';

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
  });

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

class LevelData {
  final List<HoleData> holes;
  final List<Vector2> stars;
  final List<Vector2> hearts;
  final int timeLimitSeconds; // Added time limit
  final List<BumperData> bumpers;
  final List<TeleporterData> teleporters;
  final List<Vector2> multiBalls;
  final List<Vector2> magnets;
  final double heightMultiplier;
  final double timerSeconds;
  final bool hasBomb;

  LevelData({
    required this.holes,
    required this.stars,
    required this.hearts,
    this.timeLimitSeconds = 60, // Default to 60 seconds
    this.bumpers = const [],
    this.teleporters = const [],
    this.multiBalls = const [],
    this.magnets = const [],
    this.heightMultiplier = 1.0,
    this.timerSeconds = 120.0,
    this.hasBomb = false,
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
    'heightMultiplier': heightMultiplier,
    'timerSeconds': timerSeconds,
    'hasBomb': hasBomb,
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
    heightMultiplier: (json['heightMultiplier'] ?? 1.0).toDouble(),
    timerSeconds: (json['timerSeconds'] ?? 120.0).toDouble(),
    hasBomb: json['hasBomb'] ?? false,
  );
}
