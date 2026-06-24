import 'dart:isolate';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/hole_component.dart';
import 'components/bar_component.dart';
import 'components/ball_component.dart';
import 'components/star_component.dart';
import 'components/teleporting_gate_component.dart';
import 'components/bumper_component.dart';
import 'components/teleporter_component.dart';
import 'components/confetti_component.dart';
import 'components/heart_component.dart';
import 'components/coin_component.dart';

import 'models/level_data.dart';
import 'level_generator.dart';

class BalancoGame extends FlameGame {
  final bool isMultiplayer;
  final String playerRole;

  VoidCallback? onGameOver;
  VoidCallback? onLevelComplete;

  final ValueNotifier<int> currentLevel = ValueNotifier<int>(1);
  final ValueNotifier<int> currentPoints = ValueNotifier<int>(0);
  final ValueNotifier<int> currentScore = ValueNotifier<int>(0);
  final ValueNotifier<int> currentLives = ValueNotifier<int>(3);

  // Shield state
  final ValueNotifier<int> remainingShields = ValueNotifier<int>(3);
  final ValueNotifier<double> shieldTimerNotifier = ValueNotifier<double>(0.0);
  double shieldTimer = 0.0;
  bool get isShieldActive => shieldTimer > 0;

  // Magnet state
  final ValueNotifier<int> remainingMagnets = ValueNotifier<int>(3);
  final ValueNotifier<double> magnetTimerNotifier = ValueNotifier<double>(0.0);
  double magnetTimer = 0.0;
  bool get isMagnetActive => magnetTimer > 0;

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

  bool isBoardHidden = false;
  final ValueNotifier<bool> showVictoryOverlay = ValueNotifier<bool>(false);
  bool isLevelCompleteOverlayShown = false;
  bool isSuckingToGate = false;

  bool isSpawningLevel = true;
  double spawnTimer = 0.0;
  List<PositionComponent> pendingSpawns = [];
  Map<PositionComponent, Vector2> targetPositions = {};
  double itemSpawnTimer = 0.0;
  final double spawnInterval = 0.10;

  double bounceTimer = 0.0;
  double squashX = 1.0;
  double squashY = 1.0;

  bool isRespawningFromHole = false;
  double respawnTimer = 0.0;

  double barResetTimer = 0.0;
  double initialLeftY = 0.0;
  double initialRightY = 0.0;

  final double barPadding = 20.0;
  final double ballRadius = 14.0;

  late BarComponent barComponent;
  late BallComponent ballComponent;
  final List<HoleComponent> holes = [];
  final List<StarComponent> stars = [];
  final List<HeartComponent> hearts = [];
  final List<CoinComponent> coins = [];
  final List<BumperComponent> bumpers = [];
  final List<TeleporterComponent> teleporters = [];
  TeleporterComponent? activeExitTeleporter;
  TeleportingGateComponent teleportingGateComponent = TeleportingGateComponent()
    ..priority = 0;

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
    isSpawningLevel = true;
    currentPoints.value = 0;
    currentLives.value = 3;

