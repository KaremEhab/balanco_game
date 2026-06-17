import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dart:math';

class JoystickPainter extends CustomPainter {
  final double dy;
  final bool isLeft;

  JoystickPainter({this.dy = 0, this.isLeft = true});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    
    // Base pivot point
    double pivotX = isLeft ? 0 : size.width;
    double pivotY = size.height / 2;
    
    canvas.translate(pivotX, pivotY);
    
    // Calculate rotation angle
    double r = 80.65;
    double theta = isLeft ? asin((dy / r).clamp(-1.0, 1.0)) : asin((-dy / r).clamp(-1.0, 1.0));
    canvas.rotate(theta);
    
    if (isLeft) {
      canvas.rotate(pi / 2);
    } else {
      canvas.rotate(-pi / 2);
    }
    // Translate back to the stick's pivot point
    canvas.translate(-39.78, -120.65);

    Path path_8 = Path();
    path_8.moveTo(57.663, 39.781);
    path_8.lineTo(54.055, 77.12299999999999);
    path_8.lineTo(50.83, 110.612);
    path_8.cubicTo(
      50.272999999999996,
      116.312,
      45.495,
      120.65299999999999,
      39.777,
      120.65299999999999,
    );
    path_8.cubicTo(
      34.077,
      120.65299999999999,
      29.283,
      116.312,
      28.742,
      110.612,
    );
    path_8.lineTo(25.5, 77.122);
    path_8.lineTo(21.892, 39.782);
    path_8.lineTo(57.663, 39.782);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xff372641).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(57.662, 39.782);
    path_9.lineTo(54.054, 77.124);
    path_9.arcToPoint(
      Offset(39.776, 80.20899999999999),
      radius: Radius.elliptical(34.298, 34.298),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.cubicTo(
      34.68600000000001,
      80.20899999999999,
      29.839000000000006,
      79.11099999999999,
      25.498000000000005,
      77.124,
    );
    path_9.lineTo(21.889000000000003, 39.782);
    path_9.lineTo(57.662000000000006, 39.782);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffC55C5C).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(73.947, 45.349);
    path_10.cubicTo(77.031, 26.47, 64.227, 8.667, 45.35, 5.583);
    path_10.cubicTo(26.47, 2.5, 8.667, 15.303, 5.583, 34.183);
    path_10.cubicTo(2.5, 53.06, 15.303, 70.864, 34.183, 73.94800000000001);
    path_10.cubicTo(53.06, 77.031, 70.863, 64.227, 73.947, 45.348000000000006);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xffF80000).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(74.457, 39.787);
    path_11.cubicTo(
      74.457,
      58.911,
      58.958999999999996,
      74.426,
      39.81799999999999,
      74.426,
    );
    path_11.cubicTo(
      20.693999999999992,
      74.426,
      5.194999999999993,
      58.911,
      5.194999999999993,
      39.786,
    );
    path_11.cubicTo(
      5.194999999999993,
      37.94,
      5.334999999999993,
      36.109,
      5.6319999999999935,
      34.348,
    );
    path_11.cubicTo(8.23, 50.874, 22.542, 63.53, 39.818, 63.53);
    path_11.cubicTo(
      57.111999999999995,
      63.53,
      71.424,
      50.875,
      74.02199999999999,
      34.347,
    );
    path_11.cubicTo(74.317, 36.107, 74.457, 37.937, 74.457, 39.786);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffCD0808).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(51.943, 37.113);
    path_12.cubicTo(
      59.809,
      33.877,
      63.561,
      24.878,
      60.324999999999996,
      17.012999999999998,
    );
    path_12.cubicTo(57.09, 9.147, 48.09, 5.395, 40.225, 8.63);
    path_12.cubicTo(
      32.36,
      11.866000000000001,
      28.607,
      20.865000000000002,
      31.843000000000004,
      28.730000000000004,
    );
    path_12.cubicTo(
      35.079,
      36.595000000000006,
      44.078,
      40.348000000000006,
      51.943000000000005,
      37.112,
    );
    path_12.close();
    path_12.moveTo(36.056, 43.647999999999996);
    path_12.arcToPoint(
      Offset(25.299, 43.647999999999996),
      radius: Radius.elliptical(5.378, 5.378),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_12.arcToPoint(
      Offset(30.677, 38.267999999999994),
      radius: Radius.elliptical(5.378, 5.378),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_12.arcToPoint(
      Offset(36.057, 43.647999999999996),
      radius: Radius.elliptical(5.378, 5.378),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffF06868).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant JoystickPainter oldDelegate) {
    return oldDelegate.dy != dy;
  }
}
