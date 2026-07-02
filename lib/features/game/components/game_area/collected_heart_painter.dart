import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CollectedHeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffF02300).withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1478125,
          size.height * 0.04366667,
          size.width * 0.7291667,
          size.height * 0.7291667,
        ),
        bottomRight: Radius.circular(size.width * 0.3645833),
        bottomLeft: Radius.circular(size.width * 0.3645833),
        topLeft: Radius.circular(size.width * 0.3645833),
        topRight: Radius.circular(size.width * 0.3645833),
      ),
      paint0Fill,
    );

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01656250;
    paint1Stroke.color = Color(0xff99210D).withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1395417,
          size.height * 0.03537500,
          size.width * 0.7457292,
          size.height * 0.7457292,
        ),
        bottomRight: Radius.circular(size.width * 0.3728750),
        bottomLeft: Radius.circular(size.width * 0.3728750),
        topLeft: Radius.circular(size.width * 0.3728750),
        topRight: Radius.circular(size.width * 0.3728750),
      ),
      paint1Stroke,
    );

    Path path_2 = Path();
    path_2.moveTo(24.596, 15.063);
    path_2.cubicTo(
      26.157,
      12.777000000000001,
      29.018,
      11.776,
      31.554000000000002,
      12.883000000000001,
    );
    path_2.cubicTo(
      33.696000000000005,
      13.816,
      34.971000000000004,
      15.98,
      35.028000000000006,
      18.283,
    );
    path_2.cubicTo(
      35.031000000000006,
      18.35,
      35.035000000000004,
      18.44,
      35.032000000000004,
      18.53,
    );
    path_2.cubicTo(
      35.032000000000004,
      18.655,
      35.028000000000006,
      18.790000000000003,
      35.016000000000005,
      18.923000000000002,
    );
    path_2.lineTo(35.017, 18.923000000000002);
    path_2.arcToPoint(
      Offset(34.557, 20.939),
      radius: Radius.elliptical(6.615, 6.615),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(33.34, 23.981, 29.953000000000003, 27.719, 24.85, 29.744);
    path_2.lineTo(24.847, 29.745);
    path_2.arcToPoint(
      Offset(24.738, 29.785),
      radius: Radius.elliptical(3.05, 3.05),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(24.596, 29.834);
    path_2.lineTo(24.453, 29.785);
    path_2.arcToPoint(
      Offset(24.345, 29.745),
      radius: Radius.elliptical(3.212, 3.212),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(24.340999999999998, 29.745);
    path_2.cubicTo(
      19.237,
      27.719,
      15.850999999999997,
      23.98,
      14.633999999999997,
      20.937,
    );
    path_2.arcToPoint(
      Offset(14.176999999999996, 18.958000000000002),
      radius: Radius.elliptical(6.512, 6.512),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(14.178999999999997, 18.957);
    path_2.arcToPoint(
      Offset(14.157999999999996, 18.53),
      radius: Radius.elliptical(4.208, 4.208),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      14.155999999999995,
      18.443,
      14.159999999999997,
      18.357000000000003,
      14.162999999999997,
      18.292,
    );
    path_2.cubicTo(
      14.214999999999996,
      16.057000000000002,
      15.413999999999996,
      13.954,
      17.437999999999995,
      12.975000000000001,
    );
    path_2.lineTo(17.636999999999997, 12.883000000000001);
    path_2.cubicTo(
      20.171999999999997,
      11.776000000000002,
      23.032999999999998,
      12.777000000000001,
      24.595999999999997,
      15.063,
    );
    path_2.close();

    Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01827083;
    paint2Stroke.color = Color(0xff99210D).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Stroke);

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFF9393).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(34.594, 18.53);
    path_3.arcToPoint(
      Offset(34.149, 20.774),
      radius: Radius.elliptical(6.175, 6.175),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      32.982,
      23.694000000000003,
      29.692,
      27.351,
      24.689,
      29.337000000000003,
    );
    path_3.lineTo(24.596, 29.370000000000005);
    path_3.arcToPoint(
      Offset(24.502, 29.337000000000003),
      radius: Radius.elliptical(2.6, 2.6),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      19.499,
      27.351000000000003,
      16.209,
      23.694000000000003,
      15.041999999999998,
      20.775000000000006,
    );
    path_3.arcToPoint(
      Offset(14.614999999999998, 18.928000000000004),
      radius: Radius.elliptical(6.072, 6.072),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(14.596999999999998, 18.531000000000006),
      radius: Radius.elliptical(3.692, 3.692),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(14.600999999999997, 18.302000000000007),
      radius: Radius.elliptical(2.35, 2.35),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      14.650999999999998,
      16.144000000000005,
      15.842999999999996,
      14.143000000000008,
      17.810999999999996,
      13.285000000000007,
    );
    path_3.cubicTo(
      20.324999999999996,
      12.187000000000006,
      23.223999999999997,
      13.342000000000008,
      24.573999999999998,
      15.871000000000008,
    );
    path_3.cubicTo(
      24.584,
      15.889000000000008,
      24.607,
      15.889000000000008,
      24.616999999999997,
      15.871000000000008,
    );
    path_3.cubicTo(
      25.967,
      13.341000000000008,
      28.866999999999997,
      12.187000000000008,
      31.379999999999995,
      13.285000000000007,
    );
    path_3.cubicTo(
      33.348,
      14.143000000000008,
      34.53999999999999,
      16.145000000000007,
      34.589999999999996,
      18.302000000000007,
    );
    path_3.arcToPoint(
      Offset(34.593999999999994, 18.531000000000006),
      radius: Radius.elliptical(2.5, 2.5),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffFF9393).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(32.151, 19.322);
    path_4.arcToPoint(
      Offset(31.815000000000005, 21.018),
      radius: Radius.elliptical(4.67, 4.67),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      30.933000000000003,
      23.224,
      28.446000000000005,
      25.987000000000002,
      24.665000000000006,
      27.488,
    );
    path_4.arcToPoint(
      Offset(24.595000000000006, 27.512999999999998),
      radius: Radius.elliptical(1.984, 1.984),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.arcToPoint(
      Offset(24.525000000000006, 27.488),
      radius: Radius.elliptical(2.057, 2.057),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      20.743000000000006,
      25.987,
      18.256000000000007,
      23.223,
      17.375000000000007,
      21.018,
    );
    path_4.arcToPoint(
      Offset(17.051000000000005, 19.621000000000002),
      radius: Radius.elliptical(4.582, 4.582),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      17.041000000000004,
      19.522000000000002,
      17.038000000000004,
      19.421000000000003,
      17.038000000000004,
      19.321,
    );
    path_4.cubicTo(
      17.035000000000004,
      19.264000000000003,
      17.038000000000004,
      19.205000000000002,
      17.041000000000004,
      19.148000000000003,
    );
    path_4.cubicTo(
      17.079000000000004,
      17.518000000000004,
      17.981000000000005,
      16.005000000000003,
      19.467000000000006,
      15.357000000000003,
    );
    path_4.cubicTo(
      21.367000000000004,
      14.527000000000003,
      23.558000000000007,
      15.399000000000003,
      24.579000000000008,
      17.311000000000003,
    );
    path_4.cubicTo(
      24.587000000000007,
      17.325000000000003,
      24.60300000000001,
      17.325000000000003,
      24.611000000000008,
      17.311000000000003,
    );
    path_4.cubicTo(
      25.631000000000007,
      15.399000000000004,
      27.823000000000008,
      14.527000000000005,
      29.72200000000001,
      15.357000000000003,
    );
    path_4.cubicTo(
      31.210000000000008,
      16.005000000000003,
      32.11200000000001,
      17.517000000000003,
      32.14900000000001,
      19.148000000000003,
    );
    path_4.cubicTo(
      32.15100000000001,
      19.205000000000002,
      32.15400000000001,
      19.265000000000004,
      32.15100000000001,
      19.322000000000003,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffFF9393).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(16.754, 16.65);
    path_5.arcToPoint(
      Offset(18.374000000000002, 15.030999999999999),
      radius: Radius.elliptical(1.62, 1.62),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_5.lineTo(20.533, 15.030999999999999);
    path_5.cubicTo(
      21.427,
      15.030999999999999,
      22.153000000000002,
      15.755999999999998,
      22.153000000000002,
      16.651,
    );
    path_5.lineTo(22.153000000000002, 19.89);
    path_5.arcToPoint(
      Offset(20.533, 21.509),
      radius: Radius.elliptical(1.62, 1.62),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_5.lineTo(18.373, 21.509);
    path_5.arcToPoint(
      Offset(16.754, 19.889),
      radius: Radius.elliptical(1.62, 1.62),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_5.lineTo(16.754, 16.651);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5964583, size.height * 0.1669583),
      Offset(size.width * 0.6525000, size.height * 0.4364583),
      [Color(0xffffffff).withValues(alpha: 1), Color(0xffffffff).withValues(alpha: 0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_5, paint5Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
