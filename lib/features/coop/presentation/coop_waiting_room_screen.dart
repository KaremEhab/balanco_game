import 'dart:async';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/presentation/coop_match_screen.dart';
import 'package:balanco_game/features/race/presentation/race_match_screen.dart';
import 'package:balanco_game/features/social/widgets/game_invite_flow.dart';
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
  bool _leavingRace = false;
  bool _allowRacePop = false;
  String? _lobbyError;

  List<CoopSide> get _visibleSlots => _room.isRace
      ? const [
          CoopSide.slot1,
          CoopSide.slot2,
          CoopSide.slot3,
          CoopSide.slot4,
        ].take(_room.maxPlayers).toList()
      : coopControlSides;

  bool get _isHost => _room.hostId == _userId;
  CoopMember get _me => _room.memberFor(_userId);
  bool get _shouldEnterMatch =>
      _room.isPlaying || _room.isPaused || _room.hasLeaveVote;

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
      if (_shouldEnterMatch) _enterMatch();
    } catch (error) {
      if (mounted) _message('Realtime connection failed: $error');
    }
  }

  Future<void> _reload() async {
    if (_reloading || _handoff || _busy) return;
    _reloading = true;
    try {
      final room = await _repository.getRoom(_room.id);
      if (!mounted) return;
      setState(() => _room = room);
      if (_shouldEnterMatch) _enterMatch();
    } catch (_) {
      // Realtime remains primary; the next fallback refresh retries quietly.
    } finally {
      _reloading = false;
    }
  }

  Future<void> _mutate(Future<CoopRoom> Function() action) async {
    setState(() {
      _busy = true;
      _lobbyError = null;
    });
    try {
      final room = await action();
      if (!mounted) return;
      setState(() {
        _room = room;
        _lobbyError = null;
      });
      await _realtime.notifyRoomChanged();
      if (_shouldEnterMatch) _enterMatch();
    } on PostgrestException catch (error) {
      if (mounted) setState(() => _lobbyError = error.message);
    } catch (error) {
      if (mounted) {
        setState(() {
          _lobbyError = 'Could not update the game room. $error';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _enterMatch() {
    if (_handoff || !mounted) return;
    _handoff = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => _room.isRace
            ? RaceMatchScreen(room: _room, realtime: _realtime, voice: _voice)
            : CoopMatchScreen(room: _room, realtime: _realtime, voice: _voice),
      ),
    );
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _leaveRaceLobby() async {
    if (!_room.isRace || _leavingRace || !mounted) return;
    setState(() => _leavingRace = true);
    setState(() => _allowRacePop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _inviteRacePlayers() async {
    final updated = await showRaceMultiInviteDialog(
      context: context,
      repository: _repository,
      room: _room,
      initiallyInvited: _room.members
          .where((member) => member.userId != _userId)
          .map(
            (member) => {
              'user_id': member.userId,
              'display_name': member.displayName,
              'player_code': member.playerCode,
            },
          )
          .toList(),
    );
    if (updated != null && mounted) setState(() => _room = updated);
  }

  Future<void> _editLevelRange() async {
    if (!_isHost || _busy) return;
    final selection = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RaceSeriesPicker(
        initialStart: _room.raceStartLevel,
        initialEnd: _room.raceEndLevel,
        highestLevel: _me.highestLevel,
        requireOdd: _room.isRace,
        isCoop: !_room.isRace,
      ),
    );
    if (selection == null || !mounted) return;
    // Let the bottom-sheet OverlayPortal and slider gesture detach before the
    // authoritative room update rebuilds this route. Updating on the same
    // frame can leave an inherited element with live dependents on Flutter.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await _mutate(() {
      if (_room.isRace) {
        return _repository.configureRaceSeries(
          _room.id,
          startLevel: selection.first,
          endLevel: selection.last,
        );
      }
      return _repository.configureCoopSeries(
        _room.id,
        startLevel: selection.first,
        endLevel: selection.last,
      );
    });
  }

  Future<void> _transferHost(CoopMember member) async {
    if (!_isHost || member.userId == _userId || _busy) return;
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GameColors.sandLightUi,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: GameColors.brownDarkUi, width: 4),
        ),
        icon: const Icon(
          Icons.workspace_premium_rounded,
          color: GameColors.orangeTextUi,
          size: 44,
        ),
        title: Text(
          'PASS THE LEAD?',
          textAlign: TextAlign.center,
          style: GoogleFonts.luckiestGuy(color: GameColors.brownDarkUi),
        ),
        content: Text(
          '${member.displayName} will choose the levels and start the race. '
          'Everyone will mark ready again. If your range is above their '
          'unlocked levels, it resets to Level 1.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('KEEP LEAD'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('MAKE HOST'),
          ),
        ],
      ),
    );
    if (approved == true && mounted) {
      await _mutate(
        () => _repository.transferRaceHost(_room.id, member.userId),
      );
    }
  }

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
    return PopScope(
      canPop: !_room.isRace || _allowRacePop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _room.isRace) unawaited(_leaveRaceLobby());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF76D7E8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _room.isRace ? 'RACE LOBBY' : 'WAITING ROOM',
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
                        await Clipboard.setData(
                          ClipboardData(text: _room.code),
                        );
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
                        '$count/${_room.isRace ? _room.maxPlayers : 2} ONLINE',
                        style: GoogleFonts.luckiestGuy(
                          color: count == (_room.isRace ? _room.maxPlayers : 2)
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _LevelSeriesCard(
                room: _room,
                editable: _isHost && !_busy,
                onTap: _editLevelRange,
              ),
              const SizedBox(height: 22),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final side in _visibleSlots)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: _PlayerSlot(
                            side: side,
                            member: _room.members
                                .where((m) => m.side == side)
                                .firstOrNull,
                            canTransferHost:
                                _room.isRace &&
                                _isHost &&
                                _room.members.any(
                                  (member) =>
                                      member.side == side &&
                                      member.userId != _userId,
                                ),
                            onTransferHost: () {
                              final member = _room.members
                                  .where((member) => member.side == side)
                                  .firstOrNull;
                              if (member != null) {
                                unawaited(_transferHost(member));
                              }
                            },
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
                  return ValueListenableBuilder<int>(
                    valueListenable: _voice.connectedPeers,
                    builder: (_, peers, _) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        peers > 0
                            ? 'VOICE CONNECTED · $peers/${_room.members.length - 1}'
                            : 'CONNECTING VOICE...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: peers > 0 ? Colors.green : Colors.blueGrey,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              if (_lobbyError != null) ...[
                _LobbyErrorCard(
                  message: _lobbyError!,
                  onDismiss: () => setState(() => _lobbyError = null),
                ),
                const SizedBox(height: 12),
              ],
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
                if (_room.isRace && _room.members.length < _room.maxPlayers)
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _inviteRacePlayers,
                    icon: const Icon(Icons.group_add_rounded),
                    label: Text(
                      'INVITE MORE RACERS',
                      style: GoogleFonts.luckiestGuy(),
                    ),
                  )
                else if (!_room.isRace)
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
                    _room.canStart
                        ? (_room.isRace ? 'START RACE!' : 'START CO-OP!')
                        : 'WAITING FOR ${_room.isRace ? _room.maxPlayers : 2} PLAYERS',
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
      ),
    );
  }
}

