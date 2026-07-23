enum CoopSide { left, right, slot1, slot2, slot3, slot4 }

const coopControlSides = <CoopSide>[CoopSide.left, CoopSide.right];

extension CoopSideValue on CoopSide {
  String get value => name;
  CoopSide get opposite => switch (this) {
    CoopSide.left => CoopSide.right,
    CoopSide.right => CoopSide.left,
    _ => this,
  };

  int get slotNumber => switch (this) {
    CoopSide.left || CoopSide.slot1 => 1,
    CoopSide.right || CoopSide.slot2 => 2,
    CoopSide.slot3 => 3,
    CoopSide.slot4 => 4,
  };
}

class CoopMember {
  const CoopMember({
    required this.userId,
    required this.displayName,
    required this.playerCode,
    required this.side,
    required this.ready,
    required this.isHost,
    required this.micMuted,
    this.avatarUrl,
    this.avatarShape = 'circle',
    this.raceWins = 0,
    this.sessionWins = 0,
    this.seriesStars = 0,
    this.highestLevel = 1,
    this.eliminatedAt,
    this.leftAt,
    this.lastSeenAt,
    this.isOnline = true,
  });

  final String userId;
  final String displayName;
  final String playerCode;
  final CoopSide side;
  final bool ready;
  final bool isHost;
  final bool micMuted;
  final String? avatarUrl;
  final String avatarShape;
  final int raceWins;
  final int sessionWins;
  final int seriesStars;
  final int highestLevel;
  final DateTime? eliminatedAt;
  final DateTime? leftAt;
  final DateTime? lastSeenAt;
  final bool isOnline;

  bool get isEliminated => eliminatedAt != null;
  bool get hasLeft => leftAt != null;

  String get resolvedAvatarUrl {
    final saved = avatarUrl?.trim();
    if (saved != null && saved.isNotEmpty) return saved;
    final seed = Uri.encodeQueryComponent(
      playerCode.isNotEmpty ? playerCode : displayName,
    );
    return 'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=$seed'
        '&backgroundColor=transparent';
  }

  factory CoopMember.fromJson(Map<String, dynamic> json) => CoopMember(
    userId: json['user_id'] as String,
    displayName: json['display_name'] as String,
    playerCode: json['player_code'] as String,
    side: CoopSide.values.byName(json['side'] as String),
    ready: json['ready'] as bool? ?? false,
    isHost: json['is_host'] as bool? ?? false,
    micMuted: json['mic_muted'] as bool? ?? false,
    avatarUrl: json['avatar_url'] as String?,
    avatarShape: json['avatar_shape'] as String? ?? 'circle',
    raceWins: (json['race_wins'] as num?)?.toInt() ?? 0,
    sessionWins: (json['session_wins'] as num?)?.toInt() ?? 0,
    seriesStars: (json['series_stars'] as num?)?.toInt() ?? 0,
    highestLevel: (json['highest_level'] as num?)?.toInt() ?? 1,
    eliminatedAt: DateTime.tryParse(json['eliminated_at'] as String? ?? ''),
    leftAt: DateTime.tryParse(json['left_at'] as String? ?? ''),
    lastSeenAt: DateTime.tryParse(json['last_seen_at'] as String? ?? ''),
    isOnline: json['is_online'] as bool? ?? true,
  );
}

class CoopRoom {
  const CoopRoom({
    required this.id,
    required this.code,
    required this.hostId,
    required this.status,
    required this.hostSide,
    required this.seed,
    required this.attemptNumber,
    required this.score,
    required this.leaveRequestedBy,
    required this.endReason,
    required this.mode,
    required this.raceLevel,
    required this.raceStartLevel,
    required this.raceEndLevel,
    required this.raceLevelVersion,
    required this.startedAt,
    required this.winnerId,
    required this.winnerFinishedAt,
    required this.winnerElapsedMs,
    required this.winnerHearts,
    required this.winnerStars,
    required this.raceEndKind,
    required this.seriesWinnerId,
    required this.seriesEndKind,
    required this.seriesFinishedAt,
    required this.rematchRequestedBy,
    required this.raceRestartKind,
    required this.maxPlayers,
    required this.restartVoteCount,
    required this.leaveVoteCount,
    required this.members,
    this.isBattleRace = false,
    this.racePickupClaims = const [],
  });

  final String id;
  final String code;
  final String hostId;
  final String status;
  final CoopSide hostSide;
  final int seed;
  final int attemptNumber;
  final int score;
  final String? leaveRequestedBy;
  final String? endReason;
  final String mode;
  final bool isBattleRace;
  final int raceLevel;
  final int raceStartLevel;
  final int raceEndLevel;
  final int? raceLevelVersion;
  final DateTime? startedAt;
  final String? winnerId;
  final DateTime? winnerFinishedAt;
  final int? winnerElapsedMs;
  final int? winnerHearts;
  final int? winnerStars;
  final String? raceEndKind;
  final String? seriesWinnerId;
  final String? seriesEndKind;
  final DateTime? seriesFinishedAt;
  final String? rematchRequestedBy;
  final String? raceRestartKind;
  final int maxPlayers;
  final int restartVoteCount;
  final int leaveVoteCount;
  final List<CoopMember> members;
  final List<CoopRacePickupClaim> racePickupClaims;

