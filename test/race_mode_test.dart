import 'dart:convert';

import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/components/bomb_component.dart';
import 'package:balanco_game/features/game/components/bomb_warning_component.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/features/game/models/race_pickup.dart';
import 'package:balanco_game/features/race/application/race_match_clock.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('race progress is safe before Flame lays out the board', () {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
    );

    expect(game.isLayoutReady, isFalse);
    expect(game.raceProgress, 0);
  });

  test('race timeout submits once, supports fractions, and can retry', () {
    final guard = RaceTimeoutSubmissionGuard();
    final started = DateTime.utc(2026, 7, 18, 12);

    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(milliseconds: 60499),
        limitSeconds: 60.5,
        now: started,
      ),
      isFalse,
    );
    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(milliseconds: 60500),
        limitSeconds: 60.5,
        now: started,
      ),
      isTrue,
    );
    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(seconds: 70),
        limitSeconds: 60.5,
        now: started,
      ),
      isFalse,
    );

    expect(guard.recordFailure(started), isTrue);
    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(seconds: 70),
        limitSeconds: 60.5,
        now: started.add(const Duration(milliseconds: 999)),
      ),
      isFalse,
    );
    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(seconds: 70),
        limitSeconds: 60.5,
        now: started.add(const Duration(seconds: 1)),
      ),
      isTrue,
    );

    expect(
      guard.recordFailure(started.add(const Duration(seconds: 1))),
      isTrue,
    );
    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(seconds: 70),
        limitSeconds: 60.5,
        now: started.add(const Duration(seconds: 3)),
      ),
      isTrue,
    );
    expect(
      guard.recordFailure(started.add(const Duration(seconds: 3))),
      isFalse,
    );
    expect(guard.exhausted, isTrue);
    expect(guard.failures, 3);
    expect(
      guard.take(
        isRoomActive: true,
        elapsed: const Duration(minutes: 2),
        limitSeconds: 60.5,
        now: started.add(const Duration(minutes: 1)),
      ),
      isFalse,
    );
  });

  test('race timeout can settle when pause lands exactly at zero', () {
    final guard = RaceTimeoutSubmissionGuard();

    expect(
      guard.take(
        // The coordinator treats playing or paused as an active room for
        // timeout settlement while the clock itself remains frozen on pause.
        isRoomActive: true,
        elapsed: const Duration(seconds: 60),
        limitSeconds: 60,
      ),
      isTrue,
    );
  });

  test(
    'race HUD can configure the bar before Flame lays out the board',
    () async {
      final game = BalancoGame(
        isMultiplayer: true,
        playerRole: 'BOTH',
        randomSeed: 42,
        isRaceMode: true,
      );

      expect(game.isLayoutReady, isFalse);
      expect(() => game.configureRaceBarBottomInset(120), returnsNormally);

      game.onGameResize(Vector2(400, 800));
      await Future<void>.delayed(Duration.zero);

      expect(game.isLayoutReady, isTrue);
      expect(game.levelHeight - game.leftY, 120);
      expect(game.levelHeight - game.rightY, 120);
    },
  );

  test('race games can suppress campaign tutorials without pausing', () {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
    );

    game.queueTutorial('joysticks');

    expect(game.currentTutorial.value, isNull);
  });

  test(
    'race replica materializes campaign obstacles without spawn animation',
    () async {
      final game =
          BalancoGame(
              isMultiplayer: true,
              playerRole: 'BOTH',
              randomSeed: 42,
              enableTutorials: false,
            )
            ..enableCoopReplica()
            ..onGameResize(Vector2(400, 800));

      await game.onLoad();

      expect(game.currentLevelData, isNotNull);
      expect(game.pendingSpawns, isEmpty);
      expect(game.targetPositions, isEmpty);
      expect(game.holes.every((hole) => hole.scale == Vector2.all(1)), isTrue);
    },
  );

  test(
    'race starts on the bottom bar instead of falling from finish gate',
    () async {
      final game = BalancoGame(
        isMultiplayer: true,
        playerRole: 'BOTH',
        randomSeed: 42,
        enableTutorials: false,
        isRaceMode: true,
      )..onGameResize(Vector2(400, 800));

      await Future<void>.delayed(Duration.zero);
      await game.onLoad();

      expect(
        game.currentHeightMultiplier,
        game.currentLevelData!.heightMultiplier,
      );
      expect(game.leftY, game.levelHeight - 60);
      expect(game.rightY, game.levelHeight - 60);
      expect(game.activeBalls.single.pos2D.y, game.levelHeight - 80);
      expect(game.activeBalls.single.pos2D.y, greaterThan(70));
      expect(
        game.cameraOffsetY,
        (game.levelHeight - game.size.y).clamp(0, double.infinity),
      );
      expect(game.isSpawningLevel, isFalse);
      expect(game.teleportingGateComponent.isClosed, isFalse);
      expect(game.raceProgress, 0);

      game
        ..countdownTimer = 3
        ..configureRaceBarBottomInset(120);
      expect(game.leftY, game.levelHeight - 120);
      expect(game.rightY, game.levelHeight - 120);
      expect(game.activeBalls.single.pos2D.y, game.levelHeight - 140);
    },
  );

  test(
    'race does not turn the shared timeout into a local heart loss',
    () async {
      final game = BalancoGame(
        isMultiplayer: true,
        playerRole: 'BOTH',
        randomSeed: 42,
        enableTutorials: false,
        isRaceMode: true,
      )..onGameResize(Vector2(400, 800));

      await Future<void>.delayed(Duration.zero);
      await game.onLoad();
      game
        ..countdownTimer = 0
        ..isLevelTimerActive = true
        ..levelTimer = 0.001;

      game.update(1 / 60);

      expect(game.currentLives.value, 3);
      expect(game.showGameOverOverlay.value, isFalse);
    },
  );

  test('race loads the exact regular authored level definition', () async {
    final regular = BalancoGame(
      isMultiplayer: false,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
    )..onGameResize(Vector2(400, 800));
    final race = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
    )..onGameResize(Vector2(400, 800));

    await Future.wait([regular.onLoad(), race.onLoad()]);

    expect(race.currentLevelData!.toJson(), regular.currentLevelData!.toJson());
    expect(race.currentHeightMultiplier, regular.currentHeightMultiplier);
  });

  test('race shield pickup is global and cannot grant twice', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
    )..onGameResize(Vector2(400, 800));
    game.currentLevel.value = 12;

    await Future<void>.delayed(Duration.zero);
    await game.onLoad();

    expect(game.shieldPickups, isNotEmpty);
    final claim = RacePickupResolution(
      pickupKey: 'shield:0',
      type: RacePickupType.shield,
      claimantId: 'player-1',
      claimantName: 'Player 1',
    );

    game.applyRacePickupClaim(claim, grantEffect: true);
    game.applyRacePickupClaim(claim, grantEffect: true);

    expect(game.shieldPickups.first.isCollected, isTrue);
    expect(game.remainingShields.value, 4);
  });

  test('saved vortex wind radius survives gameplay loading', () async {
    const levelId = 499;
    const savedWindRadius = 237.0;
    final database = DatabaseHelper.instance;
    final previousLevel = await database.getCustomLevel(levelId);
    addTearDown(() async {
      if (previousLevel == null) {
        await database.deleteCustomLevel(levelId);
      } else {
        await database.saveCustomLevel(levelId, previousLevel);
      }
    });

    final level = LevelData(
      holes: [HoleData(Vector2(0.5, 0.5), 64, 0, true, savedWindRadius)],
      stars: const [],
      hearts: const [],
    );
    await database.saveCustomLevel(levelId, jsonEncode(level.toJson()));

    final game =
        BalancoGame(
            isMultiplayer: false,
            isEditMode: true,
            playerRole: 'BOTH',
            enableTutorials: false,
          )
          ..currentLevel.value = levelId
          ..onGameResize(Vector2(400, 800));

    await Future<void>.delayed(Duration.zero);
    await game.onLoad();

    expect(game.holes, hasLength(1));
    final vortex = game.holes.single..scale = Vector2.all(1);
    expect(vortex.suckRadius, savedWindRadius);
    expect(game.currentLevelData!.holes.single.suckRadius, savedWindRadius);
    expect(
      vortex.forceAt(vortex.position + Vector2(savedWindRadius - 10, 0)).length,
      greaterThan(0),
    );
    expect(
      vortex.forceAt(vortex.position + Vector2(savedWindRadius + 1, 0)).length,
      0,
    );
  });

  test(
    'race camera scrolls up with the bar and reveals the distant gate',
    () async {
      final game = BalancoGame(
        isMultiplayer: true,
        playerRole: 'BOTH',
        randomSeed: 42,
        enableTutorials: false,
        isRaceMode: true,
      )..onGameResize(Vector2(400, 800));

      await Future<void>.delayed(Duration.zero);
      await game.onLoad();
      game
        ..currentHeightMultiplier = 3
        ..leftY = 2340
        ..rightY = 2340
        ..cameraOffsetY = 1600;
      game.activeBalls.single
        ..pos2D = Vector2(200, 2320)
        ..holeImmunityTimer = 100;
      final startingCameraY = game.cameraOffsetY;

      game
        ..countdownTimer = 0
        ..leftY = 110
        ..rightY = 110;
      for (var frame = 0; frame < 120; frame++) {
        game.update(1 / 60);
      }

      expect(game.cameraOffsetY, lessThan(startingCameraY));
      expect(game.cameraOffsetY, closeTo(0, 1));
      final gateScreenY =
          game.teleportingGateComponent.position.y - game.cameraOffsetY;
      expect(gateScreenY, inInclusiveRange(0, game.size.y));
    },
  );

  test('race uses the regular hole-to-bar respawn lifecycle', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
    )..onGameResize(Vector2(400, 800));

    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    final hole = game.holes.first;
    final fallingBall = game.activeBalls.single
      ..activeHole = hole
      ..fallTarget = hole.position.clone()
      ..pos2D = hole.position.clone()
      ..isFallingInHole = true
      ..scale = -0.49;

    game.update(0.02);

    expect(fallingBall.isDead, isTrue);
    expect(game.currentLives.value, 2);
    expect(game.activeBalls, hasLength(1));
    expect(game.activeBalls.single.isRespawningFromHole, isTrue);
    expect(game.activeBalls.single.activeHole, same(hole));
    expect(game.activeBalls.single.pos2D, hole.position);
    expect(game.isBoardHidden, isFalse);

    for (var frame = 0; frame < 150; frame++) {
      game.update(1 / 60);
    }

    expect(game.activeBalls.single.isRespawningFromHole, isFalse);
    expect(game.activeBalls.single.activeHole, isNull);
    expect(game.activeBalls.single.scale, 1);
    expect(game.activeBalls.single.pos2D.y, lessThan(game.leftY));
  });

  test(
    'edge fall drops from the finish gate and lands in every mode',
    () async {
      for (final isRace in [false, true]) {
        final game = BalancoGame(
          isMultiplayer: isRace,
          playerRole: 'BOTH',
          randomSeed: 42,
          enableTutorials: false,
          isRaceMode: isRace,
        )..onGameResize(Vector2(400, 800));

        await Future<void>.delayed(Duration.zero);
        await game.onLoad();
        game
          ..isSpawningLevel = false
          ..countdownTimer = 0
          ..leftY = game.levelHeight - (isRace ? 120 : 160)
          ..rightY = game.levelHeight - (isRace ? 120 : 160);
        game.activeBalls.single.isDead = true;

        game.update(1 / 60);

        expect(game.currentLives.value, 2, reason: 'race=$isRace');
        expect(game.activeBalls.single.isRespawningFromEdge, isTrue);
        expect(
          game.activeBalls.single.pos2D,
          game.teleportingGateComponent.position,
        );

        for (var frame = 0; frame < 360; frame++) {
          game.update(1 / 60);
        }

        final respawned = game.activeBalls.single;
        expect(respawned.isRespawningFromEdge, isFalse, reason: 'race=$isRace');
        expect(respawned.isFreeFalling, isFalse, reason: 'race=$isRace');
        expect(respawned.isDead, isFalse, reason: 'race=$isRace');
        expect(game.isLevelTimerActive, isTrue, reason: 'race=$isRace');
        expect(
          respawned.pos2D.y,
          closeTo((game.leftY + game.rightY) / 2 - game.ballRadius - 6, 1),
          reason: 'race=$isRace',
        );
      }
    },
  );

  test('race restart rearms victory notification for the next level', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
    )..onGameResize(Vector2(400, 800));

    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    var submittedVictories = 0;
    game.showVictoryOverlay.addListener(() {
      if (game.showVictoryOverlay.value) submittedVictories++;
    });

    game.showVictoryOverlay.value = true;
    game.isBoardHidden = true;
    game.currentLevel.value = 2;
    await game.restartRaceRun(43);

    expect(game.showVictoryOverlay.value, isFalse);
    expect(game.isBoardHidden, isFalse);
    expect(game.isLevelCompleteOverlayShown, isFalse);
    expect(game.currentLevel.value, 2);

    game.showVictoryOverlay.value = true;
    expect(submittedVictories, 2);
  });

  test(
    'race restart removes bombs and warnings from the previous level',
    () async {
      final game = BalancoGame(
        isMultiplayer: true,
        playerRole: 'BOTH',
        randomSeed: 42,
        enableTutorials: false,
        isRaceMode: true,
      )..onGameResize(Vector2(400, 800));

      await Future<void>.delayed(Duration.zero);
      await game.onLoad();
      game.levelContainer.addAll([
        BombComponent(Vector2(200, 300)),
        BombWarningComponent(),
      ]);
      game.update(1 / 60);

      expect(
        game.levelContainer.children.whereType<BombComponent>(),
        isNotEmpty,
      );
      expect(
        game.levelContainer.children.whereType<BombWarningComponent>(),
        isNotEmpty,
      );

      game.currentLevel.value = 3;
      await game.restartRaceRun(43);
      game.update(1 / 60);

      expect(game.levelContainer.children.whereType<BombComponent>(), isEmpty);
      expect(
        game.levelContainer.children.whereType<BombWarningComponent>(),
        isEmpty,
      );
    },
  );

  test('race room parses authoritative start and winner state', () {
    final room = CoopRoom.fromJson({
      'room': {
        'id': 'race-id',
        'room_code': 'RACE42',
        'host_id': 'host',
        'host_side': 'left',
        'status': 'ended',
        'seed': 42,
        'mode': 'race',
        'race_level': 1,
        'race_level_version': 7,
        'started_at': '2026-07-13T18:00:00Z',
        'winner_id': 'host',
        'winner_finished_at': '2026-07-13T18:01:12Z',
        'winner_elapsed_ms': 72000,
        'winner_hearts': 2,
        'winner_stars': 3,
        'race_end_kind': 'finish',
        'race_restart_kind': 'retry',
      },
      'members': [
        {
          'user_id': 'host',
          'display_name': 'Kareem',
          'player_code': 'KA27-A1B2C',
          'side': 'left',
          'ready': true,
          'is_host': true,
          'race_wins': 3,
        },
        {
          'user_id': 'guest',
          'display_name': 'Partner',
          'player_code': 'PA27-D3E4F',
          'side': 'right',
          'ready': true,
          'is_host': false,
          'race_wins': 2,
        },
      ],
    });

    expect(room.isRace, isTrue);
    expect(room.raceLevel, 1);
    expect(room.raceLevelVersion, 7);
    expect(room.startedAt, DateTime.utc(2026, 7, 13, 18));
    expect(room.winnerId, 'host');
    expect(room.winnerElapsedMs, 72000);
    expect(room.raceEndKind, 'finish');
    expect(room.raceRestartKind, 'retry');
    expect(room.memberFor('host').raceWins, 3);
    expect(room.memberFor('guest').raceWins, 2);
  });

  test('race room identifies an authoritative disconnect forfeit', () {
    final room = CoopRoom.fromJson({
      'room': {
        'id': 'race-id',
        'room_code': 'RACE42',
        'host_id': 'host',
        'host_side': 'left',
        'status': 'ended',
        'seed': 42,
        'mode': 'race',
        'race_level': 3,
        'end_reason': 'forfeit',
        'winner_id': 'host',
        'race_end_kind': 'disconnect',
      },
      'members': [
        {
          'user_id': 'host',
          'display_name': 'Kareem',
          'player_code': 'KA27-A1B2C',
          'side': 'left',
          'ready': true,
          'is_host': true,
        },
      ],
    });

    expect(room.endedByDisconnect, isTrue);
    expect(room.winnerId, 'host');
  });

  test('race progress maps vertical advance to the finish gate', () {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
    )..onGameResize(Vector2(400, 800));
    game.currentHeightMultiplier = 2;
    final start = game.levelHeight - 160;
    const finish = 70.0;
    final halfway = (start + finish) / 2;
    game
      ..leftY = halfway
      ..rightY = halfway;

    expect(game.raceProgress, closeTo(0.5, 0.0001));
  });

  test('race helper state travels in interpolated snapshots', () {
    final local = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
    )..onGameResize(Vector2(400, 800));
    expect(local.activateRaceBoost(), isTrue);
    local.currentPoints.value = 2;

    final remote = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
    )..onGameResize(Vector2(400, 800));
    remote
      ..enableCoopReplica()
      ..applyCoopSnapshot(local.createCoopSnapshot())
      ..update(1 / 60);

    expect(remote.remainingRaceBoosts.value, 1);
    expect(remote.raceBoostTimer, 4);
    expect(remote.currentPoints.value, 2);
  });
}
