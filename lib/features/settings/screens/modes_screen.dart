import 'package:balanco_game/core/data/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/coop/presentation/coop_setup_screen.dart';
import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:balanco_game/features/race/presentation/race_setup_screen.dart';
import 'package:balanco_game/features/social/screens/friends_list_screen.dart';
import 'package:balanco_game/features/social/widgets/game_invite_flow.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';

class ModesScreen extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback? onReturnFromGame;

  const ModesScreen({
    super.key,
    required this.scrollController,
    this.onReturnFromGame,
  });

  @override
  State<ModesScreen> createState() => _ModesScreenState();
}

class _ModesScreenState extends State<ModesScreen> {
  int _infinityHighScore = 0;
  final _friendCode = TextEditingController();
  Map<String, dynamic> _social = const {'friends': [], 'recent_players': []};
  String? _invitingPlayerCode;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  @override
  void dispose() {
    _friendCode.dispose();
    super.dispose();
  }

  Future<void> _loadHighScore() async {
    try {
      final profile = await DatabaseHelper.instance.getPlayerProfile();
      if (mounted) {
        setState(() {
          _infinityHighScore = profile.infinityHighScore;
        });
      }
      if (PlayerSession.instance.isAuthenticated) {
        final social = await CoopRepository(
          Supabase.instance.client,
        ).listFriends();
        if (mounted) setState(() => _social = social);
      }
    } catch (e) {
      debugPrint("Error loading high score: $e");
    }
  }

