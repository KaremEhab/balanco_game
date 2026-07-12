import 'dart:async';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/presentation/coop_match_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoopWaitingRoomScreen extends StatefulWidget {
  const CoopWaitingRoomScreen({super.key, required this.initialRoom});
  final CoopRoom initialRoom;

  @override
  State<CoopWaitingRoomScreen> createState() => _CoopWaitingRoomScreenState();
}

class _CoopWaitingRoomScreenState extends State<CoopWaitingRoomScreen> {
  late CoopRoom _room;
  late final String _userId;
  late final CoopRepository _repository;
  late final CoopRealtimeSession _realtime;
  late final VoiceChatController _voice;
  StreamSubscription<Map<String, dynamic>>? _events;
  Timer? _roomRefreshTimer;
  bool _busy = false;
  bool _handoff = false;
  bool _reloading = false;

  bool get _isHost => _room.hostId == _userId;
  CoopMember get _me => _room.memberFor(_userId);

  @override
  void initState() {
    super.initState();
    _room = widget.initialRoom;
    _userId = Supabase.instance.client.auth.currentUser!.id;
    _repository = CoopRepository(Supabase.instance.client);
    _realtime = CoopRealtimeSession(
      client: Supabase.instance.client,
      roomId: _room.id,
      userId: _userId,
    );
    _voice = VoiceChatController(
      realtime: _realtime,
      isHost: _isHost,
      userId: _userId,
    );
    _connect();
    _roomRefreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _reload(),
    );
  }

  Future<void> _connect() async {
    try {
      await _realtime.connect();
      _events = _realtime.events.listen((event) async {
        if (event['action'] == 'room_changed') await _reload();
      });
      await _voice.initialize();
      await _realtime.notifyRoomChanged();
    } catch (error) {
      if (mounted) _message('Realtime connection failed: $error');
    }
  }

  Future<void> _reload() async {
    if (_reloading || _handoff) return;
    _reloading = true;
    try {
      final room = await _repository.getRoom(_room.id);
      if (!mounted) return;
      setState(() => _room = room);
      if (room.isPlaying) _enterMatch();
    } catch (_) {
      // Realtime remains primary; the next fallback refresh retries quietly.
    } finally {
      _reloading = false;
    }
  }

  Future<void> _mutate(Future<CoopRoom> Function() action) async {
    setState(() => _busy = true);
    try {
      final room = await action();
      if (!mounted) return;
      setState(() => _room = room);
      await _realtime.notifyRoomChanged();
      if (room.isPlaying) _enterMatch();
    } on PostgrestException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _enterMatch() {
    if (_handoff || !mounted) return;
    _handoff = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            CoopMatchScreen(room: _room, realtime: _realtime, voice: _voice),
      ),
    );
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  void dispose() {
    _roomRefreshTimer?.cancel();
    _events?.cancel();
    if (!_handoff) {
      _voice.dispose();
      _realtime.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF76D7E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'WAITING ROOM',
          style: GoogleFonts.luckiestGuy(color: GameColors.brownDarkUi),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: GameColors.sandLightUi,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: GameColors.brownDarkUi, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: GameColors.brownDarkUi,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'ROOM CODE',
                    style: GoogleFonts.luckiestGuy(
                      color: GameColors.brownDarkUi,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: _room.code));
                      _message('Room code copied—send it to your partner!');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _room.code,
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 38,
                            letterSpacing: 7,
                            color: GameColors.deepPurple,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.copy_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<int>(
                    valueListenable: _realtime.onlinePlayers,
                    builder: (_, count, _) => Text(
                      '$count/2 ONLINE',
                      style: GoogleFonts.luckiestGuy(
                        color: count == 2 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final side in CoopSide.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _PlayerSlot(
                          side: side,
                          member: _room.members
                              .where((m) => m.side == side)
                              .firstOrNull,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            ValueListenableBuilder<bool>(
              valueListenable: _voice.muted,
              builder: (_, muted, _) => ElevatedButton.icon(
                onPressed: _voice.toggleMute,
                icon: Icon(muted ? Icons.mic_off_rounded : Icons.mic_rounded),
                label: Text(
                  muted ? 'UNMUTE MIC' : 'MUTE MIC',
                  style: GoogleFonts.luckiestGuy(),
                ),
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: _voice.error,
              builder: (_, error, _) {
                if (error != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                }
                return ValueListenableBuilder<bool>(
                  valueListenable: _voice.connected,
                  builder: (_, connected, _) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      connected ? 'VOICE CONNECTED' : 'CONNECTING VOICE...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: connected ? Colors.green : Colors.blueGrey,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _busy
                  ? null
                  : () => _mutate(
                      () => _repository.setReady(_room.id, !_me.ready),
                    ),
              icon: Icon(
                _me.ready
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
              label: Text(
                _me.ready ? 'I AM READY!' : 'MARK ME READY',
                style: GoogleFonts.luckiestGuy(fontSize: 19),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _me.ready
                    ? Colors.green
                    : GameColors.orangeTextUi,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),
            if (_isHost) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _mutate(() => _repository.swapSides(_room.id)),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: Text(
                  'SWAP BOTH SIDES',
                  style: GoogleFonts.luckiestGuy(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _busy || !_room.canStart
                    ? null
                    : () => _mutate(() => _repository.startRoom(_room.id)),
                icon: const Icon(Icons.rocket_launch_rounded),
                label: Text(
                  _room.canStart ? 'START CO-OP!' : 'WAITING FOR BOTH PLAYERS',
                  style: GoogleFonts.luckiestGuy(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(17),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayerSlot extends StatelessWidget {
  const _PlayerSlot({required this.side, required this.member});
  final CoopSide side;
  final CoopMember? member;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: member == null ? Colors.white54 : GameColors.sandLightUi,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: GameColors.brownDarkUi, width: 3),
      boxShadow: const [
        BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 5)),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          side == CoopSide.left ? Icons.south_rounded : Icons.north_rounded,
          size: 38,
          color: side == CoopSide.left ? Colors.blue : Colors.purple,
        ),
        Text(
          side.name.toUpperCase(),
          style: GoogleFonts.luckiestGuy(fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          member?.displayName ?? 'WAITING...',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 7),
        Icon(
          member?.ready == true
              ? Icons.check_circle_rounded
              : Icons.hourglass_bottom_rounded,
          color: member?.ready == true ? Colors.green : Colors.orange,
        ),
        if (member?.isHost == true)
          Text(
            'HOST',
            style: GoogleFonts.luckiestGuy(
              fontSize: 11,
              color: GameColors.orangeTextUi,
            ),
          ),
      ],
    ),
  );
}
