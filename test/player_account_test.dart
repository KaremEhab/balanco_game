import 'package:balanco_game/core/data/models.dart';
import 'package:balanco_game/features/auth/domain/player_account.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'provider-created player remains in onboarding until profile is complete',
    () {
      final account = PlayerAccount.fromState({
        'profile': {
          'id': 'social-player',
          'username': 'player_1234567890123',
          'player_code': 'PL18-A1B2C',
          'display_name': 'Social Player',
          'age': 18,
          'profile_completed': false,
        },
        'progress': {
          'highest_level': 1,
          'last_played_level': 1,
          'total_points': 0,
          'infinity_high_score': 0,
        },
        'wallet': {
          'coins': 5000,
          'money_cents': 500,
          'sparks': 5,
          'max_sparks': 5,
        },
        'levels': [
          {'level_id': 1, 'stars': 3, 'best_points': 12, 'passed': true},
        ],
        'unlocks': const [],
      }, email: 'player@example.com');

      expect(account.needsProfileSetup, isTrue);
      expect(account.highestLevel, 1);
      expect(account.levelStars, {1: 3});
    },
  );

  test('every new account starts fresh regardless of auth provider', () {
    final local = PlayerProfile(
      isFirstOpen: false,
      highestLevel: 15,
      lastPlayedLevel: 14,
      coins: 8000,
      moneyCents: 900,
      sparks: 2,
      maxSparks: 5,
      totalPoints: 1200,
      streak: 5,
      infinityHighScore: 400,
    );
    final newAccount = PlayerAccount.fromState({
      'profile': {
        'id': 'new-authenticated-player',
        'username': 'player_newaccount',
        'player_code': 'PL18-Z9Y8X',
        'display_name': 'New Player',
        'age': 18,
        'profile_completed': false,
      },
      'progress': {
        'highest_level': 1,
        'last_played_level': 1,
        'total_points': 0,
        'infinity_high_score': 0,
      },
      'wallet': {
        'coins': 5000,
        'money_cents': 500,
        'sparks': 5,
        'max_sparks': 5,
      },
      'levels': const [],
      'unlocks': const [],
    }, email: 'new-player@example.com');

    final result = localProfileForAuthenticatedAccount(local, newAccount);

    expect(result.highestLevel, 1);
    expect(result.lastPlayedLevel, 1);
    expect(result.totalPoints, 0);
    expect(result.infinityHighScore, 0);
    expect(result.coins, 5000);
  });
}
