class PlayerProfile {
  final int id; // Always 1 for global profile
  final bool isFirstOpen;
  final int highestLevel;
  final int lastPlayedLevel;
  final int coins;
  final int moneyCents;
  final int sparks;
  final int maxSparks;
  final int totalPoints;
  final int streak;
  final int infinityHighScore;

  PlayerProfile({
    this.id = 1,
    required this.isFirstOpen,
    required this.highestLevel,
    required this.lastPlayedLevel,
    required this.coins,
    this.moneyCents = 0,
    this.sparks = 5,
    this.maxSparks = 5,
    this.totalPoints = 0,
    required this.streak,
    this.infinityHighScore = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isFirstOpen': isFirstOpen ? 1 : 0,
      'highestLevel': highestLevel,
      'lastPlayedLevel': lastPlayedLevel,
      'coins': coins,
      'money_cents': moneyCents,
      'sparks': sparks,
      'max_sparks': maxSparks,
      'total_points': totalPoints,
      'streak': streak,
      'infinity_high_score': infinityHighScore,
    };
  }

  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      id: map['id'],
      isFirstOpen: map['isFirstOpen'] == 1,
      highestLevel: map['highestLevel'],
      lastPlayedLevel: map['lastPlayedLevel'],
      coins: map['coins'],
      moneyCents: map['money_cents'] ?? 0,
      sparks: map['sparks'] ?? 5,
      maxSparks: map['max_sparks'] ?? 5,
      totalPoints: map['total_points'] ?? 0,
      streak: map['streak'] ?? 0,
      infinityHighScore: map['infinity_high_score'] ?? 0,
    );
  }

  PlayerProfile copyWith({
    bool? isFirstOpen,
    int? highestLevel,
    int? lastPlayedLevel,
    int? coins,
    int? moneyCents,
    int? sparks,
    int? maxSparks,
    int? totalPoints,
    int? streak,
    int? infinityHighScore,
  }) {
    return PlayerProfile(
      id: id,
      isFirstOpen: isFirstOpen ?? this.isFirstOpen,
      highestLevel: highestLevel ?? this.highestLevel,
      lastPlayedLevel: lastPlayedLevel ?? this.lastPlayedLevel,
      coins: coins ?? this.coins,
      moneyCents: moneyCents ?? this.moneyCents,
      sparks: sparks ?? this.sparks,
      maxSparks: maxSparks ?? this.maxSparks,
      totalPoints: totalPoints ?? this.totalPoints,
      streak: streak ?? this.streak,
      infinityHighScore: infinityHighScore ?? this.infinityHighScore,
    );
  }
}

class LevelProgress {
  final int levelId;
  final int stars;
  final bool isUnlocked;

  LevelProgress({
    required this.levelId,
    required this.stars,
    required this.isUnlocked,
  });

  Map<String, dynamic> toMap() {
    return {
      'level_id': levelId,
      'stars': stars,
      'is_unlocked': isUnlocked ? 1 : 0,
    };
  }

  factory LevelProgress.fromMap(Map<String, dynamic> map) {
    return LevelProgress(
      levelId: map['level_id'],
      stars: map['stars'],
      isUnlocked: map['is_unlocked'] == 1,
    );
  }
}
