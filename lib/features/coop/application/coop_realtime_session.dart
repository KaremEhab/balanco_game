import 'dart:async';
import 'dart:math';

import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@immutable
class NetworkDiagnosticsSnapshot {
  const NetworkDiagnosticsSnapshot({
    required this.connected,
    required this.deliveryHealthy,
    required this.region,
    required this.disconnects,
    required this.reconnects,
    required this.reconnectAttempts,
    required this.packetsSent,
    required this.packetsReceived,
    required this.motionPacketsReceived,
    required this.packetsSkipped,
    required this.corrections,
    this.lastReconnectMs,
    this.rttMedianMs,
    this.rttP95Ms,
    this.jitterMedianMs,
    this.jitterP95Ms,
  });

  final bool connected;
  final bool deliveryHealthy;
  final String region;
  final int disconnects;
  final int reconnects;
  final int reconnectAttempts;
  final int packetsSent;
  final int packetsReceived;
  final int motionPacketsReceived;
  final int packetsSkipped;
  final int corrections;
  final int? lastReconnectMs;
  final int? rttMedianMs;
  final int? rttP95Ms;
  final int? jitterMedianMs;
  final int? jitterP95Ms;

  double get estimatedPacketLossPercent {
    final expected = motionPacketsReceived + packetsSkipped;
    if (expected == 0) return 0;
    return packetsSkipped * 100 / expected;
  }
}

abstract final class RealtimeTrafficPolicy {
  // Realtime counts both sent and delivered events. Keep normal gameplay
  // comfortably below the smallest project-wide limit so voice and weapon
  // events still have headroom.
  static Duration raceSnapshotInterval({
    required int activePlayers,
    int activeRooms = 1,
    bool degraded = false,
  }) {
    final players = activePlayers.clamp(2, 4);
    final rooms = activeRooms.clamp(1, 20);
    final roomEventBudget = 55 / rooms;
    final interval = Duration(
      milliseconds: (1000 * players * players / roomEventBudget).ceil().clamp(
        50,
        6000,
      ),
    );
    return degraded
        ? Duration(milliseconds: (interval.inMilliseconds * 1.6).round())
        : interval;
  }

  static Duration coopSnapshotInterval({
    int activeRooms = 1,
    bool degraded = false,
  }) {
    final roomEventBudget = 55 / activeRooms.clamp(1, 20);
    final interval = Duration(
      milliseconds: (4000 / roomEventBudget).ceil().clamp(70, 1500),
    );
    return degraded
        ? Duration(milliseconds: (interval.inMilliseconds * 1.6).round())
        : interval;
  }

  static Duration coopInputInterval({
    int activeRooms = 1,
    bool degraded = false,
  }) => coopSnapshotInterval(activeRooms: activeRooms, degraded: degraded);

  static Duration reconnectDelay(int attempt, {required int jitterMs}) {
    final seconds = switch (attempt) {
      1 => 1,
      2 => 2,
      3 => 4,
      _ => 8,
    };
    return Duration(
      milliseconds:
          seconds * Duration.millisecondsPerSecond + jitterMs.clamp(0, 500),
    );
  }

  @visibleForTesting
  static double estimatedRaceEventsPerSecond(
    int activePlayers, {
    int activeRooms = 1,
  }) {
    final players = activePlayers.clamp(2, 4);
    final interval = raceSnapshotInterval(
      activePlayers: players,
      activeRooms: activeRooms,
    );
    final snapshotsPerPlayer =
        Duration.millisecondsPerSecond / interval.inMilliseconds;
    return players * players * snapshotsPerPlayer;
  }
}

class CoopRealtimeSession {
  CoopRealtimeSession({
    required SupabaseClient client,
    required this.roomId,
    required this.userId,
  }) : _client = client;

