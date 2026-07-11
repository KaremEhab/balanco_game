import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/data/database_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    try {
      final profile = await DatabaseHelper.instance.getPlayerProfile();
      if (mounted) {
        setState(() {
          _infinityHighScore = profile.infinityHighScore;
        });
      }
    } catch (e) {
      debugPrint("Error loading high score: $e");
    }
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

  Widget _buildModeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : GameColors.gray300,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GameColors.brownDarkUi, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: GameColors.brownDarkUi,
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? GameColors.white : GameColors.brownDarkUi,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.luckiestGuy(
                  color: isSelected ? GameColors.white : GameColors.brownDarkUi,
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnchorButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? GameColors.orangeTextUi : GameColors.gray300,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GameColors.brownDarkUi, width: 3),
            boxShadow: [
              BoxShadow(
                color: GameColors.brownDarkUi,
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.luckiestGuy(
                color: isSelected ? GameColors.white : GameColors.brownDarkUi,
                fontSize: 18,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedModeRow({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
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
        const Icon(Icons.lock, size: 32, color: GameColors.brownDarkUi),
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
          BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              final isMultiplayer = state.isMultiplayer;
              final role = state.playerRole;
              return _buildCartoonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _buildModeButton(
                          label: 'SOLO',
                          icon: Icons.person,
                          isSelected: !isMultiplayer,
                          activeColor:
                              GameColors.modesScreenColor1, // Light Blue
                          onTap: () {
                            context.read<AppBloc>().add(
                              const ToggleMultiplayer(false),
                            );
                            context.read<AppBloc>().add(
                              const ChangePlayerRole('BOTH'),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildModeButton(
                          label: 'CO-OP',
                          icon: Icons.people,
                          isSelected: isMultiplayer,
                          activeColor: GameColors.modesScreenColor2, // Green
                          onTap: () {
                            context.read<AppBloc>().add(
                              const ToggleMultiplayer(true),
                            );
                            context.read<AppBloc>().add(
                              const ChangePlayerRole('LEFT'),
                            );
                          },
                        ),
                      ],
                    ),

                    // Role Selection (Animated Size)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: isMultiplayer
                          ? Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHOOSE ANCHOR:',
                                    style: GoogleFonts.luckiestGuy(
                                      color: GameColors.brownDarkUi,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildAnchorButton(
                                        label: 'LEFT',
                                        isSelected: role == 'LEFT',
                                        onTap: () =>
                                            context.read<AppBloc>().add(
                                              const ChangePlayerRole('LEFT'),
                                            ),
                                      ),
                                      const SizedBox(width: 16),
                                      _buildAnchorButton(
                                        label: 'RIGHT',
                                        isSelected: role == 'RIGHT',
                                        onTap: () =>
                                            context.read<AppBloc>().add(
                                              const ChangePlayerRole('RIGHT'),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
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
                      playerRole: context.read<AppBloc>().state.playerRole,
                      onLevelComplete: () {
                        Navigator.pop(context);
                        _loadHighScore(); // Refresh score after returning
                      },
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GamePlayOverlay(game: game),
                      ),
                    ).then((_) {
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

          _buildCartoonCard(
            disabled: true,
            child: _buildLockedModeRow(
              icon: Icons.sports_esports,
              iconBgColor: GameColors.deepPurple,
              title: 'ONLINE MATCH',
              subtitle: 'Unlocks in v2.0 update',
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
