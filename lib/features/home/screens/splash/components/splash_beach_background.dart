import 'dart:math' as math;

import 'package:balanco_game/features/map/backgrounds/beach/mountains_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sea_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sky_painter.dart';
import 'package:flutter/material.dart';

class SplashBeachBackground extends StatelessWidget {
  const SplashBeachBackground({super.key, required this.animationValue});

  final double animationValue;

  @override
  Widget build(BuildContext context) {
    final phase = animationValue * math.pi * 2;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF73DDF6)),
        Positioned.fill(
          bottom: MediaQuery.sizeOf(context).height * 0.24,
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 1000,
                height: 475,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _layer(SkyPainter(), phase, 0.05),
                    _layer(
                      FirstCloudPainter(),
                      phase,
                      0.1,
                      dx: 193.1,
                      dy: 46.5,
                      scale: 0.39,
                    ),
                    _layer(
                      SecondCloudPainter(),
                      phase,
                      0.12,
                      dx: -6.1,
                      dy: 7.1,
                      scale: 0.26,
                    ),
                    _layer(
                      ThirdCloudPainter(),
                      phase,
                      0.14,
                      dx: 59.7,
                      dy: 15.7,
                      scale: 0.46,
                    ),
                    _layer(
                      ForthCloudPainter(),
                      phase,
                      0.16,
                      dx: 305,
                      dy: 27,
                      scale: 0.63,
                    ),
                    _layer(
                      FifthCloudPainter(),
                      phase,
                      0.18,
                      dx: 127.3,
                      dy: -85.9,
                      scale: 0.48,
                    ),
                    _layer(
                      BirdsPainter(),
                      phase,
                      0.2,
                      dx: 230.1,
                      dy: -11.4,
                      scale: 0.57,
                    ),
                    _layer(
                      FurtherSeaPainter(),
                      phase,
                      0.4,
                      dy: 214,
                      scale: 1.05,
                    ),
                    _layer(
                      MountainSeaShadowsPainter(),
                      phase,
                      0.5,
                      dx: 52.8,
                      dy: 166.4,
                      scale: 0.47,
                    ),
                    _layer(
                      BackMountainPainter(),
                      phase,
                      0.3,
                      dx: 122,
                      dy: 42.6,
                      scale: 0.5,
                    ),
                    _layer(
                      CloserSeaPainter(),
                      phase,
                      0.6,
                      dx: 166.9,
                      dy: 401.3,
                      scale: 1.42,
                    ),
                    _layer(
                      SeaWaterDropsPainter(),
                      phase,
                      0.7,
                      dx: 112.6,
                      dy: 246.1,
                      scale: 0.51,
                    ),
                    _layer(
                      FrontMountainPainter(),
                      phase,
                      0.8,
                      dx: 73.2,
                      dy: 35.3,
                      scale: 0.32,
                    ),
                    _layer(
                      SeaMountainWaves(),
                      phase,
                      0.45,
                      dx: 7.1,
                      dy: 9.6,
                      scale: 0.27,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.sizeOf(context).height * 0.5,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x003CD0EE),
                  Color(0x7730C9EA),
                  Color(0xFF12AFD7),
                ],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
        ),
        Positioned(
          left: -80 + math.sin(phase) * 10,
          right: -80,
          bottom: -36,
          height: MediaQuery.sizeOf(context).height * 0.27,
          child: CustomPaint(painter: _SandForegroundPainter(phase: phase)),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x12004782),
                  Colors.transparent,
                  Color(0x22004782),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _layer(
    CustomPainter painter,
    double phase,
    double depth, {
    double dx = 0,
    double dy = 0,
    double scale = 1,
  }) {
    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(
          dx + math.sin(phase + depth * 4) * 9 * depth,
          dy + math.cos(phase * 0.8 + depth) * 4 * depth,
        ),
        child: Transform.scale(
          scale: scale,
          child: RepaintBoundary(
            child: CustomPaint(size: const Size(1000, 475), painter: painter),
          ),
        ),
      ),
    );
  }
}

class _SandForegroundPainter extends CustomPainter {
  const _SandForegroundPainter({required this.phase});

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final back = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.06,
        size.width * 0.52,
        size.height * 0.3,
      )
      ..quadraticBezierTo(
        size.width * 0.77,
        size.height * 0.5,
        size.width,
        size.height * 0.18,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      back,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE594), Color(0xFFF8BF60), Color(0xFFEC9A3D)],
        ).createShader(Offset.zero & size),
    );

    final foam = Path()
      ..moveTo(0, size.height * 0.32)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.03,
        size.width * 0.52,
        size.height * 0.27,
      )
      ..quadraticBezierTo(
        size.width * 0.77,
        size.height * 0.47,
        size.width,
        size.height * 0.15,
      );
    canvas.drawPath(
      foam,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.82)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    final sparkle = Paint()..color = const Color(0x66FFFFFF);
    for (var i = 0; i < 8; i++) {
      final x = size.width * ((i * 0.137 + 0.09) % 1);
      final y = size.height * (0.52 + 0.07 * math.sin(phase + i));
      canvas.drawCircle(Offset(x, y), 2 + i % 3, sparkle);
    }
  }

  @override
  bool shouldRepaint(_SandForegroundPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
