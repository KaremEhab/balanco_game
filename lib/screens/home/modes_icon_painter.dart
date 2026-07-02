import 'package:flutter/material.dart';

class ModesIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Native path is approx 31x31. Scale it to fit the requested size.
    canvas.scale(size.width / 31.0, size.height / 31.0);

    Path path_0 = Path();
    path_0.moveTo(8.88, 0);
    path_0.lineTo(2.96, 0);
    path_0.arcToPoint(
      Offset(0, 2.96),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(0, 8.879999999999999);
    path_0.arcToPoint(
      Offset(2.96, 11.838999999999999),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(8.879999999999999, 11.838999999999999);
    path_0.arcToPoint(
      Offset(11.84, 8.878999999999998),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(11.84, 2.96);
    path_0.arcToPoint(
      Offset(8.88, 0),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();
    path_0.moveTo(11.839, 25.135);
    path_0.arcToPoint(
      Offset(0, 25.135),
      radius: Radius.elliptical(5.92, 5.92),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_0.arcToPoint(
      Offset(11.839, 25.135),
      radius: Radius.elliptical(5.92, 5.92),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();
    path_0.moveTo(27.04, 19.215000000000003);
    path_0.lineTo(21.119999999999997, 19.215000000000003);
    path_0.arcToPoint(
      Offset(18.160999999999998, 22.175000000000004),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(18.160999999999998, 28.095000000000006);
    path_0.arcToPoint(
      Offset(21.121, 31.054000000000006),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(27.040999999999997, 31.054000000000006);
    path_0.arcToPoint(
      Offset(30, 28.094),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(30, 22.174);
    path_0.arcToPoint(
      Offset(27.04, 19.215),
      radius: Radius.elliptical(2.96, 2.96),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();
    path_0.moveTo(22.865, 1.42);
    path_0.lineTo(18.345999999999997, 9.312999999999999);
    path_0.arcToPoint(
      Offset(19.549999999999997, 11.383999999999999),
      radius: Radius.elliptical(1.38, 1.38),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(28.566999999999997, 11.383999999999999);
    path_0.arcToPoint(
      Offset(29.770999999999997, 9.312999999999999),
      radius: Radius.elliptical(1.381, 1.381),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(25.252, 1.42);
    path_0.arcToPoint(
      Offset(22.865, 1.42),
      radius: Radius.elliptical(1.382, 1.382),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withValues(alpha: 0.7);
    canvas.drawPath(path_0, paint0Fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ModesIconPainter oldDelegate) {
    return false;
  }
}