    children.whereType<ConfettiComponent>().forEach(
      (c) => c.removeFromParent(),
    );
    _resetPositions();
    await generateLevel();
    resumeEngine();
  }

  void startNextLevel() {
    currentLevel.value++;
    restartCurrentLevel();
  }

  Future<void> advanceToNextLevel() async {
    isSuckingToGate = false;
    showVictoryOverlay.value = false;
    isLevelCompleteOverlayShown = false;

    final prefs = await SharedPreferences.getInstance();
    int completedLevel = currentLevel.value;
    int starsEarned = currentPoints.value;
    int previousStars = prefs.getInt('level_${completedLevel}_stars') ?? 0;
    if (starsEarned > previousStars) {
      await prefs.setInt('level_${completedLevel}_stars', starsEarned);
    }
    int highestLevel = prefs.getInt('highestLevel') ?? 1;
    if (completedLevel + 1 > highestLevel) {
      await prefs.setInt('highestLevel', completedLevel + 1);
    }

    currentLevel.value++;
    restartCurrentLevel();
  }

  void restartLevelAfterWin() {
    isSuckingToGate = false;
    showVictoryOverlay.value = false;
    isLevelCompleteOverlayShown = false;
    restartCurrentLevel();
  }

  void _resetPositions({bool loseLife = false, bool respawnFromHole = false}) {
    HoleComponent? prevHole = activeHole;

    isFalling = false;
    isFallingInHole = false;
    activeHole = null;
    ballScale = 1.0;
    squashX = 1.0;
    squashY = 1.0;
    fallRotation = 0.0;
    ballVelocity = 0.0;
    freeFallVelocity = Vector2.zero();
    isFreeFalling = false;
    isBoardHidden = false;
    isLevelCompleteOverlayShown = false;
    teleportingGateComponent.reset();
    timeStopTimer = 0.0;
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
      if (leftY != 0.0 && size.y > 0 && !isSpawningLevel) {
        initialLeftY = leftY;
        initialRightY = rightY;
        barResetTimer = respawnFromHole ? 1.5 : 0.8;
      } else {
        barResetTimer = 0.0;
        leftY = size.y - 80.0;
        rightY = size.y - 80.0;
      }
      ballP = (size.x - 2 * barPadding) / 2.0; // Start at center of the bar

      if (isSpawningLevel) {
        teleportingGateComponent.startClosed();

        ballPos2D = teleportingGateComponent.position.clone();
        ballScale = 0.0;
        spawnTimer = 1.5;
      } else if (respawnFromHole && prevHole != null) {
        activeHole = prevHole;
        isRespawningFromHole = true;
        respawnTimer = 1.5;
        ballPos2D = activeHole!.position.clone();
        ballScale = 0.0;
        // The ball will land on the center of the bar
        ballP = (size.x - 2 * barPadding) / 2.0;
      } else {
        // Wait, if barResetTimer > 0, ball should stick to the animating bar.
        // It will be calculated in update(), but we initialize it to center.
        ballPos2D = Vector2(size.x / 2.0, leftY - ballRadius - 6.0);
        ballScale = 1.0;
        isFreeFalling = false;
        bounceTimer = 0.4; // Small bounce effect when appearing on bar
      }

      leftJoystickValue = 0.0;
      rightJoystickValue = 0.0;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    teleportingGateComponent.position = Vector2(size.x / 2.0, 70.0);
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

    add(teleportingGateComponent);
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
    for (final coin in coins) {
      if (coin.parent != null) coin.removeFromParent();
    }
    coins.clear();
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
    final LevelData data = await Isolate.run(
      () => generateLevelData(levelToGenerate),
    );

    pendingSpawns.clear();
    targetPositions.clear();

    // Quickly spawn components back on the main thread using the pre-calculated data
    for (final hData in data.holes) {
      final hole = HoleComponent(
        hData.position,
        hData.size,
        hData.rotation,
        isSuckingHole: hData.isSuckingHole,
        suckRadius: hData.suckRadius,
      )..priority = 1;

      final targetPos = Vector2(
        hData.position.x * size.x,
        120.0 + hData.position.y * (size.y - 320.0),
      );
      targetPositions[hole] = targetPos;
      hole.position = teleportingGateComponent.position.clone();
      hole.scale = Vector2.zero();
      pendingSpawns.add(hole);

      holes.add(hole);
      add(hole);
    }

    for (final tData in data.teleporters) {
      final teleporter = TeleporterComponent(
        tData.position,
        tData.size,
        tData.pairId,
      )..priority = 1;

      final targetPos = Vector2(
        tData.position.x * size.x,
        120.0 + tData.position.y * (size.y - 320.0),
      );
      targetPositions[teleporter] = targetPos;
      teleporter.position = teleportingGateComponent.position.clone();
      teleporter.scale = Vector2.zero();
      pendingSpawns.add(teleporter);

      teleporters.add(teleporter);
      add(teleporter);
    }

    for (final bData in data.bumpers) {
      final bumper = BumperComponent(bData.position, bData.size)..priority = 2;

      final targetPos = Vector2(
        bData.position.x * size.x,
        120.0 + bData.position.y * (size.y - 320.0),
      );
      targetPositions[bumper] = targetPos;
      bumper.position = teleportingGateComponent.position.clone();
      bumper.scale = Vector2.zero();
      pendingSpawns.add(bumper);

      bumpers.add(bumper);
      add(bumper);
    }

    for (final sPos in data.stars) {
      final star = StarComponent(sPos)..priority = 5;

      final targetPos = Vector2(sPos.x * size.x, 120.0 + sPos.y * (size.y - 320.0));
      targetPositions[star] = targetPos;
      star.position = teleportingGateComponent.position.clone();
      star.scale = Vector2.zero();
      pendingSpawns.add(star);

      stars.add(star);
      add(star);
    }

    for (final hPos in data.hearts) {
      final heart = HeartComponent(hPos)..priority = 5;

      final targetPos = Vector2(hPos.x * size.x, 120.0 + hPos.y * (size.y - 320.0));
      targetPositions[heart] = targetPos;
      heart.position = teleportingGateComponent.position.clone();
      heart.scale = Vector2.zero();
      pendingSpawns.add(heart);

      hearts.add(heart);
      add(heart);
    }

    for (final cPos in data.coins) {
      final coin = CoinComponent(cPos)..priority = 5;

      final targetPos = Vector2(cPos.x * size.x, 120.0 + cPos.y * (size.y - 320.0));
      targetPositions[coin] = targetPos;
      coin.position = teleportingGateComponent.position.clone();
      coin.scale = Vector2.zero();
      pendingSpawns.add(coin);

      coins.add(coin);
      add(coin);
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
        _resetPositions(loseLife: true, respawnFromHole: true);
      }
      return;
    }

    if (isSuckingToGate) {
      Vector2 gateCenter = teleportingGateComponent.position;

      // Move ball towards center
      double dx = gateCenter.x - ballPos2D.x;
      double dy = gateCenter.y - ballPos2D.y;

      // Suck ball into the center quickly
      ballPos2D.x += dx * dt * 5;
      ballPos2D.y += dy * dt * 5;

      // Keep ball in perfect shape while shrinking into the gate
      squashX = 1.0;
      squashY = 1.0;
      ballScale -= dt * 1.5; // shrink rapidly

      if (ballScale <= 0) {
        ballScale = 0;
        teleportingGateComponent.isClosing = true; // Tell the gate to close

        if (teleportingGateComponent.isClosed) {
          // wait for gate to close
          isBoardHidden = true;
          if (!isLevelCompleteOverlayShown) {
            isLevelCompleteOverlayShown = true;
            showVictoryOverlay.value = true;
            pauseEngine();
          }
        }
      }
      return; // Skip normal physics
    }

    // Check if reached top area to trigger gate snap
    if (!isFalling &&
        !isFreeFalling &&
        !isSpawningLevel &&
        !isRespawningFromHole &&
        !isLevelCompleteOverlayShown) {
      Vector2 gateCenter = teleportingGateComponent.position;
      if (ballPos2D.distanceTo(gateCenter) < 40 ||
          (ballPos2D.y < gateCenter.y + 10 &&
              (ballPos2D.x - gateCenter.x).abs() < 50)) {
        isSuckingToGate = true;
        HapticFeedback.heavyImpact();
        try {
          FlameAudio.play('win.wav', volume: 1.0);
        } catch (_) {}
        return;
      }
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

    // Shield Timer
    if (shieldTimer > 0) {
      shieldTimer -= dt;
      if (shieldTimer < 0) shieldTimer = 0.0;
      shieldTimerNotifier.value = shieldTimer;
    } else {
      if (shieldTimerNotifier.value != 0.0) shieldTimerNotifier.value = 0.0;
    }

    // Magnet Timer
    if (magnetTimer > 0) {
      magnetTimer -= dt;
      if (magnetTimer < 0) magnetTimer = 0.0;
      magnetTimerNotifier.value = magnetTimer;
    } else {
      if (magnetTimerNotifier.value != 0.0) magnetTimerNotifier.value = 0.0;
    }

    double maxY = size.y - 80.0;
    double minY = 10.0;

    if (barResetTimer > 0) {
      barResetTimer -= dt;
      if (barResetTimer <= 0) {
        barResetTimer = 0.0;
        leftY = maxY;
        rightY = maxY;
      } else {
        double duration = isRespawningFromHole ? 1.5 : 0.8;
        double p = 1.0 - (barResetTimer / duration).clamp(0.0, 1.0);
        double curved = Curves.easeInOut.transform(p);
        leftY = initialLeftY + (maxY - initialLeftY) * curved;
        rightY = initialRightY + (maxY - initialRightY) * curved;
      }
    } else if (!isSpawningLevel && !isRespawningFromHole) {
      double speed = timeStopNotifier.value > 0
          ? 150.0
          : 250.0; // Slower for suspense, but enough to reach the top!
      double maxDiff = 120.0;

      double newLeftY = leftY + leftJoystickValue * speed * dt;
      newLeftY = newLeftY.clamp(rightY - maxDiff, rightY + maxDiff);
      newLeftY = newLeftY.clamp(minY, maxY);

      double newRightY = rightY + rightJoystickValue * speed * dt;
      newRightY = newRightY.clamp(leftY - maxDiff, leftY + maxDiff);
      newRightY = newRightY.clamp(minY, maxY);

      leftY = newLeftY;
      rightY = newRightY;
    }

    Vector2 leftPoint = Vector2(barPadding, leftY);
    Vector2 rightPoint = Vector2(size.x - barPadding, rightY);
    Vector2 direction = (rightPoint - leftPoint).normalized();
    double barLength = (rightPoint - leftPoint).length;
    Vector2 normal = Vector2(direction.y, -direction.x);

    if (isSpawningLevel) {
      if (spawnTimer > 0) {
        spawnTimer -= dt;
        if (spawnTimer > 1.0 &&
            spawnTimer <= 1.5 &&
            !teleportingGateComponent.isOpening) {
          teleportingGateComponent.open();
        }

        if (spawnTimer > 1.0) {
          // Ball scaling up out of nothingness
          double t = (1.5 - spawnTimer) / 0.5; // 0 to 1
          ballScale = t;
          ballPos2D = teleportingGateComponent.position.clone();
        } else {
          ballScale = 1.0;
          // Phase 1: Manual free fall
          freeFallVelocity.y += 980.0 * dt;
          double prevY = ballPos2D.y;
          ballPos2D += freeFallVelocity * dt;
          double newY = ballPos2D.y;

          double t = (ballPos2D.x - barPadding) / (size.x - 2 * barPadding);
          double barYAtX = leftY + (rightY - leftY) * t;
          double barSurface = barYAtX - (ballRadius + 6.0);

          if (newY >= barSurface - 5.0) {
            // Hit the bar!
            spawnTimer = 0; // Trigger Phase 2
            ballP = t * barLength;
            bounceTimer = 0.4;
            ballVelocity = 0.0;
            ballPos2D =
                leftPoint + direction * ballP + normal * (ballRadius + 6.0);
            HapticFeedback.heavyImpact();
            try {
              FlameAudio.play('tick.wav');
            } catch (_) {}
          }
        }
      } else {
        // Run bounce and squish physics while waiting for the game to launch
        if (bounceTimer > 0) {
          bounceTimer -= dt;
          if (bounceTimer < 0) bounceTimer = 0.0;

          double t = 1.0 - (bounceTimer / 0.4); // goes from 0.0 to 1.0
          if (t < 0.25) {
            // Impact squish
            double sq = t / 0.25;
            squashY = 1.0 - (0.4 * sq);
            squashX = 1.0 + (0.4 * sq);
            ballPos2D =
                leftPoint +
                direction * ballP +
                normal * (ballRadius * squashY + 6.0);
          } else if (t < 0.75) {
            // Bounce up
            double sq = (t - 0.25) / 0.5;
            double bounceHeight = sin(sq * pi) * 20.0; // Hop 20 pixels
            squashY = 1.0 + (0.2 * sin(sq * pi));
            squashX = 1.0 - (0.2 * sin(sq * pi));
            ballPos2D =
                leftPoint +
                direction * ballP +
                normal * (ballRadius * squashY + 6.0 + bounceHeight);
          } else {
            // Settle squash
            double sq = (t - 0.75) / 0.25;
            double settle = sin(sq * pi);
            squashY = 1.0 - (0.2 * settle);
            squashX = 1.0 + (0.2 * settle);
            ballPos2D =
                leftPoint +
                direction * ballP +
                normal * (ballRadius * squashY + 6.0);
          }
        } else {
          squashX = 1.0;
          squashY = 1.0;
          ballPos2D =
              leftPoint + direction * ballP + normal * (ballRadius + 6.0);
        }

        // Phase 2: Cascading Spit
        if (pendingSpawns.isNotEmpty) {
          itemSpawnTimer -= dt;
          if (itemSpawnTimer <= 0) {
            itemSpawnTimer = spawnInterval;
            final item = pendingSpawns.removeAt(0);

            teleportingGateComponent.spit();

            final target = targetPositions[item]!;
            item.add(
              MoveToEffect(
                target,
                EffectController(duration: 0.55, curve: Curves.easeOutBack),
              ),
            );
            item.add(
              ScaleEffect.to(
                Vector2.all(1.0),
                EffectController(duration: 0.55, curve: Curves.easeOutBack),
              ),
            );
          }
        } else {
          // Phase 3: Wait for last item to land
          itemSpawnTimer -= dt;
          if (itemSpawnTimer <= -0.55) {
            isSpawningLevel = false; // Gameplay Launch!
          }
        }
      }
      return;
    }

    if (isRespawningFromHole && activeHole != null) {
      respawnTimer -= dt;
      if (respawnTimer <= 0) {
        isRespawningFromHole = false;
        activeHole = null;
        ballScale = 1.0;
        bounceTimer = 0.4; // Trigger bouncy landing!
        ballPos2D = leftPoint + direction * ballP + normal * (ballRadius + 6.0);
        HapticFeedback.heavyImpact();
        try {
          FlameAudio.play('tick.wav');
        } catch (_) {}
      } else {
        double progress = 1.0 - (respawnTimer / 1.5);
        if (progress < 0.4) {
          double p = progress / 0.4;
          ballPos2D = activeHole!.position.clone();
          ballScale = p;
        } else {
          double p = (progress - 0.4) / 0.6;
          double curvedP = Curves.easeIn.transform(p);
          Vector2 targetPos =
              leftPoint + direction * ballP + normal * (ballRadius + 6.0);
          ballPos2D =
              activeHole!.position +
              (targetPos - activeHole!.position) * curvedP;
          ballScale = 1.0;
        }
        return; // Skip normal physics
      }
    }

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

        // If ball falls through the surface or the bar is moved up to catch it
        if (newY >= barSurface - 5.0) {
          isFreeFalling = false;
          timeStopTimer = 0.0;
          timeStopNotifier.value = 0.0;
          ballP = t * barLength;
          ballVelocity = freeFallVelocity.x; // Keep x-momentum
          bounceTimer = 0.4; // Trigger bouncy landing!
          ballPos2D =
              leftPoint + direction * ballP + normal * (ballRadius + 6.0);
          HapticFeedback.heavyImpact();
          try {
            FlameAudio.play('tick.wav');
          } catch (_) {}

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
        if (isShieldActive) {
          // Bounce off edge
          ballVelocity = -ballVelocity * 0.6;
          ballP = ballP.clamp(0.0, barLength);
          bounceTimer = 0.4; // Trigger bouncy hop!
          HapticFeedback.lightImpact();
        } else {
          isFalling = true;
          HapticFeedback.heavyImpact();
          try {
            FlameAudio.play('fall.wav');
          } catch (_) {}
          freeFallVelocity = direction * ballVelocity;
        }
      } else {
        // Calculate standard rotation based on ball position and scale
        fallRotation = ballP / ballRadius;

        if (bounceTimer > 0) {
          bounceTimer -= dt;
          if (bounceTimer < 0) bounceTimer = 0.0;

          double t = 1.0 - (bounceTimer / 0.4); // goes from 0.0 to 1.0
          if (t < 0.25) {
            // 0.0 to 0.1s: Impact squish
            double sq = t / 0.25; // 0 to 1
            squashY = 1.0 - (0.4 * sq);
            squashX = 1.0 + (0.4 * sq);
            ballPos2D =
                leftPoint +
                direction * ballP +
                normal * (ballRadius * squashY + 6.0);
          } else if (t < 0.75) {
            // 0.1s to 0.3s: Bounce up
            double sq = (t - 0.25) / 0.5; // 0 to 1
            double bounceHeight = sin(sq * pi) * 20.0; // Hop 20 pixels
            squashY = 1.0 + (0.2 * sin(sq * pi));
            squashX = 1.0 - (0.2 * sin(sq * pi));
            ballPos2D =
                leftPoint +
                direction * ballP +
                normal * (ballRadius * squashY + 6.0 + bounceHeight);
          } else {
            // 0.3s to 0.4s: Settle squash
            double sq = (t - 0.75) / 0.25; // 0 to 1
            double settle = sin(sq * pi);
            squashY = 1.0 - (0.2 * settle);
            squashX = 1.0 + (0.2 * settle);
            ballPos2D =
                leftPoint +
                direction * ballP +
                normal * (ballRadius * squashY + 6.0);
          }
        } else if (!isSpawningLevel &&
            !isRespawningFromHole &&
            !isFreeFalling &&
            !isFalling &&
            !isFallingInHole) {
          squashX = 1.0;
          squashY = 1.0;
          ballPos2D =
              leftPoint + direction * ballP + normal * (ballRadius + 6.0);
        }

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
              try {
                FlameAudio.play('hole.wav');
              } catch (_) {}
              break;
            }
          }
        }

        if (isFreeFalling)
          return; // Skip other collisions if we just teleported

        // Check hole collisions
        for (final hole in holes) {
          double dist = ballPos2D.distanceTo(hole.position);
          double lethalDist = (hole.size.x / 2) - 2.0;

          if (dist < lethalDist) {
            if (isShieldActive) {
              // Repel ball along the bar
              double dot = (ballPos2D - hole.position).dot(direction);
              ballVelocity = (dot > 0 ? 1 : -1) * 200.0;
              HapticFeedback.lightImpact();
              continue;
            }

            isFallingInHole = true;
            activeHole = hole;
            HapticFeedback.heavyImpact();
            try {
              FlameAudio.play('hole.wav');
            } catch (_) {}
            fallTarget = hole.position.clone();
            break;
          } else if (hole.isSuckingHole && dist < hole.suckRadius) {
            if (isShieldActive) {
              continue; // Immune to wind/sucking
            }
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

            bounceTimer = 0.4; // Trigger bouncy hop!

            // Update ball pos immediately to reflect the un-sticking
            ballPos2D =
                leftPoint + direction * ballP + normal * (ballRadius + 6.0);
          }
        }

        // Check star collisions
        for (final star in stars) {
          if (!star.isCollected) {
            Vector2 starPos = star.position;
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
            Vector2 heartPos = heart.position;
            if (ballPos2D.distanceTo(heartPos) < ballRadius + 15.0) {
              heart.isCollected = true;
              currentLives.value++;
              HapticFeedback.lightImpact();
              try {
                FlameAudio.play(
                  'star.wav',
                ); // We can reuse star sound or add life.wav later
              } catch (_) {}
            }
          }
        }

        // Check coin collisions & magnet logic
        for (final coin in coins) {
          if (!coin.isCollected) {
            Vector2 coinPos = coin.position.clone();

            if (magnetTimer > 0) {
              double pullSpeed = 400.0; // Magnet pull speed in pixels/sec
              Vector2 dir = (ballPos2D - coinPos);
              double dist = dir.length;
              if (dist < 150.0 && dist > 5.0) {
                // Add a tiny deadzone to prevent jitter
                dir.normalize();
                coinPos += dir * pullSpeed * dt;

                // Update fractionalPosition so it persists in the world
                coin.fractionalPosition = Vector2(
                  coinPos.x / size.x,
                  (coinPos.y - 120.0) / (size.y - 320.0),
                );
                coin.position = coinPos;
              }
            }

            if (ballPos2D.distanceTo(coinPos) < ballRadius + 15.0) {
              coin.isCollected = true;
              currentScore.value += 50; // Each coin is worth 50
              HapticFeedback.lightImpact();
              try {
                FlameAudio.play('star.wav'); // Reuse star sound for now
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
