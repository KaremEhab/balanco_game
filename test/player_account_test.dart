import 'package:balanco_game/features/auth/domain/player_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provider-created player remains in onboarding until profile is complete', () {
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
      'unlocks': const [],
    }, email: 'player@example.com');

    expect(account.needsProfileSetup, isTrue);
  });
}
