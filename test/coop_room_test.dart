import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('room becomes startable only when both sides are ready', () {
    final room = CoopRoom.fromJson({
      'room': {
        'id': 'room-id',
        'room_code': 'ABC123',
        'host_id': 'host',
        'status': 'waiting',
        'host_side': 'left',
        'seed': 42,
        'score': 0,
        'leave_requested_by': null,
      },
      'members': [
        {
          'user_id': 'host',
          'display_name': 'Kareem',
          'player_code': 'KA27-A1B2C',
          'side': 'left',
          'ready': true,
          'is_host': true,
          'mic_muted': false,
        },
        {
          'user_id': 'guest',
          'display_name': 'Partner',
          'player_code': 'PA27-D3E4F',
          'side': 'right',
          'ready': true,
          'is_host': false,
          'mic_muted': false,
        },
      ],
    });

    expect(room.canStart, isTrue);
    expect(room.memberFor('host').side, CoopSide.left);
    expect(room.memberFor('guest').side, CoopSide.right);
  });

  test(
    'four-player race requires every selected slot and uses session wins',
    () {
      final room = CoopRoom.fromJson({
        'room': {
          'id': 'race-id',
          'room_code': 'RACE44',
          'host_id': 'p1',
          'status': 'waiting',
          'host_side': 'left',
          'seed': 7,
          'mode': 'race',
          'max_players': 4,
          'race_level': 3,
          'restart_vote_count': 2,
        },
        'members': [
          for (var index = 1; index <= 4; index++)
            {
              'user_id': 'p$index',
              'display_name': 'Player $index',
              'player_code': 'PL$index-CODE',
              'side': 'slot$index',
              'ready': true,
              'is_host': index == 1,
              'mic_muted': false,
              'session_wins': index - 1,
            },
        ],
      });

      expect(room.canStart, isTrue);
      expect(room.maxPlayers, 4);
      expect(room.members.map((member) => member.sessionWins), [0, 1, 2, 3]);
      expect(room.opponentsOf('p1'), hasLength(3));
      expect(room.restartVoteCount, 2);
    },
  );

  test('race session wins default to zero for a brand-new room', () {
    final member = CoopMember.fromJson({
      'user_id': 'new-player',
      'display_name': 'New Player',
      'player_code': 'NE20-12345',
      'side': 'slot1',
      'ready': false,
      'is_host': true,
      'mic_muted': false,
      'race_wins': 99,
    });

    expect(member.raceWins, 99);
    expect(member.sessionWins, 0);
  });

  test('co-op campaign exposes shared level range and end states', () {
    final room = CoopRoom.fromJson({
      'room': {
        'id': 'coop-series',
        'room_code': 'COOP55',
        'host_id': 'p1',
        'status': 'ended',
        'host_side': 'left',
        'seed': 17,
        'mode': 'coop',
        'race_level': 4,
        'race_start_level': 2,
        'race_end_level': 5,
        'end_reason': 'completed',
      },
      'members': [
        {
          'user_id': 'p1',
          'display_name': 'Host',
          'player_code': 'HOST',
          'side': 'left',
          'ready': true,
          'is_host': true,
        },
        {
          'user_id': 'p2',
          'display_name': 'Partner',
          'player_code': 'PARTNER',
          'side': 'right',
          'ready': true,
          'is_host': false,
        },
      ],
    });

    expect(room.levelRangeCount, 4);
    expect(room.levelRangePosition, 3);
    expect(room.isCoopLevelComplete, isTrue);
    expect(room.hasMoreCoopLevels, isTrue);
    expect(room.isCoopRunComplete, isFalse);
  });

  test('race series exposes its round, champion, and cumulative stars', () {
    final room = CoopRoom.fromJson({
      'room': {
        'id': 'series-id',
        'room_code': 'SERIES',
        'host_id': 'p1',
        'status': 'ended',
        'host_side': 'left',
        'seed': 13,
        'mode': 'race',
        'race_level': 9,
        'race_start_level': 5,
        'race_end_level': 9,
        'series_winner_id': 'p2',
        'series_end_kind': 'winner',
        'series_finished_at': '2026-07-18T12:00:00Z',
      },
      'members': [
        {
          'user_id': 'p1',
          'display_name': 'Host',
          'player_code': 'HO-CODE',
          'side': 'slot1',
          'ready': true,
          'is_host': true,
          'session_wins': 2,
          'series_stars': 4,
          'highest_level': 12,
        },
        {
          'user_id': 'p2',
          'display_name': 'Champion',
          'player_code': 'CH-CODE',
          'side': 'slot2',
          'ready': true,
          'is_host': false,
          'session_wins': 2,
          'series_stars': 6,
          'highest_level': 20,
        },
      ],
    });

    expect(room.seriesRoundCount, 5);
    expect(room.seriesRoundNumber, 5);
    expect(room.hasMoreSeriesLevels, isFalse);
    expect(room.isSeriesFinished, isTrue);
    expect(room.seriesWinnerId, 'p2');
    expect(room.memberFor('p2').seriesStars, 6);
    expect(room.memberFor('p2').highestLevel, 20);
  });

  test('race room preserves departed racers and global pickup owners', () {
    final room = CoopRoom.fromJson({
      'room': {
        'id': 'race-id',
        'room_code': 'GLOBAL',
        'host_id': 'p1',
        'status': 'playing',
        'host_side': 'left',
        'seed': 9,
        'mode': 'race',
        'race_level': 4,
        'attempt_number': 2,
      },
      'members': [
        {
          'user_id': 'p1',
          'display_name': 'Player One',
          'player_code': 'P1-CODE',
          'side': 'slot1',
          'ready': true,
          'is_host': true,
        },
        {
          'user_id': 'p2',
          'display_name': 'Player Two',
          'player_code': 'P2-CODE',
          'side': 'slot2',
          'ready': false,
          'is_host': false,
          'eliminated_at': '2026-07-18T09:00:00Z',
          'left_at': '2026-07-18T09:00:00Z',
        },
      ],
      'race_pickup_claims': [
        {
          'pickup_key': 'star:0',
          'pickup_type': 'star',
          'claimant_id': 'p1',
          'claimant_name': 'Player One',
          'claimed_at': '2026-07-18T08:59:58Z',
        },
        {
          'pickup_key': 'magnet:0',
          'pickup_type': 'magnet',
          'claimant_id': 'p2',
          'claimant_name': 'Player Two',
          'claimed_at': '2026-07-18T08:59:59Z',
        },
      ],
    });

    expect(room.memberFor('p2').hasLeft, isTrue);
    expect(room.requiredVotes, 1);
    expect(room.racePickupClaims, hasLength(2));
    expect(room.racePickupClaims.first.pickupKey, 'star:0');
    expect(room.racePickupClaims.last.claimantId, 'p2');
  });
}
