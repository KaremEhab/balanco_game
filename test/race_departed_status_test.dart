import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/race/presentation/race_portrait_match_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('right race header never selects the local player', () {
    const local = CoopMember(
      userId: 'local-auth-id',
      displayName: 'Kareem Ehab',
      playerCode: 'KA12345',
      side: CoopSide.slot1,
      ready: true,
      isHost: true,
      micMuted: false,
    );
    const staleLocalDuplicate = CoopMember(
      userId: 'stale-local-id',
      displayName: 'Kareem Ehab',
      playerCode: 'KA12345',
      side: CoopSide.slot2,
      ready: true,
      isHost: false,
      micMuted: false,
    );
    const opponent = CoopMember(
      userId: 'opponent-id',
      displayName: 'Hajer Ahmed',
      playerCode: 'HA54321',
      side: CoopSide.slot3,
      ready: true,
      isHost: false,
      micMuted: false,
    );

    final whileLocalTalks = selectRaceHeaderOpponent(
      members: const [local, staleLocalDuplicate, opponent],
      localMember: local,
      voiceUserId: local.userId,
      activeSpeakerId: local.userId,
    );
    final whileOpponentTalks = selectRaceHeaderOpponent(
      members: const [local, staleLocalDuplicate, opponent],
      localMember: local,
      voiceUserId: local.userId,
      activeSpeakerId: opponent.userId,
    );

    expect(whileLocalTalks?.userId, opponent.userId);
    expect(whileOpponentTalks?.userId, opponent.userId);
  });

  testWidgets('departed racer shows LEFT instead of hearts', (tester) async {
    final member = CoopMember(
      userId: 'departed-player',
      displayName: 'Departed Player',
      playerCode: 'DE12345',
      side: CoopSide.slot2,
      ready: false,
      isHost: false,
      micMuted: true,
      leftAt: DateTime.utc(2026, 7, 18),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF102C72),
          body: Center(child: RaceMemberVitals(member: member, hearts: 3)),
        ),
      ),
    );

    expect(find.text('LEFT'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
    expect(
      find.byKey(const ValueKey('race-player-left-departed-player')),
      findsOneWidget,
    );
  });
}
