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
  bool get canRespondToFriendRequest =>
      type == 'friend_request' && data['request_id'] != null && !isRead;
  bool get canRespondToGameInvite =>
      type == 'game_invite' && data['invite_id'] != null && !isRead;

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
