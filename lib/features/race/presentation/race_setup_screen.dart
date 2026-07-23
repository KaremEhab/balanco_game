import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RaceSetupScreen extends StatefulWidget {
  const RaceSetupScreen({super.key, this.isBattleRace = false});

  final bool isBattleRace;

  @override
  State<RaceSetupScreen> createState() => _RaceSetupScreenState();
}

class _RaceSetupScreenState extends State<RaceSetupScreen> {
  late final CoopRepository _repository;
  final _roomCode = TextEditingController();
  bool _busy = false;
  int _maxPlayers = 2;

  @override
  void initState() {
    super.initState();
    _repository = CoopRepository(Supabase.instance.client);
  }

  @override
  void dispose() {
    _roomCode.dispose();
    super.dispose();
  }

  Future<void> _open(Future<CoopRoom> Function() action) async {
    setState(() => _busy = true);
    try {
      final room = await action();
      if (!room.isRace) {
        throw const FormatException('That code belongs to a CO-OP room.');
      }
      if (room.isBattleRace != widget.isBattleRace) {
        throw FormatException(
          widget.isBattleRace
              ? 'That code belongs to a regular Online Race.'
              : 'That code belongs to a Battle Race.',
        );
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
        ),
      );
    } on PostgrestException catch (error) {
      _message(error.message);
    } on FormatException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF102B78),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.isBattleRace ? 'BATTLE RACE' : 'RACE MODE',
        style: GoogleFonts.luckiestGuy(),
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          _RaceCard(
            color: const Color(0xFF30BFF3),
            child: Column(
              children: [
                Icon(
                  widget.isBattleRace
                      ? Icons.flash_on_rounded
                      : Icons.sports_score_rounded,
                  color: Colors.white,
                  size: 58,
                ),
                Text(
                  widget.isBattleRace
                      ? 'BALANCE. BATTLE. FINISH.'
                      : 'FIRST TO FINISH WINS',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isBattleRace
                      ? 'Two to four racers share one course. Collect weapons, '
                            'knock rivals off with physical collisions and Heat '
                            'Wave, then reach the gate first. Falls have unlimited '
                            'checkpoint recovery.'
                      : 'Every racer gets the same level and synchronized start. '
                            'Up to four live bars and balls share one portrait board.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'PLAYERS',
                  style: GoogleFonts.luckiestGuy(color: Colors.white),
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 2, label: Text('2')),
                    ButtonSegment(value: 3, label: Text('3')),
                    ButtonSegment(value: 4, label: Text('4')),
                  ],
                  selected: {_maxPlayers},
                  onSelectionChanged: _busy
                      ? null
                      : (value) => setState(() => _maxPlayers = value.first),
                ),
                const SizedBox(height: 14),
                _RaceButton(
                  label: widget.isBattleRace ? 'CREATE BATTLE' : 'CREATE RACE',
                  icon: Icons.add_link_rounded,
                  busy: _busy,
                  onPressed: () => _open(
                    widget.isBattleRace
                        ? () => _repository.createBattleRaceRoom(
                            maxPlayers: _maxPlayers,
                          )
                        : () => _repository.createRaceRoom(
                            maxPlayers: _maxPlayers,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _RaceCard(
            color: const Color(0xFFFF8A3D),
            child: Column(
              children: [
                Text(
                  'JOIN A FRIEND',
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _roomCode,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 26,
                    letterSpacing: 5,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'ABC123',
                    filled: true,
                    fillColor: GameColors.sandLightUi,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: GameColors.brownDarkUi,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _RaceButton(
                  label: widget.isBattleRace ? 'JOIN BATTLE' : 'JOIN RACE',
                  icon: Icons.flag_rounded,
                  busy: _busy,
                  onPressed: () => _open(
                    () => _repository.joinRaceRoom(
                      _roomCode.text,
                      battle: widget.isBattleRace,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _RaceCard extends StatelessWidget {
  const _RaceCard({required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: GameColors.brownDarkUi, width: 4),
      boxShadow: const [
        BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 7)),
      ],
    ),
    child: child,
  );
}

class _RaceButton extends StatelessWidget {
  const _RaceButton({
    required this.label,
    required this.icon,
    required this.busy,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: busy ? null : onPressed,
      icon: busy
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : Icon(icon),
      label: Text(label, style: GoogleFonts.luckiestGuy(fontSize: 20)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF6544CF),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
        ),
      ),
    ),
  );
}
