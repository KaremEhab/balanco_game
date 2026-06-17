import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GameplayHeartPainter extends CustomPainter {
  final int hearts;
  GameplayHeartPainter({this.hearts = 3});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(119.921, 51.214);
    path_0.lineTo(119.921, 54.958999999999996);
    path_0.lineTo(30.649, 54.958999999999996);
    path_0.lineTo(30.649, 51.214);
    path_0.cubicTo(30.649, 44.579, 36.882, 39.716, 43.315, 41.336999999999996);
    path_0.lineTo(53.269, 43.836999999999996);
    path_0.cubicTo(
      56.033,
      44.528999999999996,
      58.597,
      42.19199999999999,
      58.157,
      39.376999999999995,
    );
    path_0.lineTo(58.157, 39.339);
    path_0.cubicTo(57.88099999999999, 37.542, 59.565, 36.085, 61.324, 36.562);
    path_0.cubicTo(
      65.911,
      37.830999999999996,
      69.881,
      37.982,
      72.77199999999999,
      35.995999999999995,
    );
    path_0.arcToPoint(
      Offset(77.79799999999999, 35.995999999999995),
      radius: Radius.elliptical(4.385, 4.385),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      80.68799999999999,
      37.980999999999995,
      84.64699999999999,
      37.830999999999996,
      89.24599999999998,
      36.562,
    );
    path_0.cubicTo(
      91.00599999999999,
      36.083999999999996,
      92.68899999999998,
      37.541999999999994,
      92.41199999999998,
      39.339,
    );
    path_0.lineTo(92.39899999999997, 39.376999999999995);
    path_0.cubicTo(
      91.95899999999997,
      42.19199999999999,
      94.53599999999997,
      44.528999999999996,
      97.28799999999997,
      43.836999999999996,
    );
    path_0.lineTo(107.23999999999997, 41.336999999999996);
    path_0.cubicTo(
      113.67599999999996,
      39.715999999999994,
      119.92099999999996,
      44.58,
      119.92099999999996,
      51.214,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(119.916, 51.205);
    path_1.lineTo(119.916, 54.964);
    path_1.lineTo(30.638, 54.964);
    path_1.lineTo(30.638, 51.204);
    path_1.cubicTo(30.638, 44.577, 36.884, 39.722, 43.306, 41.328);
    path_1.lineTo(53.262, 43.834);
    path_1.arcToPoint(
      Offset(58.147, 40.682),
      radius: Radius.elliptical(3.955, 3.955),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.arcToPoint(
      Offset(58.157, 39.38),
      radius: Radius.elliptical(3.84, 3.84),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.lineTo(58.157, 39.34);
    path_1.cubicTo(
      57.882,
      37.540000000000006,
      59.565999999999995,
      36.09,
      61.327,
      36.56,
    );
    path_1.cubicTo(
      65.919,
      37.833000000000006,
      69.884,
      37.99,
      72.77199999999999,
      35.993,
    );
    path_1.arcToPoint(
      Offset(77.80199999999999, 35.993),
      radius: Radius.elliptical(4.387, 4.387),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.cubicTo(
      80.68199999999999,
      37.99,
      84.645,
      37.833000000000006,
      89.246,
      36.561,
    );
    path_1.cubicTo(91.009, 36.091, 92.692, 37.539, 92.41799999999999, 39.341);
    path_1.lineTo(92.398, 39.38);
    path_1.cubicTo(
      92.378,
      39.547000000000004,
      92.359,
      39.712,
      92.35,
      39.870000000000005,
    );
    path_1.cubicTo(
      92.262,
      42.45400000000001,
      94.69999999999999,
      44.50000000000001,
      97.29299999999999,
      43.834,
    );
    path_1.lineTo(107.249, 41.329);
    path_1.cubicTo(113.67, 39.722, 119.916, 44.577, 119.916, 51.205);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4952434, size.height * 0.1954706),
      Offset(size.width * 0.4952434, size.height * 0.4445714),
      [Color(0xffF8AE00).withOpacity(1), Color(0xffF8AE00).withOpacity(0)],
      [0.216, 0.923],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(57.992, 41.238);
    path_2.cubicTo(57.370999999999995, 43.12, 55.388, 44.371, 53.274, 43.838);
    path_2.lineTo(43.321, 41.338);
    path_2.cubicTo(
      36.888,
      39.716,
      30.654999999999998,
      44.58,
      30.654999999999998,
      51.214,
    );
    path_2.lineTo(30.654999999999998, 51.704);
    path_2.cubicTo(30.654999999999998, 45.069, 36.888, 40.206, 43.321, 41.827);
    path_2.lineTo(53.274, 44.327);
    path_2.cubicTo(55.566, 44.903999999999996, 57.719, 43.382, 58.132, 41.238);
    path_2.lineTo(57.992, 41.238);
    path_2.close();
    path_2.moveTo(58.166, 39.085);
    path_2.cubicTo(58.378, 37.651, 59.81999999999999, 36.644, 61.33, 37.052);
    path_2.cubicTo(65.916, 38.322, 69.887, 38.472, 72.77799999999999, 36.486);
    path_2.arcToPoint(
      Offset(77.80399999999999, 36.486),
      radius: Radius.elliptical(4.386, 4.386),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      80.69399999999999,
      38.471999999999994,
      84.65399999999998,
      38.321,
      89.25199999999998,
      37.052,
    );
    path_2.cubicTo(
      90.76199999999999,
      36.644,
      92.20399999999998,
      37.652,
      92.41599999999998,
      39.085,
    );
    path_2.lineTo(92.42899999999999, 39.085);
    path_2.cubicTo(
      92.51899999999999,
      37.408,
      90.92699999999999,
      36.103,
      89.25199999999998,
      36.562,
    );
    path_2.cubicTo(
      84.65199999999999,
      37.830999999999996,
      80.69499999999998,
      37.982,
      77.80499999999998,
      35.995999999999995,
    );
    path_2.arcToPoint(
      Offset(72.77699999999997, 35.995999999999995),
      radius: Radius.elliptical(4.386, 4.386),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.cubicTo(
      69.88699999999997,
      37.980999999999995,
      65.91699999999997,
      37.830999999999996,
      61.32999999999997,
      36.562,
    );
    path_2.cubicTo(
      59.65499999999997,
      36.102,
      58.06199999999997,
      37.407999999999994,
      58.15299999999997,
      39.085,
    );
    path_2.lineTo(58.16599999999997, 39.085);
    path_2.close();
    path_2.moveTo(107.24799999999999, 41.337);
    path_2.lineTo(97.29499999999999, 43.837);
    path_2.cubicTo(
      95.192,
      44.372,
      93.20299999999999,
      43.120000000000005,
      92.57799999999999,
      41.237,
    );
    path_2.lineTo(92.43799999999999, 41.237);
    path_2.cubicTo(
      92.85399999999998,
      43.381,
      95.01399999999998,
      44.903,
      97.29599999999999,
      44.327,
    );
    path_2.lineTo(107.24799999999999, 41.827);
    path_2.cubicTo(
      113.68199999999999,
      40.205999999999996,
      119.92699999999999,
      45.068999999999996,
      119.92699999999999,
      51.704,
    );
    path_2.lineTo(119.92699999999999, 51.214);
    path_2.cubicTo(
      119.92699999999999,
      44.58,
      113.68199999999999,
      39.717,
      107.24799999999999,
      41.336999999999996,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(119.921, 51.277);
    path_3.lineTo(112.57400000000001, 51.277);
    path_3.cubicTo(
      103.37300000000002,
      51.277,
      94.27800000000002,
      48.217,
      87.477,
      42.019000000000005,
    );
    path_3.arcToPoint(
      Offset(75.148, 37.251000000000005),
      radius: Radius.elliptical(18.237, 18.237),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.arcToPoint(
      Offset(62.818999999999996, 42.025000000000006),
      radius: Radius.elliptical(18.238, 18.238),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.cubicTo(
      56.022,
      48.22200000000001,
      46.92699999999999,
      51.278000000000006,
      37.729,
      51.278000000000006,
    );
    path_3.lineTo(30.649, 51.278000000000006);
    path_3.lineTo(30.649, 54.959);
    path_3.lineTo(56.853, 54.959);
    path_3.lineTo(56.853, 54.964000000000006);
    path_3.lineTo(93.445, 54.964000000000006);
    path_3.lineTo(93.44399999999999, 54.959);
    path_3.lineTo(119.91999999999999, 54.959);
    path_3.lineTo(119.92099999999999, 51.277);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(91.558, 54.959);
    path_4.lineTo(58.996, 54.959);
    path_4.cubicTo(59.154, 46.099000000000004, 66.374, 38.966, 75.286, 38.966);
    path_4.cubicTo(
      84.181,
      38.966,
      91.401,
      46.099000000000004,
      91.55799999999999,
      54.959,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(91.558, 54.959);
    path_5.lineTo(58.996, 54.959);
    path_5.cubicTo(59.154, 46.099000000000004, 66.374, 38.966, 75.286, 38.966);
    path_5.cubicTo(
      84.181,
      38.966,
      91.401,
      46.099000000000004,
      91.55799999999999,
      54.959,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(91.558, 54.959);
    path_6.lineTo(58.996, 54.959);
    path_6.cubicTo(59.154, 46.099000000000004, 66.374, 38.966, 75.286, 38.966);
    path_6.cubicTo(
      84.181,
      38.966,
      91.401,
      46.099000000000004,
      91.55799999999999,
      54.959,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4952434, size.height * 0.2716050),
      Offset(size.width * 0.4952434, size.height * 0.4343361),
      [Color(0xffF8AE00).withOpacity(hearts >= 3 ? 1.0 : 0.2), Color(0xffF8AE00).withOpacity(0)],
      [0.29, 0.923],
    );
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(91.567, 54.96);
    path_7.lineTo(91.46199999999999, 54.96);
    path_7.cubicTo(
      90.55499999999999,
      46.832,
      83.66599999999998,
      40.519,
      75.29399999999998,
      40.519,
    );
    path_7.cubicTo(
      66.90499999999999,
      40.519,
      60.015999999999984,
      46.832,
      59.10899999999998,
      54.958999999999996,
    );
    path_7.lineTo(59.00499999999998, 54.958999999999996);
    path_7.cubicTo(
      59.16199999999998,
      46.099,
      66.38199999999998,
      38.965999999999994,
      75.29499999999999,
      38.965999999999994,
    );
    path_7.cubicTo(
      84.18999999999998,
      38.965999999999994,
      91.40999999999998,
      46.099,
      91.56699999999998,
      54.959999999999994,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(46.794, 88.02);
    path_8.lineTo(46.794, 85.62899999999999);
    path_8.lineTo(103.77699999999999, 85.62899999999999);
    path_8.lineTo(103.77699999999999, 88.01899999999999);
    path_8.cubicTo(
      103.77699999999999,
      92.255,
      99.79899999999999,
      95.359,
      95.69099999999999,
      94.32399999999998,
    );
    path_8.lineTo(89.33899999999998, 92.72799999999998);
    path_8.arcToPoint(
      Offset(86.21899999999998, 95.57499999999997),
      radius: Radius.elliptical(2.53, 2.53),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.lineTo(86.21899999999998, 95.59899999999998);
    path_8.cubicTo(
      86.39399999999998,
      96.74599999999998,
      85.31999999999998,
      97.67699999999998,
      84.19699999999997,
      97.37199999999997,
    );
    path_8.cubicTo(
      81.26899999999998,
      96.56199999999997,
      78.73399999999998,
      96.46499999999997,
      76.88999999999997,
      97.73199999999997,
    );
    path_8.arcToPoint(
      Offset(73.68199999999997, 97.73199999999997),
      radius: Radius.elliptical(2.8, 2.8),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.cubicTo(
      71.83599999999997,
      96.46499999999997,
      69.30999999999997,
      96.56199999999997,
      66.37399999999997,
      97.37199999999997,
    );
    path_8.cubicTo(
      65.25099999999996,
      97.67699999999998,
      64.17599999999997,
      96.74599999999997,
      64.35399999999997,
      95.59899999999998,
    );
    path_8.lineTo(64.36099999999998, 95.57499999999997);
    path_8.cubicTo(
      64.64099999999998,
      93.77899999999997,
      62.99699999999998,
      92.28699999999998,
      61.24099999999998,
      92.72799999999998,
    );
    path_8.lineTo(54.88799999999998, 94.32399999999998);
    path_8.cubicTo(
      50.77999999999998,
      95.35899999999998,
      46.793999999999976,
      92.25399999999999,
      46.793999999999976,
      88.01899999999998,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(46.798, 88.024);
    path_9.lineTo(46.798, 85.626);
    path_9.lineTo(103.78, 85.626);
    path_9.lineTo(103.78, 88.024);
    path_9.cubicTo(103.78, 92.253, 99.796, 95.356, 95.695, 94.328);
    path_9.lineTo(89.341, 92.732);
    path_9.arcToPoint(
      Offset(86.219, 95.572),
      radius: Radius.elliptical(2.523, 2.523),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(86.219, 95.60000000000001);
    path_9.cubicTo(
      86.39399999999999,
      96.74600000000001,
      85.318,
      97.676,
      84.192,
      97.37200000000001,
    );
    path_9.cubicTo(
      81.26499999999999,
      96.55900000000001,
      78.72999999999999,
      96.46200000000002,
      76.889,
      97.73400000000001,
    );
    path_9.arcToPoint(
      Offset(73.679, 97.73400000000001),
      radius: Radius.elliptical(2.798, 2.798),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.cubicTo(71.839, 96.462, 69.313, 96.56, 66.375, 97.37200000000001);
    path_9.cubicTo(
      65.25,
      97.67600000000002,
      64.173,
      96.74600000000001,
      64.349,
      95.60000000000001,
    );
    path_9.lineTo(64.35900000000001, 95.572);
    path_9.cubicTo(
      64.64200000000001,
      93.78,
      62.99800000000001,
      92.282,
      61.23600000000001,
      92.732,
    );
    path_9.lineTo(54.88200000000001, 94.328);
    path_9.cubicTo(
      50.78200000000001,
      95.35600000000001,
      46.798000000000016,
      92.253,
      46.798000000000016,
      88.024,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4953224, size.height * 0.8895966),
      Offset(size.width * 0.4953224, size.height * 0.7305966),
      [Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2), Color(0xffF8AE00).withOpacity(0)],
      [0.216, 0.923],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(86.323, 94.387);
    path_10.cubicTo(86.719, 93.187, 87.985, 92.387, 89.335, 92.728);
    path_10.lineTo(95.687, 94.32499999999999);
    path_10.cubicTo(
      99.795,
      95.359,
      103.773,
      92.255,
      103.773,
      88.01999999999998,
    );
    path_10.lineTo(103.773, 87.70699999999998);
    path_10.cubicTo(
      103.773,
      91.94299999999998,
      99.795,
      95.04699999999998,
      95.687,
      94.01199999999997,
    );
    path_10.lineTo(89.335, 92.41499999999998);
    path_10.cubicTo(
      87.871,
      92.04799999999997,
      86.497,
      93.01899999999998,
      86.23299999999999,
      94.38699999999997,
    );
    path_10.lineTo(86.323, 94.38699999999997);
    path_10.close();
    path_10.moveTo(86.213, 95.762);
    path_10.arcToPoint(
      Offset(84.193, 97.059),
      radius: Radius.elliptical(1.606, 1.606),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.cubicTo(81.265, 96.249, 78.73, 96.15299999999999, 76.886, 97.419);
    path_10.arcToPoint(
      Offset(73.67699999999999, 97.419),
      radius: Radius.elliptical(2.8, 2.8),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.cubicTo(71.832, 96.152, 69.306, 96.249, 66.36999999999999, 97.059);
    path_10.arcToPoint(
      Offset(64.35, 95.762),
      radius: Radius.elliptical(1.606, 1.606),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.lineTo(64.34299999999999, 95.762);
    path_10.cubicTo(
      64.28499999999998,
      96.832,
      65.30199999999999,
      97.665,
      66.36999999999999,
      97.372,
    );
    path_10.cubicTo(
      69.30599999999998,
      96.562,
      71.83299999999998,
      96.466,
      73.67699999999999,
      97.733,
    );
    path_10.arcToPoint(
      Offset(76.886, 97.733),
      radius: Radius.elliptical(2.8, 2.8),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_10.cubicTo(78.731, 96.46600000000001, 81.265, 96.563, 84.193, 97.373);
    path_10.cubicTo(
      85.261,
      97.66600000000001,
      86.27799999999999,
      96.833,
      86.22,
      95.762,
    );
    path_10.lineTo(86.213, 95.762);
    path_10.close();
    path_10.moveTo(54.882999999999996, 94.325);
    path_10.lineTo(61.236, 92.72800000000001);
    path_10.cubicTo(
      62.577999999999996,
      92.388,
      63.848,
      93.186,
      64.246,
      94.38700000000001,
    );
    path_10.lineTo(64.336, 94.38700000000001);
    path_10.cubicTo(
      64.071,
      93.01900000000002,
      62.692,
      92.04700000000001,
      61.236,
      92.41500000000002,
    );
    path_10.lineTo(54.882999999999996, 94.01200000000001);
    path_10.cubicTo(
      50.775999999999996,
      95.04700000000001,
      46.78999999999999,
      91.94200000000002,
      46.78999999999999,
      87.70700000000002,
    );
    path_10.lineTo(46.78999999999999, 88.02000000000002);
    path_10.cubicTo(
      46.78999999999999,
      92.25500000000002,
      50.77599999999999,
      95.35900000000002,
      54.882999999999996,
      94.32500000000002,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(46.794, 87.979);
    path_11.lineTo(51.483999999999995, 87.979);
    path_11.cubicTo(
      57.35699999999999,
      87.979,
      63.163,
      89.932,
      67.50399999999999,
      93.889,
    );
    path_11.arcToPoint(
      Offset(75.374, 96.932),
      radius: Radius.elliptical(11.641, 11.641),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_11.arcToPoint(
      Offset(83.243, 93.884),
      radius: Radius.elliptical(11.64, 11.64),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_11.cubicTo(87.58099999999999, 89.928, 93.386, 87.978, 99.258, 87.978);
    path_11.lineTo(103.777, 87.978);
    path_11.lineTo(103.777, 85.628);
    path_11.lineTo(87.051, 85.628);
    path_11.lineTo(87.051, 85.625);
    path_11.lineTo(63.693, 85.625);
    path_11.lineTo(63.693, 85.628);
    path_11.lineTo(46.793, 85.628);
    path_11.lineTo(46.793, 87.978);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xffF68B55).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(64.898, 85.629);
    path_12.lineTo(85.68299999999999, 85.629);
    path_12.arcToPoint(
      Offset(75.285, 95.83800000000001),
      radius: Radius.elliptical(10.393, 10.393),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_12.cubicTo(
      69.607,
      95.83800000000001,
      64.99799999999999,
      91.284,
      64.898,
      85.62800000000001,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(64.898, 85.629);
    path_13.lineTo(85.68299999999999, 85.629);
    path_13.arcToPoint(
      Offset(75.285, 95.83800000000001),
      radius: Radius.elliptical(10.393, 10.393),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_13.cubicTo(
      69.607,
      95.83800000000001,
      64.99799999999999,
      91.284,
      64.898,
      85.62800000000001,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(64.898, 85.629);
    path_14.lineTo(85.68299999999999, 85.629);
    path_14.arcToPoint(
      Offset(75.285, 95.83800000000001),
      radius: Radius.elliptical(10.393, 10.393),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.cubicTo(
      69.607,
      95.83800000000001,
      64.99799999999999,
      91.284,
      64.898,
      85.62800000000001,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4953289, size.height * 0.8410000),
      Offset(size.width * 0.4953289, size.height * 0.7371261),
      [Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2), Color(0xffF8AE00).withOpacity(0)],
      [0.29, 0.923],
    );
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(64.893, 85.629);
    path_15.lineTo(64.959, 85.629);
    path_15.cubicTo(
      65.538,
      90.81700000000001,
      69.936,
      94.84700000000001,
      75.279,
      94.84700000000001,
    );
    path_15.cubicTo(
      80.634,
      94.84700000000001,
      85.03099999999999,
      90.81700000000001,
      85.61,
      85.629,
    );
    path_15.lineTo(85.67699999999999, 85.629);
    path_15.arcToPoint(
      Offset(75.279, 95.83800000000001),
      radius: Radius.elliptical(10.393, 10.393),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.cubicTo(
      69.602,
      95.83800000000001,
      64.993,
      91.284,
      64.893,
      85.62800000000001,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(94.048, 30.486);
    path_16.arcToPoint(
      Offset(93.223, 34.644),
      radius: Radius.elliptical(11.441, 11.441),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.cubicTo(
      91.06099999999999,
      40.051,
      84.967,
      46.824999999999996,
      75.69800000000001,
      50.504,
    );
    path_16.arcToPoint(
      Offset(75.52600000000001, 50.567),
      radius: Radius.elliptical(3.724, 3.724),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.cubicTo(
      75.46600000000001,
      50.547,
      75.406,
      50.525,
      75.35300000000001,
      50.505,
    );
    path_16.cubicTo(
      66.084,
      46.826,
      59.99000000000001,
      40.051,
      57.82800000000001,
      34.645,
    );
    path_16.arcToPoint(
      Offset(57.03600000000001, 31.222),
      radius: Radius.elliptical(11.25, 11.25),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.arcToPoint(
      Offset(57.00300000000001, 30.486),
      radius: Radius.elliptical(6.836, 6.836),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.cubicTo(
      56.99600000000001,
      30.347,
      57.00300000000001,
      30.202,
      57.010000000000005,
      30.063000000000002,
    );
    path_16.cubicTo(
      57.10300000000001,
      26.065,
      59.312000000000005,
      22.359,
      62.958000000000006,
      20.769000000000002,
    );
    path_16.cubicTo(
      67.61500000000001,
      18.735000000000003,
      72.985,
      20.873,
      75.486,
      25.559,
    );
    path_16.cubicTo(75.506, 25.594, 75.546, 25.594, 75.566, 25.559);
    path_16.cubicTo(
      78.06700000000001,
      20.873,
      83.436,
      18.735,
      88.09400000000001,
      20.769000000000002,
    );
    path_16.cubicTo(
      91.74000000000001,
      22.359,
      93.94900000000001,
      26.065,
      94.042,
      30.063000000000002,
    );
    path_16.cubicTo(94.048, 30.202, 94.054, 30.347, 94.048, 30.486);
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = Color(0xffF22828).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(94.048, 30.486);
    path_17.arcToPoint(
      Offset(93.223, 34.644),
      radius: Radius.elliptical(11.441, 11.441),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_17.cubicTo(
      91.06099999999999,
      40.051,
      84.967,
      46.824999999999996,
      75.69800000000001,
      50.504,
    );
    path_17.arcToPoint(
      Offset(75.52600000000001, 50.567),
      radius: Radius.elliptical(3.724, 3.724),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_17.cubicTo(
      75.46600000000001,
      50.547,
      75.406,
      50.525,
      75.35300000000001,
      50.505,
    );
    path_17.cubicTo(
      66.084,
      46.826,
      59.99000000000001,
      40.051,
      57.82800000000001,
      34.645,
    );
    path_17.arcToPoint(
      Offset(57.03600000000001, 31.222),
      radius: Radius.elliptical(11.25, 11.25),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_17.arcToPoint(
      Offset(57.00300000000001, 30.486),
      radius: Radius.elliptical(6.836, 6.836),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_17.cubicTo(
      56.99600000000001,
      30.347,
      57.00300000000001,
      30.202,
      57.010000000000005,
      30.063000000000002,
    );
    path_17.cubicTo(
      57.10300000000001,
      26.065,
      59.312000000000005,
      22.359,
      62.958000000000006,
      20.769000000000002,
    );
    path_17.cubicTo(
      67.61500000000001,
      18.735000000000003,
      72.985,
      20.873,
      75.486,
      25.559,
    );
    path_17.cubicTo(75.506, 25.594, 75.546, 25.594, 75.566, 25.559);
    path_17.cubicTo(
      78.06700000000001,
      20.873,
      83.436,
      18.735,
      88.09400000000001,
      20.769000000000002,
    );
    path_17.cubicTo(
      91.74000000000001,
      22.359,
      93.94900000000001,
      26.065,
      94.042,
      30.063000000000002,
    );
    path_17.cubicTo(94.048, 30.202, 94.054, 30.347, 94.048, 30.486);
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = Color(0xffF22828).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(89.524, 31.952);
    path_18.arcToPoint(
      Offset(88.901, 35.094),
      radius: Radius.elliptical(8.656, 8.656),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_18.cubicTo(87.26599999999999, 39.18, 82.66, 44.299, 75.655, 47.08);
    path_18.lineTo(75.525, 47.126999999999995);
    path_18.arcToPoint(
      Offset(75.394, 47.08),
      radius: Radius.elliptical(3.732, 3.732),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_18.cubicTo(
      68.38900000000001,
      44.3,
      63.783,
      39.18,
      62.14900000000001,
      35.092999999999996,
    );
    path_18.arcToPoint(
      Offset(61.55000000000001, 32.507),
      radius: Radius.elliptical(8.486, 8.486),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_18.arcToPoint(
      Offset(61.52600000000001, 31.950999999999997),
      radius: Radius.elliptical(5.283, 5.283),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_18.cubicTo(
      61.52000000000001,
      31.845999999999997,
      61.52600000000001,
      31.734999999999996,
      61.53100000000001,
      31.630999999999997,
    );
    path_18.cubicTo(
      61.60100000000001,
      28.609999999999996,
      63.271000000000015,
      25.807999999999996,
      66.02600000000001,
      24.606999999999996,
    );
    path_18.cubicTo(
      69.546,
      23.068999999999996,
      73.60400000000001,
      24.684999999999995,
      75.495,
      28.226999999999997,
    );
    path_18.cubicTo(
      75.51,
      28.252999999999997,
      75.54,
      28.252999999999997,
      75.555,
      28.226999999999997,
    );
    path_18.cubicTo(
      77.44500000000001,
      24.684999999999995,
      81.50500000000001,
      23.068999999999996,
      85.024,
      24.606999999999996,
    );
    path_18.cubicTo(
      87.779,
      25.807999999999996,
      89.449,
      28.608999999999995,
      89.519,
      31.630999999999997,
    );
    path_18.cubicTo(
      89.524,
      31.735999999999997,
      89.52900000000001,
      31.845999999999997,
      89.524,
      31.950999999999997,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = Color(0xffF22828).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(61, 27);
    path_19.arcToPoint(
      Offset(64, 24),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_19.lineTo(68, 24);
    path_19.arcToPoint(
      Offset(71, 27),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_19.lineTo(71, 33);
    path_19.arcToPoint(
      Offset(68, 36),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_19.lineTo(64, 36);
    path_19.arcToPoint(
      Offset(61, 33),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_19.lineTo(61, 27);
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5460526, size.height * 0.09243697),
      Offset(size.width * 0.5788289, size.height * 0.2938151),
      [Color(0xffF8AE00).withOpacity(hearts >= 2 ? 1.0 : 0.2), Color(0xffF8AE00).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(125.395, 53.945);
    path_20.lineTo(26.652, 53.945);
    path_20.cubicTo(25.8, 53.945, 25.017, 54.405, 24.577, 55.14);
    path_20.cubicTo(23.69, 56.617, 24.459000000000003, 85.33, 24.567, 85.516);
    path_20.arcToPoint(
      Offset(26.642, 86.7),
      radius: Radius.elliptical(2.42, 2.42),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_20.lineTo(125.395, 86.7);
    path_20.arcToPoint(
      Offset(127.813, 84.282),
      radius: Radius.elliptical(2.422, 2.422),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_20.lineTo(127.813, 56.373);
    path_20.arcToPoint(
      Offset(125.395, 53.945),
      radius: Radius.elliptical(2.426, 2.426),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_20, paint20Fill);

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1598684,
          size.height * 0.4537815,
          size.width * 0.6809211,
          size.height * 0.2731092,
        ),
        bottomRight: Radius.circular(size.width * 0.02631579),
        bottomLeft: Radius.circular(size.width * 0.02631579),
        topLeft: Radius.circular(size.width * 0.02631579),
        topRight: Radius.circular(size.width * 0.02631579),
      ),
      paint21Fill,
    );

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = Color(0xffF22828).withOpacity(hearts >= 2 ? 1.0 : 0.2);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1927632,
          size.height * 0.4852941,
          size.width * 0.1831118,
          size.height * 0.2100840,
        ),
        bottomRight: Radius.circular(size.width * 0.01315789),
        bottomLeft: Radius.circular(size.width * 0.01315789),
        topLeft: Radius.circular(size.width * 0.01315789),
        topRight: Radius.circular(size.width * 0.01315789),
      ),
      paint22Fill,
    );

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = Color(0xffF22828).withOpacity(hearts >= 3 ? 1.0 : 0.2);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.4087697,
          size.height * 0.4852941,
          size.width * 0.1831118,
          size.height * 0.2100840,
        ),
        bottomRight: Radius.circular(size.width * 0.01315789),
        bottomLeft: Radius.circular(size.width * 0.01315789),
        topLeft: Radius.circular(size.width * 0.01315789),
        topRight: Radius.circular(size.width * 0.01315789),
      ),
      paint23Fill,
    );

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = Color(0xffF22828).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.6247829,
          size.height * 0.4852941,
          size.width * 0.1831118,
          size.height * 0.2100840,
        ),
        bottomRight: Radius.circular(size.width * 0.01315789),
        bottomLeft: Radius.circular(size.width * 0.01315789),
        topLeft: Radius.circular(size.width * 0.01315789),
        topRight: Radius.circular(size.width * 0.01315789),
      ),
      paint24Fill,
    );

    Path path_25 = Path();
    path_25.moveTo(127.813, 80.113);
    path_25.lineTo(127.813, 84.283);
    path_25.arcToPoint(
      Offset(125.395, 86.7),
      radius: Radius.elliptical(2.422, 2.422),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_25.lineTo(123.52499999999999, 86.7);
    path_25.lineTo(121.57799999999999, 79.46600000000001);
    path_25.arcToPoint(
      Offset(121.86099999999999, 78.48700000000001),
      radius: Radius.elliptical(0.966, 0.966),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_25.arcToPoint(
      Offset(122.85999999999999, 78.29100000000001),
      radius: Radius.elliptical(0.99, 0.99),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_25.lineTo(127.81299999999999, 80.11300000000001);
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(122.522, 79.213);
    path_26.lineTo(130.299, 87.72999999999999);
    path_26.lineTo(125.07400000000001, 88.722);
    path_26.lineTo(122.522, 79.21199999999999);
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(122.522, 79.213);
    path_27.lineTo(130.299, 87.72999999999999);
    path_27.lineTo(125.07400000000001, 88.722);
    path_27.lineTo(122.522, 79.21199999999999);
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(122.522, 79.213);
    path_28.lineTo(130.299, 87.72999999999999);
    path_28.lineTo(132, 82.69);
    path_28.lineTo(122.522, 79.213);
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(129.375, 86.058);
    path_29.cubicTo(
      129.693,
      86.33800000000001,
      130.086,
      86.412,
      130.25,
      86.224,
    );
    path_29.cubicTo(
      130.414,
      86.036,
      130.289,
      85.65700000000001,
      129.97,
      85.378,
    );
    path_29.cubicTo(129.651, 85.098, 129.259, 85.024, 129.095, 85.212);
    path_29.cubicTo(128.931, 85.4, 129.056, 85.779, 129.375, 86.058);
    path_29.close();
    path_29.moveTo(128.44, 84.786);
    path_29.cubicTo(
      128.62199999999999,
      84.94500000000001,
      128.845,
      84.988,
      128.939,
      84.881,
    );
    path_29.cubicTo(
      129.033,
      84.774,
      128.96099999999998,
      84.558,
      128.779,
      84.399,
    );
    path_29.cubicTo(128.597, 84.239, 128.374, 84.197, 128.28, 84.304);
    path_29.cubicTo(128.186, 84.411, 128.258, 84.626, 128.44, 84.786);
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(127.813, 60.533);
    path_30.lineTo(127.813, 56.363);
    path_30.arcToPoint(
      Offset(125.395, 53.945),
      radius: Radius.elliptical(2.423, 2.423),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_30.lineTo(123.52499999999999, 53.945);
    path_30.lineTo(121.57799999999999, 61.18);
    path_30.arcToPoint(
      Offset(121.86099999999999, 62.158),
      radius: Radius.elliptical(0.966, 0.966),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_30.arcToPoint(
      Offset(122.85999999999999, 62.354),
      radius: Radius.elliptical(0.99, 0.99),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_30.lineTo(127.81299999999999, 60.533);
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(122.522, 61.433);
    path_31.lineTo(130.299, 52.915);
    path_31.lineTo(125.07400000000001, 51.924);
    path_31.lineTo(122.522, 61.433);
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(122.522, 61.433);
    path_32.lineTo(130.299, 52.915);
    path_32.lineTo(125.07400000000001, 51.924);
    path_32.lineTo(122.522, 61.433);
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(122.522, 61.433);
    path_33.lineTo(130.299, 52.916);
    path_33.lineTo(132, 57.955999999999996);
    path_33.lineTo(122.522, 61.43299999999999);
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(129.375, 54.588);
    path_34.cubicTo(
      129.693,
      54.308,
      130.086,
      54.234,
      130.25,
      54.422000000000004,
    );
    path_34.cubicTo(
      130.414,
      54.61000000000001,
      130.289,
      54.989000000000004,
      129.97,
      55.268,
    );
    path_34.cubicTo(129.651, 55.548, 129.259, 55.622, 129.095, 55.434);
    path_34.cubicTo(
      128.931,
      55.245999999999995,
      129.056,
      54.867999999999995,
      129.375,
      54.588,
    );
    path_34.close();
    path_34.moveTo(128.44, 55.86);
    path_34.cubicTo(128.62199999999999, 55.7, 128.845, 55.658, 128.939, 55.765);
    path_34.cubicTo(
      129.033,
      55.872,
      128.96099999999998,
      56.088,
      128.779,
      56.247,
    );
    path_34.cubicTo(128.597, 56.406, 128.374, 56.449, 128.28, 56.342);
    path_34.cubicTo(
      128.186,
      56.235,
      128.258,
      56.019999999999996,
      128.44,
      55.86,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(24.187, 60.533);
    path_35.lineTo(24.187, 56.363);
    path_35.arcToPoint(
      Offset(26.605, 53.945),
      radius: Radius.elliptical(2.423, 2.423),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.lineTo(28.475, 53.945);
    path_35.lineTo(30.422, 61.18);
    path_35.arcToPoint(
      Offset(30.139, 62.158),
      radius: Radius.elliptical(0.966, 0.966),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.arcToPoint(
      Offset(29.14, 62.354),
      radius: Radius.elliptical(0.983, 0.983),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.lineTo(24.187, 60.533);
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(29.478, 61.433);
    path_36.lineTo(21.7, 52.915);
    path_36.lineTo(26.924999999999997, 51.924);
    path_36.lineTo(29.476999999999997, 61.433);
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(29.478, 61.433);
    path_37.lineTo(21.7, 52.915);
    path_37.lineTo(26.924999999999997, 51.924);
    path_37.lineTo(29.476999999999997, 61.433);
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(29.478, 61.433);
    path_38.lineTo(21.701, 52.916);
    path_38.lineTo(20, 57.956);
    path_38.lineTo(29.478, 61.433);
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(22.625, 54.588);
    path_39.cubicTo(22.307, 54.308, 21.915, 54.234, 21.75, 54.422000000000004);
    path_39.cubicTo(
      21.586,
      54.61000000000001,
      21.711,
      54.989000000000004,
      22.03,
      55.268,
    );
    path_39.cubicTo(22.35, 55.548, 22.742, 55.622, 22.906000000000002, 55.434);
    path_39.cubicTo(
      23.070000000000004,
      55.245999999999995,
      22.944000000000003,
      54.867999999999995,
      22.626,
      54.588,
    );
    path_39.close();
    path_39.moveTo(23.561, 55.86);
    path_39.cubicTo(23.379, 55.7, 23.156, 55.658, 23.062, 55.765);
    path_39.cubicTo(22.968, 55.872, 23.040000000000003, 56.088, 23.222, 56.247);
    path_39.cubicTo(23.404, 56.406, 23.627000000000002, 56.449, 23.722, 56.342);
    path_39.cubicTo(23.814, 56.235, 23.742, 56.019999999999996, 23.562, 55.86);
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(24.389, 80.113);
    path_40.lineTo(24.389, 84.283);
    path_40.arcToPoint(
      Offset(26.805999999999997, 86.7),
      radius: Radius.elliptical(2.423, 2.423),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_40.lineTo(28.676, 86.7);
    path_40.lineTo(30.624, 79.46600000000001);
    path_40.arcToPoint(
      Offset(30.34, 78.48700000000001),
      radius: Radius.elliptical(0.968, 0.968),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_40.arcToPoint(
      Offset(29.341, 78.29100000000001),
      radius: Radius.elliptical(0.988, 0.988),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_40.lineTo(24.388, 80.11300000000001);
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(29.478, 79.213);
    path_41.lineTo(21.7, 87.73);
    path_41.lineTo(26.924999999999997, 88.72200000000001);
    path_41.lineTo(29.476999999999997, 79.212);
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(29.478, 79.213);
    path_42.lineTo(21.7, 87.73);
    path_42.lineTo(26.924999999999997, 88.72200000000001);
    path_42.lineTo(29.476999999999997, 79.212);
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(29.478, 79.213);
    path_43.lineTo(21.701, 87.72999999999999);
    path_43.lineTo(20, 82.69);
    path_43.lineTo(29.478, 79.213);
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(22.625, 86.058);
    path_44.cubicTo(22.307, 86.33800000000001, 21.915, 86.412, 21.75, 86.224);
    path_44.cubicTo(21.586, 86.036, 21.711, 85.65700000000001, 22.03, 85.378);
    path_44.cubicTo(22.35, 85.098, 22.742, 85.024, 22.906000000000002, 85.212);
    path_44.cubicTo(
      23.070000000000004,
      85.4,
      22.944000000000003,
      85.779,
      22.626,
      86.058,
    );
    path_44.close();
    path_44.moveTo(23.561, 84.786);
    path_44.cubicTo(23.379, 84.94500000000001, 23.156, 84.988, 23.062, 84.881);
    path_44.cubicTo(22.968, 84.774, 23.040000000000003, 84.558, 23.222, 84.399);
    path_44.cubicTo(23.404, 84.239, 23.627000000000002, 84.197, 23.722, 84.304);
    path_44.cubicTo(23.814, 84.411, 23.742, 84.626, 23.562, 84.786);
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = Color(0xffF8AE00).withOpacity(hearts >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_44, paint44Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
