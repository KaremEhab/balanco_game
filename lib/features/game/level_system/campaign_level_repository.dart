import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:balanco_game/features/game/level_system/level_definition.dart';

class CampaignLevelRepository {
  static final CampaignLevelRepository instance = CampaignLevelRepository(
    assetBundle: rootBundle,
  );

  final AssetBundle assetBundle;
  final Map<int, LevelDefinition> _cache = {};
  final Set<int> _loadedChunks = {};

  CampaignLevelRepository({required this.assetBundle});

  Future<LevelDefinition?> loadLevel(int levelId) async {
    if (levelId < 1 || levelId > 500) return null;
    if (_cache.containsKey(levelId)) return _cache[levelId];

    final chunkStart = ((levelId - 1) ~/ 50) * 50 + 1;
    if (_loadedChunks.contains(chunkStart)) return _cache[levelId];

    final chunkEnd = chunkStart + 49;
    final path =
        'assets/levels/levels_${_pad(chunkStart)}_${_pad(chunkEnd)}.json';
    try {
      final raw = await assetBundle.loadString(path);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final levels = decoded['levels'] as List;
      for (final levelJson in levels) {
        final level = LevelDefinition.fromJson(
          (levelJson as Map).cast<String, dynamic>(),
        );
        _cache[level.id] = level;
      }
      _loadedChunks.add(chunkStart);
      return _cache[levelId];
    } catch (_) {
      _loadedChunks.add(chunkStart);
      return null;
    }
  }

  static String _pad(int value) => value.toString().padLeft(3, '0');
}
