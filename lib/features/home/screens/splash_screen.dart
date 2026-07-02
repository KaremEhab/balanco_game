import 'package:flutter/material.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'dart:math' as math;
import 'package:balanco_game/features/home/screens/main_screen.dart';
import 'package:balanco_game/core/widgets/logo_painter.dart';
import 'package:balanco_game/features/game/components/game_background/sky_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    try {
      AppSettings.playSound('logo_new.wav');
    } catch (e) {
      debugPrint("Could not play logo sound: $e");
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLayer(
    CustomPainter painter, {
    double dx = 0,
    double dy = 0,
    double scale = 1.0,
  }) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Transform.scale(
        scale: scale,
        child: CustomPaint(size: const Size(1000, 475), painter: painter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCCFFFB),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 1000,
              height: 475,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildLayer(SkyPainter(), dx: 0.0, dy: 0.0, scale: 1.00),
                  _buildLayer(
                    SecondCloudPainter(),
                    dx: -6.1,
                    dy: 7.1,
                    scale: 0.26,
                  ),
                  _buildLayer(
                    FifthCloudPainter(),
                    dx: 127.3,
                    dy: -85.9,
                    scale: 0.48,
                  ),
                  _buildLayer(
                    BirdsPainter(),
                    dx: 230.1,
                    dy: -11.4,
                    scale: 0.57,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double scale = 1.0;

                // The dramatic "ding" beat happens exactly at 1.8s (progress 0.72 of 2.5s)
                if (_controller.value >= 0.72) {
                  double p = (_controller.value - 0.72) / 0.28;
                  // Explosive pop up to 1.15 scale and back down smoothly
                  scale = 1.0 + 0.15 * math.sin(p * math.pi);
                } else {
                  // Subtle, tense growing effect during the whoosh build-up
                  double p = _controller.value / 0.72;
                  scale = 0.95 + 0.05 * p;
                }

                return Transform.scale(
                  scale: scale,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: CustomPaint(
                        size: const Size(3783, 3783),
                        painter: LogoPainter(progress: _controller.value),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value > 0.5
                        ? (_controller.value - 0.5) * 2
                        : 0.0,
                    child: child,
                  );
                },
                child: const Text(
                  '© Developer Kareem Ehab',
                  style: TextStyle(
                    color: Color(0xff1B4F72),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
