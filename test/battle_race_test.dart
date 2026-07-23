import 'package:balanco_game/features/battle/domain/battle_race_state.dart';
import 'package:balanco_game/features/battle/presentation/battle_weapon_effect_component.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/race_pickup.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('battle respawn escalates, stabilizes, and protects the player', () {
    final state = BattlePlayerState(playerId: 'player-1')..startMatch();

    state.recordFall();
    expect(state.beginRespawn(), 1.25);
    expect(state.respawnCount, 1);
    expect(state.canMove, isFalse);
    expect(state.canReceiveAttack, isFalse);

    state.update(1.25);
    expect(state.phase, BattlePlayerPhase.droppingBall);
    state.beginStabilizing();
    state.tickStabilization(
      0.25,
      touchingOwnBar: true,
      linearSpeed: 0,
      angularSpeed: 0,
    );
    expect(state.phase, BattlePlayerPhase.spawnProtection);
    expect(state.canMove, isTrue);
    expect(state.canReceiveAttack, isFalse);

    state.update(0.85);
    expect(state.phase, BattlePlayerPhase.active);
    expect(state.canReceiveAttack, isTrue);
  });

  test('checkpoint resets the repeated-fall penalty', () {
    final state = BattlePlayerState(playerId: 'player-1')..startMatch();

    state.recordFall();
    state.beginRespawn();
    state.phase = BattlePlayerPhase.active;
    state.recordFall();
    expect(state.beginRespawn(), 1.60);

    state.phase = BattlePlayerPhase.active;
    expect(state.activateCheckpoint(1), isTrue);
    state.recordFall();
    expect(state.beginRespawn(), 1.25);
    expect(state.checkpointIndex, 1);
  });

  test('Heat Wave is phase gated and uses a six second cooldown', () {
    final state = BattlePlayerState(playerId: 'player-1');

    expect(state.useAttack(BattleWeaponCatalog.heatWave), isFalse);
    state.startMatch();
    expect(state.useAttack(BattleWeaponCatalog.heatWave), isTrue);
    expect(state.attackCooldown, 6);
    expect(state.useAttack(BattleWeaponCatalog.heatWave), isFalse);
    state.update(6);
    expect(state.useAttack(BattleWeaponCatalog.heatWave), isTrue);
  });

  test('collected Battle weapons are consumed exactly once', () {
    final state = BattlePlayerState(playerId: 'player-1')..startMatch();

    expect(state.collectWeapon('battle_rocket', 'battle_rocket:0'), isTrue);
    expect(state.collectWeapon('battle_rocket', 'battle_rocket:0'), isFalse);
    expect(state.weaponCount('battle_rocket'), 1);
    expect(
      state.useAttack(BattleWeaponCatalog.rocket, pickupKey: 'battle_rocket:0'),
      isTrue,
    );
    expect(state.weaponCount('battle_rocket'), 0);
    state.update(BattleWeaponCatalog.rocket.cooldownSeconds);
    expect(
      state.useAttack(BattleWeaponCatalog.rocket, pickupKey: 'battle_rocket:0'),
      isFalse,
    );
  });

  test('Battle projectile animations track the target and impact once', () {
    for (final weapon in [
      BattleWeaponCatalog.rocket,
      BattleWeaponCatalog.bomb,
      BattleWeaponCatalog.nails,
    ]) {
      var target = Vector2(120, 220);
      var impacts = 0;
      final effect = BattleWeaponEffectComponent(
        weapon: weapon,
        sourcePosition: Vector2(40, 620),
        targetProvider: () => target,
        onImpact: () => impacts++,
      );

      effect.update(0.25);
      target = Vector2(250, 180);
      effect.update(1);
      effect.update(1);

      expect(effect.trackedTarget, target, reason: weapon.id);
      expect(effect.hasImpacted, isTrue, reason: weapon.id);
      expect(effect.isComplete, isTrue, reason: weapon.id);
      expect(impacts, 1, reason: weapon.id);
    }
  });

  test('battle Shield blocks one Heat Wave and is consumed', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
      isBattleRaceMode: true,
    )..onGameResize(Vector2(400, 800));
    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    game
      ..countdownTimer = 0
      ..isSpawningLevel = false;
    game.battlePlayerState.phase = BattlePlayerPhase.active;

    expect(game.remainingShields.value, 1);
    expect(game.activateShield(), isTrue);
    expect(game.shieldTimer, 1.75);
    final ball = game.activeBalls.single;
    final blocked = game.receiveShockPulse(
      sourceXRatio: (ball.pos2D.x - 20) / game.size.x,
      sourceYRatio: (ball.pos2D.y - 70) / (game.raceBarBottomY - 70),
    );

    expect(blocked, isTrue);
    expect(game.shieldTimer, 0);
    expect(ball.velocity, 0);
  });

  test('Heat Wave detaches a supported ball with a real 2D impulse', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
      isBattleRaceMode: true,
    )..onGameResize(Vector2(400, 800));
    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    game
      ..countdownTimer = 0
      ..isSpawningLevel = false;
    game.battlePlayerState.phase = BattlePlayerPhase.active;
    final ball = game.activeBalls.single;

    final hit = game.receiveBattleWeapon(
      weaponId: BattleWeaponCatalog.heatWave.id,
      sourceXRatio: 0,
      sourceYRatio: 0.5,
    );

    expect(hit, isTrue);
    expect(ball.isFreeFalling, isTrue);
    expect(ball.freeFallVelocity.x, greaterThan(0));
    expect(ball.freeFallVelocity.y, lessThan(0));
  });

  test('remote ball collision only impulses approaching balls', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
      isBattleRaceMode: true,
    )..onGameResize(Vector2(400, 800));
    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    game
      ..countdownTimer = 0
      ..isSpawningLevel = false;
    game.battlePlayerState.phase = BattlePlayerPhase.active;
    final ball = game.activeBalls.single;
    final remoteX = (ball.pos2D.x - 27) / game.size.x;
    final remoteY = ball.pos2D.y / game.levelHeight;

    expect(
      game.applyRemoteBallCollision(
        remoteXRatio: remoteX,
        remoteYRatio: remoteY,
        remoteVelocityX: -220,
        remoteVelocityY: 0,
      ),
      isFalse,
    );
    expect(ball.isFreeFalling, isFalse);

    expect(
      game.applyRemoteBallCollision(
        remoteXRatio: remoteX,
        remoteYRatio: remoteY,
        remoteVelocityX: 220,
        remoteVelocityY: 0,
      ),
      isTrue,
    );
    expect(ball.isFreeFalling, isTrue);
    expect(ball.freeFallVelocity.x, greaterThan(0));
  });

  test('Battle weapons can be collected while the ball is airborne', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
      isBattleRaceMode: true,
    )..onGameResize(Vector2(400, 800));
    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    game
      ..racePlayerId = 'player-1'
      ..countdownTimer = 0
      ..isSpawningLevel = false;
    game.battlePlayerState.phase = BattlePlayerPhase.active;
    final ball = game.activeBalls.single
      ..isFreeFalling = true
      ..freeFallVelocity.setZero();
    final pickup = game.battlePickups.firstWhere(
      (candidate) => candidate.type == RacePickupType.battleRocket,
    )..position.setFrom(ball.pos2D);
    game.onRacePickupClaim = (type, key) async => RacePickupResolution(
      pickupKey: key,
      type: type,
      claimantId: 'player-1',
      claimantName: 'Player 1',
    );

    game.checkBattlePickupCollisionsForTesting(ball);
    await Future<void>.delayed(Duration.zero);

    expect(pickup.isCollected, isTrue);
    expect(game.battlePlayerState.weaponCount('battle_rocket'), 1);
  });

  test('Battle pickups are deterministic and remain well separated', () async {
    Future<BalancoGame> loadGame() async {
      final game = BalancoGame(
        isMultiplayer: true,
        playerRole: 'BOTH',
        randomSeed: 8472,
        enableTutorials: false,
        isRaceMode: true,
        isBattleRaceMode: true,
      )..onGameResize(Vector2(400, 800));
      await Future<void>.delayed(Duration.zero);
      await game.onLoad();
      return game;
    }

    final first = await loadGame();
    final second = await loadGame();
    expect(first.battlePickups.length, 8);
    expect(second.battlePickups.length, 8);
    for (var index = 0; index < first.battlePickups.length; index++) {
      expect(
        second.battlePickups[index].pickupKey,
        first.battlePickups[index].pickupKey,
      );
      expect(
        second.battlePickups[index].position,
        first.battlePickups[index].position,
      );
      for (var other = index + 1; other < first.battlePickups.length; other++) {
        expect(
          first.battlePickups[index].position.distanceTo(
            first.battlePickups[other].position,
          ),
          greaterThanOrEqualTo(96),
        );
      }
    }
    expect(first.remainingRaceBoosts.value, 0);
  });

  test('battle fall keeps lives and begins checkpoint respawn', () async {
    final game = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: 42,
      enableTutorials: false,
      isRaceMode: true,
      isBattleRaceMode: true,
    )..onGameResize(Vector2(400, 800));
    await Future<void>.delayed(Duration.zero);
    await game.onLoad();
    game
      ..countdownTimer = 0
      ..isSpawningLevel = false;
    game.battlePlayerState.phase = BattlePlayerPhase.active;
    game.activeBalls.single.isDead = true;

    game.update(1 / 30);

    expect(game.currentLives.value, 3);
    expect(game.battlePlayerState.phase, BattlePlayerPhase.respawnDelay);
    expect(game.battlePlayerState.respawnCount, 1);
    expect(game.activeBalls.single.isRespawningFromEdge, isTrue);
  });
}
