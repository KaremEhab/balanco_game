import 'package:flame/components.dart';

class HoleData {
  final Vector2 position;
  final double size;
  final double rotation;
  final bool isSuckingHole;
  final double suckRadius;

  HoleData(this.position, this.size, this.rotation, this.isSuckingHole, this.suckRadius);
}

class TeleporterData {
  final Vector2 position;
  final double size;
  final int pairId;

  TeleporterData(this.position, this.size, this.pairId);
}

class BumperData {
  final Vector2 position;
  final double size;

  BumperData(this.position, this.size);
}

class LevelData {
  final List<HoleData> holes;
  final List<Vector2> stars;
  final List<Vector2> hearts;
  final List<Vector2> coins;
  final List<BumperData> bumpers;
  final List<TeleporterData> teleporters;

  LevelData({
    required this.holes,
    required this.stars,
    required this.hearts,
    this.coins = const [],
    this.bumpers = const [],
    this.teleporters = const [],
  });
}
