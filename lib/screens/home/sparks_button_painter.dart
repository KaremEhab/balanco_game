import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SparksButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.02941176, size.height * -2.082000),
      Offset(size.width * 0.6930784, size.height * 1.525480),
      [Color(0xff77F9E1).withOpacity(1), Color(0xff4AACC2).withOpacity(1)],
      [0, 1],
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.01470588,
          size.height * 0.03000000,
          size.width * 0.9705882,
          size.height * 0.9400000,
        ),
        bottomRight: Radius.circular(size.width * 0.2303922),
        bottomLeft: Radius.circular(size.width * 0.2303922),
        topLeft: Radius.circular(size.width * 0.2303922),
        topRight: Radius.circular(size.width * 0.2303922),
      ),
      paint_0_fill,
    );

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02941176;
    paint_1_stroke.color = Color(0xff189EC0).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.01470588,
          size.height * 0.03000000,
          size.width * 0.9705882,
          size.height * 0.9400000,
        ),
        bottomRight: Radius.circular(size.width * 0.2303922),
        bottomLeft: Radius.circular(size.width * 0.2303922),
        topLeft: Radius.circular(size.width * 0.2303922),
        topRight: Radius.circular(size.width * 0.2303922),
      ),
      paint_1_stroke,
    );

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.01470588,
          size.height * 0.03000000,
          size.width * 0.9705882,
          size.height * 0.9400000,
        ),
        bottomRight: Radius.circular(size.width * 0.2303922),
        bottomLeft: Radius.circular(size.width * 0.2303922),
        topLeft: Radius.circular(size.width * 0.2303922),
        topRight: Radius.circular(size.width * 0.2303922),
      ),
      paint_1_fill,
    );

    Path path_2 = Path();
    path_2.moveTo(3, 3);
    path_2.lineTo(35, 3);
    path_2.lineTo(35, 47);
    path_2.lineTo(3, 47);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff0079A6).withOpacity(.4);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(36.726, 14.562);
    path_3.cubicTo(38.426, 14.474, 40.2, 14.459, 41.438, 14.652999999999999);
    path_3.cubicTo(
      42.281000000000006,
      14.785999999999998,
      42.682,
      15.697,
      42.418,
      16.432,
    );
    path_3.cubicTo(42.106, 17.299, 41.38, 19.055999999999997, 40.738, 20.583);
    path_3.cubicTo(40.415, 21.348999999999997, 40.111, 22.063, 39.888, 22.584);
    path_3.lineTo(39.812, 22.764);
    path_3.lineTo(40.364, 22.784);
    path_3.lineTo(40.41, 22.785999999999998);
    path_3.lineTo(40.455, 22.796);
    path_3.cubicTo(41.555, 23.041, 42.013999999999996, 24.319, 41.527, 25.265);
    path_3.lineTo(41.417, 25.449);
    path_3.cubicTo(39.767, 27.853, 36.056000000000004, 32.451, 32.627, 35.165);
    path_3.arcToPoint(
      Offset(30.881000000000004, 35.263),
      radius: Radius.elliptical(1.488, 1.488),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(30.105000000000004, 33.658),
      radius: Radius.elliptical(1.714, 1.714),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(31.725000000000005, 26.215000000000003),
      radius: Radius.elliptical(28.297, 28.297),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(28.915000000000006, 26.039000000000005);
    path_3.lineTo(28.915000000000006, 26.037000000000006);
    path_3.cubicTo(
      27.837000000000007,
      26.046000000000006,
      27.243000000000006,
      24.880000000000006,
      27.617000000000004,
      23.957000000000008,
    );
    path_3.lineTo(30.203000000000003, 16.53300000000001);
    path_3.lineTo(30.209000000000003, 16.51600000000001);
    path_3.lineTo(30.217000000000002, 16.49900000000001);
    path_3.cubicTo(
      30.589000000000002,
      15.63900000000001,
      31.355000000000004,
      15.03000000000001,
      32.265,
      14.93100000000001,
    );
    path_3.arcToPoint(
      Offset(36.725, 14.56100000000001),
      radius: Radius.elliptical(80.712, 80.712),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.close();

    Paint paint_3_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_3_stroke.color = Color(0xff7596B5).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_stroke);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFEAD3).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(41.236, 16.645);
    path_4.cubicTo(41.195, 16.759, 41.144999999999996, 16.89, 41.089, 17.036);
    path_4.cubicTo(40.235, 19.246000000000002, 38.795, 21.146, 36.92, 22.39);
    path_4.arcToPoint(
      Offset(36.885000000000005, 22.413),
      radius: Radius.elliptical(2.692, 2.692),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      34.165000000000006,
      24.202,
      31.294000000000004,
      24.988,
      29.002000000000006,
      24.768,
    );
    path_4.arcToPoint(
      Offset(28.789000000000005, 23.698),
      radius: Radius.elliptical(0.956, 0.956),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.lineTo(31.111000000000004, 17.031);
    path_4.cubicTo(
      31.386000000000003,
      16.395,
      31.945000000000004,
      15.963,
      32.59,
      15.895,
    );
    path_4.cubicTo(
      34.498000000000005,
      15.684999999999999,
      38.583000000000006,
      15.307,
      40.70700000000001,
      15.644,
    );
    path_4.cubicTo(
      41.13700000000001,
      15.709,
      41.394000000000005,
      16.202,
      41.23700000000001,
      16.645,
    );
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3119706, size.height * 0.1605400),
      Offset(size.width * 0.3675980, size.height * 0.5249400),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(41.003, 25.163);
    path_5.cubicTo(
      39.37,
      27.547,
      35.693,
      32.099000000000004,
      32.316,
      34.772999999999996,
    );
    path_5.cubicTo(
      31.561000000000003,
      35.366,
      30.520000000000003,
      34.711999999999996,
      30.603,
      33.696999999999996,
    );
    path_5.cubicTo(
      30.707,
      32.346999999999994,
      30.957,
      30.516999999999996,
      31.525000000000002,
      28.477999999999994,
    );
    path_5.cubicTo(
      34.724000000000004,
      29.029999999999994,
      38.341,
      27.147999999999996,
      40.510000000000005,
      23.474999999999994,
    );
    path_5.lineTo(40.575, 23.360999999999994);
    path_5.cubicTo(
      41.193000000000005,
      23.659999999999993,
      41.438,
      24.534999999999993,
      41.003,
      25.162999999999993,
    );
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffFFEAD3).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(49, 13);
    path_6.lineTo(80, 13);
    path_6.lineTo(80, 34);
    path_6.lineTo(49, 34);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(61.813, 20.96);
    path_7.cubicTo(
      61.813,
      21.586000000000002,
      61.699000000000005,
      22.184,
      61.473,
      22.754,
    );
    path_7.arcToPoint(
      Offset(60.57, 24.348000000000003),
      radius: Radius.elliptical(7.021, 7.021),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(59.305, 25.718000000000004),
      radius: Radius.elliptical(9.06, 9.06),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(57.875, 26.844000000000005),
      radius: Radius.elliptical(15.56, 15.56),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.lineTo(61.578, 26.844000000000005);
    path_7.lineTo(61.297000000000004, 31.719000000000005);
    path_7.lineTo(50.328, 31.344000000000005);
    path_7.lineTo(50.328, 27.078000000000003);
    path_7.cubicTo(
      50.742000000000004,
      26.938000000000002,
      51.176,
      26.770000000000003,
      51.628,
      26.574,
    );
    path_7.cubicTo(
      52.09,
      26.371000000000002,
      52.539,
      26.141000000000002,
      52.977,
      25.883000000000003,
    );
    path_7.arcToPoint(
      Offset(54.230999999999995, 25.016000000000002),
      radius: Radius.elliptical(9.41, 9.41),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(55.272999999999996, 23.973000000000003),
      radius: Radius.elliptical(6.58, 6.58),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(55.988, 22.731),
      radius: Radius.elliptical(4.71, 4.71),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.cubicTo(56.168, 22.285, 56.258, 21.805000000000003, 56.258, 21.289);
    path_7.cubicTo(56.258, 20.992, 56.203, 20.73, 56.094, 20.504);
    path_7.arcToPoint(
      Offset(55.660000000000004, 19.941000000000003),
      radius: Radius.elliptical(1.474, 1.474),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(55.004000000000005, 19.601000000000003),
      radius: Radius.elliptical(1.753, 1.753),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(54.21900000000001, 19.484),
      radius: Radius.elliptical(2.541, 2.541),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.cubicTo(
      53.98400000000001,
      19.484,
      53.74600000000001,
      19.512,
      53.504000000000005,
      19.566000000000003,
    );
    path_7.cubicTo(
      53.26200000000001,
      19.613000000000003,
      53.02400000000001,
      19.684,
      52.789,
      19.777,
    );
    path_7.arcToPoint(
      Offset(52.121, 20.129),
      radius: Radius.elliptical(3.638, 3.638),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(51.571000000000005, 20.586000000000002),
      radius: Radius.elliptical(3.12, 3.12),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.lineTo(50.539, 15.992);
    path_7.arcToPoint(
      Offset(51.535000000000004, 15.266000000000002),
      radius: Radius.elliptical(4.03, 4.03),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.cubicTo(
      51.910000000000004,
      15.070000000000002,
      52.30500000000001,
      14.914000000000001,
      52.719,
      14.796000000000001,
    );
    path_7.arcToPoint(
      Offset(53.984, 14.527000000000001),
      radius: Radius.elliptical(7.762, 7.762),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.cubicTo(54.414, 14.473, 54.836, 14.445, 55.25, 14.445);
    path_7.cubicTo(56.172, 14.445, 57.031, 14.613, 57.828, 14.949);
    path_7.arcToPoint(
      Offset(59.902, 16.32),
      radius: Radius.elliptical(6.28, 6.28),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(61.297000000000004, 18.383),
      radius: Radius.elliptical(6.21, 6.21),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(61.813, 20.961),
      radius: Radius.elliptical(6.44, 6.44),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.close();
    path_7.moveTo(70.938, 23.367);
    path_7.arcToPoint(
      Offset(69.046, 27.874000000000002),
      radius: Radius.elliptical(70.302, 70.302),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(67.43400000000001, 32.495000000000005),
      radius: Radius.elliptical(96.123, 96.123),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.lineTo(64.894, 31.505000000000006);
    path_7.lineTo(65.82100000000001, 29.213000000000008);
    path_7.cubicTo(
      66.13100000000001,
      28.44700000000001,
      66.44600000000001,
      27.68800000000001,
      66.76700000000001,
      26.93500000000001,
    );
    path_7.arcToPoint(
      Offset(67.78300000000002, 24.681000000000008),
      radius: Radius.elliptical(71.67, 71.67),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.cubicTo(
      68.13400000000001,
      23.936000000000007,
      68.50900000000001,
      23.20200000000001,
      68.90600000000002,
      22.47800000000001,
    );
    path_7.lineTo(70.93800000000002, 23.36800000000001);
    path_7.close();
    path_7.moveTo(78.845, 28.801000000000002);
    path_7.cubicTo(
      78.845,
      29.351000000000003,
      78.746,
      29.829,
      78.547,
      30.235000000000003,
    );
    path_7.arcToPoint(
      Offset(77.747, 31.245000000000005),
      radius: Radius.elliptical(2.809, 2.809),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(76.554, 31.841000000000005),
      radius: Radius.elliptical(3.44, 3.44),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(75.08800000000001, 32.038000000000004),
      radius: Radius.elliptical(5.292, 5.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.cubicTo(
      74.83800000000001,
      32.038000000000004,
      74.593,
      32.021,
      74.35100000000001,
      31.988000000000003,
    );
    path_7.arcToPoint(
      Offset(73.63400000000001, 31.841000000000005),
      radius: Radius.elliptical(8.269, 8.269),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(72.93600000000002, 31.625000000000004),
      radius: Radius.elliptical(11.03, 11.03),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.arcToPoint(
      Offset(72.24400000000003, 31.365000000000002),
      radius: Radius.elliptical(16.39, 16.39),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_7.lineTo(72.48500000000003, 28.839000000000002);
    path_7.arcToPoint(
      Offset(74.06500000000003, 29.379),
      radius: Radius.elliptical(4.752, 4.752),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.cubicTo(
      74.25600000000003,
      29.408,
      74.44000000000003,
      29.423000000000002,
      74.61800000000002,
      29.423000000000002,
    );
    path_7.cubicTo(
      74.72400000000002,
      29.423000000000002,
      74.85300000000002,
      29.414,
      75.00500000000002,
      29.398000000000003,
    );
    path_7.cubicTo(
      75.15800000000003,
      29.376000000000005,
      75.30400000000003,
      29.340000000000003,
      75.44300000000003,
      29.290000000000003,
    );
    path_7.cubicTo(
      75.58300000000003,
      29.235000000000003,
      75.70100000000002,
      29.163000000000004,
      75.79900000000002,
      29.074,
    );
    path_7.arcToPoint(
      Offset(75.95100000000002, 28.712000000000003),
      radius: Radius.elliptical(0.468, 0.468),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.cubicTo(
      75.95100000000002,
      28.572000000000003,
      75.91100000000002,
      28.452,
      75.83100000000002,
      28.350000000000005,
    );
    path_7.arcToPoint(
      Offset(75.52600000000001, 28.102000000000004),
      radius: Radius.elliptical(0.846, 0.846),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(75.10600000000001, 27.944000000000003),
      radius: Radius.elliptical(1.691, 1.691),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.arcToPoint(
      Offset(74.18, 27.817000000000004),
      radius: Radius.elliptical(4.494, 4.494),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_7.cubicTo(
      74.04,
      27.813000000000002,
      73.924,
      27.811000000000003,
      73.83000000000001,
      27.811000000000003,
    );
    path_7.cubicTo(
      73.64000000000001,
      27.811000000000003,
      73.44600000000001,
      27.819000000000003,
      73.24700000000001,
      27.836000000000002,
    );
    path_7.cubicTo(
      73.05200000000002,
      27.853,
      72.86200000000001,
      27.886000000000003,
      72.67600000000002,
      27.938000000000002,
    );
    path_7.lineTo(72.93000000000002, 22.808000000000003);
    path_7.lineTo(78.07100000000003, 22.668000000000003);
    path_7.lineTo(78.21100000000003, 25.322000000000003);
    path_7.lineTo(75.02400000000003, 25.145000000000003);
    path_7.lineTo(74.96100000000003, 26.275000000000002);
    path_7.cubicTo(
      75.15100000000002,
      26.228,
      75.34100000000002,
      26.194000000000003,
      75.53200000000002,
      26.173000000000002,
    );
    path_7.cubicTo(
      75.72200000000002,
      26.148000000000003,
      75.91200000000002,
      26.135,
      76.10300000000002,
      26.135,
    );
    path_7.cubicTo(
      76.48800000000003,
      26.135,
      76.84600000000002,
      26.198,
      77.17600000000002,
      26.325000000000003,
    );
    path_7.cubicTo(
      77.51000000000002,
      26.448000000000004,
      77.80000000000001,
      26.625000000000004,
      78.04600000000002,
      26.858000000000004,
    );
    path_7.cubicTo(
      78.29600000000002,
      27.091000000000005,
      78.49000000000002,
      27.373000000000005,
      78.63000000000002,
      27.703000000000003,
    );
    path_7.cubicTo(
      78.77400000000003,
      28.029000000000003,
      78.84600000000002,
      28.395000000000003,
      78.84600000000002,
      28.801000000000002,
    );
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(61.813, 20.96);
    path_8.cubicTo(
      61.813,
      21.586000000000002,
      61.699000000000005,
      22.184,
      61.473,
      22.754,
    );
    path_8.arcToPoint(
      Offset(60.57, 24.348000000000003),
      radius: Radius.elliptical(7.021, 7.021),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(59.305, 25.718000000000004),
      radius: Radius.elliptical(9.06, 9.06),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(57.875, 26.844000000000005),
      radius: Radius.elliptical(15.56, 15.56),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.lineTo(61.578, 26.844000000000005);
    path_8.lineTo(61.297000000000004, 31.719000000000005);
    path_8.lineTo(50.328, 31.344000000000005);
    path_8.lineTo(50.328, 27.078000000000003);
    path_8.cubicTo(
      50.742000000000004,
      26.938000000000002,
      51.176,
      26.770000000000003,
      51.628,
      26.574,
    );
    path_8.cubicTo(
      52.09,
      26.371000000000002,
      52.539,
      26.141000000000002,
      52.977,
      25.883000000000003,
    );
    path_8.arcToPoint(
      Offset(54.230999999999995, 25.016000000000002),
      radius: Radius.elliptical(9.41, 9.41),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(55.272999999999996, 23.973000000000003),
      radius: Radius.elliptical(6.58, 6.58),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(55.988, 22.731),
      radius: Radius.elliptical(4.71, 4.71),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.cubicTo(56.168, 22.285, 56.258, 21.805000000000003, 56.258, 21.289);
    path_8.cubicTo(56.258, 20.992, 56.203, 20.73, 56.094, 20.504);
    path_8.arcToPoint(
      Offset(55.660000000000004, 19.941000000000003),
      radius: Radius.elliptical(1.474, 1.474),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(55.004000000000005, 19.601000000000003),
      radius: Radius.elliptical(1.753, 1.753),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(54.21900000000001, 19.484),
      radius: Radius.elliptical(2.541, 2.541),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.cubicTo(
      53.98400000000001,
      19.484,
      53.74600000000001,
      19.512,
      53.504000000000005,
      19.566000000000003,
    );
    path_8.cubicTo(
      53.26200000000001,
      19.613000000000003,
      53.02400000000001,
      19.684,
      52.789,
      19.777,
    );
    path_8.arcToPoint(
      Offset(52.121, 20.129),
      radius: Radius.elliptical(3.638, 3.638),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(51.571000000000005, 20.586000000000002),
      radius: Radius.elliptical(3.12, 3.12),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.lineTo(50.539, 15.992);
    path_8.arcToPoint(
      Offset(51.535000000000004, 15.266000000000002),
      radius: Radius.elliptical(4.03, 4.03),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.cubicTo(
      51.910000000000004,
      15.070000000000002,
      52.30500000000001,
      14.914000000000001,
      52.719,
      14.796000000000001,
    );
    path_8.arcToPoint(
      Offset(53.984, 14.527000000000001),
      radius: Radius.elliptical(7.762, 7.762),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.cubicTo(54.414, 14.473, 54.836, 14.445, 55.25, 14.445);
    path_8.cubicTo(56.172, 14.445, 57.031, 14.613, 57.828, 14.949);
    path_8.arcToPoint(
      Offset(59.902, 16.32),
      radius: Radius.elliptical(6.28, 6.28),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(61.297000000000004, 18.383),
      radius: Radius.elliptical(6.21, 6.21),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(61.813, 20.961),
      radius: Radius.elliptical(6.44, 6.44),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.close();
    path_8.moveTo(70.938, 23.367);
    path_8.arcToPoint(
      Offset(69.046, 27.874000000000002),
      radius: Radius.elliptical(70.302, 70.302),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(67.43400000000001, 32.495000000000005),
      radius: Radius.elliptical(96.123, 96.123),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.lineTo(64.894, 31.505000000000006);
    path_8.lineTo(65.82100000000001, 29.213000000000008);
    path_8.cubicTo(
      66.13100000000001,
      28.44700000000001,
      66.44600000000001,
      27.68800000000001,
      66.76700000000001,
      26.93500000000001,
    );
    path_8.arcToPoint(
      Offset(67.78300000000002, 24.681000000000008),
      radius: Radius.elliptical(71.67, 71.67),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.cubicTo(
      68.13400000000001,
      23.936000000000007,
      68.50900000000001,
      23.20200000000001,
      68.90600000000002,
      22.47800000000001,
    );
    path_8.lineTo(70.93800000000002, 23.36800000000001);
    path_8.close();
    path_8.moveTo(78.845, 28.801000000000002);
    path_8.cubicTo(
      78.845,
      29.351000000000003,
      78.746,
      29.829,
      78.547,
      30.235000000000003,
    );
    path_8.arcToPoint(
      Offset(77.747, 31.245000000000005),
      radius: Radius.elliptical(2.809, 2.809),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(76.554, 31.841000000000005),
      radius: Radius.elliptical(3.44, 3.44),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(75.08800000000001, 32.038000000000004),
      radius: Radius.elliptical(5.292, 5.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.cubicTo(
      74.83800000000001,
      32.038000000000004,
      74.593,
      32.021,
      74.35100000000001,
      31.988000000000003,
    );
    path_8.arcToPoint(
      Offset(73.63400000000001, 31.841000000000005),
      radius: Radius.elliptical(8.269, 8.269),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(72.93600000000002, 31.625000000000004),
      radius: Radius.elliptical(11.03, 11.03),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.arcToPoint(
      Offset(72.24400000000003, 31.365000000000002),
      radius: Radius.elliptical(16.39, 16.39),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_8.lineTo(72.48500000000003, 28.839000000000002);
    path_8.arcToPoint(
      Offset(74.06500000000003, 29.379),
      radius: Radius.elliptical(4.752, 4.752),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.cubicTo(
      74.25600000000003,
      29.408,
      74.44000000000003,
      29.423000000000002,
      74.61800000000002,
      29.423000000000002,
    );
    path_8.cubicTo(
      74.72400000000002,
      29.423000000000002,
      74.85300000000002,
      29.414,
      75.00500000000002,
      29.398000000000003,
    );
    path_8.cubicTo(
      75.15800000000003,
      29.376000000000005,
      75.30400000000003,
      29.340000000000003,
      75.44300000000003,
      29.290000000000003,
    );
    path_8.cubicTo(
      75.58300000000003,
      29.235000000000003,
      75.70100000000002,
      29.163000000000004,
      75.79900000000002,
      29.074,
    );
    path_8.arcToPoint(
      Offset(75.95100000000002, 28.712000000000003),
      radius: Radius.elliptical(0.468, 0.468),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.cubicTo(
      75.95100000000002,
      28.572000000000003,
      75.91100000000002,
      28.452,
      75.83100000000002,
      28.350000000000005,
    );
    path_8.arcToPoint(
      Offset(75.52600000000001, 28.102000000000004),
      radius: Radius.elliptical(0.846, 0.846),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(75.10600000000001, 27.944000000000003),
      radius: Radius.elliptical(1.691, 1.691),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.arcToPoint(
      Offset(74.18, 27.817000000000004),
      radius: Radius.elliptical(4.494, 4.494),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_8.cubicTo(
      74.04,
      27.813000000000002,
      73.924,
      27.811000000000003,
      73.83000000000001,
      27.811000000000003,
    );
    path_8.cubicTo(
      73.64000000000001,
      27.811000000000003,
      73.44600000000001,
      27.819000000000003,
      73.24700000000001,
      27.836000000000002,
    );
    path_8.cubicTo(
      73.05200000000002,
      27.853,
      72.86200000000001,
      27.886000000000003,
      72.67600000000002,
      27.938000000000002,
    );
    path_8.lineTo(72.93000000000002, 22.808000000000003);
    path_8.lineTo(78.07100000000003, 22.668000000000003);
    path_8.lineTo(78.21100000000003, 25.322000000000003);
    path_8.lineTo(75.02400000000003, 25.145000000000003);
    path_8.lineTo(74.96100000000003, 26.275000000000002);
    path_8.cubicTo(
      75.15100000000002,
      26.228,
      75.34100000000002,
      26.194000000000003,
      75.53200000000002,
      26.173000000000002,
    );
    path_8.cubicTo(
      75.72200000000002,
      26.148000000000003,
      75.91200000000002,
      26.135,
      76.10300000000002,
      26.135,
    );
    path_8.cubicTo(
      76.48800000000003,
      26.135,
      76.84600000000002,
      26.198,
      77.17600000000002,
      26.325000000000003,
    );
    path_8.cubicTo(
      77.51000000000002,
      26.448000000000004,
      77.80000000000001,
      26.625000000000004,
      78.04600000000002,
      26.858000000000004,
    );
    path_8.cubicTo(
      78.29600000000002,
      27.091000000000005,
      78.49000000000002,
      27.373000000000005,
      78.63000000000002,
      27.703000000000003,
    );
    path_8.cubicTo(
      78.77400000000003,
      28.029000000000003,
      78.84600000000002,
      28.395000000000003,
      78.84600000000002,
      28.801000000000002,
    );
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffFFFBF6).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(61.473, 22.754);
    path_9.lineTo(62.4, 23.127000000000002);
    path_9.lineTo(62.402, 23.123);
    path_9.lineTo(61.472, 22.753);
    path_9.close();
    path_9.moveTo(60.57, 24.348000000000003);
    path_9.lineTo(59.77, 23.748);
    path_9.lineTo(59.769000000000005, 23.75);
    path_9.lineTo(60.57000000000001, 24.348);
    path_9.close();
    path_9.moveTo(59.305, 25.718000000000004);
    path_9.lineTo(59.967, 26.468000000000004);
    path_9.lineTo(59.305, 25.718000000000004);
    path_9.close();
    path_9.moveTo(57.875, 26.844000000000005);
    path_9.lineTo(57.305, 26.022000000000006);
    path_9.lineTo(54.678, 27.844000000000005);
    path_9.lineTo(57.875, 27.844000000000005);
    path_9.lineTo(57.875, 26.844000000000005);
    path_9.close();
    path_9.moveTo(61.578, 26.844000000000005);
    path_9.lineTo(62.576, 26.901000000000003);
    path_9.lineTo(62.638, 25.844000000000005);
    path_9.lineTo(61.577999999999996, 25.844000000000005);
    path_9.lineTo(61.577999999999996, 26.844000000000005);
    path_9.close();
    path_9.moveTo(61.297000000000004, 31.719000000000005);
    path_9.lineTo(61.263000000000005, 32.71900000000001);
    path_9.lineTo(62.239000000000004, 32.751000000000005);
    path_9.lineTo(62.295, 31.776000000000003);
    path_9.lineTo(61.297000000000004, 31.719000000000005);
    path_9.close();
    path_9.moveTo(50.328, 31.344000000000005);
    path_9.lineTo(49.328, 31.344000000000005);
    path_9.lineTo(49.328, 32.31);
    path_9.lineTo(50.294000000000004, 32.343);
    path_9.lineTo(50.328, 31.343000000000004);
    path_9.close();
    path_9.moveTo(50.328, 27.078000000000003);
    path_9.lineTo(50.006, 26.131000000000004);
    path_9.lineTo(49.328, 26.361000000000004);
    path_9.lineTo(49.328, 27.078000000000003);
    path_9.lineTo(50.328, 27.078000000000003);
    path_9.close();
    path_9.moveTo(51.628, 26.574);
    path_9.lineTo(52.025, 27.493000000000002);
    path_9.lineTo(52.032, 27.489);
    path_9.lineTo(51.629, 26.574);
    path_9.close();
    path_9.moveTo(52.977, 25.883000000000003);
    path_9.lineTo(52.474999999999994, 25.017000000000003);
    path_9.lineTo(52.468999999999994, 25.021000000000004);
    path_9.lineTo(52.977, 25.883000000000003);
    path_9.close();
    path_9.moveTo(54.230999999999995, 25.016000000000002);
    path_9.lineTo(53.60399999999999, 24.236);
    path_9.lineTo(53.59599999999999, 24.242);
    path_9.lineTo(54.23099999999999, 25.016000000000002);
    path_9.close();
    path_9.moveTo(55.272999999999996, 23.973000000000003);
    path_9.lineTo(54.491, 23.35);
    path_9.lineTo(54.489, 23.352);
    path_9.lineTo(55.272999999999996, 23.972);
    path_9.close();
    path_9.moveTo(55.988, 22.731);
    path_9.lineTo(55.061, 22.356);
    path_9.lineTo(55.058, 22.363000000000003);
    path_9.lineTo(55.055, 22.370000000000005);
    path_9.lineTo(55.988, 22.730000000000004);
    path_9.close();
    path_9.moveTo(56.094, 20.504);
    path_9.lineTo(55.181000000000004, 20.913);
    path_9.lineTo(55.187000000000005, 20.926000000000002);
    path_9.lineTo(55.193000000000005, 20.939000000000004);
    path_9.lineTo(56.093, 20.504000000000005);
    path_9.close();
    path_9.moveTo(55.660000000000004, 19.941000000000003);
    path_9.lineTo(55.02, 20.71);
    path_9.lineTo(55.03, 20.718);
    path_9.lineTo(55.04, 20.726);
    path_9.lineTo(55.66, 19.941);
    path_9.close();
    path_9.moveTo(55.004000000000005, 19.601000000000003);
    path_9.lineTo(54.697, 20.553000000000004);
    path_9.lineTo(54.715, 20.559000000000005);
    path_9.lineTo(54.733000000000004, 20.564000000000004);
    path_9.lineTo(55.00300000000001, 19.602000000000004);
    path_9.close();
    path_9.moveTo(53.504000000000005, 19.566000000000003);
    path_9.lineTo(53.694, 20.548000000000002);
    path_9.lineTo(53.709, 20.545);
    path_9.lineTo(53.724000000000004, 20.542);
    path_9.lineTo(53.504000000000005, 19.566000000000003);
    path_9.close();
    path_9.moveTo(52.121, 20.129);
    path_9.lineTo(52.668, 20.966);
    path_9.lineTo(52.676, 20.961000000000002);
    path_9.lineTo(52.121, 20.129);
    path_9.close();
    path_9.moveTo(51.571000000000005, 20.586000000000002);
    path_9.lineTo(50.595000000000006, 20.805000000000003);
    path_9.lineTo(51.004000000000005, 22.628000000000004);
    path_9.lineTo(52.294000000000004, 21.276000000000003);
    path_9.lineTo(51.57000000000001, 20.586000000000002);
    path_9.close();
    path_9.moveTo(50.539, 15.992);
    path_9.lineTo(49.832, 15.285);
    path_9.lineTo(49.442, 15.675);
    path_9.lineTo(49.563, 16.211000000000002);
    path_9.lineTo(50.539, 15.992000000000003);
    path_9.close();
    path_9.moveTo(52.719, 14.797);
    path_9.lineTo(52.991, 15.759);
    path_9.lineTo(52.999, 15.757);
    path_9.lineTo(53.008, 15.754);
    path_9.lineTo(52.718, 14.796999999999999);
    path_9.close();
    path_9.moveTo(57.829, 14.949);
    path_9.lineTo(57.439, 15.871);
    path_9.lineTo(57.447, 15.874);
    path_9.lineTo(57.828, 14.949);
    path_9.close();
    path_9.moveTo(59.902, 16.32);
    path_9.lineTo(59.195, 17.027);
    path_9.lineTo(59.205, 17.037000000000003);
    path_9.lineTo(59.902, 16.320000000000004);
    path_9.close();
    path_9.moveTo(61.297000000000004, 18.383);
    path_9.lineTo(60.37500000000001, 18.771);
    path_9.lineTo(60.379000000000005, 18.779);
    path_9.lineTo(61.297000000000004, 18.383);
    path_9.close();
    path_9.moveTo(61.813, 20.961);
    path_9.lineTo(60.813, 20.961);
    path_9.cubicTo(
      60.813,
      21.461,
      60.723,
      21.933999999999997,
      60.543,
      22.384999999999998,
    );
    path_9.lineTo(61.473, 22.753999999999998);
    path_9.lineTo(62.402, 23.124);
    path_9.cubicTo(
      62.676,
      22.433999999999997,
      62.812,
      21.709999999999997,
      62.812,
      20.961,
    );
    path_9.lineTo(61.812, 20.961);
    path_9.close();
    path_9.moveTo(61.473, 22.753999999999998);
    path_9.lineTo(60.545, 22.38);
    path_9.cubicTo(
      60.352000000000004,
      22.86,
      60.095,
      23.314999999999998,
      59.77,
      23.747999999999998,
    );
    path_9.lineTo(60.57, 24.348);
    path_9.lineTo(61.37, 24.948);
    path_9.arcToPoint(
      Offset(62.4, 23.128),
      radius: Radius.elliptical(8.017, 8.017),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(61.473, 22.754);
    path_9.close();
    path_9.moveTo(60.57, 24.348);
    path_9.lineTo(59.769, 23.75);
    path_9.arcToPoint(
      Offset(58.641999999999996, 24.97),
      radius: Radius.elliptical(8.09, 8.09),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(59.30499999999999, 25.718999999999998);
    path_9.lineTo(59.96799999999999, 26.467);
    path_9.arcToPoint(
      Offset(61.371999999999986, 24.945999999999998),
      radius: Radius.elliptical(10.08, 10.08),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(60.569999999999986, 24.348);
    path_9.close();
    path_9.moveTo(59.305, 25.718);
    path_9.lineTo(58.643, 24.969);
    path_9.cubicTo(58.201, 25.359, 57.755, 25.709, 57.305, 26.022000000000002);
    path_9.lineTo(57.875, 26.844);
    path_9.lineTo(58.445, 27.666);
    path_9.cubicTo(58.963, 27.306, 59.471000000000004, 26.906, 59.967, 26.468);
    path_9.lineTo(59.305, 25.718);
    path_9.close();
    path_9.moveTo(57.875, 26.844);
    path_9.lineTo(57.875, 27.844);
    path_9.lineTo(61.578, 27.844);
    path_9.lineTo(61.578, 25.844);
    path_9.lineTo(57.875, 25.844);
    path_9.lineTo(57.875, 26.844);
    path_9.close();
    path_9.moveTo(61.578, 26.844);
    path_9.lineTo(60.580000000000005, 26.786);
    path_9.lineTo(60.29800000000001, 31.661);
    path_9.lineTo(61.29700000000001, 31.719);
    path_9.lineTo(62.29500000000001, 31.776);
    path_9.lineTo(62.577000000000005, 26.901);
    path_9.lineTo(61.578, 26.844);
    path_9.close();
    path_9.moveTo(61.297000000000004, 31.719);
    path_9.lineTo(61.331, 30.719);
    path_9.lineTo(50.362, 30.344);
    path_9.lineTo(50.328, 31.344);
    path_9.lineTo(50.294000000000004, 32.344);
    path_9.lineTo(61.263000000000005, 32.718);
    path_9.lineTo(61.297000000000004, 31.718000000000004);
    path_9.close();
    path_9.moveTo(50.328, 31.344);
    path_9.lineTo(51.328, 31.344);
    path_9.lineTo(51.328, 27.078000000000003);
    path_9.lineTo(49.328, 27.078000000000003);
    path_9.lineTo(49.328, 31.344);
    path_9.lineTo(50.328, 31.344);
    path_9.close();
    path_9.moveTo(50.328, 27.078000000000003);
    path_9.lineTo(50.650000000000006, 28.025000000000002);
    path_9.cubicTo(
      51.092000000000006,
      27.875000000000004,
      51.550000000000004,
      27.697000000000003,
      52.025000000000006,
      27.493000000000002,
    );
    path_9.lineTo(51.629000000000005, 26.574);
    path_9.lineTo(51.233000000000004, 25.656000000000002);
    path_9.cubicTo(
      50.801,
      25.842000000000002,
      50.393,
      26.000000000000004,
      50.007000000000005,
      26.131000000000004,
    );
    path_9.lineTo(50.328, 27.078000000000003);
    path_9.close();
    path_9.moveTo(51.628, 26.574);
    path_9.lineTo(52.032000000000004, 27.489);
    path_9.cubicTo(
      52.529,
      27.27,
      53.013000000000005,
      27.022000000000002,
      53.484,
      26.744,
    );
    path_9.lineTo(52.977000000000004, 25.883);
    path_9.lineTo(52.469, 25.021);
    path_9.cubicTo(52.065, 25.259, 51.65, 25.471, 51.226, 25.659000000000002);
    path_9.lineTo(51.629, 26.574);
    path_9.close();
    path_9.moveTo(52.977, 25.883000000000003);
    path_9.lineTo(53.477, 26.748);
    path_9.cubicTo(
      53.968999999999994,
      26.464000000000002,
      54.431,
      26.144000000000002,
      54.864999999999995,
      25.788,
    );
    path_9.lineTo(54.23, 25.016000000000002);
    path_9.lineTo(53.596, 24.242);
    path_9.arcToPoint(
      Offset(52.476, 25.017),
      radius: Radius.elliptical(8.416, 8.416),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(52.976, 25.883);
    path_9.close();
    path_9.moveTo(54.230999999999995, 25.016000000000002);
    path_9.lineTo(54.85699999999999, 25.795);
    path_9.arcToPoint(
      Offset(56.056999999999995, 24.593000000000004),
      radius: Radius.elliptical(7.587, 7.587),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(55.272999999999996, 23.973000000000003);
    path_9.lineTo(54.489, 23.352000000000004);
    path_9.arcToPoint(
      Offset(53.604, 24.236000000000004),
      radius: Radius.elliptical(5.579, 5.579),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(54.231, 25.016000000000005);
    path_9.close();
    path_9.moveTo(55.272999999999996, 23.973000000000003);
    path_9.lineTo(56.056, 24.595000000000002);
    path_9.cubicTo(
      56.422,
      24.135,
      56.711999999999996,
      23.633000000000003,
      56.921,
      23.090000000000003,
    );
    path_9.lineTo(55.988, 22.730000000000004);
    path_9.lineTo(55.055, 22.370000000000005);
    path_9.arcToPoint(
      Offset(54.491, 23.350000000000005),
      radius: Radius.elliptical(3.709, 3.709),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(55.272999999999996, 23.973000000000006);
    path_9.close();
    path_9.moveTo(55.988, 22.731);
    path_9.lineTo(56.916, 23.105);
    path_9.arcToPoint(
      Offset(57.257999999999996, 21.289),
      radius: Radius.elliptical(4.813, 4.813),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(55.257999999999996, 21.289);
    path_9.cubicTo(
      55.257999999999996,
      21.686,
      55.18899999999999,
      22.039,
      55.06099999999999,
      22.356,
    );
    path_9.lineTo(55.98799999999999, 22.73);
    path_9.close();
    path_9.moveTo(56.258, 21.289);
    path_9.lineTo(57.258, 21.289);
    path_9.cubicTo(57.258, 20.869, 57.18, 20.454, 56.994, 20.069000000000003);
    path_9.lineTo(56.094, 20.504);
    path_9.lineTo(55.194, 20.939);
    path_9.arcToPoint(
      Offset(55.258, 21.289),
      radius: Radius.elliptical(0.796, 0.796),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(56.258, 21.289);
    path_9.close();
    path_9.moveTo(56.094, 20.504);
    path_9.lineTo(57.006, 20.094);
    path_9.arcToPoint(
      Offset(56.281, 19.157),
      radius: Radius.elliptical(2.474, 2.474),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(55.661, 19.941);
    path_9.lineTo(55.039, 20.726);
    path_9.arcToPoint(
      Offset(55.181000000000004, 20.913),
      radius: Radius.elliptical(0.474, 0.474),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(56.094, 20.503);
    path_9.close();
    path_9.moveTo(55.660000000000004, 19.941000000000003);
    path_9.lineTo(56.300000000000004, 19.173000000000002);
    path_9.arcToPoint(
      Offset(55.275000000000006, 18.639000000000003),
      radius: Radius.elliptical(2.751, 2.751),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(55.004000000000005, 19.602000000000004);
    path_9.lineTo(54.734, 20.564000000000004);
    path_9.arcToPoint(
      Offset(55.02, 20.710000000000004),
      radius: Radius.elliptical(0.754, 0.754),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(55.660000000000004, 19.941000000000006);
    path_9.close();
    path_9.moveTo(55.004000000000005, 19.601000000000003);
    path_9.lineTo(55.31100000000001, 18.650000000000002);
    path_9.arcToPoint(
      Offset(54.21900000000001, 18.484),
      radius: Radius.elliptical(3.542, 3.542),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(54.21900000000001, 20.484);
    path_9.cubicTo(
      54.40700000000001,
      20.484,
      54.56400000000001,
      20.51,
      54.69700000000001,
      20.554000000000002,
    );
    path_9.lineTo(55.00400000000001, 19.602000000000004);
    path_9.close();
    path_9.moveTo(54.21900000000001, 19.484);
    path_9.lineTo(54.21900000000001, 18.484);
    path_9.cubicTo(
      53.906000000000006,
      18.484,
      53.59400000000001,
      18.521,
      53.284000000000006,
      18.591,
    );
    path_9.lineTo(53.504000000000005, 19.566000000000003);
    path_9.lineTo(53.724000000000004, 20.542);
    path_9.arcToPoint(
      Offset(54.219, 20.484),
      radius: Radius.elliptical(2.24, 2.24),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(54.219, 19.484);
    path_9.close();
    path_9.moveTo(53.504000000000005, 19.566000000000003);
    path_9.lineTo(53.31400000000001, 18.585);
    path_9.arcToPoint(
      Offset(52.418000000000006, 18.849),
      radius: Radius.elliptical(4.869, 4.869),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(52.78900000000001, 19.777);
    path_9.lineTo(53.16000000000001, 20.706);
    path_9.cubicTo(
      53.33800000000001,
      20.634999999999998,
      53.51500000000001,
      20.583,
      53.69400000000001,
      20.548,
    );
    path_9.lineTo(53.50400000000001, 19.566);
    path_9.close();
    path_9.moveTo(52.789, 19.777);
    path_9.lineTo(52.418, 18.849);
    path_9.cubicTo(52.118, 18.969, 51.835, 19.118, 51.566, 19.297);
    path_9.lineTo(52.121, 20.129);
    path_9.lineTo(52.676, 20.961000000000002);
    path_9.arcToPoint(
      Offset(53.160000000000004, 20.706000000000003),
      radius: Radius.elliptical(2.63, 2.63),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(52.790000000000006, 19.777000000000005);
    path_9.close();
    path_9.moveTo(52.121, 20.129);
    path_9.lineTo(51.574000000000005, 19.292);
    path_9.arcToPoint(
      Offset(50.84700000000001, 19.895000000000003),
      radius: Radius.elliptical(4.115, 4.115),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(51.57000000000001, 20.585000000000004);
    path_9.lineTo(52.294000000000004, 21.276000000000003);
    path_9.cubicTo(
      52.404,
      21.161000000000005,
      52.528000000000006,
      21.058000000000003,
      52.668000000000006,
      20.966000000000005,
    );
    path_9.lineTo(52.12100000000001, 20.129000000000005);
    path_9.close();
    path_9.moveTo(51.571000000000005, 20.586000000000002);
    path_9.lineTo(52.54600000000001, 20.366000000000003);
    path_9.lineTo(51.51500000000001, 15.773000000000003);
    path_9.lineTo(50.53900000000001, 15.993000000000004);
    path_9.lineTo(49.56300000000001, 16.211000000000006);
    path_9.lineTo(50.59500000000001, 20.805000000000007);
    path_9.lineTo(51.570000000000014, 20.585000000000008);
    path_9.close();
    path_9.moveTo(50.539, 15.992);
    path_9.lineTo(51.246, 16.699);
    path_9.cubicTo(
      51.461000000000006,
      16.485000000000003,
      51.709,
      16.302000000000003,
      51.997,
      16.152,
    );
    path_9.lineTo(51.535, 15.266000000000002);
    path_9.lineTo(51.07299999999999, 14.379000000000001);
    path_9.cubicTo(
      50.61099999999999,
      14.619000000000002,
      50.19599999999999,
      14.922,
      49.831999999999994,
      15.285000000000002,
    );
    path_9.lineTo(50.538999999999994, 15.992000000000003);
    path_9.close();
    path_9.moveTo(51.535000000000004, 15.266000000000002);
    path_9.lineTo(51.99700000000001, 16.152);
    path_9.cubicTo(
      52.31100000000001,
      15.989,
      52.641000000000005,
      15.858,
      52.99100000000001,
      15.759,
    );
    path_9.lineTo(52.71900000000001, 14.797);
    path_9.lineTo(52.446000000000005, 13.835);
    path_9.arcToPoint(
      Offset(51.07300000000001, 14.379000000000001),
      radius: Radius.elliptical(7.221, 7.221),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(51.53500000000001, 15.266000000000002);
    path_9.close();
    path_9.moveTo(52.719, 14.796000000000001);
    path_9.lineTo(53.008, 15.754000000000001);
    path_9.cubicTo(
      53.368,
      15.645000000000001,
      53.736000000000004,
      15.567000000000002,
      54.111000000000004,
      15.519000000000002,
    );
    path_9.lineTo(53.984, 14.527000000000001);
    path_9.lineTo(53.858000000000004, 13.535);
    path_9.arcToPoint(
      Offset(52.43000000000001, 13.839),
      radius: Radius.elliptical(8.775, 8.775),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(52.71900000000001, 14.797);
    path_9.close();
    path_9.moveTo(53.984, 14.527000000000001);
    path_9.lineTo(54.111000000000004, 15.519000000000002);
    path_9.cubicTo(
      54.501000000000005,
      15.469000000000001,
      54.88,
      15.445000000000002,
      55.25000000000001,
      15.445000000000002,
    );
    path_9.lineTo(55.25000000000001, 13.445000000000002);
    path_9.cubicTo(
      54.79200000000001,
      13.445000000000002,
      54.32800000000001,
      13.475000000000001,
      53.858000000000004,
      13.535000000000002,
    );
    path_9.lineTo(53.984, 14.527000000000001);
    path_9.close();
    path_9.moveTo(55.25, 14.445);
    path_9.lineTo(55.25, 15.445);
    path_9.cubicTo(56.047, 15.445, 56.774, 15.59, 57.44, 15.871);
    path_9.lineTo(57.827999999999996, 14.949);
    path_9.lineTo(58.217, 14.028);
    path_9.arcToPoint(
      Offset(55.25, 13.445),
      radius: Radius.elliptical(7.566, 7.566),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(55.25, 14.445);
    path_9.close();
    path_9.moveTo(57.828, 14.949);
    path_9.lineTo(57.448, 15.874);
    path_9.arcToPoint(
      Offset(59.195, 17.027),
      radius: Radius.elliptical(5.29, 5.29),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(59.902, 16.32);
    path_9.lineTo(60.609, 15.613);
    path_9.arcToPoint(
      Offset(58.209, 14.024999999999999),
      radius: Radius.elliptical(7.282, 7.282),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(57.829, 14.948999999999998);
    path_9.close();
    path_9.moveTo(59.902, 16.32);
    path_9.lineTo(59.205, 17.037);
    path_9.arcToPoint(
      Offset(60.375, 18.771),
      radius: Radius.elliptical(5.21, 5.21),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(61.297, 18.383);
    path_9.lineTo(62.217999999999996, 17.994);
    path_9.arcToPoint(
      Offset(60.599999999999994, 15.604),
      radius: Radius.elliptical(7.208, 7.208),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(59.901999999999994, 16.32);
    path_9.close();
    path_9.moveTo(61.297000000000004, 18.383);
    path_9.lineTo(60.379000000000005, 18.779);
    path_9.cubicTo(60.665000000000006, 19.443, 60.813, 20.167, 60.813, 20.961);
    path_9.lineTo(62.813, 20.961);
    path_9.cubicTo(
      62.813,
      19.910999999999998,
      62.616,
      18.915999999999997,
      62.215,
      17.987,
    );
    path_9.lineTo(61.297000000000004, 18.383);
    path_9.close();
    path_9.moveTo(70.93700000000001, 23.366999999999997);
    path_9.lineTo(71.84600000000002, 23.787);
    path_9.lineTo(72.27300000000002, 22.86);
    path_9.lineTo(71.33800000000002, 22.451);
    path_9.lineTo(70.93800000000002, 23.367);
    path_9.close();
    path_9.moveTo(69.046, 27.873999999999995);
    path_9.lineTo(68.111, 27.518999999999995);
    path_9.lineTo(68.111, 27.520999999999994);
    path_9.lineTo(69.046, 27.873999999999995);
    path_9.close();
    path_9.moveTo(67.43400000000001, 32.495);
    path_9.lineTo(67.07000000000001, 33.427);
    path_9.lineTo(68.061, 33.813);
    path_9.lineTo(68.38600000000001, 32.800000000000004);
    path_9.lineTo(67.43400000000001, 32.495000000000005);
    path_9.close();
    path_9.moveTo(64.894, 31.505);
    path_9.lineTo(63.967000000000006, 31.131);
    path_9.lineTo(63.589000000000006, 32.069);
    path_9.lineTo(64.531, 32.436);
    path_9.lineTo(64.89500000000001, 31.505);
    path_9.close();
    path_9.moveTo(65.82100000000001, 29.213);
    path_9.lineTo(66.74800000000002, 29.589000000000002);
    path_9.lineTo(66.74800000000002, 29.587000000000003);
    path_9.lineTo(65.82100000000001, 29.213000000000005);
    path_9.close();
    path_9.moveTo(66.76700000000001, 26.935000000000002);
    path_9.lineTo(65.849, 26.539);
    path_9.lineTo(65.84700000000001, 26.542);
    path_9.lineTo(66.76700000000001, 26.935000000000002);
    path_9.close();
    path_9.moveTo(67.78300000000002, 24.681);
    path_9.lineTo(66.87800000000001, 24.255000000000003);
    path_9.lineTo(67.78300000000002, 24.681);
    path_9.close();
    path_9.moveTo(68.90600000000002, 22.478);
    path_9.lineTo(69.30700000000002, 21.562);
    path_9.lineTo(68.47000000000001, 21.196);
    path_9.lineTo(68.03000000000002, 21.996000000000002);
    path_9.lineTo(68.90600000000002, 22.479000000000003);
    path_9.close();
    path_9.moveTo(70.93800000000002, 23.368000000000002);
    path_9.lineTo(70.03000000000002, 22.948);
    path_9.arcToPoint(
      Offset(68.11100000000002, 27.519),
      radius: Radius.elliptical(71.266, 71.266),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(69.04600000000002, 27.874);
    path_9.lineTo(69.98100000000002, 28.229);
    path_9.arcToPoint(
      Offset(71.84600000000002, 23.786),
      radius: Radius.elliptical(69.347, 69.347),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(70.93800000000002, 23.367);
    path_9.close();
    path_9.moveTo(69.04600000000002, 27.874000000000002);
    path_9.lineTo(68.11000000000001, 27.521);
    path_9.arcToPoint(
      Offset(66.48100000000001, 32.19),
      radius: Radius.elliptical(97.283, 97.283),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(67.43400000000001, 32.495);
    path_9.lineTo(68.38600000000001, 32.800999999999995);
    path_9.arcToPoint(
      Offset(69.98200000000001, 28.226999999999997),
      radius: Radius.elliptical(95.147, 95.147),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(69.046, 27.873999999999995);
    path_9.close();
    path_9.moveTo(67.43400000000003, 32.495000000000005);
    path_9.lineTo(67.79700000000003, 31.564000000000004);
    path_9.lineTo(65.25800000000002, 30.574000000000005);
    path_9.lineTo(64.89500000000002, 31.504000000000005);
    path_9.lineTo(64.53100000000002, 32.437000000000005);
    path_9.lineTo(67.07100000000003, 33.42700000000001);
    path_9.lineTo(67.43400000000003, 32.495000000000005);
    path_9.close();
    path_9.moveTo(64.89400000000002, 31.505000000000006);
    path_9.lineTo(65.82200000000002, 31.879000000000005);
    path_9.cubicTo(
      66.13100000000001,
      31.114000000000004,
      66.43900000000002,
      30.350000000000005,
      66.74800000000002,
      29.589000000000006,
    );
    path_9.lineTo(65.82100000000001, 29.213000000000005);
    path_9.lineTo(64.89500000000001, 28.838000000000005);
    path_9.cubicTo(
      64.58500000000001,
      29.600000000000005,
      64.27600000000001,
      30.364000000000004,
      63.96700000000001,
      31.131000000000004,
    );
    path_9.lineTo(64.89500000000001, 31.505000000000003);
    path_9.close();
    path_9.moveTo(65.82100000000003, 29.213000000000008);
    path_9.lineTo(66.74900000000002, 29.587000000000007);
    path_9.cubicTo(
      67.05500000000002,
      28.827000000000005,
      67.36800000000002,
      28.074000000000005,
      67.68700000000003,
      27.327000000000005,
    );
    path_9.lineTo(66.76700000000002, 26.935000000000006);
    path_9.lineTo(65.84700000000002, 26.542000000000005);
    path_9.cubicTo(
      65.52300000000002,
      27.302000000000007,
      65.20500000000003,
      28.067000000000004,
      64.89400000000002,
      28.839000000000006,
    );
    path_9.lineTo(65.82100000000003, 29.213000000000005);
    path_9.close();
    path_9.moveTo(66.76700000000002, 26.93500000000001);
    path_9.lineTo(67.68600000000002, 27.33000000000001);
    path_9.cubicTo(
      68.00700000000002,
      26.58300000000001,
      68.34100000000002,
      25.84200000000001,
      68.68700000000003,
      25.108000000000008,
    );
    path_9.lineTo(67.78300000000003, 24.681000000000008);
    path_9.lineTo(66.87800000000003, 24.25500000000001);
    path_9.cubicTo(
      66.52200000000003,
      25.01000000000001,
      66.17800000000003,
      25.771000000000008,
      65.84800000000003,
      26.53900000000001,
    );
    path_9.lineTo(66.76800000000003, 26.93500000000001);
    path_9.close();
    path_9.moveTo(67.78300000000003, 24.681000000000008);
    path_9.lineTo(68.68700000000003, 25.108000000000008);
    path_9.cubicTo(
      69.03000000000003,
      24.38200000000001,
      69.39500000000002,
      23.666000000000007,
      69.78300000000003,
      22.960000000000008,
    );
    path_9.lineTo(68.90600000000003, 22.47800000000001);
    path_9.lineTo(68.03000000000003, 21.997000000000007);
    path_9.arcToPoint(
      Offset(66.87800000000003, 24.255000000000006),
      radius: Radius.elliptical(40.947, 40.947),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(67.78300000000003, 24.681000000000004);
    path_9.close();
    path_9.moveTo(68.90600000000003, 22.47800000000001);
    path_9.lineTo(68.50600000000003, 23.39500000000001);
    path_9.lineTo(70.53600000000003, 24.283000000000012);
    path_9.lineTo(70.93800000000003, 23.36700000000001);
    path_9.lineTo(71.33800000000004, 22.45100000000001);
    path_9.lineTo(69.30800000000004, 21.562000000000012);
    path_9.lineTo(68.90600000000003, 22.478000000000012);
    path_9.close();
    path_9.moveTo(78.54700000000004, 30.235000000000007);
    path_9.lineTo(77.64900000000004, 29.795000000000005);
    path_9.lineTo(77.64500000000004, 29.803000000000004);
    path_9.lineTo(78.54700000000004, 30.235000000000003);
    path_9.close();
    path_9.moveTo(74.35100000000004, 31.987000000000005);
    path_9.lineTo(74.19500000000004, 32.97500000000001);
    path_9.lineTo(74.20400000000004, 32.976000000000006);
    path_9.lineTo(74.21200000000003, 32.97800000000001);
    path_9.lineTo(74.35200000000003, 31.98800000000001);
    path_9.close();
    path_9.moveTo(73.63400000000004, 31.841000000000005);
    path_9.lineTo(73.37100000000004, 32.806000000000004);
    path_9.lineTo(73.38100000000004, 32.809000000000005);
    path_9.lineTo(73.39100000000005, 32.812000000000005);
    path_9.lineTo(73.63400000000004, 31.842000000000006);
    path_9.close();
    path_9.moveTo(72.93600000000005, 31.625000000000004);
    path_9.lineTo(72.60400000000006, 32.569);
    path_9.lineTo(72.60900000000005, 32.571000000000005);
    path_9.lineTo(72.93600000000005, 31.626000000000005);
    path_9.close();
    path_9.moveTo(72.24400000000006, 31.365000000000002);
    path_9.lineTo(71.24900000000005, 31.270000000000003);
    path_9.lineTo(71.17700000000005, 32.016000000000005);
    path_9.lineTo(71.87300000000005, 32.294000000000004);
    path_9.lineTo(72.24300000000005, 31.365000000000006);
    path_9.close();
    path_9.moveTo(72.48500000000006, 28.839000000000002);
    path_9.lineTo(72.97100000000006, 27.965000000000003);
    path_9.lineTo(71.63500000000006, 27.223000000000003);
    path_9.lineTo(71.49000000000007, 28.743000000000002);
    path_9.lineTo(72.48500000000007, 28.839000000000002);
    path_9.close();
    path_9.moveTo(72.97400000000006, 29.074);
    path_9.lineTo(72.59100000000007, 29.997);
    path_9.lineTo(72.97400000000006, 29.073999999999998);
    path_9.close();
    path_9.moveTo(73.50700000000006, 29.258000000000003);
    path_9.lineTo(73.23800000000006, 30.221000000000004);
    path_9.lineTo(73.24400000000006, 30.223000000000003);
    path_9.lineTo(73.50700000000006, 29.258000000000003);
    path_9.close();
    path_9.moveTo(74.06600000000006, 29.378000000000004);
    path_9.lineTo(73.90900000000006, 30.366000000000003);
    path_9.lineTo(73.91200000000006, 30.366000000000003);
    path_9.lineTo(74.06600000000006, 29.378000000000004);
    path_9.close();
    path_9.moveTo(75.00600000000006, 29.398000000000003);
    path_9.lineTo(75.11600000000006, 30.391000000000002);
    path_9.lineTo(75.12900000000006, 30.39);
    path_9.lineTo(75.14300000000006, 30.388);
    path_9.lineTo(75.00500000000005, 29.398000000000003);
    path_9.close();
    path_9.moveTo(75.44300000000005, 29.290000000000003);
    path_9.lineTo(75.78500000000005, 30.230000000000004);
    path_9.lineTo(75.79700000000005, 30.225000000000005);
    path_9.lineTo(75.81000000000006, 30.220000000000006);
    path_9.lineTo(75.44300000000005, 29.290000000000006);
    path_9.close();
    path_9.moveTo(75.79900000000005, 29.074);
    path_9.lineTo(76.47300000000006, 29.812);
    path_9.lineTo(76.47400000000006, 29.811);
    path_9.lineTo(75.79900000000006, 29.074);
    path_9.close();
    path_9.moveTo(75.83000000000006, 28.35);
    path_9.lineTo(75.03000000000006, 28.950000000000003);
    path_9.lineTo(75.03800000000005, 28.960000000000004);
    path_9.lineTo(75.04600000000005, 28.970000000000006);
    path_9.lineTo(75.83000000000006, 28.350000000000005);
    path_9.close();
    path_9.moveTo(75.52600000000005, 28.102);
    path_9.lineTo(75.04300000000005, 28.978);
    path_9.lineTo(75.06000000000004, 28.988000000000003);
    path_9.lineTo(75.07900000000005, 28.997000000000003);
    path_9.lineTo(75.52600000000005, 28.102000000000004);
    path_9.close();
    path_9.moveTo(74.63100000000006, 27.855);
    path_9.lineTo(74.49700000000006, 28.846);
    path_9.lineTo(74.50000000000006, 28.846);
    path_9.lineTo(74.63000000000005, 27.855);
    path_9.close();
    path_9.moveTo(74.18000000000006, 27.817);
    path_9.lineTo(74.15000000000006, 28.817);
    path_9.lineTo(74.18000000000006, 27.817);
    path_9.close();
    path_9.moveTo(73.24700000000006, 27.836);
    path_9.lineTo(73.16200000000006, 26.84);
    path_9.lineTo(73.16000000000007, 26.84);
    path_9.lineTo(73.24700000000007, 27.836);
    path_9.close();
    path_9.moveTo(72.67600000000006, 27.938);
    path_9.lineTo(71.67600000000006, 27.887999999999998);
    path_9.lineTo(71.60900000000007, 29.264999999999997);
    path_9.lineTo(72.93900000000006, 28.901999999999997);
    path_9.lineTo(72.67600000000006, 27.936999999999998);
    path_9.close();
    path_9.moveTo(72.93000000000006, 22.808);
    path_9.lineTo(72.90200000000006, 21.809);
    path_9.lineTo(71.97700000000006, 21.834);
    path_9.lineTo(71.93100000000005, 22.759);
    path_9.lineTo(72.93000000000005, 22.809);
    path_9.close();
    path_9.moveTo(78.07100000000007, 22.668);
    path_9.lineTo(79.07000000000006, 22.616);
    path_9.lineTo(79.01900000000006, 21.643);
    path_9.lineTo(78.04400000000007, 21.669);
    path_9.lineTo(78.07100000000007, 22.669);
    path_9.close();
    path_9.moveTo(78.21100000000007, 25.322);
    path_9.lineTo(78.15500000000007, 26.320999999999998);
    path_9.lineTo(79.26800000000007, 26.383);
    path_9.lineTo(79.20900000000007, 25.27);
    path_9.lineTo(78.21100000000007, 25.322);
    path_9.close();
    path_9.moveTo(75.02400000000007, 25.145);
    path_9.lineTo(75.08000000000007, 24.146);
    path_9.lineTo(74.08200000000006, 24.09);
    path_9.lineTo(74.02600000000007, 25.088);
    path_9.lineTo(75.02400000000007, 25.144000000000002);
    path_9.close();
    path_9.moveTo(74.96100000000007, 26.275);
    path_9.lineTo(73.96200000000007, 26.218);
    path_9.lineTo(73.88700000000007, 27.566);
    path_9.lineTo(75.19800000000006, 27.246);
    path_9.lineTo(74.96100000000007, 26.273999999999997);
    path_9.close();
    path_9.moveTo(75.53200000000007, 26.173);
    path_9.lineTo(75.64200000000007, 27.166999999999998);
    path_9.lineTo(75.65300000000006, 27.165);
    path_9.lineTo(75.66400000000006, 27.165);
    path_9.lineTo(75.53200000000005, 26.173);
    path_9.close();
    path_9.moveTo(77.17600000000007, 26.325);
    path_9.lineTo(76.81700000000008, 27.259);
    path_9.lineTo(76.82400000000008, 27.261);
    path_9.lineTo(76.83200000000008, 27.264);
    path_9.lineTo(77.17600000000007, 26.325);
    path_9.close();
    path_9.moveTo(78.04600000000008, 26.858);
    path_9.lineTo(77.35800000000008, 27.584);
    path_9.lineTo(77.36400000000008, 27.59);
    path_9.lineTo(78.04600000000008, 26.858);
    path_9.close();
    path_9.moveTo(78.63000000000008, 27.703);
    path_9.lineTo(77.70900000000007, 28.093);
    path_9.lineTo(77.71200000000007, 28.099);
    path_9.lineTo(77.71500000000007, 28.107);
    path_9.lineTo(78.63000000000008, 27.703);
    path_9.close();
    path_9.moveTo(78.84600000000007, 28.801);
    path_9.lineTo(77.84600000000007, 28.801);
    path_9.cubicTo(
      77.84600000000007,
      29.230999999999998,
      77.76800000000007,
      29.552999999999997,
      77.64900000000007,
      29.796,
    );
    path_9.lineTo(78.54700000000007, 30.236);
    path_9.lineTo(79.44500000000006, 30.676000000000002);
    path_9.cubicTo(
      79.72500000000007,
      30.106,
      79.84500000000007,
      29.471000000000004,
      79.84500000000007,
      28.801000000000002,
    );
    path_9.lineTo(78.84500000000007, 28.801000000000002);
    path_9.close();
    path_9.moveTo(78.54700000000007, 30.235);
    path_9.lineTo(77.64500000000007, 29.803);
    path_9.arcToPoint(
      Offset(77.12900000000006, 30.459),
      radius: Radius.elliptical(1.81, 1.81),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(77.74700000000006, 31.245);
    path_9.lineTo(78.36700000000006, 32.03);
    path_9.arcToPoint(
      Offset(79.44900000000005, 30.667),
      radius: Radius.elliptical(3.809, 3.809),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(78.54700000000005, 30.235000000000003);
    path_9.close();
    path_9.moveTo(77.74700000000007, 31.245);
    path_9.lineTo(77.12900000000008, 30.459);
    path_9.arcToPoint(
      Offset(76.27900000000008, 30.88),
      radius: Radius.elliptical(2.44, 2.44),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(76.55400000000009, 31.840999999999998);
    path_9.lineTo(76.83000000000008, 32.803);
    path_9.arcToPoint(
      Offset(78.36600000000008, 32.029999999999994),
      radius: Radius.elliptical(4.436, 4.436),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(77.74700000000009, 31.244999999999994);
    path_9.close();
    path_9.moveTo(76.55400000000007, 31.841);
    path_9.lineTo(76.27800000000008, 30.881);
    path_9.cubicTo(
      75.91800000000008,
      30.983,
      75.52400000000007,
      31.038,
      75.08800000000008,
      31.038,
    );
    path_9.lineTo(75.08800000000008, 33.038);
    path_9.arcToPoint(
      Offset(76.83000000000008, 32.803),
      radius: Radius.elliptical(6.3, 6.3),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(76.55400000000009, 31.840999999999998);
    path_9.close();
    path_9.moveTo(75.08800000000008, 32.038000000000004);
    path_9.lineTo(75.08800000000008, 31.038000000000004);
    path_9.arcToPoint(
      Offset(74.49000000000008, 30.997000000000003),
      radius: Radius.elliptical(4.33, 4.33),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(74.35100000000008, 31.987000000000002);
    path_9.lineTo(74.21200000000009, 32.977000000000004);
    path_9.cubicTo(
      74.50100000000009,
      33.018,
      74.79200000000009,
      33.038000000000004,
      75.0880000000001,
      33.038000000000004,
    );
    path_9.lineTo(75.0880000000001, 32.038000000000004);
    path_9.close();
    path_9.moveTo(74.35100000000008, 31.988000000000003);
    path_9.lineTo(74.50700000000009, 31.000000000000004);
    path_9.arcToPoint(
      Offset(73.8770000000001, 30.871000000000002),
      radius: Radius.elliptical(7.247, 7.247),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(73.6340000000001, 31.841);
    path_9.lineTo(73.3910000000001, 32.811);
    path_9.cubicTo(
      73.65700000000011,
      32.878,
      73.92500000000011,
      32.932,
      74.1950000000001,
      32.975,
    );
    path_9.lineTo(74.35100000000011, 31.987000000000002);
    path_9.close();
    path_9.moveTo(73.63400000000009, 31.841000000000005);
    path_9.lineTo(73.89700000000009, 30.876000000000005);
    path_9.arcToPoint(
      Offset(73.26200000000009, 30.680000000000003),
      radius: Radius.elliptical(9.985, 9.985),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(72.93600000000009, 31.625000000000004);
    path_9.lineTo(72.6090000000001, 32.571000000000005);
    path_9.cubicTo(
      72.8630000000001,
      32.65800000000001,
      73.1160000000001,
      32.737,
      73.3710000000001,
      32.806000000000004,
    );
    path_9.lineTo(73.6340000000001, 31.841000000000005);
    path_9.close();
    path_9.moveTo(72.93600000000009, 31.625000000000004);
    path_9.lineTo(73.26800000000009, 30.682000000000002);
    path_9.arcToPoint(
      Offset(72.61500000000008, 30.437),
      radius: Radius.elliptical(16.687, 16.687),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(72.24400000000009, 31.365000000000002);
    path_9.lineTo(71.87300000000009, 32.294000000000004);
    path_9.cubicTo(
      72.1180000000001,
      32.392,
      72.3620000000001,
      32.484,
      72.6030000000001,
      32.569,
    );
    path_9.lineTo(72.93600000000009, 31.625000000000004);
    path_9.close();
    path_9.moveTo(72.2440000000001, 31.365000000000002);
    path_9.lineTo(73.2390000000001, 31.46);
    path_9.lineTo(73.48100000000011, 28.934);
    path_9.lineTo(72.48500000000011, 28.839000000000002);
    path_9.lineTo(71.49000000000011, 28.744000000000003);
    path_9.lineTo(71.24900000000011, 31.270000000000003);
    path_9.lineTo(72.24400000000011, 31.365000000000002);
    path_9.close();
    path_9.moveTo(72.4850000000001, 28.839000000000002);
    path_9.lineTo(71.9990000000001, 29.713);
    path_9.cubicTo(
      72.18800000000009,
      29.817,
      72.38500000000009,
      29.913,
      72.5910000000001,
      29.997,
    );
    path_9.lineTo(72.97400000000009, 29.073999999999998);
    path_9.lineTo(73.35700000000008, 28.15);
    path_9.arcToPoint(
      Offset(72.97100000000009, 27.965),
      radius: Radius.elliptical(3.774, 3.774),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(72.48500000000008, 28.839);
    path_9.close();
    path_9.moveTo(72.9740000000001, 29.074);
    path_9.lineTo(72.59100000000011, 29.997);
    path_9.cubicTo(
      72.8010000000001,
      30.085,
      73.01800000000011,
      30.16,
      73.23800000000011,
      30.221,
    );
    path_9.lineTo(73.50800000000011, 29.258);
    path_9.lineTo(73.77600000000011, 28.294999999999998);
    path_9.arcToPoint(
      Offset(73.35600000000011, 28.15),
      radius: Radius.elliptical(3.672, 3.672),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(72.9740000000001, 29.073999999999998);
    path_9.close();
    path_9.moveTo(73.5070000000001, 29.258000000000003);
    path_9.lineTo(73.2440000000001, 30.223000000000003);
    path_9.cubicTo(
      73.4640000000001,
      30.283,
      73.68600000000009,
      30.331000000000003,
      73.9090000000001,
      30.366000000000003,
    );
    path_9.lineTo(74.0660000000001, 29.378000000000004);
    path_9.lineTo(74.2230000000001, 28.391000000000005);
    path_9.arcToPoint(
      Offset(73.7700000000001, 28.293000000000006),
      radius: Radius.elliptical(4.27, 4.27),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(73.50700000000009, 29.258000000000006);
    path_9.close();
    path_9.moveTo(74.0660000000001, 29.378000000000004);
    path_9.lineTo(73.9120000000001, 30.366000000000003);
    path_9.cubicTo(
      74.1490000000001,
      30.403000000000002,
      74.3850000000001,
      30.423000000000002,
      74.61800000000011,
      30.423000000000002,
    );
    path_9.lineTo(74.61800000000011, 28.423000000000002);
    path_9.arcToPoint(
      Offset(74.21900000000011, 28.39),
      radius: Radius.elliptical(2.53, 2.53),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(74.0660000000001, 29.378);
    path_9.close();
    path_9.moveTo(74.61800000000011, 29.423000000000005);
    path_9.lineTo(74.61800000000011, 30.423000000000005);
    path_9.cubicTo(
      74.77300000000011,
      30.423000000000005,
      74.9410000000001,
      30.411000000000005,
      75.11600000000011,
      30.391000000000005,
    );
    path_9.lineTo(75.00600000000011, 29.398000000000007);
    path_9.lineTo(74.89500000000011, 28.404000000000007);
    path_9.cubicTo(
      74.76500000000011,
      28.418000000000006,
      74.67500000000011,
      28.423000000000005,
      74.61800000000011,
      28.423000000000005,
    );
    path_9.lineTo(74.61800000000011, 29.423000000000005);
    path_9.close();
    path_9.moveTo(75.00500000000011, 29.398000000000007);
    path_9.lineTo(75.14300000000011, 30.388000000000005);
    path_9.cubicTo(
      75.36300000000011,
      30.358000000000004,
      75.57700000000011,
      30.305000000000007,
      75.78500000000011,
      30.229000000000006,
    );
    path_9.lineTo(75.44300000000011, 29.289000000000005);
    path_9.lineTo(75.10100000000011, 28.349000000000004);
    path_9.arcToPoint(
      Offset(74.86800000000011, 28.407000000000004),
      radius: Radius.elliptical(1.146, 1.146),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(75.00500000000011, 29.397000000000002);
    path_9.close();
    path_9.moveTo(75.44300000000011, 29.290000000000006);
    path_9.lineTo(75.81000000000012, 30.220000000000006);
    path_9.cubicTo(
      76.04700000000011,
      30.126000000000005,
      76.27400000000011,
      29.994000000000007,
      76.47300000000011,
      29.812000000000005,
    );
    path_9.lineTo(75.7990000000001, 29.074000000000005);
    path_9.lineTo(75.12400000000011, 28.335000000000004);
    path_9.cubicTo(
      75.1290000000001,
      28.331000000000003,
      75.11900000000011,
      28.343000000000004,
      75.07700000000011,
      28.359000000000005,
    );
    path_9.lineTo(75.44300000000011, 29.289000000000005);
    path_9.close();
    path_9.moveTo(75.7990000000001, 29.074000000000005);
    path_9.lineTo(76.4740000000001, 29.811000000000003);
    path_9.cubicTo(
      76.7990000000001,
      29.513000000000005,
      76.9510000000001,
      29.117000000000004,
      76.9510000000001,
      28.711000000000002,
    );
    path_9.lineTo(74.9510000000001, 28.711000000000002);
    path_9.arcToPoint(
      Offset(75.1230000000001, 28.336000000000002),
      radius: Radius.elliptical(0.545, 0.545),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(75.7990000000001, 29.074);
    path_9.close();
    path_9.moveTo(75.9510000000001, 28.712000000000007);
    path_9.lineTo(76.9510000000001, 28.712000000000007);
    path_9.cubicTo(
      76.9510000000001,
      28.366000000000007,
      76.8460000000001,
      28.022000000000006,
      76.6140000000001,
      27.729000000000006,
    );
    path_9.lineTo(75.8300000000001, 28.350000000000005);
    path_9.lineTo(75.04600000000009, 28.970000000000006);
    path_9.arcToPoint(
      Offset(74.95100000000009, 28.712000000000007),
      radius: Radius.elliptical(0.46, 0.46),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(75.95100000000009, 28.712000000000007);
    path_9.close();
    path_9.moveTo(75.8310000000001, 28.35000000000001);
    path_9.lineTo(76.6310000000001, 27.750000000000007);
    path_9.arcToPoint(
      Offset(75.9730000000001, 27.208000000000006),
      radius: Radius.elliptical(1.845, 1.845),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(75.5260000000001, 28.103000000000005);
    path_9.lineTo(75.0790000000001, 28.997000000000003);
    path_9.cubicTo(
      75.0820000000001,
      28.999000000000002,
      75.0770000000001,
      28.997000000000003,
      75.06700000000009,
      28.988000000000003,
    );
    path_9.arcToPoint(
      Offset(75.03000000000009, 28.950000000000003),
      radius: Radius.elliptical(0.216, 0.216),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(75.83000000000008, 28.35);
    path_9.close();
    path_9.moveTo(75.5260000000001, 28.102000000000007);
    path_9.lineTo(76.0090000000001, 27.227000000000007);
    path_9.arcToPoint(
      Offset(75.3430000000001, 26.97200000000001),
      radius: Radius.elliptical(2.69, 2.69),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(75.1070000000001, 27.94400000000001);
    path_9.lineTo(74.8700000000001, 28.91600000000001);
    path_9.cubicTo(
      74.9530000000001,
      28.93600000000001,
      75.00800000000011,
      28.95900000000001,
      75.0430000000001,
      28.978000000000012,
    );
    path_9.lineTo(75.52600000000011, 28.10200000000001);
    path_9.close();
    path_9.moveTo(75.1060000000001, 27.944000000000006);
    path_9.lineTo(75.34300000000009, 26.972000000000005);
    path_9.arcToPoint(
      Offset(74.7610000000001, 26.863000000000003),
      radius: Radius.elliptical(5.472, 5.472),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(74.6310000000001, 27.855000000000004);
    path_9.lineTo(74.5010000000001, 28.846000000000004);
    path_9.arcToPoint(
      Offset(74.87100000000011, 28.916000000000004),
      radius: Radius.elliptical(3.5, 3.5),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(75.10700000000011, 27.944000000000003);
    path_9.close();
    path_9.moveTo(74.6310000000001, 27.855000000000008);
    path_9.lineTo(74.7650000000001, 26.864000000000008);
    path_9.arcToPoint(
      Offset(74.2090000000001, 26.817000000000007),
      radius: Radius.elliptical(5.327, 5.327),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(74.1800000000001, 27.817000000000007);
    path_9.lineTo(74.1500000000001, 28.817000000000007);
    path_9.cubicTo(
      74.2560000000001,
      28.820000000000007,
      74.37100000000011,
      28.829000000000008,
      74.4970000000001,
      28.846000000000007,
    );
    path_9.lineTo(74.6310000000001, 27.855000000000008);
    path_9.close();
    path_9.moveTo(74.1800000000001, 27.817000000000007);
    path_9.lineTo(74.21000000000011, 26.817000000000007);
    path_9.arcToPoint(
      Offset(73.83000000000011, 26.811000000000007),
      radius: Radius.elliptical(12.9, 12.9),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(73.83000000000011, 28.811000000000007);
    path_9.cubicTo(
      73.91000000000011,
      28.811000000000007,
      74.01600000000012,
      28.81200000000001,
      74.1500000000001,
      28.816000000000006,
    );
    path_9.lineTo(74.1800000000001, 27.816000000000006);
    path_9.close();
    path_9.moveTo(73.83000000000011, 27.811000000000007);
    path_9.lineTo(73.83000000000011, 26.811000000000007);
    path_9.cubicTo(
      73.61000000000011,
      26.811000000000007,
      73.38800000000012,
      26.82100000000001,
      73.1620000000001,
      26.840000000000007,
    );
    path_9.lineTo(73.2470000000001, 27.836000000000006);
    path_9.lineTo(73.3320000000001, 28.832000000000004);
    path_9.cubicTo(
      73.50400000000009,
      28.818000000000005,
      73.67000000000009,
      28.811000000000003,
      73.83100000000009,
      28.811000000000003,
    );
    path_9.lineTo(73.83100000000009, 27.811000000000003);
    path_9.close();
    path_9.moveTo(73.24700000000011, 27.836000000000006);
    path_9.lineTo(73.16000000000011, 26.840000000000007);
    path_9.arcToPoint(
      Offset(72.4120000000001, 26.973000000000006),
      radius: Radius.elliptical(4.23, 4.23),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(72.6760000000001, 27.938000000000006);
    path_9.lineTo(72.9390000000001, 28.902000000000005);
    path_9.arcToPoint(
      Offset(73.3340000000001, 28.832000000000004),
      radius: Radius.elliptical(2.22, 2.22),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(73.2470000000001, 27.836000000000006);
    path_9.close();
    path_9.moveTo(72.67600000000012, 27.938000000000006);
    path_9.lineTo(73.67400000000012, 27.987000000000005);
    path_9.lineTo(73.92800000000013, 22.858000000000004);
    path_9.lineTo(72.93000000000012, 22.808000000000003);
    path_9.lineTo(71.93000000000012, 22.759000000000004);
    path_9.lineTo(71.67700000000012, 27.889000000000003);
    path_9.lineTo(72.67600000000012, 27.938000000000002);
    path_9.close();
    path_9.moveTo(72.93000000000012, 22.808000000000007);
    path_9.lineTo(72.95700000000012, 23.808000000000007);
    path_9.lineTo(78.09800000000013, 23.668000000000006);
    path_9.lineTo(78.07100000000013, 22.668000000000006);
    path_9.lineTo(78.04400000000012, 21.669000000000008);
    path_9.lineTo(72.90200000000013, 21.809000000000008);
    path_9.lineTo(72.93000000000013, 22.809000000000008);
    path_9.close();
    path_9.moveTo(78.07100000000013, 22.668000000000006);
    path_9.lineTo(77.07300000000012, 22.721000000000007);
    path_9.lineTo(77.21300000000012, 25.375000000000007);
    path_9.lineTo(78.21100000000013, 25.322000000000006);
    path_9.lineTo(79.20900000000013, 25.270000000000007);
    path_9.lineTo(79.06900000000013, 22.616000000000007);
    path_9.lineTo(78.07100000000013, 22.669000000000008);
    path_9.close();
    path_9.moveTo(78.21100000000013, 25.322000000000006);
    path_9.lineTo(78.26600000000013, 24.324000000000005);
    path_9.lineTo(75.08000000000013, 24.146000000000004);
    path_9.lineTo(75.02400000000013, 25.144000000000005);
    path_9.lineTo(74.96900000000012, 26.143000000000004);
    path_9.lineTo(78.15500000000011, 26.321000000000005);
    path_9.lineTo(78.21100000000011, 25.322000000000006);
    path_9.close();
    path_9.moveTo(75.02400000000013, 25.145000000000007);
    path_9.lineTo(74.02600000000012, 25.088000000000008);
    path_9.lineTo(73.96200000000013, 26.218000000000007);
    path_9.lineTo(74.96100000000013, 26.274000000000008);
    path_9.lineTo(75.95900000000013, 26.33000000000001);
    path_9.lineTo(76.02300000000012, 25.20000000000001);
    path_9.lineTo(75.02400000000013, 25.14500000000001);
    path_9.close();
    path_9.moveTo(74.96100000000013, 26.275000000000006);
    path_9.lineTo(75.19800000000012, 27.245000000000005);
    path_9.arcToPoint(
      Offset(75.64300000000011, 27.167000000000005),
      radius: Radius.elliptical(3.55, 3.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_9.lineTo(75.53200000000011, 26.173000000000005);
    path_9.lineTo(75.42200000000011, 25.179000000000006);
    path_9.arcToPoint(
      Offset(74.72300000000011, 25.303000000000004),
      radius: Radius.elliptical(5.496, 5.496),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(74.96100000000011, 26.274000000000004);
    path_9.close();
    path_9.moveTo(75.53200000000012, 26.173000000000005);
    path_9.lineTo(75.66400000000013, 27.164000000000005);
    path_9.cubicTo(
      75.81100000000013,
      27.144000000000005,
      75.95700000000014,
      27.134000000000004,
      76.10400000000013,
      27.134000000000004,
    );
    path_9.lineTo(76.10400000000013, 25.134000000000004);
    path_9.cubicTo(
      75.86800000000012,
      25.134000000000004,
      75.63400000000013,
      25.150000000000002,
      75.40000000000013,
      25.182000000000002,
    );
    path_9.lineTo(75.53200000000014, 26.172);
    path_9.close();
    path_9.moveTo(76.10300000000012, 26.135000000000005);
    path_9.lineTo(76.10300000000012, 27.135000000000005);
    path_9.cubicTo(
      76.37700000000012,
      27.135000000000005,
      76.61100000000012,
      27.179000000000006,
      76.81700000000012,
      27.258000000000006,
    );
    path_9.lineTo(77.17700000000012, 26.325000000000006);
    path_9.lineTo(77.53500000000012, 25.392000000000007);
    path_9.arcToPoint(
      Offset(76.10300000000012, 25.135000000000005),
      radius: Radius.elliptical(3.964, 3.964),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(76.10300000000012, 26.135000000000005);
    path_9.close();
    path_9.moveTo(77.17600000000012, 26.325000000000006);
    path_9.lineTo(76.83200000000012, 27.264000000000006);
    path_9.cubicTo(
      77.04500000000012,
      27.342000000000006,
      77.21600000000012,
      27.450000000000006,
      77.35800000000012,
      27.584000000000007,
    );
    path_9.lineTo(78.04600000000012, 26.858000000000008);
    path_9.lineTo(78.73400000000012, 26.133000000000006);
    path_9.arcToPoint(
      Offset(77.52100000000013, 25.386000000000006),
      radius: Radius.elliptical(3.5, 3.5),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(77.17600000000013, 26.326000000000008);
    path_9.close();
    path_9.moveTo(78.04600000000012, 26.858000000000008);
    path_9.lineTo(77.36400000000012, 27.590000000000007);
    path_9.cubicTo(
      77.50500000000012,
      27.72200000000001,
      77.62100000000012,
      27.88500000000001,
      77.70900000000012,
      28.092000000000006,
    );
    path_9.lineTo(78.62900000000012, 27.702000000000005);
    path_9.lineTo(79.55100000000012, 27.313000000000006);
    path_9.arcToPoint(
      Offset(78.72800000000012, 26.127000000000006),
      radius: Radius.elliptical(3.436, 3.436),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(78.04600000000012, 26.858000000000008);
    path_9.close();
    path_9.moveTo(78.63000000000012, 27.703000000000007);
    path_9.lineTo(77.71500000000012, 28.107000000000006);
    path_9.cubicTo(
      77.79500000000012,
      28.288000000000007,
      77.84500000000011,
      28.514000000000006,
      77.84500000000011,
      28.801000000000005,
    );
    path_9.lineTo(79.84500000000011, 28.801000000000005);
    path_9.arcToPoint(
      Offset(79.54500000000012, 27.299000000000007),
      radius: Radius.elliptical(3.69, 3.69),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_9.lineTo(78.63000000000011, 27.703000000000007);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff7596B5).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