  final SupabaseClient _client;
  final String roomId;
  final String userId;
  final ValueNotifier<bool> connected = ValueNotifier(false);
  final ValueNotifier<int> onlinePlayers = ValueNotifier(0);
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<bool> deliveryHealthy = ValueNotifier(true);
  final ValueNotifier<int> reconnectAttempts = ValueNotifier(0);
  late final ValueNotifier<NetworkDiagnosticsSnapshot> diagnostics =
      ValueNotifier(_diagnosticsSnapshot());
  final StreamController<Map<String, dynamic>> _events =
      StreamController.broadcast();
  RealtimeChannel? _channel;
  Future<void>? _connectFuture;
  Timer? _reconnectTimer;
  Timer? _diagnosticsTimer;
  Timer? _pingTimer;
  final Random _reconnectRandom = Random();
  final List<int> _rttSamples = [];
  final List<int> _jitterSamples = [];
  final Map<String, int> _pendingPings = {};
  final Set<String> _peerIds = {};
  bool _disposed = false;
  bool _everConnected = false;
  DateTime? _disconnectedAt;
  DateTime? _lastMotionReceivedAt;
  final Map<String, int> _lastMotionArrivalMicros = {};
  final Map<String, int> _previousMotionIntervalMicros = {};
  int _disconnects = 0;
  int _reconnects = 0;
  int _packetsSent = 0;
  int _packetsReceived = 0;
  int _motionPacketsReceived = 0;
  int _packetsSkipped = 0;
  int _corrections = 0;
  int? _lastReconnectMs;

  Stream<Map<String, dynamic>> get events => _events.stream;

  int? get snapshotAgeMs {
    final receivedAt = _lastMotionReceivedAt;
    if (receivedAt == null) return null;
    return DateTime.now().toUtc().difference(receivedAt).inMilliseconds;
  }

  Future<void> connect() async {
    if (_disposed) throw StateError('Realtime session is closed');
    if (_channel != null && connected.value) return;
    final pending = _connectFuture;
    if (pending != null) return pending;
    final future = _openChannel();
    _connectFuture = future;
    try {
      await future;
    } finally {
      if (identical(_connectFuture, future)) _connectFuture = null;
    }
  }

