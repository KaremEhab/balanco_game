import 'dart:math';
import 'package:flame/components.dart';
import 'models/level_data.dart';

/// Top-level function for Isolate computation.
/// This generates random, non-overlapping coordinates for all level components.
LevelData generateLevelData(int currentLevel) {
  final random = Random();

  final List<HoleData> holes = [];
  final List<Vector2> stars = [];
  final List<Vector2> hearts = [];
  final List<BumperData> bumpers = [];
  final List<TeleporterData> teleporters = [];

  int numHoles = currentLevel;
  if (numHoles > 7) numHoles = 7; // Cap at 7

  if (currentLevel == 1) {
    // 1 big centered hole
    holes.add(HoleData(
      Vector2(0.5, 0.4),
      45.0,
      random.nextDouble() * 2 * pi,
      false,
      0.0,
    ));
  } else {
    // random holes logic
    for (int i = 0; i < numHoles; i++) {
      int attempts = 0;
      double x = 0;
      double y = 0;
      double hSize = 35.0 + random.nextDouble() * 25.0; // 35 to 60 px

      while (attempts < 50) {
        y = random.nextDouble();
        if (y < 0.2) {
          y = 0.2 + random.nextDouble() * 0.65; // Keep away from target
        }
        if (y > 0.85) {
          y = 0.2 + random.nextDouble() * 0.65; // Keep away from start
        }

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

        bool tooClose = false;
        for (final h in holes) {
          double dx = h.position.x - x;
          double dy = h.position.y - y;
          if (sqrt(dx * dx + dy * dy) < 0.16) {
            tooClose = true;
            break;
          }
        }

        if (!tooClose) {
          break;
        }
        attempts++;
      }

      // Level 8+ has 2 sucking holes, Level 6-7 has 1
      bool isSucking = false;
      if (currentLevel >= 8 && i < 2) {
        isSucking = true;
      } else if (currentLevel >= 6 && i == 0) {
        isSucking = true;
      }
      
      double suckRad = isSucking ? 50.0 + (currentLevel * 2.0) : 0.0;

      holes.add(HoleData(
        Vector2(x, y),
        hSize,
        random.nextDouble() * 2 * pi,
        isSucking,
        suckRad,
      ));
    }
  }

  // Generate Teleporters (Level 7+)
  if (currentLevel >= 7) {
    // 1 pair for level 7, 2 pairs for level 9+
    int numPairs = currentLevel >= 9 ? 2 : 1;
    for (int i = 0; i < numPairs; i++) {
      teleporters.add(TeleporterData(Vector2(0.2 + random.nextDouble() * 0.2 + (i * 0.4), 0.15 + (i * 0.1)), 30.0, i));
      teleporters.add(TeleporterData(Vector2(0.2 + random.nextDouble() * 0.2 + (i * 0.4), 0.85 - (i * 0.1)), 30.0, i));
    }
  }

  // Generate Bumpers (Level 5+)
  if (currentLevel >= 5) {
    int numBumpers = 1;
    if (currentLevel >= 6) numBumpers = 2;
    if (currentLevel >= 8) numBumpers = 4;
    
    for (int i = 0; i < numBumpers; i++) {
      int attempts = 0;
      double x = 0;
      double y = 0;

      while (attempts < 50) {
        y = 0.3 + random.nextDouble() * 0.4;
        x = 0.2 + random.nextDouble() * 0.6;

        bool tooClose = false;
        for (final h in holes) {
          if (Vector2(x, y).distanceTo(h.position) < 0.2) {
            tooClose = true;
            break;
          }
        }
        for (final b in bumpers) {
          if (Vector2(x, y).distanceTo(b.position) < 0.3) {
            tooClose = true;
            break;
          }
        }
        if (!tooClose) break;
        attempts++;
      }

      bumpers.add(BumperData(Vector2(x, y), 18.0));
    }
  }

  // Generate 3 stars safely
  for (int i = 0; i < 3; i++) {
    int attempts = 0;
    double x = 0;
    double y = 0;

    while (attempts < 50) {
      y = 0.2 + i * 0.22 + random.nextDouble() * 0.1; 
      double safeX = 0.5 + 0.3 * sin(y * 2 * pi);

      x = safeX + (random.nextDouble() - 0.5) * 0.15;
      x = x.clamp(0.12, 0.88);

      bool tooClose = false;
      for (final h in holes) {
        double dx = h.position.x - x;
        double dy = h.position.y - y;
        if (sqrt(dx * dx + dy * dy) < 0.15) {
          tooClose = true;
          break;
        }
      }

      if (!tooClose) break;
      attempts++;
    }

    stars.add(Vector2(x, y));
  }

  // Generate 1 Heart safely (Level 4+)
  if (currentLevel >= 4) {
    int numHearts = currentLevel >= 8 ? 2 : 1;
    for (int i = 0; i < numHearts; i++) {
      int attempts = 0;
      double x = 0;
      double y = 0;

      while (attempts < 50) {
        y = 0.4 + random.nextDouble() * 0.5; // Lower half of the board
      double safeX = 0.5 + 0.3 * sin(y * 2 * pi);

      x = safeX + (random.nextDouble() - 0.5) * 0.15;
      x = x.clamp(0.12, 0.88);

      bool tooClose = false;
      for (final h in holes) {
        double dx = h.position.x - x;
        double dy = h.position.y - y;
        if (sqrt(dx * dx + dy * dy) < 0.15) {
          tooClose = true;
          break;
        }
      }
      for (final s in stars) {
        if (Vector2(x, y).distanceTo(s) < 0.15) {
          tooClose = true;
          break;
        }
      }

        if (!tooClose) break;
        attempts++;
      }

      hearts.add(Vector2(x, y));
    }
  }

  return LevelData(
    holes: holes,
    stars: stars,
    hearts: hearts,
    bumpers: bumpers,
    teleporters: teleporters,
  );
}
