import 'package:balanco_game/features/coop/domain/player_social_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('own social profile keeps private wallet and friend details', () {
    final profile =
        PlayerSocialProfile.fromJson({
          'id': 'player-id',
          'display_name': 'Kareem',
          'username': 'kareem',
          'age': 27,
          'player_code': 'KA27-A1B2C',
          'avatar_shape': 'circle',
          'highest_level': 5,
          'total_points': 18,
          'infinity_high_score': 90,
          'race_wins': 2,
          'friend_count': 1,
          'friendship_status': 'self',
          'friends': [
            {
              'id': 'friend-id',
              'display_name': 'Friend',
              'player_code': 'FR25-X9Y8Z',
              'avatar_shape': 'square',
            },
          ],
        }).withPrivateStats(
          coins: 5000,
          moneyCents: 500,
          sparks: 4,
          maxSparks: 5,
          unlockedItems: 3,
        );

    expect(profile.isSelf, isTrue);
    expect(profile.raceWins, 2);
    expect(profile.coins, 5000);
    expect(profile.moneyCents, 500);
    expect(profile.friends.single.playerCode, 'FR25-X9Y8Z');
  });
}
