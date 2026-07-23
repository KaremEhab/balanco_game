import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unwraps the Flutter Realtime broadcast payload envelope', () {
    final event = CoopRealtimeSession.decodeBroadcastPayload({
      'event': 'coop',
      'payload': {
        'type': 'broadcast',
        'action': 'room_changed',
        'from': 'partner-id',
      },
    });

    expect(event['action'], 'room_changed');
    expect(event['type'], 'broadcast');
    expect(event['from'], 'partner-id');
  });

  test('race snapshot cadence remains below the shared event limit', () {
    for (final players in [2, 3, 4]) {
      expect(
        RealtimeTrafficPolicy.estimatedRaceEventsPerSecond(players),
        lessThanOrEqualTo(55),
      );
      expect(
        RealtimeTrafficPolicy.estimatedRaceEventsPerSecond(
              players,
              activeRooms: 2,
            ) *
            2,
        lessThanOrEqualTo(55),
      );
      expect(
        RealtimeTrafficPolicy.estimatedRaceEventsPerSecond(
              players,
              activeRooms: 20,
            ) *
            20,
        lessThanOrEqualTo(55),
      );
    }
    expect(
      RealtimeTrafficPolicy.raceSnapshotInterval(
        activePlayers: 4,
        degraded: true,
      ),
      const Duration(milliseconds: 466),
    );
  });

  test('reconnect policy uses bounded jitter on exponential backoff', () {
    expect(
      RealtimeTrafficPolicy.reconnectDelay(1, jitterMs: 0),
      const Duration(seconds: 1),
    );
    expect(
      RealtimeTrafficPolicy.reconnectDelay(4, jitterMs: 500),
      const Duration(milliseconds: 8500),
    );
    expect(
      RealtimeTrafficPolicy.reconnectDelay(9, jitterMs: 900),
      const Duration(milliseconds: 8500),
    );
  });

  test('network diagnostics estimates snapshot loss from sequence gaps', () {
    const diagnostics = NetworkDiagnosticsSnapshot(
      connected: true,
      deliveryHealthy: true,
      region: 'test',
      disconnects: 0,
      reconnects: 0,
      reconnectAttempts: 0,
      packetsSent: 10,
      packetsReceived: 95,
      motionPacketsReceived: 95,
      packetsSkipped: 5,
      corrections: 0,
    );

    expect(diagnostics.estimatedPacketLossPercent, 5);
  });
}
