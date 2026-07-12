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
}