class _PlayerSlot extends StatelessWidget {
  const _PlayerSlot({
    required this.side,
    required this.member,
    required this.canTransferHost,
    required this.onTransferHost,
  });
  final CoopSide side;
  final CoopMember? member;
  final bool canTransferHost;
  final VoidCallback onTransferHost;
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
          side.slotNumber.isOdd ? Icons.south_rounded : Icons.north_rounded,
          size: 38,
          color: side.slotNumber.isOdd ? Colors.blue : Colors.purple,
        ),
        Text(
          side.name.startsWith('slot')
              ? 'PLAYER ${side.slotNumber}'
              : side.name.toUpperCase(),
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
        if (canTransferHost)
          Tooltip(
            message: 'Make ${member?.displayName ?? 'player'} the host',
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onTransferHost,
              icon: const Icon(
                Icons.workspace_premium_rounded,
                color: GameColors.orangeTextUi,
              ),
            ),
          ),
      ],
    ),
  );
}

class _LevelSeriesCard extends StatelessWidget {
  const _LevelSeriesCard({
    required this.room,
    required this.editable,
    required this.onTap,
  });

  final CoopRoom room;
  final bool editable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('race-series-card'),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: GameColors.brownDarkUi, width: 4),
      boxShadow: const [
        BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 6)),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6544CF), Color(0xFF2E84D7)],
          ),
        ),
        child: InkWell(
          onTap: editable ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: GameColors.orangeTextUi,
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 31,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.isRace ? 'RACE SERIES' : 'CO-OP LEVEL RUN',
                        style: GoogleFonts.luckiestGuy(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'LEVEL ${room.raceStartLevel}  ->  ${room.raceEndLevel}  '
                            '|  ${room.seriesRoundCount} ${room.isRace ? 'ROUNDS' : 'LEVELS'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        room.isRace
                            ? 'Most level wins | stars break a tie'
                            : 'Complete every selected level together',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  editable ? Icons.tune_rounded : Icons.lock_clock_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class RaceSeriesPicker extends StatefulWidget {
  const RaceSeriesPicker({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.highestLevel,
    this.requireOdd = true,
    this.isCoop = false,
  });

  final int initialStart;
  final int initialEnd;
  final int highestLevel;
  final bool requireOdd;
  final bool isCoop;

  @override
  State<RaceSeriesPicker> createState() => RaceSeriesPickerState();
}

class RaceSeriesPickerState extends State<RaceSeriesPicker> {
  late RangeValues _range;

  int get _start => _range.start.round();
  int get _end => _range.end.round();
  int get _rounds => _end - _start + 1;
  bool get _isOdd => _rounds.isOdd;
  bool get _isValid => !widget.requireOdd || _isOdd;

  @override
  void initState() {
    super.initState();
    final max = widget.highestLevel.clamp(1, 500);
    _range = RangeValues(
      widget.initialStart.clamp(1, max).toDouble(),
      widget.initialEnd.clamp(1, max).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final max = widget.highestLevel.clamp(1, 500);
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: GameColors.sandLightUi,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(color: GameColors.brownDarkUi, width: 5),
            left: BorderSide(color: GameColors.brownDarkUi, width: 5),
            right: BorderSide(color: GameColors.brownDarkUi, width: 5),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flag_circle_rounded,
                color: GameColors.deepPurple,
                size: 46,
              ),
              Text(
                widget.isCoop ? 'BUILD YOUR CO-OP RUN' : 'BUILD YOUR RACE',
                style: GoogleFonts.luckiestGuy(
                  color: GameColors.brownDarkUi,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.requireOdd
                    ? 'You have Levels 1-$max unlocked. The inclusive range must contain an odd number of levels.'
                    : 'You have Levels 1-$max unlocked. Pick the levels you want to complete together.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DDFD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GameColors.brownDarkUi, width: 3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _pickerValue('START', _start),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: GameColors.deepPurple,
                    ),
                    _pickerValue('END', _end),
                    _pickerValue('ROUNDS', _rounds),
                  ],
                ),
              ),
              if (max > 1)
                SliderTheme(
                  data: SliderTheme.of(
                    context,
                  ).copyWith(showValueIndicator: ShowValueIndicator.never),
                  child: RangeSlider(
                    key: const Key('race-series-range-slider'),
                    min: 1,
                    max: max.toDouble(),
                    divisions: max - 1,
                    values: _range,
                    onChanged: (value) => setState(() {
                      _range = RangeValues(
                        value.start.roundToDouble(),
                        value.end.roundToDouble(),
                      );
                    }),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('Win Level 1 to unlock a longer level range.'),
                ),
              if (widget.requireOdd)
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: GoogleFonts.luckiestGuy(
                    color: _isOdd ? Colors.green : GameColors.red300,
                    fontSize: 13,
                  ),
                  child: Text(
                    _isOdd
                        ? 'PERFECT - $_rounds ${_rounds == 1 ? 'ROUND' : 'ROUNDS'} HAS A CLEAR MAJORITY'
                        : 'CHOOSE ONE MORE OR ONE FEWER LEVEL - $_rounds IS EVEN',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Text(
                  '$_rounds ${_rounds == 1 ? 'LEVEL' : 'LEVELS'} SELECTED',
                  style: GoogleFonts.luckiestGuy(color: Colors.green),
                ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('save-race-series-range'),
                  onPressed: _isValid
                      ? () => Navigator.pop(context, [_start, _end])
                      : null,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: Text(
                    widget.isCoop
                        ? 'LOCK IN $_rounds LEVELS'
                        : 'LOCK IN $_rounds ROUNDS',
                    style: GoogleFonts.luckiestGuy(),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: GameColors.deepPurple,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickerValue(String label, int value) => Column(
    children: [
      Text(
        label,
        style: GoogleFonts.luckiestGuy(
          fontSize: 11,
          color: GameColors.brownDarkUi,
        ),
      ),
      Text(
        '$value',
        style: GoogleFonts.luckiestGuy(
          fontSize: 24,
          color: GameColors.deepPurple,
        ),
      ),
    ],
  );
}

class _LobbyErrorCard extends StatelessWidget {
  const _LobbyErrorCard({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE2DE),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: GameColors.red300, width: 3),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: GameColors.red300),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: GameColors.brownDarkUi,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Dismiss error',
          onPressed: onDismiss,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    ),
  );
}
