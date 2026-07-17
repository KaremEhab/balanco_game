import 'dart:isolate';
import 'dart:math';
import 'dart:io';
import 'dart:collection';
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:uuid/uuid.dart';

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
import 'package:balanco_game/features/game/components/shooter_helper_component.dart';
import 'package:balanco_game/features/game/components/shooter_projectile_component.dart';
import 'package:balanco_game/features/game/components/villains/villain_component.dart';
import 'package:balanco_game/features/game/components/game_background/darkness_component.dart';

import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/features/game/level_generator.dart';
import 'package:balanco_game/features/game/data/premade_levels.dart';
import 'package:balanco_game/features/game/data/online_level_repository.dart';
import 'package:balanco_game/features/game/level_system/campaign_level_repository.dart';
import 'package:balanco_game/features/game/level_system/level_debug_overlay.dart';
import 'package:balanco_game/features/game/level_system/level_definition_adapter.dart';
import 'package:balanco_game/features/game/level_system/level_definition.dart';
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
  final int? randomSeed;
  final Color? raceBallTint;
  final bool enableTutorials;
  final bool isRaceMode;
  int? onlineLevelVersion;

  VoidCallback? onGameOver;
  VoidCallback? onLevelComplete;

  bool isDarknessLevel = false;
  final ValueNotifier<bool> isDarknessLevelNotifier = ValueNotifier<bool>(
    false,
  );
  bool isWinningDarkLevel = false;
  double darknessRevealProgress = 0.0;
  double darknessBaseLightRadius = 160.0;
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
      ? BiomeConfig.getDynamicScoreBiome((currentScore.value ~/ 100) * 100)
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
  final ValueNotifier<int> remainingRaceBoosts = ValueNotifier<int>(2);
  final ValueNotifier<double> raceBoostTimerNotifier = ValueNotifier<double>(
    0.0,
  );
  double raceBoostTimer = 0.0;
  bool get isRaceBoostActive => raceBoostTimer > 0;

  bool _hasGameLayout = false;
  bool get isLayoutReady => _hasGameLayout;
  double _raceBarBottomInset = 60.0;

  void configureRaceBarBottomInset(double inset) {
    if (!isRaceMode) return;
    final nextInset = inset.clamp(60.0, 180.0);

    // RacePortraitMatchView knows the HUD geometry before Flame receives its
    // first onGameResize callback. Keep that configuration, but do not touch
    // size-backed getters until the game has a canvas layout.
    if (!_hasGameLayout) {
      _raceBarBottomInset = nextInset;
      return;
    }

    final oldBottomY = _barBottomY;
    final wasAtStart =
        (leftY - oldBottomY).abs() < 1.5 &&
        (rightY - oldBottomY).abs() < 1.5 &&
        countdownTimer > 0;
    _raceBarBottomInset = nextInset;
    if (wasAtStart) _placeRaceBallAtStart();
  }

  double get raceProgress {
    if (!_hasGameLayout) return 0.0;
    if (isInfinityMode || levelHeight <= 230) return 0.0;
    final startY = _barBottomY;
    final finishY = 70.0;
    final barY = (leftY + rightY) / 2.0;
    return ((startY - barY) / (startY - finishY)).clamp(0.0, 1.0);
  }

  bool activateShield() {
    if (remainingShields.value <= 0 || isShieldActive) return false;
    remainingShields.value -= 1;
    shieldTimer = 5.0;
    shieldTimerNotifier.value = shieldTimer;
    return true;
  }

  bool activateRaceBoost() {
    if (remainingRaceBoosts.value <= 0 || isRaceBoostActive) return false;
    remainingRaceBoosts.value -= 1;
    raceBoostTimer = 4.0;
    raceBoostTimerNotifier.value = raceBoostTimer;
    return true;
  }

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
  bool get hasActiveVillain => villains.any((villain) => !villain.isDefeated);

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
  int levelBombCount = 0;
  int spawnedClassicBombs = 0;
  bool hasSpawnedBombInClassic = false;
  double praiseCooldown = 0.0;

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
  final Queue<HoleBehavior> _recentInfinityPrimaryBehaviors = Queue();
  late Random _random;
  late Random _worldRandom;
  bool _isCoopReplica = false;
  bool _hasCoopSnapshot = false;
  Map<String, dynamic>? _coopSnapshot;
  Map<String, dynamic>? _previousCoopSnapshot;
  double _coopSnapshotAgeSeconds = 0.0;
  final ValueNotifier<int> coopReplicaFrameNotifier = ValueNotifier<int>(0);
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
  final List<ShooterHelperComponent> shooterHelpers = [];
  final List<VillainComponent> villains = [];
  bool shooterActive = false;
  double shooterFireTimer = 0.0;
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
      leftY = levelHeight - 160.0;
      rightY = levelHeight - 160.0;
      if (activeBalls.isNotEmpty) {
        activeBalls.first.pos2D.y = leftY - (16.0 + 6.0); // ballRadius is 16
      }
      cameraOffsetY = max(0.0, levelHeight - size.y);
      cameraOffsetYNotifier.value = cameraOffsetY;
    }
  }

  double get levelHeight =>
      isInfinityMode ? 999999.0 : size.y * currentHeightMultiplier;

  double get _barBottomY =>
      levelHeight - (isRaceMode ? _raceBarBottomInset : 160.0);

  final ValueNotifier<PositionComponent?> selectedEditComponent = ValueNotifier(
    null,
  );

  // --- Tutorials ---
  final Queue<String> _tutorialQueue = Queue<String>();
  final Set<String> _queuedTutorials = {};
  final ValueNotifier<String?> currentTutorial = ValueNotifier<String?>(null);

  void queueTutorial(String itemId) async {
    if (!enableTutorials) return;
    if (_queuedTutorials.contains(itemId) || _tutorialQueue.contains(itemId)) {
      return;
    }
    _queuedTutorials.add(itemId);

    if (!await DatabaseHelper.instance.hasSeenTutorial(itemId)) {
      await DatabaseHelper.instance.markTutorialSeen(itemId);
      _tutorialQueue.add(itemId);
      _checkTutorialQueue();
    }
  }

  void _checkTutorialQueue() {
    if (currentTutorial.value != null) return;
    if (_tutorialQueue.isNotEmpty) {
      pauseEngine();
      currentTutorial.value = _tutorialQueue.removeFirst();
    }
  }

  void closeTutorial() {
    currentTutorial.value = null;
    if (_tutorialQueue.isNotEmpty) {
      _checkTutorialQueue();
    } else {
      resumeEngine();
    }
  }

  BalancoGame({
    required this.isMultiplayer,
    this.isInfinityMode = false,
    this.isEditMode = false,
    required this.playerRole,
    this.randomSeed,
    this.raceBallTint,
    this.enableTutorials = true,
    this.isRaceMode = false,
    this.onlineLevelVersion,
    this.onGameOver,
    this.onLevelComplete,
  }) {
    _random = Random(randomSeed);
    _worldRandom = Random((randomSeed ?? 0) ^ 0x5F3759DF);
  }

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

    if (type == EditorItemType.teleporter && teleporters.length >= 2) {
      _showPraiseText(
        'Max 1 Teleporter Pair!',
        color: GameColors.red300,
        force: true,
      );
      return;
    }

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
          suckRadius: hData.suckRadius,
          isMovingHole: hData.isMovingHole,
          moveRange: hData.moveRange,
          moveSpeed: hData.moveSpeed,
          behavior: hData.behavior,
          warningDuration: hData.warningDuration,
          activeDuration: hData.activeDuration,
          recoveryDuration: hData.recoveryDuration,
          forceStrength: hData.forceStrength,
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
          suckRadius: hData.suckRadius,
          isMovingHole: hData.isMovingHole,
          moveRange: hData.moveRange,
          moveSpeed: hData.moveSpeed,
          behavior: hData.behavior,
          warningDuration: hData.warningDuration,
          activeDuration: hData.activeDuration,
          recoveryDuration: hData.recoveryDuration,
          forceStrength: hData.forceStrength,
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
          suckRadius: hData.suckRadius,
          isMovingHole: hData.isMovingHole,
          moveRange: hData.moveRange,
          moveSpeed: hData.moveSpeed,
          behavior: hData.behavior,
          warningDuration: hData.warningDuration,
          activeDuration: hData.activeDuration,
          recoveryDuration: hData.recoveryDuration,
          forceStrength: hData.forceStrength,
        )..priority = 1;
        holes.add(newComp as HoleComponent);
        break;
      case EditorItemType.nailHole:
        newComp = HoleComponent(
          Vector2.zero(),
          76,
          0,
          behavior: HoleBehavior.nailLauncher,
          warningDuration: 0.8,
          activeDuration: 2.2,
        )..priority = 1;
        holes.add(newComp as HoleComponent);
        break;
      case EditorItemType.splittingHole:
        newComp = HoleComponent(
          Vector2.zero(),
          80,
          0,
          behavior: HoleBehavior.split,
          activeDuration: 1.5,
          recoveryDuration: 1.0,
        )..priority = 1;
        holes.add(newComp as HoleComponent);
        break;
      case EditorItemType.orbitingHole:
        newComp = HoleComponent(
          Vector2.zero(),
          80,
          0,
          behavior: HoleBehavior.orbit,
          moveRange: 0.25,
          moveSpeed: 1.5,
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
      case EditorItemType.shooterHelper:
        newComp = ShooterHelperComponent(Vector2.zero())..priority = 5;
        shooterHelpers.add(newComp as ShooterHelperComponent);
        break;
      case EditorItemType.villain:
        newComp = VillainComponent(position: Vector2.zero(), size: 88)
          ..priority = 8;
        villains.add(newComp as VillainComponent);
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
      if (comp is ShooterHelperComponent) shooterHelpers.remove(comp);
      if (comp is VillainComponent) villains.remove(comp);

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
    for (final helper in shooterHelpers) {
      if (helper.parent != null) helper.removeFromParent();
    }
    shooterHelpers.clear();
    for (final villain in villains) {
      if (villain.parent != null) villain.removeFromParent();
    }
    villains.clear();
    shooterActive = false;
    shooterFireTimer = 0;

    if (templateLevelId == -1) {
      // Blank Canvas
      currentHeightMultiplier = 1.0;
    } else {
      if (PremadeLevels.levelsJson.containsKey(templateLevelId)) {
        final jsonStr = PremadeLevels.levelsJson[templateLevelId]!;
        final data = LevelData.fromJson(jsonDecode(jsonStr));
        currentHeightMultiplier = data.heightMultiplier;
        isDarknessLevel = data.isDarkLevel;
        isDarknessLevelNotifier.value = isDarknessLevel;
        darknessOpacityNotifier.value = isDarknessLevel ? 0.94 : 0.0;
        levelHasBomb = data.hasBomb;
        levelBombCount = data.bombCount;
        levelTimer = data.timerSeconds;

        // Populate
        for (final hData in data.holes) {
          final hole = HoleComponent(
            hData.position.clone(),
            hData.size,
            hData.rotation,
            isSuckingHole: hData.isSuckingHole,
            suckRadius: hData.suckRadius,
            isMovingHole: hData.isMovingHole,
            moveRange: hData.moveRange,
            moveSpeed: hData.moveSpeed,
            moveAxis: hData.moveAxis,
            behavior: hData.behavior,
            warningDuration: hData.warningDuration,
            activeDuration: hData.activeDuration,
            recoveryDuration: hData.recoveryDuration,
            forceStrength: hData.forceStrength,
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
      } else {
        final campaignLevel = await CampaignLevelRepository.instance.loadLevel(
          templateLevelId,
        );
        if (campaignLevel != null) {
          final data = campaignLevel.toLevelData();
          currentHeightMultiplier = data.heightMultiplier;
          isDarknessLevel = data.isDarkLevel;
          isDarknessLevelNotifier.value = isDarknessLevel;
          darknessOpacityNotifier.value = isDarknessLevel ? 0.94 : 0.0;
          levelHasBomb = data.hasBomb;
          levelBombCount = data.bombCount;
          levelTimer = data.timerSeconds;

          for (final hData in data.holes) {
            final hole = HoleComponent(
              hData.position.clone(),
              hData.size,
              hData.rotation,
              isSuckingHole: hData.isSuckingHole,
              suckRadius: hData.suckRadius,
              isMovingHole: hData.isMovingHole,
              moveRange: hData.moveRange,
              moveSpeed: hData.moveSpeed,
              moveAxis: hData.moveAxis,
              behavior: hData.behavior,
              warningDuration: hData.warningDuration,
              activeDuration: hData.activeDuration,
              recoveryDuration: hData.recoveryDuration,
              forceStrength: hData.forceStrength,
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
              'moveAxis': h.moveAxis,
              'behavior': h.behavior.name,
              'warningDuration': h.warningDuration,
              'activeDuration': h.activeDuration,
              'recoveryDuration': h.recoveryDuration,
              'forceStrength': h.forceStrength,
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
              'size': b.radius * b.scale.x,
            },
          )
          .toList(),
      'teleporters': teleporters
          .map(
            (t) => {
              'x': t.position.x / size.x,
              'y': (t.position.y - 120.0) / (levelHeight - 320.0),
              'size': t.radius * t.scale.x,
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
      'shooterHelpers': shooterHelpers
          .map(
            (helper) => {
              'x': helper.position.x / size.x,
              'y': (helper.position.y - 120.0) / (levelHeight - 320.0),
            },
          )
          .toList(),
      'villains': villains
          .map(
            (villain) => {
              'x': villain.position.x / size.x,
              'y': (villain.position.y - 120.0) / (levelHeight - 320.0),
              'size': villain.size.x,
              'variant': villain.variant,
              'health': villain.maxHealth,
            },
          )
          .toList(),
      'heightMultiplier': currentHeightMultiplier,
      'timeLimitSeconds': levelTimer.toInt(), // Add this!
      'timerSeconds': levelTimer, // Add this!
      'hasBomb': levelHasBomb,
      'bombCount': levelBombCount,
      'isDarkLevel': isDarknessLevel,
      if (currentLevelData?.themeId != null)
        'themeId': currentLevelData!.themeId,
      if (currentLevelData?.generationSeed != null)
        'generationSeed': currentLevelData!.generationSeed,
      if (currentLevelData?.difficulty != null)
        'difficulty': currentLevelData!.difficulty,
      'safePath': (currentLevelData?.safePath ?? const <Vector2>[])
          .map((point) => {'x': point.x, 'y': point.y})
          .toList(),
      'safeCorridorWidth': currentLevelData?.safeCorridorWidth ?? 0.3,
      'darknessLightRadius': currentLevelData?.darknessLightRadius ?? 65.0,
      'darknessStartLitSeconds':
          currentLevelData?.darknessStartLitSeconds ?? 0.0,
      'isNightmare': currentLevelData?.isNightmare ?? false,
    };

    // We should encode to JSON, import dart:convert at the top.
    return jsonEncode(data);
  }

  void reset() {
    currentLevel.value = 1;
    restartCurrentLevel();
  }

  Future<void> restartCurrentLevel() async {
    debugPrint(
      "DEBUG: restartCurrentLevel called. Level: ${currentLevel.value}",
    );
    isSpawningLevel = true;
    isBoardHidden = false;
    isLevelCompleteOverlayShown = false;
    showVictoryOverlay.value = false;
    showGameOverOverlay.value = false;
    currentPoints.value = 0;
    earnedLevelPoints.value = 0;
    if (isInfinityMode) {
      currentScore.value = 0;
      collectedCoins.value = 0;
      lastInfinityScore = 0;
      lastInfinityCoins = 0;
      nextInfinityChunkBoundaryY = 0.0;
      _recentInfinityPrimaryBehaviors.clear();
      if (isMultiplayer) {
        remainingShields.value = 3;
        shieldTimer = 0.0;
        shieldTimerNotifier.value = 0.0;
      }
    }
    currentLives.value = isInfinityMode ? 1 : 3;
    children.whereType<ConfettiComponent>().forEach(
      (c) => c.removeFromParent(),
    );
    _resetPositions();
    debugPrint("DEBUG: generateLevel starts");
    await generateLevel();
    debugPrint("DEBUG: generateLevel finishes, resuming engine");
    resumeEngine();
  }

  Future<void> restartCoopRun(int seed) async {
    _random = Random(seed);
    _worldRandom = Random(seed ^ 0x5F3759DF);
    _hasCoopSnapshot = false;
    _coopSnapshot = null;
    _previousCoopSnapshot = null;
    _coopSnapshotAgeSeconds = 0.0;
    await restartCurrentLevel();
  }

  Future<void> restartRaceRun(int seed) async {
    remainingShields.value = 3;
    shieldTimer = 0;
    shieldTimerNotifier.value = 0;
    remainingRaceBoosts.value = 2;
    raceBoostTimer = 0;
    raceBoostTimerNotifier.value = 0;
    await restartCoopRun(seed);
  }

  void enableCoopReplica() {
    _isCoopReplica = true;
  }

  bool get isCoopReplica => _isCoopReplica;

  Map<String, dynamic> createCoopSnapshot() => {
    'world_width': size.x,
    'world_height': size.y,
    'left_y': leftY,
    'right_y': rightY,
    'camera_y': cameraOffsetY,
    'score': currentScore.value,
    'points': currentPoints.value,
    'coins': collectedCoins.value,
    'lives': currentLives.value,
    'game_over': showGameOverOverlay.value,
    'board_hidden': isBoardHidden,
    'countdown': countdownTimer,
    'gate_closing': teleportingGateComponent.isClosing,
    'gate_opening': teleportingGateComponent.isOpening,
    'gate_closed': teleportingGateComponent.isClosed,
    'shields': remainingShields.value,
    'shield_time': shieldTimer,
    'boosts': remainingRaceBoosts.value,
    'boost_time': raceBoostTimer,
    'balls': activeBalls
        .map(
          (ball) => {
            'x': ball.pos2D.x,
            'y': ball.pos2D.y,
            'velocity': ball.velocity,
            'free_fall_x': ball.freeFallVelocity.x,
            'free_fall_y': ball.freeFallVelocity.y,
            'p': ball.p,
            'scale': ball.scale,
            'is_falling': ball.isFalling,
            'is_falling_in_hole': ball.isFallingInHole,
            'is_free_falling': ball.isFreeFalling,
            'is_respawning_from_hole': ball.isRespawningFromHole,
            'is_respawning_from_edge': ball.isRespawningFromEdge,
            'is_sucking_to_gate': ball.isSuckingToGate,
            'is_dead': ball.isDead,
            'respawn_timer': ball.respawnTimer,
            'hole_immunity_timer': ball.holeImmunityTimer,
            'squash_x': ball.squashX,
            'squash_y': ball.squashY,
            'bounce_timer': ball.bounceTimer,
            'active_hole_index': ball.activeHole == null
                ? -1
                : holes.indexOf(ball.activeHole!),
            'fall_rotation': ball.fallRotation,
          },
        )
        .toList(),
    'holes': holes
        .map((hole) => {'x': hole.position.x, 'y': hole.position.y})
        .toList(),
    'stars_collected': stars.map((star) => star.isCollected).toList(),
    'hearts_collected': hearts.map((heart) => heart.isCollected).toList(),
    'multi_balls_collected': multiBallItems
        .map((item) => item.isCollected)
        .toList(),
    'magnets_collected': magnets.map((magnet) => magnet.isCollected).toList(),
    'bombs': levelContainer.children
        .whereType<BombComponent>()
        .map((bomb) => {'x': bomb.position.x, 'y': bomb.position.y})
        .toList(),
    'bomb_warnings': levelContainer.children
        .whereType<BombWarningComponent>()
        .map((warning) => {'x': warning.position.x, 'y': warning.position.y})
        .toList(),
  };

  void applyCoopSnapshot(Map<String, dynamic> snapshot) {
    _previousCoopSnapshot = _coopSnapshot;
    _coopSnapshot = Map<String, dynamic>.from(snapshot);
    _coopSnapshotAgeSeconds = 0.0;
  }

  void _updateCoopReplica(double dt) {
    final snapshot = _coopSnapshot;
    if (snapshot == null) return;

    _coopSnapshotAgeSeconds += dt;

    final firstFrame = !_hasCoopSnapshot;
    _hasCoopSnapshot = true;
    final barBlend = firstFrame ? 1.0 : 1.0 - exp(-18.0 * dt);
    final objectBlend = firstFrame ? 1.0 : 1.0 - exp(-20.0 * dt);
    final cameraBlend = firstFrame ? 1.0 : 1.0 - exp(-14.0 * dt);

    double blend(double current, dynamic target, double amount) =>
        current + ((target as num).toDouble() - current) * amount;
    final hostWidth = (snapshot['world_width'] as num?)?.toDouble() ?? size.x;
    final hostHeight = (snapshot['world_height'] as num?)?.toDouble() ?? size.y;
    final scaleX = hostWidth <= 0 ? 1.0 : size.x / hostWidth;
    final scaleY = hostHeight <= 0 ? 1.0 : size.y / hostHeight;
    double x(dynamic value) => (value as num).toDouble() * scaleX;
    double y(dynamic value) => (value as num).toDouble() * scaleY;

    final previous = _previousCoopSnapshot;
    final sentAt = snapshot['sent_at'] as int?;
    final previousSentAt = previous?['sent_at'] as int?;
    final snapshotInterval = sentAt != null && previousSentAt != null
        ? (sentAt - previousSentAt) / Duration.microsecondsPerSecond
        : 0.0;
    final predictionTime = min(_coopSnapshotAgeSeconds, 0.10);

    double predict(dynamic current, dynamic previousValue) {
      final currentValue = (current as num).toDouble();
      if (previousValue is! num ||
          snapshotInterval <= 0.005 ||
          snapshotInterval > 0.5) {
        return currentValue;
      }
      final velocity =
          (currentValue - previousValue.toDouble()) / snapshotInterval;
      final predictedDelta = (velocity * predictionTime).clamp(-48.0, 48.0);
      return currentValue + predictedDelta;
    }

    dynamic previousValue(String key) => previous?[key];

    final predictedLeftY = y(
      predict(snapshot['left_y'], previousValue('left_y')),
    ).clamp(10.0, _barBottomY);
    final predictedRightY = y(
      predict(snapshot['right_y'], previousValue('right_y')),
    ).clamp(10.0, _barBottomY);
    var predictedCameraY = y(
      predict(snapshot['camera_y'], previousValue('camera_y')),
    );
    if (!isInfinityMode) {
      predictedCameraY = predictedCameraY.clamp(
        0.0,
        max(0.0, levelHeight - size.y),
      );
    }

    leftY = blend(leftY, predictedLeftY, barBlend);
    rightY = blend(rightY, predictedRightY, barBlend);
    cameraOffsetY = blend(cameraOffsetY, predictedCameraY, cameraBlend);
    cameraOffsetYNotifier.value = cameraOffsetY;
    levelContainer.position.y = -cameraOffsetY;

    currentScore.value = snapshot['score'] as int;
    currentPoints.value = snapshot['points'] as int? ?? 0;
    collectedCoins.value = snapshot['coins'] as int;
    currentLives.value = snapshot['lives'] as int;
    isBoardHidden = snapshot['board_hidden'] as bool? ?? false;
    countdownTimer = (snapshot['countdown'] as num).toDouble();
    countdownNotifier.value = countdownTimer.ceil();
    remainingShields.value = snapshot['shields'] as int? ?? 3;
    shieldTimer = (snapshot['shield_time'] as num?)?.toDouble() ?? 0.0;
    shieldTimerNotifier.value = shieldTimer;
    remainingRaceBoosts.value = snapshot['boosts'] as int? ?? 2;
    raceBoostTimer = (snapshot['boost_time'] as num?)?.toDouble() ?? 0.0;
    raceBoostTimerNotifier.value = raceBoostTimer;
    teleportingGateComponent.applyReplicaState(
      closing: snapshot['gate_closing'] as bool? ?? false,
      opening: snapshot['gate_opening'] as bool? ?? false,
      closed: snapshot['gate_closed'] as bool? ?? false,
    );

    final remoteBalls = snapshot['balls'] as List? ?? const [];
    final previousBalls = previous?['balls'] as List? ?? const [];
    _matchReplicaBallCount(remoteBalls.length);
    for (var index = 0; index < remoteBalls.length; index++) {
      final remote = Map<String, dynamic>.from(remoteBalls[index] as Map);
      final previousBall = index < previousBalls.length
          ? Map<String, dynamic>.from(previousBalls[index] as Map)
          : const <String, dynamic>{};
      final ball = activeBalls[index];
      ball.pos2D.x = blend(
        ball.pos2D.x,
        x(predict(remote['x'], previousBall['x'])),
        objectBlend,
      );
      ball.pos2D.y = blend(
        ball.pos2D.y,
        y(predict(remote['y'], previousBall['y'])),
        objectBlend,
      );
      ball.velocity = (remote['velocity'] as num).toDouble();
      ball.freeFallVelocity.x = (remote['free_fall_x'] as num).toDouble();
      ball.freeFallVelocity.y = (remote['free_fall_y'] as num).toDouble();
      ball.p = (remote['p'] as num).toDouble();
      ball.scale = blend(ball.scale, remote['scale'], objectBlend);
      ball.isFalling = remote['is_falling'] as bool;
      ball.isFallingInHole = remote['is_falling_in_hole'] as bool? ?? false;
      ball.isFreeFalling = remote['is_free_falling'] as bool;
      ball.isRespawningFromHole =
          remote['is_respawning_from_hole'] as bool? ?? false;
      ball.isRespawningFromEdge =
          remote['is_respawning_from_edge'] as bool? ?? false;
      ball.isSuckingToGate = remote['is_sucking_to_gate'] as bool? ?? false;
      ball.isDead = remote['is_dead'] as bool;
      ball.respawnTimer = (remote['respawn_timer'] as num?)?.toDouble() ?? 0.0;
      ball.holeImmunityTimer =
          (remote['hole_immunity_timer'] as num?)?.toDouble() ?? 0.0;
      ball.squashX = blend(
        ball.squashX,
        remote['squash_x'] ?? 1.0,
        objectBlend,
      );
      ball.squashY = blend(
        ball.squashY,
        remote['squash_y'] ?? 1.0,
        objectBlend,
      );
      ball.bounceTimer = (remote['bounce_timer'] as num?)?.toDouble() ?? 0.0;
      final activeHoleIndex = remote['active_hole_index'] as int? ?? -1;
      ball.activeHole = activeHoleIndex >= 0 && activeHoleIndex < holes.length
          ? holes[activeHoleIndex]
          : null;
      ball.fallRotation = (remote['fall_rotation'] as num).toDouble();
    }

    final worldReady =
        isInfinityMode && currentLevelData != null && nextSpawnY != 0.0;
    if (worldReady) {
      _ensureInfinityWorldForBar((leftY + rightY) / 2.0);
    }

    final remoteStars = snapshot['stars_collected'] as List? ?? const [];
    for (
      var index = 0;
      index < min(stars.length, remoteStars.length);
      index++
    ) {
      stars[index].isCollected = remoteStars[index] as bool;
    }
    final remoteHearts = snapshot['hearts_collected'] as List? ?? const [];
    for (
      var index = 0;
      index < min(hearts.length, remoteHearts.length);
      index++
    ) {
      hearts[index].isCollected = remoteHearts[index] as bool;
    }
    final remoteMultiBalls =
        snapshot['multi_balls_collected'] as List? ?? const [];
    for (
      var index = 0;
      index < min(multiBallItems.length, remoteMultiBalls.length);
      index++
    ) {
      multiBallItems[index].isCollected = remoteMultiBalls[index] as bool;
    }
    final remoteMagnets = snapshot['magnets_collected'] as List? ?? const [];
    for (
      var index = 0;
      index < min(magnets.length, remoteMagnets.length);
      index++
    ) {
      magnets[index].isCollected = remoteMagnets[index] as bool;
    }
    final remoteHoles = snapshot['holes'] as List? ?? const [];
    final previousHoles = previous?['holes'] as List? ?? const [];
    final holeCount = min(holes.length, remoteHoles.length);
    for (var index = 0; index < holeCount; index++) {
      final remote = Map<String, dynamic>.from(remoteHoles[index] as Map);
      final previousHole = index < previousHoles.length
          ? Map<String, dynamic>.from(previousHoles[index] as Map)
          : const <String, dynamic>{};
      holes[index].position.x = blend(
        holes[index].position.x,
        x(predict(remote['x'], previousHole['x'])),
        objectBlend,
      );
      holes[index].position.y = blend(
        holes[index].position.y,
        y(predict(remote['y'], previousHole['y'])),
        objectBlend,
      );
    }
    if (worldReady) {
      _cullInfinityObstacles((leftY + rightY) / 2.0 + 600.0);
    }

    final remoteBombs = snapshot['bombs'] as List? ?? const [];
    final previousBombs = previous?['bombs'] as List? ?? const [];
    final localBombs = _matchReplicaBombCount(remoteBombs.length);
    for (var index = 0; index < remoteBombs.length; index++) {
      final remote = Map<String, dynamic>.from(remoteBombs[index] as Map);
      final previousBomb = index < previousBombs.length
          ? Map<String, dynamic>.from(previousBombs[index] as Map)
          : const <String, dynamic>{};
      localBombs[index].position.x = blend(
        localBombs[index].position.x,
        x(predict(remote['x'], previousBomb['x'])),
        objectBlend,
      );
      localBombs[index].position.y = blend(
        localBombs[index].position.y,
        y(predict(remote['y'], previousBomb['y'])),
        objectBlend,
      );
    }

    final remoteWarnings = snapshot['bomb_warnings'] as List? ?? const [];
    final localWarnings = _matchReplicaWarningCount(remoteWarnings.length);
    for (var index = 0; index < remoteWarnings.length; index++) {
      final remote = Map<String, dynamic>.from(remoteWarnings[index] as Map);
      localWarnings[index].position.x = x(remote['x']);
      localWarnings[index].position.y = y(remote['y']);
    }
    coopReplicaFrameNotifier.value++;
  }

  List<BombComponent> _matchReplicaBombCount(int count) {
    final bombs = levelContainer.children.whereType<BombComponent>().toList();
    while (bombs.length < count) {
      final bomb = BombComponent(Vector2.zero(), replicaOnly: true)
        ..priority = 100;
      bombs.add(bomb);
      levelContainer.add(bomb);
    }
    while (bombs.length > count) {
      bombs.removeLast().removeFromParent();
    }
    return bombs;
  }

  List<BombWarningComponent> _matchReplicaWarningCount(int count) {
    final warnings = levelContainer.children
        .whereType<BombWarningComponent>()
        .toList();
    while (warnings.length < count) {
      final warning = BombWarningComponent(replicaOnly: true)..priority = 100;
      warnings.add(warning);
      levelContainer.add(warning);
    }
    while (warnings.length > count) {
      warnings.removeLast().removeFromParent();
    }
    return warnings;
  }

  void _matchReplicaBallCount(int count) {
    while (activeBalls.length < count) {
      final ball = BallData();
      final component = BallComponent(ball)..priority = 20;
      activeBalls.add(ball);
      activeBallComponents.add(component);
      levelContainer.add(component);
    }
    while (activeBalls.length > count) {
      final ball = activeBalls.removeLast();
      final component = activeBallComponents.firstWhere(
        (value) => value.ballData == ball,
      );
      component.removeFromParent();
      activeBallComponents.remove(component);
    }
  }

  void startNextLevel() {
    currentLevel.value++;
    restartCurrentLevel();
  }

  Future<void> advanceToNextLevel() async {
    debugPrint("DEBUG: advanceToNextLevel called");
    showVictoryOverlay.value = false;
    showGameOverOverlay.value = false;
    isLevelCompleteOverlayShown = false;

    currentLevel.value++;
    await restartCurrentLevel();
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
    debugPrint(
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
      final bottomOffset = isRaceMode ? _raceBarBottomInset : 160.0;
      leftY = currentLevelHeight - bottomOffset;
      rightY = currentLevelHeight - bottomOffset;
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
    isWinningDarkLevel = false;
    darknessRevealProgress = 0.0;
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
        // Infinity score is a pure survival/progress record; falling should
        // end or reset the run state without subtracting points already earned.
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

    if (isRaceMode && isSpawningLevel) {
      teleportingGateComponent.reset();
      final barCenterY = (leftY + rightY) / 2.0;
      mainBall.pos2D = Vector2(
        currentSizeX / 2.0,
        barCenterY - (ballRadius + 6.0),
      );
      mainBall.scale = 1.0;
      mainBall.spawnTimer = 0.0;
      mainBall.isFreeFalling = false;
      mainBall.velocity = 0.0;
      mainBall.freeFallVelocity.setZero();
      mainBall.holeImmunityTimer = 1.5;
      cameraOffsetY = max(0.0, currentLevelHeight - size.y);
      cameraOffsetYNotifier.value = cameraOffsetY;
    } else if (isEditMode) {
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
      shieldTimer = isMultiplayer ? 0.0 : 2.0;
      shieldTimerNotifier.value = shieldTimer;
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
      shieldTimer = isMultiplayer ? 0.0 : 1.5;
      shieldTimerNotifier.value = shieldTimer;
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
    _hasGameLayout = size.x > 0 && size.y > 0;
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
        'winner.wav',
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

    camera.viewport.add(DarknessComponent());

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
    for (final helper in shooterHelpers) {
      if (helper.parent != null) helper.removeFromParent();
    }
    shooterHelpers.clear();
    for (final villain in villains) {
      if (villain.parent != null) villain.removeFromParent();
    }
    villains.clear();
    shooterActive = false;
    shooterFireTimer = 0;

    // Offload level generation to an Isolate
    LevelData data;
    final int levelToGenerate = currentLevel.value;
    var isFallbackGeneratedLevel = false;

    if (isEditMode) {
      final customJsonStr = await DatabaseHelper.instance.getCustomLevel(
        levelToGenerate,
      );
      if (customJsonStr != null) {
        data = LevelData.fromJson(jsonDecode(customJsonStr));
      } else if (levelToGenerate == 0) {
        data = LevelData(
          holes: [],
          teleporters: [],
          bumpers: [],
          stars: [],
          hearts: [],
          multiBalls: [],
          magnets: [],
        );
      } else {
        final onlineLevel = await _loadOnlineLevel(levelToGenerate);
        if (onlineLevel != null) {
          data = onlineLevel;
        } else if (PremadeLevels.levelsJson.containsKey(levelToGenerate)) {
          final jsonStr = PremadeLevels.levelsJson[levelToGenerate]!;
          data = LevelData.fromJson(jsonDecode(jsonStr));
        } else {
          final campaignLevel = await CampaignLevelRepository.instance
              .loadLevel(levelToGenerate);
          data =
              campaignLevel?.toLevelData() ??
              LevelData(
                holes: [],
                teleporters: [],
                bumpers: [],
                stars: [],
                hearts: [],
                multiBalls: [],
                magnets: [],
              );
        }
      }
      isSpawningLevel = false;
      // Trigger setter to adjust camera and bar for the loaded height
      currentHeightMultiplier = data.heightMultiplier;
    } else if (isInfinityMode) {
      LevelData? infinityTemplate;
      // Online co-op must never depend on device-local editor data, because
      // two phones can have different level 0 templates.
      final infinityJsonStr = isMultiplayer
          ? null
          : await DatabaseHelper.instance.getCustomLevel(0);
      if (infinityJsonStr != null) {
        infinityTemplate = LevelData.fromJson(jsonDecode(infinityJsonStr));
      }
      data = LevelData(
        holes: [],
        teleporters: [],
        bumpers: [],
        stars: [],
        hearts: [],
        multiBalls: [],
        magnets: [],
        hasBomb: infinityTemplate?.hasBomb ?? true,
        bombCount: infinityTemplate?.bombCount ?? 0,
        isDarkLevel: infinityTemplate?.isDarkLevel ?? false,
        darknessLightRadius: infinityTemplate?.darknessLightRadius ?? 65.0,
        darknessStartLitSeconds:
            infinityTemplate?.darknessStartLitSeconds ?? 0.0,
      );
      // Start spawning just above the bar
      nextSpawnY = (size.y > 0 ? size.y : 800.0) - 250.0;
      if (infinityTemplate != null) {
        _spawnInfinityStarterTemplate(infinityTemplate);
      }
      // Pre-spawn a wave of obstacles immediately
      for (int i = 0; i < 8; i++) {
        _spawnInfinityObstaclePattern(nextSpawnY, 0.0);
        nextSpawnY -= 220.0 + _worldRandom.nextDouble() * 100.0;
      }
      nextInfinityChunkBoundaryY = nextSpawnY - 4000.0;
      _scatterStarsInChunk(nextSpawnY, nextInfinityChunkBoundaryY, 10);
      isSpawningLevel = false;

      queueTutorial('infinity_mode');
    } else {
      final onlineLevel = await _loadOnlineLevel(
        levelToGenerate,
        version: isRaceMode ? onlineLevelVersion : null,
      );
      if (onlineLevel != null) {
        data = onlineLevel;
      } else if (PremadeLevels.levelsJson.containsKey(levelToGenerate)) {
        final jsonStr = PremadeLevels.levelsJson[levelToGenerate]!;
        data = LevelData.fromJson(jsonDecode(jsonStr));
      } else {
        // Race must be identical on every phone. Device-local editor levels
        // are intentionally excluded from this authoritative mode.
        final customJsonStr = isRaceMode
            ? null
            : await DatabaseHelper.instance.getCustomLevel(levelToGenerate);
        if (customJsonStr != null) {
          data = LevelData.fromJson(jsonDecode(customJsonStr));
        } else {
          final campaignLevel = await CampaignLevelRepository.instance
              .loadLevel(levelToGenerate);
          if (campaignLevel != null) {
            data = campaignLevel.toLevelData();
          } else {
            final fallbackSeed = isRaceMode ? levelToGenerate * 104729 : null;
            data = await Isolate.run(
              () => generateLevelData(levelToGenerate, fallbackSeed),
            );
            isFallbackGeneratedLevel = true;
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

    if (levelToGenerate == 1 && !isInfinityMode && !isEditMode) {
      queueTutorial('joysticks');
      queueTutorial('shield');
    }

    if (levelToGenerate >= 15 && !isInfinityMode && !isEditMode) {
      queueTutorial('scrolling_level');
    }

    if (!isEditMode && !isInfinityMode) {
      // Race uses the exact authored campaign geometry. Stretching short
      // levels here used to move the finish gate and obstacles away from
      // their regular single-player positions.
      currentHeightMultiplierNotifier.value = data.heightMultiplier;

      // Now that we have the real height multiplier, fix the bar position if it was reset to the bottom
      if (barResetTimer == 0.0) {
        leftY = isRaceMode ? _barBottomY : levelHeight - 70.0;
        rightY = isRaceMode ? _barBottomY : levelHeight - 70.0;
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
    levelHasBomb = data.hasBomb;
    levelBombCount = data.bombCount > 0
        ? data.bombCount
        : (levelHasBomb ? 1 : 0);
    hasSpawnedBombInClassic = false;
    spawnedClassicBombs = 0;
    bombSpawnTimer = 0.0;
    nextBombSpawnThreshold = 15.0 + _random.nextDouble() * 10.0;

    isDarknessLevel =
        data.isDarkLevel || (isFallbackGeneratedLevel && levelToGenerate >= 11);
    isDarknessLevelNotifier.value = isDarknessLevel;
    darknessBaseLightRadius = data.darknessLightRadius.clamp(62.0, 90.0);
    lightRadiusNotifier.value = darknessBaseLightRadius;
    lightChargeTimer = 0.0;
    lightChargeTimerNotifier.value = 0.0;
    isIlluminated = false;
    isWinningDarkLevel = false;
    darknessRevealProgress = 0.0;
    darknessOpacityNotifier.value = isDarknessLevel ? 0.94 : 0.0;
    if (data.isNightmare) {
      _showPraiseText(
        'NIGHTMARE LEVEL',
        color: GameColors.orangeAccent,
        force: true,
      );
    }

    // Quickly spawn components back on the main thread using the pre-calculated data
    for (final hData in data.holes) {
      final hole = HoleComponent(
        hData.position.clone(), // Clone so we don't modify the data directly
        hData.size,
        hData.rotation,
        isSuckingHole: hData.isSuckingHole,
        suckRadius: hData.suckRadius,
        isMovingHole: hData.isMovingHole,
        moveRange: hData.moveRange,
        moveSpeed: hData.moveSpeed,
        moveAxis: hData.moveAxis,
        behavior: hData.behavior,
        warningDuration: hData.warningDuration,
        activeDuration: hData.activeDuration,
        recoveryDuration: hData.recoveryDuration,
        forceStrength: hData.forceStrength,
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

    for (final helperPos in data.shooterHelpers) {
      final helper = ShooterHelperComponent(helperPos)..priority = 5;
      final targetPos = Vector2(
        helperPos.x * size.x,
        120.0 + helperPos.y * (levelHeight - 320.0),
      );
      targetPositions[helper] = targetPos;
      helper.position = teleportingGateComponent.position.clone();
      helper.scale = Vector2.zero();
      pendingSpawns.add(helper);
      shooterHelpers.add(helper);
      levelContainer.add(helper);
    }

    for (final villainData in data.villains) {
      final targetPos = isEditMode
          ? Vector2(
              villainData.position.x * size.x,
              120.0 + villainData.position.y * (levelHeight - 320.0),
            )
          : teleportingGateComponent.position.clone();
      final villain = VillainComponent(
        position: teleportingGateComponent.position.clone(),
        size: villainData.size,
        variant: villainData.variant,
        health: villainData.health,
      )..priority = 8;
      targetPositions[villain] = targetPos;
      villain.scale = Vector2.zero();
      pendingSpawns.add(villain);
      villains.add(villain);
      levelContainer.add(villain);
      if (!isEditMode) queueTutorial('gatekeeper_villain');
    }

    if (isEditMode || _isCoopReplica || isRaceMode) {
      for (final comp in pendingSpawns) {
        comp.position = targetPositions[comp]!;
        comp.scale = Vector2.all(1.0);
      }
      pendingSpawns.clear();
      targetPositions.clear();
      isSpawningLevel = false;
    }

    if (isRaceMode) {
      _placeRaceBallAtStart();
    }
  }

  Future<LevelData?> _loadOnlineLevel(int levelId, {int? version}) async {
    final online = await OnlineLevelRepository.instance.loadLevel(
      levelId,
      version: version,
    );
    if (online == null || online.coordinateSpace != 'normalized_v1') {
      return null;
    }
    try {
      return switch (online.definitionFormat) {
        'campaign_v1' => LevelDefinition.fromJson(
          online.definition,
        ).toLevelData(),
        'level_data_v1' => LevelData.fromJson(online.definition),
        _ => null,
      };
    } catch (error) {
      debugPrint(
        'Online level $levelId is invalid; using bundled level: $error',
      );
      return null;
    }
  }

  void _placeRaceBallAtStart() {
    if (!_hasGameLayout) return;
    leftY = _barBottomY;
    rightY = _barBottomY;
    initialLeftY = leftY;
    initialRightY = rightY;
    barResetTimer = 0.0;
    cameraOffsetY = max(0.0, levelHeight - size.y);
    cameraOffsetYNotifier.value = cameraOffsetY;
    levelContainer.position.y = -cameraOffsetY;
    teleportingGateComponent.reset();
    if (activeBalls.isEmpty) return;
    final ball = activeBalls.first;
    ball.p = (size.x - 2 * barPadding) / 2.0;
    ball.pos2D = Vector2(size.x / 2.0, _barBottomY - (ballRadius + 6.0));
    ball.scale = 1.0;
    ball.spawnTimer = 0.0;
    ball.isFreeFalling = false;
    ball.isFalling = false;
    ball.velocity = 0.0;
    ball.freeFallVelocity.setZero();
    ball.holeImmunityTimer = 1.5;
    isSpawningLevel = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (size.x == 0 || size.y == 0) return;
    if (_isCoopReplica) {
      _updateCoopReplica(dt);
      return;
    }
    if (praiseCooldown > 0) {
      praiseCooldown = max(0.0, praiseCooldown - dt);
    }

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
    if (raceBoostTimer > 0) {
      raceBoostTimer = max(0.0, raceBoostTimer - dt);
      raceBoostTimerNotifier.value = raceBoostTimer;
    } else if (raceBoostTimerNotifier.value != 0.0) {
      raceBoostTimerNotifier.value = 0.0;
    }

    // Magnet Timer
    if (magnetTimer > 0) {
      magnetTimer -= dt;
      if (magnetTimer < 0) magnetTimer = 0.0;
      magnetTimerNotifier.value = magnetTimer;
    } else {
      if (magnetTimerNotifier.value != 0.0) magnetTimerNotifier.value = 0.0;
    }

    if (shooterActive && !isSpawningLevel && !isLevelCompleteOverlayShown) {
      final targets = villains.where((villain) => !villain.isDefeated).toList();
      if (targets.isNotEmpty && activeBalls.isNotEmpty) {
        final ball = activeBalls.first;
        if (!ball.isDead &&
            !ball.isRespawningFromHole &&
            !ball.isRespawningFromEdge &&
            !ball.isFallingInHole) {
          shooterFireTimer += dt;
          if (shooterFireTimer >= 0.48) {
            shooterFireTimer = 0;
            final target = targets.first;

            Vector2 direction = target.position - ball.pos2D;
            direction.normalize();

            double currentBarLength = Vector2(
              size.x - 2 * barPadding,
              rightY - leftY,
            ).length;
            double centerDist =
                (ball.p - (currentBarLength / 2)).abs() /
                (currentBarLength / 2);
            double speed = ball.velocity.abs() / 800.0;
            double inaccuracy =
                min(1.0, centerDist + speed) * (pi / 6); // Max +- 30 degrees

            if (inaccuracy > 0) {
              double randomAngle = (_random.nextDouble() * 2 - 1) * inaccuracy;
              double baseAngle = atan2(direction.y, direction.x);
              double newAngle = baseAngle + randomAngle;
              direction = Vector2(cos(newAngle), sin(newAngle));
            }

            levelContainer.add(
              ShooterProjectileComponent(
                position: ball.pos2D.clone(),
                direction: direction,
              )..priority = 85,
            );
            AppSettings.playSound('shooting-sound.wav', volume: 0.35);
          }
        }
      }
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
          if (levelHasBomb && bombSpawnTimer >= nextBombSpawnThreshold) {
            _spawnBombWarning();
            bombSpawnTimer = 0.0;
            // Decrease threshold slightly but randomize heavily for professional feel
            double newBase = max(10.0, nextBombSpawnThreshold - 1.0);
            nextBombSpawnThreshold = newBase + _random.nextDouble() * 5.0;
          }
        } else {
          if (levelHasBomb && spawnedClassicBombs < levelBombCount) {
            // Spawn quickly but randomly (between 5 and 10 seconds)
            double spawnTime = 5.0 + _random.nextDouble() * 5.0;
            if (bombSpawnTimer >= spawnTime) {
              _spawnBombWarning();
              spawnedClassicBombs++;
              hasSpawnedBombInClassic = spawnedClassicBombs >= levelBombCount;
              bombSpawnTimer = 0.0;
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
      if (!isInfinityMode) {
        targetCameraY = targetCameraY.clamp(
          0.0,
          max(0.0, levelHeight - size.y),
        );
      }
      cameraOffsetY += (targetCameraY - cameraOffsetY) * dt * 5.0;
      levelContainer.position.y = -cameraOffsetY;
      cameraOffsetYNotifier.value = cameraOffsetY;
      return; // Skip updating ball physics and scrolling during countdown
    } else if (countdownNotifier.value != 0) {
      countdownNotifier.value = 0;
    }

    double maxY = _barBottomY;
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
            baseSpeed *
            (isRaceBoostActive ? 1.35 : 1.0) *
            (!anyBallOnBar && anyPortalCatchWindow ? 0.60 : 1.0);
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
      if (isWinningDarkLevel) {
        darknessRevealProgress = min(1.0, darknessRevealProgress + dt / 1.15);
        final reveal = Curves.easeOutCubic.transform(darknessRevealProgress);
        final fullRadius = sqrt(size.x * size.x + size.y * size.y) * 1.08;
        lightRadiusNotifier.value =
            darknessBaseLightRadius +
            (fullRadius - darknessBaseLightRadius) * reveal;
        darknessOpacityNotifier.value = 0.94 * (1.0 - reveal);
      }

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

      if (!isWinningDarkLevel) {
        final targetRadius =
            darknessBaseLightRadius * (isIlluminated ? 3.0 : 1.0);
        lightRadiusNotifier.value +=
            (targetRadius - lightRadiusNotifier.value) * min(1.0, dt * 5.0);
        darknessOpacityNotifier.value +=
            (0.94 - darknessOpacityNotifier.value) * min(1.0, dt * 8.0);
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
      if (ball.activeHole != null && ball.activeHole!.hasForceField) {
        ball.fallRotation += dt * 25.0; // Rapid spin
        Vector2 delta = ball.fallTarget - ball.pos2D;
        double dist = delta.length;
        if (dist > 2.0) {
          Vector2 radial = delta / dist;
          Vector2 tangent = Vector2(-radial.y, radial.x);
          // Swirl inwards towards the center
          ball.pos2D += (radial * 160.0 + tangent * 200.0) * dt;
        } else {
          ball.pos2D.lerp(ball.fallTarget, dt * 15.0);
        }
        ball.scale -= dt * 0.65; // Slower fall (takes ~1.5 seconds)
      } else {
        ball.fallRotation += dt * 15.0; // Rapid spin
        ball.scale -= dt * 1.0; // Slower fall (takes 1 second)
        ball.pos2D.lerp(ball.fallTarget, dt * 5.0); // Slower pull to center
      }

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
            debugPrint(
              "DEBUG: showVictoryOverlay triggered from handleLevelCompletion logic",
            );
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
      if (ball.pos2D.distanceTo(gateCenter) < 52 && hasActiveVillain) {
        ball.velocity = ball.pos2D.x < gateCenter.x ? -120 : 120;
        _showPraiseText('DEFEAT THE GATEKEEPER!', color: GameColors.redAccent);
      } else if (ball.pos2D.distanceTo(gateCenter) < 40 &&
          (!isRaceMode || raceProgress >= 0.94)) {
        debugPrint(
          "DEBUG: isSuckingToGate = true triggered. pos2D: ${ball.pos2D}, gateCenter: $gateCenter",
        );
        ball.isSuckingToGate = true;
        ball.isFalling = false;
        _clearBombs();

        if (isDarknessLevel) {
          isWinningDarkLevel = true;
        }

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
            leftY >= (levelHeight - 165.0) && rightY >= (levelHeight - 165.0);

        if (ball.spawnTimer - dt <= 1.0 && !isBarAtBottom) {
          ball.spawnTimer = 1.0001;
        } else {
          double oldTimer = ball.spawnTimer;
          ball.spawnTimer -= dt;
          if (oldTimer > 1.0 && ball.spawnTimer <= 1.0) {
            try {
              AppSettings.playSound('swoosh.wav');
            } catch (_) {}
          }
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
              AppSettings.playSound('bounce.wav');
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
            leftY >= (levelHeight - 165.0) && rightY >= (levelHeight - 165.0);

        if (ball.respawnTimer - dt <= 0.8 && !isBarAtBottom) {
          ball.respawnTimer = 0.8001;
        } else {
          double oldTimer = ball.respawnTimer;
          ball.respawnTimer -= dt;
          if (oldTimer > 0.8 && ball.respawnTimer <= 0.8) {
            try {
              AppSettings.playSound('swoosh.wav');
            } catch (_) {}
          }
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
            AppSettings.playSound('bounce.wav');
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
          final wasFastSave = ball.freeFallVelocity.y > 560.0;
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
            AppSettings.playSound('bounce.wav');
          } catch (_) {}
          if (wasFastSave) {
            _showPraiseText(
              'Great Save!',
              color: GameColors.mapAppBarGreenAccent,
            );
          }

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
              other.isClosed = true;

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

          final fieldForce = hole.forceAt(ball.pos2D);
          if (fieldForce.length2 > 0 && !isShieldActive) {
            ball.velocity += fieldForce.dot(direction) * dt;
            if (ball.isFreeFalling || ball.isFalling) {
              ball.freeFallVelocity += fieldForce * dt;
            }
          }

          if (!hole.isDangerous) continue;
          final centers = hole.collisionCenters;
          final collisionCenter = centers.reduce(
            (a, b) =>
                ball.pos2D.distanceTo(a) < ball.pos2D.distanceTo(b) ? a : b,
          );
          double dist = ball.pos2D.distanceTo(collisionCenter);
          double lethalDist =
              (hole.size.x / 2 * hole.scale.x) - 2.0 * hole.scale.x;
          if (centers.length > 1) lethalDist *= 0.48;

          if (hole.hasForceField) {
            lethalDist = hole.currentSuckRadius * hole.scale.x * 0.95;
          }

          if (dist < lethalDist) {
            if (isShieldActive) {
              double dot = (ball.pos2D - collisionCenter).dot(direction);
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
            ball.fallTarget = collisionCenter.clone();
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

        for (final helper in shooterHelpers) {
          if (!helper.isCollected &&
              ball.pos2D.distanceTo(helper.position) < ballRadius + 22) {
            helper.collect();
            HapticFeedback.mediumImpact();
            AppSettings.playSound('star.wav', volume: 0.7);
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

  void activateShooter() {
    shooterActive = true;
    shooterFireTimer = 0.48;
    queueTutorial('shooter_helper');
    _showPraiseText(
      'AUTO SHOOTER READY!',
      color: GameColors.cyanAccent,
      force: true,
    );
  }

  void onVillainDefeated(VillainComponent villain) {
    _showPraiseText(
      'GATEKEEPER DEFEATED!',
      color: GameColors.goldenYellow,
      force: true,
    );
    AppSettings.playSound('win.wav', volume: 0.65);
  }

  void _spawnInfinityStarterTemplate(LevelData template) {
    final sizeX = size.x > 0 ? size.x : 400.0;
    final sizeY = size.y > 0 ? size.y : 800.0;
    final startY = sizeY - 250.0;
    final spanY = max(520.0, sizeY * 1.15);

    double safeX(double value) => (value * sizeX)
        .clamp(barPadding + 24.0, sizeX - barPadding - 24.0)
        .toDouble();

    Vector2 mapPoint(Vector2 normalized) {
      return Vector2(safeX(normalized.x), startY - normalized.y * spanY);
    }

    for (final hData in template.holes) {
      final pos = mapPoint(hData.position);
      final hole =
          HoleComponent(
              pos,
              hData.size,
              hData.rotation,
              isSuckingHole: hData.isSuckingHole,
              suckRadius: hData.suckRadius,
              isMovingHole: hData.isMovingHole,
              moveRange: hData.moveRange <= 1.0
                  ? hData.moveRange * sizeX
                  : hData.moveRange,
              moveSpeed: hData.moveSpeed,
              moveAxis: hData.moveAxis,
              behavior: hData.behavior,
              warningDuration: hData.warningDuration,
              activeDuration: hData.activeDuration,
              recoveryDuration: hData.recoveryDuration,
              forceStrength: hData.forceStrength,
            )
            ..position = pos
            ..priority = 1;
      holes.add(hole);
      levelContainer.add(hole);
    }

    for (final bData in template.bumpers) {
      final pos = mapPoint(bData.position);
      final bumper = BumperComponent(pos, bData.size)
        ..position = pos
        ..priority = 2;
      bumpers.add(bumper);
      levelContainer.add(bumper);
    }

    for (final tData in template.teleporters) {
      final pos = mapPoint(tData.position);
      final teleporter = TeleporterComponent(pos, tData.size, tData.pairId)
        ..position = pos
        ..priority = 1;
      teleporters.add(teleporter);
      levelContainer.add(teleporter);
    }

    for (final starPos in template.stars) {
      final pos = mapPoint(starPos);
      final star = StarComponent(pos)
        ..position = pos
        ..priority = 5;
      stars.add(star);
      levelContainer.add(star);
    }

    for (final heartPos in template.hearts) {
      final pos = mapPoint(heartPos);
      final heart = HeartComponent(pos)
        ..position = pos
        ..priority = 5;
      hearts.add(heart);
      levelContainer.add(heart);
    }

    for (final magnetPos in template.magnets) {
      final pos = mapPoint(magnetPos);
      final magnet = MagnetComponent(pos)
        ..position = pos
        ..priority = 5;
      magnets.add(magnet);
      levelContainer.add(magnet);
    }

    for (final multiBallPos in template.multiBalls) {
      final pos = mapPoint(multiBallPos);
      final multiBall = MultiBallItem(pos)
        ..position = pos
        ..priority = 5;
      multiBallItems.add(multiBall);
      levelContainer.add(multiBall);
    }
  }

  void _updateInfinityMode(double dt) {
    if (dt <= 0) return;
    if (activeBalls.isEmpty) return;

    final double barMid = (leftY + rightY) / 2.0;
    _ensureInfinityWorldForBar(barMid);

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
        if (points >= 5) {
          _showPraiseText(
            points >= 10 ? 'Fantastic!' : 'Great Move!',
            color: GameColors.amber300,
          );
        }
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
        _showPraiseText('Nice Dodge!', color: GameColors.amber300);
      }
    }

    _cullInfinityObstacles(barMid + 600.0);
  }

  void _ensureInfinityWorldForBar(double barMid) {
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

      nextSpawnY -= minStep + _worldRandom.nextDouble() * (maxStep - minStep);
    }
  }

  void _scatterStarsInChunk(double startY, double endY, int count) {
    final double sizeX = size.x > 0 ? size.x : 400.0;
    final double usableWidth = sizeX - barPadding * 2 - 40.0;
    for (int i = 0; i < count; i++) {
      final double x =
          barPadding + 20.0 + _worldRandom.nextDouble() * usableWidth;
      final double y = endY + _worldRandom.nextDouble() * (startY - endY);
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
    double rx() {
      final centerWeighted =
          (_worldRandom.nextDouble() + _worldRandom.nextDouble()) / 2.0;
      return barPadding + 28.0 + centerWeighted * (usableWidth - 56.0);
    }

    final double roll = _worldRandom.nextDouble();
    final behaviorCandidates = <HoleBehavior>[
      HoleBehavior.pulse,
      if (difficulty > 0.18) HoleBehavior.wave,
      if (difficulty > 0.24) HoleBehavior.nailLauncher,
      if (difficulty > 0.32) HoleBehavior.orbit,
      if (difficulty > 0.48) HoleBehavior.teleport,
      if (difficulty > 0.6) HoleBehavior.split,
      if (difficulty > 0.72) HoleBehavior.fake,
      if (difficulty > 0.82) HoleBehavior.chase,
    ];
    final available = behaviorCandidates
        .where(
          (behavior) => !_recentInfinityPrimaryBehaviors.contains(behavior),
        )
        .toList();
    final pool = available.isEmpty ? behaviorCandidates : available;
    final primaryBehavior = roll >= 0.5 && roll < 0.7
        ? (difficulty > 0.55 && _worldRandom.nextBool()
              ? HoleBehavior.breathingVortex
              : HoleBehavior.spiralSuction)
        : pool[_worldRandom.nextInt(pool.length)];
    _recentInfinityPrimaryBehaviors.add(primaryBehavior);
    while (_recentInfinityPrimaryBehaviors.length > 2) {
      _recentInfinityPrimaryBehaviors.removeFirst();
    }
    final behaviorMoves = {
      HoleBehavior.pingPong,
      HoleBehavior.wave,
      HoleBehavior.orbit,
      HoleBehavior.teleport,
      HoleBehavior.chase,
    }.contains(primaryBehavior);

    // Spawn powerups independently of the pattern (small chance)
    if (_worldRandom.nextDouble() < 0.05) {
      final heart = HeartComponent(Vector2(rx(), y - 80))
        ..position = Vector2(rx(), y - 80)
        ..priority = 5;
      hearts.add(heart);
      levelContainer.add(heart);
    } else if (_worldRandom.nextDouble() < 0.05) {
      final mag = MagnetComponent(Vector2(rx(), y - 80))
        ..position = Vector2(rx(), y - 80)
        ..priority = 5;
      magnets.add(mag);
      levelContainer.add(mag);
    } else if (_worldRandom.nextDouble() < 0.05) {
      final mb =
          MultiBallItem(
              Vector2(rx(), y - 80),
              ballCount: 1 + _worldRandom.nextInt(3),
            )
            ..position = Vector2(rx(), y - 80)
            ..priority = 5;
      multiBallItems.add(mb);
      levelContainer.add(mb);
    }

    final double patternWidth = usableWidth * 0.76;
    final double offsetRange = usableWidth - patternWidth;
    final double startX =
        barPadding + offsetRange * (0.35 + _worldRandom.nextDouble() * 0.3);

    if (roll < 0.25) {
      // The Blockade: Horizontal line of small holes
      int count = 3 + (difficulty * 2).floor(); // 3 to 5 holes
      double spacing = patternWidth / (count + 1);
      for (int i = 0; i < count; i++) {
        double px = startX + spacing * (i + 1);
        final hole =
            HoleComponent(
                Vector2(px, y),
                34 + difficulty * 10,
                _worldRandom.nextDouble() * pi,
                behavior: primaryBehavior,
                isMovingHole: behaviorMoves,
                moveRange: 28 + difficulty * 18,
                moveSpeed: 65 + difficulty * 55,
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
              isMovingHole: behaviorMoves,
              moveRange: patternWidth * 0.4 + difficulty * 20,
              moveSpeed: 60 + difficulty * 80,
              behavior: primaryBehavior,
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
              behavior: primaryBehavior,
              forceStrength: 250 + difficulty * 120,
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
                _worldRandom.nextDouble() * pi,
                behavior: primaryBehavior,
                isMovingHole: behaviorMoves,
                moveRange: 24 + difficulty * 14,
                moveSpeed: 65 + difficulty * 50,
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
              _worldRandom.nextDouble() * pi,
              behavior: primaryBehavior,
              isMovingHole: behaviorMoves,
              moveRange: 32 + difficulty * 18,
              moveSpeed: 65 + difficulty * 55,
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
    if (!isInfinityMode || isMultiplayer) return;
    final int finalScore = currentScore.value;
    final int finalCoins = collectedCoins.value;
    lastInfinityScore = finalScore;
    lastInfinityCoins = finalCoins;
    if (finalScore > infinityHighScore) {
      infinityHighScore = finalScore;
    }

    try {
      await PlayerSession.instance.recordInfinityRun(
        runId: const Uuid().v4(),
        score: finalScore,
        coins: finalCoins,
      );
      infinityHighScore = finalScore > infinityHighScore
          ? finalScore
          : infinityHighScore;
    } catch (e) {
      debugPrint("DEBUG: Failed to save coins or high score: $e");
    } finally {
      currentScore.value = 0;
      collectedCoins.value = 0;
    }
  }

  void _showPraiseText(
    String text, {
    Color color = GameColors.white,
    bool force = false,
  }) {
    if (!force && praiseCooldown > 0) return;
    if (size.x <= 0 || size.y <= 0) return;
    praiseCooldown = 1.4;
    levelContainer.add(
      FloatingTextComponent(
        text: text,
        position: Vector2(size.x / 2, cameraOffsetY + size.y * 0.32),
        color: color,
      )..priority = 250,
    );
  }
}
