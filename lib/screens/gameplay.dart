import 'dart:ui';
import 'package:balanco_game/game/components/game_background/mountains_painter.dart';
import 'package:balanco_game/game/components/game_background/sea_painter.dart';
import 'package:balanco_game/game/components/game_background/sky_painter.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

import '../game/game_area.dart';
import '../game/components/game_area/gameplay_card_painter.dart';

import 'package:flutter_svg/flutter_svg.dart';
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
                        ? Icons.star
                        : Icons.star_border,
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
                icon: const Icon(Icons.play_arrow),
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
                icon: const Icon(Icons.refresh),
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
                icon: const Icon(Icons.home),
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
    // --- GAMEPLAY CARD COLORS ---
    // Change these to control the colors of the card frame
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                // Top Header
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: 411,
                      height: 105,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(411, 105),
                            painter: GameplayTopPainter(
                              baseGradient: cardBaseGradient,
                              highlightGradient: cardHighlightGradient,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 30,
                            child: const SvgWithShadow(
                              assetName: 'assets/images/energy.svg',
                              width: 100,
                              height: 80,
                            ),
                          ),
                          const Center(
                            child: SvgWithShadow(
                              assetName: 'assets/images/hearts.svg',
                              width: 150,
                              height: 105,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 30,
                            child: const SvgWithShadow(
                              assetName: 'assets/images/stars.svg',
                              width: 100,
                              height: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Middle Game Area
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF), // 20% white
                          border: Border.all(
                            color: cardBaseGradient.first,
                            width: 4,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
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
                  ),
                ),

                // Bottom Footer
                GestureDetector(
                  onTapUp: (_) => _showPauseMenu(),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.92 *
                        (270.36 / 410.95),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
                        width: 270.36,
                        height: 52,
                        child: CustomPaint(
                          painter: GameplayBottomPainter(
                            baseGradient: cardBaseGradient,
                            highlightGradient: cardHighlightGradient,
                            darkAccentGradient: cardDarkAccentGradient,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Joysticks
                GameControlsOverlay(game: widget.game),
                const SizedBox(height: 16),
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

class ParallaxBackgroundWidget extends StatefulWidget {
  const ParallaxBackgroundWidget({super.key});

  @override
  State<ParallaxBackgroundWidget> createState() =>
      _ParallaxBackgroundWidgetState();
}

class _ParallaxBackgroundWidgetState extends State<ParallaxBackgroundWidget> {
  final ValueNotifier<Offset> _accelNotifier = ValueNotifier<Offset>(
    Offset.zero,
  );
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      if (mounted) {
        // Low-pass filter for smooth motion (increased inertia for smoothness)
        final current = _accelNotifier.value;
        final newX = current.dx * 0.95 + event.x * 0.05;
        final newY = current.dy * 0.95 + event.y * 0.05;
        _accelNotifier.value = Offset(newX, newY);
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _accelNotifier.dispose();
    super.dispose();
  }

  Widget _buildLayer(
    CustomPainter painter,
    double depthMultiplier, {
    double dx = 0,
    double dy = 0,
    double scale = 1.0,
  }) {
    // Gentle parallax effect configuration
    const double maxOffset = 15.0;

    return Positioned.fill(
      child: ValueListenableBuilder<Offset>(
        valueListenable: _accelNotifier,
        builder: (context, accel, child) {
          // Calculate movement based on tilt.
          // accel.dx is positive when tilting right. We want background to move left to simulate depth.
          // accel.dy is positive when tilting up. We want background to move down.
          final double tiltDx =
              (accel.dx.clamp(-10.0, 10.0) / 10.0) *
              maxOffset *
              depthMultiplier;
          final double tiltDy =
              (accel.dy.clamp(-10.0, 10.0) / 10.0) *
              maxOffset *
              depthMultiplier;

          return Transform.translate(
            offset: Offset(dx - tiltDx, dy + tiltDy),
            child: child,
          );
        },
        child: RepaintBoundary(
          child: Transform.scale(
            scale: scale,
            child: CustomPaint(size: const Size(1000, 475), painter: painter),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffCCFFFB), // Base sky color just in case
      child: ClipRect(
        // Ensure drawing doesn't bleed out of bounds
        child: FittedBox(
          fit: BoxFit.cover, // Make sure the 1000x1000 canvas covers the screen
          child: SizedBox(
            width: 1000,
            height: 475,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildLayer(SkyPainter(), 0.05, dx: 0.0, dy: 0.0, scale: 1.00),
                _buildLayer(
                  FirstCloudPainter(),
                  0.1,
                  dx: 193.1,
                  dy: 46.5,
                  scale: 0.39,
                ),
                _buildLayer(
                  SecondCloudPainter(),
                  0.12,
                  dx: -6.1,
                  dy: 7.1,
                  scale: 0.26,
                ),
                _buildLayer(
                  ThirdCloudPainter(),
                  0.14,
                  dx: 59.7,
                  dy: 15.7,
                  scale: 0.46,
                ),
                _buildLayer(
                  ForthCloudPainter(),
                  0.16,
                  dx: 305.0,
                  dy: 27.0,
                  scale: 0.63,
                ),
                _buildLayer(
                  FifthCloudPainter(),
                  0.18,
                  dx: 127.3,
                  dy: -85.9,
                  scale: 0.48,
                ),
                _buildLayer(
                  BirdsPainter(),
                  0.2,
                  dx: 230.1,
                  dy: -11.4,
                  scale: 0.57,
                ),
                _buildLayer(
                  FurtherSeaPainter(),
                  0.4,
                  dx: 4.6,
                  dy: 178.3,
                  scale: 0.79,
                ),
                _buildLayer(
                  MountainSeaShadowsPainter(),
                  0.5,
                  dx: 52.8,
                  dy: 166.4,
                  scale: 0.47,
                ),
                _buildLayer(
                  BackMountainPainter(),
                  0.3,
                  dx: 122.0,
                  dy: 42.6,
                  scale: 0.50,
                ),
                _buildLayer(
                  CloserSeaPainter(),
                  0.6,
                  dx: 166.9,
                  dy: 401.3,
                  scale: 1.42,
                ),
                _buildLayer(
                  SeaWaterDropsPainter(),
                  0.7,
                  dx: 112.6,
                  dy: 246.1,
                  scale: 0.51,
                ),
                _buildLayer(
                  FrontMountainPainter(),
                  0.8,
                  dx: 73.2,
                  dy: 35.3,
                  scale: 0.32,
                ),
                _buildLayer(
                  SeaMountainWaves(),
                  0.45,
                  dx: 7.1,
                  dy: 9.6,
                  scale: 0.27,
                ),
                // _buildLayer(LeftTreePainter(), 1.0),
                // _buildLayer(RightTreePainter(), 1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SvgWithShadow extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final Offset offset;
  final double blurRadius;

  const SvgWithShadow({
    super.key,
    required this.assetName,
    required this.width,
    required this.height,
    this.offset = const Offset(0, 4),
    this.blurRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: offset,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blurRadius,
              sigmaY: blurRadius,
            ),
            child: SvgPicture.asset(
              assetName,
              width: width,
              height: height,
              colorFilter: const ColorFilter.mode(
                Colors.black45,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SvgPicture.asset(assetName, width: width, height: height),
      ],
    );
  }
}
