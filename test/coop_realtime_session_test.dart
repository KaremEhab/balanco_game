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
    expect(RealtimeTrafficPolicy.estimatedRaceEventsPerSecond(2), 80);
    expect(RealtimeTrafficPolicy.estimatedRaceEventsPerSecond(3), lessThan(81));
    expect(RealtimeTrafficPolicy.estimatedRaceEventsPerSecond(4), 80);
    expect(
      RealtimeTrafficPolicy.raceSnapshotInterval(
        activePlayers: 4,
        degraded: true,
      ),
      const Duration(milliseconds: 320),
    );
  });
}
