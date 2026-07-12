import 'package:flutter/foundation.dart';
import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/core/data/models.dart';
import 'package:balanco_game/features/auth/data/supabase_auth_repository.dart';
import 'package:balanco_game/features/auth/domain/auth_repository.dart';
import 'package:balanco_game/features/auth/domain/player_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerSession {
  PlayerSession._();

  static final PlayerSession instance = PlayerSession._();
  final ValueNotifier<PlayerAccount?> player = ValueNotifier(null);

  AuthRepository? get repository {
    if (!SupabaseConfig.isConfigured) return null;
    return SupabaseAuthRepository(Supabase.instance.client);
  }

  bool get isAuthenticated => repository?.hasSession ?? false;

  Future<PlayerAccount?> refresh() async {
    final repo = repository;
    if (repo == null) return null;
    await _flushPendingResults(repo);
    final account = await repo.loadCurrentPlayer();
    if (account != null) await use(account);
    return account;
  }

  Future<void> use(PlayerAccount account) async {
    player.value = account;
    AppSettings.setPlayerName(account.displayName);
    final local = await DatabaseHelper.instance.getPlayerProfile();
    await DatabaseHelper.instance.updatePlayerProfile(
      local.copyWith(
        highestLevel: account.highestLevel,
        lastPlayedLevel: account.lastPlayedLevel,
        coins: account.coins,
        moneyCents: account.moneyCents,
        sparks: account.sparks,
        maxSparks: account.maxSparks,
        totalPoints: account.totalPoints,
        infinityHighScore: account.infinityHighScore,
      ),
    );
  }

  Future<void> recordGameOver({
    required String attemptId,
    required int levelId,
  }) async {
    final local = await DatabaseHelper.instance.getPlayerProfile();
    await DatabaseHelper.instance.updatePlayerProfile(
      local.copyWith(sparks: (local.sparks - 1).clamp(0, local.maxSparks)),
    );
    final repo = repository;
    if (repo == null || !repo.hasSession) return;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await DatabaseHelper.instance.enqueueGameResult(
      attemptId: attemptId,
      userId: userId,
      levelId: levelId,
      won: false,
      points: 0,
      stars: 0,
    );
    try {
      await use(
        await repo.recordGameResult(
          attemptId: attemptId,
          levelId: levelId,
          won: false,
        ),
      );
      await DatabaseHelper.instance.removePendingGameResult(attemptId);
    } catch (error) {
      debugPrint('Game-over cloud sync remains queued: $error');
    }
  }

  Future<void> recordVictory({
    required String attemptId,
    required int levelId,
    required int points,
    required int stars,
  }) async {
    final local = await DatabaseHelper.instance.getPlayerProfile();
    final nextLevel = (levelId + 1).clamp(1, 500);
    await DatabaseHelper.instance.updatePlayerProfile(
      local.copyWith(
        highestLevel: nextLevel > local.highestLevel
            ? nextLevel
            : local.highestLevel,
        lastPlayedLevel: levelId,
        totalPoints: local.totalPoints + points,
      ),
    );
    final existing = await DatabaseHelper.instance.getLevelProgress(levelId);
    if (stars > (existing?.stars ?? 0)) {
      await DatabaseHelper.instance.saveLevelProgress(
        LevelProgress(levelId: levelId, stars: stars, isUnlocked: true),
      );
    }
    final repo = repository;
    if (repo == null || !repo.hasSession) return;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await DatabaseHelper.instance.enqueueGameResult(
      attemptId: attemptId,
      userId: userId,
      levelId: levelId,
      won: true,
      points: points,
      stars: stars,
    );
    try {
      await use(
        await repo.recordGameResult(
          attemptId: attemptId,
          levelId: levelId,
          won: true,
          points: points,
          stars: stars,
        ),
      );
      await DatabaseHelper.instance.removePendingGameResult(attemptId);
    } catch (error) {
      debugPrint('Victory cloud sync queued for next refresh: $error');
    }
  }

  Future<void> _flushPendingResults(AuthRepository repo) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final pending = await DatabaseHelper.instance.getPendingGameResults(userId);
    for (final result in pending) {
      final attemptId = result['attempt_id'] as String;
      try {
        await use(
          await repo.recordGameResult(
            attemptId: attemptId,
            levelId: result['level_id'] as int,
            won: (result['won'] as int) == 1,
            points: result['points'] as int,
            stars: result['stars'] as int,
          ),
        );
        await DatabaseHelper.instance.removePendingGameResult(attemptId);
      } catch (error) {
        debugPrint('Stopped outbox sync after a network/server error: $error');
        break;
      }
    }

    final infinityRuns = await DatabaseHelper.instance.getPendingInfinityRuns(
      userId,
    );
    for (final run in infinityRuns) {
      final runId = run['run_id'] as String;
      try {
        await use(
          await repo.recordInfinityRun(
            runId: runId,
            score: run['score'] as int,
            coins: run['coins'] as int,
          ),
        );
        await DatabaseHelper.instance.removePendingInfinityRun(runId);
      } catch (error) {
        debugPrint('Stopped Infinity outbox sync after an error: $error');
        break;
      }
    }
  }

  Future<void> recordInfinityRun({
    required String runId,
    required int score,
    required int coins,
  }) async {
    final local = await DatabaseHelper.instance.getPlayerProfile();
    await DatabaseHelper.instance.updatePlayerProfile(
      local.copyWith(
        coins: local.coins + coins,
        infinityHighScore: score > local.infinityHighScore
            ? score
            : local.infinityHighScore,
      ),
    );

    final repo = repository;
    if (repo == null || !repo.hasSession) return;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await DatabaseHelper.instance.enqueueInfinityRun(
      runId: runId,
      userId: userId,
      score: score,
      coins: coins,
    );
    try {
      await use(
        await repo.recordInfinityRun(runId: runId, score: score, coins: coins),
      );
      await DatabaseHelper.instance.removePendingInfinityRun(runId);
    } catch (error) {
      debugPrint('Infinity run cloud sync remains queued: $error');
    }
  }

  Future<void> clear() async {
    player.value = null;
    await repository?.signOut();
  }
}
