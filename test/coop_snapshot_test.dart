import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/ball_data.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('co-op replica applies authoritative world and countdown state', () {
    final host = BalancoGame(
      isMultiplayer: true,
      isInfinityMode: true,
      playerRole: 'RIGHT',
      randomSeed: 42,
    )..onGameResize(Vector2(400, 800));
    host
      ..leftY = 510
      ..rightY = 390
      ..cameraOffsetY = 175
      ..countdownTimer = 2.4;
    host.currentScore.value = 17;
    host.remainingShields.value = 2;
    host.shieldTimer = 4.25;
    host.activeBalls.add(BallData()..pos2D = Vector2(210, 330));

    final guest = BalancoGame(
      isMultiplayer: true,
      isInfinityMode: true,
      playerRole: 'LEFT',
      randomSeed: 42,
    )..onGameResize(Vector2(400, 800));
    guest
      ..enableCoopReplica()
      ..applyCoopSnapshot(host.createCoopSnapshot())
      ..update(1 / 60);

    expect(guest.leftY, 510);
    expect(guest.rightY, 390);
    expect(guest.cameraOffsetY, 175);
    expect(guest.countdownTimer, 2.4);
    expect(guest.countdownNotifier.value, 3);
    expect(guest.currentScore.value, 17);
    expect(guest.remainingShields.value, 2);
    expect(guest.shieldTimer, 4.25);
    expect(guest.shieldTimerNotifier.value, 4.25);
    expect(guest.activeBalls.single.pos2D, Vector2(210, 330));
  });

  test('shield activation consumes one charge and cannot stack', () {
    final game = BalancoGame(
      isMultiplayer: true,
      isInfinityMode: true,
      playerRole: 'RIGHT',
      randomSeed: 42,
    );

    expect(game.activateShield(), isTrue);
    expect(game.remainingShields.value, 2);
    expect(game.shieldTimer, 5);
    expect(game.activateShield(), isFalse);
    expect(game.remainingShields.value, 2);
  });
}
