import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:balanco_game/features/map/backgrounds/beach/mountains_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sea_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sky_painter.dart';
import 'package:balanco_game/features/game/components/game_background/biome_background_transition.dart';
import 'package:balanco_game/features/game/components/game_background/pyramids_painter.dart';
import 'package:balanco_game/features/game/components/game_background/level_group_painters.dart';

import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';

class ParallaxBackgroundWidget extends StatefulWidget {
  final BalancoGame game;
  const ParallaxBackgroundWidget({super.key, required this.game});

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
    bool isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    if (!isDesktop) {
      try {
        _accelerometerSubscription = accelerometerEventStream().listen(
          (AccelerometerEvent event) {
            if (mounted) {
              // Low-pass filter for smooth motion (increased inertia for smoothness)
              final current = _accelNotifier.value;
              final newX = current.dx * 0.95 + event.x * 0.05;
              final newY = current.dy * 0.95 + event.y * 0.05;
              _accelNotifier.value = Offset(newX, newY);
            }
          },
          onError: (e) {
            // Ignore sensor errors gracefully
          },
        );
      } catch (e) {
        // Ignore initialization errors
      }
    }
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
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _accelNotifier,
          widget.game.cameraOffsetYNotifier,
        ]),
        builder: (context, child) {
          final bool isParallax = AppSettings.parallaxEnabled.value;
          final accel = _accelNotifier.value;
          final cameraOffsetY = widget.game.cameraOffsetYNotifier.value;

          // Calculate max level scroll to normalize background scroll
          double maxCameraY = 1.0;
          if (widget.game.hasLayout) {
            maxCameraY = widget.game.levelHeight - widget.game.size.y;
            if (maxCameraY <= 0) maxCameraY = 1.0;
          }

          // Background scrolls upwards smoothly as camera moves downwards
          double backgroundVerticalScroll = isParallax
              ? (cameraOffsetY / maxCameraY) * 200.0 * depthMultiplier
              : 0.0;
          // Calculate movement based on tilt.
          // accel.dx is positive when tilting right. We want background to move left to simulate depth.
          // accel.dy is positive when tilting up. We want background to move down.
          final double tiltDx = isParallax
              ? (accel.dx.clamp(-10.0, 10.0) / 10.0) *
                    maxOffset *
                    depthMultiplier
              : 0.0;
          final double tiltDy = isParallax
              ? (accel.dy.clamp(-10.0, 10.0) / 10.0) *
                    maxOffset *
                    depthMultiplier
              : 0.0;

          return Transform.translate(
            offset: Offset(dx - tiltDx, dy + tiltDy - backgroundVerticalScroll),
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
      color: GameColors.mapAppBarCyanLightest,
      child: ValueListenableBuilder<int>(
        valueListenable: widget.game.currentLevel,
        builder: (context, level, child) {
          final sceneIndex = BiomeConfig.getBiomeIndexForLevel(level);
          final double targetProgress = sceneIndex == 0 ? 0.0 : 1.0;
          final currentBiome = widget.game.currentBiome;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: targetProgress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutCubic,
            builder: (context, progress, child) {
              final Widget tropicalScene = SizedBox(
                width: 1000,
                height: 475,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildLayer(
                      SkyPainter(),
                      0.05,
                      dx: 0.0,
                      dy: 0.0,
                      scale: 1.00,
                    ),
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
                      dx: 0.0,
                      dy: 214.0,
                      scale: 1.05,
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
                  ],
                ),
              );

              final Widget pyramidScene = SizedBox(
                width: 1000,
                height: 475,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildLayer(PyramidSkyPainter(), 0.0),
                    _buildLayer(WispyCloudPainter(), 0.1),
                    _buildLayer(DistantMountainsPainter(), 0.2),
                    _buildLayer(MainPyramidsPainter(), 0.4),
                    _buildLayer(MidgroundDunesPainter(), 0.7),
                    _buildLayer(ForegroundDunesPainter(), 1.0),
                  ],
                ),
              );

              final Widget themedScene = sceneIndex <= 1
                  ? pyramidScene
                  : SizedBox(
                      width: 1000,
                      height: 475,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          for (final layer in levelGroupLayers(currentBiome))
                            _buildLayer(
                              layer.painter,
                              layer.depth,
                              dx: layer.dx,
                              dy: layer.dy,
                              scale: layer.scale,
                            ),
                        ],
                      ),
                    );

              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRect(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: BiomeBackgroundTransition(
                        tropical: tropicalScene,
                        pyramids: themedScene,
                        progress: progress,
                        tropicalTint: widget.game.isInfinityMode
                            ? currentBiome.secondaryColor.withValues(
                                alpha: 0.16,
                              )
                            : Colors.transparent,
                        pyramidTint: widget.game.isInfinityMode
                            ? currentBiome.primaryColor.withValues(alpha: 0.22)
                            : const Color(0x336A2CA0),
                      ),
                    ),
                  ),
                  if (widget.game.isInfinityMode)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: widget.game.cameraOffsetYNotifier,
                        builder: (context, _) {
                          final double cameraY =
                              widget.game.cameraOffsetYNotifier.value;
                          final int score = (cameraY / 40.0).floor();
                          final biome1 = BiomeConfig.getDynamicScoreBiome(
                            score,
                          );
                          final biome2 = BiomeConfig.getDynamicScoreBiome(
                            score + 100,
                          );
                          final biome3 = BiomeConfig.getDynamicScoreBiome(
                            score + 200,
                          );

                          final double scrollOffset = (cameraY % 2000) / 2000.0;

                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0, -1),
                                end: const Alignment(0, 1),
                                colors: [
                                  biome1.bgTopColor.withValues(alpha: 0.45),
                                  biome2.secondaryColor.withValues(alpha: 0.35),
                                  biome3.bgBottomColor.withValues(alpha: 0.45),
                                  biome1.bgTopColor.withValues(alpha: 0.45),
                                ],
                                stops: const [0.0, 0.33, 0.66, 1.0],
                                transform: _ScrollGradientTransform(
                                  scrollOffset,
                                ),
                                tileMode: TileMode.repeated,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ScrollGradientTransform extends GradientTransform {
  final double scrollOffset;
  const _ScrollGradientTransform(this.scrollOffset);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(0, scrollOffset * bounds.height, 0);
  }
}
