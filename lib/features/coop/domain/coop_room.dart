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
  });

  final String userId;
  final String displayName;
  final String playerCode;
  final CoopSide side;
  final bool ready;
  final bool isHost;
  final bool micMuted;

  factory CoopMember.fromJson(Map<String, dynamic> json) => CoopMember(
    userId: json['user_id'] as String,
    displayName: json['display_name'] as String,
    playerCode: json['player_code'] as String,
    side: CoopSide.values.byName(json['side'] as String),
    ready: json['ready'] as bool? ?? false,
    isHost: json['is_host'] as bool? ?? false,
    micMuted: json['mic_muted'] as bool? ?? false,
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
