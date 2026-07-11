import 'dart:isolate';
import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
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
import 'package:balanco_game/features/game/components/coin_component.dart';
import 'package:balanco_game/features/game/components/floating_text_component.dart';
import 'package:balanco_game/features/game/components/bomb_warning_component.dart';
import 'package:balanco_game/features/game/components/bomb_component.dart';

import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/features/game/level_generator.dart';
import 'package:balanco_game/features/game/data/premade_levels.dart';
import 'package:balanco_game/features/game/level_system/campaign_level_repository.dart';
import 'package:balanco_game/features/game/level_system/level_debug_overlay.dart';
import 'package:balanco_game/features/game/level_system/level_definition_adapter.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/editor/screens/level_editor_screen.dart'; // EditorItemType

class BalancoGame extends FlameGame with KeyboardEvents, PanDetector {
  final bool isMultiplayer;
  final bool isInfinityMode;
  final bool isEditMode;
  final String playerRole;

  VoidCallback? onGameOver;
  VoidCallback? onLevelComplete;

  bool isDarknessLevel = false;
  bool isIlluminated = false;
  final ValueNotifier<int> lightChargesNotifier = ValueNotifier<int>(5);
  double lightChargeTimer = 0.0;
  final ValueNotifier<double> lightChargeTimerNotifier = ValueNotifier<double>(
    0.0,
  );
  final ValueNotifier<double> darknessOpacityNotifier = ValueNotifier<double>(
    0.0,
  );
  final ValueNotifier<List<Offset>> lightSpotNotifier =
      ValueNotifier<List<Offset>>([]);
  final ValueNotifier<double> lightRadiusNotifier = ValueNotifier<double>(65.0);

  final ValueNotifier<int> currentLevel = ValueNotifier<int>(1);
  BiomeModel get currentBiome => isInfinityMode
      ? BiomeConfig.getDynamicScoreBiome(currentScore.value)
      : BiomeConfig.getBiomeForLevel(currentLevel.value);
  final ValueNotifier<int> currentPoints = ValueNotifier<int>(0);
  final ValueNotifier<int> currentScore = ValueNotifier<int>(0);
  final ValueNotifier<int> collectedCoins = ValueNotifier<int>(0);
  late final ValueNotifier<int> currentLives = ValueNotifier<int>(
    isInfinityMode ? 1 : 3,
  );
  final ValueNotifier<int> earnedLevelPoints = ValueNotifier<int>(0);
  int infinityHighScore = 0;
  int lastInfinityScore = 0;
  int lastInfinityCoins = 0;

  static const int regularHolePoints = 3;
  static const int suckingHolePoints = 10;
  static const int movingHolePoints = 20;
  static const int bumperPoints = 5;

  // Shield state
  final ValueNotifier<int> remainingShields = ValueNotifier<int>(3);
  final ValueNotifier<double> shieldTimerNotifier = ValueNotifier<double>(0.0);
  double shieldTimer = 0.0;
  bool get isShieldActive => shieldTimer > 0;

  // Level timer
  double maxLevelTimer = 120.0; // Changed from a getter to a mutable variable
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

  // Bomb state
  double bombSpawnTimer = 0.0;
  double nextBombSpawnThreshold = 8.0; // Dynamic for infinity mode
  bool levelHasBomb = false;
  bool hasSpawnedBombInClassic = false;

  // Countdown
  double countdownTimer = 0.0;
  final ValueNotifier<int> countdownNotifier = ValueNotifier<int>(0);

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

  double nextSpawnY = 0.0;
  double nextInfinityChunkBoundaryY = 0.0;
  final Random _random = Random();
  static const bool showLevelDebugOverlay = false;

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
  List<CoinComponent> coins = [];
  TeleporterComponent? activeExitTeleporter;
  TeleportingGateComponent teleportingGateComponent = TeleportingGateComponent()
    ..priority = 0;

  final PositionComponent levelContainer = PositionComponent();
  LevelData? currentLevelData;
  double cameraOffsetY = 0.0;
  final ValueNotifier<double> cameraOffsetYNotifier = ValueNotifier<double>(
    0.0,
  );

  // Track the height multiplier for the current level (used for tall scrolling levels)
  final ValueNotifier<double> currentHeightMultiplierNotifier =
      ValueNotifier<double>(1.0);
  double get currentHeightMultiplier => currentHeightMultiplierNotifier.value;
  set currentHeightMultiplier(double val) {
    currentHeightMultiplierNotifier.value = val;
    if (isEditMode) {
      leftY = levelHeight - 70.0;
      rightY = levelHeight - 70.0;
      if (activeBalls.isNotEmpty) {
        activeBalls.first.pos2D.y = leftY - (16.0 + 6.0); // ballRadius is 16
      }
      cameraOffsetY = max(0.0, levelHeight - size.y);
      cameraOffsetYNotifier.value = cameraOffsetY;
    }
  }

  double get levelHeight =>
      isInfinityMode ? 999999.0 : size.y * currentHeightMultiplier;

  final ValueNotifier<PositionComponent?> selectedEditComponent = ValueNotifier(
    null,
  );

  BalancoGame({
    required this.isMultiplayer,
    this.isInfinityMode = false,
    this.isEditMode = false,
    required this.playerRole,
    this.onGameOver,
    this.onLevelComplete,
  });

