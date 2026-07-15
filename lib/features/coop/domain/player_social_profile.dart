class PlayerFriendSummary {
  const PlayerFriendSummary({
    required this.id,
    required this.displayName,
    required this.playerCode,
    required this.avatarShape,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String playerCode;
  final String avatarShape;
  final String? avatarUrl;

  factory PlayerFriendSummary.fromJson(Map<String, dynamic> json) =>
      PlayerFriendSummary(
        id: json['id'] as String,
        displayName: json['display_name'] as String,
        playerCode: json['player_code'] as String,
        avatarShape: json['avatar_shape'] as String? ?? 'circle',
        avatarUrl: json['avatar_url'] as String?,
      );
}

class PlayerSocialProfile {
  const PlayerSocialProfile({
    required this.id,
    required this.displayName,
    required this.username,
    required this.age,
    required this.playerCode,
    required this.avatarShape,
    required this.highestLevel,
    required this.totalPoints,
    required this.infinityHighScore,
    required this.raceWins,
    required this.friendCount,
    required this.friendshipStatus,
    required this.friends,
    this.avatarUrl,
    this.friendRequestId,
    this.coins,
    this.moneyCents,
    this.sparks,
    this.maxSparks,
    this.unlockedItems,
  });

  final String id;
  final String displayName;
  final String username;
  final int age;
  final String playerCode;
  final String avatarShape;
  final String? avatarUrl;
  final int highestLevel;
  final int totalPoints;
  final int infinityHighScore;
  final int raceWins;
  final int friendCount;
  final String friendshipStatus;
  final String? friendRequestId;
  final List<PlayerFriendSummary> friends;
  final int? coins;
  final int? moneyCents;
  final int? sparks;
  final int? maxSparks;
  final int? unlockedItems;

  bool get isSelf => friendshipStatus == 'self';
  bool get isFriend => friendshipStatus == 'friend';

  factory PlayerSocialProfile.fromJson(Map<String, dynamic> json) =>
      PlayerSocialProfile(
        id: json['id'] as String,
        displayName: json['display_name'] as String,
        username: json['username'] as String? ?? '',
        age: (json['age'] as num?)?.toInt() ?? 0,
        playerCode: json['player_code'] as String,
        avatarShape: json['avatar_shape'] as String? ?? 'circle',
        avatarUrl: json['avatar_url'] as String?,
        highestLevel: (json['highest_level'] as num?)?.toInt() ?? 1,
        totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
        infinityHighScore: (json['infinity_high_score'] as num?)?.toInt() ?? 0,
        raceWins: (json['race_wins'] as num?)?.toInt() ?? 0,
        friendCount: (json['friend_count'] as num?)?.toInt() ?? 0,
        friendshipStatus: json['friendship_status'] as String? ?? 'none',
        friendRequestId: json['friend_request_id'] as String?,
        friends: (json['friends'] as List? ?? const [])
            .map(
              (value) => PlayerFriendSummary.fromJson(
                Map<String, dynamic>.from(value as Map),
              ),
            )
            .toList(growable: false),
      );

  PlayerSocialProfile withPrivateStats({
    required int coins,
    required int moneyCents,
    required int sparks,
    required int maxSparks,
    required int unlockedItems,
  }) => PlayerSocialProfile(
    id: id,
    displayName: displayName,
    username: username,
    age: age,
    playerCode: playerCode,
    avatarShape: avatarShape,
    avatarUrl: avatarUrl,
    highestLevel: highestLevel,
    totalPoints: totalPoints,
    infinityHighScore: infinityHighScore,
    raceWins: raceWins,
    friendCount: friendCount,
    friendshipStatus: friendshipStatus,
    friendRequestId: friendRequestId,
    friends: friends,
    coins: coins,
    moneyCents: moneyCents,
    sparks: sparks,
    maxSparks: maxSparks,
    unlockedItems: unlockedItems,
  );
}
