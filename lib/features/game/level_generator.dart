import 'dart:math';
import 'package:flame/components.dart';
import 'package:balanco_game/features/game/models/level_data.dart';

class _OccupiedSpace {
  final Vector2 position;
  final double radius;
  _OccupiedSpace(this.position, this.radius);
}

/// Top-level function for Isolate computation.
/// This generates random, non-overlapping coordinates for all level components.
LevelData generateLevelData(int currentLevel) {
  final random = Random();

  final List<HoleData> holes = [];
  final List<Vector2> stars = [];
  final List<Vector2> hearts = [];
  List<Vector2> multiBalls = [];
  final List<Vector2> magnets = [];
  final List<BumperData> bumpers = [];
  final List<TeleporterData> teleporters = [];

  // This list tracks all placed items to ensure a transparent radius/clearance around each.
  final List<_OccupiedSpace> occupied = [];

  // Helper to check if a space is safe (no overlaps)
  bool isSpaceSafe(Vector2 pos, double radius) {
    for (final space in occupied) {
      double dx = space.position.x - pos.x;
      // Multiply dy by approx aspect ratio (4.0) so clearance is roughly circular on-screen
      double dy = (space.position.y - pos.y) * 4.0;
      if (sqrt(dx * dx + dy * dy) < space.radius + radius) {
        return false; // Too close!
      }
    }
    return true;
  }

  // ---------------------------------------------------------
  // 1. Generate Teleporters (Level 7+) first to ensure they have space
  // ---------------------------------------------------------
  if (currentLevel >= 7) {
    int numPairs = 1;
    for (int i = 0; i < numPairs; i++) {
      double tY1 = 0.05 + (i * (0.9 / numPairs));
      double tY2 = 0.95 - (i * (0.9 / numPairs));
      
      Vector2 p1 = Vector2(0.2 + random.nextDouble() * 0.2 + ((i % 2) * 0.4), tY1);
      Vector2 p2 = Vector2(0.2 + random.nextDouble() * 0.2 + ((i % 2) * 0.4), tY2);

      teleporters.add(TeleporterData(p1, 30.0, i));
      teleporters.add(TeleporterData(p2, 30.0, i));
      
      occupied.add(_OccupiedSpace(p1, 0.20)); // Generous clearance for teleporters
      occupied.add(_OccupiedSpace(p2, 0.20));
    }
  }

  // ---------------------------------------------------------
  // 2. Generate Holes
  // ---------------------------------------------------------
  int numHoles = currentLevel;
  if (currentLevel >= 10) {
    numHoles = 18;
  } else if (numHoles > 7) {
    numHoles = 7; // Cap at 7 for normal levels
  }

  if (currentLevel == 1) {
    // 1 big centered hole
    Vector2 p = Vector2(0.5, 0.4);
    holes.add(HoleData(p, 45.0, random.nextDouble() * 2 * pi, false, 0.0));
    occupied.add(_OccupiedSpace(p, 0.25));
  } else {
    for (int i = 0; i < numHoles; i++) {
      int attempts = 0;
      double x = 0;
      double y = 0;
      double hSize = 35.0 + random.nextDouble() * 25.0; // 35 to 60 px

      while (attempts < 50) {
        y = random.nextDouble();
        double safeX = 0.5 + 0.3 * sin(y * 2 * pi);
        x = random.nextDouble();

        if ((x - safeX).abs() < 0.22) {
          if (x > safeX) {
            x = safeX + 0.22 + random.nextDouble() * 0.2;
          } else {
            x = safeX - 0.22 - random.nextDouble() * 0.2;
          }
        }
        x = x.clamp(0.12, 0.88);

        bool isSucking = false;
        if (currentLevel >= 10 && i < 5) {
          isSucking = true;
        } else if (currentLevel >= 8 && i < 2) {
          isSucking = true;
        } else if (currentLevel >= 6 && i == 0) {
          isSucking = true;
        }

        double requiredSpace = isSucking ? 0.35 : 0.16;

        if (isSpaceSafe(Vector2(x, y), requiredSpace)) {
          double suckRad = isSucking ? 50.0 + (currentLevel * 2.0) : 0.0;

          holes.add(HoleData(Vector2(x, y), hSize, random.nextDouble() * 2 * pi, isSucking, suckRad));
          
          // Add to occupied space so other obstacles stay away
          occupied.add(_OccupiedSpace(Vector2(x, y), requiredSpace));
          break; // successfully placed
        }
        attempts++;
      }
    }
  }

  // ---------------------------------------------------------
  // 3. Generate Bumpers (Level 5+)
  // ---------------------------------------------------------
  if (currentLevel >= 5) {
    int numBumpers = 1;
    if (currentLevel >= 6) numBumpers = 2;
    if (currentLevel >= 8) numBumpers = 4;
    if (currentLevel >= 10) numBumpers = 10;

    for (int i = 0; i < numBumpers; i++) {
      int attempts = 0;
      double x = 0, y = 0;

      while (attempts < 50) {
        y = random.nextDouble();
        x = 0.2 + random.nextDouble() * 0.6;

        if (isSpaceSafe(Vector2(x, y), 0.14)) {
          bumpers.add(BumperData(Vector2(x, y), 18.0));
          occupied.add(_OccupiedSpace(Vector2(x, y), 0.14));
          break;
        }
        attempts++;
      }
    }
  }

  // ---------------------------------------------------------
  // 4. Generate Stars
  // ---------------------------------------------------------
  int numStars = currentLevel >= 10 ? 9 : 3;
  for (int i = 0; i < numStars; i++) {
    int attempts = 0;
    double x = 0, y = 0;

    while (attempts < 50) {
      y = 0.05 + (i / numStars) * 0.9 + random.nextDouble() * (0.9 / numStars);
      double safeX = 0.5 + 0.3 * sin(y * 2 * pi);

      x = safeX + (random.nextDouble() - 0.5) * 0.15;
      x = x.clamp(0.12, 0.88);

      if (isSpaceSafe(Vector2(x, y), 0.12)) {
        stars.add(Vector2(x, y));
        occupied.add(_OccupiedSpace(Vector2(x, y), 0.12));
        break;
      }
      attempts++;
    }
  }

  // ---------------------------------------------------------
  // 5. Generate Hearts (Level 4+)
  // ---------------------------------------------------------
  if (currentLevel >= 4) {
    int numHearts = currentLevel >= 8 ? 2 : 1;
    if (currentLevel >= 10) numHearts = 4;
    for (int i = 0; i < numHearts; i++) {
      int attempts = 0;
      double x = 0, y = 0;

      while (attempts < 50) {
        y = 0.05 + (i / numHearts) * 0.9 + random.nextDouble() * (0.9 / numHearts);
        double safeX = 0.5 + 0.3 * sin(y * 2 * pi);

        x = safeX + (random.nextDouble() - 0.5) * 0.15;
        x = x.clamp(0.12, 0.88);

        if (isSpaceSafe(Vector2(x, y), 0.12)) {
          hearts.add(Vector2(x, y));
          occupied.add(_OccupiedSpace(Vector2(x, y), 0.12));
          break;
        }
        attempts++;
      }
    }
  }

  // ---------------------------------------------------------
  // 6. Generate MultiBalls (Level 4+)
  // ---------------------------------------------------------
  if (currentLevel >= 4) {
    int attempts = 0;
    while (attempts < 50) {
      double x = 0.5 + (random.nextDouble() - 0.5) * 0.4;
      double y = 0.3 + random.nextDouble() * 0.4;
      
      if (isSpaceSafe(Vector2(x, y), 0.12)) {
        multiBalls.add(Vector2(x, y));
        occupied.add(_OccupiedSpace(Vector2(x, y), 0.12));
        break;
      }
      attempts++;
    }
  }

  // ---------------------------------------------------------
  // 7. Generate Magnets (Level 3+)
  // ---------------------------------------------------------
  if (currentLevel >= 3) {
    int attempts = 0;
    while (attempts < 50) {
      double x = 0.5 + (random.nextDouble() - 0.5) * 0.6;
      double y = 0.2 + random.nextDouble() * 0.6;
      
      if (isSpaceSafe(Vector2(x, y), 0.12)) {
        magnets.add(Vector2(x, y));
        occupied.add(_OccupiedSpace(Vector2(x, y), 0.12));
        break;
      }
      attempts++;
    }
  }

  return LevelData(
    holes: holes,
    stars: stars,
    hearts: hearts,
    bumpers: bumpers,
    teleporters: teleporters,
    multiBalls: multiBalls,
    magnets: magnets,
  );
}
