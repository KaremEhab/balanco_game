import 'package:balanco_game/features/notifications/domain/game_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GameNotification notification({
    required String type,
    Map<String, dynamic> data = const {},
    DateTime? readAt,
  }) {
    return GameNotification(
      id: 'notification-id',
      recipientId: 'recipient-id',
      actorId: 'actor-id',
      type: type,
      title: 'Title',
      body: 'Body',
      data: data,
      createdAt: DateTime(2026, 7, 18),
      readAt: readAt,
    );
  }

  test('maps every social notification to its dedicated card kind', () {
    expect(
      notification(type: 'friend_request').kind,
      GameNotificationKind.friendRequest,
    );
    expect(
      notification(type: 'friend_accepted').kind,
      GameNotificationKind.friendAccepted,
    );
    expect(
      notification(type: 'friend_declined').kind,
      GameNotificationKind.friendDeclined,
    );
    expect(
      notification(type: 'game_invite').kind,
      GameNotificationKind.gameInvite,
    );
    expect(
      notification(type: 'game_invite_accepted').kind,
      GameNotificationKind.gameInviteAccepted,
    );
    expect(
      notification(type: 'game_invite_declined').kind,
      GameNotificationKind.gameInviteDeclined,
    );
    expect(
      notification(type: 'game_invite_cancelled').kind,
      GameNotificationKind.gameInviteCancelled,
    );
    expect(
      notification(type: 'future_notification').kind,
      GameNotificationKind.system,
    );
  });

  test('only unresolved requests and invites expose response actions', () {
    final friendRequest = notification(
      type: 'friend_request',
      data: const {'request_id': 'request-id'},
    );
    final gameInvite = notification(
      type: 'game_invite',
      data: const {'invite_id': 'invite-id', 'mode': 'race', 'max_players': 4},
    );

    expect(friendRequest.hasResponseAction, isTrue);
    expect(gameInvite.hasResponseAction, isTrue);
    expect(gameInvite.gameMode, 'RACE');
    expect(gameInvite.maxPlayers, 4);
    expect(
      notification(
        type: 'friend_request',
        data: const {'request_id': 'request-id'},
        readAt: DateTime(2026, 7, 18, 1),
      ).hasResponseAction,
      isFalse,
    );
    expect(notification(type: 'friend_accepted').hasResponseAction, isFalse);
  });
}
