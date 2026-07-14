import 'dart:async';

import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/race/application/race_match_clock.dart';
import 'package:balanco_game/features/race/application/race_remote_snapshot_interpolator.dart';
import 'package:flutter/foundation.dart';

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
  final ValueNotifier<bool> syncHealthy = ValueNotifier(false);
  final ValueNotifier<Duration> elapsed = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> showBoardLabels = ValueNotifier(true);
  final ValueNotifier<String?> actionError = ValueNotifier(null);
  final RaceRemoteSnapshotInterpolator remoteInterpolator =
      RaceRemoteSnapshotInterpolator();
  final RaceMatchClock _matchClock = RaceMatchClock(
    countdown: countdownDuration,
  );

  StreamSubscription<Map<String, dynamic>>? _events;
  Timer? _snapshotTimer;
  Timer? _displayTimer;
  Timer? _roomTimer;
  Timer? _healthTimer;
  Timer? _introTimer;
  bool _sending = false;
  bool _reloading = false;
  bool _finishSubmitted = false;
  bool _lossSubmitted = false;
  bool _actionInFlight = false;
  bool _disposed = false;
  int _sequence = 0;
  int _lastRemoteSequence = 0;

  DateTime get goAt =>
      (room.value.startedAt ?? DateTime.now().toUtc()).add(countdownDuration);

  void attach() {
    remoteGame.enableCoopReplica();
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
    _scheduleBoardLabels();
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
    if (event['from'] == userId) return;
    switch (event['action']) {
      case 'race_snapshot':
        if (event['attempt'] != room.value.attemptNumber ||
            event['level'] != room.value.raceLevel) {
          return;
        }
        final sequence = event['sequence'] as int? ?? 0;
        if (sequence <= _lastRemoteSequence) return;
        _lastRemoteSequence = sequence;
        remoteInterpolator.addSnapshot(event);
        remoteGame.applyCoopSnapshot(event);
        remoteProgress.value =
            (event['progress'] as num?)?.toDouble().clamp(0.0, 1.0) ?? 0;
        remoteHearts.value = event['lives'] as int? ?? 3;
        remoteStars.value = event['points'] as int? ?? 0;
        syncHealthy.value = true;
        _healthTimer?.cancel();
        _healthTimer = Timer(const Duration(milliseconds: 1200), () {
          if (!_disposed) syncHealthy.value = false;
        });
      case 'room_changed':
        await reloadRoom();
    }
  }

  void _onLocalFinished() {
    if (!localGame.showVictoryOverlay.value || _finishSubmitted) return;
    _finishSubmitted = true;
    unawaited(_submitFinish());
  }

  void _onLocalGameOver() {
    if (!localGame.showGameOverOverlay.value || _lossSubmitted) return;
    _lossSubmitted = true;
    unawaited(surrender());
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

  Future<void> setPaused(bool paused) => _runAction(() async {
    room.value = await repository.setPaused(room.value.id, paused);
    _applyRoomState();
    await realtime.notifyRoomChanged();
  });

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
      room.value = await repository.getRoom(room.value.id);
      if (room.value.attemptNumber > previousAttempt) await _restartRace();
      _applyRoomState();
    } catch (_) {
      // The next poll or Realtime event retries transient failures.
    } finally {
      _reloading = false;
    }
  }

  Future<void> _restartRace() async {
    _finishSubmitted = false;
    _lossSubmitted = false;
    _lastRemoteSequence = 0;
    remoteInterpolator.clear();
    localProgress.value = 0;
    remoteProgress.value = 0;
    remoteHearts.value = 3;
    remoteStars.value = 0;
    elapsed.value = Duration.zero;
    _matchClock.reset();
    localGame.currentLevel.value = room.value.raceLevel;
    remoteGame.currentLevel.value = room.value.raceLevel;
    await Future.wait([
      localGame.restartRaceRun(room.value.seed),
      remoteGame.restartRaceRun(room.value.seed),
    ]);
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
    _healthTimer?.cancel();
    _introTimer?.cancel();
    await _events?.cancel();
    room.dispose();
    localProgress.dispose();
    remoteProgress.dispose();
    remoteHearts.dispose();
    remoteStars.dispose();
    syncHealthy.dispose();
    elapsed.dispose();
    showBoardLabels.dispose();
    actionError.dispose();
    remoteInterpolator.dispose();
  }
}
