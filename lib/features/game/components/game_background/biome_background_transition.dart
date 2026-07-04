import 'dart:math' as math;

import 'package:balanco_game/features/game/components/game_background/celestial_cycle_painter.dart';
import 'package:flutter/material.dart';

class BiomeBackgroundTransition extends StatelessWidget {
  final Widget tropical;
  final Widget pyramids;
  final double progress;
  final Color tropicalTint;
  final Color pyramidTint;

  const BiomeBackgroundTransition({
    super.key,
    required this.tropical,
    required this.pyramids,
    required this.progress,
    this.tropicalTint = Colors.transparent,
    this.pyramidTint = const Color(0x336A2CA0),
  });

  @override
  Widget build(BuildContext context) {
    final double t = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
    final Color tint = Color.lerp(tropicalTint, pyramidTint, t)!;

    return SizedBox(
      width: 1000,
      height: 475,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Opacity(
            opacity: (1.0 - t * 0.72).clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(-28 * t, 10 * t),
              child: Transform.scale(
                scale: 1.0 + 0.025 * t,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(tint, BlendMode.srcATop),
                  child: tropical,
                ),
              ),
            ),
          ),
          ClipPath(
            clipper: _BiomeRevealClipper(progress: t),
            child: Opacity(
              opacity: (t * 1.3).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(34 * (1.0 - t), -10 * (1.0 - t)),
                child: Transform.scale(scale: 1.04 - 0.04 * t, child: pyramids),
              ),
            ),
          ),
          const IgnorePointer(child: CelestialCycleLayer()),
          IgnorePointer(
            child: CustomPaint(
              size: const Size(1000, 475),
              painter: _BiomeTransitionBloomPainter(progress: t),
            ),
          ),
        ],
      ),
    );
  }
}

class _BiomeRevealClipper extends CustomClipper<Path> {
  final double progress;

  const _BiomeRevealClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final double edge = -0.18 + 2.36 * progress;
    final double wave = 0.04 * math.sin(progress * math.pi);
    if (edge <= 0.0) return Path();
    if (edge >= 2.0) return Path()..addRect(Offset.zero & size);

    final double e = edge.clamp(0.0, 2.0);
    double yFor(double normalizedX) {
      final double normalizedY = 1.0 - (e - normalizedX + wave);
      return size.height * normalizedY.clamp(0.0, 1.0);
    }

    double xFor(double normalizedY) {
      final double normalizedX = e - (1.0 - normalizedY) - wave;
      return size.width * normalizedX.clamp(0.0, 1.0);
    }

    if (e <= 1.0) {
      final Offset bottomHit = Offset(xFor(1.0), size.height);
      final Offset leftHit = Offset(0, yFor(0.0));
      return Path()
        ..moveTo(0, size.height)
        ..lineTo(bottomHit.dx, bottomHit.dy)
        ..quadraticBezierTo(
          size.width * 0.18,
          size.height * (0.86 - wave),
          leftHit.dx,
          leftHit.dy,
        )
        ..close();
    }

    final Offset rightHit = Offset(size.width, yFor(1.0));
    final Offset topHit = Offset(xFor(0.0), 0);
    return Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(rightHit.dx, rightHit.dy)
      ..quadraticBezierTo(
        size.width * (0.82 + wave),
        size.height * 0.18,
        topHit.dx,
        topHit.dy,
      )
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(_BiomeRevealClipper oldClipper) =>
      oldClipper.progress != progress;
}

class _BiomeTransitionBloomPainter extends CustomPainter {
  final double progress;

  const _BiomeTransitionBloomPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final double pulse = math.sin(progress * math.pi);
    final double edge = -0.18 + 2.36 * progress;
    final Offset start = Offset(
      size.width * (edge - 1.0).clamp(0.0, 1.0),
      size.height,
    );
    final Offset end = Offset(size.width * edge.clamp(0.0, 1.0), 0);
    final Rect bloomRect = Offset.zero & size;

    final Paint wash = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Colors.transparent,
          const Color(0xFFFFD6A5).withValues(alpha: 0.28 * pulse),
          const Color(0xFFB57BCC).withValues(alpha: 0.20 * pulse),
          Colors.transparent,
        ],
        stops: const [0.0, 0.42, 0.62, 1.0],
      ).createShader(bloomRect)
      ..blendMode = BlendMode.plus;
    canvas.drawRect(bloomRect, wash);

    final Path shimmerEdge = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        size.width * (0.30 + 0.06 * pulse),
        size.height * 0.70,
        size.width * (0.62 - 0.08 * pulse),
        size.height * 0.34,
        end.dx,
        end.dy,
      );

    canvas.drawPath(
      shimmerEdge,
      Paint()
        ..color = const Color(0xFFFFF1C7).withValues(alpha: 0.55 * pulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 + 4.0 * pulse
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0 * pulse),
    );
  }

  @override
  bool shouldRepaint(_BiomeTransitionBloomPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
