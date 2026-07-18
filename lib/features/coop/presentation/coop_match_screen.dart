import 'package:balanco_game/features/coop/application/coop_game_coordinator.dart';
import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoopMatchScreen extends StatefulWidget {
  const CoopMatchScreen({
    super.key,
    required this.room,
    required this.realtime,
    required this.voice,
  });

  final CoopRoom room;
  final CoopRealtimeSession realtime;
  final VoiceChatController voice;

  @override
  State<CoopMatchScreen> createState() => _CoopMatchScreenState();
}

class _CoopMatchScreenState extends State<CoopMatchScreen> {
  late final BalancoGame _game;
  late final CoopGameCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final side = widget.room.memberFor(userId).side;
    _game = BalancoGame(
      isMultiplayer: true,
      isInfinityMode: false,
      playerRole: side.name.toUpperCase(),
      randomSeed: widget.room.seed,
      enableTutorials: false,
      onlineLevelVersion: widget.room.raceLevelVersion,
    )..currentLevel.value = widget.room.raceLevel;
    _coordinator = CoopGameCoordinator(
      initialRoom: widget.room,
      userId: userId,
      game: _game,
      repository: CoopRepository(Supabase.instance.client),
      realtime: widget.realtime,
    )..attach();
  }

  @override
  void dispose() {
    _coordinator.dispose();
    widget.voice.dispose();
    widget.realtime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GamePlayOverlay(
    game: _game,
    coopCoordinator: _coordinator,
    voice: widget.voice,
  );
}