  @override
  Color backgroundColor() => GameColors.transparentBlack;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (isEditMode) {
      // Pan camera (standard natural touch scrolling)
      cameraOffsetY -= info.delta.global.y;
      cameraOffsetY = cameraOffsetY.clamp(0.0, max(0.0, levelHeight - size.y));
      cameraOffsetYNotifier.value = cameraOffsetY;
    }
  }

  void spawnEditComponent(EditorItemType type) {
    if (!isEditMode) return;

    // Spawn in middle of screen (relative to camera)
    Vector2 spawnPos = Vector2(size.x / 2.0, cameraOffsetY + size.y / 2.0);

    PositionComponent newComp;
    switch (type) {
      case EditorItemType.hole:
        final hData = HoleData(
          Vector2.zero(),
          80.0,
          0.0,
          false,
          0.0,
          isMovingHole: false,
        );
        newComp = HoleComponent(
          hData.position,
          hData.size,
          hData.rotation,
          isSuckingHole: hData.isSuckingHole,
          isMovingHole: hData.isMovingHole,
          moveRange: hData.moveRange,
          moveSpeed: hData.moveSpeed,
        )..priority = 1;
        holes.add(newComp as HoleComponent);
        break;
      case EditorItemType.suckingHole:
        final hData = HoleData(
          Vector2.zero(),
          80.0,
          0.0,
          true,
          40.0,
          isMovingHole: false,
        );
        newComp = HoleComponent(
          hData.position,
          hData.size,
          hData.rotation,
          isSuckingHole: hData.isSuckingHole,
          isMovingHole: hData.isMovingHole,
          moveRange: hData.moveRange,
          moveSpeed: hData.moveSpeed,
        )..priority = 1;
        holes.add(newComp as HoleComponent);
        break;
      case EditorItemType.movingHole:
        final hData = HoleData(
          Vector2.zero(),
          80.0,
          0.0,
          false,
          0.0,
          isMovingHole: true,
          moveRange: 0.2,
          moveSpeed: 2.0,
        );
        newComp = HoleComponent(
          hData.position,
          hData.size,
          hData.rotation,
          isSuckingHole: hData.isSuckingHole,
          isMovingHole: hData.isMovingHole,
          moveRange: hData.moveRange,
          moveSpeed: hData.moveSpeed,
        )..priority = 1;
        holes.add(newComp as HoleComponent);
        break;
      case EditorItemType.star:
        newComp = StarComponent(Vector2.zero())..priority = 10;
        stars.add(newComp as StarComponent);
        break;
      case EditorItemType.heart:
        newComp = HeartComponent(Vector2.zero())..priority = 10;
        hearts.add(newComp as HeartComponent);
        break;
      case EditorItemType.bumper:
        newComp = BumperComponent(Vector2.zero(), 40.0)..priority = 2;
        bumpers.add(newComp as BumperComponent);
        break;
      case EditorItemType.teleporter:
        newComp = TeleporterComponent(Vector2.zero(), 40.0, 0)..priority = 1;
        teleporters.add(newComp as TeleporterComponent);
        break;
      case EditorItemType.magnet:
        newComp = MagnetComponent(Vector2.zero())..priority = 5;
        magnets.add(newComp as MagnetComponent);
        break;
      case EditorItemType.multiBall:
        newComp = MultiBallItem(Vector2.zero(), ballCount: 2)..priority = 4;
        multiBallItems.add(newComp as MultiBallItem);
        break;
    }

    newComp.position = spawnPos;
    newComp.scale = Vector2.all(1.0);
    levelContainer.add(newComp);
    selectedEditComponent.value = newComp;
  }

  void deleteSelectedEditComponent() {
    if (selectedEditComponent.value != null) {
      final comp = selectedEditComponent.value!;
      if (comp is HoleComponent) holes.remove(comp);
      if (comp is StarComponent) stars.remove(comp);
      if (comp is HeartComponent) hearts.remove(comp);
      if (comp is BumperComponent) bumpers.remove(comp);
      if (comp is TeleporterComponent) teleporters.remove(comp);
      if (comp is MagnetComponent) magnets.remove(comp);
      if (comp is MultiBallItem) multiBallItems.remove(comp);

      comp.removeFromParent();
      selectedEditComponent.value = null;
    }
  }

  Future<void> loadEditorTemplate(int templateLevelId) async {
    if (!isEditMode) return;

    // Clear everything
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

    if (templateLevelId == -1) {
      // Blank Canvas
      currentHeightMultiplier = 1.0;
    } else {
      if (PremadeLevels.levelsJson.containsKey(templateLevelId)) {
        final jsonStr = PremadeLevels.levelsJson[templateLevelId]!;
        final data = LevelData.fromJson(jsonDecode(jsonStr));
        currentHeightMultiplier = data.heightMultiplier;

        // Populate
        for (final hData in data.holes) {
          final hole = HoleComponent(
            hData.position.clone(),
            hData.size,
            hData.rotation,
            isSuckingHole: hData.isSuckingHole,
            isMovingHole: hData.isMovingHole,
            moveRange: hData.moveRange,
            moveSpeed: hData.moveSpeed,
          )..priority = 1;
          hole.position = Vector2(
            hData.position.x * size.x,
            120.0 + hData.position.y * (levelHeight - 320.0),
          );
          hole.scale = Vector2.all(1.0);
          holes.add(hole);
          levelContainer.add(hole);
        }
        for (final sPos in data.stars) {
          final s = StarComponent(sPos)..priority = 10;
          s.position = Vector2(
            sPos.x * size.x,
            120.0 + sPos.y * (levelHeight - 320.0),
          );
          s.scale = Vector2.all(1.0);
          stars.add(s);
          levelContainer.add(s);
        }
        for (final hPos in data.hearts) {
          final h = HeartComponent(hPos)..priority = 10;
          h.position = Vector2(
            hPos.x * size.x,
            120.0 + hPos.y * (levelHeight - 320.0),
          );
          h.scale = Vector2.all(1.0);
          hearts.add(h);
          levelContainer.add(h);
        }
        for (final bData in data.bumpers) {
          final b = BumperComponent(bData.position, bData.size)..priority = 2;
          b.position = Vector2(
            bData.position.x * size.x,
            120.0 + bData.position.y * (levelHeight - 320.0),
          );
          b.scale = Vector2.all(1.0);
          bumpers.add(b);
          levelContainer.add(b);
        }
        for (final tData in data.teleporters) {
          final t = TeleporterComponent(
            tData.position,
            tData.size,
            tData.pairId,
          )..priority = 1;
          t.position = Vector2(
            tData.position.x * size.x,
            120.0 + tData.position.y * (levelHeight - 320.0),
          );
          t.scale = Vector2.all(1.0);
          teleporters.add(t);
          levelContainer.add(t);
        }
        for (final magPos in data.magnets) {
          final mag = MagnetComponent(magPos)..priority = 5;
          mag.position = Vector2(
            magPos.x * size.x,
            120.0 + magPos.y * (levelHeight - 320.0),
          );
          mag.scale = Vector2.all(1.0);
          magnets.add(mag);
          levelContainer.add(mag);
        }
        for (final mbPos in data.multiBalls) {
          final mb = MultiBallItem(mbPos)..priority = 5;
          mb.position = Vector2(
            mbPos.x * size.x,
            120.0 + mbPos.y * (levelHeight - 320.0),
          );
          mb.scale = Vector2.all(1.0);
          multiBallItems.add(mb);
          levelContainer.add(mb);
        }
      }
    }
  }

  String exportLevelData() {
    final Map<String, dynamic> data = {
      'levelNumber': currentLevel.value,
      'holes': holes
          .map(
            (h) => {
              'x': h.position.x / size.x,
              'y': (h.position.y - 120.0) / (levelHeight - 320.0),
              'size': h.size.x * h.scale.x,
              'rotation': 0.0,
              'isSuckingHole': h.isSuckingHole,
              'suckRadius': h.suckRadius * h.scale.x,
              'isMovingHole': h.isMovingHole,
              'moveRange': h.moveRange,
              'moveSpeed': h.moveSpeed,
            },
          )
          .toList(),
      'stars': stars
          .map(
            (s) => {
              'x': s.position.x / size.x,
              'y': (s.position.y - 120.0) / (levelHeight - 320.0),
            },
          )
          .toList(),
      'hearts': hearts
          .map(
            (h) => {
              'x': h.position.x / size.x,
              'y': (h.position.y - 120.0) / (levelHeight - 320.0),
            },
          )
          .toList(),
      'bumpers': bumpers
          .map(
            (b) => {
              'x': b.position.x / size.x,
              'y': (b.position.y - 120.0) / (levelHeight - 320.0),
              'radius': b.radius * b.scale.x,
            },
          )
          .toList(),
      'teleporters': teleporters
          .map(
            (t) => {
              'x': t.position.x / size.x,
              'y': (t.position.y - 120.0) / (levelHeight - 320.0),
              'radius': t.radius * t.scale.x,
              'pairId': t.index,
            },
          )
          .toList(),
      'magnets': magnets
          .map(
            (m) => {
              'x': m.position.x / size.x,
              'y': (m.position.y - 120.0) / (levelHeight - 320.0),
            },
          )
          .toList(),
      'multiBalls': multiBallItems
          .map(
            (m) => {
              'x': m.position.x / size.x,
              'y': (m.position.y - 120.0) / (levelHeight - 320.0),
              'ballCount': m.ballCount,
            },
          )
          .toList(),
      'heightMultiplier': currentHeightMultiplier,
      'timeLimitSeconds': levelTimer.toInt(), // Add this!
      'timerSeconds': levelTimer, // Add this!
    };

    // We should encode to JSON, import dart:convert at the top.
    return jsonEncode(data);
  }

  void reset() {
    currentLevel.value = 1;
    restartCurrentLevel();
  }

  void restartCurrentLevel() async {
    print("DEBUG: restartCurrentLevel called. Level: ${currentLevel.value}");
    isSpawningLevel = true;
    currentPoints.value = 0;
    earnedLevelPoints.value = 0;
    if (isInfinityMode) {
      currentScore.value = 0;
      collectedCoins.value = 0;
      lastInfinityScore = 0;
      lastInfinityCoins = 0;
      nextInfinityChunkBoundaryY = 0.0;
    }
    currentLives.value = isInfinityMode ? 1 : 3;
    showGameOverOverlay.value = false;

    children.whereType<ConfettiComponent>().forEach(
      (c) => c.removeFromParent(),
    );
    _resetPositions();
    print("DEBUG: generateLevel starts");
    await generateLevel();
    print("DEBUG: generateLevel finishes, resuming engine");
    resumeEngine();
  }

  void startNextLevel() {
    currentLevel.value++;
    restartCurrentLevel();
  }

  Future<void> advanceToNextLevel() async {
    print("DEBUG: advanceToNextLevel called");
    showVictoryOverlay.value = false;
    showGameOverOverlay.value = false;
    isLevelCompleteOverlayShown = false;

    currentLevel.value++;
    restartCurrentLevel();
  }

  void restartLevelAfterWin() {
    showVictoryOverlay.value = false;
    showGameOverOverlay.value = false;
    isLevelCompleteOverlayShown = false;
    earnedLevelPoints.value = 0;
    restartCurrentLevel();
  }

  int get levelPointMultiplier {
    final level = currentLevel.value;
    if (level <= 10) return 1;
    if (level <= 30) return 2;
    if (level <= 50) return 3;
    return 3 + ((level - 51) ~/ 20);
  }

  int get baseLevelPoints {
    final holePoints = holes.fold<int>(0, (sum, hole) {
      if (hole.isMovingHole) return sum + movingHolePoints;
      if (hole.isSuckingHole) return sum + suckingHolePoints;
      return sum + regularHolePoints;
    });
    return holePoints + bumpers.length * bumperPoints;
  }

  int calculateLevelRewardPoints() => baseLevelPoints * levelPointMultiplier;

  void _resetPositions({
    bool loseLife = false,
    bool respawnFromHole = false,
    HoleComponent? prevHole,
  }) {
    print(
      "DEBUG: _resetPositions called. size: ${size.x}x${size.y}, isSpawningLevel: $isSpawningLevel, loseLife: $loseLife",
    );

    double currentSizeY = size.y > 0 ? size.y : 800.0;
    double currentLevelHeight =
        currentSizeY * (currentLevel.value >= 10 ? 3.0 : 1.0);

    if (leftY != 0.0 && size.y > 0 && !isSpawningLevel) {
      initialLeftY = leftY;
      initialRightY = rightY;
      barResetTimer = 0.8; // Straighten bar consistently in 0.8s
    } else {
      barResetTimer = 0.0;
      leftY = currentLevelHeight - 70.0;
      rightY = currentLevelHeight - 70.0;
    }

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
    lightChargeTimer = 0.0;
    lightChargeTimerNotifier.value = 0.0;
    isIlluminated = false;
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
      if (isInfinityMode) {
        currentScore.value -= 20;
        if (currentScore.value < 0) currentScore.value = 0;
        // Float text
        final centerPos = Vector2(size.x / 2.0, (leftY + rightY) / 2.0 - 50);
        levelContainer.add(
          FloatingTextComponent(
            text: '-20',
            position: centerPos,
            color: GameColors.red300,
          ),
        );
      }
      currentLives.value--;
      if (currentLives.value <= 0) {
        HapticFeedback.vibrate();
        try {
          AppSettings.playSound('gameover.wav');
        } catch (_) {}
        pauseEngine();
        showGameOverOverlay.value = true;
        _saveInfinityScoreAndCoins();
        return; // Don't reset position yet
      }
    }

    // Always clear balls and components, even if size is temporarily 0
    activeBalls.clear();
    for (var bc in activeBallComponents) {
      bc.removeFromParent();
    }
    activeBallComponents.clear();

    teleportingGateComponent.reset();

    // Create main ball
    BallData mainBall = BallData();
    double currentSizeX = size.x > 0 ? size.x : 400.0;
    mainBall.p = (currentSizeX - 2 * barPadding) / 2.0;

    if (isEditMode) {
      teleportingGateComponent.startClosed();
      mainBall.pos2D = Vector2(
        currentSizeX / 2.0,
        (leftY + rightY) / 2.0 - (ballRadius + 6.0),
      );
      mainBall.scale = 1.0;
      mainBall.spawnTimer = 0.0;
      mainBall.isFreeFalling = false;
      mainBall.velocity = 0.0;
      cameraOffsetY = max(0.0, currentLevelHeight - size.y);
      cameraOffsetYNotifier.value = cameraOffsetY;
    } else if (isInfinityMode) {
      // In infinity mode: instantly spawn ball on the bar
      double barCenterY = (leftY + rightY) / 2.0;
      mainBall.pos2D = Vector2(
        currentSizeX / 2.0,
        barCenterY - (ballRadius + 6.0),
      );
      for (final hole in holes) {
        if (!hole.isSuckingHole || hole.parent == null) continue;
        if (mainBall.pos2D.distanceTo(hole.position) < hole.suckRadius) {
          final lift = hole.suckRadius + ballRadius + 10.0;
          leftY -= lift;
          rightY -= lift;
          initialLeftY -= lift;
          initialRightY -= lift;
          barCenterY = (leftY + rightY) / 2.0;
          mainBall.pos2D = Vector2(
            currentSizeX / 2.0,
            barCenterY - (ballRadius + 6.0),
          );
        }
      }
      mainBall.scale = 1.0;
      mainBall.isFreeFalling = false;
      mainBall.velocity = 0.0;
      mainBall.freeFallVelocity.setZero();
      mainBall.holeImmunityTimer = 2.0;
      shieldTimer = 2.0;
      shieldTimerNotifier.value = 2.0;
      isSpawningLevel = false;
      isLevelTimerActive = false;
      teleportingGateComponent.scale = Vector2.zero(); // hide the gate
      countdownTimer = 3.99; // 3 seconds countdown + "GO"
    } else if (isSpawningLevel) {
      teleportingGateComponent.startClosed();
      mainBall.pos2D = teleportingGateComponent.position.clone();
      mainBall.scale = 0.0;
      mainBall.spawnTimer = 1.5;
      itemSpawnTimer = 0.5;
      cameraOffsetY = 0.0;
    } else if (respawnFromHole && prevHole != null) {
      mainBall.activeHole = prevHole;
      mainBall.isRespawningFromHole = true;
      isLevelTimerActive = false;
      mainBall.respawnTimer = 1.6;
      mainBall.pos2D = mainBall.activeHole!.position.clone();
      mainBall.scale = 0.0;
      mainBall.p = (currentSizeX - 2 * barPadding) / 2.0;
      shieldTimer = 1.5;
      shieldTimerNotifier.value = 1.5;
    } else {
      mainBall.isRespawningFromEdge = true;
      isLevelTimerActive = false;
      mainBall.respawnTimer = 1.6;
      mainBall.pos2D = teleportingGateComponent.position.clone();
      mainBall.scale = 0.0;
      mainBall.p = (currentSizeX - 2 * barPadding) / 2.0;
      mainBall.isFreeFalling = false;
    }

    activeBalls.add(mainBall);
    BallComponent bc = BallComponent(mainBall)..priority = 20;
    activeBallComponents.add(bc);
    levelContainer.add(bc);

    leftJoystickValue = 0.0;
    rightJoystickValue = 0.0;
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
        'power_down.wav',
        'light_switch_on.wav',
      ]);
    } catch (_) {}

    if (isInfinityMode) {
      await _loadInfinityHighScore();
    }

    barComponent = BarComponent()..priority = 10;

    add(levelContainer);
    if (showLevelDebugOverlay) {
      add(LevelDebugOverlay());
    }

    levelContainer.add(teleportingGateComponent);
    levelContainer.add(barComponent);

    await generateLevel();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (Platform.isWindows) {
      bool isUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
      bool isDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
      bool isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
      bool isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);

      double newLeft = 0.0;
      double newRight = 0.0;

      if (isUp) {
        newLeft = -1.0;
        newRight = -1.0;
      } else if (isDown) {
        newLeft = 1.0;
        newRight = 1.0;
      } else if (isLeft) {
        newLeft = 1.0;
        newRight = -1.0;
      } else if (isRight) {
        newLeft = -1.0;
        newRight = 1.0;
      }

      leftJoystickValue = newLeft;
      rightJoystickValue = newRight;
    }

    return super.onKeyEvent(event, keysPressed);
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
    for (final coin in coins) {
      if (coin.parent != null) coin.removeFromParent();
    }
    coins.clear();

    // Offload level generation to an Isolate
    LevelData data;
    final int levelToGenerate = currentLevel.value;
    var loadedBakedCampaignLevel = false;

    if (isEditMode) {
      final customJsonStr = await DatabaseHelper.instance.getCustomLevel(
        levelToGenerate,
      );
      if (customJsonStr != null) {
        data = LevelData.fromJson(jsonDecode(customJsonStr));
      } else if (PremadeLevels.levelsJson.containsKey(levelToGenerate)) {
        final jsonStr = PremadeLevels.levelsJson[levelToGenerate]!;
        data = LevelData.fromJson(jsonDecode(jsonStr));
      } else {
        data = LevelData(
          holes: [],
          teleporters: [],
          bumpers: [],
          stars: [],
          hearts: [],
          multiBalls: [],
          magnets: [],
        );
      }
      isSpawningLevel = false;
      // Trigger setter to adjust camera and bar for the loaded height
      currentHeightMultiplier = data.heightMultiplier;
    } else if (isInfinityMode) {
      data = LevelData(
        holes: [],
        teleporters: [],
        bumpers: [],
        stars: [],
        hearts: [],
        multiBalls: [],
        magnets: [],
      );
      // Start spawning just above the bar
      nextSpawnY = (size.y > 0 ? size.y : 800.0) - 250.0;
      // Pre-spawn a wave of obstacles immediately
      for (int i = 0; i < 8; i++) {
        _spawnInfinityObstaclePattern(nextSpawnY, 0.0);
        nextSpawnY -= 220.0 + _random.nextDouble() * 100.0;
      }
      nextInfinityChunkBoundaryY = nextSpawnY - 4000.0;
      _scatterStarsInChunk(nextSpawnY, nextInfinityChunkBoundaryY, 10);
      isSpawningLevel = false;
    } else {
      if (PremadeLevels.levelsJson.containsKey(levelToGenerate)) {
        final jsonStr = PremadeLevels.levelsJson[levelToGenerate]!;
        data = LevelData.fromJson(jsonDecode(jsonStr));
      } else {
        final customJsonStr = await DatabaseHelper.instance.getCustomLevel(
          levelToGenerate,
        );
        if (customJsonStr != null) {
          data = LevelData.fromJson(jsonDecode(customJsonStr));
        } else {
          final campaignLevel = await CampaignLevelRepository.instance
              .loadLevel(levelToGenerate);
          if (campaignLevel != null) {
            data = campaignLevel.toLevelData();
            loadedBakedCampaignLevel = true;
          } else {
            data = await Isolate.run(() => generateLevelData(levelToGenerate));
            // fallback generated levels don't specify height, so infer it if >= 10
            if (levelToGenerate >= 10) {
              data = LevelData(
                holes: data.holes,
                stars: data.stars,
                hearts: data.hearts,
                bumpers: data.bumpers,
                teleporters: data.teleporters,
                multiBalls: data.multiBalls,
                magnets: data.magnets,
                heightMultiplier: 3.0,
              );
            }
          }
        }
      }
    }
    currentLevelData = data;

    if (!isEditMode && !isInfinityMode) {
      currentHeightMultiplierNotifier.value = data.heightMultiplier;

      // Now that we have the real height multiplier, fix the bar position if it was reset to the bottom
      if (barResetTimer == 0.0) {
        leftY = levelHeight - 70.0;
        rightY = levelHeight - 70.0;
      }
    }

    pendingSpawns.clear();
    targetPositions.clear();
    // Check for time-related obstacles
    if (data.timeLimitSeconds > 0) {
      maxLevelTimer = data.timeLimitSeconds.toDouble();
      levelTimer = maxLevelTimer;
      levelTimerNotifier.value = levelTimer;
    } else {
      maxLevelTimer = data.timerSeconds;
      levelTimer = maxLevelTimer;
      levelTimerNotifier.value = levelTimer;
    }

    // Reset bomb states
    levelHasBomb =
        data.hasBomb || (!loadedBakedCampaignLevel && currentLevel.value >= 2);
    hasSpawnedBombInClassic = false;
    bombSpawnTimer = 0.0;
    nextBombSpawnThreshold = 15.0 + _random.nextDouble() * 10.0;

    isDarknessLevel =
        data.isDarkLevel ||
        (!loadedBakedCampaignLevel && levelToGenerate >= 11);

    // Quickly spawn components back on the main thread using the pre-calculated data
    for (final hData in data.holes) {
      final hole = HoleComponent(
        hData.position.clone(), // Clone so we don't modify the data directly
        hData.size,
        hData.rotation,
        isSuckingHole: hData.isSuckingHole,
        isMovingHole: hData.isMovingHole,
        moveRange: hData.moveRange,
        moveSpeed: hData.moveSpeed,
        moveAxis: hData.moveAxis,
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

    if (isEditMode) {
      for (final comp in pendingSpawns) {
        comp.position = targetPositions[comp]!;
        comp.scale = Vector2.all(1.0);
      }
      pendingSpawns.clear();
      targetPositions.clear();
      isSpawningLevel = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (size.x == 0 || size.y == 0) return;

    if (isEditMode) {
      levelContainer.position.y = -cameraOffsetY;
      return;
    }

    if (!isInfinityMode &&
        isLevelTimerActive &&
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

    // Bomb Spawning
    if (!isSpawningLevel &&
        !isLevelCompleteOverlayShown &&
        countdownNotifier.value == 0 &&
        activeBalls.isNotEmpty &&
        !isBoardHidden) {
      bool isActivelyPlaying = activeBalls.any(
        (b) =>
            !b.isDead &&
            !b.isRespawningFromHole &&
            !b.isRespawningFromEdge &&
            !b.isShattering &&
            !b.isFreeFalling &&
            !b.isFalling &&
            !b.isFallingInHole,
      );

      if (isActivelyPlaying) {
        bombSpawnTimer += dt;
        if (isInfinityMode) {
          if (bombSpawnTimer >= nextBombSpawnThreshold) {
            _spawnBombWarning();
            bombSpawnTimer = 0.0;
            // Decrease threshold slightly but randomize heavily for professional feel
            double newBase = max(10.0, nextBombSpawnThreshold - 1.0);
            nextBombSpawnThreshold = newBase + _random.nextDouble() * 5.0;
          }
        } else {
          if (levelHasBomb && !hasSpawnedBombInClassic) {
            // Spawn quickly but randomly (between 5 and 10 seconds)
            double spawnTime = 5.0 + _random.nextDouble() * 5.0;
            if (bombSpawnTimer >= spawnTime) {
              _spawnBombWarning();
              hasSpawnedBombInClassic = true;
            }
          }
        }
      } else {
        _clearBombs();
      }
    }

    if (countdownTimer > 0) {
      countdownTimer -= dt;
      if (countdownTimer < 0) countdownTimer = 0.0;
      countdownNotifier.value = countdownTimer.ceil();
      // Lock the camera to the bar while counting down
      double targetCameraY =
          ((leftY + rightY) / 2) - size.y + (isInfinityMode ? 75.0 : 150.0);
      cameraOffsetY += (targetCameraY - cameraOffsetY) * dt * 5.0;
      levelContainer.position.y = -cameraOffsetY;
      cameraOffsetYNotifier.value = cameraOffsetY;
      return; // Skip updating ball physics and scrolling during countdown
    } else if (countdownNotifier.value != 0) {
      countdownNotifier.value = 0;
    }

    double maxY = levelHeight - 70.0;
    double minY = 10.0;

    if (barResetTimer > 0) {
      barResetTimer -= dt;
      double targetY = isInfinityMode
          ? (initialLeftY + initialRightY) / 2.0
          : maxY;
      if (barResetTimer <= 0) {
        barResetTimer = 0.0;
        leftY = targetY;
        rightY = targetY;
      } else {
        double duration = 0.8;
        double p = 1.0 - (barResetTimer / duration).clamp(0.0, 1.0);
        double curved = Curves.easeInOut.transform(p);
        leftY = initialLeftY + (targetY - initialLeftY) * curved;
        rightY = initialRightY + (targetY - initialRightY) * curved;
      }
    } else {
      bool anyBallOnBar = activeBalls.any(
        (b) =>
            !b.isDead &&
            !b.isFalling &&
            !b.isFreeFalling &&
            !b.isFallingInHole &&
            !b.isRespawningFromHole &&
            !b.isRespawningFromEdge &&
            b.spawnTimer <= 0,
      );
      bool anyPortalCatchWindow = activeBalls.any(
        (b) =>
            !b.isDead &&
            (b.spawnTimer > 0 ||
                (b.isFreeFalling && b.activeExitTeleporter != null)),
      );

      if (anyBallOnBar || anyPortalCatchWindow) {
        final double baseSpeed = timeStopNotifier.value > 0
            ? 150.0 * AppSettings.joystickSensitivity.value
            : 250.0 * AppSettings.joystickSensitivity.value;
        final double speed =
            baseSpeed * (!anyBallOnBar && anyPortalCatchWindow ? 0.60 : 1.0);
        double maxDiff = 120.0;

        double leftInput = isSpawningLevel ? 0.0 : leftJoystickValue;
        double rightInput = isSpawningLevel ? 0.0 : rightJoystickValue;

        double newLeftY = leftY + (leftInput * speed) * dt;
        newLeftY = newLeftY.clamp(rightY - maxDiff, rightY + maxDiff);
        if (!isInfinityMode) newLeftY = newLeftY.clamp(minY, maxY);

        double newRightY = rightY + (rightInput * speed) * dt;
        newRightY = newRightY.clamp(leftY - maxDiff, leftY + maxDiff);
        if (!isInfinityMode) newRightY = newRightY.clamp(minY, maxY);

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
      final deadBalls = activeBalls.where((b) => b.isDead).toList();
      final shouldSpendLife =
          !isInfinityMode || deadBalls.any((b) => b.spendsLifeOnDeath);
      activeBalls.removeWhere((b) => b.isDead);
      for (var bc in activeBallComponents.toList()) {
        if (!activeBalls.contains(bc.ballData)) {
          bc.removeFromParent();
          activeBallComponents.remove(bc);
        }
      }

      if (activeBalls.isEmpty) {
        _resetPositions(
          loseLife: shouldSpendLife,
          respawnFromHole: prevHole != null,
          prevHole: prevHole,
        );
      }
    }

    if (isInfinityMode) {
      _updateInfinityMode(dt);
    }

    // --- Camera Logic ---
    if (size.y > 0) {
      double targetCameraY = 0.0;
      if (isSpawningLevel) {
        double mainBallY = activeBalls.isNotEmpty
            ? activeBalls.first.pos2D.y
            : size.y / 2;
        targetCameraY = (mainBallY - size.y / 2);
        if (!isInfinityMode) {
          targetCameraY = targetCameraY.clamp(
            0.0,
            max(0.0, levelHeight - size.y),
          );
        }
      } else {
        targetCameraY =
            ((leftY + rightY) / 2) - size.y + (isInfinityMode ? 75.0 : 150.0);
        if (!isInfinityMode) {
          targetCameraY = targetCameraY.clamp(
            0.0,
            max(0.0, levelHeight - size.y),
          );
        }
      }
      cameraOffsetY += (targetCameraY - cameraOffsetY) * dt * 5.0;
      levelContainer.position.y = -cameraOffsetY;
      cameraOffsetYNotifier.value = cameraOffsetY;
    }

    // Light Dude Mechanic State Machine
    if (isDarknessLevel && !isSpawningLevel && activeBalls.isNotEmpty) {
      if (lightChargeTimer > 0) {
        lightChargeTimer -= dt;
        if (lightChargeTimer <= 0) {
          lightChargeTimer = 0.0;
          isIlluminated = false;
          try {
            AppSettings.playSound('power_down.wav');
          } catch (_) {}
        }
        lightChargeTimerNotifier.value = lightChargeTimer;
      }

      if (isIlluminated) {
        darknessOpacityNotifier.value =
            (darknessOpacityNotifier.value - dt * 3.33).clamp(0.0, 1);
      } else {
        darknessOpacityNotifier.value =
            (darknessOpacityNotifier.value + dt * 10.0).clamp(0.0, 1);
      }

      final spots = activeBalls
          .where((b) => !b.isDead)
          .map((b) => Offset(b.pos2D.x, b.pos2D.y - cameraOffsetY))
          .toList();
      lightSpotNotifier.value = spots;
    } else {
      darknessOpacityNotifier.value = 0.0;
      lightSpotNotifier.value = [];
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
    if (ball.holeImmunityTimer > 0) {
      ball.holeImmunityTimer = max(0.0, ball.holeImmunityTimer - dt);
    }

    if (ball.isShattering) {
      ball.shatterTimer += dt;
      if (ball.shatterTimer >= 1.0) {
        ball.isDead = true;
      }
      return;
    }

    if (ball.isFallingInHole) {
      if (ball.activeHole != null) {
        ball.fallTarget = ball.activeHole!.position.clone();
      }
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
            print("DEBUG: showVictoryOverlay triggered from isSuckingToGate");
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
        !isInfinityMode && // No gate sucking in infinity mode
        !ball.isRespawningFromHole &&
        !ball.isRespawningFromEdge &&
        !isLevelCompleteOverlayShown) {
      Vector2 gateCenter = teleportingGateComponent.position;
      if (ball.pos2D.distanceTo(gateCenter) < 40) {
        print(
          "DEBUG: isSuckingToGate = true triggered. pos2D: ${ball.pos2D}, gateCenter: $gateCenter",
        );
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
            int charges = 5 - (currentLevel.value - 11);
            if (charges < 2) charges = 2;
            lightChargesNotifier.value = charges;

            if (isDarknessLevel) {
              isIlluminated = false;
            }
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
          if (ball.holeImmunityTimer > 0) continue;

          double dist = ball.pos2D.distanceTo(hole.position);
          double lethalDist =
              (hole.size.x / 2 * hole.scale.x) - 2.0 * hole.scale.x;

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
          } else if (hole.isSuckingHole &&
              dist < hole.suckRadius * hole.scale.x) {
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

        // Check coin collisions & magnet logic
        for (final coin in coins) {
          if (!coin.isCollected) {
            Vector2 coinPos = coin.position.clone();

            if (magnetTimer > 0) {
              double pullSpeed = 400.0;
              Vector2 dir = (ball.pos2D - coinPos);
              double dist = dir.length;
              if (dist < 150.0 && dist > 5.0) {
                dir.normalize();
                coinPos += dir * pullSpeed * dt;
                coin.position = coinPos;
              }
            }

            if (ball.pos2D.distanceTo(coinPos) < ballRadius + coin.radius) {
              coin.collect();
              HapticFeedback.lightImpact();
              try {
                AppSettings.playSound('star.wav'); // Reuse star sound
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

  void useLightCharge() {
    if (isDarknessLevel) {
      if (lightChargesNotifier.value > 0 && lightChargeTimer <= 0) {
        lightChargesNotifier.value--;
        lightChargeTimer = 5.0; // Grants 5 seconds of light buff
        lightChargeTimerNotifier.value = lightChargeTimer;
        isIlluminated = true;
        try {
          AppSettings.playSound('light_switch_on.wav');
        } catch (_) {}
      }
    }
  }

  void _updateInfinityMode(double dt) {
    if (dt <= 0) return;
    if (activeBalls.isEmpty) return;

    final double barMid = (leftY + rightY) / 2.0;
    final double barTop = barMid - 800.0;
    while (nextSpawnY > barTop) {
      if (nextSpawnY <= nextInfinityChunkBoundaryY) {
        _spawnInfinityCoinSnake(nextSpawnY);
        nextSpawnY -= 620.0;
        final double currentChunkEnd = nextInfinityChunkBoundaryY;
        nextInfinityChunkBoundaryY -= 4000.0;
        _scatterStarsInChunk(currentChunkEnd, nextInfinityChunkBoundaryY, 10);
        continue;
      }

      final double estimatedScore = ((550 - nextSpawnY) / 40.0).clamp(0, 9999);
      final double difficulty = (estimatedScore / 500.0).clamp(0.0, 1.0);

      _spawnInfinityObstaclePattern(nextSpawnY, difficulty);

      final double maxStep = 320.0 - (difficulty * 80.0);
      final double minStep = 220.0 - (difficulty * 40.0);

      nextSpawnY -= minStep + _random.nextDouble() * (maxStep - minStep);
    }

    for (final hole in holes) {
      if (!hole.isPassed && hole.position.y > barMid) {
        hole.isPassed = true;
        int points = 1;
        if (hole.isSuckingHole) {
          points = 10;
        } else if (hole.isMovingHole) {
          points = 5;
        }

        currentScore.value += points;
        levelContainer.add(
          FloatingTextComponent(
            text: '+$points',
            position: hole.position.clone(),
            color: GameColors.lightBlue,
          ),
        );
      }
    }

    for (final bumper in bumpers) {
      if (!bumper.isPassed && bumper.position.y > barMid) {
        bumper.isPassed = true;
        currentScore.value += 3;
        levelContainer.add(
          FloatingTextComponent(
            text: '+3',
            position: bumper.position.clone(),
            color: GameColors.lightBlue,
          ),
        );
      }
    }

    _cullInfinityObstacles(barMid + 600.0);
  }

  void _scatterStarsInChunk(double startY, double endY, int count) {
    final double sizeX = size.x > 0 ? size.x : 400.0;
    final double usableWidth = sizeX - barPadding * 2 - 40.0;
    for (int i = 0; i < count; i++) {
      final double x = barPadding + 20.0 + _random.nextDouble() * usableWidth;
      final double y = endY + _random.nextDouble() * (startY - endY);
      final coin = CoinComponent(position: Vector2(x, y))..priority = 5;
      coins.add(coin);
      levelContainer.add(coin);
    }
  }

  void _spawnInfinityCoinSnake(double startY) {
    final double sizeX = size.x > 0 ? size.x : 400.0;
    final double centerX = sizeX / 2.0;
    final double amplitude = (sizeX / 2.0) - barPadding - 30.0;
    const int coinCount = 20;
    const double stepY = 30.0;

    for (int i = 0; i < coinCount; i++) {
      final double progress = i / (coinCount - 1);
      final double wave = sin(progress * pi * 3.0); // 1.5 full cycles
      final double x = centerX + wave * amplitude;
      final double y = startY - i * stepY;
      final coin = CoinComponent(position: Vector2(x, y))..priority = 5;
      coins.add(coin);
      levelContainer.add(coin);
    }
  }

  void _spawnBombWarning() {
    final warning = BombWarningComponent()..priority = 100;
    levelContainer.add(warning);
    try {
      AppSettings.playSound('tick.wav'); // Optional warning sound
    } catch (_) {}
  }

  void _clearBombs() {
    bombSpawnTimer = 0.0;
    for (var c in levelContainer.children.whereType<BombWarningComponent>()) {
      c.removeFromParent();
    }
    for (var c in levelContainer.children.whereType<BombComponent>()) {
      c.removeFromParent();
    }
  }

  void _spawnInfinityObstaclePattern(double y, double difficulty) {
    final double sizeX = size.x > 0 ? size.x : 400.0;
    final double usableWidth = sizeX - barPadding * 2;
    double rx() =>
        barPadding + 40.0 + _random.nextDouble() * (usableWidth - 80.0);

    final double roll = _random.nextDouble();

    // Spawn powerups independently of the pattern (small chance)
    if (_random.nextDouble() < 0.05) {
      final heart = HeartComponent(Vector2(rx(), y - 80))
        ..position = Vector2(rx(), y - 80)
        ..priority = 5;
      hearts.add(heart);
      levelContainer.add(heart);
    } else if (_random.nextDouble() < 0.05) {
      final mag = MagnetComponent(Vector2(rx(), y - 80))
        ..position = Vector2(rx(), y - 80)
        ..priority = 5;
      magnets.add(mag);
      levelContainer.add(mag);
    } else if (_random.nextDouble() < 0.05) {
      final mb =
          MultiBallItem(
              Vector2(rx(), y - 80),
              ballCount: 1 + _random.nextInt(3),
            )
            ..position = Vector2(rx(), y - 80)
            ..priority = 5;
      multiBallItems.add(mb);
      levelContainer.add(mb);
    }

    final double patternWidth = usableWidth * 0.6;
    final double offsetRange = usableWidth - patternWidth;
    final double startX = barPadding + _random.nextDouble() * offsetRange;

    if (roll < 0.25) {
      // The Blockade: Horizontal line of small holes
      int count = 2 + (difficulty * 2).floor(); // 2 to 4 holes
      double spacing = patternWidth / (count + 1);
      for (int i = 0; i < count; i++) {
        double px = startX + spacing * (i + 1);
        final hole =
            HoleComponent(
                Vector2(px, y),
                34 + difficulty * 10,
                _random.nextDouble() * pi,
              )
              ..position = Vector2(px, y)
              ..priority = 1;
        holes.add(hole);
        levelContainer.add(hole);
      }
    } else if (roll < 0.50) {
      // The Gauntlet: 2 bumpers with a moving hole
      final double bx1 = startX + patternWidth * 0.2;
      final double bx2 = startX + patternWidth * 0.8;
      final b1 = BumperComponent(Vector2(bx1, y), 20)
        ..position = Vector2(bx1, y)
        ..priority = 2;
      final b2 = BumperComponent(Vector2(bx2, y), 20)
        ..position = Vector2(bx2, y)
        ..priority = 2;
      bumpers.add(b1);
      levelContainer.add(b1);
      bumpers.add(b2);
      levelContainer.add(b2);

      final double hx = startX + patternWidth / 2;
      final hole =
          HoleComponent(
              Vector2(hx, y),
              45,
              0,
              isMovingHole: true,
              moveRange: patternWidth * 0.4 + difficulty * 20,
              moveSpeed: 60 + difficulty * 80,
            )
            ..position = Vector2(hx, y)
            ..priority = 1;
      holes.add(hole);
      levelContainer.add(hole);
    } else if (roll < 0.70) {
      // The Vortex: Sucking hole with bumpers
      final double vx = startX + patternWidth / 2;
      final hole =
          HoleComponent(
              Vector2(vx, y),
              50 + difficulty * 20,
              0,
              isSuckingHole: true,
            )
            ..position = Vector2(vx, y)
            ..priority = 1;
      holes.add(hole);
      levelContainer.add(hole);

      if (difficulty > 0.3) {
        final b1 = BumperComponent(Vector2(vx - 60, y - 40), 15)
          ..position = Vector2(vx - 60, y - 40)
          ..priority = 2;
        final b2 = BumperComponent(Vector2(vx + 60, y + 40), 15)
          ..position = Vector2(vx + 60, y + 40)
          ..priority = 2;
        bumpers.add(b1);
        levelContainer.add(b1);
        bumpers.add(b2);
        levelContainer.add(b2);
      }
    } else if (roll < 0.90) {
      // Zig-Zag Path: Staggered holes
      final int count = 3 + (difficulty * 2).floor();
      for (int i = 0; i < count; i++) {
        final double zx = i.isEven
            ? startX + patternWidth * 0.2
            : startX + patternWidth * 0.8;
        final zy = y - i * 100.0;
        final hole =
            HoleComponent(
                Vector2(zx, zy),
                40 + difficulty * 15,
                _random.nextDouble() * pi,
              )
              ..position = Vector2(zx, zy)
              ..priority = 1;
        holes.add(hole);
        levelContainer.add(hole);
      }
    } else {
      // Small random hole
      final double nx = rx();
      final hole =
          HoleComponent(
              Vector2(nx, y),
              55 + difficulty * 15,
              _random.nextDouble() * pi,
            )
            ..position = Vector2(nx, y)
            ..priority = 1;
      holes.add(hole);
      levelContainer.add(hole);
    }
  }

  void _cullInfinityObstacles(double cullY) {
    // Holes reward points for each hole successfully passed.
    holes.removeWhere((hole) {
      if (hole.position.y > cullY) {
        hole.removeFromParent();
        return true;
      }
      return false;
    });

    // Bumpers
    bumpers.removeWhere((bumper) {
      if (bumper.position.y > cullY) {
        bumper.removeFromParent();
        return true;
      }
      return false;
    });

    // Coins
    coins.removeWhere((coin) {
      if (coin.position.y > cullY) {
        coin.removeFromParent();
        return true;
      }
      return false;
    });

    // Hearts
    hearts.removeWhere((heart) {
      if (heart.position.y > cullY) {
        heart.removeFromParent();
        return true;
      }
      return false;
    });

    multiBallItems.removeWhere((mb) {
      if (mb.position.y > cullY) {
        mb.removeFromParent();
        return true;
      }
      return false;
    });

    // Magnets
    magnets.removeWhere((mag) {
      if (mag.position.y > cullY) {
        mag.removeFromParent();
        return true;
      }
      return false;
    });
  }

  Future<void> _loadInfinityHighScore() async {
    try {
      final profile = await DatabaseHelper.instance.getPlayerProfile();
      infinityHighScore = profile.infinityHighScore;
    } catch (_) {}
  }

  Future<void> _saveInfinityScoreAndCoins() async {
    if (!isInfinityMode) return;
    final int finalScore = currentScore.value;
    final int finalCoins = collectedCoins.value;
    lastInfinityScore = finalScore;
    lastInfinityCoins = finalCoins;
    if (finalScore > infinityHighScore) {
      infinityHighScore = finalScore;
    }

    try {
      final profile = await DatabaseHelper.instance.getPlayerProfile();
      final newCoins = profile.coins + finalCoins;
      final newHighScore = finalScore > profile.infinityHighScore
          ? finalScore
          : profile.infinityHighScore;

      await DatabaseHelper.instance.updatePlayerProfile(
        profile.copyWith(coins: newCoins, infinityHighScore: newHighScore),
      );

      infinityHighScore = newHighScore;
    } catch (e) {
      print("DEBUG: Failed to save coins or high score: $e");
    } finally {
      currentScore.value = 0;
      collectedCoins.value = 0;
    }
  }
}
