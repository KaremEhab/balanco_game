import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../game/game_area.dart';
import '../game/components/game_area/game_painter.dart';

import 'animated_game_overlays.dart';
import 'victory/victory_overlay.dart';
import 'game_controls_overlay.dart';

import 'widgets/gameplay_header.dart';
import 'widgets/parallax_background_widget.dart';
import 'overlays/time_stop_overlay.dart';

class GamePlayOverlay extends StatefulWidget {
  final BalancoGame game;

  const GamePlayOverlay({super.key, required this.game});

  @override
  State<GamePlayOverlay> createState() => _GamePlayOverlayState();
}

class _GamePlayOverlayState extends State<GamePlayOverlay> {
  @override
  void initState() {
    super.initState();
  }

  void _showPauseMenu() {
    widget.game.pauseEngine();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'PAUSED',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          color: Colors.white,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Stars Collected',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Icon(
                            index < widget.game.currentPoints.value
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: const Color(0xffF8AE00),
                            size: 42,
                            shadows: const [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 36),

                      // Continue Button
                      _buildPauseButton(
                        icon: Icons.play_arrow_rounded,
                        label: 'Continue',
                        colors: const [Color(0xff6BABFF), Color(0xff2A75D3)],
                        onTap: () {
                          Navigator.pop(context);
                          widget.game.resumeEngine();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Reset Button
                      _buildPauseButton(
                        icon: Icons.refresh_rounded,
                        label: 'Restart Level',
                        colors: const [Color(0xffF8AE00), Color(0xffE88000)],
                        onTap: () {
                          Navigator.pop(context);
                          widget.game.restartCurrentLevel();
                          widget.game.resumeEngine();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Leave Button
                      _buildPauseButton(
                        icon: Icons.home_rounded,
                        label: 'Leave to Lobby',
                        colors: const [Color(0xffFF6B6B), Color(0xffD32A2A)],
                        onTap: () {
                          Navigator.pop(context); // close dialog
                          Navigator.pop(context); // close game route
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Widget _buildPauseButton({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double innerCornerRadius = 50.0;

    // --- GAMEPLAY CARD COLORS ---
    const List<Color> cardBaseGradient = [Color(0xffF8AE00), Color(0xffE88000)];
    const List<Color> cardHighlightGradient = [
      Color.fromARGB(255, 255, 180, 80),
      Color.fromARGB(255, 229, 145, 49),
    ];
    const List<Color> cardDarkAccentGradient = [
      Color(0xff503040),
      Color(0xff301525),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background based on current level
          ValueListenableBuilder<int>(
            valueListenable: widget.game.currentLevel,
            builder: (context, level, child) {
              return Stack(
                children: [
                  Positioned.fill(child: const ParallaxBackgroundWidget()),
                ],
              );
            },
          ),

          // Big centered blurry container
          Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: AspectRatio(
                  aspectRatio: 410 / 850,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 410,
                      height: 870,
                      child: Stack(
                        children: [
                          // Base Frame
                          Positioned.fill(
                            child: CustomPaint(
                              painter: GamePainter(
                                innerCornerRadius: innerCornerRadius,
                              ),
                            ),
                          ),

                          // Top Header (Hearts, Energy, Stars)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 115,
                            child: GameplayHeader(
                              game: widget.game,
                              cardBaseGradient: cardBaseGradient,
                              cardHighlightGradient: cardHighlightGradient,
                            ),
                          ),

                          // Middle Game Area
                          Positioned(
                            top: 109,
                            bottom: 110,
                            left: 6,
                            right: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(innerCornerRadius),
                                topRight: Radius.circular(innerCornerRadius),
                                bottomLeft: const Radius.circular(16),
                                bottomRight: const Radius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  GameWidget(
                                    game: widget.game,
                                    overlayBuilderMap: {
                                      'GameOver': (context, game) =>
                                          AnimatedGameOverOverlay(
                                            game: game as BalancoGame,
                                          ),
                                    },
                                  ),
                                  TimeStopOverlay(
                                    timeNotifier: widget.game.timeStopNotifier,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Joysticks & Controls Overlay
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            height: 150,
                            child: GameControlsOverlay(game: widget.game),
                          ),

                          // Pause Button Overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: _showPauseMenu,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CustomPaint(
                                    size: const Size(28, 24),
                                    painter: PauseBtnPainter(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Fullscreen Victory Overlay
          ValueListenableBuilder<bool>(
            valueListenable: widget.game.showVictoryOverlay,
            builder: (context, showVictory, child) {
              if (showVictory) {
                return AnimatedLevelCompleteOverlay(game: widget.game);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
