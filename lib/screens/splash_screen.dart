import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../widgets/logo_painter.dart';
import '../game/components/game_background/sky_painter.dart';

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
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
                  // _buildLayer(FirstCloudPainter(), dx: 193.1, dy: 46.5, scale: 0.39),
                  _buildLayer(
                    SecondCloudPainter(),
                    dx: -6.1,
                    dy: 7.1,
                    scale: 0.26,
                  ),
                  // _buildLayer(ThirdCloudPainter(), dx: 59.7, dy: 15.7, scale: 0.46),
                  // _buildLayer(ForthCloudPainter(), dx: 305.0, dy: 27.0, scale: 0.63),
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
                // Apply a nice spring scaling effect on the whole logo at the very end
                double scale = 1.0;
                if (_controller.value > 0.9) {
                  double p = (_controller.value - 0.9) / 0.1;
                  scale = 1.0 + 0.05 * (1.0 - (1.0 - p) * (1.0 - p));
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
