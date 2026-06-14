import 'dart:ui';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:iconly/iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/game_area.dart';
import 'animated_game_overlays.dart';
import 'game_controls_overlay.dart';


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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'PAUSED',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Stars Collected:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < widget.game.currentPoints.value
                        ? IconlyBold.star
                        : IconlyLight.star,
                    color: Colors.amber,
                    size: 36,
                  );
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 48),
                ),
                icon: const Icon(IconlyBold.play),
                label: const Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  widget.game.resumeEngine();
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 48),
                ),
                icon: const Icon(IconlyBold.danger),
                label: const Text('Reset Level'),
                onPressed: () {
                  Navigator.pop(context);
                  widget.game.restartCurrentLevel();
                  widget.game.resumeEngine();
                },
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(200, 48),
                ),
                icon: const Icon(IconlyBold.home),
                label: const Text('Leave to Lobby'),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close game route
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background based on current level
          ValueListenableBuilder<int>(
            valueListenable: widget.game.currentLevel,
            builder: (context, level, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF005973), // Deep Teal at top
                            Color(0xFF33E6CC), // Aquamarine at bottom
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Big centered blurry container
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.currentLevel,
                  builder: (context, level, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      child: Text(
                        'Level $level',
                        key: ValueKey<int>(level),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                          shadows: isDark
                              ? const [
                                  Shadow(color: Colors.black45, blurRadius: 4),
                                ]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.currentLives,
                  builder: (context, lives, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(lives > 3 ? lives : 3, (index) {
                        bool hasLife = index < lives;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                          child: Icon(
                            hasLife ? IconlyBold.heart : IconlyLight.heart,
                            key: ValueKey<bool>(hasLife),
                            color: hasLife
                                ? Colors.redAccent
                                : Colors.redAccent.withValues(alpha: 0.5),
                            size: 28,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<int>(
                  valueListenable: widget.game.currentPoints,
                  builder: (context, stars, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        bool hasStar = index < stars;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return RotationTransition(
                                  turns: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.elasticOut,
                                        ),
                                      ),
                                  child: ScaleTransition(
                                    scale: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.elasticOut,
                                    ),
                                    child: child,
                                  ),
                                );
                              },
                          child: Icon(
                            hasStar ? IconlyBold.star : IconlyLight.star,
                            key: ValueKey<bool>(hasStar),
                            color: Colors.amber,
                            size: 24,
                            shadows: hasStar
                                ? [
                                    const Shadow(
                                      color: Colors.black45,
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      height: MediaQuery.of(context).size.height * 0.62,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.3),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isDark
                            ? [
                                BoxShadow(
                                  color: Colors.cyanAccent.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 20,
                                ),
                              ]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
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
                  ),
                ),
                const SizedBox(height: 24),
                GameControlsOverlay(
                  game: widget.game,
                  onPausePressed: _showPauseMenu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeStopOverlay extends StatefulWidget {
  final ValueNotifier<double> timeNotifier;
  const TimeStopOverlay({super.key, required this.timeNotifier});

  @override
  State<TimeStopOverlay> createState() => _TimeStopOverlayState();
}

class _TimeStopOverlayState extends State<TimeStopOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  dynamic _heartbeatPlayer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward && widget.timeNotifier.value > 0) {
        HapticFeedback.heavyImpact();
      }
    });

    _pulseAnimation = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.timeNotifier.addListener(_onTimeChanged);
  }

  void _onTimeChanged() async {
    if (widget.timeNotifier.value > 0) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
        try {
          _heartbeatPlayer?.stop();
          _heartbeatPlayer = await FlameAudio.play('heartbeat.mp3');
        } catch (_) {}
      }
    } else {
      if (_controller.isAnimating) {
        _controller.stop();
        _controller.value = 0.0;
        try {
          _heartbeatPlayer?.stop();
          _heartbeatPlayer = null;
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    widget.timeNotifier.removeListener(_onTimeChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.timeNotifier,
      builder: (context, timeRemaining, child) {
        if (timeRemaining <= 0) return const SizedBox.shrink();

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: const SizedBox.expand(),
            ),

            // Pulsating Red Vignette
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        Colors.red.withValues(alpha: _pulseAnimation.value),
                        Colors.redAccent.shade700.withValues(
                          alpha: _pulseAnimation.value + 0.3,
                        ),
                      ],
                      stops: const [0.4, 0.8, 1.0],
                      radius: 1.2,
                    ),
                  ),
                );
              },
            ),

            // Countdown Timer
            Text(
              timeRemaining.toStringAsFixed(1),
              style: GoogleFonts.rubikBurned(
                fontSize: 120,
                color: Colors.redAccent.shade100,
                shadows: [
                  Shadow(color: Colors.red.shade900, blurRadius: 20),
                  const Shadow(color: Colors.black, blurRadius: 10),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
