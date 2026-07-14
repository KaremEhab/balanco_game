enum CoopSide { left, right }

extension CoopSideValue on CoopSide {
  String get value => name;
  CoopSide get opposite =>
      this == CoopSide.left ? CoopSide.right : CoopSide.left;
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
    required this.startedAt,
    required this.winnerId,
    required this.winnerFinishedAt,
    required this.winnerElapsedMs,
    required this.winnerHearts,
    required this.winnerStars,
    required this.raceEndKind,
    required this.rematchRequestedBy,
    required this.raceRestartKind,
    required this.members,
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
  final int raceLevel;
  final DateTime? startedAt;
  final String? winnerId;
  final DateTime? winnerFinishedAt;
  final int? winnerElapsedMs;
  final int? winnerHearts;
  final int? winnerStars;
  final String? raceEndKind;
  final String? rematchRequestedBy;
  final String? raceRestartKind;
  final List<CoopMember> members;

  bool get isWaiting => status == 'waiting';
  bool get isPlaying => status == 'playing';
  bool get isPaused => status == 'paused';
  bool get hasLeaveVote => status == 'leave_vote';
  bool get isEnded => status == 'ended';
  bool get endedByAgreement => isEnded && endReason == 'leave';
  bool get hasPostgameExitVote =>
      isEnded && endReason == 'completed' && leaveRequestedBy != null;
  bool get canStart => members.length == 2 && members.every((m) => m.ready);
  bool get isRace => mode == 'race';

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
      raceLevel: room['race_level'] as int? ?? 1,
      startedAt: DateTime.tryParse(room['started_at'] as String? ?? ''),
      winnerId: room['winner_id'] as String?,
      winnerFinishedAt: DateTime.tryParse(
        room['winner_finished_at'] as String? ?? '',
      ),
      winnerElapsedMs: room['winner_elapsed_ms'] as int?,
      winnerHearts: room['winner_hearts'] as int?,
      winnerStars: room['winner_stars'] as int?,
      raceEndKind: room['race_end_kind'] as String?,
      rematchRequestedBy: room['rematch_requested_by'] as String?,
      raceRestartKind: room['race_restart_kind'] as String?,
      members: (json['members'] as List? ?? const [])
          .map(
            (value) =>
                CoopMember.fromJson(Map<String, dynamic>.from(value as Map)),
          )
          .toList(),
    );
  }
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
