import 'dart:isolate';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/core/data/models.dart';

import 'package:balanco_game/features/game/components/hole_component.dart';
import 'package:balanco_game/features/game/components/bar_component.dart';
import 'package:balanco_game/features/game/components/ball_component.dart';
import 'package:balanco_game/features/game/components/star_component.dart';
import 'package:balanco_game/features/game/components/teleporting_gate_component.dart';
import 'package:balanco_game/features/game/components/bumper_component.dart';
import 'package:balanco_game/features/game/components/teleporter_component.dart';
import 'package:balanco_game/features/game/components/confetti_component.dart';
import 'package:balanco_game/features/game/components/heart_component.dart';
import 'package:balanco_game/features/game/components/items/multi_ball_item.dart';
import 'package:balanco_game/features/game/components/magnet_component.dart';

import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/features/game/level_generator.dart';
import 'package:balanco_game/core/data/app_settings.dart';

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

  // Level timer
  double get maxLevelTimer => currentLevel.value >= 10 ? 360.0 : 120.0;
  final ValueNotifier<double> levelTimerNotifier = ValueNotifier<double>(120.0);
  double levelTimer = 120.0;
  bool isLevelTimerActive = false;

  // Magnet state
  final ValueNotifier<int> remainingMagnets = ValueNotifier<int>(3);
  final ValueNotifier<double> magnetTimerNotifier = ValueNotifier<double>(0.0);
  double magnetTimer = 0.0;
  bool get isMagnetActive => magnetTimer > 0;

  double leftJoystickValue = 0.0;
  double rightJoystickValue = 0.0;

  double leftY = 0.0;
  double rightY = 0.0;

  List<BallData> activeBalls = [];
  List<BallComponent> activeBallComponents = [];
  double timeStopTimer = 0.0;
  final ValueNotifier<double> timeStopNotifier = ValueNotifier<double>(0.0);

  bool isBoardHidden = false;
  final ValueNotifier<bool> showVictoryOverlay = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showGameOverOverlay = ValueNotifier<bool>(false);
  bool isLevelCompleteOverlayShown = false;
  bool isSpawningLevel = true;
  List<PositionComponent> pendingSpawns = [];
  Map<PositionComponent, Vector2> targetPositions = {};
  double itemSpawnTimer = 0.0;
  final double spawnInterval = 0.10;

  double barResetTimer = 0.0;
  double initialLeftY = 0.0;
  double initialRightY = 0.0;

  final double barPadding = 20.0;
  final double ballRadius = 14.0;

  late BarComponent barComponent;

  final List<HoleComponent> holes = [];
  final List<StarComponent> stars = [];
  final List<HeartComponent> hearts = [];
  final List<BumperComponent> bumpers = [];
  final List<TeleporterComponent> teleporters = [];
  List<MultiBallItem> multiBallItems = [];
  List<MagnetComponent> magnets = [];
  TeleporterComponent? activeExitTeleporter;
  TeleportingGateComponent teleportingGateComponent = TeleportingGateComponent()
    ..priority = 0;

  final PositionComponent levelContainer = PositionComponent();
  double cameraOffsetY = 0.0;
  final ValueNotifier<double> cameraOffsetYNotifier = ValueNotifier<double>(
    0.0,
  );
  double get levelHeight => size.y * (currentLevel.value >= 10 ? 3.0 : 1.0);

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
    showGameOverOverlay.value = false;

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
    showVictoryOverlay.value = false;
    showGameOverOverlay.value = false;
    isLevelCompleteOverlayShown = false;

    final profile = await DatabaseHelper.instance.getPlayerProfile();
    int completedLevel = currentLevel.value;
    int starsEarned = currentPoints.value;

    final existingProgress = await DatabaseHelper.instance.getLevelProgress(
      completedLevel,
    );
    int previousStars = existingProgress?.stars ?? 0;

    if (starsEarned > previousStars) {
      await DatabaseHelper.instance.saveLevelProgress(
        LevelProgress(
          levelId: completedLevel,
          stars: starsEarned,
          isUnlocked: true,
        ),
      );
    }

    if (completedLevel + 1 > profile.highestLevel) {
      await DatabaseHelper.instance.updatePlayerProfile(
        profile.copyWith(highestLevel: completedLevel + 1),
      );
    }

    currentLevel.value++;
    restartCurrentLevel();
  }

  void restartLevelAfterWin() {
    showVictoryOverlay.value = false;
    showGameOverOverlay.value = false;
    isLevelCompleteOverlayShown = false;
    restartCurrentLevel();
  }

  void _resetPositions({
    bool loseLife = false,
    bool respawnFromHole = false,
    HoleComponent? prevHole,
  }) {
    isBoardHidden = false;
    isLevelCompleteOverlayShown = false;
    teleportingGateComponent.reset();

    if (!loseLife && !respawnFromHole) {
      levelTimer = maxLevelTimer;
      levelTimerNotifier.value = maxLevelTimer;
      isLevelTimerActive = false;
    }
    timeStopTimer = 0.0;
    timeStopNotifier.value = 0.0;
    activeExitTeleporter = null;

    if (!loseLife) {
      for (final t in teleporters) {
        t.isClosed = false;
      }
      for (final star in stars) {
        star.reset();
      }
      for (final heart in hearts) {
        heart.reset();
      }
      for (final mb in multiBallItems) {
        mb.isCollected = false;
        mb.scale = isSpawningLevel ? Vector2.zero() : Vector2.all(1.0);
        if (mb.parent == null) levelContainer.add(mb);
      }
      for (final mag in magnets) {
        mag.reset();
      }
    }

    if (loseLife) {
      currentLives.value--;
      if (currentLives.value <= 0) {
        HapticFeedback.vibrate();
        try {
          AppSettings.playSound('gameover.wav');
        } catch (_) {}
        pauseEngine();
        showGameOverOverlay.value = true;
        return; // Don't reset position yet
      }
    }

    if (size.x > 0 && size.y > 0) {
      if (leftY != 0.0 && size.y > 0 && !isSpawningLevel) {
        initialLeftY = leftY;
        initialRightY = rightY;
        barResetTimer = 0.8; // Straighten bar consistently in 0.8s
      } else {
        barResetTimer = 0.0;
        leftY = levelHeight - 70.0;
        rightY = levelHeight - 70.0;
      }

      // Clear balls
      activeBalls.clear();
      for (var bc in activeBallComponents) {
        bc.removeFromParent();
      }
      activeBallComponents.clear();

      // Create main ball
      BallData mainBall = BallData();
      mainBall.p = (size.x - 2 * barPadding) / 2.0;

      if (isSpawningLevel) {
        teleportingGateComponent.startClosed();
        mainBall.pos2D = teleportingGateComponent.position.clone();
        mainBall.scale = 0.0;
        mainBall.spawnTimer = 1.5;
        itemSpawnTimer = 0.5;
        cameraOffsetY = 0.0;
      } else if (respawnFromHole && prevHole != null) {
        mainBall.activeHole = prevHole;
        mainBall.isRespawningFromHole = true;
        isLevelTimerActive = false; // Pause the timer during respawn
        mainBall.respawnTimer = 1.6;
        mainBall.pos2D = mainBall.activeHole!.position.clone();
        mainBall.scale = 0.0;
        mainBall.p = (size.x - 2 * barPadding) / 2.0;
      } else {
        mainBall.isRespawningFromEdge = true;
        isLevelTimerActive = false;
        mainBall.respawnTimer = 1.6;
        mainBall.pos2D = teleportingGateComponent.position.clone();
        mainBall.scale = 0.0;
        mainBall.p = (size.x - 2 * barPadding) / 2.0;
        mainBall.isFreeFalling = false;
      }

      activeBalls.add(mainBall);
      BallComponent bc = BallComponent(mainBall)..priority = 20;
      activeBallComponents.add(bc);
      levelContainer.add(bc);

      leftJoystickValue = 0.0;
      rightJoystickValue = 0.0;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    teleportingGateComponent.position = Vector2(size.x / 2.0, 70.0);
    if (leftY == 0.0 && rightY == 0.0) {
      Future.microtask(() => _resetPositions());
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

    add(levelContainer);

    levelContainer.add(teleportingGateComponent);
    levelContainer.add(barComponent);

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
    for (final mb in multiBallItems) {
      if (mb.parent != null) mb.removeFromParent();
    }
    multiBallItems.clear();
    for (final mag in magnets) {
      if (mag.parent != null) mag.removeFromParent();
    }
    magnets.clear();

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
        120.0 + hData.position.y * (levelHeight - 320.0),
      );
      targetPositions[hole] = targetPos;
      hole.position = teleportingGateComponent.position.clone();
      hole.scale = Vector2.zero();
      pendingSpawns.add(hole);

      holes.add(hole);
      levelContainer.add(hole);
    }

    for (final tData in data.teleporters) {
      final teleporter = TeleporterComponent(
        tData.position,
        tData.size,
        tData.pairId,
      )..priority = 1;

      final targetPos = Vector2(
        tData.position.x * size.x,
        120.0 + tData.position.y * (levelHeight - 320.0),
      );
      targetPositions[teleporter] = targetPos;
      teleporter.position = teleportingGateComponent.position.clone();
      teleporter.scale = Vector2.zero();
      pendingSpawns.add(teleporter);

      teleporters.add(teleporter);
      levelContainer.add(teleporter);
    }

    for (final bData in data.bumpers) {
      final bumper = BumperComponent(bData.position, bData.size)..priority = 2;

      final targetPos = Vector2(
        bData.position.x * size.x,
        120.0 + bData.position.y * (levelHeight - 320.0),
      );
      targetPositions[bumper] = targetPos;
      bumper.position = teleportingGateComponent.position.clone();
      bumper.scale = Vector2.zero();
      pendingSpawns.add(bumper);

      bumpers.add(bumper);
      levelContainer.add(bumper);
    }

    for (final sPos in data.stars) {
      final star = StarComponent(sPos)..priority = 5;

      final targetPos = Vector2(
        sPos.x * size.x,
        120.0 + sPos.y * (levelHeight - 320.0),
      );
      targetPositions[star] = targetPos;
      star.position = teleportingGateComponent.position.clone();
      star.scale = Vector2.zero();
      pendingSpawns.add(star);

      stars.add(star);
      levelContainer.add(star);
    }

    for (final hPos in data.hearts) {
      final heart = HeartComponent(hPos)..priority = 5;

      final targetPos = Vector2(
        hPos.x * size.x,
        120.0 + hPos.y * (levelHeight - 320.0),
      );
      targetPositions[heart] = targetPos;
      heart.position = teleportingGateComponent.position.clone();
      heart.scale = Vector2.zero();
      pendingSpawns.add(heart);

      hearts.add(heart);
      levelContainer.add(heart);
    }

    for (final mbPos in data.multiBalls) {
      final mb = MultiBallItem(mbPos)..priority = 5;

      final targetPos = Vector2(
        mbPos.x * size.x,
        120.0 + mbPos.y * (levelHeight - 320.0),
      );
      targetPositions[mb] = targetPos;
      mb.position = teleportingGateComponent.position.clone();
      mb.scale = Vector2.zero();
      pendingSpawns.add(mb);

      multiBallItems.add(mb);
      levelContainer.add(mb);
    }

    for (final magPos in data.magnets) {
      final mag = MagnetComponent(magPos)..priority = 5;

      final targetPos = Vector2(
        magPos.x * size.x,
        120.0 + magPos.y * (levelHeight - 320.0),
      );
      targetPositions[mag] = targetPos;
      mag.position = teleportingGateComponent.position.clone();
      mag.scale = Vector2.zero();
      pendingSpawns.add(mag);

      magnets.add(mag);
      levelContainer.add(mag);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (size.x == 0 || size.y == 0) return;

    if (isLevelTimerActive &&
        activeBalls.any((b) => !b.isFalling) &&
        !isBoardHidden) {
      double previousTimer = levelTimer;
      levelTimer -= dt;

      int prevFloor = previousTimer.floor();
      int currFloor = levelTimer.floor();
      if (currFloor == 10 && prevFloor > 10) {
        try {
          AppSettings.playSound('clock-ticking.wav');
        } catch (_) {}
      }

      if (levelTimer <= 0) {
        levelTimer = 0.0;
        isLevelTimerActive = false;
        currentLives.value = 0; // force game over
        _resetPositions(loseLife: true);
        return;
      }
      levelTimerNotifier.value = levelTimer;
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

    double maxY = levelHeight - 70.0;
    double minY = 10.0;

    if (barResetTimer > 0) {
      barResetTimer -= dt;
      if (barResetTimer <= 0) {
        barResetTimer = 0.0;
        leftY = maxY;
        rightY = maxY;
      } else {
        double duration = 0.8;
        double p = 1.0 - (barResetTimer / duration).clamp(0.0, 1.0);
        double curved = Curves.easeInOut.transform(p);
        leftY = initialLeftY + (maxY - initialLeftY) * curved;
        rightY = initialRightY + (maxY - initialRightY) * curved;
      }
    } else {
      bool anyBallOnBar = activeBalls.any((b) =>
          !b.isDead &&
          !b.isFalling &&
          !b.isFreeFalling &&
          !b.isFallingInHole &&
          !b.isRespawningFromHole &&
          !b.isRespawningFromEdge &&
          b.spawnTimer <= 0);

      if (anyBallOnBar) {
        // Base speed balanced so default (1.0) is not too high and not too low
        double speed = timeStopNotifier.value > 0
            ? 150.0 * AppSettings.joystickSensitivity.value
            : 250.0 * AppSettings.joystickSensitivity.value;
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
    }

    Vector2 leftPoint = Vector2(barPadding, leftY);
    Vector2 rightPoint = Vector2(size.x - barPadding, rightY);
    Vector2 direction = (rightPoint - leftPoint).normalized();
    double barLength = (rightPoint - leftPoint).length;
    Vector2 normal = Vector2(direction.y, -direction.x);

    if (isSpawningLevel) {
      if (pendingSpawns.isNotEmpty || itemSpawnTimer > -0.55) {
        // Phase 1: Spit all items
        if (!teleportingGateComponent.isOpening &&
            teleportingGateComponent.isClosed) {
          teleportingGateComponent.open();
        }

        itemSpawnTimer -= dt;
        if (itemSpawnTimer <= 0 && pendingSpawns.isNotEmpty) {
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
        // Phase 2: Drop the balls
        for (var ball in activeBalls) {
          _updateBallPhysics(
            ball,
            dt,
            leftPoint,
            rightPoint,
            direction,
            barLength,
            normal,
          );
        }
        _checkBallToBallCollisions(direction);
      }
    } else {
      HoleComponent? prevHole;
      for (var ball in activeBalls.toList()) {
        if (ball.isDead) continue;
        _updateBallPhysics(
          ball,
          dt,
          leftPoint,
          rightPoint,
          direction,
          barLength,
          normal,
        );
        if (ball.isDead && ball.activeHole != null) {
          prevHole = ball.activeHole;
        }
      }
      _checkBallToBallCollisions(direction);

      // Clean up dead balls
      activeBalls.removeWhere((b) => b.isDead);
      for (var bc in activeBallComponents.toList()) {
        if (!activeBalls.contains(bc.ballData)) {
          bc.removeFromParent();
          activeBallComponents.remove(bc);
        }
      }

      if (activeBalls.isEmpty) {
        _resetPositions(
          loseLife: true,
          respawnFromHole: prevHole != null,
          prevHole: prevHole,
        );
      }
    }

    // --- Camera Logic ---
    if (size.y > 0) {
      double targetCameraY = 0.0;
      if (isSpawningLevel) {
        double mainBallY = activeBalls.isNotEmpty
            ? activeBalls.first.pos2D.y
            : size.y / 2;
        targetCameraY = (mainBallY - size.y / 2).clamp(
          0.0,
          max(0.0, levelHeight - size.y),
        );
      } else {
        targetCameraY = ((leftY + rightY) / 2) - size.y + 150.0;
        targetCameraY = targetCameraY.clamp(
          0.0,
          max(0.0, levelHeight - size.y),
        );
      }
      cameraOffsetY += (targetCameraY - cameraOffsetY) * dt * 5.0;
      levelContainer.position.y = -cameraOffsetY;
      cameraOffsetYNotifier.value = cameraOffsetY;
    }
  }

  void _updateBallPhysics(
    BallData ball,
    double dt,
    Vector2 leftPoint,
    Vector2 rightPoint,
    Vector2 direction,
    double barLength,
    Vector2 normal,
  ) {
    if (ball.isFallingInHole) {
      ball.fallRotation += dt * 15.0; // Rapid spin
      ball.scale -= dt * 1.0; // Slower fall (takes 1 second)
      ball.pos2D.lerp(ball.fallTarget, dt * 5.0); // Slower pull to center

      if (ball.scale <= -0.5) {
        // Wait half a second after ball vanishes for teeth to close
        ball.isDead = true;
      }
      return;
    }

    if (ball.isSuckingToGate) {
      Vector2 gateCenter = teleportingGateComponent.position;
      double dx = gateCenter.x - ball.pos2D.x;
      double dy = gateCenter.y - ball.pos2D.y;

      ball.pos2D.x += dx * dt * 5;
      ball.pos2D.y += dy * dt * 5;

      ball.squashX = 1.0;
      ball.squashY = 1.0;
      ball.scale -= dt * 1.5;

      if (ball.scale <= 0) {
        ball.scale = 0;
        teleportingGateComponent.isClosing = true;

        if (teleportingGateComponent.isClosed) {
          isBoardHidden = true;
          if (!isLevelCompleteOverlayShown) {
            isLevelCompleteOverlayShown = true;
            showVictoryOverlay.value = true;
            pauseEngine();
          }
        }
      }
      return;
    }

    if (!ball.isFreeFalling &&
        !ball.isFalling &&
        !isSpawningLevel &&
        !ball.isRespawningFromHole &&
        !ball.isRespawningFromEdge &&
        !isLevelCompleteOverlayShown) {
      Vector2 gateCenter = teleportingGateComponent.position;
      if (ball.pos2D.distanceTo(gateCenter) < 40) {
        ball.isSuckingToGate = true;
        ball.isFalling = false;
        HapticFeedback.heavyImpact();
        try {
          AppSettings.playSound('win.wav', volume: 1.0);
        } catch (_) {}
        return;
      }
    }

    if (isSpawningLevel) {
      if (ball.spawnTimer > 0) {
        bool isBarAtBottom =
            leftY >= (levelHeight - 75.0) && rightY >= (levelHeight - 75.0);

        if (ball.spawnTimer - dt <= 1.0 && !isBarAtBottom) {
          ball.spawnTimer = 1.0001;
        } else {
          ball.spawnTimer -= dt;
        }

        if (ball.spawnTimer > 1.0 &&
            ball.spawnTimer <= 1.5 &&
            !teleportingGateComponent.isOpening) {
          teleportingGateComponent.open();
        }

        if (ball.spawnTimer > 1.0) {
          double t = (1.5 - ball.spawnTimer) / 0.5;
          ball.scale = t;
          ball.pos2D = teleportingGateComponent.position.clone();
        } else {
          ball.scale = 1.0;
          ball.freeFallVelocity.y += 980.0 * dt;
          ball.pos2D += ball.freeFallVelocity * dt;
          double newY = ball.pos2D.y;

          double t = (ball.pos2D.x - barPadding) / (size.x - 2 * barPadding);
          double barYAtX = leftY + (rightY - leftY) * t;
          double barSurface = barYAtX - (ballRadius + 6.0);

          if (newY >= barSurface - 5.0) {
            ball.spawnTimer = 0;
            ball.p = t * barLength;
            ball.bounceTimer = 0.4;
            ball.velocity = 0.0;
            ball.freeFallVelocity.setZero();
            ball.pos2D =
                leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
            HapticFeedback.heavyImpact();
            try {
              AppSettings.playSound('tick.wav');
            } catch (_) {}
          }
        }
      } else {
        if (ball.bounceTimer > 0) {
          ball.bounceTimer -= dt;
          if (ball.bounceTimer < 0) ball.bounceTimer = 0.0;

          double t = 1.0 - (ball.bounceTimer / 0.4);
          if (t < 0.25) {
            double sq = t / 0.25;
            ball.squashY = 1.0 - (0.4 * sq);
            ball.squashX = 1.0 + (0.4 * sq);
            ball.pos2D =
                leftPoint +
                direction * ball.p +
                normal * (ballRadius * ball.squashY + 6.0);
          } else if (t < 0.75) {
            double sq = (t - 0.25) / 0.5;
            double bounceHeight = sin(sq * pi) * 20.0;
            ball.squashY = 1.0 + (0.2 * sin(sq * pi));
            ball.squashX = 1.0 - (0.2 * sin(sq * pi));
            ball.pos2D =
                leftPoint +
                direction * ball.p +
                normal * (ballRadius * ball.squashY + 6.0 + bounceHeight);
          } else {
            double sq = (t - 0.75) / 0.25;
            double settle = sin(sq * pi);
            ball.squashY = 1.0 - (0.2 * settle);
            ball.squashX = 1.0 + (0.2 * settle);
            ball.pos2D =
                leftPoint +
                direction * ball.p +
                normal * (ballRadius * ball.squashY + 6.0);
          }
        } else {
          ball.squashX = 1.0;
          ball.squashY = 1.0;
          ball.pos2D =
              leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
          isSpawningLevel = false; // Gameplay Launch!
          isLevelTimerActive = true;
        }
      }
      return;
    }

    if ((ball.isRespawningFromHole && ball.activeHole != null) ||
        ball.isRespawningFromEdge) {
      if (ball.respawnTimer > 0) {
        bool isBarAtBottom =
            leftY >= (levelHeight - 75.0) && rightY >= (levelHeight - 75.0);

        if (ball.respawnTimer - dt <= 0.8 && !isBarAtBottom) {
          ball.respawnTimer = 0.8001;
        } else {
          ball.respawnTimer -= dt;
        }

        if (ball.respawnTimer <= 0) {
          ball.respawnTimer = 0.0;
          ball.scale = 1.0;
          // Trigger the bouncy squish animation when landing!
          ball.bounceTimer = 0.4;
          ball.freeFallVelocity.setZero();
          ball.pos2D =
              leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
          HapticFeedback.heavyImpact();
          try {
            AppSettings.playSound('tick.wav');
          } catch (_) {}

          ball.squashX = 1.0;
          ball.squashY = 1.0;
          ball.isRespawningFromHole = false;
          ball.isRespawningFromEdge = false;
          ball.activeHole = null;
          isLevelTimerActive = true;
        } else {
          double progress = 1.0 - (ball.respawnTimer / 1.6);
          if (progress < 0.5) {
            double p = progress / 0.5;
            ball.pos2D = ball.isRespawningFromEdge
                ? teleportingGateComponent.position.clone()
                : ball.activeHole!.position.clone();
            ball.scale = p;
          } else {
            double p = (progress - 0.5) / 0.5;
            double curvedP = Curves.easeIn.transform(p);
            Vector2 targetPos =
                leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
            Vector2 startPos = ball.isRespawningFromEdge
                ? teleportingGateComponent.position.clone()
                : ball.activeHole!.position.clone();
            ball.pos2D = startPos + (targetPos - startPos) * curvedP;
            ball.scale = 1.0;
          }
        }
      }
      return;
    }

    if (ball.isFreeFalling) {
      double gravity = timeStopNotifier.value > 0 ? 15.0 : 980.0;
      ball.freeFallVelocity.y += gravity * dt;

      ball.pos2D += ball.freeFallVelocity * dt;
      double newY = ball.pos2D.y;

      if (ball.pos2D.x > barPadding && ball.pos2D.x < size.x - barPadding) {
        double t = (ball.pos2D.x - barPadding) / (size.x - 2 * barPadding);
        double barYAtX = leftY + (rightY - leftY) * t;
        double barSurface = barYAtX - (ballRadius + 6.0);

        if (newY >= barSurface - 5.0) {
          ball.isFreeFalling = false;
          timeStopTimer = 0.0;
          timeStopNotifier.value = 0.0;
          ball.p = t * barLength;
          ball.velocity = ball.freeFallVelocity.x;
          ball.freeFallVelocity.setZero();
          ball.bounceTimer = 0.4;
          ball.pos2D =
              leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
          HapticFeedback.heavyImpact();
          try {
            AppSettings.playSound('tick.wav');
          } catch (_) {}

          if (ball.activeExitTeleporter != null) {
            ball.activeExitTeleporter!.isClosed = true;
            ball.activeExitTeleporter = null;
          }
        }
      }

      if (ball.pos2D.y > levelHeight + 100) {
        ball.isDead = true;
      }
    } else if (!ball.isFalling) {
      double alpha = atan2(
        rightPoint.y - leftPoint.y,
        rightPoint.x - leftPoint.x,
      );
      double gravity = 980.0;
      double accel = gravity * sin(alpha);

      ball.velocity += accel * dt;
      ball.velocity *= 0.99;

      ball.p += ball.velocity * dt;

      if (ball.p < 0 || ball.p > barLength) {
        if (isShieldActive) {
          ball.velocity = -ball.velocity * 0.6;
          ball.p = ball.p.clamp(0.0, barLength);
          ball.bounceTimer = 0.4;
          HapticFeedback.lightImpact();
        } else {
          ball.isFalling = true;
          HapticFeedback.heavyImpact();
          try {
            AppSettings.playSound('fall.wav');
          } catch (_) {}
          ball.freeFallVelocity = direction * ball.velocity;
        }
      } else {
        ball.fallRotation = ball.p / ballRadius;

        if (ball.bounceTimer > 0) {
          ball.bounceTimer -= dt;
          if (ball.bounceTimer < 0) ball.bounceTimer = 0.0;

          double t = 1.0 - (ball.bounceTimer / 0.4);
          if (t < 0.25) {
            double sq = t / 0.25;
            ball.squashY = 1.0 - (0.4 * sq);
            ball.squashX = 1.0 + (0.4 * sq);
            ball.pos2D =
                leftPoint +
                direction * ball.p +
                normal * (ballRadius * ball.squashY + 6.0);
          } else if (t < 0.75) {
            double sq = (t - 0.25) / 0.5;
            double bounceHeight = sin(sq * pi) * 20.0;
            ball.squashY = 1.0 + (0.2 * sin(sq * pi));
            ball.squashX = 1.0 - (0.2 * sin(sq * pi));
            ball.pos2D =
                leftPoint +
                direction * ball.p +
                normal * (ballRadius * ball.squashY + 6.0 + bounceHeight);
          } else {
            double sq = (t - 0.75) / 0.25;
            double settle = sin(sq * pi);
            ball.squashY = 1.0 - (0.2 * settle);
            ball.squashX = 1.0 + (0.2 * settle);
            ball.pos2D =
                leftPoint +
                direction * ball.p +
                normal * (ballRadius * ball.squashY + 6.0);
          }
        } else if (!isSpawningLevel &&
            !ball.isRespawningFromHole &&
            !ball.isFreeFalling &&
            !ball.isFalling &&
            !ball.isFallingInHole) {
          ball.squashX = 1.0;
          ball.squashY = 1.0;
          ball.pos2D =
              leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
        }

        // Check teleporter collisions
        for (final t in teleporters) {
          if (t.isClosed) continue;
          double dist = ball.pos2D.distanceTo(t.position);
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
              ball.activeExitTeleporter = other;
              ball.pos2D = other.position.clone();

              ball.isFreeFalling = true;
              timeStopTimer = 4.0;
              timeStopNotifier.value = 4.0;
              ball.freeFallVelocity = Vector2.zero();

              HapticFeedback.heavyImpact();
              try {
                AppSettings.playSound('hole.wav');
              } catch (_) {}
              break;
            }
          }
        }

        if (ball.isFreeFalling) {
          return;
        }

        // Check hole collisions
        for (final hole in holes) {
          double dist = ball.pos2D.distanceTo(hole.position);
          double lethalDist = (hole.size.x / 2) - 2.0;

          if (dist < lethalDist) {
            if (isShieldActive) {
              double dot = (ball.pos2D - hole.position).dot(direction);
              ball.velocity = (dot > 0 ? 1 : -1) * 200.0;
              HapticFeedback.lightImpact();
              continue;
            }

            ball.isFallingInHole = true;
            ball.activeHole = hole;
            ball.freeFallVelocity.setZero();
            HapticFeedback.heavyImpact();
            try {
              AppSettings.playSound('hole.wav');
            } catch (_) {}
            ball.fallTarget = hole.position.clone();
            break;
          } else if (hole.isSuckingHole && dist < hole.suckRadius) {
            if (isShieldActive) {
              continue;
            }
            ball.isFallingInHole = true;
            ball.activeHole = hole;
            ball.freeFallVelocity.setZero();
            HapticFeedback.heavyImpact();
            try {
              AppSettings.playSound('hole.wav');
            } catch (_) {}
            ball.fallTarget = hole.position.clone();
            break;
          }
        }

        // Check bumper collisions
        for (final bumper in bumpers) {
          double dist = ball.pos2D.distanceTo(bumper.position);
          if (dist < bumper.radius + ballRadius) {
            bumper.hit();
            HapticFeedback.heavyImpact();

            Vector2 bounceDir = (ball.pos2D - bumper.position).normalized();
            double dot = bounceDir.dot(direction);

            ball.velocity += dot * 400.0;

            double overlap = (bumper.radius + ballRadius) - dist;
            ball.p += dot.sign * overlap * 2.0;

            ball.bounceTimer = 0.4;

            ball.pos2D =
                leftPoint + direction * ball.p + normal * (ballRadius + 6.0);
          }
        }

        // Check star collisions & magnet logic
        for (final star in stars) {
          if (!star.isCollected) {
            Vector2 starPos = star.position.clone();

            if (magnetTimer > 0) {
              double pullSpeed = 400.0;
              Vector2 dir = (ball.pos2D - starPos);
              double dist = dir.length;
              if (dist < 150.0 && dist > 5.0) {
                dir.normalize();
                starPos += dir * pullSpeed * dt;

                star.fractionalPosition = Vector2(
                  starPos.x / size.x,
                  (starPos.y - 120.0) / (levelHeight - 320.0),
                );
                star.position = starPos;
              }
            }

            if (ball.pos2D.distanceTo(starPos) < ballRadius + 15.0) {
              star.isCollected = true;
              currentPoints.value++;
              HapticFeedback.lightImpact();
              try {
                AppSettings.playSound('star.wav');
              } catch (_) {}
            }
          }
        }

        // Check heart collisions
        for (final heart in hearts) {
          if (!heart.isCollected) {
            Vector2 heartPos = heart.position;
            if (ball.pos2D.distanceTo(heartPos) < ballRadius + 15.0) {
              heart.isCollected = true;
              currentLives.value++;
              HapticFeedback.lightImpact();
              try {
                AppSettings.playSound('star.wav');
              } catch (_) {}
            }
          }
        }

        // Check magnet collisions
        for (final mag in magnets) {
          if (!mag.isCollected) {
            Vector2 magPos = mag.position;
            if (ball.pos2D.distanceTo(magPos) < ballRadius + 15.0) {
              mag.isCollected = true;
              magnetTimer = 5.0; // Instantly activate!
              HapticFeedback.lightImpact();
              try {
                AppSettings.playSound('star.wav');
              } catch (_) {}
            }
          }
        }
      }
    } else {
      ball.fallRotation += dt * 10.0;
      ball.scale -= dt * 1.5;
      if (ball.scale < 0) ball.scale = 0;

      ball.freeFallVelocity.y += 980.0 * dt;
      ball.pos2D += ball.freeFallVelocity * dt;

      if (ball.pos2D.y > levelHeight + 100 || ball.scale <= 0) {
        ball.isDead = true;
      }
    }
  }

  void _checkBallToBallCollisions(Vector2 direction) {
    if (activeBalls.length < 2) return;

    for (int i = 0; i < activeBalls.length; i++) {
      for (int j = i + 1; j < activeBalls.length; j++) {
        final ballA = activeBalls[i];
        final ballB = activeBalls[j];

        if (ballA.isDead || ballB.isDead) continue;
        if (ballA.isFallingInHole || ballB.isFallingInHole) continue;
        if (ballA.isSuckingToGate || ballB.isSuckingToGate) continue;

        // Determine if they are both on the bar
        bool onBarA =
            !ballA.isFreeFalling &&
            !ballA.isFalling &&
            !ballA.isRespawningFromHole &&
            !ballA.isRespawningFromEdge &&
            ballA.spawnTimer <= 0;
        bool onBarB =
            !ballB.isFreeFalling &&
            !ballB.isFalling &&
            !ballB.isRespawningFromHole &&
            !ballB.isRespawningFromEdge &&
            ballB.spawnTimer <= 0;

        if (onBarA && onBarB) {
          // 1D Collision on the bar
          double dist = (ballA.p - ballB.p).abs();
          double minDist = 2 * ballRadius;
          if (dist < minDist) {
            // Swap velocities elastically
            double temp = ballA.velocity;
            ballA.velocity = ballB.velocity;
            ballB.velocity = temp;

            // Resolve overlap
            double overlap = minDist - dist;
            if (ballA.p > ballB.p) {
              ballA.p += overlap / 2;
              ballB.p -= overlap / 2;
            } else {
              ballA.p -= overlap / 2;
              ballB.p += overlap / 2;
            }

            // Apply light haptic feedback
            HapticFeedback.lightImpact();
          }
        } else {
          // 2D Collision in space (free falling, spawning, or falling off the bar)
          double dist = ballA.pos2D.distanceTo(ballB.pos2D);
          double minDist = 2 * ballRadius;
          if (dist < minDist) {
            Vector2 normal = (ballA.pos2D - ballB.pos2D).normalized();

            // If distance is zero, pick a random normal to avoid NaN
            if (dist == 0) {
              normal = Vector2(1, 0);
            }

            // Resolve overlap
            double overlap = minDist - dist;
            ballA.pos2D += normal * (overlap / 2);
            ballB.pos2D -= normal * (overlap / 2);

            // Get 2D velocities
            Vector2 velA = ballA.isFreeFalling || ballA.isFalling
                ? ballA.freeFallVelocity.clone()
                : (direction * ballA.velocity);
            Vector2 velB = ballB.isFreeFalling || ballB.isFalling
                ? ballB.freeFallVelocity.clone()
                : (direction * ballB.velocity);

            // Relative velocity along normal
            Vector2 relVel = velA - velB;
            double velAlongNormal = relVel.dot(normal);

            // Bouncing elastically if moving towards each other
            if (velAlongNormal < 0) {
              // Swap velocities along normal (elastic collision of equal masses)
              Vector2 impulse = normal * velAlongNormal;
              velA -= impulse;
              velB += impulse;

              // Apply updated velocities
              if (ballA.isFreeFalling || ballA.isFalling) {
                ballA.freeFallVelocity = velA;
              } else if (onBarA) {
                ballA.velocity = velA.dot(direction);
              }

              if (ballB.isFreeFalling || ballB.isFalling) {
                ballB.freeFallVelocity = velB;
              } else if (onBarB) {
                ballB.velocity = velB.dot(direction);
              }

              HapticFeedback.lightImpact();
            }
          }
        }
      }
    }
  }
}
