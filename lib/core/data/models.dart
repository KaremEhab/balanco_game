class PlayerProfile {
  final int id; // Always 1 for global profile
  final bool isFirstOpen;
  final int highestLevel;
  final int lastPlayedLevel;
  final int coins;
  final int streak;

  PlayerProfile({
    this.id = 1,
    required this.isFirstOpen,
    required this.highestLevel,
    required this.lastPlayedLevel,
    required this.coins,
    required this.streak,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isFirstOpen': isFirstOpen ? 1 : 0,
      'highestLevel': highestLevel,
      'lastPlayedLevel': lastPlayedLevel,
      'coins': coins,
      'streak': streak,
    };
  }

  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      id: map['id'],
      isFirstOpen: map['isFirstOpen'] == 1,
      highestLevel: map['highestLevel'],
      lastPlayedLevel: map['lastPlayedLevel'],
      coins: map['coins'],
      streak: map['streak'],
    );
  }

  PlayerProfile copyWith({
    bool? isFirstOpen,
    int? highestLevel,
    int? lastPlayedLevel,
    int? coins,
    int? streak,
  }) {
    return PlayerProfile(
      id: id,
      isFirstOpen: isFirstOpen ?? this.isFirstOpen,
      highestLevel: highestLevel ?? this.highestLevel,
      lastPlayedLevel: lastPlayedLevel ?? this.lastPlayedLevel,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
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
