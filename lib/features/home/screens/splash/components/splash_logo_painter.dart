import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashLogoPainter extends CustomPainter {
  const SplashLogoPainter({required this.shine});

  final double shine;

  static const _letters = ['B', 'A', 'L', 'A', 'N', 'C', 'O'];
  static const _colors = [
    Color(0xFFFF4D45),
    Color(0xFFFFCF25),
    Color(0xFF20B9F2),
    Color(0xFFFF684A),
    Color(0xFFFFD52A),
    Color(0xFF18A9ED),
    Color(0xFF7CD05B),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final fontSize = math.min(size.width * 0.19, size.height * 0.55);
    final painters = _letters
        .map(
          (letter) =>
              _textPainter(letter, fontSize, Paint()..color = Colors.white),
        )
        .toList();
    final widths = painters.map((p) => p.width * 0.82).toList();
    final totalWidth = widths.fold<double>(0, (sum, width) => sum + width);
    final scale = math.min(1.0, size.width * 0.94 / totalWidth);

    canvas.save();
    canvas.translate(size.width / 2, size.height * 0.47);
    canvas.scale(scale);
    canvas.translate(-totalWidth / 2, 0);

    var x = 0.0;
    for (var i = 0; i < _letters.length; i++) {
      final normalized = i / (_letters.length - 1);
      final arcY = math.pow((normalized - 0.5) * 2, 2) * fontSize * 0.2;
      final angle = (normalized - 0.5) * 0.2;
      final centerX = x + painters[i].width / 2;
      final origin = Offset(centerX, arcY);

      canvas.save();
      canvas.translate(origin.dx, origin.dy);
      canvas.rotate(angle);
      canvas.translate(-painters[i].width / 2, -fontSize / 2);

      _paintLayer(
        canvas,
        _letters[i],
        fontSize,
        const Color(0xFF07509E),
        PaintingStyle.stroke,
        15,
        const Offset(0, 10),
      );
      _paintLayer(
        canvas,
        _letters[i],
        fontSize,
        Colors.white,
        PaintingStyle.stroke,
        13,
        Offset.zero,
      );
      _paintLayer(
        canvas,
        _letters[i],
        fontSize,
        const Color(0xFF0B5BAA),
        PaintingStyle.stroke,
        7,
        Offset.zero,
      );

      final fill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(_colors[i], Colors.white, 0.42)!,
            _colors[i],
            Color.lerp(_colors[i], Colors.black, 0.24)!,
          ],
          stops: const [0, 0.58, 1],
        ).createShader(Rect.fromLTWH(0, 0, painters[i].width, fontSize));
      _textPainter(_letters[i], fontSize, fill).paint(canvas, Offset.zero);

      final sweep = (shine * 1.45 - 0.2) * totalWidth;
      if (sweep > x && sweep < x + widths[i]) {
        canvas.drawOval(
          Rect.fromLTWH(
            painters[i].width * 0.2,
            fontSize * 0.1,
            painters[i].width * 0.26,
            fontSize * 0.07,
          ),
          Paint()..color = const Color(0xAAFFFFFF),
        );
      }
      canvas.restore();
      x += widths[i];
    }
    canvas.restore();
  }

  TextPainter _textPainter(String text, double fontSize, Paint foreground) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          height: 0.9,
          foreground: foreground,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  void _paintLayer(
    Canvas canvas,
    String text,
    double fontSize,
    Color color,
    PaintingStyle style,
    double strokeWidth,
    Offset offset,
  ) {
    final paint = Paint()
      ..color = color
      ..style = style
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;
    _textPainter(text, fontSize, paint).paint(canvas, offset);
  }

  @override
  bool shouldRepaint(SplashLogoPainter oldDelegate) =>
      oldDelegate.shine != shine;
}
