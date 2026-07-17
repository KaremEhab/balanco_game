import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SocialGameMode { coop, race }

Future<CoopRoom?> showFriendGameInviteFlow({
  required BuildContext context,
  required CoopRepository repository,
  required Map<String, dynamic> firstFriend,
}) async {
  final mode = await showDialog<SocialGameMode>(
    context: context,
    builder: (context) => const _ModePickerDialog(),
  );
  if (mode == null || !context.mounted) return null;

  var players = 2;
  if (mode == SocialGameMode.race) {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => const _PlayerCountDialog(),
    );
    if (selected == null || !context.mounted) return null;
    players = selected;
  }

  var room = await repository.invitePlayerToGame(
    playerCode: firstFriend['player_code'] as String,
    mode: mode.name,
    maxPlayers: players,
  );
  if (mode == SocialGameMode.race && players > 2 && context.mounted) {
    room =
        await showRaceMultiInviteDialog(
          context: context,
          repository: repository,
          room: room,
          initiallyInvited: [firstFriend],
        ) ??
        room;
  }
  return room;
}

Future<CoopRoom?> showRaceMultiInviteDialog({
  required BuildContext context,
  required CoopRepository repository,
  required CoopRoom room,
  List<Map<String, dynamic>> initiallyInvited = const [],
}) => showDialog<CoopRoom>(
  context: context,
  barrierDismissible: false,
  builder: (context) => _RaceMultiInviteDialog(
    repository: repository,
    initialRoom: room,
    initiallyInvited: initiallyInvited,
  ),
);

class _ModePickerDialog extends StatelessWidget {
  const _ModePickerDialog();

  @override
  Widget build(BuildContext context) => _CartoonDialog(
    title: 'CHOOSE GAME MODE',
    child: Row(
      children: [
        Expanded(
          child: _ChoiceButton(
            label: 'CO-OP',
            icon: Icons.handshake_rounded,
            color: GameColors.modesScreenColor2,
            onTap: () => Navigator.pop(context, SocialGameMode.coop),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ChoiceButton(
            label: 'RACE',
            icon: Icons.sports_score_rounded,
            color: GameColors.deepPurple,
            onTap: () => Navigator.pop(context, SocialGameMode.race),
          ),
        ),
      ],
    ),
  );
}

class _PlayerCountDialog extends StatelessWidget {
  const _PlayerCountDialog();

  @override
  Widget build(BuildContext context) => _CartoonDialog(
    title: 'RACE PLAYERS',
    subtitle: 'Choose the exact lobby size.',
    child: Row(
      children: [
        for (final count in const [2, 3, 4]) ...[
          Expanded(
            child: _ChoiceButton(
              label: '$count',
              icon: Icons.groups_rounded,
              color: count == 4
                  ? GameColors.orangeTextUi
                  : GameColors.deepPurple,
              onTap: () => Navigator.pop(context, count),
            ),
          ),
          if (count != 4) const SizedBox(width: 9),
        ],
      ],
    ),
  );
}

class _RaceMultiInviteDialog extends StatefulWidget {
  const _RaceMultiInviteDialog({
    required this.repository,
    required this.initialRoom,
    required this.initiallyInvited,
  });

  final CoopRepository repository;
  final CoopRoom initialRoom;
  final List<Map<String, dynamic>> initiallyInvited;

  @override
  State<_RaceMultiInviteDialog> createState() => _RaceMultiInviteDialogState();
}

class _RaceMultiInviteDialogState extends State<_RaceMultiInviteDialog> {
  final _code = TextEditingController();
  late CoopRoom _room;
  late final List<Map<String, dynamic>> _invited;
  List<Map<String, dynamic>> _friends = const [];
  bool _busy = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _room = widget.initialRoom;
    _invited = [...widget.initiallyInvited];
    _loadFriends();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    try {
      final social = await widget.repository.listFriends();
      _friends = (social['friends'] as List? ?? const [])
          .map((value) => Map<String, dynamic>.from(value as Map))
          .toList();
    } catch (error) {
      _error = error.toString();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool _alreadyInvited(String code) =>
      _invited.any((friend) => friend['player_code'] == code);

  Future<void> _invite(Map<String, dynamic> player) async {
    final code = player['player_code'] as String;
    if (_alreadyInvited(code)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      _room = await widget.repository.invitePlayerToGame(
        playerCode: code,
        mode: 'race',
        maxPlayers: _room.maxPlayers,
        roomId: _room.id,
      );
      _invited.add(player);
    } on PostgrestException catch (error) {
      _error = error.message;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _searchAddAndInvite() async {
    final code = _code.text.trim().toUpperCase();
    if (code.length < 5) {
      setState(() => _error = 'Enter a valid player code.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final player = await widget.repository.findPlayer(code);
      if (player == null) throw const FormatException('Player not found.');
      try {
        await widget.repository.sendFriendRequest(code);
      } on PostgrestException {
        // The player may already be a friend or have a pending request. The
        // game invitation is still allowed and remains a separate decision.
      }
      await _invite({
        'user_id': player.id,
        'display_name': player.displayName,
        'player_code': player.playerCode,
      });
      _code.clear();
    } on PostgrestException catch (error) {
      _error = error.message;
    } on FormatException catch (error) {
      _error = error.message;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => _CartoonDialog(
    title: 'BUILD YOUR RACE',
    subtitle: '${_invited.length + 1}/${_room.maxPlayers} seats planned',
    child: SizedBox(
      width: 390,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              const Chip(
                avatar: Icon(Icons.stars_rounded, size: 18),
                label: Text('YOU · HOST'),
              ),
              for (final player in _invited)
                Chip(
                  avatar: const Icon(Icons.mail_rounded, size: 18),
                  label: Text(player['display_name'] as String),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_invited.length < _room.maxPlayers - 1) ...[
            TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'SEARCH PLAYER CODE',
                suffixIcon: IconButton(
                  onPressed: _busy ? null : _searchAddAndInvite,
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView(
                children: [
                  for (final friend in _friends)
                    ListTile(
                      dense: true,
                      leading: const CircleAvatar(
                        child: Icon(Icons.person_rounded),
                      ),
                      title: Text(friend['display_name'] as String),
                      subtitle: Text(friend['player_code'] as String),
                      trailing: IconButton(
                        onPressed:
                            _busy ||
                                _alreadyInvited(friend['player_code'] as String)
                            ? null
                            : () => _invite(friend),
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (_busy) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: const TextStyle(
                  color: GameColors.redAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _busy ? null : () => Navigator.pop(context, _room),
              icon: const Icon(Icons.meeting_room_rounded),
              label: Text('OPEN RACE LOBBY', style: GoogleFonts.luckiestGuy()),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CartoonDialog extends StatelessWidget {
  const _CartoonDialog({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(18),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameColors.sandLightUi,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: GameColors.brownDarkUi, width: 4),
        boxShadow: const [
          BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.luckiestGuy(
              color: GameColors.brownDarkUi,
              fontSize: 24,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
          const SizedBox(height: 17),
          child,
        ],
      ),
    ),
  );
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
      ),
    ),
    child: Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 5),
        Text(label, style: GoogleFonts.luckiestGuy(fontSize: 18)),
      ],
    ),
  );
}
