import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:uuid/uuid.dart';
import 'package:balanco_game/core/data/database_helper.dart';

class AnimatedGameOverOverlay extends StatefulWidget {
  final BalancoGame game;
  const AnimatedGameOverOverlay({super.key, required this.game});

  @override
  State<AnimatedGameOverOverlay> createState() =>
      _AnimatedGameOverOverlayState();
}

class _AnimatedGameOverOverlayState extends State<AnimatedGameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late final Future<void> _saveLoss;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _saveLoss = PlayerSession.instance.recordGameOver(
      attemptId: const Uuid().v4(),
      levelId: widget.game.currentLevel.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _restartLevel() async {
    await _saveLoss;
    if (!mounted) return;
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    if (profile.sparks <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your sparks are empty. Come back after the daily refill!',
          ),
        ),
      );
      widget.game.showGameOverOverlay.value = false;
      Navigator.pop(context);
      return;
    }
    _controller.reverse().then((_) {
      widget.game.showGameOverOverlay.value = false;
      widget.game.restartCurrentLevel();
    });
  }

  void _returnToLobby() async {
    await _saveLoss;
    if (!mounted) return;
    widget.game.showGameOverOverlay.value = false;
    Navigator.pop(context); // Close GamePlayOverlay
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: GameColors.black.withValues(alpha: 0.5),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 340,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: GameColors.sandLightUi, // Light sand color
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: GameColors.brownDarkUi, // Dark brown outline
                      width: 3.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: GameColors.brownDarkUi,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Text(
                            'GAME OVER!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 38,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 5
                                ..color = GameColors.brownDarkUi,
                              letterSpacing: 3.0,
                            ),
                          ),
                          Text(
                            'GAME OVER!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 38,
                              color: GameColors.orangeTextUi,
                              letterSpacing: 3.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (widget.game.isInfinityMode) ...[
                        Text(
                          'Score: ${widget.game.lastInfinityScore}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            color: GameColors.brownDarkUi,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'High Score: ${widget.game.infinityHighScore}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            color: GameColors.orangeTextUi,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Coins: ${widget.game.lastInfinityCoins}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            color: GameColors.amber400,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'You lost all your lives\nor time ran out!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            color: GameColors.brownDarkUi,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _returnToLobby,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: GameColors.red300, // Red
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: GameColors.brownDarkUi,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: GameColors.brownDarkUi,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'LEAVE',
                                style: GoogleFonts.luckiestGuy(
                                  color: GameColors.white,
                                  fontSize: 20,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      color: GameColors.brownDarkUi,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _restartLevel,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: GameColors.green300, // Green
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: GameColors.brownDarkUi,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: GameColors.brownDarkUi,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'RESTART',
                                style: GoogleFonts.luckiestGuy(
                                  color: GameColors.white,
                                  fontSize: 20,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      color: GameColors.brownDarkUi,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