  bool get isWaiting => status == 'waiting';
  bool get isPlaying => status == 'playing';
  bool get isPaused => status == 'paused';
  bool get hasLeaveVote => status == 'leave_vote';
  bool get isEnded => status == 'ended';
  bool get endedByAgreement => isEnded && endReason == 'leave';
  bool get endedByDisconnect =>
      isEnded && endReason == 'forfeit' && raceEndKind == 'disconnect';
  bool get hasPostgameExitVote =>
      isEnded &&
      (endReason == 'completed' || endReason == 'game_over') &&
      leaveRequestedBy != null;
  bool get canStart =>
      members.length == (isRace ? maxPlayers : 2) &&
      members.every((m) => m.ready);
  bool get isRace => mode == 'race';
  bool get isRegularRace => isRace && !isBattleRace;
  int get seriesRoundCount => raceEndLevel - raceStartLevel + 1;
  int get seriesRoundNumber => raceLevel - raceStartLevel + 1;
  bool get hasMoreSeriesLevels => raceLevel < raceEndLevel;
  int get levelRangeCount => raceEndLevel - raceStartLevel + 1;
  int get levelRangePosition => raceLevel - raceStartLevel + 1;
  bool get hasMoreCoopLevels => !isRace && raceLevel < raceEndLevel;
  bool get isCoopLevelComplete =>
      !isRace && isEnded && endReason == 'completed';
  bool get isCoopRunComplete => isCoopLevelComplete && !hasMoreCoopLevels;
  bool get isCoopGameOver => !isRace && isEnded && endReason == 'game_over';
  bool get isSeriesFinished => seriesFinishedAt != null;
  bool get isSeriesDraw => seriesEndKind == 'draw';

  int get requiredVotes => members.where((member) => !member.hasLeft).length;
  List<CoopMember> opponentsOf(String userId) =>
      members.where((member) => member.userId != userId).toList();

  CoopMember memberFor(String userId) =>
      members.firstWhere((member) => member.userId == userId);

  factory CoopRoom.fromJson(Map<String, dynamic> json) {
    final room = Map<String, dynamic>.from(json['room'] as Map);
    return CoopRoom(
      id: room['id'] as String,
      code: room['room_code'] as String,
      hostId: room['host_id'] as String,
      status: room['status'] as String,
      hostSide: CoopSide.values.byName(room['host_side'] as String),
      seed: room['seed'] as int,
      attemptNumber: room['attempt_number'] as int? ?? 1,
      score: room['score'] as int? ?? 0,
      leaveRequestedBy: room['leave_requested_by'] as String?,
      endReason: room['end_reason'] as String?,
      mode: room['mode'] as String? ?? 'coop',
      isBattleRace: room['is_battle_race'] as bool? ?? false,
      raceLevel: room['race_level'] as int? ?? 1,
      raceStartLevel: room['race_start_level'] as int? ?? 1,
      raceEndLevel: room['race_end_level'] as int? ?? 1,
      raceLevelVersion: room['race_level_version'] as int?,
      startedAt: DateTime.tryParse(room['started_at'] as String? ?? ''),
      winnerId: room['winner_id'] as String?,
      winnerFinishedAt: DateTime.tryParse(
        room['winner_finished_at'] as String? ?? '',
      ),
      winnerElapsedMs: room['winner_elapsed_ms'] as int?,
      winnerHearts: room['winner_hearts'] as int?,
      winnerStars: room['winner_stars'] as int?,
      raceEndKind: room['race_end_kind'] as String?,
      seriesWinnerId: room['series_winner_id'] as String?,
      seriesEndKind: room['series_end_kind'] as String?,
      seriesFinishedAt: DateTime.tryParse(
        room['series_finished_at'] as String? ?? '',
      ),
      rematchRequestedBy: room['rematch_requested_by'] as String?,
      raceRestartKind: room['race_restart_kind'] as String?,
      maxPlayers: (room['max_players'] as num?)?.toInt() ?? 2,
      restartVoteCount: (room['restart_vote_count'] as num?)?.toInt() ?? 0,
      leaveVoteCount: (room['leave_vote_count'] as num?)?.toInt() ?? 0,
      members: (json['members'] as List? ?? const [])
          .map(
            (value) =>
                CoopMember.fromJson(Map<String, dynamic>.from(value as Map)),
          )
          .toList(),
      racePickupClaims: (json['race_pickup_claims'] as List? ?? const [])
          .map(
            (value) => CoopRacePickupClaim.fromJson(
              Map<String, dynamic>.from(value as Map),
            ),
          )
          .toList(),
    );
  }
}

class CoopRacePickupClaim {
  const CoopRacePickupClaim({
    required this.pickupKey,
    required this.pickupType,
    required this.claimantId,
    required this.claimantName,
    required this.claimedAt,
  });

  final String pickupKey;
  final String pickupType;
  final String claimantId;
  final String claimantName;
  final DateTime? claimedAt;

  factory CoopRacePickupClaim.fromJson(Map<String, dynamic> json) =>
      CoopRacePickupClaim(
        pickupKey: json['pickup_key'] as String,
        pickupType: json['pickup_type'] as String,
        claimantId: json['claimant_id'] as String,
        claimantName: json['claimant_name'] as String? ?? 'Rival',
        claimedAt: DateTime.tryParse(json['claimed_at'] as String? ?? ''),
      );
}

class PlayerCodeResult {
  const PlayerCodeResult({
    required this.id,
    required this.displayName,
    required this.playerCode,
  });
  final String id;
  final String displayName;
  final String playerCode;

  factory PlayerCodeResult.fromJson(Map<String, dynamic> json) =>
      PlayerCodeResult(
        id: json['id'] as String,
        displayName: json['display_name'] as String,
        playerCode: json['player_code'] as String,
      );
}
