import 'package:flutter/material.dart';

class CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Drop shadow
    canvas.drawCircle(
      center.translate(0, 2),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0),
    );

    // Outer dark gold ring
    final outerRingGradient = const RadialGradient(
      center: Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: [Color(0xFFB58D3D), Color(0xFF6B4D16)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = outerRingGradient,
    );

    // Inner bevel shadow (dark)
    canvas.drawCircle(
      center,
      radius * 0.85,
      Paint()..color = const Color(0xFF4A340D),
    );

    // Inner bright gold face
    final innerFaceGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFD464), Color(0xFFB58D3D)],
    ).createShader(Rect.fromCircle(center: center, radius: radius * 0.8));

    canvas.drawCircle(
      center,
      radius * 0.8,
      Paint()..shader = innerFaceGradient,
    );

    // Draw the "C"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'C',
        style: TextStyle(
          color: Color(0xFF5A3E10), // Dark brown/gold
          fontSize: 24,
          fontWeight: FontWeight.w900,
          fontFamily: 'Arial', // or Luckiest Guy if it's available, but arial is safe
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // Scale text to fit perfectly inside the inner face
    canvas.save();
    canvas.translate(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
    
    // Inner highlight (glassy effect)
    final highlightPath = Path()
      ..addOval(Rect.fromCenter(center: center.translate(0, -radius * 0.4), width: radius * 1.2, height: radius * 0.5));
    
    canvas.drawPath(
      highlightPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
