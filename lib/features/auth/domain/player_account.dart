class PlayerAccount {
  const PlayerAccount({
    required this.id,
    required this.email,
    required this.username,
    required this.playerCode,
    required this.displayName,
    required this.age,
    required this.highestLevel,
    required this.lastPlayedLevel,
    required this.totalPoints,
    required this.coins,
    required this.moneyCents,
    required this.sparks,
    required this.maxSparks,
    required this.infinityHighScore,
    required this.unlockedBallShapes,
    required this.unlockedBallColors,
    this.profileCompleted = true,
  });

  final String id;
  final String email;
  final String username;
  final String playerCode;
  final String displayName;
  final int age;
  final int highestLevel;
  final int lastPlayedLevel;
  final int totalPoints;
  final int coins;
  final int moneyCents;
  final int sparks;
  final int maxSparks;
  final int infinityHighScore;
  final Set<String> unlockedBallShapes;
  final Set<String> unlockedBallColors;
  final bool profileCompleted;

  String get formattedMoney => '\$${(moneyCents / 100).toStringAsFixed(2)}';
  bool get needsProfileSetup => !profileCompleted;

  factory PlayerAccount.fromState(
    Map<String, dynamic> state, {
    required String email,
  }) {
    final profile = Map<String, dynamic>.from(state['profile'] as Map);
    final progress = Map<String, dynamic>.from(state['progress'] as Map);
    final wallet = Map<String, dynamic>.from(state['wallet'] as Map);
    final unlocks = (state['unlocks'] as List? ?? const []).map(
      (value) => Map<String, dynamic>.from(value as Map),
    );

    Set<String> keysFor(String type) => unlocks
        .where((value) => value['unlock_type'] == type)
        .map((value) => value['item_key'] as String)
        .toSet();

    return PlayerAccount(
      id: profile['id'] as String,
      email: email,
      username: profile['username'] as String,
      playerCode: profile['player_code'] as String? ?? '',
      displayName: profile['display_name'] as String,
      age: profile['age'] as int,
      highestLevel: progress['highest_level'] as int,
      lastPlayedLevel: progress['last_played_level'] as int,
      totalPoints: (progress['total_points'] as num).toInt(),
      coins: (wallet['coins'] as num).toInt(),
      moneyCents: (wallet['money_cents'] as num).toInt(),
      sparks: wallet['sparks'] as int,
      maxSparks: wallet['max_sparks'] as int,
      infinityHighScore: (progress['infinity_high_score'] as num).toInt(),
      unlockedBallShapes: keysFor('ball_shape'),
      unlockedBallColors: keysFor('ball_color'),
      profileCompleted: profile['profile_completed'] as bool? ?? true,
    );
  }
}
