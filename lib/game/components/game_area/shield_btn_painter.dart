import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShieldBtnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff49BCE9).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.08666000,
          size.height * 0.02000000,
          size.width * 0.8800000,
          size.height * 0.8800000,
        ),
        bottomRight: Radius.circular(size.width * 0.3000000),
        bottomLeft: Radius.circular(size.width * 0.3000000),
        topLeft: Radius.circular(size.width * 0.3000000),
        topRight: Radius.circular(size.width * 0.3000000),
      ),
      paint_0_fill,
    );

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.07666000,
          size.height * 0.01000000,
          size.width * 0.9000000,
          size.height * 0.9000000,
        ),
        bottomRight: Radius.circular(size.width * 0.3100000),
        bottomLeft: Radius.circular(size.width * 0.3100000),
        topLeft: Radius.circular(size.width * 0.3100000),
        topRight: Radius.circular(size.width * 0.3100000),
      ),
      paint_1_stroke,
    );

    Path path_2 = Path();
    path_2.moveTo(38.504, 17.605);
    path_2.arcToPoint(
      Offset(28.304, 35.275999999999996),
      radius: Radius.elliptical(20.401, 20.401),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(28.305999999999997, 35.276999999999994);
    path_2.lineTo(27.612, 35.67999999999999);
    path_2.arcToPoint(
      Offset(25.226, 35.67999999999999),
      radius: Radius.elliptical(2.388, 2.388),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(25.224, 35.67999999999999);
    path_2.lineTo(24.532, 35.276999999999994);
    path_2.lineTo(24.532, 35.27799999999999);
    path_2.arcToPoint(
      Offset(14.333, 17.604999999999993),
      radius: Radius.elliptical(20.4, 20.4),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(14.333, 17.602999999999994);
    path_2.arcToPoint(
      Offset(16.219, 14.341999999999995),
      radius: Radius.elliptical(3.771, 3.771),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(24.644000000000002, 9.477999999999994);
    path_2.arcToPoint(
      Offset(28.193, 9.477999999999994),
      radius: Radius.elliptical(3.535, 3.535),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(36.618, 14.341999999999995);
    path_2.arcToPoint(
      Offset(38.504000000000005, 17.602999999999994),
      radius: Radius.elliptical(3.772, 3.772),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(38.504000000000005, 17.604999999999993);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04000000;
    paint_2_stroke.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff227DA1).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(27.313, 30.6);
    path_3.lineTo(26.843, 30.874000000000002);
    path_3.arcToPoint(
      Offset(25.9, 30.874000000000002),
      radius: Radius.elliptical(0.942, 0.942),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(25.429, 30.601000000000003);
    path_3.arcToPoint(
      Offset(18.833, 19.171000000000003),
      radius: Radius.elliptical(13.191, 13.191),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(19.776, 17.541000000000004),
      radius: Radius.elliptical(1.884, 1.884),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(25.503999999999998, 14.234000000000004);
    path_3.arcToPoint(
      Offset(27.238, 14.234000000000004),
      radius: Radius.elliptical(1.725, 1.725),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(32.967, 17.541000000000004);
    path_3.arcToPoint(
      Offset(33.909, 19.171000000000003),
      radius: Radius.elliptical(1.885, 1.885),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(27.313, 30.601000000000003),
      radius: Radius.elliptical(13.19, 13.19),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffCDF1FF).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
