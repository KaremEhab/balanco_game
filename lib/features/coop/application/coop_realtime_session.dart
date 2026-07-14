import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final StreamController<Map<String, dynamic>> _events =
      StreamController.broadcast();
  RealtimeChannel? _channel;

  Stream<Map<String, dynamic>> get events => _events.stream;

  Future<void> connect() async {
    if (_channel != null) return;
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
            error.value = null;
            await channel.track({
              'user_id': userId,
              'online_at': DateTime.now().toUtc().toIso8601String(),
            });
            if (!completer.isCompleted) completer.complete();
          } else if (status == RealtimeSubscribeStatus.channelError ||
              status == RealtimeSubscribeStatus.timedOut) {
            error.value =
                subscribeError?.toString() ?? 'Realtime connection failed';
            if (!completer.isCompleted) {
              completer.completeError(StateError(error.value!));
            }
          } else if (status == RealtimeSubscribeStatus.closed) {
            connected.value = false;
          }
        });
    return completer.future.timeout(const Duration(seconds: 12));
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
      if (!delivered) error.value = 'Realtime delivery was not acknowledged';
      return delivered;
    } catch (exception) {
      deliveryHealthy.value = false;
      error.value = 'Realtime send failed: $exception';
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
    final channel = _channel;
    _channel = null;
    if (channel != null) {
      await channel.untrack();
      await _client.removeChannel(channel);
    }
    connected.dispose();
    onlinePlayers.dispose();
    error.dispose();
    deliveryHealthy.dispose();
    await _events.close();
  }
}
