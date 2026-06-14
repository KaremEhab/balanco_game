import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/hole_component.dart';
import 'components/bar_component.dart';
import 'components/ball_component.dart';
import 'components/star_component.dart';
import 'components/finish_line_component.dart';
import 'components/bumper_component.dart';
import 'components/teleporter_component.dart';
import 'components/confetti_component.dart';
import 'components/heart_component.dart';
import 'dart:isolate';
import 'models/level_data.dart';
import 'level_generator.dart';

class BalancoGame extends FlameGame {
  final bool isMultiplayer;
  final String playerRole;

  VoidCallback? onGameOver;
  VoidCallback? onLevelComplete;

  final ValueNotifier<int> currentLevel = ValueNotifier<int>(1);
  final ValueNotifier<int> currentPoints = ValueNotifier<int>(0);
  final ValueNotifier<int> currentLives = ValueNotifier<int>(3);

  double leftJoystickValue = 0.0;
  double rightJoystickValue = 0.0;

  double leftY = 0.0;
  double rightY = 0.0;

  double ballP = 0.0; // 1D position along the bar
  double ballVelocity = 0.0;
  bool isFalling = false;
  bool isFallingInHole = false;
  Vector2 fallTarget = Vector2.zero();
  HoleComponent? activeHole;
  double fallRotation = 0.0;
  double ballScale = 1.0;

  Vector2 ballPos2D = Vector2.zero();
  Vector2 freeFallVelocity = Vector2.zero();
  
  bool isFreeFalling = false;
  double timeStopTimer = 0.0;
  final ValueNotifier<double> timeStopNotifier = ValueNotifier<double>(0.0);

  bool isCurtainDropping = false;
  bool isCurtainRetracting = false;
  bool isBoardHidden = false;

  final double barPadding = 20.0;
  final double ballRadius = 10.0;

  late BarComponent barComponent;
  late BallComponent ballComponent;
  final List<HoleComponent> holes = [];
  final List<StarComponent> stars = [];
  final List<HeartComponent> hearts = [];
  final List<BumperComponent> bumpers = [];
  final List<TeleporterComponent> teleporters = [];
  TeleporterComponent? activeExitTeleporter;
  late FinishLineComponent finishLineComponent;

  BalancoGame({
    required this.isMultiplayer,
    required this.playerRole,
    this.onGameOver,
    this.onLevelComplete,
  });

  @override
  Color backgroundColor() => const Color(0x00000000);

  void reset() {
    currentLevel.value = 1;
    restartCurrentLevel();
  }

  void restartCurrentLevel() async {
    currentPoints.value = 0;
    currentLives.value = 3;
    
    children.whereType<ConfettiComponent>().forEach((c) => c.removeFromParent());
    _resetPositions();
    await generateLevel();
    resumeEngine();
  }

  void startNextLevel() {
    currentLevel.value++;
    restartCurrentLevel();
  }

  Future<void> retractCurtainAndStartNextLevel() async {
    isCurtainDropping = false;
    isCurtainRetracting = true;
    finishLineComponent.targetHeight = 24.0;
    
    // Save progress!
    final prefs = await SharedPreferences.getInstance();
    
    int completedLevel = currentLevel.value;
    int starsEarned = currentPoints.value;
    
    // Save stars for THIS level (only overwrite if they got more stars)
    int previousStars = prefs.getInt('level_${completedLevel}_stars') ?? 0;
    if (starsEarned > previousStars) {
      await prefs.setInt('level_${completedLevel}_stars', starsEarned);
    }
    
    // Update highest level
    int highestLevel = prefs.getInt('highestLevel') ?? 1;
    if (completedLevel + 1 > highestLevel) {
      await prefs.setInt('highestLevel', completedLevel + 1);
    }

    currentLevel.value++;
  }

  void retractCurtainAndRestartLevel() {
    isCurtainDropping = false;
    isCurtainRetracting = true;
    // We don't advance the level, we just restart the current one after curtain goes up.
    // We'll set a flag so that `restartCurrentLevel` is called.
    finishLineComponent.targetHeight = 24.0;
    // By convention, if currentPoints was 0 it's a restart. We will just use startNextLevel = false;
  }

