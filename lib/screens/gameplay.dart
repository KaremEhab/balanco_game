import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:google_fonts/google_fonts.dart';

import '../game/game_area.dart';
import '../data/app_settings.dart';
import '../game/components/game_area/game_painter.dart';

import 'animated_game_overlays.dart';
import 'victory/victory_overlay.dart';
import 'victory/victory_painters.dart';
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
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
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
                  CustomPaint(
                    painter: VictoryCardPainter(),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 36,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PAUSED',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 38,
                              color: const Color(0xFFB5701B), // Dark gold text
                              letterSpacing: 3.0,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Divider line for "Progress"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 3,
                                color: const Color(0xFFD68F2C),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  'PROGRESS',
                                  style: GoogleFonts.luckiestGuy(
                                    fontSize: 20,
                                    color: const Color(0xFFB5701B),
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 3,
                                color: const Color(0xFFD68F2C),
                              ),
                            ],
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

                          // Buttons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Restart Button
                              _buildRoundPauseButton(
                                icon: Icons.refresh_rounded,
                                label: 'RESTART',
                                c1: const Color(0xFF81D4FA),
                                c2: const Color(0xFF039BE5),
                                onTap: () {
                                  Navigator.pop(context); // Close the dialog
                                  widget.game.restartCurrentLevel();
                                },
                              ),

                              // Continue Button (Center & Slightly larger visually)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: _buildRoundPauseButton(
                                  icon: Icons.play_arrow_rounded,
                                  label: 'CONTINUE',
                                  c1: const Color(0xFFFFCA28),
                                  c2: const Color(0xFFFF8F00),
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.game.resumeEngine();
                                  },
                                ),
                              ),

                              // Leave Button
                              _buildRoundPauseButton(
                                icon: Icons.home_rounded,
                                label: 'LOBBY',
                                c1: const Color(0xFFD7CCC8),
                                c2: const Color(0xFF8D6E63),
                                onTap: () {
                                  Navigator.pop(context); // close dialog
                                  Navigator.pop(context); // close game route
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Settings Button
                          _buildRoundPauseButton(
                            icon: Icons.settings_rounded,
                            label: 'SETTINGS',
                            c1: const Color(0xFFBDBDBD),
                            c2: const Color(0xFF757575),
                            onTap: () {
                              _showSettingsMenu();
                            },
                          ),
                        ],
                      ),
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: CustomPaint(
              painter: VictoryCardPainter(),
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 36,
                ),
                child: StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SETTINGS',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 32,
                            color: const Color(0xFFB5701B),
                            letterSpacing: 2.0,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sound Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SOUND FX',
                              style: GoogleFonts.luckiestGuy(
                                fontSize: 20,
                                color: const Color(0xFFB5701B),
                              ),
                            ),
                            Switch(
                              value: AppSettings.soundEnabled.value,
                              activeThumbColor: const Color(0xFFFFCA28),
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
                            Text(
                              'JOYSTICK SENSITIVITY',
                              style: GoogleFonts.luckiestGuy(
                                fontSize: 20,
                                color: const Color(0xFFB5701B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFFFFCA28),
                                inactiveTrackColor: const Color(0xFFD7CCC8),
                                thumbColor: const Color(0xFFFF8F00),
                                overlayColor: const Color(0x33FF8F00),
                                trackHeight: 8.0,
                                valueIndicatorTextStyle:
                                    GoogleFonts.luckiestGuy(
                                      color: Colors.white,
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
                          c1: const Color(0xFF81C784),
                          c2: const Color(0xFF388E3C),
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
    return AnimatedPressButton(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(
              painter: GamifiedButtonPainter(innerColor1: c1, innerColor2: c2),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 36,
                  shadows: const [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.luckiestGuy(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1.2,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  offset: Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // Dynamic Background based on current level
            ValueListenableBuilder<int>(
              valueListenable: widget.game.currentLevel,
              builder: (context, level, child) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ParallaxBackgroundWidget(game: widget.game),
                    ),
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
                          clipBehavior: Clip.none,
                          children: [
                            // Blurry Background (Placed behind GamePainter)
                            Positioned(
                              top: 99, // Extended height by 10px (was 109)
                              bottom: 41, // Extended height by 10px (was 110)
                              left: 6,
                              right: 6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(innerCornerRadius),
                                  topRight: Radius.circular(innerCornerRadius),
                                  bottomLeft: const Radius.circular(41),
                                  bottomRight: const Radius.circular(41),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 3.5,
                                    sigmaY: 3.5,
                                  ),
                                  child: Container(
                                    color: Colors.white.withValues(alpha: 0.2),
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
                                  topLeft: Radius.circular(innerCornerRadius),
                                  topRight: Radius.circular(innerCornerRadius),
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
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Icon(
                                      Icons
                                          .pause_rounded, // Iconly doesn't have a pause icon, using Material rounded
                                      color: Colors.brown,
                                      size: 45,
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
