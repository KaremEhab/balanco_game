import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GameplayBottomPainter extends CustomPainter {
  final List<Color> baseGradient;
  final List<Color> highlightGradient;
  final List<Color> darkAccentGradient;

  GameplayBottomPainter({
    this.baseGradient = const [Color(0xffF8AE00), Color(0xffE88000)],
    this.highlightGradient = const [Color(0xffFFB450), Color(0xffE59131)],
    this.darkAccentGradient = const [Color(0xff503040), Color(0xff301525)],
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(20.004, 9.68);
    path_0.cubicTo(
      17.602,
      3.71,
      13.199000000000002,
      1.9100000000000001,
      0.004000000000001336,
      0.017999999999998906,
    );
    path_0.lineTo(270.358, 0.017999999999998906);
    path_0.cubicTo(
      256.44100000000003,
      1.954999999999999,
      251.494,
      3.8989999999999987,
      250.358,
      9.681,
    );
    path_0.cubicTo(
      250.358,
      26.802999999999997,
      234.275,
      39.351,
      217.671,
      35.167,
    );
    path_0.lineTo(191.99099999999999, 28.714000000000002);
    path_0.cubicTo(
      184.85699999999997,
      26.931,
      178.24099999999999,
      32.96,
      179.37699999999998,
      40.225,
    );
    path_0.lineTo(179.37699999999998, 40.322);
    path_0.cubicTo(
      180.08899999999997,
      44.959,
      175.74599999999998,
      48.721000000000004,
      171.206,
      47.488,
    );
    path_0.cubicTo(
      159.36999999999998,
      44.212,
      149.123,
      43.822,
      141.66699999999997,
      48.946,
    );
    path_0.cubicTo(
      137.71099999999998,
      51.668,
      132.65299999999996,
      51.668,
      128.69799999999998,
      48.946,
    );
    path_0.cubicTo(
      121.23899999999998,
      43.821999999999996,
      111.02599999999998,
      44.211999999999996,
      99.15799999999999,
      47.488,
    );
    path_0.cubicTo(
      94.61799999999998,
      48.721,
      90.27199999999999,
      44.958,
      90.98799999999999,
      40.322,
    );
    path_0.lineTo(91.01799999999999, 40.225);
    path_0.cubicTo(
      92.15199999999999,
      32.963,
      85.50499999999998,
      26.931,
      78.40499999999999,
      28.714000000000002,
    );
    path_0.lineTo(52.72, 35.167);
    path_0.cubicTo(36.12, 39.351, 20.003, 26.803, 20.003, 9.681000000000001);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(179.802, 35.423);
    path_1.cubicTo(
      181.405,
      30.569000000000003,
      186.522,
      27.339000000000002,
      191.977,
      28.717000000000002,
    );
    path_1.lineTo(217.657, 35.171);
    path_1.cubicTo(
      234.258,
      39.355,
      250.344,
      26.802999999999997,
      250.344,
      9.684999999999999,
    );
    path_1.lineTo(250.344, 8.42);
    path_1.cubicTo(250.344, 25.542, 234.262, 38.09, 217.65699999999998, 33.907);
    path_1.lineTo(191.97699999999998, 27.452999999999996);
    path_1.cubicTo(
      186.06199999999998,
      25.966999999999995,
      180.50699999999998,
      29.894999999999996,
      179.43899999999996,
      35.422999999999995,
    );
    path_1.lineTo(179.80199999999996, 35.422999999999995);
    path_1.close();
    path_1.moveTo(179.357, 40.976);
    path_1.cubicTo(178.807, 44.676, 175.086, 47.274, 171.193, 46.224);
    path_1.cubicTo(
      159.35600000000002,
      42.94799999999999,
      149.109,
      42.558,
      141.654,
      47.681999999999995,
    );
    path_1.cubicTo(
      137.698,
      50.403999999999996,
      132.64,
      50.403999999999996,
      128.684,
      47.681999999999995,
    );
    path_1.cubicTo(
      121.225,
      42.55799999999999,
      111.012,
      42.94799999999999,
      99.144,
      46.224,
    );
    path_1.cubicTo(
      95.251,
      47.276999999999994,
      91.53,
      44.678999999999995,
      90.98100000000001,
      40.976,
    );
    path_1.lineTo(90.95, 40.976);
    path_1.cubicTo(
      90.715,
      45.301,
      94.82600000000001,
      48.67,
      99.14500000000001,
      47.488,
    );
    path_1.cubicTo(
      111.01200000000001,
      44.213,
      121.22800000000001,
      43.822,
      128.68400000000003,
      48.946,
    );
    path_1.cubicTo(
      132.64000000000001,
      51.669,
      137.69800000000004,
      51.669,
      141.65400000000002,
      48.946,
    );
    path_1.cubicTo(
      149.11300000000003,
      43.821999999999996,
      159.36,
      44.213,
      171.19300000000004,
      47.488,
    );
    path_1.cubicTo(
      175.51100000000005,
      48.673,
      179.62300000000005,
      45.305,
      179.38800000000003,
      40.976,
    );
    path_1.lineTo(179.35700000000003, 40.976);
    path_1.close();
    path_1.moveTo(52.708, 35.165);
    path_1.lineTo(78.388, 28.712);
    path_1.cubicTo(83.815, 27.333, 88.94900000000001, 30.563, 90.559, 35.417);
    path_1.lineTo(90.922, 35.417);
    path_1.cubicTo(
      89.851,
      29.887,
      84.27499999999999,
      25.961000000000002,
      78.38799999999999,
      27.447000000000003,
    );
    path_1.lineTo(52.70799999999999, 33.901);
    path_1.cubicTo(36.104, 38.084, 19.99, 25.536, 19.99, 8.414);
    path_1.lineTo(19.99, 9.68);
    path_1.cubicTo(19.99, 26.799, 36.104, 39.35, 52.708, 35.166);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(20.003, 9.515);
    path_2.lineTo(38.963, 9.515);
    path_2.cubicTo(
      62.706,
      9.515,
      86.17500000000001,
      17.413,
      103.72200000000001,
      33.405,
    );
    path_2.arcToPoint(
      Offset(135.535, 45.708),
      radius: Radius.elliptical(47.06, 47.06),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.cubicTo(147.786, 45.708, 158.952, 41.044, 167.347, 33.388);
    path_2.cubicTo(
      184.888,
      17.394999999999996,
      208.353,
      9.511,
      232.08800000000002,
      9.511,
    );
    path_2.lineTo(250.35800000000003, 9.511);
    path_2.cubicTo(
      251.60200000000003,
      3.834999999999999,
      256.13800000000003,
      1.730999999999999,
      270.35800000000006,
      0.013999999999999346,
    );
    path_2.lineTo(182.74200000000008, 0.013999999999999346);
    path_2.lineTo(182.74200000000008, 0);
    path_2.lineTo(88.32, 0);
    path_2.lineTo(88.32, 0.014);
    path_2.lineTo(0, 0.014);
    path_2.cubicTo(12.99, 1.6380000000000001, 17.522, 3.691, 20, 9.514);
    path_2.lineTo(20.003, 9.514);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), highlightGradient, [0.0, 1.0]);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(93.192, 0.018);
    path_3.lineTo(177.214, 0.018);
    path_3.cubicTo(176.81, 22.878, 158.178, 41.286, 135.18200000000002, 41.286);
    path_3.cubicTo(
      112.22800000000001,
      41.286,
      93.59600000000002,
      22.878,
      93.19200000000001,
      0.018000000000000682,
    );
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(93.192, 0.018);
    path_4.lineTo(177.214, 0.018);
    path_4.cubicTo(176.81, 22.878, 158.178, 41.286, 135.18200000000002, 41.286);
    path_4.cubicTo(
      112.22800000000001,
      41.286,
      93.59600000000002,
      22.878,
      93.19200000000001,
      0.018000000000000682,
    );
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(93.192, 0.018);
    path_5.lineTo(177.214, 0.018);
    path_5.cubicTo(176.81, 22.878, 158.178, 41.286, 135.18200000000002, 41.286);
    path_5.cubicTo(
      112.22800000000001,
      41.286,
      93.59600000000002,
      22.878,
      93.19200000000001,
      0.018000000000000682,
    );
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4988967, size.height * 1.145706),
      Offset(size.width * 0.4988967, size.height * 0.1659216),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.29, 0.923],
    );
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(93.168, 0.018);
    path_6.lineTo(93.438, 0.018);
    path_6.cubicTo(
      95.776,
      20.988,
      113.555,
      37.282000000000004,
      135.155,
      37.282000000000004,
    );
    path_6.cubicTo(
      156.803,
      37.282000000000004,
      174.579,
      20.992000000000004,
      176.918,
      0.018000000000000682,
    );
    path_6.lineTo(177.187, 0.018000000000000682);
    path_6.cubicTo(
      176.78300000000002,
      22.878,
      158.151,
      41.286,
      135.15500000000003,
      41.286,
    );
    path_6.cubicTo(
      112.20400000000004,
      41.286,
      93.57500000000003,
      22.878,
      93.16800000000003,
      0.018000000000000682,
    );
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(120.948, 8);
    path_7.arcToPoint(
      Offset(123.948, 5),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.lineTo(129.94799999999998, 5);
    path_7.arcToPoint(
      Offset(132.94799999999998, 8),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.lineTo(132.94799999999998, 26);
    path_7.arcToPoint(
      Offset(129.94799999999998, 29),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.lineTo(123.94799999999998, 29);
    path_7.arcToPoint(
      Offset(120.94799999999998, 26),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.lineTo(120.94799999999998, 8);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), darkAccentGradient, [0.0, 1.0]);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(121.948, 9);
    path_8.arcToPoint(
      Offset(124.948, 6),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.lineTo(128.94799999999998, 6);
    path_8.arcToPoint(
      Offset(131.94799999999998, 9),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.lineTo(131.94799999999998, 15);
    path_8.arcToPoint(
      Offset(128.94799999999998, 18),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.lineTo(124.94799999999998, 18);
    path_8.arcToPoint(
      Offset(121.94799999999998, 15),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.lineTo(121.94799999999998, 9);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5311734, size.height * -13.72549),
      Offset(size.width * 0.5495609, size.height * 0.3326275),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(136.948, 8);
    path_9.arcToPoint(
      Offset(139.948, 5),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(145.948, 5);
    path_9.arcToPoint(
      Offset(148.948, 8),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(148.948, 26);
    path_9.arcToPoint(
      Offset(145.948, 29),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(139.948, 29);
    path_9.arcToPoint(
      Offset(136.948, 26),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(136.948, 8);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), darkAccentGradient, [0.0, 1.0]);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(137.948, 9);
    path_10.arcToPoint(
      Offset(140.948, 6),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.lineTo(144.948, 6);
    path_10.arcToPoint(
      Offset(147.948, 9),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.lineTo(147.948, 15);
    path_10.arcToPoint(
      Offset(144.948, 18),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.lineTo(140.948, 18);
    path_10.arcToPoint(
      Offset(137.948, 15),
      radius: Radius.elliptical(3, 3),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_10.lineTo(137.948, 9);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5311734, size.height * -13.72549),
      Offset(size.width * 0.5495609, size.height * 0.3326275),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_10, paint_10_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GameplayTopPainter extends CustomPainter {
  final List<Color> baseGradient;
  final List<Color> highlightGradient;

  GameplayTopPainter({
    this.baseGradient = const [Color(0xffF8AE00), Color(0xffE88000)],
    this.highlightGradient = const [Color(0xffFFB450), Color(0xffE59131)],
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.028, 87.159);
    path_0.lineTo(0.028, 107.54400000000001);
    path_0.lineTo(410.928, 107.54400000000001);
    path_0.lineTo(410.928, 87.159);
    path_0.cubicTo(
      410.928,
      51.047000000000004,
      382.238,
      24.571000000000005,
      352.624,
      33.39600000000001,
    );
    path_0.lineTo(306.81500000000005, 47.00600000000001);
    path_0.cubicTo(
      294.0880000000001,
      50.766000000000005,
      282.2900000000001,
      38.04600000000001,
      284.31300000000005,
      22.721000000000007,
    );
    path_0.lineTo(284.31300000000005, 22.51300000000001);
    path_0.cubicTo(
      285.588,
      12.73000000000001,
      277.83600000000007,
      4.79600000000001,
      269.73800000000006,
      7.396000000000008,
    );
    path_0.cubicTo(
      248.62400000000005,
      14.305000000000007,
      230.34900000000005,
      15.129000000000008,
      217.04400000000004,
      4.320000000000007,
    );
    path_0.cubicTo(
      209.98900000000003,
      -1.422999999999993,
      200.96200000000005,
      -1.422999999999993,
      193.90700000000004,
      4.320000000000007,
    );
    path_0.cubicTo(
      180.60200000000003,
      15.129000000000007,
      162.38300000000004,
      14.305000000000007,
      141.21300000000002,
      7.396000000000008,
    );
    path_0.cubicTo(
      133.115,
      4.796000000000008,
      125.36300000000003,
      12.730000000000008,
      126.63800000000002,
      22.51300000000001,
    );
    path_0.lineTo(126.69500000000002, 22.721000000000007);
    path_0.cubicTo(
      128.71800000000002,
      38.040000000000006,
      116.86300000000003,
      50.76500000000001,
      104.19300000000003,
      47.00600000000001,
    );
    path_0.lineTo(58.383000000000024, 33.39600000000001);
    path_0.cubicTo(28.775, 24.577, 0.028, 51.046, 0.028, 87.159);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(Offset(0, size.height), const Offset(0, 0), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(0.056, 87.128);
    path_1.lineTo(0.056, 107.58);
    path_1.lineTo(410.95, 107.58);
    path_1.lineTo(410.95, 87.128);
    path_1.cubicTo(410.95, 51.069, 382.221, 24.606, 352.64599999999996, 33.372);
    path_1.lineTo(306.83099999999996, 46.982);
    path_1.cubicTo(
      294.05299999999994,
      50.822,
      282.26699999999994,
      38.049,
      284.31199999999995,
      22.77,
    );
    path_1.lineTo(284.31199999999995, 22.523);
    path_1.cubicTo(
      285.58199999999994,
      12.753,
      277.818,
      4.824999999999999,
      269.698,
      7.411,
    );
    path_1.cubicTo(
      248.58999999999997,
      14.341,
      230.30899999999997,
      15.171,
      217.03799999999998,
      4.321999999999999,
    );
    path_1.cubicTo(
      209.97699999999998,
      -1.4410000000000007,
      200.944,
      -1.4410000000000007,
      193.884,
      4.321999999999999,
    );
    path_1.cubicTo(
      180.612,
      15.171999999999999,
      162.39999999999998,
      14.34,
      141.224,
      7.411999999999999,
    );
    path_1.cubicTo(
      133.10299999999998,
      4.824999999999999,
      125.33999999999999,
      12.751999999999999,
      126.609,
      22.522,
    );
    path_1.lineTo(126.68299999999999, 22.77);
    path_1.cubicTo(
      128.72899999999998,
      38.049,
      116.868,
      50.821,
      104.16399999999999,
      46.980999999999995,
    );
    path_1.lineTo(58.353999999999985, 33.370999999999995);
    path_1.cubicTo(28.787, 24.6, 0.056, 51.063, 0.056, 87.129);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000097, size.height * -60.16944),
      Offset(size.width * 0.5000097, size.height * 0.8922685),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.216, 0.923],
    );
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(285.066, 32.865);
    path_2.cubicTo(
      287.928,
      43.111000000000004,
      297.051,
      49.919,
      306.78099999999995,
      47.011,
    );
    path_2.lineTo(352.5899999999999, 33.401);
    path_2.cubicTo(
      382.2039999999999,
      24.576000000000004,
      410.8949999999999,
      51.045,
      410.8949999999999,
      87.164,
    );
    path_2.lineTo(410.8949999999999, 89.831);
    path_2.cubicTo(
      410.8949999999999,
      53.712,
      382.20399999999995,
      27.243000000000002,
      352.5899999999999,
      36.068000000000005,
    );
    path_2.lineTo(306.78099999999995, 49.678000000000004);
    path_2.cubicTo(
      296.22999999999996,
      52.815000000000005,
      286.31899999999996,
      44.532000000000004,
      284.41499999999996,
      32.858000000000004,
    );
    path_2.lineTo(285.066, 32.858000000000004);
    path_2.lineTo(285.066, 32.865);
    path_2.close();
    path_2.moveTo(284.27299999999997, 21.14);
    path_2.cubicTo(
      283.292,
      13.333,
      276.657,
      7.851000000000001,
      269.70899999999995,
      10.07,
    );
    path_2.cubicTo(
      248.59499999999994,
      16.978,
      230.31999999999994,
      17.796,
      217.01499999999993,
      6.994,
    );
    path_2.cubicTo(
      209.95999999999992,
      1.2509999999999994,
      200.93299999999994,
      1.2509999999999994,
      193.87799999999993,
      6.994,
    );
    path_2.cubicTo(
      180.57299999999992,
      17.802999999999997,
      162.35499999999993,
      16.978,
      141.1839999999999,
      10.068999999999999,
    );
    path_2.cubicTo(
      134.2369999999999,
      7.844999999999999,
      127.60099999999991,
      13.325999999999999,
      126.62099999999991,
      21.139,
    );
    path_2.lineTo(126.56399999999991, 21.139);
    path_2.cubicTo(
      126.14499999999991,
      12.013,
      133.47699999999992,
      4.908999999999999,
      141.1839999999999,
      7.401999999999999,
    );
    path_2.cubicTo(
      162.3549999999999,
      14.312,
      180.57299999999992,
      15.129,
      193.87799999999993,
      4.326999999999999,
    );
    path_2.cubicTo(
      200.93299999999994,
      -1.4160000000000013,
      209.95999999999992,
      -1.4160000000000013,
      217.01499999999993,
      4.326999999999999,
    );
    path_2.cubicTo(
      230.31999999999994,
      15.136,
      248.5949999999999,
      14.311,
      269.70899999999995,
      7.401999999999999,
    );
    path_2.cubicTo(
      277.41599999999994,
      4.902999999999999,
      284.74899999999997,
      12.006,
      284.32899999999995,
      21.14,
    );
    path_2.lineTo(284.27299999999997, 21.14);
    path_2.close();
    path_2.moveTo(58.36, 33.415);
    path_2.lineTo(104.17, 47.025);
    path_2.cubicTo(
      113.854,
      49.933,
      123.012,
      43.117999999999995,
      125.885,
      32.879,
    );
    path_2.lineTo(126.531, 32.879);
    path_2.cubicTo(
      124.61500000000001,
      44.545,
      114.67,
      52.82899999999999,
      104.17,
      49.699,
    );
    path_2.lineTo(58.36, 36.089);
    path_2.cubicTo(28.748, 27.263, 0, 53.733, 0, 89.852);
    path_2.lineTo(0, 87.185);
    path_2.cubicTo(
      0,
      51.059000000000005,
      28.747,
      24.590000000000003,
      58.36,
      33.415,
    );
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.linear(Offset(0, size.height), const Offset(0, 0), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(0.028, 87.501);
    path_3.lineTo(33.847, 87.501);
    path_3.cubicTo(76.199, 87.501, 118.059, 70.84200000000001, 149.362, 37.109);
    path_3.cubicTo(
      164.327,
      20.979000000000003,
      184.23399999999998,
      11.155000000000001,
      206.107,
      11.155000000000001,
    );
    path_3.cubicTo(
      227.964,
      11.155000000000001,
      247.882,
      20.993000000000002,
      262.859,
      37.141999999999996,
    );
    path_3.cubicTo(294.144, 70.876, 336.00399999999996, 87.508, 378.34, 87.508);
    path_3.lineTo(410.928, 87.508);
    path_3.lineTo(410.928, 107.544);
    path_3.lineTo(290.314, 107.544);
    path_3.lineTo(290.314, 107.578);
    path_3.lineTo(121.89, 107.578);
    path_3.lineTo(121.89, 107.544);
    path_3.lineTo(0.023, 107.544);
    path_3.lineTo(0.023, 87.501);
    path_3.lineTo(0.028, 87.501);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.shader = ui.Gradient.linear(Offset(0, size.height), const Offset(0, 0), highlightGradient, [0.0, 1.0]);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(130.571, 107.538);
    path_4.lineTo(280.448, 107.538);
    path_4.cubicTo(
      279.72799999999995,
      59.309999999999995,
      246.493,
      20.48299999999999,
      205.47299999999998,
      20.48299999999999,
    );
    path_4.cubicTo(
      164.53099999999998,
      20.48299999999999,
      131.296,
      59.30999999999999,
      130.57099999999997,
      107.538,
    );
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(Offset(0, size.height), const Offset(0, 0), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(130.571, 107.538);
    path_5.lineTo(280.448, 107.538);
    path_5.cubicTo(
      279.72799999999995,
      59.309999999999995,
      246.493,
      20.48299999999999,
      205.47299999999998,
      20.48299999999999,
    );
    path_5.cubicTo(
      164.53099999999998,
      20.48299999999999,
      131.296,
      59.30999999999999,
      130.57099999999997,
      107.538,
    );
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.shader = ui.Gradient.linear(Offset(0, size.height), const Offset(0, 0), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(130.571, 107.538);
    path_6.lineTo(280.448, 107.538);
    path_6.cubicTo(
      279.72799999999995,
      59.309999999999995,
      246.493,
      20.48299999999999,
      205.47299999999998,
      20.48299999999999,
    );
    path_6.cubicTo(
      164.53099999999998,
      20.48299999999999,
      131.296,
      59.30999999999999,
      130.57099999999997,
      107.538,
    );
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000243, size.height * -14.51759),
      Offset(size.width * 0.5000243, size.height * 0.8307870),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.29, 0.923],
    );
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(130.531, 107.538);
    path_7.lineTo(131.012, 107.538);
    path_7.cubicTo(
      135.189,
      63.297,
      166.894,
      28.932999999999993,
      205.42700000000002,
      28.932999999999993,
    );
    path_7.cubicTo(
      244.04000000000002,
      28.932999999999993,
      275.75,
      63.29699999999999,
      279.92100000000005,
      107.538,
    );
    path_7.lineTo(280.40200000000004, 107.538);
    path_7.cubicTo(
      279.677,
      59.309999999999995,
      246.44800000000004,
      20.48299999999999,
      205.42700000000005,
      20.48299999999999,
    );
    path_7.cubicTo(
      164.49100000000004,
      20.48999999999999,
      131.25600000000003,
      59.31599999999999,
      130.53100000000006,
      107.538,
    );
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.shader = ui.Gradient.linear(Offset(0, size.height), const Offset(0, 0), baseGradient, [0.0, 1.0]);
    canvas.drawPath(path_7, paint_7_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
