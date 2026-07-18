enum GameNotificationKind {
  friendRequest,
  friendAccepted,
  friendDeclined,
  gameInvite,
  gameInviteAccepted,
  gameInviteDeclined,
  gameInviteCancelled,
  system,
}

class GameNotification {
  const GameNotification({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    this.actorId,
    this.readAt,
  });

  final String id;
  final String recipientId;
  final String? actorId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;
  GameNotificationKind get kind => switch (type) {
    'friend_request' => GameNotificationKind.friendRequest,
    'friend_accepted' => GameNotificationKind.friendAccepted,
    'friend_declined' => GameNotificationKind.friendDeclined,
    'game_invite' => GameNotificationKind.gameInvite,
    'game_invite_accepted' => GameNotificationKind.gameInviteAccepted,
    'game_invite_declined' => GameNotificationKind.gameInviteDeclined,
    'game_invite_cancelled' => GameNotificationKind.gameInviteCancelled,
    _ => GameNotificationKind.system,
  };
  bool get canRespondToFriendRequest =>
      type == 'friend_request' && data['request_id'] != null && !isRead;
  bool get canRespondToGameInvite =>
      type == 'game_invite' && data['invite_id'] != null && !isRead;
  bool get hasResponseAction =>
      canRespondToFriendRequest || canRespondToGameInvite;

  String? get gameMode {
    final mode = data['mode']?.toString().trim().toUpperCase();
    return mode == null || mode.isEmpty ? null : mode;
  }

  int? get maxPlayers => (data['max_players'] as num?)?.toInt();

  factory GameNotification.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return GameNotification(
      id: json['id'] as String,
      recipientId: json['recipient_id'] as String,
      actorId: json['actor_id'] as String?,
      type: json['notification_type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : const <String, dynamic>{},
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String).toLocal(),
    );
  }
}
