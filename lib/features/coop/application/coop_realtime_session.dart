import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class RealtimeTrafficPolicy {
  // Realtime counts both sent and delivered events. Keep normal gameplay
  // comfortably below the smallest project-wide limit so voice and weapon
  // events still have headroom.
  static Duration raceSnapshotInterval({
    required int activePlayers,
    bool degraded = false,
  }) {
    final interval = switch (activePlayers.clamp(2, 4)) {
      2 => const Duration(milliseconds: 50),
      3 => const Duration(milliseconds: 112),
      _ => const Duration(milliseconds: 200),
    };
    return degraded
        ? Duration(milliseconds: (interval.inMilliseconds * 1.6).round())
        : interval;
  }

  static Duration coopSnapshotInterval({bool degraded = false}) =>
      Duration(milliseconds: degraded ? 100 : 50);

  static Duration coopInputInterval({bool degraded = false}) =>
      Duration(milliseconds: degraded ? 90 : 50);

  @visibleForTesting
  static double estimatedRaceEventsPerSecond(int activePlayers) {
    final players = activePlayers.clamp(2, 4);
    final interval = raceSnapshotInterval(activePlayers: players);
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
  final StreamController<Map<String, dynamic>> _events =
      StreamController.broadcast();
  RealtimeChannel? _channel;
  Future<void>? _connectFuture;
  Timer? _reconnectTimer;
  bool _disposed = false;

  Stream<Map<String, dynamic>> get events => _events.stream;

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
            connected.value = true;
            deliveryHealthy.value = true;
            if (!_events.isClosed) {
              _events.add(decodeBroadcastPayload(payload));
            }
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
            connected.value = true;
            deliveryHealthy.value = true;
            error.value = null;
            reconnectAttempts.value = 0;
            _reconnectTimer?.cancel();
            _reconnectTimer = null;
            await channel.track({
              'user_id': userId,
              'online_at': DateTime.now().toUtc().toIso8601String(),
            });
            if (!completer.isCompleted) completer.complete();
          } else if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut) {
            connected.value = false;
            deliveryHealthy.value = false;
            error.value =
                subscribeError?.toString() ?? 'Realtime connection failed';
            if (!completer.isCompleted) {
              completer.completeError(StateError(error.value!));
            }
            _scheduleReconnect();
          } else if (status == RealtimeSubscribeStatus.closed) {
            connected.value = false;
            deliveryHealthy.value = false;
            _scheduleReconnect();
          }
        });
    try {
      await completer.future.timeout(const Duration(seconds: 12));
    } catch (_) {
      connected.value = false;
      deliveryHealthy.value = false;
      _scheduleReconnect();
      rethrow;
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _reconnectTimer?.isActive == true) return;
    final attempt = reconnectAttempts.value + 1;
    reconnectAttempts.value = attempt;
    final seconds = switch (attempt) {
      1 => 1,
      2 => 2,
      3 => 4,
      _ => 8,
    };
    _reconnectTimer = Timer(Duration(seconds: seconds), () {
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
      deliveryHealthy.value = false;
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
      if (!delivered) {
        error.value = 'Realtime message could not be queued';
        _scheduleReconnect();
      }
      return delivered;
    } catch (exception) {
      deliveryHealthy.value = false;
      error.value = 'Realtime send failed: $exception';
      _scheduleReconnect();
      return false;
    }
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
    await _events.close();
  }
}
