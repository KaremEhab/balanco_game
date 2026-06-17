import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GameplayStarsPainter extends CustomPainter {
  final int stars;
  GameplayStarsPainter({this.stars = 3});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(21.89, 29.156);
    path_0.lineTo(99.058, 29.156);
    path_0.cubicTo(
      99.72300000000001,
      29.156,
      100.33500000000001,
      29.516,
      100.679,
      30.09,
    );
    path_0.cubicTo(101.372, 31.244, 100.771, 53.683, 100.687, 53.828);
    path_0.arcToPoint(
      Offset(99.065, 54.753),
      radius: Radius.elliptical(1.892, 1.892),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(21.89, 54.753);
    path_0.cubicTo(20.85, 54.753, 20, 53.904, 20, 52.863);
    path_0.lineTo(20, 31.053);
    path_0.cubicTo(
      20,
      30.006,
      20.85,
      29.156000000000002,
      21.89,
      29.156000000000002,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(21.76, 30.871);
    path_1.lineTo(98.55000000000001, 30.871);
    path_1.lineTo(98.55000000000001, 52.8);
    path_1.lineTo(21.76, 52.8);
    path_1.lineTo(21.76, 30.871);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(90.92, 51.065);
    path_2.lineTo(90.92, 32.469);
    path_2.cubicTo(90.92, 32.074, 90.581, 31.753, 90.163, 31.753);
    path_2.lineTo(81.526, 31.753);
    path_2.cubicTo(
      81.10799999999999,
      31.753,
      80.76899999999999,
      32.073,
      80.76899999999999,
      32.469,
    );
    path_2.lineTo(80.76899999999999, 51.065);
    path_2.cubicTo(80.76899999999999, 51.461, 81.109, 51.781, 81.526, 51.781);
    path_2.lineTo(90.163, 51.781);
    path_2.cubicTo(90.581, 51.781, 90.92, 51.461, 90.92, 51.065);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(81.527, 51.78);
    path_3.lineTo(81.527, 31.75);
    path_3.cubicTo(81.109, 31.75, 80.77, 32.07, 80.77, 32.466);
    path_3.lineTo(80.77, 51.062);
    path_3.cubicTo(
      80.77,
      51.458,
      81.109,
      51.778999999999996,
      81.527,
      51.778999999999996,
    );
    path_3.close();
    path_3.moveTo(90.92, 51.065);
    path_3.lineTo(90.92, 32.469);
    path_3.cubicTo(90.92, 32.074, 90.581, 31.753, 90.163, 31.753);
    path_3.lineTo(90.133, 31.753);
    path_3.lineTo(90.133, 51.782);
    path_3.lineTo(90.163, 51.782);
    path_3.cubicTo(90.581, 51.782, 90.92, 51.461, 90.92, 51.065);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(89.5, 51.78);
    path_4.lineTo(82.188, 51.78);
    path_4.lineTo(82.188, 31.753);
    path_4.lineTo(89.5, 31.753);
    path_4.lineTo(89.5, 51.78);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(87.19, 51.78);
    path_5.lineTo(84.497, 51.78);
    path_5.lineTo(84.497, 31.753);
    path_5.lineTo(87.19, 31.753);
    path_5.lineTo(87.19, 51.78);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(79.29, 51.065);
    path_6.lineTo(79.29, 32.469);
    path_6.cubicTo(79.29, 32.074, 78.95100000000001, 31.753, 78.533, 31.753);
    path_6.lineTo(69.897, 31.753);
    path_6.cubicTo(69.479, 31.753, 69.14, 32.073, 69.14, 32.469);
    path_6.lineTo(69.14, 51.065);
    path_6.cubicTo(69.14, 51.461, 69.479, 51.781, 69.897, 51.781);
    path_6.lineTo(78.533, 51.781);
    path_6.cubicTo(78.95100000000001, 51.781, 79.29, 51.461, 79.29, 51.065);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(69.897, 51.78);
    path_7.lineTo(69.897, 31.75);
    path_7.cubicTo(69.479, 31.75, 69.14, 32.07, 69.14, 32.466);
    path_7.lineTo(69.14, 51.062);
    path_7.cubicTo(
      69.14,
      51.458,
      69.479,
      51.778999999999996,
      69.897,
      51.778999999999996,
    );
    path_7.close();
    path_7.moveTo(79.29, 51.065);
    path_7.lineTo(79.29, 32.469);
    path_7.cubicTo(79.29, 32.074, 78.95100000000001, 31.753, 78.533, 31.753);
    path_7.lineTo(78.503, 31.753);
    path_7.lineTo(78.503, 51.782);
    path_7.lineTo(78.533, 51.782);
    path_7.cubicTo(78.95100000000001, 51.782, 79.29, 51.461, 79.29, 51.065);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(77.87, 51.78);
    path_8.lineTo(70.558, 51.78);
    path_8.lineTo(70.558, 31.753);
    path_8.lineTo(77.87, 31.753);
    path_8.lineTo(77.87, 51.78);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(75.56, 51.78);
    path_9.lineTo(72.868, 51.78);
    path_9.lineTo(72.868, 31.753);
    path_9.lineTo(75.56099999999999, 31.753);
    path_9.lineTo(75.56099999999999, 51.78);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(67.66, 51.065);
    path_10.lineTo(67.66, 32.469);
    path_10.cubicTo(67.66, 32.074, 67.321, 31.753, 66.90299999999999, 31.753);
    path_10.lineTo(58.266999999999996, 31.753);
    path_10.cubicTo(
      57.848,
      31.753,
      57.50899999999999,
      32.073,
      57.50899999999999,
      32.469,
    );
    path_10.lineTo(57.50899999999999, 51.065);
    path_10.cubicTo(
      57.50899999999999,
      51.461,
      57.849,
      51.781,
      58.266999999999996,
      51.781,
    );
    path_10.lineTo(66.90299999999999, 51.781);
    path_10.cubicTo(67.321, 51.781, 67.66, 51.461, 67.66, 51.065);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(58.267, 51.78);
    path_11.lineTo(58.267, 31.75);
    path_11.cubicTo(
      57.849000000000004,
      31.75,
      57.510000000000005,
      32.07,
      57.510000000000005,
      32.466,
    );
    path_11.lineTo(57.510000000000005, 51.062);
    path_11.cubicTo(
      57.510000000000005,
      51.458,
      57.85000000000001,
      51.778999999999996,
      58.267,
      51.778999999999996,
    );
    path_11.close();
    path_11.moveTo(67.66, 51.065);
    path_11.lineTo(67.66, 32.469);
    path_11.cubicTo(67.66, 32.074, 67.321, 31.753, 66.90299999999999, 31.753);
    path_11.lineTo(66.87299999999999, 31.753);
    path_11.lineTo(66.87299999999999, 51.782);
    path_11.lineTo(66.90299999999999, 51.782);
    path_11.cubicTo(67.321, 51.782, 67.66, 51.461, 67.66, 51.065);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(66.24, 51.78);
    path_12.lineTo(58.928, 51.78);
    path_12.lineTo(58.928, 31.753);
    path_12.lineTo(66.24, 31.753);
    path_12.lineTo(66.24, 51.78);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(63.93, 51.78);
    path_13.lineTo(61.238, 51.78);
    path_13.lineTo(61.238, 31.753);
    path_13.lineTo(63.931, 31.753);
    path_13.lineTo(63.931, 51.78);
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(56.03, 51.065);
    path_14.lineTo(56.03, 32.469);
    path_14.cubicTo(56.03, 32.074, 55.691, 31.753, 55.273, 31.753);
    path_14.lineTo(46.637, 31.753);
    path_14.cubicTo(46.218, 31.753, 45.879, 32.073, 45.879, 32.469);
    path_14.lineTo(45.879, 51.065);
    path_14.cubicTo(45.879, 51.461, 46.219, 51.781, 46.637, 51.781);
    path_14.lineTo(55.272999999999996, 51.781);
    path_14.cubicTo(55.690999999999995, 51.781, 56.031, 51.461, 56.031, 51.065);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(46.638, 51.78);
    path_15.lineTo(46.638, 31.75);
    path_15.cubicTo(
      46.219,
      31.75,
      45.879999999999995,
      32.07,
      45.879999999999995,
      32.466,
    );
    path_15.lineTo(45.879999999999995, 51.062);
    path_15.cubicTo(
      45.879999999999995,
      51.458,
      46.22,
      51.778999999999996,
      46.638,
      51.778999999999996,
    );
    path_15.close();
    path_15.moveTo(56.03, 51.065);
    path_15.lineTo(56.03, 32.469);
    path_15.cubicTo(56.03, 32.074, 55.691, 31.753, 55.273, 31.753);
    path_15.lineTo(55.243, 31.753);
    path_15.lineTo(55.243, 51.782);
    path_15.lineTo(55.273, 51.782);
    path_15.cubicTo(
      55.691,
      51.782,
      56.031000000000006,
      51.461,
      56.031000000000006,
      51.065,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(54.61, 51.78);
    path_16.lineTo(47.298, 51.78);
    path_16.lineTo(47.298, 31.753);
    path_16.lineTo(54.61, 31.753);
    path_16.lineTo(54.61, 51.78);
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(52.301, 51.78);
    path_17.lineTo(49.608000000000004, 51.78);
    path_17.lineTo(49.608000000000004, 31.753);
    path_17.lineTo(52.301, 31.753);
    path_17.lineTo(52.301, 51.78);
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(113.778, 20);
    path_18.cubicTo(
      125.691,
      20,
      135.35500000000002,
      29.664,
      135.35500000000002,
      41.578,
    );
    path_18.cubicTo(
      135.35500000000002,
      53.491,
      125.69100000000002,
      63.147000000000006,
      113.77800000000002,
      63.147000000000006,
    );
    path_18.cubicTo(
      101.86400000000002,
      63.147000000000006,
      92.20800000000003,
      53.49100000000001,
      92.20800000000003,
      41.577000000000005,
    );
    path_18.cubicTo(
      92.20800000000003,
      29.664000000000005,
      101.86300000000003,
      20.000000000000004,
      113.77800000000002,
      20.000000000000004,
    );
    path_18.close();
    path_18.moveTo(113.778, 60.463);
    path_18.cubicTo(124.212, 60.463, 132.671, 52.003, 132.671, 41.578);
    path_18.cubicTo(
      132.671,
      31.143,
      124.21199999999999,
      22.684000000000005,
      113.77799999999999,
      22.684000000000005,
    );
    path_18.cubicTo(
      103.34299999999999,
      22.684000000000005,
      94.892,
      31.143000000000004,
      94.892,
      41.578,
    );
    path_18.cubicTo(
      94.892,
      52.004000000000005,
      103.34299999999999,
      60.46300000000001,
      113.77799999999999,
      60.46300000000001,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(93.434, 41.578);
    path_19.cubicTo(
      93.434,
      52.80800000000001,
      102.53699999999999,
      61.92100000000001,
      113.777,
      61.92100000000001,
    );
    path_19.cubicTo(
      125.01700000000001,
      61.92100000000001,
      134.129,
      52.809000000000005,
      134.129,
      41.578,
    );
    path_19.cubicTo(
      134.129,
      30.338,
      125.017,
      21.227000000000004,
      113.77699999999999,
      21.227000000000004,
    );
    path_19.cubicTo(
      102.53699999999998,
      21.227000000000004,
      93.43399999999998,
      30.338000000000005,
      93.43399999999998,
      41.578,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(93.953, 41.578);
    path_20.cubicTo(
      93.953,
      52.522000000000006,
      102.824,
      61.401,
      113.777,
      61.401,
    );
    path_20.cubicTo(124.731, 61.401, 133.61, 52.521, 133.61, 41.578);
    path_20.cubicTo(
      133.61,
      30.624000000000002,
      124.73100000000001,
      21.744000000000003,
      113.77700000000002,
      21.744000000000003,
    );
    path_20.cubicTo(
      102.82400000000001,
      21.744000000000003,
      93.95300000000002,
      30.624000000000002,
      93.95300000000002,
      41.578,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(94.892, 41.577);
    path_21.cubicTo(
      94.892,
      52.003,
      103.34299999999999,
      60.462999999999994,
      113.77799999999999,
      60.462999999999994,
    );
    path_21.cubicTo(
      124.21199999999999,
      60.462999999999994,
      132.672,
      52.00299999999999,
      132.672,
      41.577,
    );
    path_21.cubicTo(
      132.672,
      31.143,
      124.21199999999999,
      22.683999999999997,
      113.77799999999999,
      22.683999999999997,
    );
    path_21.cubicTo(
      103.34299999999999,
      22.683999999999997,
      94.892,
      31.142999999999997,
      94.892,
      41.577,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(94.892, 41.577);
    path_22.cubicTo(
      94.892,
      52.003,
      103.34299999999999,
      60.462999999999994,
      113.77799999999999,
      60.462999999999994,
    );
    path_22.cubicTo(
      124.21199999999999,
      60.462999999999994,
      132.672,
      52.00299999999999,
      132.672,
      41.577,
    );
    path_22.cubicTo(
      132.672,
      31.143,
      124.21199999999999,
      22.683999999999997,
      113.77799999999999,
      22.683999999999997,
    );
    path_22.cubicTo(
      103.34299999999999,
      22.683999999999997,
      94.892,
      31.142999999999997,
      94.892,
      41.577,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(98.965, 36.84);
    path_23.cubicTo(99.547, 35.047000000000004, 101.141, 33.89, 103.025, 33.89);
    path_23.lineTo(108.17500000000001, 33.89);
    path_23.lineTo(109.766, 28.992);
    path_23.cubicTo(
      110.348,
      27.2,
      111.94200000000001,
      26.042,
      113.82600000000001,
      26.042,
    );
    path_23.cubicTo(
      115.71000000000001,
      26.042,
      117.304,
      27.200000000000003,
      117.88600000000001,
      28.992,
    );
    path_23.lineTo(119.477, 33.889);
    path_23.lineTo(124.62700000000001, 33.889);
    path_23.cubicTo(
      126.51100000000001,
      33.889,
      128.10500000000002,
      35.048,
      128.687,
      36.839000000000006,
    );
    path_23.cubicTo(
      129.269,
      38.632000000000005,
      128.661,
      40.505,
      127.13600000000001,
      41.61200000000001,
    );
    path_23.lineTo(122.971, 44.63900000000001);
    path_23.lineTo(123.72200000000001, 46.95000000000001);
    path_23.arcToPoint(
      Offset(123.757, 47.04100000000001),
      radius: Radius.elliptical(0.98, 0.98),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.lineTo(124.566, 49.53100000000001);
    path_23.cubicTo(
      125.148,
      51.32500000000001,
      124.537,
      53.201000000000015,
      123.011,
      54.31000000000002,
    );
    path_23.cubicTo(
      121.484,
      55.420000000000016,
      119.511,
      55.420000000000016,
      117.984,
      54.311000000000014,
    );
    path_23.lineTo(113.826, 51.28800000000001);
    path_23.lineTo(109.66699999999999, 54.311000000000014);
    path_23.arcToPoint(
      Offset(107.15499999999999, 55.14200000000002),
      radius: Radius.elliptical(4.263, 4.263),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(104.63999999999999, 54.30900000000002),
      radius: Radius.elliptical(4.268, 4.268),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.cubicTo(
      103.11399999999999,
      53.19900000000002,
      102.50499999999998,
      51.32300000000002,
      103.08999999999999,
      49.530000000000015,
    );
    path_23.lineTo(103.90699999999998, 47.018000000000015);
    path_23.arcToPoint(
      Offset(103.92699999999998, 46.96100000000001),
      radius: Radius.elliptical(1.08, 1.08),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.lineTo(104.68199999999997, 44.63900000000001);
    path_23.lineTo(100.51599999999998, 41.61200000000001);
    path_23.cubicTo(
      98.99199999999998,
      40.50500000000001,
      98.38299999999998,
      38.63200000000001,
      98.96599999999998,
      36.83900000000001,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = Color(0xffF68B55).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(100.681, 41.576);
    path_24.cubicTo(100.681, 48.806, 106.542, 54.674, 113.779, 54.674);
    path_24.cubicTo(
      121.01599999999999,
      54.674,
      126.883,
      48.807,
      126.883,
      41.576,
    );
    path_24.cubicTo(
      126.883,
      34.339,
      121.01599999999999,
      28.472,
      113.779,
      28.472,
    );
    path_24.cubicTo(106.542, 28.472, 100.681, 34.339, 100.681, 41.576);
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(112.228, 58.072);
    path_25.arcToPoint(
      Offset(115.33099999999999, 57.968),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_25.arcToPoint(
      Offset(112.228, 58.072),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(112.228, 58.072);
    path_26.arcToPoint(
      Offset(115.33099999999999, 57.968),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_26.arcToPoint(
      Offset(112.228, 58.072),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(112.228, 58.078);
    path_27.cubicTo(
      112.25699999999999,
      58.928000000000004,
      112.979,
      59.603,
      113.829,
      59.574000000000005,
    );
    path_27.arcToPoint(
      Offset(115.335, 57.97200000000001),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_27.arcToPoint(
      Offset(115.3, 57.726000000000006),
      radius: Radius.elliptical(1.146, 1.146),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_27.arcToPoint(
      Offset(113.812, 59.07000000000001),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_27.arcToPoint(
      Offset(112.245, 57.82900000000001),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_27.cubicTo(
      112.23100000000001,
      57.909000000000006,
      112.22500000000001,
      57.989000000000004,
      112.22800000000001,
      58.077000000000005,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(112.923, 57.421);
    path_28.cubicTo(112.936, 57.796, 113.318, 57.921, 113.784, 57.906);
    path_28.cubicTo(
      114.251,
      57.89,
      114.62400000000001,
      57.739,
      114.61200000000001,
      57.364,
    );
    path_28.cubicTo(
      114.599,
      56.989999999999995,
      114.21100000000001,
      56.699,
      113.74400000000001,
      56.714,
    );
    path_28.cubicTo(
      113.27800000000002,
      56.73,
      112.91000000000001,
      57.047,
      112.92300000000002,
      57.421,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = Color(0xffffffff).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(123.859, 53.256);
    path_29.arcToPoint(
      Offset(126.96199999999999, 53.152),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_29.arcToPoint(
      Offset(123.859, 53.256),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(123.859, 53.256);
    path_30.arcToPoint(
      Offset(126.96199999999999, 53.152),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_30.arcToPoint(
      Offset(123.859, 53.256),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(123.859, 53.26);
    path_31.cubicTo(123.88799999999999, 54.11, 124.61, 54.786, 125.46, 54.757);
    path_31.arcToPoint(
      Offset(126.966, 53.155),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_31.arcToPoint(
      Offset(126.931, 52.908),
      radius: Radius.elliptical(1.088, 1.088),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_31.arcToPoint(
      Offset(123.877, 53.011),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_31.cubicTo(123.862, 53.091, 123.856, 53.171, 123.859, 53.261);
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(124.554, 52.604);
    path_32.cubicTo(
      124.56700000000001,
      52.979,
      124.949,
      53.104,
      125.416,
      53.089,
    );
    path_32.cubicTo(
      125.88199999999999,
      53.071999999999996,
      126.255,
      52.921,
      126.243,
      52.547,
    );
    path_32.cubicTo(
      126.22999999999999,
      52.172,
      125.842,
      51.882,
      125.37599999999999,
      51.897,
    );
    path_32.cubicTo(
      124.90899999999999,
      51.913,
      124.541,
      52.229,
      124.55399999999999,
      52.604,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = Color(0xffffffff).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(129.053, 41.624);
    path_33.arcToPoint(
      Offset(132.157, 41.52),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_33.arcToPoint(
      Offset(129.053, 41.624),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(129.053, 41.624);
    path_34.arcToPoint(
      Offset(132.157, 41.52),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_34.arcToPoint(
      Offset(129.053, 41.624),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(129.053, 41.63);
    path_35.cubicTo(
      129.082,
      42.480000000000004,
      129.805,
      43.156000000000006,
      130.655,
      43.127,
    );
    path_35.arcToPoint(
      Offset(132.16, 41.525000000000006),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_35.arcToPoint(
      Offset(132.125, 41.278000000000006),
      radius: Radius.elliptical(1.088, 1.088),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_35.arcToPoint(
      Offset(129.071, 41.38100000000001),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.cubicTo(
      129.056,
      41.461000000000006,
      129.05,
      41.541000000000004,
      129.053,
      41.63100000000001,
    );
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(129.748, 40.974);
    path_36.cubicTo(
      129.761,
      41.349,
      130.14399999999998,
      41.474,
      130.60999999999999,
      41.458999999999996,
    );
    path_36.cubicTo(
      131.076,
      41.443,
      131.44899999999998,
      41.291999999999994,
      131.43699999999998,
      40.916999999999994,
    );
    path_36.cubicTo(
      131.42399999999998,
      40.541999999999994,
      131.03599999999997,
      40.251999999999995,
      130.57,
      40.266999999999996,
    );
    path_36.cubicTo(
      130.10299999999998,
      40.282999999999994,
      129.73499999999999,
      40.599,
      129.748,
      40.974,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = Color(0xffffffff).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(123.859, 29.995);
    path_37.arcToPoint(
      Offset(126.963, 29.89),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_37.arcToPoint(
      Offset(123.859, 29.995),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(123.859, 29.995);
    path_38.arcToPoint(
      Offset(126.963, 29.89),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_38.arcToPoint(
      Offset(123.859, 29.995),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(123.859, 29.997);
    path_39.cubicTo(123.887, 30.847, 124.61, 31.523, 125.46, 31.494);
    path_39.arcToPoint(
      Offset(126.966, 29.892),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_39.arcToPoint(
      Offset(126.931, 29.645),
      radius: Radius.elliptical(1.147, 1.147),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_39.arcToPoint(
      Offset(125.443, 30.99),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.arcToPoint(
      Offset(123.876, 29.749),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.cubicTo(
      123.86200000000001,
      29.828999999999997,
      123.85600000000001,
      29.909,
      123.85900000000001,
      29.997,
    );
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = Color(0xffF8AE00).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(124.554, 29.342);
    path_40.cubicTo(
      124.56700000000001,
      29.717,
      124.949,
      29.842,
      125.415,
      29.826999999999998,
    );
    path_40.cubicTo(
      125.882,
      29.811,
      126.25500000000001,
      29.659999999999997,
      126.24300000000001,
      29.284999999999997,
    );
    path_40.cubicTo(
      126.23,
      28.909999999999997,
      125.84200000000001,
      28.619999999999997,
      125.376,
      28.634999999999998,
    );
    path_40.cubicTo(
      124.909,
      28.650999999999996,
      124.54100000000001,
      28.967999999999996,
      124.554,
      29.342,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = Color(0xffffffff).withOpacity(stars >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(112.228, 25.177);
    path_41.arcToPoint(
      Offset(115.332, 25.073),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_41.arcToPoint(
      Offset(112.228, 25.177),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(112.228, 25.177);
    path_42.arcToPoint(
      Offset(115.332, 25.073),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_42.arcToPoint(
      Offset(112.228, 25.177),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(112.228, 25.182);
    path_43.cubicTo(
      112.25699999999999,
      26.032,
      112.979,
      26.706999999999997,
      113.829,
      26.677999999999997,
    );
    path_43.arcToPoint(
      Offset(115.335, 25.075999999999997),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_43.arcToPoint(
      Offset(115.3, 24.828999999999997),
      radius: Radius.elliptical(1.146, 1.146),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_43.arcToPoint(
      Offset(113.812, 26.173),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_43.arcToPoint(
      Offset(112.245, 24.933),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_43.cubicTo(
      112.23100000000001,
      25.012999999999998,
      112.22500000000001,
      25.093,
      112.22800000000001,
      25.182,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = Color(0xffF8AE00).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(112.923, 24.526);
    path_44.cubicTo(
      112.936,
      24.9,
      113.318,
      25.026,
      113.784,
      25.009999999999998,
    );
    path_44.cubicTo(
      114.251,
      24.994,
      114.62400000000001,
      24.842999999999996,
      114.61200000000001,
      24.468999999999998,
    );
    path_44.cubicTo(
      114.599,
      24.093999999999998,
      114.21100000000001,
      23.804,
      113.74400000000001,
      23.819,
    );
    path_44.cubicTo(
      113.27800000000002,
      23.834999999999997,
      112.91000000000001,
      24.151,
      112.92300000000002,
      24.526,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = Color(0xffffffff).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(100.597, 29.995);
    path_45.arcToPoint(
      Offset(103.701, 29.891000000000002),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_45.arcToPoint(
      Offset(100.597, 29.995),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(100.597, 29.995);
    path_46.arcToPoint(
      Offset(103.701, 29.891000000000002),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_46.arcToPoint(
      Offset(100.597, 29.995),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(100.597, 29.997);
    path_47.cubicTo(
      100.62599999999999,
      30.847,
      101.34899999999999,
      31.523,
      102.199,
      31.494,
    );
    path_47.arcToPoint(
      Offset(103.705, 29.892),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_47.arcToPoint(
      Offset(103.67, 29.645),
      radius: Radius.elliptical(1.147, 1.147),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_47.arcToPoint(
      Offset(100.615, 29.748),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_47.arcToPoint(
      Offset(100.597, 29.998),
      radius: Radius.elliptical(1.133, 1.133),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(101.292, 29.342);
    path_48.cubicTo(
      101.305,
      29.717,
      101.688,
      29.842,
      102.154,
      29.826999999999998,
    );
    path_48.cubicTo(
      102.61999999999999,
      29.811,
      102.994,
      29.659999999999997,
      102.981,
      29.284999999999997,
    );
    path_48.cubicTo(
      102.96799999999999,
      28.909999999999997,
      102.58,
      28.619999999999997,
      102.11399999999999,
      28.634999999999998,
    );
    path_48.cubicTo(
      101.648,
      28.650999999999996,
      101.27999999999999,
      28.967999999999996,
      101.29199999999999,
      29.342,
    );
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = Color(0xffffffff).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(95.374, 41.624);
    path_49.arcToPoint(
      Offset(98.478, 41.52),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_49.arcToPoint(
      Offset(95.374, 41.624),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(95.374, 41.624);
    path_50.arcToPoint(
      Offset(98.478, 41.52),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_50.arcToPoint(
      Offset(95.374, 41.624),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(95.374, 41.63);
    path_51.cubicTo(
      95.40299999999999,
      42.480000000000004,
      96.12599999999999,
      43.156000000000006,
      96.976,
      43.127,
    );
    path_51.arcToPoint(
      Offset(98.481, 41.525000000000006),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_51.arcToPoint(
      Offset(98.446, 41.278000000000006),
      radius: Radius.elliptical(1.128, 1.128),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_51.arcToPoint(
      Offset(95.39099999999999, 41.38100000000001),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_51.cubicTo(
      95.377,
      41.461000000000006,
      95.371,
      41.541000000000004,
      95.374,
      41.63100000000001,
    );
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(96.07, 40.974);
    path_52.cubicTo(
      96.082,
      41.349,
      96.46499999999999,
      41.474,
      96.92999999999999,
      41.458999999999996,
    );
    path_52.cubicTo(
      97.39699999999999,
      41.443,
      97.77,
      41.291999999999994,
      97.758,
      40.916999999999994,
    );
    path_52.cubicTo(
      97.74499999999999,
      40.541999999999994,
      97.357,
      40.251999999999995,
      96.89099999999999,
      40.266999999999996,
    );
    path_52.cubicTo(
      96.42399999999999,
      40.282999999999994,
      96.056,
      40.599,
      96.06899999999999,
      40.974,
    );
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = Color(0xffffffff).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(100.597, 53.256);
    path_53.arcToPoint(
      Offset(103.701, 53.151),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_53.arcToPoint(
      Offset(100.597, 53.256),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(100.597, 53.256);
    path_54.arcToPoint(
      Offset(103.701, 53.151),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_54.arcToPoint(
      Offset(100.597, 53.256),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(100.597, 53.26);
    path_55.cubicTo(
      100.62599999999999,
      54.11,
      101.34899999999999,
      54.786,
      102.199,
      54.757,
    );
    path_55.arcToPoint(
      Offset(103.705, 53.155),
      radius: Radius.elliptical(1.56, 1.56),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_55.arcToPoint(
      Offset(103.67, 52.908),
      radius: Radius.elliptical(1.147, 1.147),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_55.arcToPoint(
      Offset(100.615, 53.011),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_55.cubicTo(100.6, 53.091, 100.594, 53.171, 100.597, 53.261);
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = Color(0xffF8AE00).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(101.292, 52.604);
    path_56.cubicTo(101.305, 52.979, 101.688, 53.104, 102.154, 53.089);
    path_56.cubicTo(
      102.61999999999999,
      53.071999999999996,
      102.994,
      52.921,
      102.981,
      52.547,
    );
    path_56.cubicTo(
      102.969,
      52.172,
      102.58,
      51.882,
      102.11399999999999,
      51.897,
    );
    path_56.cubicTo(
      101.648,
      51.913,
      101.27999999999999,
      52.229,
      101.29199999999999,
      52.604,
    );
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = Color(0xffffffff).withOpacity(stars >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_56, paint56Fill);

    Path path_57 = Path();
    path_57.moveTo(110.816, 29.22);
    path_57.lineTo(109.018, 34.754);
    path_57.lineTo(103.199, 34.754);
    path_57.cubicTo(
      99.956,
      34.754,
      98.607,
      38.903999999999996,
      101.232,
      40.809999999999995,
    );
    path_57.lineTo(105.939, 44.23);
    path_57.lineTo(104.14099999999999, 49.765);
    path_57.cubicTo(
      103.13799999999999,
      52.849000000000004,
      106.669,
      55.414,
      109.29299999999999,
      53.508,
    );
    path_57.lineTo(113.99999999999999, 50.088);
    path_57.lineTo(118.70699999999998, 53.508);
    path_57.cubicTo(
      121.33099999999997,
      55.414,
      124.86199999999998,
      52.849000000000004,
      123.85899999999998,
      49.764,
    );
    path_57.lineTo(122.06099999999998, 44.230000000000004);
    path_57.lineTo(126.76799999999997, 40.81);
    path_57.cubicTo(
      129.39199999999997,
      38.904,
      128.04399999999998,
      34.754000000000005,
      124.80099999999997,
      34.754000000000005,
    );
    path_57.lineTo(118.98199999999997, 34.754000000000005);
    path_57.lineTo(117.18399999999997, 29.220000000000006);
    path_57.cubicTo(
      116.18099999999997,
      26.135000000000005,
      111.81799999999997,
      26.135000000000005,
      110.81599999999997,
      29.220000000000006,
    );
    path_57.close();

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = Color(0xffF68B55).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_57, paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(112.235, 36.319);
    path_58.lineTo(111.505, 38.563);
    path_58.arcToPoint(
      Offset(111.42, 38.625),
      radius: Radius.elliptical(0.09, 0.09),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_58.lineTo(109.06, 38.625);
    path_58.cubicTo(
      107.468,
      38.625,
      106.805,
      40.663,
      108.09400000000001,
      41.599000000000004,
    );
    path_58.lineTo(110.00300000000001, 42.986000000000004);
    path_58.arcToPoint(
      Offset(110.03600000000002, 43.086000000000006),
      radius: Radius.elliptical(0.089, 0.089),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_58.lineTo(109.30700000000002, 45.331);
    path_58.cubicTo(
      108.81500000000001,
      46.845000000000006,
      110.54800000000002,
      48.105000000000004,
      111.83600000000001,
      47.169000000000004,
    );
    path_58.lineTo(113.74600000000001, 45.782000000000004);
    path_58.arcToPoint(
      Offset(113.85100000000001, 45.782000000000004),
      radius: Radius.elliptical(0.09, 0.09),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_58.lineTo(115.76100000000001, 47.169000000000004);
    path_58.cubicTo(
      117.049,
      48.105000000000004,
      118.78200000000001,
      46.845000000000006,
      118.29,
      45.331,
    );
    path_58.lineTo(117.561, 43.086000000000006);
    path_58.arcToPoint(
      Offset(117.593, 42.986000000000004),
      radius: Radius.elliptical(0.09, 0.09),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_58.lineTo(119.503, 41.599000000000004);
    path_58.cubicTo(
      120.791,
      40.663000000000004,
      120.129,
      38.625,
      118.537,
      38.625,
    );
    path_58.lineTo(116.177, 38.625);
    path_58.arcToPoint(
      Offset(116.09100000000001, 38.563),
      radius: Radius.elliptical(0.09, 0.09),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_58.lineTo(115.36200000000001, 36.318000000000005);
    path_58.cubicTo(
      114.87,
      34.804,
      112.727,
      34.804,
      112.23500000000001,
      36.318000000000005,
    );
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = Color(0xffF68B55).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_58, paint58Fill);

    Path path_59 = Path();
    path_59.moveTo(101.553, 40.244);
    path_59.cubicTo(102.77499999999999, 41.131, 104.119, 41.844, 105.559, 42.3);
    path_59.cubicTo(108.19, 43.132999999999996, 111.247, 43.61, 114.511, 43.61);
    path_59.arcToPoint(
      Offset(120.16, 43.113),
      radius: Radius.elliptical(31.76, 31.76),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_59.cubicTo(
      122.26899999999999,
      42.731,
      124.252,
      41.838,
      125.985,
      40.578,
    );
    path_59.lineTo(126.447, 40.243);
    path_59.cubicTo(128.615, 38.667, 127.5, 35.237, 124.82000000000001, 35.237);
    path_59.lineTo(118.715, 35.237);
    path_59.arcToPoint(
      Offset(118.521, 35.094),
      radius: Radius.elliptical(0.204, 0.204),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_59.lineTo(116.923, 29.493000000000002);
    path_59.cubicTo(
      116.001,
      26.663000000000004,
      111.998,
      26.663000000000004,
      111.081,
      29.493000000000002,
    );
    path_59.lineTo(109.482, 35.094);
    path_59.arcToPoint(
      Offset(109.285, 35.237),
      radius: Radius.elliptical(0.207, 0.207),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_59.lineTo(103.17999999999999, 35.237);
    path_59.cubicTo(
      100.49799999999999,
      35.237,
      99.38399999999999,
      38.668,
      101.553,
      40.244,
    );
    path_59.close();

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7414231, size.height * 0.2932500),
      Offset(size.width * 0.7241538, size.height * 0.5516905),
      [Color(0xffffffff).withOpacity(stars >= 1 ? 1.0 : 0.2), Color(0xffffffff).withOpacity(0)],
      [0.471, 0.991],
    );
    canvas.drawPath(path_59, paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(109.299, 53.51);
    path_60.lineTo(113.867, 50.187999999999995);
    path_60.arcToPoint(
      Offset(114.131, 50.187999999999995),
      radius: Radius.elliptical(0.221, 0.221),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_60.lineTo(118.699, 53.51);
    path_60.cubicTo(
      121.327,
      55.418,
      124.865,
      52.848,
      123.863,
      49.757999999999996,
    );
    path_60.lineTo(123.054, 47.269);
    path_60.cubicTo(
      120.526,
      48.635999999999996,
      117.402,
      49.437,
      114.026,
      49.437,
    );
    path_60.cubicTo(
      110.631,
      49.437,
      107.49199999999999,
      48.623999999999995,
      104.95599999999999,
      47.247,
    );
    path_60.lineTo(104.139, 49.758);
    path_60.cubicTo(
      103.133,
      52.848,
      106.67099999999999,
      55.418000000000006,
      109.29899999999999,
      53.510000000000005,
    );
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.color = Color(0xffF68B55).withOpacity(stars >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_60, paint60Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
