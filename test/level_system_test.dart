import 'dart:convert';
import 'dart:io';

import 'package:balanco_game/features/game/level_system/campaign_level_generator.dart';
import 'package:balanco_game/features/game/level_system/endless_chunk_generator.dart';
import 'package:balanco_game/features/game/level_system/level_definition.dart';
import 'package:balanco_game/features/game/level_system/level_definition_adapter.dart';
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

    test('marks every theme finale as a nightmare', () {
      final generator = CampaignLevelGenerator();

      for (final theme in CampaignLevelGenerator.themes) {
        expect(
          generator.generateLevel(theme.endLevel).isNightmare,
          isTrue,
          reason: 'level ${theme.endLevel}',
        );
      }
      expect(generator.generateLevel(44).isNightmare, isFalse);
    });

    test('adds early center pressure so the middle is not empty', () {
      final generator = CampaignLevelGenerator();

      for (var id = 1; id <= 19; id++) {
        final level = generator.generateLevel(id);
        expect(
          level.obstacles.any((obstacle) => (obstacle.x - 0.5).abs() < 0.08),
          isTrue,
          reason: 'level $id',
        );
      }
    });

    test('schedules dark levels 30 through 60 with shrinking light radius', () {
      final generator = CampaignLevelGenerator();

      expect(generator.generateLevel(29).isDark, isFalse);
      expect(generator.generateLevel(30).isDark, isTrue);
      expect(generator.generateLevel(60).isDark, isTrue);
      expect(generator.generateLevel(61).isDark, isFalse);
      expect(
        generator.generateLevel(30).nightMode!.lightRadius,
        greaterThan(generator.generateLevel(60).nightMode!.lightRadius),
      );
      expect(generator.generateLevel(30).nightMode!.startLitSeconds, equals(0));
    });

    test('varies hole sizes within the campaign', () {
      final level = CampaignLevelGenerator().generateLevel(20);
      final radii = level.obstacles
          .where((obstacle) => obstacle.type.endsWith('Hole'))
          .map((obstacle) => obstacle.radius.toStringAsFixed(3))
          .toSet();

      expect(radii.length, greaterThan(1));
    });

    test('contains at least 35 reusable pattern templates', () {
      expect(
        CampaignLevelGenerator.patternTemplateIds.length,
        greaterThanOrEqualTo(35),
      );
    });

    test('rolls out every reusable hole behavior with fair warnings', () {
      final generator = CampaignLevelGenerator();
      final behaviors = <String>{};

      for (var id = 16; id <= 500; id++) {
        for (final obstacle in generator.generateLevel(id).obstacles) {
          final behavior = obstacle.behavior;
          if (behavior == null || obstacle.type == 'bumper') continue;
          behaviors.add(behavior);
          if (behavior != 'pingPong' && behavior != 'spiralSuction') {
            expect(
              obstacle.warningDuration,
              greaterThanOrEqualTo(0.62),
              reason: 'level $id ${obstacle.id}',
            );
          }
        }
      }

      expect(
        behaviors,
        containsAll(<String>{
          'pulse',
          'wave',
          'nailLauncher',
          'orbit',
          'teleport',
          'chase',
          'split',
          'fake',
          'spiralSuction',
          'breathingVortex',
        }),
      );
    });

    test('introduces a fresh hole behavior every seven levels', () {
      final generator = CampaignLevelGenerator();
      const introductions = <int, String>{
        16: 'pulse',
        23: 'wave',
        30: 'orbit',
        37: 'teleport',
        44: 'split',
        51: 'nailLauncher',
        58: 'fake',
        65: 'chase',
      };

      for (final entry in introductions.entries) {
        expect(
          generator
              .generateLevel(entry.key)
              .obstacles
              .any((obstacle) => obstacle.behavior == entry.value),
          isTrue,
          reason: 'level ${entry.key} should introduce ${entry.value}',
        );
      }
    });

    test('pressures the center lanes on the 460px gameplay width', () {
      final level = CampaignLevelGenerator().generateLevel(48);
      final hazards = level.obstacles.where(
        (obstacle) => obstacle.type != 'bumper',
      );
      final centerCount = hazards
          .where((obstacle) => obstacle.x >= 0.35 && obstacle.x <= 0.65)
          .length;

      expect(hazards.length, greaterThanOrEqualTo(12));
      expect(centerCount / hazards.length, greaterThanOrEqualTo(0.30));
      expect(
        hazards.every((obstacle) => obstacle.x >= 0.12 && obstacle.x <= 0.88),
        isTrue,
      );
    });

    test('adds shooter boss encounters at the requested milestones', () {
      final generator = CampaignLevelGenerator();
      for (final levelId in [50, 100, 200, 300, 400, 500]) {
        final data = generator.generateLevel(levelId).toLevelData();
        expect(data.villains, hasLength(1), reason: 'level $levelId');
        expect(data.shooterHelpers, hasLength(1), reason: 'level $levelId');
      }
      expect(generator.generateLevel(150).toLevelData().villains, isEmpty);
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

    test('does not repeat a primary pattern in the next two chunks', () {
      const generator = EndlessChunkGenerator(runSeed: 42);
      final recent = <String>[];

      for (var index = 0; index < 24; index++) {
        final chunk = generator.generateChunk(
          chunkIndex: index,
          score: 900,
          elapsedMinutes: 5,
        );
        final pattern = chunk.patternIds.single;
        if (pattern != 'recovery_chunk') {
          expect(recent, isNot(contains(pattern)), reason: 'chunk $index');
        }
        recent.add(pattern);
        if (recent.length > 2) recent.removeAt(0);
      }
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
