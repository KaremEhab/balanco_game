import 'package:balanco_game/features/auth/domain/auth_repository.dart';
import 'package:balanco_game/features/auth/domain/player_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get hasSession => _client.auth.currentSession != null;

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required String username,
    required int age,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      data: {
        'display_name': displayName.trim(),
        'username': username.trim(),
        'age': age,
      },
    );
    return response.session != null;
  }

  @override
  Future<PlayerAccount> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
    return (await loadCurrentPlayer())!;
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _client.auth.resetPasswordForEmail(email.trim().toLowerCase());

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<PlayerAccount?> loadCurrentPlayer() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final response = await _client.rpc('get_my_player_state');
    return PlayerAccount.fromState(
      Map<String, dynamic>.from(response as Map),
      email: user.email ?? '',
    );
  }

  @override
  Future<PlayerAccount> updateProfile({
    required String displayName,
    required String username,
    required int age,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Authentication required');
    await _client
        .from('profiles')
        .update({
          'display_name': displayName.trim(),
          'username': username.trim(),
          'age': age,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', user.id);
    return (await loadCurrentPlayer())!;
  }

  @override
  Future<PlayerAccount> recordGameResult({
    required String attemptId,
    required int levelId,
    required bool won,
    int points = 0,
    int stars = 0,
  }) async {
    final response = await _client.rpc(
      'record_game_result',
      params: {
        'p_client_attempt_id': attemptId,
        'p_level_id': levelId,
        'p_result': won ? 'victory' : 'game_over',
        'p_points': points,
        'p_stars': stars,
      },
    );
    return PlayerAccount.fromState(
      Map<String, dynamic>.from(response as Map),
      email: _client.auth.currentUser?.email ?? '',
    );
  }

  @override
  Future<PlayerAccount> recordInfinityRun({
    required String runId,
    required int score,
    required int coins,
  }) async {
    final response = await _client.rpc(
      'record_infinity_run',
      params: {'p_client_run_id': runId, 'p_score': score, 'p_coins': coins},
    );
    return PlayerAccount.fromState(
      Map<String, dynamic>.from(response as Map),
      email: _client.auth.currentUser?.email ?? '',
    );
  }
}
