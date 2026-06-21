import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MagnatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(30.335, 20.866);
    path_0.lineTo(23.009, 22.322);
    path_0.cubicTo(23.009, 22.322, 30.086, 43.224000000000004, 16.529, 43.046);
    path_0.cubicTo(
      14.681,
      43.022,
      6.429,
      41.056,
      12.469000000000001,
      22.951999999999998,
    );
    path_0.lineTo(4.624000000000001, 21.272);
    path_0.cubicTo(
      4.624000000000001,
      21.272,
      0.7850000000000015,
      29.817,
      2.1640000000000015,
      40.221999999999994,
    );
    path_0.cubicTo(
      3.5440000000000014,
      50.62799999999999,
      12.069,
      52.467999999999996,
      17.566000000000003,
      52.651999999999994,
    );
    path_0.cubicTo(
      22.938000000000002,
      52.830999999999996,
      39.621,
      47.400999999999996,
      30.336000000000002,
      20.865999999999993,
    );
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF02300).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(1.969, 31.822);
    path_1.lineTo(1.969, 31.82);
    path_1.cubicTo(2.59, 25.64, 4.526, 21.276, 4.545, 21.233);
    path_1.lineTo(4.575, 21.167);
    path_1.lineTo(12.582, 22.882);
    path_1.lineTo(12.55, 22.975);
    path_1.cubicTo(
      11.443000000000001,
      26.292,
      10.752,
      29.275000000000002,
      10.494,
      31.839000000000002,
    );
    path_1.lineTo(10.494, 31.841);
    path_1.cubicTo(10.086, 35.905, 10.738, 38.953, 12.432, 40.901);
    path_1.cubicTo(
      14.142,
      42.867000000000004,
      16.29,
      42.952000000000005,
      16.529,
      42.955000000000005,
    );
    path_1.cubicTo(
      21.399,
      43.02,
      24.139,
      40.36300000000001,
      24.672,
      35.05800000000001,
    );
    path_1.cubicTo(
      25.25,
      29.306000000000008,
      22.95,
      22.42000000000001,
      22.926000000000002,
      22.352000000000007,
    );
    path_1.lineTo(22.893, 22.25400000000001);
    path_1.lineTo(30.393, 20.76400000000001);
    path_1.lineTo(30.417, 20.83400000000001);
    path_1.cubicTo(
      32.641000000000005,
      27.19200000000001,
      33.527,
      32.80400000000001,
      33.054,
      37.51700000000001,
    );
    path_1.cubicTo(
      32.378,
      44.247000000000014,
      29.03,
      47.92500000000001,
      26.340000000000003,
      49.82500000000001,
    );
    path_1.cubicTo(
      23.141000000000005,
      52.08500000000001,
      19.609,
      52.80600000000001,
      17.555000000000003,
      52.73800000000001,
    );
    path_1.cubicTo(
      11.220000000000002,
      52.526,
      3.392000000000003,
      50.184000000000005,
      2.075000000000003,
      40.232000000000006,
    );
    path_1.arcToPoint(
      Offset(1.9690000000000027, 31.822000000000006),
      radius: Radius.elliptical(36.394, 36.394),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.close();
    path_1.moveTo(4.673, 21.37);
    path_1.cubicTo(4.43, 21.94, 2.718, 26.099, 2.141, 31.834000000000003);
    path_1.lineTo(2.141, 31.835000000000004);
    path_1.arcToPoint(
      Offset(2.247, 40.20400000000001),
      radius: Radius.elliptical(36.263, 36.263),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.cubicTo(
      3.549,
      50.037000000000006,
      11.296,
      52.351000000000006,
      17.567,
      52.56100000000001,
    );
    path_1.cubicTo(
      19.593,
      52.629000000000005,
      23.081,
      51.915000000000006,
      26.245,
      49.681000000000004,
    );
    path_1.cubicTo(
      28.903000000000002,
      47.801,
      32.213,
      44.165000000000006,
      32.882,
      37.504000000000005,
    );
    path_1.cubicTo(
      33.352,
      32.834,
      32.475,
      27.271000000000004,
      30.278,
      20.967000000000006,
    );
    path_1.lineTo(23.122999999999998, 22.387000000000008);
    path_1.cubicTo(
      23.401999999999997,
      23.253000000000007,
      25.388999999999996,
      29.657000000000007,
      24.845,
      35.071000000000005,
    );
    path_1.cubicTo(24.599999999999998, 37.505, 23.88, 39.42, 22.705, 40.761);
    path_1.cubicTo(
      21.294999999999998,
      42.371,
      19.214999999999996,
      43.168000000000006,
      16.522,
      43.132000000000005,
    );
    path_1.cubicTo(
      16.275,
      43.129000000000005,
      14.057999999999998,
      43.042,
      12.300999999999998,
      41.022000000000006,
    );
    path_1.cubicTo(
      10.573999999999998,
      39.03600000000001,
      9.907999999999998,
      35.94200000000001,
      10.320999999999998,
      31.828000000000003,
    );
    path_1.lineTo(10.320999999999998, 31.826000000000004);
    path_1.cubicTo(
      10.577999999999998,
      29.271000000000004,
      11.261999999999999,
      26.308000000000003,
      12.354999999999997,
      23.016000000000005,
    );
    path_1.lineTo(4.673, 21.37);
    path_1.close();

    Path path_2 = Path();
    path_2.moveTo(32.288, 38.948);
    path_2.cubicTo(
      31.562999999999995,
      43.208,
      29.373999999999995,
      48.452,
      24.416999999999994,
      50.971000000000004,
    );
    path_2.arcToPoint(
      Offset(23.839999999999996, 51.295),
      radius: Radius.elliptical(7.007, 7.007),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.cubicTo(
      30.131999999999998,
      48.419000000000004,
      37.086,
      40.358000000000004,
      30.405999999999995,
      21.108,
    );
    path_2.lineTo(23.201999999999995, 22.551000000000002);
    path_2.cubicTo(
      23.201999999999995,
      22.551000000000002,
      24.475999999999996,
      26.347,
      24.891999999999996,
      30.677,
    );
    path_2.cubicTo(
      26.168999999999997,
      30.431,
      29.168999999999997,
      29.852999999999998,
      31.017999999999997,
      29.512,
    );
    path_2.cubicTo(32.18, 29.288, 33.013, 34.689, 32.288, 38.948);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFFAEA3).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(12.187, 22.897);
    path_3.lineTo(4.37, 21.24);
    path_3.cubicTo(
      4.37,
      21.24,
      3.154,
      23.939999999999998,
      2.3160000000000003,
      28.150999999999996,
    );
    path_3.lineTo(10.326, 30.075999999999997);
    path_3.cubicTo(
      10.668000000000001,
      28.019999999999996,
      11.263,
      25.644999999999996,
      12.186,
      22.897,
    );
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffA3A5A8).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(2.215, 28.218);
    path_4.lineTo(2.231, 28.135);
    path_4.cubicTo(
      3.062,
      23.962000000000003,
      4.279999999999999,
      21.231,
      4.291,
      21.205000000000002,
    );
    path_4.lineTo(4.321000000000001, 21.138);
    path_4.lineTo(12.3, 22.828000000000003);
    path_4.lineTo(12.268, 22.922000000000004);
    path_4.cubicTo(
      11.394,
      25.524000000000004,
      10.768,
      27.934000000000005,
      10.41,
      30.087000000000003,
    );
    path_4.lineTo(10.394, 30.184000000000005);
    path_4.lineTo(10.302, 30.162000000000006);
    path_4.lineTo(2.215, 28.218000000000007);
    path_4.close();
    path_4.moveTo(4.4190000000000005, 21.341);
    path_4.cubicTo(
      4.23,
      21.781000000000002,
      3.1710000000000003,
      24.337,
      2.4170000000000007,
      28.081000000000003,
    );
    path_4.lineTo(10.256, 29.966000000000005);
    path_4.cubicTo(
      10.614,
      27.855000000000004,
      11.226,
      25.500000000000004,
      12.073,
      22.964000000000006,
    );
    path_4.lineTo(4.42, 21.34);
    path_4.close();

    Path path_5 = Path();
    path_5.moveTo(30.326, 21.08);
    path_5.lineTo(23.018, 22.572);
    path_5.cubicTo(23.018, 22.572, 24.206, 26.165, 24.64, 30.366999999999997);
    path_5.lineTo(32.366, 28.686999999999998);
    path_5.cubicTo(
      31.935,
      26.365999999999996,
      31.269,
      23.836,
      30.326,
      21.078999999999997,
    );
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffA3A5A8).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(22.903, 22.506);
    path_6.lineTo(30.384, 20.979);
    path_6.lineTo(30.408, 21.049);
    path_6.cubicTo(31.318, 23.713, 32.006, 26.276, 32.45, 28.669);
    path_6.lineTo(32.466, 28.757);
    path_6.lineTo(24.563000000000002, 30.474);
    path_6.lineTo(24.553, 30.38);
    path_6.cubicTo(24.125, 26.237, 22.947, 22.64, 22.936, 22.604);
    path_6.lineTo(22.903, 22.506);
    path_6.close();
    path_6.moveTo(30.269, 21.183);
    path_6.lineTo(23.131, 22.639);
    path_6.cubicTo(23.321, 23.241, 24.318, 26.519, 24.715, 30.261);
    path_6.lineTo(32.264, 28.621);
    path_6.cubicTo(
      31.824,
      26.282999999999998,
      31.154000000000003,
      23.781,
      30.269000000000002,
      21.183,
    );
    path_6.close();

    Path path_7 = Path();
    path_7.moveTo(12.186, 22.898);
    path_7.lineTo(4.373, 21.243);
    path_7.cubicTo(
      4.373,
      21.243,
      3.156,
      23.942999999999998,
      2.3160000000000003,
      28.156,
    );
    path_7.lineTo(10.322000000000001, 30.079);
    path_7.cubicTo(
      10.665000000000001,
      28.022000000000002,
      11.262,
      25.646,
      12.186000000000002,
      22.898,
    );
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffA3A5A8).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(2.215, 28.225);
    path_8.lineTo(2.2319999999999998, 28.142000000000003);
    path_8.cubicTo(
      3.0639999999999996,
      23.967000000000002,
      4.282,
      21.236000000000004,
      4.295,
      21.209000000000003,
    );
    path_8.lineTo(4.325, 21.142000000000003);
    path_8.lineTo(12.299, 22.831000000000003);
    path_8.lineTo(12.267999999999999, 22.925000000000004);
    path_8.cubicTo(
      11.392,
      25.527000000000005,
      10.765999999999998,
      27.938000000000002,
      10.406999999999998,
      30.092000000000006,
    );
    path_8.lineTo(10.390999999999998, 30.189000000000007);
    path_8.lineTo(10.298999999999998, 30.16700000000001);
    path_8.lineTo(2.214999999999998, 28.22500000000001);
    path_8.close();
    path_8.moveTo(4.422, 21.345000000000002);
    path_8.cubicTo(
      4.233,
      21.785000000000004,
      3.1719999999999997,
      24.343000000000004,
      2.417,
      28.089000000000002,
    );
    path_8.lineTo(10.253, 29.971000000000004);
    path_8.cubicTo(
      10.613,
      27.859,
      11.224,
      25.503000000000004,
      12.073,
      22.966000000000005,
    );
    path_8.lineTo(4.422000000000001, 21.346000000000004);
    path_8.close();

    Path path_9 = Path();
    path_9.moveTo(26.637, 29.784);
    path_9.cubicTo(26.299, 26.511, 25.434, 23.548, 24.975, 22.144);
    path_9.lineTo(22.966, 22.543999999999997);
    path_9.cubicTo(
      22.966,
      22.543999999999997,
      24.153000000000002,
      26.055999999999997,
      24.619,
      30.180999999999997,
    );
    path_9.cubicTo(25.291, 30.048, 25.962, 29.903, 26.637, 29.784);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffA3A5A8).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(26.75, 29.782);
    path_10.cubicTo(26.074, 29.903, 25.402, 30.048000000000002, 24.73, 30.18);
    path_10.cubicTo(25.347, 35.79, 24.61, 42.49, 17.75, 43.04);
    path_10.lineTo(17.755, 43.094);
    path_10.cubicTo(
      26.185,
      42.606,
      27.342999999999996,
      35.708,
      26.749,
      29.782000000000004,
    );
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xff8B1000).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(5.342, 28.796);
    path_11.arcToPoint(
      Offset(7.172, 21.863),
      radius: Radius.elliptical(70.365, 70.365),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_11.lineTo(4.3, 21.246);
    path_11.cubicTo(4.3, 21.246, 3.094, 23.939, 2.284, 28.14);
    path_11.arcToPoint(
      Offset(5.342, 28.796),
      radius: Radius.elliptical(36.15, 36.15),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffA3A5A8).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(16.727, 52.437);
    path_12.lineTo(16.591, 52.4);
    path_12.cubicTo(16.591, 52.4, 0.764, 52.473, 5.634, 28.804);
    path_12.arcToPoint(
      Offset(2.567, 28.142),
      radius: Radius.elliptical(37.886, 37.886),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_12.cubicTo(
      1.9410000000000003,
      31.404,
      1.5560000000000003,
      35.565,
      2.1540000000000004,
      40.077,
    );
    path_12.cubicTo(
      3.4670000000000005,
      49.977,
      11.258,
      52.102999999999994,
      16.727,
      52.437,
    );
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xff8B1000).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(32.242, 28.419);
    path_13.cubicTo(32.262, 28.494, 32.282, 28.564, 32.303999999999995, 28.632);
    path_13.lineTo(32.30499999999999, 28.632);
    path_13.cubicTo(
      31.86799999999999,
      26.364,
      31.19899999999999,
      23.892000000000003,
      30.254999999999992,
      21.196,
    );
    path_13.lineTo(23.67499999999999, 22.504);
    path_13.cubicTo(
      25.38499999999999,
      22.328000000000003,
      28.20299999999999,
      22.042,
      29.32499999999999,
      21.953000000000003,
    );
    path_13.cubicTo(
      30.28699999999999,
      21.930000000000003,
      31.34799999999999,
      24.983000000000004,
      32.24199999999999,
      28.419000000000004,
    );
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffFDFFFF).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(24.658, 30.338);
    path_14.lineTo(32.429, 28.692);
    path_14.arcToPoint(
      Offset(32.356, 28.32),
      radius: Radius.elliptical(42.776, 42.776),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.cubicTo(31.199, 28.52, 27.953000000000003, 29.09, 26.222, 29.453);
    path_14.cubicTo(
      24.592000000000002,
      29.835,
      24.725,
      25.743,
      23.200000000000003,
      22.497,
    );
    path_14.lineTo(22.980000000000004, 22.541);
    path_14.cubicTo(
      22.980000000000004,
      22.541,
      24.197000000000003,
      26.137,
      24.658000000000005,
      30.338,
    );
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Color(0xff5C5D60).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(25.17, 30.196);
    path_15.lineTo(28.366000000000003, 29.542);
    path_15.arcToPoint(
      Offset(31.668000000000003, 25.44),
      radius: Radius.elliptical(195.047, 195.047),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(30.745000000000005, 22.438000000000002),
      radius: Radius.elliptical(57.6, 57.6),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.cubicTo(
      28.780000000000005,
      24.946,
      26.945000000000004,
      27.550000000000004,
      25.169000000000004,
      30.196,
    );
    path_15.close();
    path_15.moveTo(23.718000000000004, 25.334000000000003);
    path_15.cubicTo(
      23.814000000000004,
      25.717000000000002,
      23.912000000000003,
      26.129000000000005,
      24.008000000000003,
      26.566000000000003,
    );
    path_15.arcToPoint(
      Offset(27.337000000000003, 21.706000000000003),
      radius: Radius.elliptical(99.982, 99.982),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.lineTo(26.269000000000002, 21.910000000000004);
    path_15.arcToPoint(
      Offset(23.718000000000004, 25.334000000000003),
      radius: Radius.elliptical(351.3, 351.3),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffCFD1D4).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(10.916, 25.451);
    path_16.cubicTo(
      10.593,
      26.737000000000002,
      10.237,
      28.615000000000002,
      10.141,
      29.966,
    );
    path_16.lineTo(10.284, 30);
    path_16.cubicTo(
      10.610000000000001,
      27.990000000000002,
      11.184000000000001,
      25.67,
      12.079,
      22.987000000000002,
    );
    path_16.lineTo(5.21, 21.515);
    path_16.cubicTo(6.8919999999999995, 21.995, 9.407, 22.702, 10.538, 22.974);
    path_16.cubicTo(11.639, 23.349, 11.39, 23.564, 10.916, 25.451);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffFDFFFF).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(10.412, 29.696);
    path_17.cubicTo(
      9.246,
      29.386000000000003,
      6.014000000000001,
      28.521,
      4.421000000000001,
      28.016000000000002,
    );
    path_17.cubicTo(
      2.6050000000000013,
      27.438000000000002,
      3.5280000000000014,
      25.701,
      4.551000000000001,
      21.295,
    );
    path_17.lineTo(4.329000000000001, 21.247000000000003);
    path_17.cubicTo(
      4.329000000000001,
      21.247000000000003,
      3.1260000000000003,
      23.927000000000003,
      2.3090000000000006,
      28.113000000000003,
    );
    path_17.lineTo(10.351, 30.061000000000003);
    path_17.lineTo(10.412, 29.696000000000005);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xff5C5D60).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(6.362, 29.073);
    path_18.lineTo(7.896, 29.448);
    path_18.arcToPoint(
      Offset(11.225999999999999, 26.311),
      radius: Radius.elliptical(47.33, 47.33),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_18.cubicTo(11.376, 25.737, 11.543, 25.143, 11.726999999999999, 24.529);
    path_18.cubicTo(
      9.907999999999998,
      26.006,
      8.136999999999999,
      27.543,
      6.361999999999998,
      29.073,
    );
    path_18.close();
    path_18.moveTo(5.5440000000000005, 22.273);
    path_18.cubicTo(4.815, 22.745, 4.094, 23.23, 3.3800000000000003, 23.725);
    path_18.arcToPoint(
      Offset(2.29, 28.079),
      radius: Radius.elliptical(38.88, 38.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_18.lineTo(2.534, 28.139);
    path_18.cubicTo(5.1419999999999995, 26.247, 7.761, 24.372, 10.442, 22.589);
    path_18.lineTo(6.422000000000001, 21.715999999999998);
    path_18.cubicTo(
      6.1290000000000004,
      21.9,
      5.835000000000001,
      22.083999999999996,
      5.5440000000000005,
      22.272999999999996,
    );
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Color(0xffCFD1D4).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(5.525, 28.952);
    path_19.cubicTo(5.525, 28.952, 9.747, 30.045, 9.557, 31.756);
    path_19.cubicTo(9.341000000000001, 33.697, 8.893, 42.212, 15.97, 43.112);
    path_19.cubicTo(
      13.155000000000001,
      42.166000000000004,
      9.536000000000001,
      39.752,
      10.21,
      31.263,
    );
    path_19.cubicTo(10.352, 29.747, 10.224, 30.136000000000003, 9.131, 29.788);
    path_19.cubicTo(8.038, 29.44, 5.525, 28.952, 5.525, 28.952);
    path_19.close();

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffFFAEA3).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(15.72, 3.093);
    path_20.lineTo(10.440000000000001, 7.0969999999999995);
    path_20.arcToPoint(
      Offset(10.007000000000001, 9.152),
      radius: Radius.elliptical(1.603, 1.603),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_20.lineTo(12.153000000000002, 13.017);
    path_20.arcToPoint(
      Offset(12.074000000000002, 14.700999999999999),
      radius: Radius.elliptical(1.603, 1.603),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_20.lineTo(9.77, 18.067);

    Paint paint_20_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04332432;
    paint_20_stroke.strokeCap = StrokeCap.round;
    paint_20_stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.2402432, size.height * 0.3845455),
      Offset(size.width * 0.4070000, size.height * -0.7818182),
      [Color(0xffF8AE00).withOpacity(1), Color(0xffF8AE00).withOpacity(0)],
      [0.042, 0.841],
    );
    canvas.drawPath(path_20, paint_20_stroke);

    Path path_21 = Path();
    path_21.moveTo(10.078, 9.192);
    path_21.lineTo(7.4559999999999995, 11.181000000000001);
    path_21.arcToPoint(
      Offset(7.241, 12.201),
      radius: Radius.elliptical(0.796, 0.796),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_21.lineTo(8.307, 14.121);
    path_21.arcToPoint(
      Offset(8.267000000000001, 14.958),
      radius: Radius.elliptical(0.796, 0.796),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_21.lineTo(7.123000000000001, 16.629);

    Paint paint_21_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02151351;
    paint_21_stroke.strokeCap = StrokeCap.round;
    paint_21_stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.1806757, size.height * 0.3301818),
      Offset(size.width * 0.2635135, size.height * 0.1353091),
      [Color(0xffF8AE00).withOpacity(1), Color(0xffF8AE00).withOpacity(0)],
      [0.042, 0.841],
    );
    canvas.drawPath(path_21, paint_21_stroke);

    Path path_22 = Path();
    path_22.moveTo(24.332, 9.19);
    path_22.lineTo(26.954, 11.179);
    path_22.cubicTo(27.27, 11.419, 27.361, 11.853, 27.169, 12.199);
    path_22.lineTo(26.103, 14.119);
    path_22.arcToPoint(
      Offset(26.143, 14.956),
      radius: Radius.elliptical(0.796, 0.796),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.lineTo(27.286, 16.627);

    Paint paint_22_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02151351;
    paint_22_stroke.strokeCap = StrokeCap.round;
    paint_22_stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.7492973, size.height * 0.3301455),
      Offset(size.width * 0.6664865, size.height * 0.1352727),
      [Color(0xffF8AE00).withOpacity(1), Color(0xffF8AE00).withOpacity(0)],
      [0.042, 0.841],
    );
    canvas.drawPath(path_22, paint_22_stroke);

    Path path_23 = Path();
    path_23.moveTo(18.72, 3.443);
    path_23.lineTo(24, 7.446);
    path_23.cubicTo(24.635, 7.928, 24.82, 8.805, 24.432, 9.501999999999999);
    path_23.lineTo(22.285999999999998, 13.366999999999999);
    path_23.arcToPoint(
      Offset(22.365999999999996, 15.050999999999998),
      radius: Radius.elliptical(1.603, 1.603),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.lineTo(24.668999999999997, 18.416999999999998);

    Paint paint_23_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04332432;
    paint_23_stroke.strokeCap = StrokeCap.round;
    paint_23_stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.6905676, size.height * 0.3909091),
      Offset(size.width * 0.5237838, size.height * -0.1472727),
      [Color(0xffF8AE00).withOpacity(1), Color(0xffF8AE00).withOpacity(0)],
      [0.042, 0.841],
    );
    canvas.drawPath(path_23, paint_23_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
