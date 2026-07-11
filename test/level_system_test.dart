import 'dart:convert';
import 'dart:io';

import 'package:balanco_game/features/game/level_system/campaign_level_generator.dart';
import 'package:balanco_game/features/game/level_system/endless_chunk_generator.dart';
import 'package:balanco_game/features/game/level_system/level_definition.dart';
import 'package:balanco_game/features/game/level_system/level_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CampaignLevelGenerator', () {
    test('generates deterministic level JSON', () {
      final generator = CampaignLevelGenerator();

      final first = generator.generateLevel(100).toJsonString();
      final second = generator.generateLevel(100).toJsonString();

      expect(first, second);
    });

    test('round-trips JSON serialization', () {
      final level = CampaignLevelGenerator().generateLevel(24);
      final decoded = LevelDefinition.fromJson(
        (jsonDecode(level.toJsonString()) as Map).cast<String, dynamic>(),
      );

      expect(decoded.toJsonString(), level.toJsonString());
    });

    test('uses the requested theme boundaries', () {
      expect(CampaignLevelGenerator.themeIdForLevel(1), 'beach');
      expect(CampaignLevelGenerator.themeIdForLevel(15), 'beach');
      expect(CampaignLevelGenerator.themeIdForLevel(16), 'egypt');
      expect(CampaignLevelGenerator.themeIdForLevel(45), 'egypt');
      expect(CampaignLevelGenerator.themeIdForLevel(46), 'jungle');
      expect(CampaignLevelGenerator.themeIdForLevel(495), 'eclipse');
      expect(CampaignLevelGenerator.themeIdForLevel(496), 'final_nightmare');
      expect(CampaignLevelGenerator.themeIdForLevel(500), 'final_nightmare');
    });

    test('contains at least 35 reusable pattern templates', () {
      expect(
        CampaignLevelGenerator.patternTemplateIds.length,
        greaterThanOrEqualTo(35),
      );
    });

    test('generates valid levels 1 through 500', () {
      final generator = CampaignLevelGenerator();
      final validator = LevelValidator();

      for (var id = 1; id <= 500; id++) {
        final level = generator.generateLevel(id);
        final validation = validator.validate(level);
        expect(validation.errors, isEmpty, reason: 'level $id');
        expect(
          level.pickups.where((pickup) => pickup.type == 'star'),
          hasLength(3),
        );
        expect(
          level.seed,
          greaterThanOrEqualTo(CampaignLevelGenerator.seedForLevel(id)),
        );
        _expectNoDuplicateIds(level);
        _expectCoordinatesInRange(level);
      }
    });

    test('introduces helpers at the tutorial unlock levels', () {
      final generator = CampaignLevelGenerator();

      expect(
        generator
            .generateLevel(8)
            .pickups
            .any((pickup) => pickup.type == 'magnet'),
        isTrue,
      );
      expect(
        generator
            .generateLevel(9)
            .pickups
            .any(
              (pickup) => pickup.type == 'extraBall' || pickup.type == 'heart',
            ),
        isTrue,
      );
      expect(generator.generateLevel(10).teleportPairs, isNotEmpty);
      expect(generator.generateLevel(11).nightMode?.lightPickups, hasLength(2));
      expect(
        generator
            .generateLevel(12)
            .pickups
            .any((pickup) => pickup.type == 'shield'),
        isTrue,
      );
    });

    test('baked assets cover all 500 levels', () {
      final ids = <int>{};

      for (var start = 1; start <= 500; start += 50) {
        final end = start + 49;
        final file = File(
          'assets/levels/levels_${_pad(start)}_${_pad(end)}.json',
        );
        expect(file.existsSync(), isTrue, reason: file.path);

        final decoded =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final levels = decoded['levels'] as List;
        expect(levels, hasLength(50));
        for (final levelJson in levels) {
          final level = LevelDefinition.fromJson(
            (levelJson as Map).cast<String, dynamic>(),
          );
          ids.add(level.id);
        }
      }

      expect(ids, hasLength(500));
      expect(ids.contains(1), isTrue);
      expect(ids.contains(500), isTrue);
      expect(
        File('assets/levels/level_generation_report.csv').existsSync(),
        isTrue,
      );
    });
  });

  group('EndlessChunkGenerator', () {
    test('difficulty is monotonic with score and time', () {
      final low = EndlessChunkGenerator.endlessDifficulty(
        score: 0,
        elapsedMinutes: 0,
      );
      final mid = EndlessChunkGenerator.endlessDifficulty(
        score: 650,
        elapsedMinutes: 3,
      );
      final high = EndlessChunkGenerator.endlessDifficulty(
        score: 1801,
        elapsedMinutes: 8,
      );

      expect(low, lessThan(mid));
      expect(mid, lessThan(high));
    });

    test('uses deterministic run seeds', () {
      const generator = EndlessChunkGenerator(runSeed: 42);

      final first = generator
          .generateChunk(chunkIndex: 4, score: 500, elapsedMinutes: 2)
          .toJsonString();
      final second = generator
          .generateChunk(chunkIndex: 4, score: 500, elapsedMinutes: 2)
          .toJsonString();

      expect(first, second);
    });
  });
}

void _expectNoDuplicateIds(LevelDefinition level) {
  final ids = <String>{};
  for (final obstacle in level.obstacles) {
    expect(ids.add(obstacle.id), isTrue, reason: 'level ${level.id}');
  }
  for (final pickup in level.pickups) {
    expect(ids.add(pickup.id), isTrue, reason: 'level ${level.id}');
  }
  for (final wave in level.bombWaves) {
    expect(ids.add(wave.id), isTrue, reason: 'level ${level.id}');
  }
  for (final pair in level.teleportPairs) {
    expect(ids.add(pair.id), isTrue, reason: 'level ${level.id}');
  }
}

void _expectCoordinatesInRange(LevelDefinition level) {
  for (final obstacle in level.obstacles) {
    expect(obstacle.x.isFinite, isTrue);
    expect(obstacle.y.isFinite, isTrue);
    expect(obstacle.x, inInclusiveRange(0.0, 1.0), reason: obstacle.id);
    expect(
      obstacle.y,
      inInclusiveRange(0.0, level.worldHeight),
      reason: obstacle.id,
    );
  }
  for (final pickup in level.pickups) {
    expect(pickup.x.isFinite, isTrue);
    expect(pickup.y.isFinite, isTrue);
    expect(pickup.x, inInclusiveRange(0.0, 1.0), reason: pickup.id);
    expect(
      pickup.y,
      inInclusiveRange(0.0, level.worldHeight),
      reason: pickup.id,
    );
  }
}

String _pad(int value) => value.toString().padLeft(3, '0');
