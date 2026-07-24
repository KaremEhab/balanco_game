import 'package:balanco_game/features/game/game_area.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'new unseeded Infinity runs receive different obstacle layouts',
    () async {
      final first = await _loadInfinityGame();
      final second = await _loadInfinityGame();

      expect(first.effectiveWorldSeed, isNot(second.effectiveWorldSeed));
      expect(_obstacleSignature(first), isNot(_obstacleSignature(second)));
    },
  );

  test('explicit Infinity seeds remain deterministic', () async {
    final first = await _loadInfinityGame(seed: 8472);
    final second = await _loadInfinityGame(seed: 8472);

    expect(first.effectiveWorldSeed, second.effectiveWorldSeed);
    expect(_obstacleSignature(first), _obstacleSignature(second));
  });

  test('retrying an unseeded Infinity run creates a fresh layout', () async {
    final game = await _loadInfinityGame();
    final firstSeed = game.effectiveWorldSeed;
    final firstLayout = _obstacleSignature(game);

    await game.restartCurrentLevel();

    expect(game.effectiveWorldSeed, isNot(firstSeed));
    expect(_obstacleSignature(game), isNot(firstLayout));
  });
}

Future<BalancoGame> _loadInfinityGame({int? seed}) async {
  final game = BalancoGame(
    isMultiplayer: false,
    isInfinityMode: true,
    playerRole: 'BOTH',
    randomSeed: seed,
    enableTutorials: false,
  )..onGameResize(Vector2(400, 800));
  await Future<void>.delayed(Duration.zero);
  await game.onLoad();
  return game;
}

List<String> _obstacleSignature(BalancoGame game) => [
  ...game.holes.map(
    (hole) =>
        'h:${hole.position.x.toStringAsFixed(3)}:'
        '${hole.position.y.toStringAsFixed(3)}',
  ),
  ...game.bumpers.map(
    (bumper) =>
        'b:${bumper.position.x.toStringAsFixed(3)}:'
        '${bumper.position.y.toStringAsFixed(3)}',
  ),
];
