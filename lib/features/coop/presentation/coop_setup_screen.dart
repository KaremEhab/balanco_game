import 'dart:async';
import 'dart:convert';
import 'package:balanco_game/core/data/database_helper.dart';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _playerCode = TextEditingController();
  CoopSide _side = CoopSide.left;
  bool _busy = false;
  bool _refreshingSocial = false;
  Timer? _socialRefreshTimer;
  Map<String, dynamic> _social = const {
    'requests': [],
    'friends': [],
    'invites': [],
  };

  @override
  void initState() {
    super.initState();
    _repository = CoopRepository(Supabase.instance.client);
    _refreshAccountAndFriends();
    _socialRefreshTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _refreshAccountAndFriends(refreshPlayer: false),
    );
  }

  Future<void> _refreshAccountAndFriends({bool refreshPlayer = true}) async {
    if (_refreshingSocial) return;
    _refreshingSocial = true;
    try {
      if (refreshPlayer) await PlayerSession.instance.refresh();
      _social = await _repository.listFriends();
      if (mounted) setState(() {});
    } catch (_) {
      // The periodic refresh will retry after transient network failures.
    } finally {
      _refreshingSocial = false;
    }
  }

  @override
  void dispose() {
    _socialRefreshTimer?.cancel();
    _roomCode.dispose();
    _playerCode.dispose();
    super.dispose();
  }

  Future<void> _run(Future<CoopRoom> Function() action) async {
    setState(() => _busy = true);
    try {
      final room = await action();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
        ),
      );
    } on PostgrestException catch (error) {
      _message(error.message);
    } catch (error) {
      _message('Could not connect to the co-op room: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _findAndAddFriend() async {
    final code = _playerCode.text.trim();
    if (code.isEmpty) return;
    setState(() => _busy = true);
    try {
      final player = await _repository.findPlayer(code);
      if (player == null) {
        _message('No player was found with that code.');
      } else if (mounted) {
        final send = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: GameColors.sandLightUi,
            title: Text(
              'ADD ${player.displayName.toUpperCase()}?',
              style: GoogleFonts.luckiestGuy(),
            ),
            content: Text(player.playerCode),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('SEND REQUEST'),
              ),
            ],
          ),
        );
        if (send == true) {
          await _repository.sendFriendRequest(player.playerCode);
          _message('Friend request sent!');
        }
      }
    } on PostgrestException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _inviteFriend(Map<String, dynamic> friend) async {
    setState(() => _busy = true);
    try {
      await DatabaseHelper.instance.saveConfig('last_coop_friend', jsonEncode(friend));
      final room = await _repository.inviteFriend(
        playerCode: friend['player_code'] as String,
        side: _side,
      );
      if (!mounted) return;
      _message('Invitation sent to ${friend['display_name']}!');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
        ),
      );
    } on PostgrestException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _respondToInvite(
    Map<String, dynamic> invite,
    bool accept,
  ) async {
    setState(() => _busy = true);
    try {
      final room = await _repository.respondCoopInvite(
        invite['invite_id'] as String,
        accept,
      );
      if (!mounted) return;
      if (room != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
          ),
        );
      } else {
        _message('Invitation declined.');
        await _refreshAccountAndFriends(refreshPlayer: false);
      }
    } on PostgrestException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = PlayerSession.instance.player.value;
    final requests = _social['requests'] as List? ?? const [];
    final friends = _social['friends'] as List? ?? const [];
    final invites = _social['invites'] as List? ?? const [];
    return Scaffold(
      backgroundColor: const Color(0xFF76D7E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'CO-OP BASE',
          style: GoogleFonts.luckiestGuy(color: GameColors.brownDarkUi),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _BubbleBackgroundPainter()),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
              children: [
                _CartoonCard(
                  child: Column(
                    children: [
                      Text('CHOOSE YOUR SIDE', style: _titleStyle()),
                      const SizedBox(height: 14),
                      Row(
                        children: CoopSide.values
                            .map(
                              (side) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: _CartoonButton(
                                    label: side.name.toUpperCase(),
                                    icon: side == CoopSide.left
                                        ? Icons.west_rounded
                                        : Icons.east_rounded,
                                    selected: _side == side,
                                    onTap: () => setState(() => _side = side),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                      _PrimaryButton(
                        label: 'CREATE ROOM',
                        icon: Icons.add_link_rounded,
                        busy: _busy,
                        onTap: () => _run(() => _repository.createRoom(_side)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _CartoonCard(
                  child: Column(
                    children: [
                      Text('JOIN YOUR PARTNER', style: _titleStyle()),
                      const SizedBox(height: 12),
                      _CodeField(
                        controller: _roomCode,
                        label: '6-CHARACTER ROOM CODE',
                      ),
                      const SizedBox(height: 12),
                      _PrimaryButton(
                        label: 'JOIN ROOM',
                        icon: Icons.group_add_rounded,
                        busy: _busy,
                        color: GameColors.deepPurple,
                        onTap: () =>
                            _run(() => _repository.joinRoom(_roomCode.text)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _CartoonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'YOUR PLAYER CODE',
                        textAlign: TextAlign.center,
                        style: _titleStyle(),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: player?.playerCode ?? ''),
                          );
                          _message('Player code copied!');
                        },
                        child: _CodeBadge(
                          code: player?.playerCode ?? 'SYNCING...',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _CodeField(
                        controller: _playerCode,
                        label: 'SEARCH PLAYER CODE',
                      ),
                      const SizedBox(height: 10),
                      _PrimaryButton(
                        label: 'FIND PLAYER',
                        icon: Icons.person_search_rounded,
                        busy: _busy,
                        color: GameColors.orangeTextUi,
                        onTap: _findAndAddFriend,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'GAME INVITES (${invites.length})',
                        style: _titleStyle(fontSize: 18),
                      ),
                      if (invites.isEmpty)
                        const Text('Invitations from friends appear here.'),
                      ...invites.map((item) {
                        final invite = Map<String, dynamic>.from(item as Map);
                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.sports_esports_rounded),
                          ),
                          title: Text(
                            invite['display_name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          subtitle: const Text('Invited you to play CO-OP'),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                tooltip: 'Decline game invite',
                                onPressed: _busy
                                    ? null
                                    : () => _respondToInvite(invite, false),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Accept game invite',
                                onPressed: _busy
                                    ? null
                                    : () => _respondToInvite(invite, true),
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'FRIEND REQUESTS (${requests.length})',
                              style: _titleStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Refresh friends',
                            onPressed: _refreshAccountAndFriends,
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                        ],
                      ),
                      if (requests.isEmpty)
                        const Text('No incoming requests yet.'),
                      if (requests.isNotEmpty) ...[
                        ...requests.map((item) {
                          final request = Map<String, dynamic>.from(
                            item as Map,
                          );
                          return ListTile(
                            title: Text(
                              request['display_name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            subtitle: Text(request['player_code'] as String),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  tooltip: 'Decline friend request',
                                  onPressed: () async {
                                    await _repository.respondFriendRequest(
                                      request['request_id'] as String,
                                      false,
                                    );
                                    await _refreshAccountAndFriends();
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Accept friend request',
                                  onPressed: () async {
                                    await _repository.respondFriendRequest(
                                      request['request_id'] as String,
                                      true,
                                    );
                                    await _refreshAccountAndFriends();
                                  },
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 14),
                      Text(
                        'FRIENDS (${friends.length})',
                        style: _titleStyle(fontSize: 18),
                      ),
                      if (friends.isEmpty)
                        const Text('Accepted friends will appear here.'),
                      if (friends.isNotEmpty) ...[
                        ...friends.map((item) {
                          final friend = Map<String, dynamic>.from(item as Map);
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person_rounded),
                            ),
                            title: Text(
                              friend['display_name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            subtitle: Text(friend['player_code'] as String),
                            trailing: ElevatedButton.icon(
                              onPressed: _busy
                                  ? null
                                  : () => _inviteFriend(friend),
                              icon: const Icon(Icons.sports_esports_rounded),
                              label: const Text('INVITE'),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _titleStyle({double fontSize = 23}) => GoogleFonts.luckiestGuy(
  color: GameColors.brownDarkUi,
  fontSize: fontSize,
  letterSpacing: 1.1,
);

class _CartoonCard extends StatelessWidget {
  const _CartoonCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: GameColors.sandLightUi,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: GameColors.brownDarkUi, width: 3.5),
      boxShadow: const [
        BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 6)),
      ],
    ),
    child: child,
  );
}

class _CartoonButton extends StatelessWidget {
  const _CartoonButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: selected ? GameColors.green700 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.brownDarkUi, width: 3),
        boxShadow: const [
          BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: selected ? Colors.white : GameColors.brownDarkUi),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.luckiestGuy(
              color: selected ? Colors.white : GameColors.brownDarkUi,
            ),
          ),
        ],
      ),
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.busy,
    required this.onTap,
    this.color = GameColors.green700,
  });
  final String label;
  final IconData icon;
  final bool busy;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: busy ? null : onTap,
    icon: busy
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 3),
          )
        : Icon(icon),
    label: Text(label, style: GoogleFonts.luckiestGuy(fontSize: 19)),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
      ),
      elevation: 6,
      shadowColor: GameColors.brownDarkUi,
    ),
  );
}

class _CodeField extends StatelessWidget {
  const _CodeField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    textCapitalization: TextCapitalization.characters,
    textAlign: TextAlign.center,
    style: GoogleFonts.luckiestGuy(fontSize: 20, letterSpacing: 3),
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GameColors.brownDarkUi, width: 3),
      ),
    ),
  );
}

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({required this.code});
  final String code;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: GameColors.brownDarkUi, width: 3),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          code,
          style: GoogleFonts.luckiestGuy(
            fontSize: 22,
            letterSpacing: 2,
            color: GameColors.deepPurple,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.copy_rounded, color: GameColors.brownDarkUi),
      ],
    ),
  );
}

class _BubbleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    for (var i = 0; i < 16; i++) {
      canvas.drawCircle(
        Offset((i * 83.0) % size.width, (i * 137.0) % size.height),
        18 + (i % 4) * 8,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
