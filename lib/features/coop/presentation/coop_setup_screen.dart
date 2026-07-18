import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoopSetupScreen extends StatefulWidget {
  const CoopSetupScreen({super.key});

  @override
  State<CoopSetupScreen> createState() => _CoopSetupScreenState();
}

class _CoopSetupScreenState extends State<CoopSetupScreen> {
  late final CoopRepository _repository;
  final _roomCode = TextEditingController();
  CoopSide _side = CoopSide.left;
  bool _busy = false;

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
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final room = await action();
      if (room.isRace) {
        throw const FormatException('That code belongs to a Race room.');
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
    } catch (_) {
      _message('Could not connect to the CO-OP room. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF102B78),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text('CO-OP MODE', style: GoogleFonts.luckiestGuy()),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          _CoopCard(
            color: const Color(0xFF30BFF3),
            child: Column(
              children: [
                const Icon(
                  Icons.handshake_rounded,
                  color: Colors.white,
                  size: 58,
                ),
                Text(
                  'BALANCE TOGETHER',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose which joystick side you control. Your partner '
                  'automatically controls the other side.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'CHOOSE YOUR SIDE',
                  style: GoogleFonts.luckiestGuy(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SideButton(
                        side: CoopSide.left,
                        selected: _side == CoopSide.left,
                        busy: _busy,
                        onTap: () => setState(() => _side = CoopSide.left),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SideButton(
                        side: CoopSide.right,
                        selected: _side == CoopSide.right,
                        busy: _busy,
                        onTap: () => setState(() => _side = CoopSide.right),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CoopButton(
                  label: 'CREATE CO-OP',
                  icon: Icons.add_link_rounded,
                  busy: _busy,
                  onPressed: () => _open(() => _repository.createRoom(_side)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _CoopCard(
            color: const Color(0xFFFF8A3D),
            child: Column(
              children: [
                const Icon(
                  Icons.group_add_rounded,
                  color: Colors.white,
                  size: 48,
                ),
                Text(
                  'JOIN YOUR PARTNER',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter the room code your partner sent you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _roomCode,
                  enabled: !_busy,
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: GameColors.brownDarkUi,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: GameColors.deepPurple,
                        width: 4,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _joinRoom(),
                ),
                const SizedBox(height: 12),
                _CoopButton(
                  label: 'JOIN CO-OP',
                  icon: Icons.handshake_rounded,
                  busy: _busy,
                  onPressed: _joinRoom,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  void _joinRoom() {
    final code = _roomCode.text.trim().toUpperCase();
    if (code.length != 6) {
      _message('Enter the complete 6-character room code.');
      return;
    }
    _open(() => _repository.joinRoom(code));
  }
}

class _CoopCard extends StatelessWidget {
  const _CoopCard({required this.color, required this.child});

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

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.side,
    required this.selected,
    required this.busy,
    required this.onTap,
  });

  final CoopSide side;
  final bool selected;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: const Duration(milliseconds: 180),
    scale: selected ? 1 : 0.96,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? GameColors.deepPurple : GameColors.sandLightUi,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: GameColors.brownDarkUi, width: 3),
            boxShadow: const [
              BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Icon(
                side == CoopSide.left
                    ? Icons.keyboard_double_arrow_left_rounded
                    : Icons.keyboard_double_arrow_right_rounded,
                color: selected ? Colors.white : GameColors.brownDarkUi,
                size: 30,
              ),
              const SizedBox(height: 3),
              Text(
                side.name.toUpperCase(),
                style: GoogleFonts.luckiestGuy(
                  color: selected ? Colors.white : GameColors.brownDarkUi,
                  fontSize: 17,
                ),
              ),
              Text(
                selected ? 'SELECTED' : 'TAP TO PICK',
                style: TextStyle(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.78)
                      : GameColors.gray600,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CoopButton extends StatelessWidget {
  const _CoopButton({
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
        disabledForegroundColor: Colors.white70,
        disabledBackgroundColor: const Color(0xFF7968B7),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
        ),
      ),
    ),
  );
}