  void _resetPositions({bool loseLife = false}) {
    isFalling = false;
    isFallingInHole = false;
    activeHole = null;
    ballScale = 1.0;
    fallRotation = 0.0;
    ballVelocity = 0.0;
    isFreeFalling = false;
    isBoardHidden = false;
    timeStopTimer = 0.0;
    timeStopNotifier.value = 0.0;
    timeStopNotifier.value = 0.0;
    activeExitTeleporter = null;
    for (final t in teleporters) {
      t.isClosed = false;
    }
    if (!loseLife) {
      for (final star in stars) {
        star.reset();
      }
      for (final heart in hearts) {
        heart.reset();
      }
    }

    if (loseLife) {
      currentLives.value--;
      if (currentLives.value <= 0) {
        HapticFeedback.vibrate();
        try {
          FlameAudio.play('gameover.wav');
        } catch (_) {}
        pauseEngine();
        overlays.add('GameOver');
        return; // Don't reset position yet
      }
    }

    if (size.x > 0 && size.y > 0) {
      leftY = size.y - 20.0;
      rightY = size.y - 20.0;
      ballP = (size.x - 2 * barPadding) / 2.0; // Start at center of the bar
      ballPos2D = Vector2(size.x / 2.0, size.y - 20.0 - ballRadius - 6.0);

      leftJoystickValue = 0.0;
      rightJoystickValue = 0.0;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (leftY == 0.0 && rightY == 0.0) {
      _resetPositions();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Pre-cache audio if possible
    try {
      await FlameAudio.audioCache.loadAll([
        'star.wav',
        'hole.wav',
        'fall.wav',
        'win.wav',
        'gameover.wav',
        'tick.wav',
      ]);
    } catch (_) {}

    barComponent = BarComponent()..priority = 10;
    ballComponent = BallComponent()..priority = 20;
    finishLineComponent = FinishLineComponent()..priority = 30;
    
    add(finishLineComponent); // Add flag above the ball and bar
    add(barComponent);
    add(ballComponent);
    await generateLevel();
  }

  Future<void> generateLevel() async {
    for (final hole in holes) {
      if (hole.parent != null) hole.removeFromParent();
    }
    holes.clear();
    for (final star in stars) {
      if (star.parent != null) star.removeFromParent();
    }
    stars.clear();
    for (final heart in hearts) {
      if (heart.parent != null) heart.removeFromParent();
    }
    hearts.clear();
    for (final bumper in bumpers) {
      if (bumper.parent != null) bumper.removeFromParent();
    }
    bumpers.clear();
    for (final t in teleporters) {
      if (t.parent != null) t.removeFromParent();
    }
    teleporters.clear();

    // Offload level generation to an Isolate
    final int levelToGenerate = currentLevel.value;
    final LevelData data = await Isolate.run(() => generateLevelData(levelToGenerate));

    // Quickly spawn components back on the main thread using the pre-calculated data
    for (final hData in data.holes) {
      final hole = HoleComponent(
        hData.position,
        hData.size,
        hData.rotation,
        isSuckingHole: hData.isSuckingHole,
        suckRadius: hData.suckRadius,
      )..priority = 1;
      holes.add(hole);
      add(hole);
    }

    for (final tData in data.teleporters) {
      final teleporter = TeleporterComponent(tData.position, tData.size, tData.pairId)..priority = 1;
      teleporters.add(teleporter);
      add(teleporter);
    }

    for (final bData in data.bumpers) {
      final bumper = BumperComponent(bData.position, bData.size)..priority = 2;
      bumpers.add(bumper);
      add(bumper);
    }

    for (final sPos in data.stars) {
      final star = StarComponent(sPos)..priority = 5;
      stars.add(star);
      add(star);
    }

    for (final hPos in data.hearts) {
      final heart = HeartComponent(hPos)..priority = 5;
      hearts.add(heart);
      add(heart);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (size.x == 0 || size.y == 0) return;

    if (isFallingInHole) {
      fallRotation += dt * 15.0; // Rapid spin
      ballScale -= dt * 1.0; // Slower fall (takes 1 second)
      ballPos2D.lerp(fallTarget, dt * 5.0); // Slower pull to center

      if (ballScale <= -0.5) {
        // Wait half a second after ball vanishes for teeth to close
        _resetPositions(loseLife: true);
      }
      return;
    }

    if (isCurtainRetracting) {
      if (finishLineComponent.currentHeight <= 25.0) {
        finishLineComponent.currentHeight = 24.0;
        isCurtainRetracting = false;
        isBoardHidden = false; // Show the board again!
        // Since we retracted, we reset the level now!
        restartCurrentLevel();
      }
      return; // Skip physics while retracting
    }

    if (isCurtainDropping) {
      // Hide the board items quickly as the curtain comes down
      if (finishLineComponent.currentHeight > 100.0) {
        isBoardHidden = true;
      }

      if (finishLineComponent.currentHeight >= size.y - 1.0) {
        finishLineComponent.currentHeight = size.y;
        // Don't pause engine, we need engine running for Flame tap events!
        // pauseEngine(); 
      }
      return; // Skip physics while dropping
    }

    // Check if reached Finish Line
    if (ballPos2D.y > 0 && ballPos2D.y < 25.0 && !isFalling) {
      HapticFeedback.heavyImpact();
      try {
        FlameAudio.play('win.wav', volume: 1.0);
      } catch (_) {}
      isCurtainDropping = true;
      finishLineComponent.targetHeight = size.y;

      // Spawn Confetti!
      final confetti = ConfettiComponent()
        ..size = size
        ..priority = 40;
      add(confetti);

      return;
    }

    // Time Stop Timer
    if (timeStopTimer > 0) {
      timeStopTimer -= dt;
      if (timeStopTimer <= 0) {
        timeStopTimer = 0.0;
      }
      timeStopNotifier.value = timeStopTimer;
    } else {
      timeStopNotifier.value = 0.0;
    }

    double maxY = size.y - 20.0;
    double minY = 10.0;

    double speed = timeStopNotifier.value > 0 ? 150.0 : 250.0; // Slower for suspense, but enough to reach the top!
    double maxDiff = 120.0;

    double newLeftY = leftY + leftJoystickValue * speed * dt;
    newLeftY = newLeftY.clamp(rightY - maxDiff, rightY + maxDiff);
    newLeftY = newLeftY.clamp(minY, maxY);

    double newRightY = rightY + rightJoystickValue * speed * dt;
    newRightY = newRightY.clamp(leftY - maxDiff, leftY + maxDiff);
    newRightY = newRightY.clamp(minY, maxY);

    leftY = newLeftY;
    rightY = newRightY;

    Vector2 leftPoint = Vector2(barPadding, leftY);
    Vector2 rightPoint = Vector2(size.x - barPadding, rightY);
    Vector2 direction = (rightPoint - leftPoint).normalized();
    double barLength = (rightPoint - leftPoint).length;
    Vector2 normal = Vector2(direction.y, -direction.x);

    if (isFreeFalling) {
      double gravity = timeStopNotifier.value > 0 ? 15.0 : 980.0;
      freeFallVelocity.y += gravity * dt;
      
      double prevY = ballPos2D.y;
      ballPos2D += freeFallVelocity * dt;
      double newY = ballPos2D.y;

      // Check bar intersection
      if (ballPos2D.x > barPadding && ballPos2D.x < size.x - barPadding) {
        double t = (ballPos2D.x - barPadding) / (size.x - 2 * barPadding);
        double barYAtX = leftY + (rightY - leftY) * t;
        double barSurface = barYAtX - (ballRadius + 6.0);
        
        // If ball falls through the surface
        if (prevY <= barSurface + 5.0 && newY >= barSurface - 5.0) {
          isFreeFalling = false;
          timeStopTimer = 0.0;
          timeStopNotifier.value = 0.0;
          ballP = t * barLength;
          ballVelocity = freeFallVelocity.x; // Keep x-momentum
          ballPos2D = leftPoint + direction * ballP + normal * (ballRadius + 6.0);
          HapticFeedback.heavyImpact();
          try { FlameAudio.play('tick.wav'); } catch (_) {}
          
          if (activeExitTeleporter != null) {
            activeExitTeleporter!.isClosed = true;
            activeExitTeleporter = null;
          }
        }
      }

      if (ballPos2D.y > size.y + 100) {
        _resetPositions(loseLife: true);
      }
    } else if (!isFalling) {
      double alpha = atan2(
        rightPoint.y - leftPoint.y,
        rightPoint.x - leftPoint.x,
      );
      double gravity = 980.0;
      double accel = gravity * sin(alpha);

      ballVelocity += accel * dt;
      ballVelocity *= 0.99; // Simple friction

      ballP += ballVelocity * dt;

      if (ballP < 0 || ballP > barLength) {
        isFalling = true;
        HapticFeedback.heavyImpact();
        try {
          FlameAudio.play('fall.wav');
        } catch (_) {}
        freeFallVelocity = direction * ballVelocity;
      } else {
        ballPos2D = leftPoint + direction * ballP + normal * (ballRadius + 6.0);

        // Check teleporter collisions
        for (final t in teleporters) {
          if (t.isClosed) continue;
          double dist = ballPos2D.distanceTo(t.position);
          if (dist < t.radius) {
            t.isClosed = true;
            
            TeleporterComponent? other;
            for (final candidate in teleporters) {
              if (candidate != t && candidate.index == t.index) {
                other = candidate;
                break;
              }
            }
            
            if (other != null) {
              activeExitTeleporter = other;
              ballPos2D = other.position.clone();
              
              isFreeFalling = true;
              timeStopTimer = 4.0;
              timeStopNotifier.value = 4.0;
              freeFallVelocity = Vector2.zero();
              
              HapticFeedback.heavyImpact();
              try { FlameAudio.play('hole.wav'); } catch (_) {}
              break;
            }
          }
        }
        
        if (isFreeFalling) return; // Skip other collisions if we just teleported

        // Check hole collisions
        for (final hole in holes) {
          double dist = ballPos2D.distanceTo(hole.position);
          double lethalDist = (hole.size.x / 2) - 2.0;

          if (dist < lethalDist) {
            isFallingInHole = true;
            activeHole = hole;
            HapticFeedback.heavyImpact();
            try {
              FlameAudio.play('hole.wav');
            } catch (_) {}
            fallTarget = hole.position.clone();
            break;
          } else if (hole.isSuckingHole && dist < hole.suckRadius) {
            // Sucked by the wind radius!
            isFallingInHole = true;
            activeHole = hole;
            HapticFeedback.heavyImpact();
            try {
              FlameAudio.play('hole.wav');
            } catch (_) {}
            fallTarget = hole.position.clone();
            break;
          }
        }

        // Check bumper collisions
        for (final bumper in bumpers) {
          double dist = ballPos2D.distanceTo(bumper.position);
          if (dist < bumper.radius + ballRadius) {
            bumper.hit();
            HapticFeedback.heavyImpact();

            Vector2 bounceDir = (ballPos2D - bumper.position).normalized();
            double dot = bounceDir.dot(direction);

            // Add a massive bounce force along the bar
            ballVelocity += dot * 400.0;

            // Immediately resolve intersection
            double overlap = (bumper.radius + ballRadius) - dist;
            ballP += dot.sign * overlap * 2.0;

            // Update ball pos immediately to reflect the un-sticking
            ballPos2D =
                leftPoint + direction * ballP + normal * (ballRadius + 6.0);
          }
        }

        // Check star collisions
        for (final star in stars) {
          if (!star.isCollected) {
            Vector2 starPos = Vector2(
              star.fractionalPosition.x * size.x,
              star.fractionalPosition.y * size.y,
            );
            if (ballPos2D.distanceTo(starPos) < ballRadius + 15.0) {
              star.isCollected = true;
              currentPoints.value++;
              HapticFeedback.lightImpact();
              try {
                FlameAudio.play('star.wav');
              } catch (_) {}
            }
          }
        }

        // Check heart collisions
        for (final heart in hearts) {
          if (!heart.isCollected) {
            Vector2 heartPos = Vector2(
              heart.fractionalPosition.x * size.x,
              heart.fractionalPosition.y * size.y,
            );
            if (ballPos2D.distanceTo(heartPos) < ballRadius + 15.0) {
              heart.isCollected = true;
              currentLives.value++;
              HapticFeedback.lightImpact();
              try {
                FlameAudio.play('star.wav'); // We can reuse star sound or add life.wav later
              } catch (_) {}
            }
          }
        }
      }
    } else {
      // Free fall mechanics (falling off the edge)
      fallRotation += dt * 10.0; // Spin wildly
      ballScale -= dt * 1.5; // Shrink as it falls away into the abyss
      if (ballScale < 0) ballScale = 0;

      freeFallVelocity.y += 980.0 * dt;
      ballPos2D += freeFallVelocity * dt;

      if (ballPos2D.y > size.y + 100 || ballScale <= 0) {
        _resetPositions(loseLife: true);
      }
    }
  }
}
