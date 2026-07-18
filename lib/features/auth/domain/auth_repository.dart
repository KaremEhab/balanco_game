import 'package:balanco_game/features/auth/domain/player_account.dart';

enum SocialAuthProvider { google, apple }

abstract interface class AuthRepository {
  bool get hasSession;
  Stream<PlayerAccount> get authCompletions;

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
  Future<PlayerAccount?> signInWithSocial(SocialAuthProvider provider);
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
