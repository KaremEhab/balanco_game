import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/features/game/components/game_area/game_painter.dart';

import 'package:balanco_game/features/game/screens/animated_game_overlays.dart';
import 'package:balanco_game/features/game/screens/victory/victory_overlay.dart';
import 'package:balanco_game/features/game/screens/game_controls_overlay.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';

import 'package:balanco_game/features/game/widgets/gameplay_header.dart';
import 'package:balanco_game/core/widgets/parallax_background_widget.dart';
import 'package:balanco_game/features/game/screens/overlays/time_stop_overlay.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

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

    final currentBiome = widget.game.currentBiome;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      barrierColor: GameColors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: PopScope(
            canPop: false,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Main Card Background
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
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
                              'PAUSED',
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
                              'PAUSED',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.luckiestGuy(
                                fontSize: 38,
                                color: GameColors.white, // White scheme
                                letterSpacing: 3.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        const SizedBox(height: 20),

                        // Game Stats Row
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF3E2723,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(
                                0xFF3E2723,
                              ).withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: GameColors.amber,
                                    size: 28,
                                  ),
                                  Text(
                                    'LVL ${widget.game.currentLevel.value}',
                                    style: GoogleFonts.luckiestGuy(
                                      fontSize: 18,
                                      color:
                                          GameColors.brownDarkUi,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.emoji_events_rounded,
                                    color: GameColors.orange,
                                    size: 28,
                                  ),
                                  Text(
                                    '${widget.game.currentScore.value}',
                                    style: GoogleFonts.luckiestGuy(
                                      fontSize: 18,
                                      color:
                                          currentBiome.nodeUnlockedBorderColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.favorite_rounded,
                                    color: GameColors.redAccent,
                                    size: 28,
                                  ),
                                  Text(
                                    '${widget.game.currentLives.value}',
                                    style: GoogleFonts.luckiestGuy(
                                      fontSize: 18,
                                      color:
                                          currentBiome.nodeUnlockedBorderColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Restart Button
                            _buildRoundPauseButton(
                              icon: Icons.refresh_rounded,
                              label: 'RESTART',
                              c1: GameColors.lightBlue200,
                              c2: GameColors.lightBlue600,
                              onTap: () {
                                Navigator.pop(context); // Close the dialog
                                widget.game.restartCurrentLevel();
                              },
                            ),

                            // Lobby Button
                            _buildRoundPauseButton(
                              icon: Icons.home_rounded,
                              label: 'LOBBY',
                              c1: GameColors.brown100,
                              c2: GameColors.brown400,
                              onTap: () {
                                Navigator.pop(context); // close dialog
                                Navigator.pop(context); // close game route
                              },
                            ),

                            // Settings Button
                            _buildRoundPauseButton(
                              icon: Icons.settings_rounded,
                              label: 'SETTINGS',
                              c1: GameColors.gray400,
                              c2: GameColors.gray600,
                              onTap: () {
                                _showSettingsMenu();
                              },
                            ),

                            // Continue Button
                            _buildRoundPauseButton(
                              icon: Icons.play_arrow_rounded,
                              label: 'CONTINUE',
                              c1: GameColors.amber400,
                              c2: GameColors.amber800,
                              onTap: () {
                                Navigator.pop(context);
                                widget.game.resumeEngine();
                              },
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

  void _showSettingsMenu() {
    final currentBiome = widget.game.currentBiome;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: GameColors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              decoration: BoxDecoration(
                color: currentBiome.nodeUnlockedColor, // Light dynamic color
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: currentBiome.nodeUnlockedBorderColor, // Dark outline
                  width: 3.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentBiome.nodeUnlockedBorderColor,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: StatefulBuilder(
                builder: (context, setDialogState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Text(
                            'SETTINGS',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 32,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 5
                                ..color = GameColors.brownDarkUi,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            'SETTINGS',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 32,
                              color: GameColors.orangeTextUi,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Sound Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Text(
                                'SOUND FX',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 20,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = GameColors.brownDarkUi,
                                ),
                              ),
                              Text(
                                'SOUND FX',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 20,
                                  color: GameColors.orangeTextUi,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: AppSettings.soundEnabled.value,
                            activeThumbColor: GameColors.amber400,
                            onChanged: (val) {
                              setDialogState(() {
                                AppSettings.setSoundEnabled(val);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Sensitivity Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Text(
                                'JOYSTICK SENSITIVITY',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 20,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = GameColors.brownDarkUi,
                                ),
                              ),
                              Text(
                                'JOYSTICK SENSITIVITY',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 20,
                                  color: GameColors.orangeTextUi,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: GameColors.amber400,
                              inactiveTrackColor: GameColors.brown100,
                              thumbColor: GameColors.amber800,
                              overlayColor: GameColors.amber800Alpha20,
                              trackHeight: 8.0,
                              valueIndicatorTextStyle: GoogleFonts.luckiestGuy(
                                color: GameColors.white,
                              ),
                            ),
                            child: Slider(
                              value: AppSettings.joystickSensitivity.value,
                              min: 0.5,
                              max: 2.0,
                              divisions: 15,
                              label: AppSettings.joystickSensitivity.value
                                  .toStringAsFixed(1),
                              onChanged: (val) {
                                setDialogState(() {
                                  AppSettings.setJoystickSensitivity(val);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Close Button
                      _buildRoundPauseButton(
                        icon: Icons.check_rounded,
                        label: 'DONE',
                        c1: GameColors.green300,
                        c2: GameColors.green700,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
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

  Widget _buildRoundPauseButton({
    required IconData icon,
    required String label,
    required Color c1,
    required Color c2,
    required VoidCallback onTap,
  }) {
    double size = 54;
    return AnimatedPressButton(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: c1, // Use the primary color
              shape: BoxShape.circle,
              border: Border.all(color: GameColors.brownDarkUi, width: 3),
              boxShadow: const [
                BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 4)),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: GameColors.white,
                size: size * 0.55,
                shadows: const [
                  Shadow(color: GameColors.brownDarkUi, offset: Offset(0, 2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.luckiestGuy(
              color: GameColors.brownDarkUi, // Dark brown
              fontSize: 13,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double innerCornerRadius = 50.0;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ValueListenableBuilder<int>(
          valueListenable: widget.game.currentLevel,
          builder: (context, level, child) {
            final currentBiome = BiomeConfig.getBiomeForLevel(level);
            return Stack(
              children: [
                // Dynamic Background based on current level
                Stack(
                  children: [
                    Positioned.fill(
                      child: ParallaxBackgroundWidget(game: widget.game),
                    ),
                  ],
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
                          clipBehavior: Clip.none,
                          child: SizedBox(
                            width: 410,
                            height: 870,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Blurry Background (Placed behind GamePainter)
                                Positioned(
                                  top: 99,
                                  bottom: 41,
                                  left: 6,
                                  right: 6,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        innerCornerRadius,
                                      ),
                                      topRight: Radius.circular(
                                        innerCornerRadius,
                                      ),
                                      bottomLeft: const Radius.circular(41),
                                      bottomRight: const Radius.circular(41),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 3.5,
                                        sigmaY: 3.5,
                                      ),
                                      child: Container(
                                        color: GameColors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Base Frame
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: CustomPaint(
                                      painter: GamePainter(
                                        innerCornerRadius: innerCornerRadius,
                                        biome: currentBiome,
                                      ),
                                    ),
                                  ),
                                ),

                                // Middle Game Area
                                Positioned(
                                  top: 124,
                                  bottom: 110,
                                  left: 6,
                                  right: 6,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        innerCornerRadius,
                                      ),
                                      topRight: Radius.circular(
                                        innerCornerRadius,
                                      ),
                                      bottomLeft: const Radius.circular(16),
                                      bottomRight: const Radius.circular(16),
                                    ),
                                    child: Stack(
                                      children: [
                                        GameWidget(game: widget.game),
                                        TimeStopOverlay(
                                          timeNotifier:
                                              widget.game.timeStopNotifier,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Fullscreen Darkness Overlay
                                Positioned(
                                  top: -4000,
                                  bottom: -4000,
                                  left: -4000,
                                  right: -4000,
                                  child: FullScreenDarknessOverlay(
                                    game: widget.game,
                                  ),
                                ),

                                // TOP HEADER (Hearts, Score, etc.)
                                Positioned(
                                  top: 24, // Push down slightly
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: GameplayHeader(
                                      game: widget.game,
                                      cardBaseGradient: [
                                        currentBiome.primaryColor,
                                        currentBiome.primaryColor,
                                      ],
                                      cardHighlightGradient: [
                                        currentBiome.nodeUnlockedColor,
                                        currentBiome.nodeUnlockedColor,
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
                                  bottom: -15,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: AnimatedPressButton(
                                      onTap: _showPauseMenu,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: currentBiome
                                                .nodeUnlockedColor, // Bright contrasting base
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: currentBiome
                                                  .primaryColor, // Dark outline
                                              width: 3.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: currentBiome
                                                    .nodeUnlockedBorderColor,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.pause_rounded,
                                            color: GameColors
                                                .white, // Dark contrasting icon
                                            size: 30,
                                          ),
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

                // Fullscreen Game Over Overlay
                ValueListenableBuilder<bool>(
                  valueListenable: widget.game.showGameOverOverlay,
                  builder: (context, showGameOver, child) {
                    if (showGameOver) {
                      return AnimatedGameOverOverlay(game: widget.game);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedPressButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedPressButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

class FullScreenDarknessOverlay extends StatelessWidget {
  final BalancoGame game;
  const FullScreenDarknessOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ValueListenableBuilder<double>(
        valueListenable: game.darknessOpacityNotifier,
        builder: (context, opacity, child) {
          if (opacity <= 0.0) return const SizedBox.shrink();
          return ValueListenableBuilder<List<Offset>>(
            valueListenable: game.lightSpotNotifier,
            builder: (context, spots, child) {
              if (spots.isEmpty) return const SizedBox.shrink();

              // Map from Flame coordinates to FittedBox coordinates
              // The Flame game has left padding of 6, right 6, top 124.
              // The Positioned expands by 4000 in all directions.
              final mappedSpots = spots
                  .map((s) => Offset(s.dx + 6 + 4000, s.dy + 124 + 4000))
                  .toList();

              return ValueListenableBuilder<double>(
                valueListenable: game.lightRadiusNotifier,
                builder: (context, radius, child) {
                  return CustomPaint(
                    painter: DarknessPainter(
                      opacity: opacity,
                      spots: mappedSpots,
                      radius: radius,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class DarknessPainter extends CustomPainter {
  final double opacity;
  final List<Offset> spots;
  final double radius;
  DarknessPainter({
    required this.opacity,
    required this.spots,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final bgPaint = Paint()
      ..color = GameColors.darknessOverlayBg.withValues(alpha: opacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (final spot in spots) {
      final holePaint = Paint()
        ..blendMode = BlendMode.dstOut
        ..shader = RadialGradient(
          colors: [
            GameColors.black,
            GameColors.black,
            GameColors.black.withValues(alpha: 0.6),
            GameColors.black.withValues(alpha: 0.2),
            Colors.transparent,
          ],
          stops: const [0.0, 0.25, 0.45, 0.75, 1.0],
        ).createShader(Rect.fromCircle(center: spot, radius: radius));

      canvas.drawCircle(spot, radius, holePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(DarknessPainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.spots != spots ||
        oldDelegate.radius != radius;
  }
}
