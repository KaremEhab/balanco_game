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
}
