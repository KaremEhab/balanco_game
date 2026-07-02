import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SettingsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Native path is approx 30x30. Scale it to fit the requested size.
    canvas.scale(size.width / 30.0, size.height / 30.0);

    Path path_0 = Path();
    path_0.moveTo(15, 17.344);
    path_0.arcToPoint(
      Offset(15, 12.656000000000002),
      radius: Radius.elliptical(2.344, 2.344),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_0.arcToPoint(
      Offset(15, 17.344),
      radius: Radius.elliptical(2.344, 2.344),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();

    // Replaced by combined fill logic below

    Path path_1 = Path();
    path_1.moveTo(28.125, 11.719);
    path_1.lineTo(26.719, 11.719);
    path_1.arcToPoint(
      Offset(25.612000000000002, 9.038),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(26.606, 8.044);
    path_1.arcToPoint(
      Offset(26.606, 5.381),
      radius: Radius.elliptical(1.876, 1.876),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(24.62, 3.394);
    path_1.arcToPoint(
      Offset(21.957, 3.394),
      radius: Radius.elliptical(1.874, 1.874),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(20.963, 4.388);
    path_1.arcToPoint(
      Offset(18.283, 3.2809999999999997),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(18.283, 1.875);
    path_1.arcToPoint(
      Offset(16.405, 0),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(13.593000000000002, 0);
    path_1.arcToPoint(
      Offset(11.718000000000002, 1.875),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(11.718000000000002, 3.2809999999999997);
    path_1.arcToPoint(
      Offset(9.037000000000003, 4.388),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(8.043000000000003, 3.394);
    path_1.arcToPoint(
      Offset(5.380000000000003, 3.394),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(3.394, 5.38);
    path_1.arcToPoint(
      Offset(3.394, 8.043),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(4.388, 9.036);
    path_1.arcToPoint(
      Offset(3.28, 11.72),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(1.875, 11.72);
    path_1.arcToPoint(
      Offset(0, 13.594),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(0, 16.406);
    path_1.arcToPoint(
      Offset(1.875, 18.281),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(3.2809999999999997, 18.281);
    path_1.arcToPoint(
      Offset(4.388, 20.962),
      radius: Radius.elliptical(1.576, 1.576),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(3.394, 21.956);
    path_1.arcToPoint(
      Offset(3.394, 24.6),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(5.381, 26.587000000000003);
    path_1.arcToPoint(
      Offset(8.044, 26.587000000000003),
      radius: Radius.elliptical(1.876, 1.876),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(9.037, 25.594000000000005);
    path_1.arcToPoint(
      Offset(11.719000000000001, 26.719000000000005),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(11.719000000000001, 28.125000000000004);
    path_1.arcToPoint(
      Offset(13.594, 30),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(16.406, 30);
    path_1.arcToPoint(
      Offset(18.281, 28.125),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(18.281, 26.719);
    path_1.arcToPoint(
      Offset(20.962, 25.594),
      radius: Radius.elliptical(1.576, 1.576),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(21.956, 26.587);
    path_1.arcToPoint(
      Offset(24.619, 26.587),
      radius: Radius.elliptical(1.877, 1.877),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(26.606, 24.6);
    path_1.arcToPoint(
      Offset(26.606, 21.956000000000003),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(25.612000000000002, 20.962000000000003);
    path_1.arcToPoint(
      Offset(26.719, 18.282000000000004),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.lineTo(28.125, 18.282000000000004);
    path_1.arcToPoint(
      Offset(30, 16.405),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(30, 13.593000000000002);
    path_1.arcToPoint(
      Offset(28.125, 11.718000000000002),
      radius: Radius.elliptical(1.875, 1.875),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.close();
    path_1.moveTo(15, 20.156);
    path_1.arcToPoint(
      Offset(15, 9.841999999999999),
      radius: Radius.elliptical(5.157, 5.157),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_1.arcToPoint(
      Offset(15, 20.156),
      radius: Radius.elliptical(5.157, 5.157),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.close();

    Paint fillPaint = Paint()..style = PaintingStyle.fill;
    fillPaint.color = Colors.white.withValues(alpha: 0.7);

    canvas.drawPath(path_0, fillPaint);
    canvas.drawPath(path_1, fillPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SettingsIconPainter oldDelegate) {
    return false;
  }
}