  Future<void> _openChannel() async {
    final completer = Completer<void>();
    final channel = _client.channel(
      'coop:$roomId',
      // Gameplay snapshots are ephemeral and arrive many times per second.
      // Waiting for a server acknowledgement serializes those frames and
      // makes the replica board advance in visible network-sized steps.
      opts: RealtimeChannelConfig(private: true, key: userId, ack: false),
    );
    _channel = channel;
    channel
        .onBroadcast(
          event: 'coop',
          callback: (payload) {
            _markConnected();
            final event = decodeBroadcastPayload(payload);
            _packetsReceived++;
            final senderId = event['from'] as String?;
            if (senderId != null && senderId != userId) {
              _peerIds.add(senderId);
            }
            if (_handleDiagnosticEvent(event)) return;
            if (!_events.isClosed) _events.add(event);
          },
        )
        .onPresenceSync((_) {
          onlinePlayers.value = channel.presenceState().length;
        })
        .onPresenceJoin((_) {
          onlinePlayers.value = channel.presenceState().length;
        })
        .onPresenceLeave((_) {
          onlinePlayers.value = channel.presenceState().length;
        })
        .subscribe((status, subscribeError) async {
          if (status == RealtimeSubscribeStatus.subscribed) {
            _markConnected();
            error.value = null;
            reconnectAttempts.value = 0;
            _publishDiagnostics();
            _reconnectTimer?.cancel();
            _reconnectTimer = null;
            await channel.track({
              'user_id': userId,
              'online_at': DateTime.now().toUtc().toIso8601String(),
            });
            _schedulePing();
            if (!completer.isCompleted) completer.complete();
          } else if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut) {
            _markDisconnected();
            error.value =
                subscribeError?.toString() ?? 'Realtime connection failed';
            if (!completer.isCompleted) {
              completer.completeError(StateError(error.value!));
            }
            _scheduleReconnect();
          } else if (status == RealtimeSubscribeStatus.closed) {
            _markDisconnected();
            _scheduleReconnect();
          }
        });
    try {
      await completer.future.timeout(const Duration(seconds: 12));
    } catch (_) {
      _markDisconnected();
      _scheduleReconnect();
      rethrow;
    }
  }

  void _markConnected() {
    final changed = !connected.value || !deliveryHealthy.value;
    if (!connected.value) {
      connected.value = true;
      if (_everConnected && _disconnectedAt != null) {
        _reconnects++;
        _lastReconnectMs = DateTime.now()
            .toUtc()
            .difference(_disconnectedAt!)
            .inMilliseconds;
      }
      _disconnectedAt = null;
      _everConnected = true;
    }
    deliveryHealthy.value = true;
    _publishDiagnostics(immediate: changed);
  }

  void _markDisconnected() {
    if (connected.value) {
      connected.value = false;
      _disconnects++;
      _disconnectedAt = DateTime.now().toUtc();
    } else {
      _disconnectedAt ??= DateTime.now().toUtc();
    }
    deliveryHealthy.value = false;
    _pingTimer?.cancel();
    _pingTimer = null;
    _publishDiagnostics();
  }

  void _scheduleReconnect() {
    if (_disposed || _reconnectTimer?.isActive == true) return;
    final attempt = reconnectAttempts.value + 1;
    reconnectAttempts.value = attempt;
    _publishDiagnostics(immediate: true);
    final delay = RealtimeTrafficPolicy.reconnectDelay(
      attempt,
      jitterMs: _reconnectRandom.nextInt(501),
    );
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      unawaited(_reconnect());
    });
  }

  Future<void> _reconnect() async {
    if (_disposed || connected.value) return;
    final oldChannel = _channel;
    _channel = null;
    if (oldChannel != null) {
      try {
        await _client.removeChannel(oldChannel);
      } catch (_) {
        // A broken socket may already have removed the channel locally.
      }
    }
    try {
      await connect();
    } catch (_) {
      _scheduleReconnect();
    }
  }

  Future<bool> send(String type, Map<String, dynamic> data) async {
    final channel = _channel;
    if (channel == null || !connected.value) {
      _markDisconnected();
      return false;
    }
    try {
      final response = await channel.sendBroadcastMessage(
        event: 'coop',
        payload: {
          // `type` is reserved by realtime_client and becomes `broadcast`.
          'action': type,
          'from': userId,
          'sent_at': DateTime.now().microsecondsSinceEpoch,
          ...data,
        },
      );
      final delivered = response == ChannelResponse.ok;
      deliveryHealthy.value = delivered;
      if (delivered) {
        _packetsSent++;
      } else {
        error.value = 'Realtime message could not be queued';
      }
      _publishDiagnostics();
      return delivered;
    } catch (exception) {
      _markDisconnected();
      error.value = 'Realtime send failed: $exception';
      _scheduleReconnect();
      return false;
    }
  }

  void recordMotionPacket({
    String streamId = 'default',
    int skippedPackets = 0,
    bool corrected = false,
  }) {
    final now = DateTime.now().toUtc();
    final nowMicros = now.microsecondsSinceEpoch;
    final previousArrival = _lastMotionArrivalMicros[streamId];
    if (previousArrival != null) {
      final interval = nowMicros - previousArrival;
      final previousInterval = _previousMotionIntervalMicros[streamId];
      if (previousInterval != null) {
        _addSample(_jitterSamples, (interval - previousInterval).abs() ~/ 1000);
      }
      _previousMotionIntervalMicros[streamId] = interval;
    }
    _lastMotionArrivalMicros[streamId] = nowMicros;
    _lastMotionReceivedAt = now;
    _motionPacketsReceived++;
    _packetsSkipped += max(0, skippedPackets);
    if (corrected) _corrections++;
    _publishDiagnostics();
  }

  void recordCorrection() {
    _corrections++;
    _publishDiagnostics();
  }

  bool _handleDiagnosticEvent(Map<String, dynamic> event) {
    final action = event['action'];
    if (action == '_net_ping') {
      if (event['target'] == userId) {
        unawaited(
          send('_net_pong', {
            'target': event['from'],
            'ping_id': event['ping_id'],
          }),
        );
      }
      return true;
    }
    if (action != '_net_pong') return false;
    if (event['target'] != userId) return true;
    final pingId = event['ping_id'] as String?;
    final startedAt = pingId == null ? null : _pendingPings.remove(pingId);
    if (startedAt != null) {
      final rtt =
          (DateTime.now().microsecondsSinceEpoch - startedAt) ~/
          Duration.microsecondsPerMillisecond;
      _addSample(_rttSamples, max(0, rtt));
      _publishDiagnostics();
    }
    return true;
  }

  void _schedulePing() {
    _pingTimer?.cancel();
    if (_disposed || !connected.value) return;
    final delay = Duration(seconds: 35 + _reconnectRandom.nextInt(21));
    _pingTimer = Timer(delay, () async {
      _pingTimer = null;
      await _sendPing();
      _schedulePing();
    });
  }

  Future<void> _sendPing() async {
    if (_channel == null || !connected.value) return;
    final peers = _peerIds.toList(growable: false);
    if (peers.isEmpty) return;
    final pingId =
        '$userId:${DateTime.now().microsecondsSinceEpoch}:'
        '${_reconnectRandom.nextInt(1 << 20)}';
    _pendingPings[pingId] = DateTime.now().microsecondsSinceEpoch;
    if (!await send('_net_ping', {
      'target': peers[_reconnectRandom.nextInt(peers.length)],
      'ping_id': pingId,
    })) {
      _pendingPings.remove(pingId);
    }
    if (_pendingPings.length > 8) {
      _pendingPings.remove(_pendingPings.keys.first);
    }
  }

  void _addSample(List<int> samples, int value) {
    samples.add(value);
    if (samples.length > 40) samples.removeAt(0);
  }

  int? _percentile(List<int> samples, double percentile) {
    if (samples.isEmpty) return null;
    final sorted = [...samples]..sort();
    final index = ((sorted.length - 1) * percentile).round();
    return sorted[index];
  }

  NetworkDiagnosticsSnapshot _diagnosticsSnapshot() =>
      NetworkDiagnosticsSnapshot(
        connected: connected.value,
        deliveryHealthy: deliveryHealthy.value,
        region: SupabaseConfig.region,
        disconnects: _disconnects,
        reconnects: _reconnects,
        reconnectAttempts: reconnectAttempts.value,
        packetsSent: _packetsSent,
        packetsReceived: _packetsReceived,
        motionPacketsReceived: _motionPacketsReceived,
        packetsSkipped: _packetsSkipped,
        corrections: _corrections,
        lastReconnectMs: _lastReconnectMs,
        rttMedianMs: _percentile(_rttSamples, 0.5),
        rttP95Ms: _percentile(_rttSamples, 0.95),
        jitterMedianMs: _percentile(_jitterSamples, 0.5),
        jitterP95Ms: _percentile(_jitterSamples, 0.95),
      );

  void _publishDiagnostics({bool immediate = false}) {
    if (_disposed) return;
    if (!immediate) {
      if (_diagnosticsTimer?.isActive == true) return;
      _diagnosticsTimer = Timer(const Duration(milliseconds: 500), () {
        _diagnosticsTimer = null;
        _publishDiagnostics(immediate: true);
      });
      return;
    }
    _diagnosticsTimer?.cancel();
    _diagnosticsTimer = null;
    diagnostics.value = _diagnosticsSnapshot();
  }

  Future<bool> notifyRoomChanged() => send('room_changed', const {});

  @visibleForTesting
  static Map<String, dynamic> decodeBroadcastPayload(
    Map<String, dynamic> message,
  ) {
    final payload = message['payload'];
    if (payload is Map) return Map<String, dynamic>.from(payload);
    return Map<String, dynamic>.from(message);
  }

  Future<void> dispose() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _diagnosticsTimer?.cancel();
    _diagnosticsTimer = null;
    _pingTimer?.cancel();
    _pingTimer = null;
    final channel = _channel;
    _channel = null;
    if (channel != null) {
      try {
        await channel.untrack();
      } catch (_) {
        // Closing should remain safe when the network disappeared first.
      }
      try {
        await _client.removeChannel(channel);
      } catch (_) {
        // The Realtime client may already have removed a failed channel.
      }
    }
    connected.dispose();
    onlinePlayers.dispose();
    error.dispose();
    deliveryHealthy.dispose();
    reconnectAttempts.dispose();
    diagnostics.dispose();
    await _events.close();
  }
}
