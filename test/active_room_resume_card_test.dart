import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/presentation/active_room_resume_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a recoverable race and invokes Resume', (tester) async {
    var resumed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActiveRoomResumeCard(
            room: _room(mode: 'race', status: 'playing'),
            busy: false,
            onResume: () => resumed = true,
          ),
        ),
      ),
    );

    expect(find.text('RACE  •  ABC123'), findsOneWidget);
    expect(find.textContaining('MATCH IN PROGRESS'), findsOneWidget);
    await tester.tap(find.text('RESUME'));
    expect(resumed, isTrue);
  });

  testWidgets('describes a paused co-op room', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActiveRoomResumeCard(
            room: _room(mode: 'coop', status: 'paused'),
            busy: false,
            onResume: () {},
          ),
        ),
      ),
    );

    expect(find.text('CO-OP  •  ABC123'), findsOneWidget);
    expect(find.textContaining('MATCH PAUSED'), findsOneWidget);
  });
}

CoopRoom _room({required String mode, required String status}) => CoopRoom(
  id: 'room-id',
  code: 'ABC123',
  hostId: 'player-1',
  status: status,
  hostSide: CoopSide.left,
  seed: 7,
  attemptNumber: 1,
  score: 0,
  leaveRequestedBy: null,
  endReason: null,
  mode: mode,
  raceLevel: 1,
  raceLevelVersion: null,
  startedAt: DateTime.utc(2026, 7, 17),
  winnerId: null,
  winnerFinishedAt: null,
  winnerElapsedMs: null,
  winnerHearts: null,
  winnerStars: null,
  raceEndKind: null,
  rematchRequestedBy: null,
  raceRestartKind: null,
  maxPlayers: 2,
  restartVoteCount: 0,
  leaveVoteCount: 0,
  members: const [
    CoopMember(
      userId: 'player-1',
      displayName: 'Kareem',
      playerCode: 'KA12345',
      side: CoopSide.left,
      ready: true,
      isHost: true,
      micMuted: false,
    ),
    CoopMember(
      userId: 'player-2',
      displayName: 'Partner',
      playerCode: 'PA12345',
      side: CoopSide.right,
      ready: true,
      isHost: false,
      micMuted: false,
    ),
  ],
);
