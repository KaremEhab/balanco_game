import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
          _heartbeatPlayer = await AppSettings.playSound('heartbeat.mp3');
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
