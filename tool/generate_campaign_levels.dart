import 'dart:convert';
import 'dart:io';

import 'package:balanco_game/features/game/level_system/campaign_level_generator.dart';

void main() {
  final generator = CampaignLevelGenerator();
  final levels = generator.generateCampaign();
  final levelsDir = Directory('assets/levels')..createSync(recursive: true);

  for (var start = 1; start <= 500; start += 50) {
    final end = start + 49;
    final chunk = levels.where((level) => level.id >= start && level.id <= end);
    final file = File(
      '${levelsDir.path}/levels_${_pad(start)}_${_pad(end)}.json',
    );
    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(
      encoder.convert({
        'schemaVersion': 1,
        'levels': chunk.map((level) => level.toJson()).toList(),
      }),
    );
  }

  final report = StringBuffer()
    ..writeln(
      [
        'level_id',
        'theme',
        'difficulty',
        'world_height',
        'target_duration',
        'regular_hole_count',
        'moving_hole_count',
        'suction_hole_count',
        'bumper_count',
        'bomb_wave_count',
        'teleport_count',
        'helper_count',
        'nightmare',
        'validation_attempts',
        'final_seed',
      ].join(','),
    );

  for (final level in levels) {
    int countObstacles(String type) =>
        level.obstacles.where((obstacle) => obstacle.type == type).length;
    final helperCount = level.pickups
        .where((pickup) => pickup.type != 'star')
        .length;
    report.writeln(
      [
        level.id,
        level.themeId,
        level.difficulty.toStringAsFixed(4),
        level.worldHeight.toStringAsFixed(2),
        level.timeLimitSeconds,
        countObstacles('regularHole'),
        countObstacles('movingHole'),
        countObstacles('suckingHole'),
        countObstacles('bumper'),
        level.bombWaves.length,
        level.teleportPairs.length,
        helperCount,
        level.isNightmare,
        level.validationAttempts,
        level.seed,
      ].join(','),
    );
  }

  File(
    '${levelsDir.path}/level_generation_report.csv',
  ).writeAsStringSync(report.toString());
}

String _pad(int value) => value.toString().padLeft(3, '0');
