import 'package:flame/components.dart';
import 'package:balanco_game/features/game/components/hole_component.dart';
import 'package:balanco_game/features/game/components/teleporter_component.dart';

class BallData {
  Vector2 pos2D = Vector2.zero();
  double scale = 1.0;
  double p = 0.0;
  double velocity = 0.0;
  Vector2 freeFallVelocity = Vector2.zero();

  bool isFalling = false;
  bool isFallingInHole = false;
  bool isFreeFalling = false;

  HoleComponent? activeHole;
  TeleporterComponent? activeExitTeleporter;

  bool isRespawningFromEdge = false;
  bool isRespawningFromHole = false;
  double respawnTimer = 0.0;
  double spawnTimer = 0.0;

  double squashX = 1.0;
  double squashY = 1.0;
  double bounceTimer = 0.0;
  double fallRotation = 0.0;
  Vector2 fallTarget = Vector2.zero();

  bool isSuckingToGate = false;
  bool isDead = false;
}
