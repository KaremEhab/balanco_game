import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../game/components/game_background/mountains_painter.dart';
import '../../game/components/game_background/sea_painter.dart';
import '../../game/components/game_background/sky_painter.dart';

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
