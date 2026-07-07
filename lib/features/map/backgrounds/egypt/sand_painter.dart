import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(440, 0);
    path_0.lineTo(440, 395);
    path_0.lineTo(0, 395);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000000, size.height * 1.000010),
      Offset(size.width * 0.5000000, size.height * 0.0005063291),
      [
        Color(0xff160052).withOpacity(1),
        Color(0xff200255).withOpacity(1),
        Color(0xff3C065E).withOpacity(1),
        Color(0xff690D6C).withOpacity(1),
        Color(0xff7F1173).withOpacity(1),
        Color(0xffED5492).withOpacity(1),
      ],
      [0, 0.138, 0.376, 0.684, 0.818, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(-124.437, 260.795);
    path_1.cubicTo(
      -124.437,
      260.795,
      -66.701,
      295.922,
      160.86599999999999,
      305.59900000000005,
    );
    path_1.cubicTo(
      375.363,
      314.725,
      451.402,
      280.37300000000005,
      563.653,
      284.36800000000005,
    );
    path_1.cubicTo(
      563.653,
      284.36800000000005,
      511.084,
      282.56000000000006,
      309.39700000000005,
      310.4030000000001,
    );
    path_1.cubicTo(
      132.90200000000004,
      334.7510000000001,
      -50.03299999999996,
      292.99500000000006,
      -124.43699999999995,
      265.15100000000007,
    );
    path_1.lineTo(-124.43699999999995, 260.7950000000001);
    path_1.close();
    path_1.moveTo(0.066, 33);
    path_1.cubicTo(0.066, 33, 83.906, 39.49, 232.725, 42.284);
    path_1.cubicTo(381.544, 45.079, 440, 42.284, 440, 42.284);
    path_1.lineTo(440, 45.294);
    path_1.cubicTo(440, 45.294, 289.378, 46.881, 212.653, 45.294);
    path_1.cubicTo(135.929, 43.71, 40.232, 35.056, 0, 36.877);
    path_1.lineTo(0.066, 33);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff6B2D86).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(30.587, 155.258);
    path_2.lineTo(565.049, 155.258);
    path_2.lineTo(563.6709999999999, 211.13400000000001);
    path_2.cubicTo(
      563.6709999999999,
      211.13400000000001,
      480.8299999999999,
      221.51700000000002,
      328.4939999999999,
      211.13400000000001,
    );
    path_2.cubicTo(
      176.13899999999992,
      200.76800000000003,
      108.76099999999991,
      163.85000000000002,
      30.586999999999932,
      155.258,
    );
    path_2.close();
    path_2.moveTo(-124.539, 249.517);
    path_2.cubicTo(
      -124.539,
      249.517,
      177.44800000000004,
      271.248,
      565.032,
      243.835,
    );
    path_2.lineTo(563.654, 284.369);
    path_2.cubicTo(
      563.654,
      284.369,
      513.753,
      280.959,
      393.63300000000004,
      297.713,
    );
    path_2.cubicTo(
      273.51300000000003,
      314.45000000000005,
      -10.876999999999953,
      313.865,
      -124.43599999999992,
      260.79600000000005,
    );
    path_2.lineTo(-124.53899999999992, 249.51700000000005);
    path_2.close();
    path_2.moveTo(-124.539, 44.662000000000006);
    path_2.lineTo(565.032, 44.662000000000006);
    path_2.lineTo(563.654, 92.84100000000001);
    path_2.cubicTo(
      563.654,
      92.84100000000001,
      522.759,
      94.35600000000001,
      377.947,
      87.968,
    );
    path_2.cubicTo(233.135, 81.58, 199.385, 69.595, 194.512, 66.238);
    path_2.cubicTo(189.639, 62.88, 201.366, 63.964999999999996, 201.59, 60.159);
    path_2.cubicTo(
      201.796,
      56.336999999999996,
      85.25800000000001,
      40.959999999999994,
      -124.436,
      78.446,
    );
    path_2.lineTo(-124.539, 44.662);
    path_2.close();
    path_2.moveTo(-124.54, 323.438);
    path_2.cubicTo(
      -124.54,
      323.438,
      53.040000000000006,
      379.572,
      313.68399999999997,
      351.022,
    );
    path_2.cubicTo(512.357, 329.275, 565.03, 331.823, 565.03, 331.823);
    path_2.lineTo(563.653, 372.37399999999997);
    path_2.cubicTo(
      563.653,
      372.37399999999997,
      468.72400000000005,
      355.70599999999996,
      313.66700000000003,
      363.21399999999994,
    );
    path_2.cubicTo(
      158.60900000000004,
      370.70399999999995,
      -35.46599999999995,
      375.86999999999995,
      -124.55799999999999,
      359.66599999999994,
    );
    path_2.lineTo(-124.55799999999999, 323.43799999999993);
    path_2.lineTo(-124.53999999999999, 323.43799999999993);
    path_2.close();
    path_2.moveTo(-124.539, 145.618);
    path_2.cubicTo(-124.539, 145.618, -73.915, 147.873, 5, 151.575);
    path_2.lineTo(425.988, 145.084);
    path_2.cubicTo(425.988, 145.084, 49.804, 108.545, -124.539, 118.98);
    path_2.lineTo(-124.539, 145.618);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffAB9FFF).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(564.325, 2.423);
    path_3.lineTo(-124.437, -4);
    path_3.lineTo(-124.437, -0.7799999999999998);
    path_3.lineTo(564.3249999999999, 8.036000000000001);
    path_3.lineTo(564.3249999999999, 2.423);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xff6B2D86).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(54.907, 152.581);
    path_4.cubicTo(
      54.907,
      152.581,
      60.003,
      125.35799999999999,
      61.276999999999994,
      96.67099999999999,
    );
    path_4.lineTo(54.907, 122.74099999999999);
    path_4.lineTo(56.404999999999994, 106.81299999999999);
    path_4.cubicTo(
      56.404999999999994,
      106.81299999999999,
      42.73299999999999,
      139.80499999999998,
      42.50899999999999,
      151.789,
    );
    path_4.lineTo(54.907, 152.581);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1179455, size.height * 0.3862962),
      Offset(size.width * 0.1179455, size.height * 0.2447722),
      [
        Color(0xff161342).withOpacity(1),
        Color(0xff20164B).withOpacity(1),
        Color(0xff3C1D64).withOpacity(1),
        Color(0xff632787).withOpacity(1),
      ],
      [0, 0.214, 0.583, 1],
    );
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(24.979, 152.065);
    path_5.cubicTo(
      24.979,
      152.065,
      26.649,
      124.13499999999999,
      35.723,
      104.161,
    );
    path_5.cubicTo(35.723, 104.161, 32.503, 135.448, 31.953, 152.357);
    path_5.lineTo(24.979, 152.065);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.06897955, size.height * 0.3857266),
      Offset(size.width * 0.06897955, size.height * 0.2637215),
      [
        Color(0xff161342).withOpacity(1),
        Color(0xff20164B).withOpacity(1),
        Color(0xff3C1D64).withOpacity(1),
        Color(0xff632787).withOpacity(1),
      ],
      [0, 0.214, 0.583, 1],
    );
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(33.881, 150.928);
    path_6.cubicTo(33.881, 150.928, 36.068, 132.745, 43.541, 106.71);
    path_6.lineTo(40.492999999999995, 130.127);
    path_6.cubicTo(
      40.492999999999995,
      130.127,
      47.794,
      96.602,
      57.53999999999999,
      77.60900000000001,
    );
    path_6.cubicTo(
      57.53999999999999,
      77.60900000000001,
      48.44799999999999,
      109.74000000000001,
      45.02199999999999,
      136.275,
    );
    path_6.cubicTo(
      45.02199999999999,
      136.275,
      52.49499999999999,
      105.539,
      55.00899999999999,
      96.05100000000002,
    );
    path_6.cubicTo(
      55.00899999999999,
      96.05100000000002,
      49.03399999999999,
      128.733,
      47.27799999999999,
      145.50400000000002,
    );
    path_6.lineTo(53.88999999999999, 124.82400000000001);
    path_6.cubicTo(
      53.88999999999999,
      124.82400000000001,
      50.78999999999999,
      138.858,
      51.650999999999996,
      152.37400000000002,
    );
    path_6.lineTo(27.475999999999996, 151.63400000000001);
    path_6.lineTo(31.435999999999996, 123.70500000000001);
    path_6.cubicTo(
      31.435999999999996,
      123.68800000000002,
      33.019999999999996,
      137.94500000000002,
      33.88099999999999,
      150.928,
    );
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.09661136, size.height * 0.3857266),
      Offset(size.width * 0.09661136, size.height * 0.1964405),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(64.049, 153.391);
    path_7.cubicTo(
      64.049,
      153.391,
      67.47500000000001,
      132.36599999999999,
      79.546,
      106.71,
    );
    path_7.cubicTo(
      79.546,
      106.71,
      71.212,
      127.76899999999999,
      66.51100000000001,
      153.57999999999998,
    );
    path_7.lineTo(64.049, 153.391);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1631659, size.height * 0.3887873),
      Offset(size.width * 0.1631659, size.height * 0.2701367),
      [
        Color(0xff321D54).withOpacity(1),
        Color(0xff311E5E).withOpacity(1),
        Color(0xff2E1F7A).withOpacity(1),
        Color(0xff2C2087).withOpacity(1),
      ],
      [0, 0.294, 0.799, 1],
    );
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(7.415, 150.928);
    path_8.cubicTo(7.415, 150.928, 6.675, 139.73499999999999, 11.324, 128.268);
    path_8.cubicTo(11.324, 128.268, 9.464, 139.529, 11.324, 151.444);
    path_8.lineTo(7.415, 150.928);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.02125455, size.height * 0.3834000),
      Offset(size.width * 0.02125455, size.height * 0.3247241),
      [
        Color(0xff321D54).withOpacity(1),
        Color(0xff311E5E).withOpacity(1),
        Color(0xff2E1F7A).withOpacity(1),
        Color(0xff2C2087).withOpacity(1),
      ],
      [0, 0.294, 0.799, 1],
    );
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(364.188, 303.142);
    path_9.cubicTo(364.188, 303.142, 372.436, 227.878, 390.293, 187);
    path_9.cubicTo(390.293, 187, 384.645, 233.113, 378.98, 266.604);
    path_9.cubicTo(
      378.98,
      266.604,
      386.814,
      228.75599999999997,
      392.03200000000004,
      207.439,
    );
    path_9.cubicTo(
      392.03200000000004,
      207.439,
      393.237,
      240.482,
      389.38000000000005,
      272.251,
    );
    path_9.cubicTo(
      389.38000000000005,
      272.251,
      399.74600000000004,
      250.24599999999998,
      410.66300000000007,
      238.32999999999998,
    );
    path_9.cubicTo(
      410.66300000000007,
      238.32999999999998,
      405.3760000000001,
      274.214,
      397.83400000000006,
      299.991,
    );
    path_9.lineTo(364.18800000000005, 303.142);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8804909, size.height * 0.7674557),
      Offset(size.width * 0.8804909, size.height * 0.4734127),
      [
        Color(0xff161342).withOpacity(1),
        Color(0xff20164B).withOpacity(1),
        Color(0xff3C1D64).withOpacity(1),
        Color(0xff632787).withOpacity(1),
      ],
      [0, 0.214, 0.583, 1],
    );
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(341.442, 306.69);
    path_10.cubicTo(
      341.442,
      306.69,
      345.42,
      277.693,
      353.72,
      246.37099999999998,
    );
    path_10.lineTo(351.774, 276.522);
    path_10.cubicTo(
      351.774,
      276.522,
      363.552,
      228.016,
      372.902,
      200.96499999999997,
    );
    path_10.cubicTo(
      372.902,
      200.96499999999997,
      357.86899999999997,
      274.49,
      353.73699999999997,
      303.48699999999997,
    );
    path_10.cubicTo(
      353.73699999999997,
      303.48699999999997,
      366.75399999999996,
      240.87899999999996,
      381.33899999999994,
      200.96499999999997,
    );
    path_10.cubicTo(
      381.33899999999994,
      200.96499999999997,
      365.99699999999996,
      249.24699999999996,
      361.38199999999995,
      302.609,
    );
    path_10.cubicTo(
      361.38199999999995,
      302.609,
      372.6089999999999,
      255.37699999999998,
      381.33899999999994,
      230.32299999999998,
    );
    path_10.cubicTo(
      381.33899999999994,
      230.32299999999998,
      371.0249999999999,
      258.924,
      375.62199999999996,
      302.52299999999997,
    );
    path_10.lineTo(383.62899999999996, 281.412);
    path_10.lineTo(382.90599999999995, 299.63);
    path_10.cubicTo(
      382.90599999999995,
      299.63,
      398.60999999999996,
      228.653,
      410.64599999999996,
      200.96499999999997,
    );
    path_10.cubicTo(
      410.64599999999996,
      200.96499999999997,
      399.05699999999996,
      250.48699999999997,
      397.81699999999995,
      299.974,
    );
    path_10.lineTo(341.44199999999995, 306.69);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8546500, size.height * 0.7764405),
      Offset(size.width * 0.8546500, size.height * 0.5088228),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(337, 306.414);
    path_11.cubicTo(337, 306.414, 338.085, 275.316, 343.75, 249.642);
    path_11.cubicTo(348.881, 226.328, 360.711, 200.981, 360.711, 200.981);
    path_11.cubicTo(360.711, 200.981, 348.313, 233.319, 346.023, 259.096);
    path_11.cubicTo(
      343.733,
      284.873,
      345.36800000000005,
      306.069,
      345.36800000000005,
      306.069,
    );
    path_11.lineTo(337.00000000000006, 306.41400000000004);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7928386, size.height * 0.7757139),
      Offset(size.width * 0.7928386, size.height * 0.5088203),
      [
        Color(0xff321D54).withOpacity(1),
        Color(0xff311E5E).withOpacity(1),
        Color(0xff2E1F7A).withOpacity(1),
        Color(0xff2C2087).withOpacity(1),
      ],
      [0, 0.294, 0.799, 1],
    );
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(410.646, 296.685);
    path_12.cubicTo(410.646, 296.685, 408.976, 275.471, 430.74, 249.643);
    path_12.cubicTo(430.74, 249.643, 420.684, 270.581, 413.848, 298.252);
    path_12.lineTo(410.646, 296.685);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9560909, size.height * 0.7550481),
      Offset(size.width * 0.9560909, size.height * 0.6319975),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(353.588, 87.499);
    path_13.cubicTo(
      353.588,
      87.499,
      353.726,
      73.362,
      359.322,
      56.400999999999996,
    );
    path_13.cubicTo(
      359.322,
      56.400999999999996,
      357.548,
      76.18599999999999,
      356.446,
      87.499,
    );
    path_13.lineTo(359.322, 71.193);
    path_13.lineTo(359.322, 88.533);
    path_13.lineTo(353.588, 87.499);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8101136, size.height * 0.2241114),
      Offset(size.width * 0.8101136, size.height * 0.1427544),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(389.938, 89.617);
    path_14.cubicTo(
      389.938,
      89.617,
      392.108,
      76.186,
      398.858,
      63.788000000000004,
    );
    path_14.cubicTo(
      398.858,
      63.788000000000004,
      394.071,
      78.7,
      394.398,
      89.617,
    );
    path_14.lineTo(389.93800000000005, 89.617);
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8963636, size.height * 0.2268709),
      Offset(size.width * 0.8963636, size.height * 0.1614759),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(76.249, 297.266);
    path_15.cubicTo(
      76.249,
      297.266,
      84.945,
      256.233,
      91.695,
      243.83500000000004,
    );
    path_15.cubicTo(
      91.695,
      243.83500000000004,
      80.38199999999999,
      286.331,
      80.70899999999999,
      297.266,
    );
    path_15.lineTo(76.249, 297.266);
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1908545, size.height * 0.7525646),
      Offset(size.width * 0.1908545, size.height * 0.6172962),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(25.823, 394.982);
    path_16.cubicTo(
      25.823,
      394.982,
      23.86,
      357.514,
      34.313,
      329.05100000000004,
    );
    path_16.cubicTo(
      34.313,
      329.05100000000004,
      27.132,
      365.40000000000003,
      30.231,
      394.982,
    );
    path_16.lineTo(25.823, 394.982);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.06816818, size.height * 0.9999747),
      Offset(size.width * 0.06816818, size.height * 0.8330608),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(35.622, 394.983);
    path_17.cubicTo(
      35.622,
      394.983,
      35.622,
      371.72,
      43.784,
      349.54200000000003,
    );
    path_17.cubicTo(
      43.784,
      349.54200000000003,
      38.239,
      374.21700000000004,
      39.702999999999996,
      395,
    );
    path_17.lineTo(35.623, 394.983);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.09020909, size.height * 0.9999772),
      Offset(size.width * 0.09020909, size.height * 0.8849063),
      [
        Color(0xff5B0068).withOpacity(1),
        Color(0xff5C0A72).withOpacity(1),
        Color(0xff60268C).withOpacity(1),
        Color(0xff633EA3).withOpacity(1),
      ],
      [0, 0.253, 0.688, 1],
    );
    canvas.drawPath(path_17, paint_17_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
