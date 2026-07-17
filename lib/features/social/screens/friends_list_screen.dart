import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/player/application/player_session.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  late final CoopRepository _repository;
  final _playerCode = TextEditingController();
  bool _busy = false;
  Map<String, dynamic> _social = {
    'profile': null,
    'friends': [],
    'friend_requests': [],
  };

  @override
  void initState() {
    super.initState();
    _repository = CoopRepository(Supabase.instance.client);
    _refreshAccountAndFriends();
  }

  @override
  void dispose() {
    _playerCode.dispose();
    super.dispose();
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _refreshAccountAndFriends() async {
    setState(() => _busy = true);
    try {
      await PlayerSession.instance.refresh();
      _social = await _repository.listFriends();
    } on PostgrestException catch (error) {
      if (!mounted) return;
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _findAndAddFriend() async {
    final code = _playerCode.text.trim().toUpperCase();
    if (code.isEmpty || code.length < 5) {
      _message('Please enter a valid player code.');
      return;
    }
    setState(() => _busy = true);
    try {
      final player = await _repository.findPlayer(code);
      if (!mounted) return;
      if (player == null) {
        _message('No player was found with that code.');
        return;
      }

      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: GameColors.sandLightUi,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
          ),
          title: Text(
            'Add Friend',
            style: GoogleFonts.luckiestGuy(color: GameColors.brownDarkUi),
          ),
          content: Text(
            'Send friend request to ${player.displayName}?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: GameColors.blueAccent,
              ),
              child: const Text('SEND'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() => _busy = true);
        try {
          await _repository.sendFriendRequest(player.playerCode);
          _message('Friend request sent!');
          _playerCode.clear();
        } on PostgrestException catch (error) {
          _message(error.message);
        }
      }
    } on PostgrestException catch (error) {
      _message(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final friends = _social['friends'] as List? ?? const [];
    final requests = _social['friend_requests'] as List? ?? const [];
    final profile = _social['profile'] as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: GameColors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: GameColors.white,
        elevation: 0,
        title: Text('FRIENDS', style: GoogleFonts.luckiestGuy(fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _busy ? null : _refreshAccountAndFriends,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _busy && profile == null
          ? const Center(child: CircularProgressIndicator(color: GameColors.white))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (profile != null) ...[
                  Text(
                    'MY PLAYER CODE',
                    style: GoogleFonts.luckiestGuy(
                      color: GameColors.white,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: GameColors.sandLightUi,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GameColors.brownDarkUi, width: 3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          profile['player_code'] as String,
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 28,
                            letterSpacing: 4,
                            color: GameColors.brownDarkUi,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: GameColors.brownDarkUi),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: profile['player_code'] as String));
                            _message('Copied to clipboard');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                Text(
                  'ADD FRIEND',
                  style: GoogleFonts.luckiestGuy(
                    color: GameColors.white,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _playerCode,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'ENTER PLAYER CODE',
                          filled: true,
                          fillColor: GameColors.sandLightUi,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: GameColors.brownDarkUi, width: 3),
                          ),
                        ),
                        style: GoogleFonts.luckiestGuy(letterSpacing: 2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _busy ? null : _findAndAddFriend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GameColors.blueAccent,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
                        ),
                      ),
                      child: const Icon(Icons.person_add_rounded, color: GameColors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                if (requests.isNotEmpty) ...[
                  Text(
                    'REQUESTS (${requests.length})',
                    style: GoogleFonts.luckiestGuy(color: GameColors.orangeTextUi, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ...requests.map((req) {
                    final isIncoming = req['receiver_id'] == profile?['id'];
                    final other = isIncoming ? req['sender'] : req['receiver'];
                    return Card(
                      color: GameColors.sandLightUi,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: GameColors.brownDarkUi, width: 2),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: GameColors.brownDarkUi,
                          child: Text(
                            (other['display_name'] as String)[0].toUpperCase(),
                            style: GoogleFonts.luckiestGuy(color: GameColors.white),
                          ),
                        ),
                        title: Text(
                          other['display_name'] as String,
                          style: GoogleFonts.luckiestGuy(color: GameColors.brownDarkUi),
                        ),
                        subtitle: Text(
                          isIncoming ? 'Wants to be friends' : 'Request sent',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: isIncoming
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, color: GameColors.redAccent),
                                    onPressed: () async {
                                      await _repository.respondFriendRequest(req['id'] as String, false);
                                      _refreshAccountAndFriends();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.check_rounded, color: GameColors.modesScreenColor2),
                                    onPressed: () async {
                                      await _repository.respondFriendRequest(req['id'] as String, true);
                                      _refreshAccountAndFriends();
                                    },
                                  ),
                                ],
                              )
                            : const Icon(Icons.access_time_rounded),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                ],

                Text(
                  'MY FRIENDS (${friends.length})',
                  style: GoogleFonts.luckiestGuy(color: GameColors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                if (friends.isEmpty)
                  const Text('Accepted friends will appear here.', style: TextStyle(color: GameColors.white)),
                ...friends.map((friend) {
                  return Card(
                    color: GameColors.sandLightUi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: GameColors.brownDarkUi, width: 2),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: GameColors.modesScreenColor1,
                        child: Text(
                          (friend['display_name'] as String)[0].toUpperCase(),
                          style: GoogleFonts.luckiestGuy(color: GameColors.white),
                        ),
                      ),
                      title: Text(
                        friend['display_name'] as String,
                        style: GoogleFonts.luckiestGuy(color: GameColors.brownDarkUi, fontSize: 18),
                      ),
                      subtitle: Text(
                        friend['player_code'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
