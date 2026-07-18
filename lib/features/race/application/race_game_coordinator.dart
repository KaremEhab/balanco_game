import 'dart:async';

import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/race_pickup.dart';
import 'package:balanco_game/features/race/application/race_match_clock.dart';
import 'package:balanco_game/features/race/application/race_remote_snapshot_interpolator.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class RaceGameCoordinator {
  RaceGameCoordinator({
    required CoopRoom initialRoom,
    required this.userId,
    required this.localGame,
    required this.remoteGame,
    required this.repository,
    required this.realtime,
  }) : room = ValueNotifier(initialRoom);

  static const countdownDuration = Duration(seconds: 4);

  final String userId;
  final BalancoGame localGame;
  final BalancoGame remoteGame;
  final CoopRepository repository;
  final CoopRealtimeSession realtime;
  final ValueNotifier<CoopRoom> room;
  final ValueNotifier<double> localProgress = ValueNotifier(0);
  final ValueNotifier<double> remoteProgress = ValueNotifier(0);
  final ValueNotifier<int> remoteHearts = ValueNotifier(3);
  final ValueNotifier<int> remoteStars = ValueNotifier(0);
  final ValueNotifier<Map<String, int>> remoteHeartsByUser = ValueNotifier(
    const {},
  );
  final ValueNotifier<Map<String, int>> remoteStarsByUser = ValueNotifier(
    const {},
  );
  final ValueNotifier<Map<String, double>> remoteProgressByUser = ValueNotifier(
    const {},
  );
  final ValueNotifier<Map<String, Map<String, int>>> pickupCountsByUser =
      ValueNotifier(const {});
  final ValueNotifier<bool> syncHealthy = ValueNotifier(false);
  final ValueNotifier<Duration> elapsed = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> showBoardLabels = ValueNotifier(true);
  final ValueNotifier<String?> actionError = ValueNotifier(null);
  final RaceRemoteSnapshotInterpolator remoteInterpolator =
      RaceRemoteSnapshotInterpolator();
  final Map<String, RaceRemoteSnapshotInterpolator> remoteInterpolators = {};
  final RaceMatchClock _matchClock = RaceMatchClock(
    countdown: countdownDuration,
  );
  final RaceTimeoutSubmissionGuard _timeoutGuard = RaceTimeoutSubmissionGuard();

  StreamSubscription<Map<String, dynamic>>? _events;
  Timer? _snapshotTimer;
  Timer? _displayTimer;
  Timer? _roomTimer;
  Timer? _presenceTimer;
  Timer? _healthTimer;
  Timer? _introTimer;
  bool _sending = false;
  bool _reloading = false;
  bool _finishSubmitted = false;
  bool _lossSubmitted = false;
  bool _actionInFlight = false;
  bool _timeoutSettlementInFlight = false;
  bool _presenceInFlight = false;
  bool _disposed = false;
  int _sequence = 0;
  final String _snapshotStreamId = const Uuid().v4();
  final Map<String, int> _lastRemoteSequenceByUser = {};
  final Map<String, String> _remoteSnapshotStreamByUser = {};
  final Set<String> _knownPickupClaimKeys = {};

  DateTime get goAt =>
      (room.value.startedAt ?? DateTime.now().toUtc()).add(countdownDuration);

  void attach() {
    remoteGame.enableCoopReplica();
    localGame.racePlayerId = userId;
    localGame.onRacePickupClaim = _claimPickup;
    _events = realtime.events.listen(_handleEvent);
    localGame.showVictoryOverlay.addListener(_onLocalFinished);
    localGame.showGameOverOverlay.addListener(_onLocalGameOver);
    _snapshotTimer = Timer.periodic(
      const Duration(milliseconds: 33),
      (_) => _sendSnapshot(),
    );
    _displayTimer = Timer.periodic(
      const Duration(milliseconds: 33),
      (_) => _updateDisplayState(),
    );
    _roomTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => reloadRoom(),
    );
    unawaited(_maintainPresence());
    _presenceTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _maintainPresence(),
    );
    _scheduleBoardLabels();
    _syncRemotePlayers();
    _syncPickupClaims();
    _applyRoomState();
    _updateDisplayState();
  }

  void _scheduleBoardLabels() {
    _introTimer?.cancel();
    showBoardLabels.value = true;
    final now = DateTime.now().toUtc();
    final visibleStart = goAt.isAfter(now) ? goAt : now;
    final hideAt = visibleStart.add(const Duration(seconds: 2));
    final delay = hideAt.difference(now);
    _introTimer = Timer(delay, () {
      if (!_disposed) showBoardLabels.value = false;
    });
  }

  void _updateDisplayState() {
    if (_disposed) return;
    final now = DateTime.now().toUtc();
    final clock = _matchClock.update(
      startedAt: room.value.startedAt,
      running: room.value.isPlaying,
      now: now,
    );
    elapsed.value = clock.elapsed;
    localGame.countdownTimer = clock.countdownSeconds;
    localGame.countdownNotifier.value = clock.countdownSeconds.ceil();
    remoteGame.countdownTimer = clock.countdownSeconds;
    remoteGame.countdownNotifier.value = clock.countdownSeconds.ceil();
    if (localGame.isLayoutReady) {
      localProgress.value = localGame.raceProgress;
    }
    if (localGame.showGameOverOverlay.value && !_lossSubmitted) {
      _onLocalGameOver();
    }

    if (_timeoutGuard.take(
      // A pause request can reach the room on the exact frame the clock hits
      // zero. The elapsed clock is already frozen at the limit in that case,
      // so the timeout must still settle instead of becoming stuck forever.
      isRoomActive: room.value.isPlaying || room.value.isPaused,
      elapsed: clock.elapsed,
      limitSeconds: localGame.maxLevelTimer,
      now: now,
    )) {
      unawaited(_submitTimeoutDraw());
    }
  }

  Future<void> _submitTimeoutDraw() async {
    final attemptedAt = DateTime.now().toUtc();
    if (_timeoutSettlementInFlight || _disposed) {
      _timeoutGuard.defer(
        attemptedAt,
        delay: const Duration(milliseconds: 500),
      );
      return;
    }

    // Timeout settlement has its own lock. A simultaneous pause/menu action
    // must not prevent the authoritative draw RPC from reaching Supabase.
    _timeoutSettlementInFlight = true;
    try {
      room.value = await repository.drawRace(room.value.id);
      actionError.value = null;
      _applyRoomState();
      await realtime.notifyRoomChanged();
    } catch (_) {
      // Another device may have resolved the timeout even if this request or
      // its Realtime broadcast failed. Refresh before deciding to retry.
      await reloadRoom();
      if (room.value.isEnded) return;
      final willRetry = _timeoutGuard.recordFailure(DateTime.now().toUtc());
      if (!willRetry) {
        actionError.value =
            'Time is up, but the room could not finish after 3 attempts. '
            'Check your connection and reopen the match.';
      }
    } finally {
      _timeoutSettlementInFlight = false;
    }
  }

  Future<void> _sendSnapshot() async {
    if (_sending ||
        _disposed ||
        !localGame.isLayoutReady ||
        !room.value.isPlaying) {
      return;
    }
    _sending = true;
    try {
      final delivered = await realtime.send('race_snapshot', {
        'sequence': ++_sequence,
        'stream_id': _snapshotStreamId,
        'attempt': room.value.attemptNumber,
        'level': room.value.raceLevel,
        'progress': localGame.raceProgress,
        ...localGame.createCoopSnapshot(),
      });
      if (!delivered) syncHealthy.value = false;
    } finally {
      _sending = false;
    }
  }

  Future<void> _handleEvent(Map<String, dynamic> event) async {
    final senderId = event['from'] as String?;
    if (senderId == null || senderId == userId) return;
    switch (event['action']) {
      case 'race_snapshot':
        final eventAttempt = (event['attempt'] as num?)?.toInt();
        final eventLevel = (event['level'] as num?)?.toInt();
        if (eventAttempt != room.value.attemptNumber ||
            eventLevel != room.value.raceLevel) {
          return;
        }
        final streamId = (event['stream_id'] as String?)?.trim();
        final streamKey =
            '$eventAttempt:$eventLevel:${streamId?.isNotEmpty == true ? streamId : 'legacy'}';
        final previousStream = _remoteSnapshotStreamByUser[senderId];
        if (previousStream != streamKey) {
          _remoteSnapshotStreamByUser[senderId] = streamKey;
          _lastRemoteSequenceByUser.remove(senderId);
          remoteInterpolators[senderId]?.clear();
          if (senderId == _primaryOpponentId) remoteInterpolator.clear();
        }
        final sequence = (event['sequence'] as num?)?.toInt() ?? 0;
        if (sequence <= (_lastRemoteSequenceByUser[senderId] ?? 0)) return;
        _lastRemoteSequenceByUser[senderId] = sequence;
        final interpolator = remoteInterpolators.putIfAbsent(
          senderId,
          RaceRemoteSnapshotInterpolator.new,
        );
        interpolator.addSnapshot(event);
        if (senderId == _primaryOpponentId) {
          remoteInterpolator.addSnapshot(event);
        }
        remoteGame.applyCoopSnapshot(event);
        final progress =
            (event['progress'] as num?)?.toDouble().clamp(0.0, 1.0) ?? 0;
        final hearts = event['lives'] as int? ?? 3;
        final stars = event['points'] as int? ?? 0;
        remoteProgressByUser.value = {
          ...remoteProgressByUser.value,
          senderId: progress,
        };
        remoteHeartsByUser.value = {
          ...remoteHeartsByUser.value,
          senderId: hearts,
        };
        remoteStarsByUser.value = {...remoteStarsByUser.value, senderId: stars};
        if (senderId == _primaryOpponentId) {
          remoteProgress.value = progress;
          remoteHearts.value = hearts;
          remoteStars.value = stars;
        }
        syncHealthy.value = true;
        _healthTimer?.cancel();
        _healthTimer = Timer(const Duration(milliseconds: 1200), () {
          if (!_disposed) syncHealthy.value = false;
        });
      case 'race_pickup_claimed':
        final eventAttempt = (event['attempt'] as num?)?.toInt();
        final eventLevel = (event['level'] as num?)?.toInt();
        if (eventAttempt != room.value.attemptNumber ||
            eventLevel != room.value.raceLevel) {
          return;
        }
        final type = RacePickupType.fromWireName(
          event['pickup_type'] as String? ?? '',
        );
        final key = event['pickup_key'] as String?;
        final claimantId = event['claimant_id'] as String?;
        if (type == null || key == null || claimantId == null) return;
        _applyPickupClaim(
          RacePickupResolution(
            pickupKey: key,
            type: type,
            claimantId: claimantId,
            claimantName: event['claimant_name'] as String? ?? 'Rival',
          ),
        );
      case 'room_changed':
        await reloadRoom();
    }
  }

  Future<RacePickupResolution> _claimPickup(
    RacePickupType type,
    String pickupKey,
  ) async {
    final claim = await repository.claimRacePickup(
      roomId: room.value.id,
      attemptNumber: room.value.attemptNumber,
      level: room.value.raceLevel,
      pickupKey: pickupKey,
      pickupType: type.wireName,
    );
    final resolution = RacePickupResolution(
      pickupKey: claim.pickupKey,
      type: RacePickupType.fromWireName(claim.pickupType) ?? type,
      claimantId: claim.claimantId,
      claimantName: claim.claimantName,
    );
    _recordPickupCount(resolution);
    if (claim.claimantId == userId) {
      await realtime.send('race_pickup_claimed', {
        'attempt': room.value.attemptNumber,
        'level': room.value.raceLevel,
        'pickup_key': claim.pickupKey,
        'pickup_type': claim.pickupType,
        'claimant_id': claim.claimantId,
        'claimant_name': claim.claimantName,
      });
    }
    return resolution;
  }

  void _applyPickupClaim(RacePickupResolution claim) {
    localGame.applyRacePickupClaim(
      claim,
      grantEffect: claim.claimantId == userId,
      animateOpponentClaim: claim.claimantId != userId,
    );
    remoteGame.applyRacePickupClaim(
      claim,
      grantEffect: false,
      animateOpponentClaim: false,
    );
    _recordPickupCount(claim);
  }

  void _recordPickupCount(RacePickupResolution claim) {
    if (!_knownPickupClaimKeys.add(claim.pickupKey)) return;
    final existing = pickupCountsByUser.value;
    final claimantCounts = Map<String, int>.from(
      existing[claim.claimantId] ?? const {},
    );
    // Counts are rebuilt authoritatively during every room refresh. While a
    // broadcast is in flight, only add a claim not already known locally.
    claimantCounts[claim.type.wireName] =
        (claimantCounts[claim.type.wireName] ?? 0) + 1;
    pickupCountsByUser.value = {...existing, claim.claimantId: claimantCounts};
  }

  void _syncPickupClaims() {
    final counts = <String, Map<String, int>>{};
    for (final claim in room.value.racePickupClaims) {
      final type = RacePickupType.fromWireName(claim.pickupType);
      if (type == null) continue;
      final userCounts = counts.putIfAbsent(claim.claimantId, () => {});
      _knownPickupClaimKeys.add(claim.pickupKey);
      userCounts[claim.pickupType] = (userCounts[claim.pickupType] ?? 0) + 1;
      _applyPickupClaim(
        RacePickupResolution(
          pickupKey: claim.pickupKey,
          type: type,
          claimantId: claim.claimantId,
          claimantName: claim.claimantName,
        ),
      );
    }
    pickupCountsByUser.value = {
      for (final entry in counts.entries)
        entry.key: Map<String, int>.unmodifiable(entry.value),
    };
  }

  void _onLocalFinished() {
    if (!localGame.showVictoryOverlay.value || _finishSubmitted) return;
    _finishSubmitted = true;
    unawaited(_submitFinish());
  }

  void _onLocalGameOver() {
    if (!localGame.showGameOverOverlay.value || _lossSubmitted) return;
    _lossSubmitted = true;
    unawaited(_submitLocalLoss());
  }

  Future<void> _submitLocalLoss() async {
    await surrender();
    final localMember = room.value.members
        .where((member) => member.userId == userId)
        .firstOrNull;
    // If Pause/Leave was already being submitted, _runAction deliberately
    // skipped this request. Re-arm it so the next display tick still records
    // zero hearts as an elimination and the final survivor becomes winner.
    if (!room.value.isEnded && localMember?.isEliminated != true) {
      _lossSubmitted = false;
    }
  }

  Future<void> _submitFinish() async {
    try {
      room.value = await repository.finishRace(
        room.value.id,
        progress: 1.0,
        hearts: localGame.currentLives.value,
        stars: localGame.currentPoints.value,
      );
      await realtime.notifyRoomChanged();
      _applyRoomState();
    } catch (_) {
      _finishSubmitted = false;
      await reloadRoom();
    }
  }

  Future<void> surrender() => _runAction(() async {
    room.value = await repository.surrenderRace(room.value.id);
    await realtime.notifyRoomChanged();
    _applyRoomState();
  });

  Future<void> _maintainPresence() async {
    if (_presenceInFlight || _disposed || room.value.isEnded) return;
    _presenceInFlight = true;
    final wasEnded = room.value.isEnded;
    try {
      final refreshed = await repository.maintainRacePresence(room.value.id);
      _acceptRoomUpdate(refreshed);
      _applyRoomState();
      if (!wasEnded && room.value.endedByDisconnect) {
        await realtime.notifyRoomChanged();
      }
    } catch (_) {
      // Losing connectivity intentionally stops this heartbeat. The online
      // opponent's server-validated heartbeat resolves the match after 2 min.
    } finally {
      _presenceInFlight = false;
    }
  }

  Future<void> setPaused(bool paused) => _runAction(() async {
    room.value = await repository.setPaused(room.value.id, paused);
    _applyRoomState();
    await realtime.notifyRoomChanged();
  });

  Future<bool> leaveRaceImmediately() async {
    if (_actionInFlight || _disposed) return false;
    _actionInFlight = true;
    actionError.value = null;
    try {
      await repository.leaveRaceRoom(room.value.id);
      try {
        await realtime.notifyRoomChanged();
      } catch (_) {
        // The database leave already succeeded. Remaining players also poll
        // the authoritative room state, so a failed broadcast must not keep
        // this player trapped on the Race screen.
      }
      return true;
    } catch (error) {
      actionError.value = _friendlyActionError(error);
      return false;
    } finally {
      _actionInFlight = false;
    }
  }

  Future<void> requestLeave() => _runAction(() async {
    room.value = await repository.voteLeave(room.value.id, false);
    _applyRoomState();
    await realtime.notifyRoomChanged();
  });

  Future<void> respondToLeave(bool approve) => _runAction(() async {
    room.value = await repository.voteLeave(room.value.id, approve);
    _applyRoomState();
    await realtime.notifyRoomChanged();
  });

  Future<void> requestPostgameExit() => _runAction(() async {
    room.value = await repository.votePostgameExit(room.value.id, false);
    await realtime.notifyRoomChanged();
  });

  Future<void> respondToPostgameExit(bool approve) => _runAction(() async {
    room.value = await repository.votePostgameExit(room.value.id, approve);
    await realtime.notifyRoomChanged();
  });

  Future<void> requestRetry() => _requestRestart('retry');

  Future<void> requestContinue() => _requestRestart('continue');

  Future<void> acceptRestartOffer() async {
    final kind = room.value.raceRestartKind;
    if (kind == null) return;
    await _requestRestart(kind);
  }

  Future<void> _requestRestart(String kind) async {
    await _runAction(() async {
      final previousAttempt = room.value.attemptNumber;
      room.value = await repository.voteRaceRestart(room.value.id, kind);
      if (room.value.attemptNumber > previousAttempt) await _restartRace();
      await realtime.notifyRoomChanged();
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    if (_actionInFlight || _disposed) return;
    _actionInFlight = true;
    actionError.value = null;
    try {
      await action();
    } catch (error) {
      actionError.value = _friendlyActionError(error);
      await reloadRoom();
    } finally {
      _actionInFlight = false;
    }
  }

  String _friendlyActionError(Object error) {
    final message = error.toString();
    if (message.contains('players selected different')) {
      return 'Both players must choose the same retry option.';
    }
    if (message.contains('not ready to restart')) {
      return 'The room changed before that retry could be sent. Try again.';
    }
    return 'The shared race action did not reach the room. Please try again.';
  }

  Future<void> reloadRoom() async {
    if (_reloading || _disposed) return;
    _reloading = true;
    try {
      final previousAttempt = room.value.attemptNumber;
      _acceptRoomUpdate(await repository.getRoom(room.value.id));
      if (room.value.attemptNumber > previousAttempt) await _restartRace();
      _applyRoomState();
    } catch (_) {
      // The next poll or Realtime event retries transient failures.
    } finally {
      _reloading = false;
    }
  }

  void _acceptRoomUpdate(CoopRoom next) {
    final current = room.value;
    if (current.isEnded &&
        !next.isEnded &&
        next.attemptNumber <= current.attemptNumber) {
      return;
    }
    room.value = next;
    _syncRemotePlayers();
    _syncPickupClaims();
  }

  String? get _primaryOpponentId => room.value.members
      .where((member) => member.userId != userId)
      .map((member) => member.userId)
      .firstOrNull;

  void _syncRemotePlayers() {
    final opponentIds = room.value.members
        .where((member) => member.userId != userId)
        .map((member) => member.userId)
        .toSet();
    for (final id in opponentIds) {
      remoteInterpolators.putIfAbsent(id, RaceRemoteSnapshotInterpolator.new);
    }
    final removed = remoteInterpolators.keys
        .where((id) => !opponentIds.contains(id))
        .toList();
    for (final id in removed) {
      remoteInterpolators.remove(id)?.dispose();
      _lastRemoteSequenceByUser.remove(id);
      _remoteSnapshotStreamByUser.remove(id);
    }
  }

  Future<void> _restartRace() async {
    _finishSubmitted = false;
    _lossSubmitted = false;
    _sequence = 0;
    _lastRemoteSequenceByUser.clear();
    _remoteSnapshotStreamByUser.clear();
    _knownPickupClaimKeys.clear();
    remoteInterpolator.clear();
    for (final interpolator in remoteInterpolators.values) {
      interpolator.clear();
    }
    localProgress.value = 0;
    remoteProgress.value = 0;
    remoteHearts.value = 3;
    remoteStars.value = 0;
    remoteHeartsByUser.value = const {};
    remoteStarsByUser.value = const {};
    remoteProgressByUser.value = const {};
    pickupCountsByUser.value = const {};
    elapsed.value = Duration.zero;
    _matchClock.reset();
    _timeoutGuard.reset();
    localGame.currentLevel.value = room.value.raceLevel;
    remoteGame.currentLevel.value = room.value.raceLevel;
    localGame.onlineLevelVersion = room.value.raceLevelVersion;
    remoteGame.onlineLevelVersion = room.value.raceLevelVersion;
    await Future.wait([
      localGame.restartRaceRun(room.value.seed),
      remoteGame.restartRaceRun(room.value.seed),
    ]);
    _syncPickupClaims();
    _scheduleBoardLabels();
    _applyRoomState();
  }

  void _applyRoomState() {
    if (room.value.isPaused || room.value.hasLeaveVote || room.value.isEnded) {
      localGame.pauseEngine();
      remoteGame.pauseEngine();
    } else if (room.value.isPlaying) {
      localGame.resumeEngine();
      remoteGame.resumeEngine();
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    localGame.showVictoryOverlay.removeListener(_onLocalFinished);
    localGame.showGameOverOverlay.removeListener(_onLocalGameOver);
    _snapshotTimer?.cancel();
    _displayTimer?.cancel();
    _roomTimer?.cancel();
    _presenceTimer?.cancel();
    _healthTimer?.cancel();
    _introTimer?.cancel();
    await _events?.cancel();
    room.dispose();
    localProgress.dispose();
    remoteProgress.dispose();
    remoteHearts.dispose();
    remoteStars.dispose();
    remoteHeartsByUser.dispose();
    remoteStarsByUser.dispose();
    remoteProgressByUser.dispose();
    pickupCountsByUser.dispose();
    syncHealthy.dispose();
    elapsed.dispose();
    showBoardLabels.dispose();
    actionError.dispose();
    remoteInterpolator.dispose();
    for (final interpolator in remoteInterpolators.values) {
      interpolator.dispose();
    }
    remoteInterpolators.clear();
    localGame.onRacePickupClaim = null;
    localGame.racePlayerId = null;
  }
}
