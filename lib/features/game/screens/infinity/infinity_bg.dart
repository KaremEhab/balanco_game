import 'package:flutter/material.dart';

class InfinityScrollGradientBg extends StatelessWidget {
  final ValueNotifier<double> cameraOffsetY;
  final ValueNotifier<int> currentScore;

  const InfinityScrollGradientBg({
    super.key,
    required this.cameraOffsetY,
    required this.currentScore,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([cameraOffsetY, currentScore]),
      builder: (context, _) {
        return CustomPaint(
          painter: _InfinityScrollGradientPainter(
            cameraOffsetY: cameraOffsetY.value,
            currentScore: currentScore.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _InfinityScrollGradientPainter extends CustomPainter {
  final double cameraOffsetY;
  final int currentScore;

  static const List<List<Color>> _stages = [
    [Color(0xFF1A237E), Color(0xFF0D47A1)],
    [Color(0xFF283593), Color(0xFF4527A0)],
    [Color(0xFF4A148C), Color(0xFF880E4F)],
    [Color(0xFF6A1B9A), Color(0xFF1565C0)],
  ];

  const _InfinityScrollGradientPainter({
    required this.cameraOffsetY,
    required this.currentScore,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gradientHeight = (size.height * 1.7).clamp(900.0, 1600.0);
    final offset = cameraOffsetY % gradientHeight;
    final score = currentScore.clamp(0, 1 << 30);
    final stageIndex = (score ~/ 100) % _stages.length;
    final nextStageIndex = (stageIndex + 1) % _stages.length;
    final progress = (score % 100) / 100.0;

    final from = Color.lerp(
      _stages[stageIndex][0],
      _stages[nextStageIndex][0],
      progress,
    )!;
    final to = Color.lerp(
      _stages[stageIndex][1],
      _stages[nextStageIndex][1],
      progress,
    )!;

    final paint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [from, to, from],
            stops: const [0.0, 0.55, 1.0],
            tileMode: TileMode.repeated,
          ).createShader(
            Rect.fromLTWH(0, -offset, size.width, gradientHeight.toDouble()),
          );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _InfinityScrollGradientPainter oldDelegate) {
    return oldDelegate.cameraOffsetY != cameraOffsetY ||
        oldDelegate.currentScore != currentScore;
  }
}
