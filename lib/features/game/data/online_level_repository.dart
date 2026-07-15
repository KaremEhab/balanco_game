import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnlineGameLevel {
  const OnlineGameLevel({
    required this.levelId,
    required this.version,
    required this.definitionFormat,
    required this.coordinateSpace,
    required this.definition,
  });

  final int levelId;
  final int version;
  final String definitionFormat;
  final String coordinateSpace;
  final Map<String, dynamic> definition;

  factory OnlineGameLevel.fromJson(Map<String, dynamic> json) =>
      OnlineGameLevel(
        levelId: (json['level_id'] as num).toInt(),
        version: (json['version'] as num).toInt(),
        definitionFormat: json['definition_format'] as String,
        coordinateSpace: json['coordinate_space'] as String,
        definition: Map<String, dynamic>.from(json['definition'] as Map),
      );
}

class OnlineLevelRepository {
  OnlineLevelRepository._();

  static final OnlineLevelRepository instance = OnlineLevelRepository._();

  SupabaseClient? get _client {
    if (!SupabaseConfig.isConfigured) return null;
    try {
      final client = Supabase.instance.client;
      return client.auth.currentUser == null ? null : client;
    } catch (_) {
      return null;
    }
  }

  Future<OnlineGameLevel?> loadLevel(int levelId, {int? version}) async {
    final client = _client;
    if (client == null || levelId < 1 || levelId > 500) return null;
    try {
      final result = await client.rpc(
        'get_game_level',
        params: {'p_level_id': levelId, 'p_version': version},
      );
      if (result == null) return null;
      return OnlineGameLevel.fromJson(Map<String, dynamic>.from(result as Map));
    } catch (error) {
      debugPrint(
        'Online level $levelId unavailable; using bundled level: $error',
      );
      return null;
    }
  }

  Future<bool> canPublish() async {
    final client = _client;
    if (client == null) return false;
    try {
      final allowed = await client.rpc('is_level_editor') as bool? ?? false;
      if (allowed) return true;
      // Owner/editor authorization lives in app_metadata. Refresh once so a
      // newly granted role is available without forcing a manual sign-out.
      await client.auth.refreshSession();
      return await client.rpc('is_level_editor') as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<OnlineGameLevel> publishLevel({
    required int levelId,
    required Map<String, dynamic> definition,
    int? expectedVersion,
  }) async {
    final client = _client;
    if (client == null) throw StateError('Sign in before publishing levels.');
    final result = await client.rpc(
      'publish_game_level',
      params: {
        'p_level_id': levelId,
        'p_definition': definition,
        'p_expected_version': expectedVersion,
      },
    );
    return OnlineGameLevel.fromJson(Map<String, dynamic>.from(result as Map));
  }
}
