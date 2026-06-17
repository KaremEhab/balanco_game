import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class HeartFilledPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(21.667, 0.25);
    path_0.cubicTo(11.503, 0.25, 3.25, 8.194, 3.25, 18.005);
    path_0.cubicTo(
      3.25,
      27.815999999999995,
      11.503,
      35.751999999999995,
      21.667,
      35.751999999999995,
    );
    path_0.cubicTo(
      31.830000000000002,
      35.751999999999995,
      40.09,
      27.815999999999995,
      40.09,
      18.004999999999995,
    );
    path_0.cubicTo(40.09, 8.193, 31.83, 0.25, 21.668, 0.25);
    path_0.close();
    path_0.moveTo(21.667, 2.927);
    path_0.cubicTo(30.327, 2.927, 37.33, 9.687, 37.33, 18.005);
    path_0.cubicTo(
      37.33,
      26.314999999999998,
      30.326,
      33.075,
      21.666999999999998,
      33.075,
    );
    path_0.cubicTo(
      13.006999999999998,
      33.075,
      6.0109999999999975,
      26.315000000000005,
      6.009999999999998,
      18.005000000000003,
    );
    path_0.cubicTo(
      6.009999999999998,
      9.687000000000003,
      13.006999999999998,
      2.927000000000003,
      21.666999999999998,
      2.927000000000003,
    );
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01219512;
    paint_0_stroke.color = Color(0xffC27E0C).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(4.532, 18.006);
    path_1.cubicTo(4.532, 27.116, 12.199, 34.509, 21.666, 34.509);
    path_1.cubicTo(31.133000000000003, 34.509, 38.807, 27.117, 38.807, 18.006);
    path_1.cubicTo(
      38.807,
      8.888,
      31.133000000000003,
      1.4959999999999987,
      21.667,
      1.4959999999999987,
    );
    path_1.cubicTo(
      12.199000000000002,
      1.4959999999999987,
      4.532,
      8.887999999999998,
      4.532,
      18.006,
    );
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(4.97, 18.006);
    path_2.cubicTo(4.97, 26.884, 12.44, 34.087, 21.666, 34.087);
    path_2.cubicTo(
      30.892000000000003,
      34.087,
      38.370999999999995,
      26.883000000000003,
      38.370999999999995,
      18.005000000000003,
    );
    path_2.cubicTo(
      38.370999999999995,
      9.120000000000003,
      30.890999999999995,
      1.916000000000004,
      21.665999999999997,
      1.916000000000004,
    );
    path_2.cubicTo(
      12.440999999999997,
      1.916000000000004,
      4.969999999999995,
      9.120000000000005,
      4.969999999999995,
      18.006000000000004,
    );
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(5.76, 18.005);
    path_3.cubicTo(5.76, 26.462, 12.878, 33.325, 21.667, 33.325);
    path_3.cubicTo(
      30.455000000000002,
      33.325,
      37.58,
      26.463,
      37.58,
      18.005000000000003,
    );
    path_3.cubicTo(
      37.58,
      9.540000000000003,
      30.455,
      2.6780000000000026,
      21.666999999999998,
      2.6780000000000026,
    );
    path_3.cubicTo(
      12.877999999999998,
      2.6780000000000026,
      5.759999999999998,
      9.540000000000003,
      5.759999999999998,
      18.005000000000003,
    );
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(5.76, 18.005);
    path_4.cubicTo(5.76, 26.462, 12.878, 33.325, 21.667, 33.325);
    path_4.cubicTo(
      30.455000000000002,
      33.325,
      37.58,
      26.463,
      37.58,
      18.005000000000003,
    );
    path_4.cubicTo(
      37.58,
      9.540000000000003,
      30.455,
      2.6780000000000026,
      21.666999999999998,
      2.6780000000000026,
    );
    path_4.cubicTo(
      12.877999999999998,
      2.6780000000000026,
      5.759999999999998,
      9.540000000000003,
      5.759999999999998,
      18.005000000000003,
    );
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(9.19, 14.16);
    path_5.cubicTo(9.681, 12.706, 11.024, 11.767, 12.61, 11.767);
    path_5.lineTo(16.948, 11.767);
    path_5.lineTo(18.288, 7.795);
    path_5.cubicTo(18.778, 6.34, 20.121, 5.401, 21.708, 5.401);
    path_5.cubicTo(
      23.294999999999998,
      5.401,
      24.636999999999997,
      6.340999999999999,
      25.128,
      7.795,
    );
    path_5.lineTo(26.468, 11.767);
    path_5.lineTo(30.805, 11.767);
    path_5.cubicTo(32.392, 11.767, 33.735, 12.706999999999999, 34.225, 14.161);
    path_5.cubicTo(34.715, 15.615, 34.202, 17.134999999999998, 32.918, 18.032);
    path_5.lineTo(29.41, 20.488);
    path_5.lineTo(30.042, 22.363);
    path_5.cubicTo(
      30.053,
      22.387,
      30.063000000000002,
      22.412,
      30.072000000000003,
      22.436,
    );
    path_5.lineTo(30.753000000000004, 24.456);
    path_5.cubicTo(
      31.243000000000002,
      25.911,
      30.729000000000003,
      27.433,
      29.443000000000005,
      28.333,
    );
    path_5.cubicTo(
      28.158000000000005,
      29.232999999999997,
      26.495000000000005,
      29.232999999999997,
      25.209000000000003,
      28.334,
    );
    path_5.lineTo(21.707000000000004, 25.881);
    path_5.lineTo(18.205000000000005, 28.334);
    path_5.arcToPoint(
      Offset(16.089000000000006, 29.008),
      radius: Radius.elliptical(3.683, 3.683),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_5.arcToPoint(
      Offset(13.970000000000006, 28.332),
      radius: Radius.elliptical(3.687, 3.687),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_5.cubicTo(
      12.685000000000006,
      27.432000000000002,
      12.172000000000006,
      25.91,
      12.665000000000006,
      24.456,
    );
    path_5.lineTo(13.353000000000007, 22.418);
    path_5.lineTo(13.370000000000006, 22.372);
    path_5.lineTo(14.006000000000006, 20.488);
    path_5.lineTo(10.497000000000005, 18.032);
    path_5.cubicTo(
      9.213000000000005,
      17.134,
      8.701000000000006,
      15.614,
      9.191000000000006,
      14.16,
    );
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffF68B55).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(10.636, 18.004);
    path_6.cubicTo(10.636, 23.87, 15.572, 28.629, 21.668, 28.629);
    path_6.cubicTo(27.762999999999998, 28.629, 32.705, 23.869, 32.705, 18.004);
    path_6.cubicTo(
      32.705,
      12.132000000000001,
      27.762999999999998,
      7.373000000000001,
      21.668,
      7.373000000000001,
    );
    path_6.cubicTo(
      15.572,
      7.373000000000001,
      10.636,
      12.133000000000001,
      10.636,
      18.003,
    );
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(20.361, 31.387);
    path_7.cubicTo(20.385, 32.082, 20.991, 32.627, 21.713, 32.603);
    path_7.cubicTo(
      22.435000000000002,
      32.58,
      23,
      31.997,
      22.976,
      31.301000000000002,
    );
    path_7.cubicTo(
      22.951999999999998,
      30.606,
      22.346,
      30.061000000000003,
      21.624,
      30.085,
    );
    path_7.cubicTo(
      20.901999999999997,
      30.108,
      20.337,
      30.691000000000003,
      20.360999999999997,
      31.387,
    );
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(20.361, 31.387);
    path_8.cubicTo(20.385, 32.082, 20.991, 32.627, 21.713, 32.603);
    path_8.cubicTo(
      22.435000000000002,
      32.58,
      23,
      31.997,
      22.976,
      31.301000000000002,
    );
    path_8.cubicTo(
      22.951999999999998,
      30.606,
      22.346,
      30.061000000000003,
      21.624,
      30.085,
    );
    path_8.cubicTo(
      20.901999999999997,
      30.108,
      20.337,
      30.691000000000003,
      20.360999999999997,
      31.387,
    );
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(20.361, 31.389);
    path_9.cubicTo(20.385, 32.079, 20.994, 32.627, 21.711000000000002, 32.603);
    path_9.cubicTo(
      22.433000000000003,
      32.58,
      23.003000000000004,
      31.993000000000002,
      22.979000000000003,
      31.303,
    );
    path_9.arcToPoint(
      Offset(22.949, 31.103),
      radius: Radius.elliptical(0.888, 0.888),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.cubicTo(
      22.866000000000003,
      31.703000000000003,
      22.345000000000002,
      32.173,
      21.696,
      32.194,
    );
    path_9.arcToPoint(
      Offset(20.376, 31.187),
      radius: Radius.elliptical(1.297, 1.297),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.arcToPoint(
      Offset(20.361, 31.389000000000003),
      radius: Radius.elliptical(0.887, 0.887),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(20.947, 30.856);
    path_10.cubicTo(
      20.957,
      31.16,
      21.279999999999998,
      31.262,
      21.672,
      31.249000000000002,
    );
    path_10.cubicTo(22.065, 31.236, 22.379, 31.114, 22.369, 30.809);
    path_10.cubicTo(22.358999999999998, 30.506, 22.031, 30.27, 21.639, 30.283);
    path_10.cubicTo(21.246, 30.296000000000003, 20.936, 30.553, 20.947, 30.856);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(30.157, 27.478);
    path_11.cubicTo(30.182, 28.174000000000003, 30.787, 28.718, 31.509, 28.695);
    path_11.cubicTo(32.231, 28.672, 32.796, 28.089, 32.772, 27.393);
    path_11.cubicTo(
      32.748,
      26.698,
      32.141999999999996,
      26.153000000000002,
      31.421,
      26.177,
    );
    path_11.cubicTo(30.698, 26.2, 30.133, 26.783, 30.157, 27.477999999999998);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(30.157, 27.478);
    path_12.cubicTo(30.182, 28.174000000000003, 30.787, 28.718, 31.509, 28.695);
    path_12.cubicTo(32.231, 28.672, 32.796, 28.089, 32.772, 27.393);
    path_12.cubicTo(
      32.748,
      26.698,
      32.141999999999996,
      26.153000000000002,
      31.421,
      26.177,
    );
    path_12.cubicTo(30.698, 26.2, 30.133, 26.783, 30.157, 27.477999999999998);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(30.157, 27.482);
    path_13.cubicTo(30.182, 28.172, 30.791, 28.719, 31.507, 28.695999999999998);
    path_13.cubicTo(
      32.230000000000004,
      28.671999999999997,
      32.799,
      28.086,
      32.775,
      27.395999999999997,
    );
    path_13.arcToPoint(
      Offset(32.745, 27.195999999999998),
      radius: Radius.elliptical(0.893, 0.893),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_13.cubicTo(
      32.662,
      27.796,
      32.141,
      28.266,
      31.491999999999997,
      28.285999999999998,
    );
    path_13.arcToPoint(
      Offset(30.171999999999997, 27.279999999999998),
      radius: Radius.elliptical(1.296, 1.296),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_13.arcToPoint(
      Offset(30.156999999999996, 27.482),
      radius: Radius.elliptical(0.892, 0.892),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(30.743, 26.949);
    path_14.cubicTo(
      30.753,
      27.253,
      31.075999999999997,
      27.355,
      31.468999999999998,
      27.342000000000002,
    );
    path_14.cubicTo(
      31.860999999999997,
      27.329,
      32.175999999999995,
      27.206000000000003,
      32.166,
      26.902,
    );
    path_14.cubicTo(
      32.154999999999994,
      26.599,
      31.827999999999996,
      26.363,
      31.435999999999996,
      26.375,
    );
    path_14.cubicTo(
      31.041999999999998,
      26.388,
      30.731999999999996,
      26.645,
      30.742999999999995,
      26.949,
    );
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(34.532, 18.043);
    path_15.cubicTo(
      34.556,
      18.738,
      35.162,
      19.282999999999998,
      35.88399999999999,
      19.259,
    );
    path_15.cubicTo(
      36.605999999999995,
      19.236,
      37.17099999999999,
      18.653,
      37.14699999999999,
      17.958000000000002,
    );
    path_15.cubicTo(
      37.12299999999999,
      17.262,
      36.51699999999999,
      16.718000000000004,
      35.794999999999995,
      16.741000000000003,
    );
    path_15.cubicTo(
      35.07299999999999,
      16.764000000000003,
      34.507,
      17.347000000000005,
      34.532,
      18.043000000000003,
    );
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(34.532, 18.043);
    path_16.cubicTo(
      34.556,
      18.738,
      35.162,
      19.282999999999998,
      35.88399999999999,
      19.259,
    );
    path_16.cubicTo(
      36.605999999999995,
      19.236,
      37.17099999999999,
      18.653,
      37.14699999999999,
      17.958000000000002,
    );
    path_16.cubicTo(
      37.12299999999999,
      17.262,
      36.51699999999999,
      16.718000000000004,
      35.794999999999995,
      16.741000000000003,
    );
    path_16.cubicTo(
      35.07299999999999,
      16.764000000000003,
      34.507,
      17.347000000000005,
      34.532,
      18.043000000000003,
    );
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(34.532, 18.047);
    path_17.cubicTo(
      34.556999999999995,
      18.737000000000002,
      35.165,
      19.285,
      35.882,
      19.261,
    );
    path_17.cubicTo(36.605, 19.238, 37.174, 18.651, 37.15, 17.962);
    path_17.arcToPoint(
      Offset(37.12, 17.762),
      radius: Radius.elliptical(0.888, 0.888),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_17.cubicTo(37.037, 18.362000000000002, 36.516, 18.831, 35.867, 18.852);
    path_17.arcToPoint(
      Offset(34.547, 17.845),
      radius: Radius.elliptical(1.297, 1.297),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_17.arcToPoint(
      Offset(34.532, 18.047),
      radius: Radius.elliptical(0.884, 0.884),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(35.118, 17.515);
    path_18.cubicTo(35.128, 17.819, 35.451, 17.921, 35.844, 17.908);
    path_18.cubicTo(36.236000000000004, 17.895, 36.551, 17.773, 36.54, 17.469);
    path_18.cubicTo(
      36.53,
      17.165000000000003,
      36.202999999999996,
      16.929000000000002,
      35.81,
      16.942,
    );
    path_18.cubicTo(35.417, 16.955000000000002, 35.107, 17.212, 35.118, 17.515);
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(30.157, 8.61);
    path_19.cubicTo(30.182, 9.305, 30.787, 9.85, 31.509, 9.825999999999999);
    path_19.cubicTo(32.231, 9.802, 32.796, 9.219, 32.772, 8.524);
    path_19.cubicTo(
      32.748,
      7.827999999999999,
      32.141999999999996,
      7.283999999999999,
      31.421,
      7.306999999999999,
    );
    path_19.cubicTo(
      30.698,
      7.330999999999999,
      30.133,
      7.913999999999999,
      30.157,
      8.608999999999998,
    );
    path_19.close();

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(30.157, 8.61);
    path_20.cubicTo(30.182, 9.305, 30.787, 9.85, 31.509, 9.825999999999999);
    path_20.cubicTo(32.231, 9.802, 32.796, 9.219, 32.772, 8.524);
    path_20.cubicTo(
      32.748,
      7.827999999999999,
      32.141999999999996,
      7.283999999999999,
      31.421,
      7.306999999999999,
    );
    path_20.cubicTo(
      30.698,
      7.330999999999999,
      30.133,
      7.913999999999999,
      30.157,
      8.608999999999998,
    );
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(30.157, 8.61);
    path_21.cubicTo(
      30.182,
      9.299999999999999,
      30.791,
      9.847999999999999,
      31.507,
      9.825,
    );
    path_21.cubicTo(
      32.230000000000004,
      9.801,
      32.799,
      9.215,
      32.775,
      8.524999999999999,
    );
    path_21.arcToPoint(
      Offset(32.745, 8.325),
      radius: Radius.elliptical(0.893, 0.893),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_21.cubicTo(
      32.662,
      8.924999999999999,
      32.141,
      9.395,
      31.491999999999997,
      9.415,
    );
    path_21.arcToPoint(
      Offset(30.171999999999997, 8.408999999999999),
      radius: Radius.elliptical(1.296, 1.296),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_21.arcToPoint(
      Offset(30.156999999999996, 8.610999999999999),
      radius: Radius.elliptical(0.892, 0.892),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_21.close();

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(30.743, 8.079);
    path_22.cubicTo(
      30.753,
      8.383000000000001,
      31.075999999999997,
      8.485000000000001,
      31.468999999999998,
      8.472000000000001,
    );
    path_22.cubicTo(
      31.860999999999997,
      8.459000000000001,
      32.175999999999995,
      8.336000000000002,
      32.166,
      8.032000000000002,
    );
    path_22.cubicTo(
      32.154999999999994,
      7.729000000000002,
      31.827999999999996,
      7.492000000000002,
      31.435999999999996,
      7.505000000000002,
    );
    path_22.cubicTo(
      31.041999999999998,
      7.518000000000002,
      30.731999999999996,
      7.775000000000002,
      30.742999999999995,
      8.079000000000002,
    );
    path_22.close();

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(20.361, 4.7);
    path_23.cubicTo(20.385, 5.3950000000000005, 20.991, 5.94, 21.713, 5.917);
    path_23.cubicTo(22.435000000000002, 5.893, 23, 5.31, 22.976, 4.615);
    path_23.cubicTo(
      22.951999999999998,
      3.9190000000000005,
      22.346,
      3.375,
      21.624,
      3.398,
    );
    path_23.cubicTo(
      20.901999999999997,
      3.422,
      20.337,
      4.005,
      20.360999999999997,
      4.7,
    );
    path_23.close();

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(20.361, 4.7);
    path_24.cubicTo(20.385, 5.3950000000000005, 20.991, 5.94, 21.713, 5.917);
    path_24.cubicTo(22.435000000000002, 5.893, 23, 5.31, 22.976, 4.615);
    path_24.cubicTo(
      22.951999999999998,
      3.9190000000000005,
      22.346,
      3.375,
      21.624,
      3.398,
    );
    path_24.cubicTo(
      20.901999999999997,
      3.422,
      20.337,
      4.005,
      20.360999999999997,
      4.7,
    );
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(20.361, 4.704);
    path_25.cubicTo(
      20.385,
      5.394,
      20.994,
      5.941,
      21.711000000000002,
      5.917999999999999,
    );
    path_25.cubicTo(
      22.433000000000003,
      5.895,
      23.003000000000004,
      5.307999999999999,
      22.979000000000003,
      4.617999999999999,
    );
    path_25.arcToPoint(
      Offset(22.949, 4.417999999999999),
      radius: Radius.elliptical(0.888, 0.888),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_25.cubicTo(
      22.866000000000003,
      5.017999999999999,
      22.345000000000002,
      5.4879999999999995,
      21.696,
      5.507999999999999,
    );
    path_25.cubicTo(
      21.054000000000002,
      5.528999999999999,
      20.502000000000002,
      5.094999999999999,
      20.376,
      4.501999999999999,
    );
    path_25.arcToPoint(
      Offset(20.361, 4.703999999999999),
      radius: Radius.elliptical(0.889, 0.889),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(20.947, 4.172);
    path_26.cubicTo(
      20.957,
      4.475,
      21.279999999999998,
      4.577999999999999,
      21.672,
      4.5649999999999995,
    );
    path_26.cubicTo(
      22.065,
      4.552,
      22.379,
      4.428999999999999,
      22.369,
      4.124999999999999,
    );
    path_26.cubicTo(
      22.358999999999998,
      3.8209999999999993,
      22.031,
      3.584999999999999,
      21.639,
      3.597999999999999,
    );
    path_26.cubicTo(
      21.246,
      3.610999999999999,
      20.936,
      3.867999999999999,
      20.947,
      4.171999999999999,
    );
    path_26.close();

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(10.565, 8.61);
    path_27.cubicTo(
      10.588999999999999,
      9.305,
      11.195,
      9.85,
      11.917,
      9.825999999999999,
    );
    path_27.cubicTo(12.639, 9.802, 13.204, 9.219, 13.18, 8.524);
    path_27.cubicTo(
      13.156,
      7.827999999999999,
      12.549999999999999,
      7.283999999999999,
      11.828,
      7.306999999999999,
    );
    path_27.cubicTo(
      11.106,
      7.330999999999999,
      10.541,
      7.913999999999999,
      10.565,
      8.608999999999998,
    );
    path_27.close();

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(10.565, 8.61);
    path_28.cubicTo(
      10.588999999999999,
      9.305,
      11.195,
      9.85,
      11.917,
      9.825999999999999,
    );
    path_28.cubicTo(12.639, 9.802, 13.204, 9.219, 13.18, 8.524);
    path_28.cubicTo(
      13.156,
      7.827999999999999,
      12.549999999999999,
      7.283999999999999,
      11.828,
      7.306999999999999,
    );
    path_28.cubicTo(
      11.106,
      7.330999999999999,
      10.541,
      7.913999999999999,
      10.565,
      8.608999999999998,
    );
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(10.565, 8.61);
    path_29.cubicTo(
      10.588999999999999,
      9.299999999999999,
      11.198,
      9.847999999999999,
      11.915,
      9.825,
    );
    path_29.cubicTo(
      12.636999999999999,
      9.801,
      13.206999999999999,
      9.215,
      13.183,
      8.524999999999999,
    );
    path_29.arcToPoint(
      Offset(13.153, 8.325),
      radius: Radius.elliptical(0.888, 0.888),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_29.cubicTo(13.07, 8.924999999999999, 12.548, 9.395, 11.9, 9.415);
    path_29.arcToPoint(
      Offset(10.58, 8.408999999999999),
      radius: Radius.elliptical(1.295, 1.295),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_29.arcToPoint(
      Offset(10.565, 8.610999999999999),
      radius: Radius.elliptical(0.88, 0.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_29.close();

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(11.15, 8.079);
    path_30.cubicTo(
      11.162,
      8.383000000000001,
      11.484,
      8.485000000000001,
      11.877,
      8.472000000000001,
    );
    path_30.cubicTo(
      12.269,
      8.459000000000001,
      12.584000000000001,
      8.336000000000002,
      12.573,
      8.032000000000002,
    );
    path_30.cubicTo(
      12.563,
      7.729000000000002,
      12.236,
      7.492000000000002,
      11.843,
      7.505000000000002,
    );
    path_30.cubicTo(
      11.45,
      7.518000000000002,
      11.141,
      7.775000000000002,
      11.151,
      8.079000000000002,
    );
    path_30.close();

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);

    Path path_31 = Path();
    path_31.moveTo(6.166, 18.043);
    path_31.cubicTo(6.19, 18.738, 6.795, 19.282999999999998, 7.516, 19.259);
    path_31.cubicTo(8.239, 19.236, 8.804, 18.653, 8.78, 17.958000000000002);
    path_31.cubicTo(
      8.754999999999999,
      17.262,
      8.149999999999999,
      16.718000000000004,
      7.427999999999999,
      16.741000000000003,
    );
    path_31.cubicTo(
      6.706999999999999,
      16.764000000000003,
      6.140999999999999,
      17.347000000000005,
      6.165999999999999,
      18.043000000000003,
    );
    path_31.close();

    Paint paint_31_fill = Paint()..style = PaintingStyle.fill;
    paint_31_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_fill);

    Path path_32 = Path();
    path_32.moveTo(6.166, 18.043);
    path_32.cubicTo(6.19, 18.738, 6.795, 19.282999999999998, 7.516, 19.259);
    path_32.cubicTo(8.239, 19.236, 8.804, 18.653, 8.78, 17.958000000000002);
    path_32.cubicTo(
      8.754999999999999,
      17.262,
      8.149999999999999,
      16.718000000000004,
      7.427999999999999,
      16.741000000000003,
    );
    path_32.cubicTo(
      6.706999999999999,
      16.764000000000003,
      6.140999999999999,
      17.347000000000005,
      6.165999999999999,
      18.043000000000003,
    );
    path_32.close();

    Paint paint_32_fill = Paint()..style = PaintingStyle.fill;
    paint_32_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_32, paint_32_fill);

    Path path_33 = Path();
    path_33.moveTo(6.166, 18.047);
    path_33.cubicTo(
      6.19,
      18.737000000000002,
      6.799,
      19.285,
      7.515000000000001,
      19.261,
    );
    path_33.cubicTo(
      8.238000000000001,
      19.238,
      8.807,
      18.651,
      8.783000000000001,
      17.962,
    );
    path_33.arcToPoint(
      Offset(8.753000000000002, 17.762),
      radius: Radius.elliptical(0.89, 0.89),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_33.cubicTo(
      8.671000000000001,
      18.362000000000002,
      8.150000000000002,
      18.831,
      7.501000000000002,
      18.852,
    );
    path_33.arcToPoint(
      Offset(6.181000000000002, 17.845),
      radius: Radius.elliptical(1.297, 1.297),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_33.arcToPoint(
      Offset(6.166000000000002, 18.047),
      radius: Radius.elliptical(0.884, 0.884),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_33.close();

    Paint paint_33_fill = Paint()..style = PaintingStyle.fill;
    paint_33_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_fill);

    Path path_34 = Path();
    path_34.moveTo(6.751, 17.515);
    path_34.cubicTo(
      6.7620000000000005,
      17.819,
      7.0840000000000005,
      17.921,
      7.477,
      17.908,
    );
    path_34.cubicTo(7.87, 17.895, 8.184000000000001, 17.773, 8.174, 17.469);
    path_34.cubicTo(
      8.163,
      17.165000000000003,
      7.835999999999999,
      16.929000000000002,
      7.443999999999999,
      16.942,
    );
    path_34.cubicTo(
      7.049999999999999,
      16.955000000000002,
      6.739999999999999,
      17.212,
      6.7509999999999994,
      17.515,
    );
    path_34.close();

    Paint paint_34_fill = Paint()..style = PaintingStyle.fill;
    paint_34_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_34, paint_34_fill);

    Path path_35 = Path();
    path_35.moveTo(10.565, 27.478);
    path_35.cubicTo(
      10.588999999999999,
      28.174000000000003,
      11.195,
      28.718,
      11.917,
      28.695,
    );
    path_35.cubicTo(12.639, 28.672, 13.204, 28.089, 13.18, 27.393);
    path_35.cubicTo(
      13.156,
      26.698,
      12.549999999999999,
      26.153000000000002,
      11.828,
      26.177,
    );
    path_35.cubicTo(11.106, 26.2, 10.541, 26.783, 10.565, 27.477999999999998);
    path_35.close();

    Paint paint_35_fill = Paint()..style = PaintingStyle.fill;
    paint_35_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_35, paint_35_fill);

    Path path_36 = Path();
    path_36.moveTo(10.565, 27.478);
    path_36.cubicTo(
      10.588999999999999,
      28.174000000000003,
      11.195,
      28.718,
      11.917,
      28.695,
    );
    path_36.cubicTo(12.639, 28.672, 13.204, 28.089, 13.18, 27.393);
    path_36.cubicTo(
      13.156,
      26.698,
      12.549999999999999,
      26.153000000000002,
      11.828,
      26.177,
    );
    path_36.cubicTo(11.106, 26.2, 10.541, 26.783, 10.565, 27.477999999999998);
    path_36.close();

    Paint paint_36_fill = Paint()..style = PaintingStyle.fill;
    paint_36_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_36, paint_36_fill);

    Path path_37 = Path();
    path_37.moveTo(10.565, 27.482);
    path_37.cubicTo(
      10.588999999999999,
      28.172,
      11.198,
      28.719,
      11.915,
      28.695999999999998,
    );
    path_37.cubicTo(
      12.636999999999999,
      28.671999999999997,
      13.206999999999999,
      28.086,
      13.183,
      27.395999999999997,
    );
    path_37.arcToPoint(
      Offset(13.153, 27.195999999999998),
      radius: Radius.elliptical(0.888, 0.888),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_37.cubicTo(13.07, 27.796, 12.548, 28.266, 11.9, 28.285999999999998);
    path_37.arcToPoint(
      Offset(10.58, 27.279999999999998),
      radius: Radius.elliptical(1.295, 1.295),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_37.arcToPoint(
      Offset(10.565, 27.482),
      radius: Radius.elliptical(0.88, 0.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_37.close();

    Paint paint_37_fill = Paint()..style = PaintingStyle.fill;
    paint_37_fill.color = Color(0xffA97C12).withOpacity(1.0);
    canvas.drawPath(path_37, paint_37_fill);

    Path path_38 = Path();
    path_38.moveTo(11.15, 26.949);
    path_38.cubicTo(11.162, 27.253, 11.484, 27.355, 11.877, 27.342000000000002);
    path_38.cubicTo(
      12.269,
      27.329,
      12.584000000000001,
      27.206000000000003,
      12.573,
      26.902,
    );
    path_38.cubicTo(12.563, 26.599, 12.236, 26.363, 11.843, 26.375);
    path_38.cubicTo(11.45, 26.388, 11.141, 26.645, 11.151, 26.949);
    path_38.close();

    Paint paint_38_fill = Paint()..style = PaintingStyle.fill;
    paint_38_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_38, paint_38_fill);

    Path path_39 = Path();
    path_39.moveTo(28.914, 16.808);
    path_39.arcToPoint(
      Offset(28.593, 18.428),
      radius: Radius.elliptical(4.458, 4.458),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.cubicTo(27.75, 20.535, 25.375, 23.175, 21.762999999999998, 24.608);
    path_39.cubicTo(
      21.743,
      24.617,
      21.718999999999998,
      24.625,
      21.695999999999998,
      24.633,
    );
    path_39.arcToPoint(
      Offset(21.628999999999998, 24.608999999999998),
      radius: Radius.elliptical(1.794, 1.794),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.cubicTo(
      18.016999999999996,
      23.174999999999997,
      15.641999999999998,
      20.534999999999997,
      14.798999999999998,
      18.429,
    );
    path_39.arcToPoint(
      Offset(14.490999999999998, 17.095),
      radius: Radius.elliptical(4.385, 4.385),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.arcToPoint(
      Offset(14.477999999999998, 16.808),
      radius: Radius.elliptical(2.671, 2.671),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.cubicTo(
      14.474999999999998,
      16.754,
      14.477999999999998,
      16.698,
      14.480999999999998,
      16.643,
    );
    path_39.cubicTo(
      14.516999999999998,
      15.085,
      15.377999999999998,
      13.641000000000002,
      16.799,
      13.021,
    );
    path_39.cubicTo(
      18.613,
      12.229000000000001,
      20.706,
      13.062000000000001,
      21.68,
      14.888000000000002,
    );
    path_39.cubicTo(
      21.688,
      14.901000000000002,
      21.704,
      14.901000000000002,
      21.712,
      14.888000000000002,
    );
    path_39.cubicTo(
      22.686,
      13.062000000000001,
      24.779,
      12.228000000000002,
      26.593,
      13.021,
    );
    path_39.cubicTo(28.014, 13.641, 28.875, 15.085, 28.911, 16.643);
    path_39.cubicTo(28.914, 16.697, 28.916, 16.753, 28.914, 16.808);
    path_39.close();

    Paint paint_39_fill = Paint()..style = PaintingStyle.fill;
    paint_39_fill.color = Color(0xffF22828).withOpacity(1.0);
    canvas.drawPath(path_39, paint_39_fill);

    Path path_40 = Path();
    path_40.moveTo(28.914, 16.808);
    path_40.arcToPoint(
      Offset(28.593, 18.428),
      radius: Radius.elliptical(4.458, 4.458),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_40.cubicTo(27.75, 20.535, 25.375, 23.175, 21.762999999999998, 24.608);
    path_40.cubicTo(
      21.743,
      24.617,
      21.718999999999998,
      24.625,
      21.695999999999998,
      24.633,
    );
    path_40.arcToPoint(
      Offset(21.628999999999998, 24.608999999999998),
      radius: Radius.elliptical(1.794, 1.794),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_40.cubicTo(
      18.016999999999996,
      23.174999999999997,
      15.641999999999998,
      20.534999999999997,
      14.798999999999998,
      18.429,
    );
    path_40.arcToPoint(
      Offset(14.490999999999998, 17.095),
      radius: Radius.elliptical(4.385, 4.385),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_40.arcToPoint(
      Offset(14.477999999999998, 16.808),
      radius: Radius.elliptical(2.671, 2.671),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_40.cubicTo(
      14.474999999999998,
      16.754,
      14.477999999999998,
      16.698,
      14.480999999999998,
      16.643,
    );
    path_40.cubicTo(
      14.516999999999998,
      15.085,
      15.377999999999998,
      13.641000000000002,
      16.799,
      13.021,
    );
    path_40.cubicTo(
      18.613,
      12.229000000000001,
      20.706,
      13.062000000000001,
      21.68,
      14.888000000000002,
    );
    path_40.cubicTo(
      21.688,
      14.901000000000002,
      21.704,
      14.901000000000002,
      21.712,
      14.888000000000002,
    );
    path_40.cubicTo(
      22.686,
      13.062000000000001,
      24.779,
      12.228000000000002,
      26.593,
      13.021,
    );
    path_40.cubicTo(28.014, 13.641, 28.875, 15.085, 28.911, 16.643);
    path_40.cubicTo(28.914, 16.697, 28.916, 16.753, 28.914, 16.808);
    path_40.close();

    Paint paint_40_fill = Paint()..style = PaintingStyle.fill;
    paint_40_fill.color = Color(0xffF22828).withOpacity(1.0);
    canvas.drawPath(path_40, paint_40_fill);

    Path path_41 = Path();
    path_41.moveTo(27.15, 17.379);
    path_41.arcToPoint(
      Offset(26.907, 18.603),
      radius: Radius.elliptical(3.372, 3.372),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_41.cubicTo(26.271, 20.195, 24.476, 22.19, 21.747, 23.273000000000003);
    path_41.arcToPoint(
      Offset(21.695, 23.292),
      radius: Radius.elliptical(1.448, 1.448),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_41.arcToPoint(
      Offset(21.645, 23.274),
      radius: Radius.elliptical(1.44, 1.44),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_41.cubicTo(18.915, 22.19, 17.119999999999997, 20.195, 16.483, 18.603);
    path_41.arcToPoint(
      Offset(16.243000000000002, 17.253),
      radius: Radius.elliptical(3.307, 3.307),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_41.cubicTo(
      16.270000000000003,
      16.076,
      16.921000000000003,
      14.985,
      17.994000000000003,
      14.517,
    );
    path_41.cubicTo(
      19.366000000000003,
      13.917,
      20.947000000000003,
      14.546999999999999,
      21.684000000000005,
      15.927,
    );
    path_41.cubicTo(
      21.690000000000005,
      15.937,
      21.701000000000004,
      15.937,
      21.707000000000004,
      15.927,
    );
    path_41.cubicTo(
      22.444000000000003,
      14.547,
      24.026000000000003,
      13.917,
      25.397000000000006,
      14.517,
    );
    path_41.cubicTo(
      26.471000000000007,
      14.985,
      27.122000000000007,
      16.076999999999998,
      27.149000000000004,
      17.253999999999998,
    );
    path_41.cubicTo(
      27.151000000000003,
      17.293999999999997,
      27.153000000000006,
      17.337999999999997,
      27.151000000000003,
      17.378999999999998,
    );
    path_41.close();

    Paint paint_41_fill = Paint()..style = PaintingStyle.fill;
    paint_41_fill.color = Color(0xffF22828).withOpacity(1.0);
    canvas.drawPath(path_41, paint_41_fill);

    Path path_42 = Path();
    path_42.moveTo(16.035, 15.45);
    path_42.arcToPoint(
      Offset(17.205, 14.280999999999999),
      radius: Radius.elliptical(1.17, 1.17),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_42.lineTo(18.762999999999998, 14.280999999999999);
    path_42.cubicTo(
      19.409,
      14.280999999999999,
      19.933,
      14.805,
      19.933,
      15.450999999999999,
    );
    path_42.lineTo(19.933, 17.788);
    path_42.arcToPoint(
      Offset(18.762999999999998, 18.958),
      radius: Radius.elliptical(1.17, 1.17),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_42.lineTo(17.203999999999997, 18.958);
    path_42.arcToPoint(
      Offset(16.034999999999997, 17.787999999999997),
      radius: Radius.elliptical(1.169, 1.169),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_42.lineTo(16.034999999999997, 15.45);
    path_42.close();

    Paint paint_42_fill = Paint()..style = PaintingStyle.fill;
    paint_42_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6001951, size.height * 0.2362821),
      Offset(size.width * 0.6475610, size.height * 0.4757436),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_42, paint_42_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
