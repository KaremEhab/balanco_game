import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ModesIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(7.617, 21.235);
    path_0.arcToPoint(
      Offset(7.617, 34.471000000000004),
      radius: Radius.elliptical(6.618, 6.618),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_0.arcToPoint(
      Offset(7.617, 21.235000000000003),
      radius: Radius.elliptical(6.618, 6.618),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.close();
    path_0.moveTo(29.661, 21.235);
    path_0.arcToPoint(
      Offset(33.47, 25.044),
      radius: Radius.elliptical(3.808, 3.808),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(33.47, 30.661);
    path_0.arcToPoint(
      Offset(29.660999999999998, 34.471000000000004),
      radius: Radius.elliptical(3.81, 3.81),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(24.043999999999997, 34.471000000000004);
    path_0.arcToPoint(
      Offset(20.234999999999996, 30.661000000000005),
      radius: Radius.elliptical(3.81, 3.81),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(20.234999999999996, 25.044000000000004);
    path_0.arcToPoint(
      Offset(24.043999999999997, 21.235000000000003),
      radius: Radius.elliptical(3.808, 3.808),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(29.660999999999998, 21.235000000000003);
    path_0.close();
    path_0.moveTo(10.427, 1);
    path_0.arcToPoint(
      Offset(14.235, 4.809),
      radius: Radius.elliptical(3.809, 3.809),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(14.235, 10.427);
    path_0.arcToPoint(
      Offset(10.427, 14.235),
      radius: Radius.elliptical(3.81, 3.81),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(4.809, 14.235);
    path_0.arcToPoint(
      Offset(1, 10.427),
      radius: Radius.elliptical(3.81, 3.81),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(1, 4.809);
    path_0.arcToPoint(
      Offset(4.809, 1),
      radius: Radius.elliptical(3.809, 3.809),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(10.427, 1);
    path_0.close();
    path_0.moveTo(26.831, 1.696);
    path_0.arcToPoint(
      Offset(28.748, 2.716),
      radius: Radius.elliptical(2.312, 2.312),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(28.828, 2.845);
    path_0.lineTo(28.832, 2.851);
    path_0.lineTo(33.118, 10.338000000000001);
    path_0.lineTo(33.190000000000005, 10.472000000000001);
    path_0.arcToPoint(
      Offset(31.110000000000007, 13.802000000000001),
      radius: Radius.elliptical(2.31, 2.31),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(31.110000000000007, 13.804000000000002);
    path_0.lineTo(22.553000000000004, 13.804000000000002);
    path_0.lineTo(22.553000000000004, 13.803000000000003);
    path_0.arcToPoint(
      Offset(20.545000000000005, 10.338000000000003),
      radius: Radius.elliptical(2.31, 2.31),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(24.83, 2.85);
    path_0.lineTo(24.833, 2.8440000000000003);
    path_0.arcToPoint(
      Offset(26.83, 1.6950000000000003),
      radius: Radius.elliptical(2.311, 2.311),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05714286;
    paint_0_stroke.color = Color(0xff420F00).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4781429, size.height * 0.05555556),
      Offset(size.width * 0.4781429, size.height * 0.9575000),
      [Color(0xffFFA428).withOpacity(1), Color(0xffF54812).withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
