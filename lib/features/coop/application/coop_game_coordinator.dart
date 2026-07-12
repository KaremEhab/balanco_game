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
  bool _completed = false;
  bool _reloadingRoom = false;
  bool _snapshotSending = false;
  bool _inputSending = false;
  bool _disposed = false;
  int _lastSnapshotAt = 0;
  int _snapshotSequence = 0;
  int _localInputSequence = 0;
  int _lastRemoteInputSequence = 0;
  double? _pendingInput;

  void attach() {
    _subscription = realtime.events.listen(_handleEvent);
    game.showGameOverOverlay.addListener(_onGameOver);
    if (isHost) {
      _snapshotTimer = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) => _sendSnapshot(),
      );
    } else {
      game.enableCoopReplica();
    }
    _roomRefreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => reloadRoom(),
    );
    _applyRoomState(room.value);
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
        final value = _pendingInput!;
        _pendingInput = null;
        final sequence = ++_localInputSequence;
        final delivered = await realtime.send('control', {
          'side': mySide.value,
          'value': value,
          'sequence': sequence,
        });
        if (!delivered) {
          _pendingInput ??= value;
          await Future<void>.delayed(const Duration(milliseconds: 35));
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
    await realtime.send('shield_request', const {});
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
    final previousAttempt = room.value.attemptNumber;
    final next = await repository.retryRoom(room.value.id);
    room.value = next;
    if (next.attemptNumber > previousAttempt) _restartLocalRun();
    await realtime.notifyRoomChanged();
  }

  Future<void> _handleEvent(Map<String, dynamic> event) async {
    if (event['from'] == userId) return;
    switch (event['action']) {
      case 'control':
        if (!isHost) return;
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
        if (!isHost) _applySnapshot(event);
      case 'shield_request':
        if (isHost) game.activateShield();
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
    rewardSynced.value = false;
    game.restartCoopRun(room.value.seed);
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
      syncHealthy.value = await realtime.send('snapshot', {
        'sequence': ++_snapshotSequence,
        ...game.createCoopSnapshot(),
      });
    } finally {
      _snapshotSending = false;
    }
  }

  void _applySnapshot(Map<String, dynamic> data) {
    final sentAt = data['sent_at'] as int? ?? 0;
    if (sentAt <= _lastSnapshotAt) return;
    _lastSnapshotAt = sentAt;
    game.applyCoopSnapshot(data);
    syncHealthy.value = true;
    _snapshotHealthTimer?.cancel();
    _snapshotHealthTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!_disposed) syncHealthy.value = false;
    });
  }

  void _onGameOver() {
    if (!game.showGameOverOverlay.value || !isHost || _completed) return;
    _completed = true;
    unawaited(_completeRun());
  }

  Future<void> _completeRun() async {
    room.value = await repository.completeRun(
      room.value.id,
      score: game.currentScore.value,
      coins: game.collectedCoins.value,
    );
    await PlayerSession.instance.refresh();
    rewardSynced.value = true;
    await realtime.notifyRoomChanged();
  }

  Future<void> dispose() async {
    _disposed = true;
    _pendingInput = null;
    game.showGameOverOverlay.removeListener(_onGameOver);
    _snapshotTimer?.cancel();
    _snapshotHealthTimer?.cancel();
    _roomRefreshTimer?.cancel();
    await _subscription?.cancel();
    room.dispose();
    partnerMuted.dispose();
    rewardSynced.dispose();
    syncHealthy.dispose();
  }
}
