import 'package:balanco_game/features/auth/domain/player_account.dart';

abstract interface class AuthRepository {
  bool get hasSession;

  Future<PlayerAccount?> loadCurrentPlayer();
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required String username,
    required int age,
  });
  Future<PlayerAccount> signIn({
    required String email,
    required String password,
  });
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
  Future<PlayerAccount> updateProfile({
    required String displayName,
    required String username,
    required int age,
  });
  Future<PlayerAccount> recordGameResult({
    required String attemptId,
    required int levelId,
    required bool won,
    int points,
    int stars,
  });
  Future<PlayerAccount> recordInfinityRun({
    required String runId,
    required int score,
    required int coins,
  });
}
