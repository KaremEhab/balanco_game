import 'dart:async';

import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:flutter/foundation.dart';

class CoopGameCoordinator {
  CoopGameCoordinator({
    required CoopRoom initialRoom,
    required this.userId,
    required this.game,
    required this.repository,
    required this.realtime,
  }) : room = ValueNotifier(initialRoom),
       mySide = initialRoom.memberFor(userId).side,
       isHost = initialRoom.hostId == userId;

  final String userId;
  final BalancoGame game;
  final CoopRepository repository;
  final CoopRealtimeSession realtime;
  final ValueNotifier<CoopRoom> room;
  final ValueNotifier<bool> partnerMuted = ValueNotifier(false);
  final ValueNotifier<bool> rewardSynced = ValueNotifier(false);
  final ValueNotifier<bool> syncHealthy = ValueNotifier(false);
  final CoopSide mySide;
  final bool isHost;
  StreamSubscription<Map<String, dynamic>>? _subscription;
  Timer? _snapshotTimer;
  Timer? _roomRefreshTimer;
  Timer? _snapshotHealthTimer;
  Timer? _loadHintTimer;
  bool _completed = false;
  bool _reloadingRoom = false;
  bool _snapshotSending = false;
  bool _inputSending = false;
  bool _disposed = false;
  int _lastSnapshotAt = 0;
  int _snapshotSequence = 0;
  int _lastRemoteSnapshotSequence = 0;
  int _localInputSequence = 0;
  int _lastRemoteInputSequence = 0;
  int _activeRealtimeRooms = 1;
  int _lastInputSentAtMicros = 0;
  double? _pendingInput;

  String get _roomEpoch =>
      '${room.value.id}:${room.value.attemptNumber}:'
      '${room.value.raceLevel}:'
      '${room.value.startedAt?.microsecondsSinceEpoch ?? 0}';

