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

class MultiBallData {
  final Vector2 position;
  final int count;

  MultiBallData(this.position, this.count);
}

class LevelData {
  final List<HoleData> holes;
  final List<Vector2> stars;
  final List<Vector2> hearts;
  final List<BumperData> bumpers;
  final List<TeleporterData> teleporters;
  final List<MultiBallData> multiBalls;

  LevelData({
    required this.holes,
    required this.stars,
    required this.hearts,
    this.bumpers = const [],
    this.teleporters = const [],
    this.multiBalls = const [],
  });
}
