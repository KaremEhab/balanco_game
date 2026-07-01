import 'package:flutter/material.dart';

class BeachRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // A rich, warm sandy gradient that looks smooth and premium
    final Paint sandPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFD4A373), // Darker wet sand edge
          Color(0xFFE9C46A), // Rich sand
          Color(0xFFF4A261), // Warm beach tone
          Color(0xFFE9C46A), // Rich sand
          Color(0xFFD4A373), // Darker wet sand edge
        ],
        stops: [0.0, 0.15, 0.5, 0.85, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, sandPaint);

    // Add a subtle vertical glowing overlay to make it feel premium/glassy
    final Paint highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.transparent,
          Colors.white.withValues(alpha: 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..blendMode = BlendMode.softLight;
      
    canvas.drawRect(rect, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