  Future<void> _searchFriend() async {
    final code = _friendCode.text.trim().toUpperCase();
    if (code.length < 5) return;
    try {
      final repository = CoopRepository(Supabase.instance.client);
      final player = await repository.findPlayer(code);
      if (!mounted) return;
      if (player == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No player found with that code.')),
        );
        return;
      }
      await repository.sendFriendRequest(code);
      _friendCode.clear();
      await _loadHighScore();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend request sent to ${player.displayName}!'),
          ),
        );
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _inviteRecentPlayer(Map<String, dynamic> player) async {
    if (_invitingPlayerCode != null) return;
    final playerCode = player['player_code']?.toString() ?? '';
    if (playerCode.isEmpty) {
      _message('This player does not have a valid player code yet.');
      return;
    }

    setState(() => _invitingPlayerCode = playerCode);
    try {
      final repository = CoopRepository(Supabase.instance.client);
      final room = await showFriendGameInviteFlow(
        context: context,
        repository: repository,
        firstFriend: player,
      );
      if (room == null || !mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
        ),
      );
      await _loadHighScore();
    } on PostgrestException catch (error) {
      _message(error.message);
    } catch (error) {
      _message('Could not open the game invitation. Please try again.');
      debugPrint('Recent player invite failed: $error');
    } finally {
      if (mounted) setState(() => _invitingPlayerCode = null);
    }
  }

  Widget _buildSocialDiscovery() {
    final recent = (_social['recent_players'] as List? ?? const []).take(5);
    return _buildCartoonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_alt_rounded,
                color: GameColors.deepPurple,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'FRIENDS',
                  style: GoogleFonts.luckiestGuy(
                    color: GameColors.brownDarkUi,
                    fontSize: 22,
                  ),
                ),
              ),
              IconButton.filled(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const FriendsListScreen(),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _friendCode,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'SEARCH BY PLAYER CODE',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: _searchFriend,
                icon: const Icon(Icons.person_add_alt_1_rounded),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.72),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          if (recent.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'PLAYED WITH RECENTLY',
              style: GoogleFonts.luckiestGuy(
                color: GameColors.orangeTextUi,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              height: 116,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recent.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  final player = Map<String, dynamic>.from(
                    recent.elementAt(index) as Map,
                  );
                  final playerCode = player['player_code']?.toString() ?? '';
                  return _RecentPlayerInviteCard(
                    player: player,
                    loading: _invitingPlayerCode == playerCode,
                    enabled: _invitingPlayerCode == null,
                    onTap: () => _inviteRecentPlayer(player),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartoonCard({required Widget child, bool disabled = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: disabled
            ? GameColors.modesScreenColor3
            : GameColors.sandLightUi, // Light sand color
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: GameColors.brownDarkUi, // Dark brown outline
          width: 3.5,
        ),
        boxShadow: [
          if (!disabled)
            const BoxShadow(
              color: GameColors.brownDarkUi,
              offset: Offset(0, 6),
            ),
        ],
      ),
      child: Opacity(opacity: disabled ? 0.6 : 1.0, child: child),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
      child: Stack(
        children: [
          Text(
            title,
            style: GoogleFonts.luckiestGuy(
              fontSize: 24,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = GameColors.brownDarkUi,
              letterSpacing: 2,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.luckiestGuy(
              color: GameColors.orangeTextUi, // Vibrant orange/sand
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedModeRow({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    bool locked = true,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GameColors.brownDarkUi, width: 2.5),
            boxShadow: const [
              BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 3)),
            ],
          ),
          child: Icon(icon, size: 32, color: GameColors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.luckiestGuy(
                  color: GameColors.brownDarkUi,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: GameColors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Icon(
          locked ? Icons.lock : Icons.play_circle_fill_rounded,
          size: 32,
          color: GameColors.brownDarkUi,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: MediaQuery.of(context).padding.top + 170.0,
        bottom: 120.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (PlayerSession.instance.isAuthenticated)
            _buildSocialDiscovery()
          else
            _buildCartoonCard(
              child: const Text(
                'Log in to search friends, invite players, and see recent racers.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),

          const SizedBox(height: 32),

          _buildSectionHeader('BALANCE MODES'),

          _buildCartoonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: GameColors.deepPurple,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: GameColors.brownDarkUi,
                          width: 2.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: GameColors.brownDarkUi,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.all_inclusive_rounded,
                        size: 40,
                        color: GameColors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INFINITY BALANCE',
                            style: GoogleFonts.luckiestGuy(
                              color: GameColors.brownDarkUi,
                              fontSize: 22,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'HIGH SCORE: $_infinityHighScore',
                            style: GoogleFonts.luckiestGuy(
                              color: GameColors.orangeTextUi,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 16),
                // const Text(
                //   'Endless levels, shifting colors, and bigger score climbs. How far can you go?',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: GameColors.brownDarkUi,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w800,
                //   ),
                // ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final game = BalancoGame(
                      isMultiplayer: context
                          .read<AppBloc>()
                          .state
                          .isMultiplayer,
                      isInfinityMode: true,
                      enableTutorials: false,
                      playerRole: context.read<AppBloc>().state.playerRole,
                      onLevelComplete: () {
                        Navigator.pop(context);
                        _loadHighScore(); // Refresh score after returning
                      },
                    );
                    AppSettings.stopBgm();
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => GamePlayOverlay(game: game),
                          ),
                        )
                        .then((_) {
                          _loadHighScore();
                          widget.onReturnFromGame?.call();
                        });
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 32,
                    color: GameColors.white,
                  ),
                  label: Text(
                    'PLAY INFINITY',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 24,
                      letterSpacing: 1.5,
                      color: GameColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GameColors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: GameColors.brownDarkUi,
                        width: 3.5,
                      ),
                    ),
                    elevation: 6,
                    shadowColor: GameColors.brownDarkUi,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              if (!PlayerSession.instance.isAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Log in with an online account to play CO-OP.',
                    ),
                  ),
                );
                return;
              }
              context.read<AppBloc>()
                ..add(const ToggleMultiplayer(true))
                ..add(const ChangePlayerRole('LEFT'));
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CoopSetupScreen(),
                ),
              );
            },
            child: _buildCartoonCard(
              child: _buildLockedModeRow(
                icon: Icons.handshake_rounded,
                iconBgColor: GameColors.modesScreenColor2,
                title: 'ONLINE CO-OP',
                subtitle: 'Two players · one shared balance challenge',
                locked: false,
              ),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              if (!PlayerSession.instance.isAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Log in to challenge a friend online.'),
                  ),
                );
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const RaceSetupScreen(),
                ),
              );
            },
            child: _buildCartoonCard(
              child: _buildLockedModeRow(
                icon: Icons.sports_score_rounded,
                iconBgColor: GameColors.deepPurple,
                title: 'ONLINE RACE',
                subtitle: 'Live Balance challenge • First to finish wins',
                locked: false,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildCartoonCard(
            disabled: true,
            child: _buildLockedModeRow(
              icon: Icons.timer,
              iconBgColor: GameColors.redAccent,
              title: 'TIME TRIALS',
              subtitle: 'Beat the clock. Coming soon.',
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPlayerInviteCard extends StatelessWidget {
  const _RecentPlayerInviteCard({
    required this.player,
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  final Map<String, dynamic> player;
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  String get _displayName =>
      player['display_name']?.toString().trim().isNotEmpty == true
      ? player['display_name'].toString().trim()
      : 'Balanco Player';

  String get _playerCode => player['player_code']?.toString() ?? '';

  String get _avatarUrl {
    final saved = player['avatar_url']?.toString().trim();
    if (saved != null && saved.isNotEmpty) return saved;
    final seed = Uri.encodeQueryComponent(
      _playerCode.isNotEmpty ? _playerCode : _displayName,
    );
    return 'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=$seed'
        '&backgroundColor=transparent';
  }

  AvatarShape get _avatarShape => AvatarShape.values.firstWhere(
    (shape) => shape.name == player['avatar_shape']?.toString(),
    orElse: () => AvatarShape.circle,
  );

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Invite $_displayName to play',
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled || loading ? 1 : 0.62,
      child: Container(
        width: 208,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFFFF), Color(0xFFFFE9C4)],
          ),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: GameColors.brownDarkUi, width: 2.4),
          boxShadow: const [
            BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 10, 9),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ProfileAvatarWidget(
                        shape: _avatarShape,
                        size: 54,
                        imageUrl: _avatarUrl,
                      ),
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: GameColors.deepPurple,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.luckiestGuy(
                            color: GameColors.brownDarkUi,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _playerCode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: GameColors.gray700,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            if (loading)
                              const SizedBox.square(
                                dimension: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: GameColors.deepPurple,
                                ),
                              )
                            else
                              const Icon(
                                Icons.sports_esports_rounded,
                                size: 16,
                                color: GameColors.deepPurple,
                              ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                loading ? 'OPENING...' : 'PLAY TOGETHER',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.luckiestGuy(
                                  color: GameColors.deepPurple,
                                  fontSize: 10,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: GameColors.deepPurple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