  void attach() {
    _subscription = realtime.events.listen(_handleEvent);
    realtime.connected.addListener(_onRealtimeConnectionChanged);
    game.currentScore.value = room.value.score;
    game.showVictoryOverlay.addListener(_onVictory);
    game.showGameOverOverlay.addListener(_onGameOver);
    if (isHost) {
      _scheduleNextSnapshot(Duration.zero);
    } else {
      game.enableCoopReplica();
    }
    _roomRefreshTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => reloadRoom(),
    );
    unawaited(_refreshRealtimeLoadHint());
    _loadHintTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refreshRealtimeLoadHint(),
    );
    _applyRoomState(room.value);
  }

  Future<void> _refreshRealtimeLoadHint() async {
    try {
      _activeRealtimeRooms = await repository.getRealtimeActiveRoomCount();
    } catch (_) {
      // Keep the previous estimate while the REST API is unavailable.
    }
  }

  void _onRealtimeConnectionChanged() {
    if (_disposed) return;
    if (!realtime.connected.value) {
      syncHealthy.value = false;
      return;
    }
    if (isHost) _scheduleNextSnapshot();
    unawaited(reloadRoom());
  }

  void _scheduleNextSnapshot([Duration? delay]) {
    if (_disposed || !isHost) return;
    _snapshotTimer?.cancel();
    final interval =
        delay ??
        RealtimeTrafficPolicy.coopSnapshotInterval(
          activeRooms: _activeRealtimeRooms,
          degraded:
              !realtime.connected.value || !realtime.deliveryHealthy.value,
        );
    _snapshotTimer = Timer(interval, () async {
      await _sendSnapshot();
      _scheduleNextSnapshot();
    });
  }

  Future<void> setLocalInput(double value) async {
    if (mySide == CoopSide.left) {
      game.leftJoystickValue = value;
    } else {
      game.rightJoystickValue = value;
    }
    if (isHost) return;
    _pendingInput = value.clamp(-1.0, 1.0);
    if (!_inputSending) await _flushLatestInput();
  }

  Future<void> _flushLatestInput() async {
    _inputSending = true;
    try {
      while (_pendingInput != null && !_disposed) {
        final minimumInterval = RealtimeTrafficPolicy.coopInputInterval(
          activeRooms: _activeRealtimeRooms,
          degraded:
              !realtime.connected.value || !realtime.deliveryHealthy.value,
        );
        final now = DateTime.now().microsecondsSinceEpoch;
        final waitMicros =
            minimumInterval.inMicroseconds - (now - _lastInputSentAtMicros);
        if (waitMicros > 0) {
          await Future<void>.delayed(Duration(microseconds: waitMicros));
        }
        final value = _pendingInput!;
        _pendingInput = null;
        final sequence = ++_localInputSequence;
        final delivered = await realtime.send('control', {
          'side': mySide.value,
          'value': value,
          'sequence': sequence,
          'epoch': _roomEpoch,
        });
        _lastInputSentAtMicros = DateTime.now().microsecondsSinceEpoch;
        if (!delivered) {
          _pendingInput ??= value;
        }
      }
    } finally {
      _inputSending = false;
    }
  }

  Future<void> setPaused(bool paused) async {
    room.value = await repository.setPaused(room.value.id, paused);
    _applyRoomState(room.value);
    await realtime.notifyRoomChanged();
  }

  Future<void> activateSharedShield() async {
    if (isHost) {
      game.activateShield();
      return;
    }
    await realtime.send('shield_request', {'epoch': _roomEpoch});
  }

  Future<void> requestLeave() async {
    room.value = await repository.voteLeave(room.value.id, false);
    _applyRoomState(room.value);
    await realtime.notifyRoomChanged();
  }

  Future<void> respondToLeave(bool approve) async {
    room.value = await repository.voteLeave(room.value.id, approve);
    _applyRoomState(room.value);
    await realtime.notifyRoomChanged();
  }

  Future<void> requestPostgameExit() async {
    room.value = await repository.votePostgameExit(room.value.id, false);
    await realtime.notifyRoomChanged();
  }

  Future<void> respondToPostgameExit(bool approve) async {
    room.value = await repository.votePostgameExit(room.value.id, approve);
    await realtime.notifyRoomChanged();
  }

  Future<void> retryTogether() async {
    await _requestLevelRestart('retry');
  }

  Future<void> continueTogether() async {
    await _requestLevelRestart('continue');
  }

  Future<void> _requestLevelRestart(String kind) async {
    final previousAttempt = room.value.attemptNumber;
    final next = await repository.voteCoopLevelRestart(room.value.id, kind);
    room.value = next;
    if (next.attemptNumber > previousAttempt) _restartLocalRun();
    await realtime.notifyRoomChanged();
  }

  Future<void> _handleEvent(Map<String, dynamic> event) async {
    if (event['from'] == userId) return;
    switch (event['action']) {
      case 'control':
        if (!isHost) return;
        if (event['epoch'] != _roomEpoch) return;
        final sequence = event['sequence'] as int? ?? 0;
        if (sequence <= _lastRemoteInputSequence) return;
        _lastRemoteInputSequence = sequence;
        final value = (event['value'] as num).toDouble().clamp(-1.0, 1.0);
        if (event['side'] == 'left') {
          game.leftJoystickValue = value;
        } else {
          game.rightJoystickValue = value;
        }
      case 'snapshot':
        if (!isHost && event['epoch'] == _roomEpoch) _applySnapshot(event);
      case 'shield_request':
        if (isHost && event['epoch'] == _roomEpoch) game.activateShield();
      case 'room_changed':
        await reloadRoom();
      case 'mic_state':
        partnerMuted.value = event['muted'] as bool? ?? false;
    }
  }

  Future<void> reloadRoom() async {
    if (_reloadingRoom) return;
    _reloadingRoom = true;
    try {
      final previousAttempt = room.value.attemptNumber;
      final next = await repository.getRoom(room.value.id);
      room.value = next;
      if (next.attemptNumber > previousAttempt) _restartLocalRun();
      _applyRoomState(room.value);
      if (room.value.isEnded && !rewardSynced.value) {
        await PlayerSession.instance.refresh();
        rewardSynced.value = true;
      }
    } catch (_) {
      // Broadcast is primary; polling retries room state after brief outages.
    } finally {
      _reloadingRoom = false;
    }
  }

  void _restartLocalRun() {
    _completed = false;
    _lastSnapshotAt = 0;
    _lastRemoteSnapshotSequence = 0;
    rewardSynced.value = false;
    game.currentLevel.value = room.value.raceLevel;
    game.onlineLevelVersion = room.value.raceLevelVersion;
    game.currentScore.value = room.value.score;
    game.collectedCoins.value = 0;
    unawaited(game.restartCoopRun(room.value.seed));
  }

  void _applyRoomState(CoopRoom state) {
    if (state.isPaused || state.hasLeaveVote || state.isEnded) {
      game.pauseEngine();
    } else if (state.isPlaying) {
      game.resumeEngine();
    }
  }

  Future<void> _sendSnapshot() async {
    if (!isHost ||
        !realtime.connected.value ||
        room.value.isEnded ||
        _snapshotSending) {
      return;
    }
    _snapshotSending = true;
    try {
      final sequence = ++_snapshotSequence;
      syncHealthy.value = await realtime.send('snapshot', {
        'sequence': sequence,
        'epoch': _roomEpoch,
        ...game.createCoopSnapshot(
          includeWorldState: sequence == 1 || sequence % 10 == 0,
        ),
      });
    } finally {
      _snapshotSending = false;
    }
  }

  void _applySnapshot(Map<String, dynamic> data) {
    final sentAt = data['sent_at'] as int? ?? 0;
    if (sentAt <= _lastSnapshotAt) return;
    final sequence = (data['sequence'] as num?)?.toInt() ?? 0;
    if (sequence <= _lastRemoteSnapshotSequence) return;
    final skipped = _lastRemoteSnapshotSequence == 0
        ? 0
        : sequence - _lastRemoteSnapshotSequence - 1;
    _lastRemoteSnapshotSequence = sequence;
    _lastSnapshotAt = sentAt;
    realtime.recordMotionPacket(
      streamId: data['from'] as String? ?? 'coop-host',
      skippedPackets: skipped,
    );
    game.applyCoopSnapshot(data);
    syncHealthy.value = true;
    _snapshotHealthTimer?.cancel();
    _snapshotHealthTimer = Timer(const Duration(milliseconds: 2400), () {
      if (!_disposed) syncHealthy.value = false;
    });
  }

  void _onGameOver() {
    if (!game.showGameOverOverlay.value || !isHost || _completed) return;
    _completed = true;
    unawaited(_submitGameOver());
  }

  void _onVictory() {
    if (!game.showVictoryOverlay.value || !isHost || _completed) return;
    _completed = true;
    unawaited(_submitVictory());
  }

  Future<void> _submitVictory() async {
    try {
      final stars = game.currentPoints.value.clamp(0, 3);
      final points = game.calculateLevelRewardPoints();
      game.earnedLevelPoints.value = points;
      room.value = await repository.completeCoopLevel(
        room.value.id,
        points: points,
        stars: stars,
        coins: game.collectedCoins.value,
      );
      game.currentScore.value = room.value.score;
      await _finishOutcomeSync();
    } catch (_) {
      _completed = false;
      if (!_disposed) {
        Timer(const Duration(seconds: 1), _onVictory);
      }
    }
  }

  Future<void> _submitGameOver() async {
    try {
      room.value = await repository.failCoopLevel(room.value.id);
      await _finishOutcomeSync();
    } catch (_) {
      _completed = false;
      if (!_disposed) {
        Timer(const Duration(seconds: 1), _onGameOver);
      }
    }
  }

  Future<void> _finishOutcomeSync() async {
    _applyRoomState(room.value);
    await PlayerSession.instance.refresh();
    rewardSynced.value = true;
    await realtime.notifyRoomChanged();
  }

  Future<void> dispose() async {
    _disposed = true;
    _pendingInput = null;
    realtime.connected.removeListener(_onRealtimeConnectionChanged);
    game.showVictoryOverlay.removeListener(_onVictory);
    game.showGameOverOverlay.removeListener(_onGameOver);
    _snapshotTimer?.cancel();
    _snapshotHealthTimer?.cancel();
    _roomRefreshTimer?.cancel();
    _loadHintTimer?.cancel();
    await _subscription?.cancel();
    room.dispose();
    partnerMuted.dispose();
    rewardSynced.dispose();
    syncHealthy.dispose();
  }
}
