import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class HomeIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Native path is approx 37x30. Scale it to fit the requested size.
    canvas.scale((size.width + 3) / 37.0, size.height / 30.0);

    Path path_0 = Path();
    path_0.moveTo(36.209, 11.276);
    path_0.lineTo(20.288, 0.593);
    path_0.arcToPoint(
      Offset(16.506, 0.593),
      radius: Radius.elliptical(3.309, 3.309),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(0.587, 11.276);
    path_0.arcToPoint(
      Offset(0.20899999999999996, 13.166),
      radius: Radius.elliptical(1.418, 1.418),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.arcToPoint(
      Offset(2.1, 13.564),
      radius: Radius.elliptical(1.4, 1.4),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(4.1419999999999995, 12.202);
    path_0.lineTo(4.1419999999999995, 24.328);
    path_0.arcToPoint(
      Offset(9.814, 30),
      radius: Radius.elliptical(5.672, 5.672),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(13.104, 30);
    path_0.arcToPoint(
      Offset(14.616999999999999, 28.487000000000002),
      radius: Radius.elliptical(1.513, 1.513),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(14.616999999999999, 22.437);
    path_0.arcToPoint(
      Offset(22.179, 22.437),
      radius: Radius.elliptical(3.781, 3.781),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_0.lineTo(22.179, 28.487000000000002);
    path_0.arcToPoint(
      Offset(23.692, 30),
      radius: Radius.elliptical(1.513, 1.513),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(26.906, 30);
    path_0.arcToPoint(
      Offset(32.577999999999996, 24.328),
      radius: Radius.elliptical(5.672, 5.672),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(32.577999999999996, 12.202);
    path_0.lineTo(34.62, 13.564);
    path_0.cubicTo(
      34.855,
      13.724,
      35.129999999999995,
      13.816,
      35.413999999999994,
      13.828,
    );
    path_0.arcToPoint(
      Offset(36.586999999999996, 13.205),
      radius: Radius.elliptical(1.38, 1.38),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.arcToPoint(
      Offset(36.208, 11.275),
      radius: Radius.elliptical(1.418, 1.418),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withValues(alpha: 0.7);
    canvas.drawPath(path_0, paint_0_fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HomeIconPainter oldDelegate) {
    return false;
  }
}
