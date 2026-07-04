import 'dart:math' as math;

import 'package:flutter/material.dart';

class CelestialCycleLayer extends StatefulWidget {
  const CelestialCycleLayer({super.key});

  @override
  State<CelestialCycleLayer> createState() => _CelestialCycleLayerState();
}

class _CelestialCycleLayerState extends State<CelestialCycleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clockController;

  @override
  void initState() {
    super.initState();
    _clockController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _clockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _clockController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(1000, 475),
            painter: CelestialCyclePainter(now: DateTime.now()),
          );
        },
      ),
    );
  }
}

class CelestialCyclePainter extends CustomPainter {
  final DateTime now;

  const CelestialCyclePainter({required this.now});

  static const double _dayStart = 6.0;
  static const double _dayEnd = 18.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double hour =
        now.hour +
        now.minute / 60.0 +
        now.second / 3600.0 +
        now.millisecond / 3600000.0;
    final double sunrise = _smoothstep(
      _dayStart - 0.75,
      _dayStart + 0.75,
      hour,
    );
    final double sunset = _smoothstep(_dayEnd - 0.75, _dayEnd + 0.75, hour);
    final double sunOpacity = (sunrise * (1.0 - sunset)).clamp(0.0, 1.0);
    final double moonOpacity = (1.0 - sunOpacity).clamp(0.0, 1.0);
    final double transitionBlend = (1.0 - (sunOpacity - moonOpacity).abs())
        .clamp(0.0, 1.0);
    final bool useDayTrack = sunOpacity >= moonOpacity;
    final double dayProgress = ((hour - _dayStart) / (_dayEnd - _dayStart))
        .clamp(0.0, 1.0);
    final double nightHour = hour >= _dayEnd
        ? hour - _dayEnd
        : hour + 24 - _dayEnd;
    final double nightProgress = (nightHour / 12.0).clamp(0.0, 1.0);
    final double trackProgress = useDayTrack ? dayProgress : nightProgress;
    final Offset position = _arcPosition(size, trackProgress);

    if (sunOpacity > 0.01) {
      _drawSun(canvas, position, 34 + 8 * (1.0 - transitionBlend), sunOpacity);
    }
    if (moonOpacity > 0.01) {
      _drawMoon(canvas, position, 31 + 5 * transitionBlend, moonOpacity);
    }
  }

  double _smoothstep(double edge0, double edge1, double value) {
    final double t = ((value - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
  }

  Offset _arcPosition(Size size, double progress) {
    final double eased = Curves.easeInOutSine.transform(progress);
    final double x = size.width * (0.12 + 0.76 * eased);
    final double y = size.height * (0.34 - 0.24 * math.sin(math.pi * eased));
    return Offset(x, y);
  }

  void _drawSun(Canvas canvas, Offset center, double radius, double opacity) {
    final Rect glowRect = Rect.fromCircle(center: center, radius: radius * 3.2);
    canvas.drawCircle(
      center,
      radius * 3.0,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF1A8).withValues(alpha: 0.22 * opacity),
            const Color(0xFFFFB35C).withValues(alpha: 0.08 * opacity),
            Colors.transparent,
          ],
        ).createShader(glowRect)
        ..blendMode = BlendMode.plus,
    );

    final Paint rayPaint = Paint()
      ..color = const Color(0xFFFFE08A).withValues(alpha: 0.36 * opacity)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 12; i++) {
      final double angle = (math.pi * 2 / 12) * i;
      final Offset inner =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius + 8);
      final Offset outer =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius + 20);
      canvas.drawLine(inner, outer, rayPaint);
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF6B8).withValues(alpha: opacity),
            const Color(0xFFFFC66D).withValues(alpha: opacity),
            const Color(0xFFFF8F5A).withValues(alpha: opacity),
          ],
          stops: const [0.0, 0.62, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _drawMoon(Canvas canvas, Offset center, double radius, double opacity) {
    final Rect glowRect = Rect.fromCircle(center: center, radius: radius * 3.0);
    canvas.drawCircle(
      center,
      radius * 2.5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFDDEBFF).withValues(alpha: 0.18 * opacity),
            const Color(0xFF9DB9FF).withValues(alpha: 0.06 * opacity),
            Colors.transparent,
          ],
        ).createShader(glowRect)
        ..blendMode = BlendMode.plus,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: opacity),
            const Color(0xFFD8E2FF).withValues(alpha: opacity),
            const Color(0xFF8FA4DA).withValues(alpha: opacity),
          ],
          stops: const [0.0, 0.70, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center + Offset(radius * 0.34, -radius * 0.12),
      radius * 0.92,
      Paint()
        ..color = const Color(0xFF6E4AA8).withValues(alpha: 0.78 * opacity),
    );

    final Paint craterPaint = Paint()
      ..color = const Color(0xFFB6C5EE).withValues(alpha: 0.34 * opacity);
    canvas.drawCircle(
      center + Offset(-radius * 0.34, -radius * 0.22),
      radius * 0.12,
      craterPaint,
    );
    canvas.drawCircle(
      center + Offset(-radius * 0.18, radius * 0.28),
      radius * 0.08,
      craterPaint,
    );
  }

  @override
  bool shouldRepaint(CelestialCyclePainter oldDelegate) =>
      oldDelegate.now.millisecond != now.millisecond ||
      oldDelegate.now.second != now.second ||
      oldDelegate.now.minute != now.minute ||
      oldDelegate.now.hour != now.hour;
}
