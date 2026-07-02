import 'package:flutter/material.dart';

class GemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.583, 11.083);
    path_0.lineTo(11.083, 21.583);
    path_0.lineTo(21.583, 11.082999999999998);
    path_0.lineTo(11.082999999999998, 0.5829999999999984);
    path_0.lineTo(0.5829999999999984, 11.082999999999998);
    path_0.close();

    // Add a small shadow behind the gem
    canvas.drawShadow(path_0, Colors.black, 3.0, false);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xff63EAD1).withValues(alpha: 1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0.17, 10.67);
    path_1.arcToPoint(
      Offset(0.17, 11.496),
      radius: Radius.elliptical(0.583, 0.583),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(10.67, 21.996000000000002);
    path_1.arcToPoint(
      Offset(11.496, 21.996000000000002),
      radius: Radius.elliptical(0.583, 0.583),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(21.996000000000002, 11.496000000000002);
    path_1.arcToPoint(
      Offset(21.996000000000002, 10.671000000000003),
      radius: Radius.elliptical(0.583, 0.583),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(11.496, 0.17);
    path_1.arcToPoint(
      Offset(10.671000000000001, 0.17),
      radius: Radius.elliptical(0.583, 0.583),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(0.17, 10.67);
    path_1.close();
    path_1.moveTo(0.583, 11.083);
    path_1.lineTo(11.083, 21.583);
    path_1.lineTo(21.583, 11.082999999999998);
    path_1.lineTo(11.082999999999998, 0.5829999999999984);
    path_1.lineTo(0.5829999999999984, 11.082999999999998);
    path_1.close();

    Path path_2 = Path();
    path_2.moveTo(14.292, 13.708);
    path_2.arcToPoint(
      Offset(13.709, 13.708),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(14.292, 13.708),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(14.292, 14.875);
    path_2.arcToPoint(
      Offset(13.709, 14.875),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(14.292, 14.875),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(13.124, 16.04);
    path_2.arcToPoint(
      Offset(12.541, 16.04),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(13.124, 16.04),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(12.25, 17.208);
    path_2.arcToPoint(
      Offset(11.667, 17.208),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(12.25, 17.208),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(12.834, 12.832999999999998);
    path_2.arcToPoint(
      Offset(12.251, 12.832999999999998),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(12.834, 12.832999999999998),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(15.75, 11.957999999999998);
    path_2.arcToPoint(
      Offset(15.167, 11.957999999999998),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(15.75, 11.957999999999998),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(14.291, 12.104);
    path_2.arcToPoint(
      Offset(13.416, 12.104),
      radius: Radius.elliptical(0.438, 0.438),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(14.291, 12.104),
      radius: Radius.elliptical(0.438, 0.438),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();
    path_2.moveTo(13.126000000000001, 14.729);
    path_2.arcToPoint(
      Offset(12.250000000000002, 14.729),
      radius: Radius.elliptical(0.438, 0.438),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(13.126000000000001, 14.729),
      radius: Radius.elliptical(0.438, 0.438),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xff50D5BC).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(0.583, 11.083);
    path_3.lineTo(11.083, 0.5830000000000002);
    path_3.lineTo(21.583, 11.083);
    path_3.lineTo(0.5829999999999984, 11.083);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xff77F9E1).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(11.06, 1.777);
    path_4.cubicTo(
      11.206000000000001,
      1.845,
      11.270000000000001,
      2.019,
      11.202,
      2.165,
    );
    path_4.lineTo(7.263999999999999, 10.623000000000001);
    path_4.arcToPoint(
      Offset(6.734999999999999, 10.377),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.lineTo(10.673, 1.9190000000000005);
    path_4.arcToPoint(
      Offset(11.06, 1.7770000000000006),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffDFFFF9).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(5.833, 11.083);
    path_5.lineTo(11.083, 21.583);
    path_5.lineTo(0.5830000000000002, 11.082999999999998);
    path_5.lineTo(11.083, 0.5829999999999984);
    path_5.lineTo(5.833, 11.082999999999998);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xff5AD9C2).withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(2.916, 11.083);
    path_6.lineTo(11.083, 21.583);
    path_6.lineTo(0.5830000000000002, 11.082999999999998);
    path_6.lineTo(11.083, 0.5829999999999984);
    path_6.lineTo(2.9160000000000004, 11.082999999999998);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xff84F8E3).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(5.833, 11.083);
    path_7.lineTo(11.083, 0.5830000000000002);
    path_7.lineTo(0.5830000000000002, 11.083);
    path_7.lineTo(5.833, 11.083);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xff7AEED9).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(2.916, 11.083);
    path_8.lineTo(11.083, 0.5830000000000002);
    path_8.lineTo(0.5830000000000002, 11.083);
    path_8.lineTo(2.9160000000000004, 11.083);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffB1FFF1).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(16.333, 11.083);
    path_9.lineTo(11.082999999999998, 21.583);
    path_9.lineTo(21.583, 11.082999999999998);
    path_9.lineTo(11.082999999999998, 0.5829999999999984);
    path_9.lineTo(16.333, 11.082999999999998);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xff2E90A6).withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(16.333, 11.083);
    path_10.lineTo(11.082999999999998, 0.5830000000000002);
    path_10.lineTo(21.583, 11.083);
    path_10.lineTo(16.333, 11.083);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xff4AACC2).withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(19.25, 11.083);
    path_11.lineTo(11.083, 21.583);
    path_11.lineTo(21.583, 11.082999999999998);
    path_11.lineTo(11.082999999999998, 0.5829999999999984);
    path_11.lineTo(19.25, 11.082999999999998);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xff1EB5AC).withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(19.25, 11.083);
    path_12.lineTo(11.083, 0.583);
    path_12.lineTo(21.583, 11.083);
    path_12.lineTo(19.25, 11.083);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xff30CFC6).withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(6.324, 5.912);
    path_13.cubicTo(6.441, 6.022, 6.4479999999999995, 6.207, 6.338, 6.325);
    path_13.lineTo(2.254, 10.7);
    path_13.arcToPoint(
      Offset(1.828, 10.302),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_13.lineTo(5.9110000000000005, 5.927);
    path_13.arcToPoint(
      Offset(6.324000000000001, 5.912),
      radius: Radius.elliptical(0.292, 0.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xffffffff).withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
