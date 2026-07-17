import 'package:balanco_game/features/notifications/domain/game_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses an actionable unread game invite', () {
    final notification = GameNotification.fromJson({
      'id': 'notification-id',
      'recipient_id': 'recipient-id',
      'actor_id': 'actor-id',
      'notification_type': 'game_invite',
      'title': 'RACE INVITATION!',
      'body': 'Karem invited you to play RACE.',
      'data': {'invite_id': 'invite-id', 'room_id': 'room-id', 'mode': 'race'},
      'created_at': '2026-07-17T12:00:00Z',
      'read_at': null,
    });

    expect(notification.isRead, isFalse);
    expect(notification.canRespondToGameInvite, isTrue);
    expect(notification.canRespondToFriendRequest, isFalse);
    expect(notification.data['room_id'], 'room-id');
  });

  test('read notifications no longer expose response actions', () {
    final notification = GameNotification.fromJson({
      'id': 'notification-id',
      'recipient_id': 'recipient-id',
      'notification_type': 'friend_request',
      'title': 'NEW FRIEND REQUEST!',
      'body': 'A player wants to be your friend.',
      'data': {'request_id': 'request-id'},
      'created_at': '2026-07-17T12:00:00Z',
      'read_at': '2026-07-17T12:01:00Z',
    });

    expect(notification.isRead, isTrue);
    expect(notification.canRespondToFriendRequest, isFalse);
  });
}
