import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

//Copy this CustomPainter code to the Bottom of the File
class FirstIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(60.318, 66.224);
    path_0.cubicTo(
      79.738,
      63.504000000000005,
      102.208,
      50.31400000000001,
      98.258,
      25.404000000000003,
    );
    path_0.cubicTo(
      98.238,
      25.254000000000005,
      98.21799999999999,
      25.124000000000002,
      98.208,
      25.014000000000003,
    );
    path_0.cubicTo(
      98.188,
      24.874000000000002,
      98.16799999999999,
      24.764000000000003,
      98.148,
      24.694000000000003,
    );
    path_0.lineTo(98.128, 24.594);
    path_0.cubicTo(97.998, 23.904, 97.868, 23.214000000000002, 97.698, 22.504);
    path_0.cubicTo(
      91.448,
      -4.285999999999998,
      36.297999999999995,
      -5.096,
      10.727999999999994,
      9.284,
    );
    path_0.cubicTo(
      4.377999999999995,
      12.854000000000001,
      0.9379999999999953,
      18.624000000000002,
      0.16799999999999393,
      25.174,
    );
    path_0.cubicTo(
      -2.172000000000006,
      44.994,
      20.017999999999994,
      71.874,
      60.31799999999999,
      66.22399999999999,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5637980, size.height * 1.000269),
      Offset(size.width * 0.4478687, size.height * -0.3059701),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(34.268, 56.154);
    path_1.cubicTo(
      36.298,
      54.504000000000005,
      33.778,
      48.354000000000006,
      26.888,
      49.024,
    );
    path_1.cubicTo(19.988, 49.704, 27.268, 61.844, 34.268, 56.154);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(33.978, 51.784);
    path_2.cubicTo(33.978, 51.784, 35.158, 53.614, 34.088, 55.184);
    path_2.cubicTo(33.018, 56.754, 30.628, 57.354, 27.528000000000002, 55.784);
    path_2.cubicTo(
      24.428,
      54.224,
      24.118000000000002,
      51.403999999999996,
      24.118000000000002,
      51.403999999999996,
    );
    path_2.cubicTo(
      24.118000000000002,
      51.403999999999996,
      23.838,
      52.494,
      24.678,
      54.464,
    );
    path_2.cubicTo(25.518, 56.434, 28.408, 58.903999999999996, 33.038, 57.794);
    path_2.cubicTo(
      37.668,
      56.693999999999996,
      34.647999999999996,
      52.233999999999995,
      33.977999999999994,
      51.784,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(98.148, 24.694);
    path_3.lineTo(98.208, 25.014);
    path_3.cubicTo(98.178, 24.884, 98.158, 24.764, 98.148, 24.694);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9919394, size.height * 0.3734328),
      Offset(size.width * 0.9913838, size.height * 0.3686269),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(98.118, 24.594);
    path_4.cubicTo(98.118, 24.594, 98.128, 24.634, 98.13799999999999, 24.704);
    path_4.lineTo(98.118, 24.594);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9913535, size.height * 0.3686119),
      Offset(size.width * 0.9911616, size.height * 0.3670149),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(98.198, 25.023);
    path_5.cubicTo(
      98.21799999999999,
      25.153,
      98.228,
      25.283,
      98.24799999999999,
      25.413,
    );
    path_5.cubicTo(
      98.23799999999999,
      25.263,
      98.21799999999999,
      25.123,
      98.198,
      25.023,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9925354, size.height * 0.3791791),
      Offset(size.width * 0.9918687, size.height * 0.3734328),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(60.318, 66.224);
    path_6.cubicTo(
      79.738,
      63.504000000000005,
      102.208,
      50.31400000000001,
      98.258,
      25.404000000000003,
    );
    path_6.cubicTo(
      98.768,
      29.484,
      99.428,
      47.784000000000006,
      72.228,
      57.504000000000005,
    );
    path_6.cubicTo(
      41.507999999999996,
      68.474,
      0.2680000000000007,
      57.944,
      0.16799999999999216,
      25.184000000000005,
    );
    path_6.cubicTo(
      -2.1720000000000077,
      44.994,
      20.017999999999994,
      71.874,
      60.31799999999999,
      66.224,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5637273, size.height * 1.000284),
      Offset(size.width * 0.4776970, size.height * 0.2557612),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(7.538, 16.674);
    path_7.cubicTo(
      7.738,
      3.203999999999999,
      55.458,
      -7.466000000000001,
      81.74799999999999,
      9.604,
    );
    path_7.cubicTo(
      108.03799999999998,
      26.674,
      73.57799999999999,
      49.974,
      44.85799999999999,
      49.844,
    );
    path_7.cubicTo(
      16.13799999999999,
      49.724000000000004,
      7.437999999999988,
      23.774,
      7.53799999999999,
      16.674,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5484242, size.height * 0.7330448),
      Offset(size.width * 0.4633434, size.height * -0.3238806),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(89.458, 17.154);
    path_8.cubicTo(89.458, 17.154, 92.248, 35.873999999999995, 62.778, 45.164);
    path_8.cubicTo(
      33.308,
      54.454,
      10.647999999999996,
      35.364000000000004,
      7.597999999999999,
      17.904,
    );
    path_8.cubicTo(
      7.597999999999999,
      17.904,
      7.347999999999999,
      41.664,
      36.288,
      50.584,
    );
    path_8.cubicTo(
      65.228,
      59.514,
      102.458,
      31.354000000000003,
      89.458,
      17.154000000000003,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5564646, size.height * 0.7730149),
      Offset(size.width * 0.4860909, size.height * 0.1640448),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(69.748, 39.674);
    path_9.cubicTo(
      82.03800000000001,
      33.324,
      59.73800000000001,
      9.663999999999998,
      29.108000000000004,
      16.854,
    );
    path_9.cubicTo(
      -1.521999999999995,
      24.054,
      30.188000000000002,
      60.104,
      69.748,
      39.674,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(67.588, 57.924);
    path_10.cubicTo(
      72.948,
      56.314,
      42.66799999999999,
      54.734,
      30.227999999999994,
      49.644,
    );
    path_10.cubicTo(
      17.777999999999995,
      44.554,
      11.097999999999995,
      32.733999999999995,
      8.837999999999994,
      31.663999999999998,
    );
    path_10.cubicTo(
      6.577999999999994,
      30.593999999999998,
      2.3579999999999934,
      43.093999999999994,
      17.727999999999994,
      53.534,
    );
    path_10.cubicTo(
      33.09799999999999,
      63.994,
      55.45799999999999,
      61.574,
      67.588,
      57.924,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(96.348, 26.754);
    path_11.cubicTo(98.198, 25.024, 93.028, 47.024, 80.988, 52.254000000000005);
    path_11.cubicTo(
      68.94800000000001,
      57.49400000000001,
      61.138,
      54.20400000000001,
      59.588,
      53.944,
    );
    path_11.cubicTo(
      58.038000000000004,
      53.684000000000005,
      75.818,
      49.744,
      96.348,
      26.754,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(9.958, 28.654);
    path_12.cubicTo(9.768, 25.414, 5.198, 23.354, 2.3580000000000005, 27.904);
    path_12.cubicTo(
      -0.4819999999999993,
      32.464,
      10.228000000000002,
      33.364,
      9.958,
      28.654,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(9.548, 27.194);
    path_13.cubicTo(9.548, 27.194, 10.338000000000001, 30.194, 7.338, 31.104);
    path_13.cubicTo(
      4.328,
      32.013999999999996,
      1.7880000000000003,
      30.274,
      2.168,
      28.264,
    );
    path_13.cubicTo(2.168, 28.264, 1.4180000000000001, 29.084, 1.278, 30.274);
    path_13.cubicTo(
      1.138,
      31.464000000000002,
      3.738,
      33.364000000000004,
      8.228,
      32.594,
    );
    path_13.cubicTo(12.718, 31.834, 10.318, 28.184, 9.548, 27.194000000000003);
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(3.978, 27.314);
    path_14.cubicTo(
      5.0280000000000005,
      27.224,
      5.018000000000001,
      29.014,
      3.3480000000000003,
      29.004,
    );
    path_14.cubicTo(1.6880000000000004, 28.984, 3.208, 27.384, 3.978, 27.314);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(79.448, 52.834);
    path_15.cubicTo(
      79.928,
      51.134,
      79.54799999999999,
      46.284000000000006,
      76.818,
      44.464000000000006,
    );
    path_15.cubicTo(
      74.098,
      42.654,
      68.148,
      45.99400000000001,
      65.27799999999999,
      50.23400000000001,
    );
    path_15.cubicTo(
      62.407999999999994,
      54.47400000000001,
      64.568,
      56.41400000000001,
      69.74799999999999,
      56.41400000000001,
    );
    path_15.cubicTo(
      74.93799999999999,
      56.42400000000001,
      79.07799999999999,
      54.15400000000001,
      79.448,
      52.83400000000001,
    );
    path_15.close();
    path_15.moveTo(20.257999999999996, 47.374);
    path_15.cubicTo(
      21.597999999999995,
      48.624,
      21.477999999999994,
      50.514,
      19.037999999999997,
      51.284000000000006,
    );
    path_15.cubicTo(
      16.598,
      52.05400000000001,
      14.377999999999997,
      49.59400000000001,
      14.117999999999997,
      48.66400000000001,
    );
    path_15.cubicTo(
      13.867999999999997,
      47.73400000000001,
      19.387999999999998,
      46.56400000000001,
      20.257999999999996,
      47.37400000000001,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(78.818, 47.063);
    path_16.cubicTo(78.818, 47.063, 79.858, 52.283, 76.338, 54.213);
    path_16.cubicTo(
      72.818,
      56.153,
      67.87799999999999,
      56.103,
      65.868,
      55.413000000000004,
    );
    path_16.cubicTo(
      63.858000000000004,
      54.723000000000006,
      64.048,
      52.963,
      64.048,
      52.963,
    );
    path_16.cubicTo(64.048, 52.963, 63.648, 54.293, 64.628, 55.943);
    path_16.cubicTo(65.618, 57.592999999999996, 75.928, 57.233, 78.848, 54.933);
    path_16.cubicTo(81.758, 52.633, 78.818, 47.063, 78.818, 47.063);
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(20.598, 47.734);
    path_17.cubicTo(20.598, 47.734, 21.258, 48.894, 20.418, 49.914);
    path_17.cubicTo(19.588, 50.934000000000005, 17.258, 51.234, 15.658, 50.104);
    path_17.cubicTo(
      14.058,
      48.974,
      14.177999999999999,
      48.424,
      14.177999999999999,
      48.424,
    );
    path_17.cubicTo(
      14.177999999999999,
      48.424,
      14.088,
      48.614,
      14.088,
      48.903999999999996,
    );
    path_17.cubicTo(
      14.088,
      49.193999999999996,
      15.478,
      51.614,
      18.357999999999997,
      51.693999999999996,
    );
    path_17.cubicTo(
      21.237999999999996,
      51.773999999999994,
      22.057999999999996,
      49.354,
      20.598,
      47.733999999999995,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(85.608, 42.904);
    path_18.cubicTo(
      87.608,
      44.444,
      87.058,
      47.67400000000001,
      83.688,
      48.934000000000005,
    );
    path_18.cubicTo(
      81.358,
      49.804,
      79.708,
      47.324000000000005,
      79.518,
      46.394000000000005,
    );
    path_18.cubicTo(79.328, 45.444, 84.468, 42.02400000000001, 85.608, 42.904);
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(86.068, 43.353);
    path_19.cubicTo(
      86.068,
      43.353,
      86.948,
      45.053000000000004,
      85.52799999999999,
      46.903,
    );
    path_19.cubicTo(84.338, 48.443, 81.91799999999999, 48.893, 80.618, 47.723);
    path_19.cubicTo(79.488, 46.702999999999996, 79.548, 46.113, 79.548, 46.113);
    path_19.cubicTo(79.548, 46.113, 79.488, 46.323, 79.498, 46.623);
    path_19.cubicTo(
      79.50800000000001,
      46.922999999999995,
      80.488,
      49.303,
      82.938,
      49.422999999999995,
    );
    path_19.cubicTo(
      86.47800000000001,
      49.602999999999994,
      88.298,
      45.583,
      86.068,
      43.352999999999994,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(54.708, 43.404);
    path_20.cubicTo(
      63.658,
      38.024,
      48.298,
      30.284000000000006,
      30.607999999999997,
      35.444,
    );
    path_20.cubicTo(
      12.917999999999996,
      40.604,
      42.647999999999996,
      50.654,
      54.708,
      43.404,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5782929, size.height * 0.5775970),
      Offset(size.width * 0.2553535, size.height * 0.6153284),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(22.118, 6.934);
    path_21.cubicTo(
      31.948,
      6.704,
      18.747999999999998,
      15.654,
      12.867999999999999,
      15.154,
    );
    path_21.cubicTo(
      6.977999999999999,
      14.644,
      11.307999999999998,
      7.194,
      22.118,
      6.933999999999999,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2608687, size.height * 0.1553134),
      Offset(size.width * 0.1020303, size.height * 0.1738657),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(56.538, 41.944);
    path_22.cubicTo(56.538, 41.944, 59.147999999999996, 36.104, 43.458, 35.664);
    path_22.cubicTo(
      27.567999999999998,
      35.224000000000004,
      26.458,
      41.334,
      26.887999999999998,
      42.024,
    );
    path_22.cubicTo(
      27.328,
      42.714,
      33.948,
      46.474000000000004,
      43.007999999999996,
      46.034,
    );
    path_22.cubicTo(53.867999999999995, 45.504, 56.538, 41.944, 56.538, 41.944);
    path_22.close();
    path_22.moveTo(25.157999999999998, 9.434000000000005);
    path_22.cubicTo(
      25.157999999999998,
      9.434000000000005,
      24.487999999999996,
      6.494000000000005,
      17.247999999999998,
      8.524000000000004,
    );
    path_22.cubicTo(
      10.007999999999997,
      10.544000000000004,
      10.777999999999999,
      14.404000000000003,
      10.777999999999999,
      14.404000000000003,
    );
    path_22.cubicTo(
      10.777999999999999,
      14.404000000000003,
      12.437999999999999,
      16.354000000000003,
      17.948,
      14.134000000000004,
    );
    path_22.cubicTo(
      23.468,
      11.914000000000003,
      25.158,
      9.434000000000005,
      25.158,
      9.434000000000005,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor13.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(35.158, 16.934);
    path_23.cubicTo(
      35.558,
      17.054000000000002,
      35.838,
      17.114,
      35.958,
      17.144000000000002,
    );
    path_23.cubicTo(35.838, 17.094, 35.548, 17.024, 35.158, 16.934);
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor20.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(82.238, 30.154);
    path_24.cubicTo(85.498, 30.404, 80.068, 33.844, 77.878, 33.564);
    path_24.cubicTo(75.698, 33.274, 79.118, 29.904, 82.238, 30.154);
    path_24.close();
    path_24.moveTo(93.738, 33.424);
    path_24.cubicTo(95.518, 34.474, 93.478, 38.044, 88.668, 37.414);
    path_24.cubicTo(
      83.86800000000001,
      36.794000000000004,
      91.938,
      32.364000000000004,
      93.738,
      33.424,
    );
    path_24.close();
    path_24.moveTo(12.798000000000002, 18.064);
    path_24.cubicTo(
      15.868000000000002,
      19.364,
      12.448000000000002,
      19.764,
      11.118000000000002,
      19.184,
    );
    path_24.cubicTo(
      9.778000000000002,
      18.604000000000003,
      12.058000000000002,
      17.754,
      12.798000000000002,
      18.064,
    );
    path_24.close();
    path_24.moveTo(11.418000000000003, 37.894999999999996);
    path_24.cubicTo(
      12.198000000000002,
      38.644999999999996,
      10.468000000000004,
      38.824999999999996,
      9.658000000000003,
      38.044999999999995,
    );
    path_24.cubicTo(
      8.868000000000002,
      37.27499999999999,
      10.248000000000003,
      36.76499999999999,
      11.418000000000003,
      37.894999999999996,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = GameColors.islandPainterColor49.withValues(alpha: 1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(29.488, 28.164);
    path_25.cubicTo(30.778, 28.934, 28.958, 29.434, 27.718, 29.004);
    path_25.cubicTo(26.478, 28.574, 28.208, 27.394000000000002, 29.488, 28.164);
    path_25.close();
    path_25.moveTo(29.798, 25.983);
    path_25.cubicTo(
      30.357999999999997,
      26.113,
      29.578,
      26.643,
      29.017999999999997,
      26.433,
    );
    path_25.cubicTo(28.458, 26.223, 28.897999999999996, 25.773, 29.798, 25.983);
    path_25.close();
    path_25.moveTo(41.757999999999996, 29.513);
    path_25.cubicTo(
      42.708,
      30.253,
      40.12799999999999,
      31.413,
      38.227999999999994,
      30.553,
    );
    path_25.cubicTo(
      36.337999999999994,
      29.683,
      40.477999999999994,
      28.503,
      41.757999999999996,
      29.513,
    );
    path_25.close();
    path_25.moveTo(25.647999999999996, 34.354);
    path_25.cubicTo(
      25.927999999999997,
      35.324,
      24.947999999999997,
      35.524,
      24.267999999999997,
      34.734,
    );
    path_25.cubicTo(
      23.587999999999997,
      33.934000000000005,
      25.517999999999997,
      33.874,
      25.647999999999996,
      34.354,
    );
    path_25.close();
    path_25.moveTo(27.897999999999996, 29.543);
    path_25.cubicTo(
      29.017999999999997,
      30.663,
      26.187999999999995,
      31.012999999999998,
      25.417999999999996,
      29.983,
    );
    path_25.cubicTo(
      24.647999999999996,
      28.953000000000003,
      26.997999999999998,
      28.643,
      27.897999999999996,
      29.543,
    );
    path_25.close();
    path_25.moveTo(22.347999999999995, 16.654);
    path_25.cubicTo(
      23.587999999999994,
      17.114,
      20.827999999999996,
      19.644,
      19.457999999999995,
      18.924,
    );
    path_25.cubicTo(
      18.097999999999995,
      18.204,
      19.617999999999995,
      15.644,
      22.347999999999995,
      16.654,
    );
    path_25.close();
    path_25.moveTo(24.917999999999996, 18.723);
    path_25.cubicTo(
      25.627999999999997,
      18.903,
      25.157999999999994,
      19.753,
      24.127999999999997,
      19.602999999999998,
    );
    path_25.cubicTo(
      23.087999999999997,
      19.453,
      23.107999999999997,
      18.262999999999998,
      24.917999999999996,
      18.723,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_25, paint25Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class SecondIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(6.994, 58.115);
    path_0.cubicTo(
      10.934,
      63.385000000000005,
      16.323999999999998,
      67.475,
      22.644,
      69.395,
    );
    path_0.cubicTo(
      50.854,
      77.975,
      61.083999999999996,
      92.255,
      102.54400000000001,
      64.785,
    );
    path_0.cubicTo(
      102.60400000000001,
      64.755,
      102.66400000000002,
      64.715,
      102.72400000000002,
      64.675,
    );
    path_0.cubicTo(
      102.79400000000001,
      64.63499999999999,
      102.85400000000001,
      64.595,
      102.88400000000001,
      64.575,
    );
    path_0.cubicTo(
      103.17400000000002,
      64.385,
      103.47400000000002,
      64.185,
      103.76400000000001,
      63.985,
    );
    path_0.cubicTo(
      111.15400000000001,
      59.015,
      113.68400000000001,
      50.394999999999996,
      111.95400000000001,
      41.065,
    );
    path_0.cubicTo(
      111.93400000000001,
      40.955,
      111.924,
      40.875,
      111.914,
      40.824999999999996,
    );
    path_0.lineTo(111.914, 40.794999999999995);
    path_0.lineTo(111.904, 40.794999999999995);
    path_0.cubicTo(
      107.86399999999999,
      19.854999999999993,
      82.494,
      -4.505000000000003,
      42.483999999999995,
      0.7149999999999963,
    );
    path_0.cubicTo(
      17.493999999999996,
      3.974999999999996,
      5.063999999999993,
      15.544999999999996,
      1.2739999999999938,
      28.364999999999995,
    );
    path_0.lineTo(1.2639999999999938, 28.394999999999996);
    path_0.cubicTo(
      -1.7560000000000062,
      38.724999999999994,
      0.8239999999999938,
      49.875,
      6.993999999999994,
      58.114999999999995,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4977434, size.height * 0.9980123),
      Offset(size.width * 0.4977434, size.height * -0.01111111),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(111.914, 40.785);
    path_1.cubicTo(
      111.914,
      40.785,
      111.914,
      40.794999999999995,
      111.924,
      40.815,
    );
    path_1.lineTo(111.914, 40.785);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9904425, size.height * 0.5039012),
      Offset(size.width * 0.9904425, size.height * 0.5035679),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(22.644, 69.396);
    path_2.cubicTo(51.134, 78.066, 61.284, 92.536, 103.774, 63.976);
    path_2.cubicTo(
      111.164,
      59.006,
      113.694,
      50.385999999999996,
      111.964,
      41.056,
    );
    path_2.cubicTo(
      112.254,
      43.025999999999996,
      113.234,
      55.936,
      90.964,
      67.73599999999999,
    );
    path_2.cubicTo(
      66.78399999999999,
      80.54599999999999,
      33.844,
      71.136,
      16.263999999999996,
      59.48599999999999,
    );
    path_2.cubicTo(
      -1.3060000000000045,
      47.83599999999999,
      1.4139999999999961,
      27.96599999999999,
      1.4139999999999961,
      27.96599999999999,
    );
    path_2.lineTo(1.2839999999999963, 28.35599999999999);
    path_2.lineTo(1.2739999999999962, 28.385999999999992);
    path_2.cubicTo(
      -3.706000000000004,
      45.34599999999999,
      6.433999999999997,
      64.45599999999999,
      22.644,
      69.39599999999999,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4977345, size.height * 0.9980370),
      Offset(size.width * 0.4977345, size.height * 0.3452222),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(6.994, 58.115);
    path_3.cubicTo(
      10.934,
      63.385000000000005,
      16.323999999999998,
      67.475,
      22.644,
      69.395,
    );
    path_3.cubicTo(
      50.854,
      77.975,
      61.083999999999996,
      92.255,
      102.54400000000001,
      64.785,
    );
    path_3.cubicTo(
      99.51400000000001,
      66.60499999999999,
      79.12400000000001,
      78.045,
      52.15400000000001,
      72.935,
    );
    path_3.cubicTo(
      22.90400000000001,
      67.405,
      6.994000000000014,
      58.115,
      6.994000000000014,
      58.115,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4846637, size.height * 0.9980123),
      Offset(size.width * 0.4846637, size.height * 0.7174815),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(91.964, 19.475);
    path_4.cubicTo(106.744, 38.505, 89.574, 70.875, 41.304, 54.705);
    path_4.cubicTo(
      0.7839999999999989,
      41.135,
      18.194000000000003,
      8.704999999999998,
      40.444,
      3.9549999999999983,
    );
    path_4.cubicTo(
      62.684,
      -0.8050000000000015,
      81.374,
      5.844999999999998,
      91.964,
      19.474999999999998,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5046195, size.height * 0.7294938),
      Offset(size.width * 0.5046195, size.height * 0.02988889),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(96.704, 29.866);
    path_5.cubicTo(96.704, 29.866, 98.354, 50.366, 74.994, 54.706);
    path_5.cubicTo(
      51.634,
      59.04600000000001,
      30.634,
      51.326,
      22.183999999999997,
      40.156000000000006,
    );
    path_5.cubicTo(
      13.743999999999998,
      28.986000000000004,
      24.263999999999996,
      13.216000000000005,
      24.263999999999996,
      13.216000000000005,
    );
    path_5.cubicTo(
      24.263999999999996,
      13.216000000000005,
      16.643999999999995,
      19.536000000000005,
      16.263999999999996,
      31.436000000000003,
    );
    path_5.cubicTo(
      15.883999999999995,
      43.336000000000006,
      38.943999999999996,
      64.936,
      68.94399999999999,
      61.96600000000001,
    );
    path_5.cubicTo(
      98.93399999999998,
      58.99600000000001,
      99.50399999999999,
      41.626000000000005,
      96.704,
      29.866000000000007,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5046195, size.height * 0.7683457),
      Offset(size.width * 0.5046195, size.height * 0.1631235),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(74.184, 52.746);
    path_6.cubicTo(
      87.564,
      48.206,
      67.384,
      24.676000000000002,
      40.443999999999996,
      20.046,
    );
    path_6.cubicTo(
      13.503999999999994,
      15.425999999999998,
      18.853999999999996,
      34.316,
      23.403999999999996,
      41.626,
    );
    path_6.cubicTo(
      27.943999999999996,
      48.936,
      51.483999999999995,
      60.43599999999999,
      74.184,
      52.745999999999995,
    );
    path_6.close();
    path_6.moveTo(84.884, 14.786000000000001);
    path_6.cubicTo(
      93.20400000000001,
      22.976,
      59.304,
      26.026000000000003,
      46.824,
      17.256,
    );
    path_6.cubicTo(
      34.324,
      8.476,
      61.333999999999996,
      -8.373999999999999,
      84.884,
      14.786,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(42.404, 4.835);
    path_7.cubicTo(
      50.024,
      5.435,
      39.294000000000004,
      12.245000000000001,
      34.774,
      11.325,
    );
    path_7.cubicTo(
      30.244,
      10.395,
      34.024,
      4.174999999999999,
      42.404,
      4.834999999999999,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3986637, size.height * 0.1002840),
      Offset(size.width * 0.2906372, size.height * 0.09962963),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(44.604, 7.286);
    path_8.cubicTo(44.604, 7.286, 44.254, 4.635999999999999, 38.534, 5.826);
    path_8.cubicTo(32.814, 7.016, 33.194, 10.486, 33.194, 10.486);
    path_8.cubicTo(
      33.194,
      10.486,
      34.364000000000004,
      12.346,
      38.754000000000005,
      10.836,
    );
    path_8.cubicTo(
      43.154,
      9.336,
      44.604000000000006,
      7.2860000000000005,
      44.604000000000006,
      7.2860000000000005,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = GameColors.islandPainterColor13.withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(49.434, 46.656);
    path_9.cubicTo(
      59.343999999999994,
      42.846,
      45.553999999999995,
      29.586,
      27.003999999999998,
      30.726,
    );
    path_9.cubicTo(
      8.463999999999999,
      31.875999999999998,
      36.083999999999996,
      51.786,
      49.434,
      46.656,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4689735, size.height * 0.5077284),
      Offset(size.width * 0.1806903, size.height * 0.4550370),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(51.524, 45.455);
    path_10.cubicTo(51.524, 45.455, 55.224000000000004, 39.355, 39.714, 34.525);
    path_10.cubicTo(24.014, 29.625, 21.753999999999998, 36.445, 22.054, 37.375);
    path_10.cubicTo(22.354, 38.295, 28.223999999999997, 44.515, 37.314, 46.495);
    path_10.cubicTo(48.194, 48.864999999999995, 51.524, 45.455, 51.524, 45.455);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = GameColors.islandPainterColor13.withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(50.164, 24.615);
    path_11.cubicTo(
      53.434000000000005,
      27.034999999999997,
      51.044000000000004,
      31.755,
      39.954,
      30.665,
    );
    path_11.cubicTo(28.864, 29.564999999999998, 25.714, 24.615, 25.714, 24.615);
    path_11.cubicTo(25.714, 24.615, 35.924, 14.054999999999998, 50.164, 24.615);
    path_11.close();
    path_11.moveTo(62.074, 55.156);
    path_11.cubicTo(62.894, 54.536, 57.664, 48.266, 46.954, 47.936);
    path_11.cubicTo(36.244, 47.606, 26.794, 44.896, 26.794, 44.896);
    path_11.cubicTo(26.794, 44.896, 39.824, 56.516, 62.074, 55.156);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(40.464, 69.475);
    path_12.cubicTo(42.734, 67.725, 18.724, 49.584999999999994, 16.554, 34.175);
    path_12.cubicTo(
      14.383999999999999,
      18.764999999999997,
      25.723999999999997,
      8.834999999999997,
      25.723999999999997,
      8.834999999999997,
    );
    path_12.cubicTo(
      25.723999999999997,
      8.834999999999997,
      2.463999999999995,
      8.374999999999996,
      1.423999999999996,
      34.175,
    );
    path_12.cubicTo(0.3839999999999959, 59.985, 40.464, 69.475, 40.464, 69.475);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(105.024, 57.515);
    path_13.cubicTo(
      107.334,
      52.565,
      90.20400000000001,
      59.955,
      72.95400000000001,
      61.455,
    );
    path_13.cubicTo(
      55.70400000000001,
      62.955,
      40.144000000000005,
      63.515,
      39.824000000000005,
      65.345,
    );
    path_13.cubicTo(
      39.504000000000005,
      67.175,
      48.264,
      74.935,
      70.57400000000001,
      72.845,
    );
    path_13.cubicTo(
      92.88400000000001,
      70.755,
      105.02400000000002,
      57.515,
      105.02400000000002,
      57.515,
    );
    path_13.close();
    path_13.moveTo(26.793999999999997, 62.236000000000004);
    path_13.cubicTo(
      30.723999999999997,
      62.836000000000006,
      23.983999999999998,
      44.43600000000001,
      12.743999999999996,
      40.816,
    );
    path_13.cubicTo(
      1.4939999999999962,
      37.196000000000005,
      3.793999999999997,
      58.726,
      26.793999999999997,
      62.236000000000004,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(54.454, 10.935);
    path_14.cubicTo(57.254, 13.255, 50.914, 13.445, 49.084, 11.775);
    path_14.cubicTo(47.254000000000005, 10.095, 51.774, 8.715, 54.454, 10.935);
    path_14.close();
    path_14.moveTo(85.394, 35.935);
    path_14.cubicTo(87.194, 37.185, 85.134, 41.435, 80.254, 40.695);
    path_14.cubicTo(
      75.37400000000001,
      39.955,
      83.56400000000001,
      34.675,
      85.394,
      35.935,
    );
    path_14.close();
    path_14.moveTo(29.794000000000004, 16.176000000000002);
    path_14.cubicTo(
      30.584000000000003,
      17.076,
      28.824000000000005,
      17.286,
      28.014000000000003,
      16.356,
    );
    path_14.cubicTo(
      27.194000000000003,
      15.446000000000002,
      28.594,
      14.826000000000002,
      29.794000000000004,
      16.176000000000002,
    );
    path_14.close();
    path_14.moveTo(78.54400000000001, 41.146);
    path_14.cubicTo(
      84.40400000000001,
      44.066,
      78.07400000000001,
      49.086,
      72.004,
      45.036,
    );
    path_14.cubicTo(
      65.934,
      40.986000000000004,
      75.224,
      39.496,
      78.54400000000001,
      41.146,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = GameColors.islandPainterColor49.withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(34.124, 60.925);
    path_15.cubicTo(
      36.864000000000004,
      59.065,
      34.894000000000005,
      55.974999999999994,
      31.374000000000002,
      53.345,
    );
    path_15.cubicTo(
      27.854000000000003,
      50.705,
      17.864000000000004,
      55.035,
      16.804000000000002,
      56.165,
    );
    path_15.cubicTo(
      15.754000000000001,
      57.295,
      25.154000000000003,
      67.025,
      34.124,
      60.925,
    );
    path_15.close();
    path_15.moveTo(13.424000000000003, 41.364999999999995);
    path_15.cubicTo(
      15.374000000000002,
      39.894999999999996,
      14.224000000000004,
      31.544999999999995,
      8.354000000000003,
      30.414999999999996,
    );
    path_15.cubicTo(
      2.4840000000000027,
      29.284999999999997,
      6.704000000000002,
      46.425,
      13.424000000000003,
      41.364999999999995,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(34.924, 57.065);
    path_16.cubicTo(34.924, 57.065, 34.814, 63.464999999999996, 27.214, 62.295);
    path_16.cubicTo(
      16.464,
      60.645,
      17.793999999999997,
      55.485,
      17.793999999999997,
      55.485,
    );
    path_16.cubicTo(
      17.793999999999997,
      55.485,
      16.793999999999997,
      56.155,
      16.503999999999998,
      56.545,
    );
    path_16.cubicTo(
      16.214,
      56.925000000000004,
      19.183999999999997,
      62.545,
      26.873999999999995,
      63.345,
    );
    path_16.cubicTo(
      34.56399999999999,
      64.145,
      35.803999999999995,
      59.985,
      35.714,
      59.105,
    );
    path_16.cubicTo(35.644, 58.235, 34.924, 57.065, 34.924, 57.065);
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(50.784, 63.486);
    path_17.cubicTo(51.544, 64.816, 49.494, 66.256, 48.333999999999996, 64.556);
    path_17.cubicTo(47.174, 62.866, 50.273999999999994, 62.596, 50.784, 63.486);
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(50.784, 63.485);
    path_18.cubicTo(50.784, 63.485, 51.244, 64.895, 49.794, 64.925);
    path_18.cubicTo(
      48.333999999999996,
      64.955,
      48.083999999999996,
      63.775,
      48.083999999999996,
      63.775,
    );
    path_18.cubicTo(
      48.083999999999996,
      63.775,
      47.873999999999995,
      65.625,
      49.81399999999999,
      65.635,
    );
    path_18.cubicTo(
      51.75399999999999,
      65.64500000000001,
      50.78399999999999,
      63.48500000000001,
      50.78399999999999,
      63.48500000000001,
    );
    path_18.close();
    path_18.moveTo(13.854, 35.855000000000004);
    path_18.cubicTo(
      13.854,
      35.855000000000004,
      14.553999999999998,
      38.465,
      13.424,
      40.115,
    );
    path_18.cubicTo(
      12.294,
      41.765,
      10.203999999999999,
      41.815000000000005,
      7.853999999999999,
      38.995000000000005,
    );
    path_18.cubicTo(
      5.504,
      36.175000000000004,
      5.683999999999999,
      32.58500000000001,
      5.683999999999999,
      32.58500000000001,
    );
    path_18.cubicTo(
      5.683999999999999,
      32.58500000000001,
      5.283999999999999,
      33.85500000000001,
      5.683999999999999,
      36.53500000000001,
    );
    path_18.cubicTo(
      6.084,
      39.21500000000001,
      8.113999999999999,
      43.10500000000001,
      12.154,
      43.04500000000001,
    );
    path_18.cubicTo(
      16.184,
      42.99500000000001,
      14.344,
      36.60500000000001,
      13.854,
      35.85500000000001,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(45.894, 67.135);
    path_19.cubicTo(
      48.074,
      65.385,
      45.964,
      57.815000000000005,
      38.934,
      57.885000000000005,
    );
    path_19.cubicTo(
      31.903999999999996,
      57.97500000000001,
      38.403999999999996,
      73.165,
      45.894,
      67.135,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(45.914, 61.916);
    path_20.cubicTo(45.914, 61.916, 46.974000000000004, 64.216, 45.784, 65.976);
    path_20.cubicTo(
      44.594,
      67.736,
      42.123999999999995,
      68.18599999999999,
      39.094,
      66.006,
    );
    path_20.cubicTo(36.064, 63.826, 35.964, 60.436, 35.964, 60.436);
    path_20.cubicTo(35.964, 60.436, 35.604, 61.696, 36.314, 64.126);
    path_20.cubicTo(
      37.024,
      66.55600000000001,
      39.764,
      69.786,
      44.534,
      68.96600000000001,
    );
    path_20.cubicTo(
      49.294,
      68.13600000000001,
      46.564,
      62.516000000000005,
      45.914,
      61.91600000000001,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(15.994, 22.475);
    path_21.cubicTo(
      16.034,
      18.605,
      11.553999999999998,
      15.685000000000002,
      8.354,
      20.795,
    );
    path_21.cubicTo(5.164, 25.905, 15.934, 28.095000000000002, 15.994, 22.475);
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(15.684, 20.695);
    path_22.cubicTo(15.684, 20.695, 16.274, 24.335, 13.164, 25.105);
    path_22.cubicTo(
      10.053999999999998,
      25.875,
      7.604,
      23.535,
      8.134,
      21.185000000000002,
    );
    path_22.cubicTo(
      8.134,
      21.185000000000002,
      7.324,
      22.075000000000003,
      7.0840000000000005,
      23.475,
    );
    path_22.cubicTo(
      6.854,
      24.875,
      9.354000000000001,
      27.405,
      13.954,
      26.965000000000003,
    );
    path_22.cubicTo(
      18.564,
      26.535000000000004,
      16.394000000000002,
      21.945000000000004,
      15.684000000000001,
      20.695000000000004,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(10.044, 20.255);
    path_23.cubicTo(11.114, 20.255, 10.974, 22.384999999999998, 9.284, 22.195);
    path_23.cubicTo(
      7.604000000000001,
      21.995,
      9.254000000000001,
      20.255,
      10.044,
      20.255,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(106.644, 40.925);
    path_24.cubicTo(106.674, 37.055, 103.674, 34.135, 101.534, 39.245);
    path_24.cubicTo(
      99.384,
      44.355,
      106.60400000000001,
      46.544999999999995,
      106.644,
      40.925,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(106.434, 39.145);
    path_25.cubicTo(
      106.434,
      39.145,
      106.824,
      42.785000000000004,
      104.744,
      43.55500000000001,
    );
    path_25.cubicTo(
      102.664,
      44.32500000000001,
      101.024,
      41.98500000000001,
      101.384,
      39.635000000000005,
    );
    path_25.cubicTo(
      101.384,
      39.635000000000005,
      100.834,
      40.525000000000006,
      100.684,
      41.925000000000004,
    );
    path_25.cubicTo(
      100.53399999999999,
      43.325,
      102.204,
      45.855000000000004,
      105.28399999999999,
      45.415000000000006,
    );
    path_25.cubicTo(
      108.35399999999998,
      44.98500000000001,
      106.91399999999999,
      40.40500000000001,
      106.434,
      39.14500000000001,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(102.654, 38.705);
    path_26.cubicTo(
      103.36399999999999,
      38.705,
      103.274,
      40.835,
      102.14399999999999,
      40.644999999999996,
    );
    path_26.cubicTo(
      101.02399999999999,
      40.455,
      102.124,
      38.705,
      102.654,
      38.705,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(68.894, 21.516);
    path_27.cubicTo(
      70.34400000000001,
      22.546,
      68.304,
      23.195999999999998,
      66.90400000000001,
      22.636,
    );
    path_27.cubicTo(65.504, 22.066, 67.46400000000001, 20.506, 68.894, 21.516);
    path_27.close();
    path_27.moveTo(69.244, 18.636);
    path_27.cubicTo(69.874, 18.806, 69.004, 19.506, 68.374, 19.226);
    path_27.cubicTo(67.744, 18.956, 68.22399999999999, 18.366, 69.244, 18.636);
    path_27.close();
    path_27.moveTo(82.734, 23.305);
    path_27.cubicTo(
      83.80399999999999,
      24.285,
      80.89399999999999,
      25.825,
      78.764,
      24.675,
    );
    path_27.cubicTo(76.624, 23.535, 81.28399999999999, 21.975, 82.734, 23.305);
    path_27.close();
    path_27.moveTo(64.574, 29.715);
    path_27.cubicTo(
      64.89399999999999,
      31.005,
      63.784,
      31.265,
      63.013999999999996,
      30.215,
    );
    path_27.cubicTo(
      62.24399999999999,
      29.165,
      64.42399999999999,
      29.085,
      64.574,
      29.715,
    );
    path_27.close();
    path_27.moveTo(57.074, 28.936);
    path_27.cubicTo(57.394, 30.226, 56.284, 30.486, 55.513999999999996, 29.436);
    path_27.cubicTo(54.754, 28.386, 56.92399999999999, 28.306, 57.074, 28.936);
    path_27.close();
    path_27.moveTo(67.114, 23.356);
    path_27.cubicTo(
      68.37400000000001,
      24.836000000000002,
      65.194,
      25.296000000000003,
      64.31400000000001,
      23.936,
    );
    path_27.cubicTo(
      63.434000000000005,
      22.576,
      66.09400000000001,
      22.166,
      67.114,
      23.356,
    );
    path_27.close();
    path_27.moveTo(65.084, 46.215);
    path_27.cubicTo(
      66.34400000000001,
      47.695,
      63.164,
      48.155,
      62.284000000000006,
      46.795,
    );
    path_27.cubicTo(
      61.41400000000001,
      45.435,
      64.06400000000001,
      45.025,
      65.084,
      46.215,
    );
    path_27.close();
    path_27.moveTo(60.854, 6.286000000000001);
    path_27.cubicTo(
      62.254,
      6.886000000000001,
      59.144,
      10.246000000000002,
      57.604,
      9.296000000000001,
    );
    path_27.cubicTo(
      56.054,
      8.346000000000002,
      57.774,
      4.956000000000001,
      60.854,
      6.286000000000001,
    );
    path_27.close();
    path_27.moveTo(63.744, 9.026000000000002);
    path_27.cubicTo(
      64.544,
      9.256000000000002,
      64.024,
      10.386000000000001,
      62.854,
      10.186000000000002,
    );
    path_27.cubicTo(
      61.684,
      9.986000000000002,
      61.704,
      8.426000000000002,
      63.744,
      9.026000000000002,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(69.414, 23.416);
    path_28.cubicTo(70.214, 23.646, 69.694, 24.776, 68.524, 24.576);
    path_28.cubicTo(67.364, 24.386, 67.384, 22.816, 69.414, 23.416);
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class ThirdIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(1.25, 102.128);
    path_0.cubicTo(4.68, 112.858, 15.5, 122.688, 37.57, 126.498);
    path_0.cubicTo(
      94.83,
      136.40800000000002,
      116.189,
      131.448,
      124.959,
      119.25800000000001,
    );
    path_0.lineTo(124.96900000000001, 119.248);
    path_0.cubicTo(
      128.269,
      114.658,
      141.37900000000002,
      116.108,
      157.609,
      118.718,
    );
    path_0.lineTo(157.619, 118.718);
    path_0.cubicTo(
      157.639,
      118.718,
      157.669,
      118.72800000000001,
      157.699,
      118.738,
    );
    path_0.lineTo(158.079, 118.798);
    path_0.cubicTo(
      184.949,
      123.148,
      220.149,
      130.528,
      233.62900000000002,
      119.058,
    );
    path_0.cubicTo(
      239.03900000000002,
      114.44800000000001,
      242.299,
      106.028,
      243.12900000000002,
      95.828,
    );
    path_0.cubicTo(243.419, 92.278, 243.419, 88.518, 243.109, 84.618);
    path_0.lineTo(243.109, 84.60799999999999);
    path_0.cubicTo(
      240.809,
      55.44799999999999,
      221.40900000000002,
      19.177999999999983,
      180.239,
      12.407999999999987,
    );
    path_0.cubicTo(
      121.459,
      2.747999999999987,
      100.949,
      18.667999999999985,
      76.539,
      43.02799999999999,
    );
    path_0.cubicTo(
      52.129000000000005,
      67.38799999999999,
      52.409000000000006,
      62.897999999999996,
      25.579,
      64.56799999999998,
    );
    path_0.cubicTo(
      17.779,
      65.04799999999999,
      10.699,
      69.64799999999998,
      5.978999999999999,
      76.15799999999999,
    );
    path_0.cubicTo(
      0.7089999999999996,
      83.448,
      -1.641000000000001,
      93.09799999999998,
      1.2489999999999988,
      102.12799999999999,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4986721, size.height * 0.9983409),
      Offset(size.width * 0.4986721, size.height * 0.07239394),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(37.569, 126.498);
    path_1.cubicTo(
      94.849,
      136.40800000000002,
      116.199,
      131.447,
      124.96900000000001,
      119.257,
    );
    path_1.cubicTo(
      133.739,
      107.057,
      211.899,
      137.558,
      233.62900000000002,
      119.058,
    );
    path_1.cubicTo(
      240.92900000000003,
      112.84800000000001,
      244.30900000000003,
      99.688,
      243.11900000000003,
      84.62800000000001,
    );
    path_1.cubicTo(
      243.08900000000003,
      85.28800000000001,
      241.41900000000004,
      115.01800000000001,
      213.76900000000003,
      119.108,
    );
    path_1.cubicTo(
      185.80900000000003,
      123.248,
      147.31900000000002,
      109.968,
      133.03900000000004,
      113.108,
    );
    path_1.cubicTo(
      117.40900000000005,
      116.53800000000001,
      115.91900000000004,
      128.697,
      77.84900000000005,
      127.787,
    );
    path_1.cubicTo(
      39.779000000000046,
      126.87700000000001,
      12.839000000000041,
      116.028,
      4.449000000000041,
      105.418,
    );
    path_1.cubicTo(
      -3.93099999999996,
      94.808,
      5.9990000000000405,
      76.188,
      5.9990000000000405,
      76.188,
    );
    path_1.cubicTo(
      -5.57099999999996,
      92.08800000000001,
      -3.0709999999999598,
      119.468,
      37.56900000000004,
      126.498,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4986721, size.height * 0.9983409),
      Offset(size.width * 0.4986721, size.height * 0.5770909),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(235.209, 84.518);
    path_2.cubicTo(
      230.519,
      105.518,
      167.62900000000002,
      107.94800000000001,
      139.599,
      99.618,
    );
    path_2.cubicTo(
      111.56899999999996,
      91.28799999999998,
      110.14899999999999,
      96.35799999999999,
      115.579,
      102.82799999999999,
    );
    path_2.cubicTo(
      121.009,
      109.29799999999999,
      86.56899999999999,
      121.28799999999998,
      46.92899999999999,
      108.84799999999998,
    );
    path_2.cubicTo(
      7.298999999999985,
      96.40799999999999,
      14.448999999999991,
      72.338,
      43.41899999999999,
      68.20799999999998,
    );
    path_2.cubicTo(
      69.06899999999999,
      64.55799999999998,
      68.45899999999999,
      66.94799999999998,
      79.07899999999998,
      65.91799999999998,
    );
    path_2.cubicTo(
      89.68899999999998,
      64.88799999999998,
      90.94899999999998,
      56.90799999999998,
      79.06899999999997,
      56.20799999999998,
    );
    path_2.cubicTo(
      64.35899999999998,
      55.34799999999998,
      105.56899999999997,
      8.057999999999979,
      165.04899999999998,
      15.637999999999977,
    );
    path_2.cubicTo(
      224.52899999999997,
      23.217999999999975,
      239.01899999999998,
      67.45799999999997,
      235.20899999999997,
      84.51799999999997,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5229631, size.height * 0.8656667),
      Offset(size.width * 0.5229631, size.height * 0.1122803),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(232.669, 62.707);
    path_3.cubicTo(
      232.669,
      62.707,
      241.029,
      83.17699999999999,
      219.479,
      93.857,
    );
    path_3.cubicTo(
      197.93900000000002,
      104.537,
      171.149,
      105.107,
      145.419,
      98.957,
    );
    path_3.cubicTo(
      119.67900000000002,
      92.80699999999999,
      115.38900000000001,
      91.94699999999999,
      111.24900000000001,
      93.52699999999999,
    );
    path_3.cubicTo(
      107.099,
      95.09699999999998,
      117.30900000000001,
      104.42699999999999,
      101.85900000000001,
      109.30699999999999,
    );
    path_3.cubicTo(
      86.409,
      114.18699999999998,
      47.52900000000001,
      109.68699999999998,
      32.659000000000006,
      101.487,
    );
    path_3.cubicTo(
      17.78900000000001,
      93.28699999999999,
      19.609000000000005,
      85.00699999999999,
      19.609000000000005,
      85.00699999999999,
    );
    path_3.cubicTo(
      19.609000000000005,
      85.00699999999999,
      12.739000000000004,
      99.66699999999999,
      50.919000000000004,
      111.327,
    );
    path_3.cubicTo(
      89.099,
      122.98700000000001,
      111.469,
      112.477,
      116.189,
      108.547,
    );
    path_3.cubicTo(
      120.90899999999999,
      104.61699999999999,
      113.329,
      98.607,
      118.04899999999999,
      97.39699999999999,
    );
    path_3.cubicTo(
      122.76899999999999,
      96.17699999999999,
      158.159,
      108.83699999999999,
      194.759,
      105.97699999999999,
    );
    path_3.cubicTo(
      231.35899999999998,
      103.11699999999999,
      235.79899999999998,
      93.39699999999999,
      237.36899999999997,
      83.817,
    );
    path_3.cubicTo(
      238.92899999999997,
      74.217,
      232.66899999999998,
      62.706999999999994,
      232.66899999999998,
      62.706999999999994,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5260943, size.height * 0.8836591),
      Offset(size.width * 0.5260943, size.height * 0.4750227),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(86.37, 63.148);
    path_4.cubicTo(
      86.37,
      63.148,
      88.18,
      59.678000000000004,
      84.84,
      58.288000000000004,
    );
    path_4.cubicTo(81.5, 56.908, 79.17, 57.908, 76.83, 57.188);
    path_4.cubicTo(
      74.49,
      56.478,
      75.66,
      51.858000000000004,
      76.89999999999999,
      50.338,
    );
    path_4.cubicTo(
      76.89999999999999,
      50.338,
      75.72999999999999,
      53.518,
      78.35,
      54.378,
    );
    path_4.cubicTo(80.97, 55.238, 85.19999999999999, 54.708, 86.83, 56.898);
    path_4.cubicTo(89.37, 60.298, 86.37, 63.148, 86.37, 63.148);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3347459, size.height * 0.4784167),
      Offset(size.width * 0.3347459, size.height * 0.3814091),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(104.529, 87.578);
    path_5.cubicTo(
      108.939,
      92.128,
      116.539,
      108.33800000000001,
      78.789,
      108.718,
    );
    path_5.cubicTo(41.039, 109.098, 21.789, 87.768, 22.549, 80.708);
    path_5.cubicTo(23.319, 73.638, 70.59899999999999, 52.518, 104.529, 87.578);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(225.589, 76.887);
    path_6.cubicTo(233.989, 92.827, 192.609, 101.337, 142.849, 91.207);
    path_6.cubicTo(
      93.089,
      81.077,
      84.22899999999998,
      65.017,
      118.25899999999999,
      56.74699999999999,
    );
    path_6.cubicTo(
      152.289,
      48.47699999999999,
      93.08899999999998,
      54.81699999999999,
      82.57899999999998,
      51.14699999999999,
    );
    path_6.cubicTo(
      72.06899999999997,
      47.47699999999999,
      104.78899999999999,
      13.096999999999994,
      162.67899999999997,
      17.97699999999999,
    );
    path_6.cubicTo(
      220.55899999999997,
      22.84699999999999,
      238.54899999999998,
      65.25699999999999,
      225.58899999999997,
      76.88699999999999,
    );
    path_6.close();
    path_6.moveTo(95.85900000000001, 106.538);
    path_6.cubicTo(129.609, 92.608, 84.149, 74.368, 50.77900000000001, 82.208);
    path_6.cubicTo(
      17.409000000000013,
      90.038,
      51.25900000000001,
      117.71799999999999,
      95.85900000000001,
      106.538,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(66.54, 125.967);
    path_7.cubicTo(
      77.08000000000001,
      124.53699999999999,
      44.480000000000004,
      115.957,
      26.750000000000007,
      101.087,
    );
    path_7.cubicTo(
      9.02000000000001,
      86.21700000000001,
      21.60000000000001,
      75.37700000000001,
      24.890000000000008,
      72.367,
    );
    path_7.cubicTo(
      28.180000000000007,
      69.34700000000001,
      2.670000000000009,
      67.057,
      1.9800000000000075,
      94.367,
    );
    path_7.cubicTo(
      1.2900000000000076,
      121.677,
      66.54,
      125.96700000000001,
      66.54,
      125.96700000000001,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(223.919, 108.727);
    path_8.cubicTo(
      226.059,
      110.677,
      225.34900000000002,
      119.857,
      201.179,
      119.917,
    );
    path_8.cubicTo(
      177.019,
      119.977,
      156.269,
      110.787,
      136.68900000000002,
      112.667,
    );
    path_8.cubicTo(
      117.10900000000002,
      114.537,
      112.54900000000002,
      125.657,
      98.09900000000002,
      126.737,
    );
    path_8.cubicTo(
      83.64900000000002,
      127.827,
      67.43900000000002,
      120.39699999999999,
      66.53900000000002,
      119.687,
    );
    path_8.cubicTo(
      65.63900000000001,
      118.977,
      97.94900000000001,
      117.25699999999999,
      109.38900000000001,
      113.53699999999999,
    );
    path_8.cubicTo(
      120.82900000000001,
      109.817,
      111.959,
      99.94699999999999,
      119.53900000000002,
      98.30699999999999,
    );
    path_8.cubicTo(
      127.11900000000001,
      96.66699999999999,
      161.59900000000002,
      108.66699999999999,
      201.959,
      105.25699999999999,
    );
    path_8.cubicTo(
      242.31900000000002,
      101.847,
      223.919,
      108.72699999999999,
      223.919,
      108.72699999999999,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(189.319, 116.648);
    path_9.cubicTo(
      198.32899999999998,
      113.678,
      170.01899999999998,
      103.43799999999999,
      146.569,
      103.978,
    );
    path_9.cubicTo(
      123.11899999999999,
      104.52799999999999,
      152.48899999999998,
      118.46799999999999,
      189.319,
      116.648,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(1.249, 102.138);
    path_10.cubicTo(
      4.679,
      112.858,
      15.499,
      122.688,
      37.569,
      126.50800000000001,
    );
    path_10.cubicTo(
      94.82900000000001,
      136.418,
      116.18900000000001,
      131.458,
      124.959,
      119.26800000000001,
    );
    path_10.cubicTo(
      124.529,
      119.54800000000002,
      109.649,
      129.108,
      66.519,
      127.97800000000001,
    );
    path_10.cubicTo(
      22.749000000000002,
      126.828,
      1.2490000000000094,
      102.138,
      1.2490000000000094,
      102.138,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5121352, size.height * 0.8860455),
      Offset(size.width * 0.005118852, size.height * 0.8860455),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(157.699, 118.748);
    path_11.cubicTo(
      184.61900000000003,
      123.08800000000001,
      220.079,
      130.598,
      233.62900000000002,
      119.068,
    );
    path_11.cubicTo(
      239.03900000000002,
      114.458,
      242.299,
      106.038,
      243.12900000000002,
      95.838,
    );
    path_11.cubicTo(
      243.12900000000002,
      95.838,
      237.11900000000003,
      115.428,
      211.89900000000003,
      119.398,
    );
    path_11.cubicTo(
      187.51900000000003,
      123.238,
      159.51900000000003,
      119.02799999999999,
      157.699,
      118.74799999999999,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9964467, size.height * 0.8371818),
      Offset(size.width * 0.6463279, size.height * 0.8371818),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(49.48, 71.357);
    path_12.cubicTo(
      60.379999999999995,
      72.477,
      44.47,
      85.507,
      32.03999999999999,
      84.797,
    );
    path_12.cubicTo(
      19.609999999999992,
      84.077,
      25.749999999999993,
      68.917,
      49.47999999999999,
      71.357,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2177008, size.height * 0.5905682),
      Offset(size.width * 0.1055820, size.height * 0.5905682),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(138.559, 20.448);
    path_13.cubicTo(170.059, 21.508, 141.319, 49.728, 100.719, 50.338);
    path_13.cubicTo(
      60.11899999999999,
      50.948,
      106.67899999999999,
      19.378,
      138.559,
      20.448,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6227582, size.height * 0.2681061),
      Offset(size.width * 0.3478443, size.height * 0.2681061),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(184.549, 23.638);
    path_14.cubicTo(
      195.75900000000001,
      29.618000000000002,
      168.529,
      31.348000000000003,
      158.62900000000002,
      26.498,
    );
    path_14.cubicTo(
      148.71900000000002,
      21.668,
      168.00900000000001,
      14.818000000000001,
      184.54900000000004,
      23.638,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7672582, size.height * 0.1844394),
      Offset(size.width * 0.6390287, size.height * 0.1844394),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(52.48, 75.638);
    path_15.cubicTo(
      53.629999999999995,
      72.138,
      44.54,
      70.33800000000001,
      34.26,
      74.358,
    );
    path_15.cubicTo(
      23.979999999999997,
      78.378,
      26.419999999999998,
      82.418,
      26.419999999999998,
      82.418,
    );
    path_15.cubicTo(
      26.419999999999998,
      82.418,
      27.619999999999997,
      86.39800000000001,
      39.449999999999996,
      83.84800000000001,
    );
    path_15.cubicTo(
      51.269999999999996,
      81.28800000000001,
      52.48,
      75.638,
      52.48,
      75.638,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor72.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(151.829, 28.577);
    path_16.cubicTo(
      151.829,
      28.577,
      150.639,
      15.877000000000002,
      118.25900000000001,
      24.987000000000002,
    );
    path_16.cubicTo(
      85.87900000000002,
      34.097,
      86.60900000000001,
      47.42700000000001,
      86.60900000000001,
      47.42700000000001,
    );
    path_16.cubicTo(
      86.60900000000001,
      47.42700000000001,
      93.07900000000001,
      55.617000000000004,
      121.679,
      47.617000000000004,
    );
    path_16.cubicTo(
      150.279,
      39.617000000000004,
      151.829,
      28.577000000000005,
      151.829,
      28.577000000000005,
    );
    path_16.close();
    path_16.moveTo(186.169, 27.598000000000003);
    path_16.cubicTo(
      186.169,
      27.598000000000003,
      186.929,
      23.068,
      173.109,
      20.788000000000004,
    );
    path_16.cubicTo(
      159.28900000000002,
      18.498000000000005,
      155.799,
      23.878000000000004,
      156.06900000000002,
      24.348000000000003,
    );
    path_16.cubicTo(
      156.33900000000003,
      24.818,
      156.56900000000002,
      28.028000000000002,
      169.34900000000002,
      29.318,
    );
    path_16.cubicTo(
      182.11900000000003,
      30.608,
      186.169,
      27.598000000000003,
      186.169,
      27.598000000000003,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor19.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(38.55, 120.608);
    path_17.cubicTo(
      41.599999999999994,
      120.128,
      42.97,
      116.028,
      35.29,
      112.168,
    );
    path_17.cubicTo(27.61, 108.308, 23.77, 113.438, 23.25, 115.028);
    path_17.cubicTo(22.72, 116.628, 30.32, 121.89800000000001, 38.55, 120.608);
    path_17.close();
    path_17.moveTo(42.068999999999996, 113.608);
    path_17.cubicTo(
      42.068999999999996,
      114.94800000000001,
      40.538999999999994,
      115.468,
      39.208999999999996,
      113.608,
    );
    path_17.cubicTo(
      37.879,
      111.748,
      42.068999999999996,
      112.408,
      42.068999999999996,
      113.608,
    );
    path_17.close();
    path_17.moveTo(16.459999999999994, 108.73700000000001);
    path_17.cubicTo(
      19.939999999999994,
      106.947,
      17.509999999999994,
      102.037,
      12.219999999999994,
      102.13700000000001,
    );
    path_17.cubicTo(
      6.9299999999999935,
      102.23700000000001,
      7.6399999999999935,
      105.76700000000001,
      8.259999999999994,
      106.85700000000001,
    );
    path_17.cubicTo(
      8.879999999999994,
      107.95700000000001,
      13.639999999999993,
      110.177,
      16.459999999999994,
      108.73700000000001,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(44.67, 121.678);
    path_18.cubicTo(
      41.95,
      119.228,
      40.77,
      114.738,
      50.480000000000004,
      114.268,
    );
    path_18.cubicTo(60.2, 113.798, 64.59, 119.488, 64.59, 122.918);
    path_18.cubicTo(64.59, 126.358, 48.39, 125.028, 44.67, 121.67800000000001);
    path_18.close();
    path_18.moveTo(83.67, 117.697);
    path_18.cubicTo(89.22, 119.197, 84.61, 121.677, 77.56, 123.017);
    path_18.cubicTo(70.51, 124.347, 68.69, 117.187, 68.6, 116.957);
    path_18.cubicTo(
      68.5,
      116.72699999999999,
      78.44,
      116.28699999999999,
      83.66999999999999,
      117.69699999999999,
    );
    path_18.close();
    path_18.moveTo(108.539, 124.22800000000001);
    path_18.cubicTo(
      108.949,
      121.76800000000001,
      104.099,
      121.468,
      99.669,
      121.608,
    );
    path_18.cubicTo(
      95.239,
      121.748,
      95.37899999999999,
      126.498,
      96.73899999999999,
      126.808,
    );
    path_18.cubicTo(
      98.09899999999999,
      127.11800000000001,
      108.39899999999999,
      125.08800000000001,
      108.53899999999999,
      124.22800000000001,
    );
    path_18.close();
    path_18.moveTo(152.859, 106.36800000000001);
    path_18.cubicTo(
      157.769,
      109.44800000000001,
      150.089,
      115.718,
      138.179,
      110.76800000000001,
    );
    path_18.cubicTo(
      126.269,
      105.81800000000001,
      129.559,
      103.03800000000001,
      130.989,
      102.13800000000002,
    );
    path_18.cubicTo(
      132.409,
      101.23800000000001,
      140.989,
      98.91800000000002,
      152.859,
      106.36800000000002,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(63.11, 119.067);
    path_19.cubicTo(63.11, 119.067, 64.4, 121.39699999999999, 62.61, 122.717);
    path_19.cubicTo(60.82, 124.047, 52.82, 124.397, 47.45, 122.257);
    path_19.cubicTo(
      42.09,
      120.117,
      43.040000000000006,
      116.95700000000001,
      43.040000000000006,
      116.95700000000001,
    );
    path_19.cubicTo(
      43.040000000000006,
      116.95700000000001,
      41.730000000000004,
      118.35700000000001,
      43.27,
      121.397,
    );
    path_19.cubicTo(
      44.81,
      124.43700000000001,
      51.03,
      125.577,
      58.89,
      125.20700000000001,
    );
    path_19.cubicTo(
      66.75,
      124.82700000000001,
      65.75,
      122.45700000000001,
      63.11,
      119.06700000000001,
    );
    path_19.close();
    path_19.moveTo(40.64, 116.707);
    path_19.cubicTo(
      40.64,
      116.707,
      41.76,
      122.097,
      32.730000000000004,
      120.017,
    );
    path_19.cubicTo(
      23.700000000000003,
      117.937,
      23.750000000000004,
      114.957,
      24.250000000000004,
      113.39699999999999,
    );
    path_19.cubicTo(
      24.250000000000004,
      113.39699999999999,
      22.770000000000003,
      114.44699999999999,
      22.940000000000005,
      115.78699999999999,
    );
    path_19.cubicTo(
      23.110000000000007,
      117.127,
      27.200000000000003,
      120.707,
      34.38,
      121.58699999999999,
    );
    path_19.cubicTo(
      41.550000000000004,
      122.46699999999998,
      42.27,
      119.71699999999998,
      40.64,
      116.707,
    );
    path_19.close();
    path_19.moveTo(41.910000000000004, 113.208);
    path_19.cubicTo(42.07, 113.608, 41.74, 114.798, 40.31, 114.198);
    path_19.cubicTo(38.88, 113.598, 39.13, 112.628, 39.13, 112.628);
    path_19.cubicTo(
      39.13,
      112.628,
      38.830000000000005,
      112.708,
      38.800000000000004,
      113.188,
    );
    path_19.cubicTo(
      38.760000000000005,
      113.668,
      39.68000000000001,
      114.928,
      41.02,
      115.098,
    );
    path_19.cubicTo(42.35, 115.258, 42.5, 114.048, 41.910000000000004, 113.208);
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(130.879, 108.997);
    path_20.cubicTo(
      130.879,
      111.407,
      128.119,
      112.357,
      125.70899999999999,
      108.997,
    );
    path_20.cubicTo(
      123.30899999999998,
      105.637,
      130.879,
      106.837,
      130.879,
      108.997,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(130.589, 108.277);
    path_21.cubicTo(130.879, 108.997, 130.279, 111.147, 127.699, 110.077);
    path_21.cubicTo(125.119, 108.997, 125.559, 107.247, 125.559, 107.247);
    path_21.cubicTo(125.559, 107.247, 125.029, 107.387, 124.959, 108.257);
    path_21.cubicTo(124.899, 109.117, 126.549, 111.397, 128.959, 111.697);
    path_21.cubicTo(
      131.379,
      111.98700000000001,
      131.649,
      109.797,
      130.589,
      108.277,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(216.409, 110.197);
    path_22.cubicTo(216.409, 112.607, 213.649, 113.557, 211.239, 110.197);
    path_22.cubicTo(208.829, 106.837, 216.409, 108.037, 216.409, 110.197);
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(216.119, 109.477);
    path_23.cubicTo(
      216.409,
      110.197,
      215.809,
      112.34700000000001,
      213.229,
      111.277,
    );
    path_23.cubicTo(
      210.649,
      110.197,
      211.08900000000003,
      108.447,
      211.08900000000003,
      108.447,
    );
    path_23.cubicTo(
      211.08900000000003,
      108.447,
      210.55900000000003,
      108.587,
      210.48900000000003,
      109.45700000000001,
    );
    path_23.cubicTo(
      210.42900000000003,
      110.31700000000001,
      212.07900000000004,
      112.59700000000001,
      214.48900000000003,
      112.897,
    );
    path_23.cubicTo(
      216.89900000000003,
      113.18700000000001,
      217.17900000000003,
      110.997,
      216.11900000000003,
      109.477,
    );
    path_23.close();
    path_23.moveTo(18, 105.668);
    path_23.cubicTo(18, 105.668, 17.45, 109.34800000000001, 13.27, 108.718);
    path_23.cubicTo(
      9.09,
      108.098,
      7.529999999999999,
      106.018,
      8.149999999999999,
      103.83800000000001,
    );
    path_23.cubicTo(
      8.149999999999999,
      103.83800000000001,
      6.829999999999998,
      105.498,
      8.019999999999998,
      107.328,
    );
    path_23.cubicTo(
      9.209999999999997,
      109.158,
      13.519999999999998,
      110.278,
      16.519999999999996,
      109.358,
    );
    path_23.cubicTo(
      19.529999999999994,
      108.438,
      17.999999999999996,
      105.668,
      17.999999999999996,
      105.668,
    );
    path_23.close();
    path_23.moveTo(84.86, 118.09800000000001);
    path_23.cubicTo(
      84.86,
      118.09800000000001,
      86.12,
      121.42800000000001,
      79.33,
      122.24800000000002,
    );
    path_23.cubicTo(
      72.53999999999999,
      123.06800000000001,
      69.22,
      118.57800000000002,
      69.22,
      118.57800000000002,
    );
    path_23.cubicTo(
      69.22,
      118.57800000000002,
      69.67999999999999,
      122.86800000000002,
      75.92999999999999,
      123.46800000000002,
    );
    path_23.cubicTo(
      82.19,
      124.06800000000001,
      86.41999999999999,
      120.02800000000002,
      86.32,
      119.43800000000002,
    );
    path_23.cubicTo(
      86.22999999999999,
      118.84800000000001,
      84.86,
      118.09800000000001,
      84.86,
      118.09800000000001,
    );
    path_23.close();
    path_23.moveTo(108.279, 123.08800000000001);
    path_23.cubicTo(
      108.279,
      123.08800000000001,
      107.729,
      124.86800000000001,
      101.76899999999999,
      125.84800000000001,
    );
    path_23.cubicTo(
      95.809,
      126.82800000000002,
      95.92899999999999,
      125.47800000000001,
      95.92899999999999,
      125.47800000000001,
    );
    path_23.cubicTo(
      95.92899999999999,
      125.47800000000001,
      95.54899999999999,
      126.778,
      96.719,
      127.25800000000001,
    );
    path_23.cubicTo(
      97.889,
      127.73800000000001,
      107.429,
      125.43800000000002,
      108.56899999999999,
      124.888,
    );
    path_23.cubicTo(
      109.69899999999998,
      124.328,
      108.27899999999998,
      123.08800000000001,
      108.27899999999998,
      123.08800000000001,
    );
    path_23.close();
    path_23.moveTo(154.179, 107.778);
    path_23.cubicTo(
      154.179,
      107.778,
      154.819,
      111.81800000000001,
      144.919,
      110.888,
    );
    path_23.cubicTo(
      135.019,
      109.958,
      130.739,
      105.47800000000001,
      130.40900000000002,
      104.168,
    );
    path_23.cubicTo(
      130.079,
      102.858,
      131.71900000000002,
      101.798,
      131.71900000000002,
      101.798,
    );
    path_23.cubicTo(
      131.71900000000002,
      101.798,
      130.08900000000003,
      102.018,
      129.01900000000003,
      104.278,
    );
    path_23.cubicTo(
      127.94900000000004,
      106.528,
      132.84900000000005,
      110.92800000000001,
      144.10900000000004,
      112.908,
    );
    path_23.cubicTo(
      155.35900000000004,
      114.888,
      156.28900000000004,
      111.358,
      154.17900000000003,
      107.778,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(18.39, 74.198);
    path_24.cubicTo(20.01, 73.988, 19.44, 81.488, 14.8, 87.57799999999999);
    path_24.cubicTo(
      10.16,
      93.65799999999999,
      2.5500000000000007,
      94.37799999999999,
      2.5500000000000007,
      94.37799999999999,
    );
    path_24.cubicTo(
      2.5500000000000007,
      94.37799999999999,
      -4.829999999999999,
      77.20799999999998,
      18.39,
      74.19799999999998,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(236.499, 100.188);
    path_25.cubicTo(236.499, 100.188, 230.069, 106.637, 222.629, 110.887);
    path_25.cubicTo(
      215.19899999999998,
      115.127,
      203.399,
      114.257,
      194.749,
      112.397,
    );
    path_25.cubicTo(
      186.69899999999998,
      110.677,
      192.459,
      110.497,
      178.44899999999998,
      109.277,
    );
    path_25.cubicTo(
      164.439,
      108.057,
      158.42899999999997,
      107.787,
      158.42899999999997,
      107.787,
    );
    path_25.cubicTo(
      158.42899999999997,
      107.787,
      182.58899999999997,
      109.857,
      190.01899999999998,
      112.337,
    );
    path_25.cubicTo(
      193.39899999999997,
      113.467,
      202.95899999999997,
      118.437,
      214.80899999999997,
      116.637,
    );
    path_25.cubicTo(
      226.66899999999998,
      114.837,
      231.27899999999997,
      109.747,
      231.05899999999997,
      108.007,
    );
    path_25.cubicTo(
      230.84899999999996,
      106.277,
      236.49899999999997,
      100.188,
      236.49899999999997,
      100.188,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8092910, size.height * 0.8866136),
      Offset(size.width * 0.8092910, size.height * 0.7589924),
      [
        GameColors.islandPainterColor43.withValues(alpha: 1),
        GameColors.islandPainterColor46.withValues(alpha: 1),
        GameColors.islandPainterColor53.withValues(alpha: 1),
        GameColors.islandPainterColor57.withValues(alpha: 1),
        GameColors.islandPainterColor73.withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(133.469, 45.288);
    path_26.cubicTo(
      133.469,
      46.918,
      138.19899999999998,
      47.668,
      146.659,
      47.717999999999996,
    );
    path_26.lineTo(178.04899999999998, 48.058);
    path_26.cubicTo(
      178.04899999999998,
      48.058,
      183.08899999999997,
      41.248,
      179.659,
      36.998,
    );
    path_26.cubicTo(
      176.349,
      32.878,
      168.969,
      35.327999999999996,
      168.509,
      35.488,
    );
    path_26.cubicTo(
      169.879,
      34.478,
      183.259,
      32.808,
      180.61899999999997,
      26.448,
    );
    path_26.cubicTo(
      177.96899999999997,
      20.068,
      168.11899999999997,
      22.918,
      168.11899999999997,
      22.918,
    );
    path_26.cubicTo(
      168.11899999999997,
      22.918,
      180.13899999999998,
      10.097999999999999,
      166.34899999999996,
      1.9979999999999976,
    );
    path_26.cubicTo(
      165.45899999999997,
      1.4779999999999975,
      164.59899999999996,
      1.0679999999999974,
      163.77899999999997,
      0.7579999999999976,
    );
    path_26.lineTo(163.76899999999998, 0.7579999999999976);
    path_26.cubicTo(
      151.849,
      -3.7120000000000024,
      146.99899999999997,
      13.007999999999997,
      150.63899999999998,
      14.247999999999998,
    );
    path_26.cubicTo(
      151.22899999999998,
      14.447999999999997,
      151.82899999999998,
      14.717999999999998,
      152.39899999999997,
      15.027999999999997,
    );
    path_26.lineTo(152.41899999999998, 15.037999999999997);
    path_26.cubicTo(
      155.51899999999998,
      16.727999999999998,
      158.16899999999998,
      19.667999999999996,
      158.33899999999997,
      19.847999999999995,
    );
    path_26.cubicTo(
      150.09899999999996,
      13.117999999999995,
      147.01899999999998,
      28.197999999999993,
      147.01899999999998,
      28.197999999999993,
    );
    path_26.cubicTo(
      147.01899999999998,
      28.197999999999993,
      142.82899999999998,
      25.217999999999993,
      138.46899999999997,
      32.06799999999999,
    );
    path_26.cubicTo(
      134.12899999999996,
      38.92799999999999,
      138.88899999999995,
      44.92799999999999,
      138.88899999999995,
      44.92799999999999,
    );
    path_26.cubicTo(
      138.88899999999995,
      44.92799999999999,
      135.06899999999996,
      44.02799999999999,
      133.83899999999994,
      44.69799999999999,
    );
    path_26.cubicTo(
      133.60899999999995,
      44.837999999999994,
      133.46899999999994,
      45.02799999999999,
      133.46899999999994,
      45.288,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6475533, size.height * 0.3735530),
      Offset(size.width * 0.6350779, size.height * 0.2356061),
      [
        GameColors.islandPainterColor2.withValues(alpha: 1),
        GameColors.islandPainterColor4.withValues(alpha: 1),
        GameColors.islandPainterColor7.withValues(alpha: 1),
      ],
      [0, 0.42, 1],
    );
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(133.469, 45.288);
    path_27.cubicTo(
      133.469,
      46.918,
      138.19899999999998,
      47.668,
      146.659,
      47.717999999999996,
    );
    path_27.lineTo(178.04899999999998, 48.058);
    path_27.cubicTo(
      178.04899999999998,
      48.058,
      183.08899999999997,
      41.248,
      179.659,
      36.998,
    );
    path_27.cubicTo(
      176.349,
      32.878,
      168.969,
      35.327999999999996,
      168.509,
      35.488,
    );
    path_27.cubicTo(
      169.879,
      34.478,
      183.259,
      32.808,
      180.61899999999997,
      26.448,
    );
    path_27.cubicTo(
      177.96899999999997,
      20.068,
      168.11899999999997,
      22.918,
      168.11899999999997,
      22.918,
    );
    path_27.cubicTo(
      168.11899999999997,
      22.918,
      180.13899999999998,
      10.097999999999999,
      166.34899999999996,
      1.9979999999999976,
    );
    path_27.cubicTo(
      165.45899999999997,
      1.4779999999999975,
      164.59899999999996,
      1.0679999999999974,
      163.77899999999997,
      0.7579999999999976,
    );
    path_27.cubicTo(
      164.44899999999996,
      1.1179999999999977,
      172.45899999999997,
      3.6179999999999977,
      171.11899999999997,
      11.517999999999997,
    );
    path_27.cubicTo(
      169.01899999999998,
      23.867999999999995,
      153.07899999999998,
      15.247999999999998,
      152.42899999999997,
      15.027999999999997,
    );
    path_27.cubicTo(
      155.52899999999997,
      16.717999999999996,
      158.17899999999997,
      19.657999999999998,
      158.34899999999996,
      19.837999999999997,
    );
    path_27.lineTo(158.35899999999995, 19.848);
    path_27.cubicTo(
      158.35899999999995,
      19.848,
      163.58899999999994,
      22.458,
      164.76899999999995,
      28.808,
    );
    path_27.cubicTo(
      166.32899999999995,
      37.248,
      153.72899999999996,
      34.498,
      153.72899999999996,
      34.498,
    );
    path_27.cubicTo(
      153.72899999999996,
      34.498,
      157.81899999999996,
      35.687999999999995,
      161.73899999999995,
      36.727999999999994,
    );
    path_27.cubicTo(
      167.50899999999996,
      38.257999999999996,
      171.42899999999995,
      44.16799999999999,
      161.54899999999995,
      46.577999999999996,
    );
    path_27.cubicTo(
      152.59899999999996,
      48.767999999999994,
      136.01899999999995,
      46.888,
      133.85899999999995,
      44.69799999999999,
    );
    path_27.cubicTo(
      133.60899999999995,
      44.837999999999994,
      133.46899999999997,
      45.02799999999999,
      133.46899999999997,
      45.288,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6475533, size.height * 0.3735530),
      Offset(size.width * 0.6353361, size.height * 0.01003788),
      [
        GameColors.islandPainterColor28.withValues(alpha: 1),
        GameColors.islandPainterColor37.withValues(alpha: 1),
        GameColors.islandPainterColor45.withValues(alpha: 1),
        GameColors.islandPainterColor54.withValues(alpha: 1),
        GameColors.islandPainterColor59.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 1),
      ],
      [0, 0.265, 0.522, 0.738, 0.904, 1],
    );
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(154.159, 44.597);
    path_28.cubicTo(
      156.509,
      42.597,
      151.91899999999998,
      28.437,
      144.959,
      27.917,
    );
    path_28.cubicTo(
      137.999,
      27.397000000000002,
      137.03900000000002,
      39.577,
      139.639,
      42.977000000000004,
    );
    path_28.cubicTo(
      142.229,
      46.367000000000004,
      153.779,
      44.917,
      154.15900000000002,
      44.597,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(162.269, 34.288);
    path_29.cubicTo(
      168.53900000000002,
      28.297999999999995,
      160.779,
      19.778,
      155.169,
      18.598,
    );
    path_29.cubicTo(
      149.559,
      17.407999999999998,
      147.05900000000003,
      24.838,
      150.459,
      30.398,
    );
    path_29.cubicTo(153.859, 35.958, 162.269, 34.288, 162.269, 34.288);
    path_29.close();
    path_29.moveTo(167.31900000000002, 14.407999999999998);
    path_29.cubicTo(
      172.34900000000002,
      11.707999999999998,
      170.06900000000002,
      1.027999999999997,
      160.25900000000001,
      0.5179999999999971,
    );
    path_29.cubicTo(
      150.449,
      0.00799999999999712,
      148.709,
      9.637999999999996,
      152.62900000000002,
      13.237999999999998,
    );
    path_29.cubicTo(
      156.55900000000003,
      16.837999999999997,
      167.31900000000002,
      14.407999999999998,
      167.31900000000002,
      14.407999999999998,
    );
    path_29.close();
    path_29.moveTo(175.019, 23.278);
    path_29.cubicTo(
      179.56900000000002,
      24.868,
      174.979,
      33.178,
      168.479,
      33.488,
    );
    path_29.cubicTo(
      165.56900000000002,
      33.628,
      165.43900000000002,
      26.247999999999998,
      165.50900000000001,
      25.528,
    );
    path_29.cubicTo(
      165.579,
      24.817999999999998,
      168.58900000000003,
      21.028,
      175.019,
      23.278,
    );
    path_29.close();
    path_29.moveTo(148.37900000000002, 29.308);
    path_29.cubicTo(
      150.50900000000001,
      31.858,
      148.479,
      36.647999999999996,
      143.70900000000003,
      37.038,
    );
    path_29.cubicTo(
      138.93900000000002,
      37.418,
      140.58900000000003,
      30.417999999999996,
      142.29900000000004,
      28.837999999999997,
    );
    path_29.cubicTo(
      143.98900000000003,
      27.267999999999997,
      147.55900000000003,
      28.327999999999996,
      148.37900000000005,
      29.307999999999996,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(157.179, 20.148);
    path_30.cubicTo(
      160.28900000000002,
      21.387999999999998,
      159.239,
      28.238,
      153.229,
      29.088,
    );
    path_30.cubicTo(
      147.229,
      29.938000000000002,
      149.979,
      17.268,
      157.179,
      20.148000000000003,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(224.649, 110.237);
    path_31.cubicTo(
      224.649,
      110.237,
      222.059,
      116.08699999999999,
      210.75900000000001,
      116.64699999999999,
    );
    path_31.cubicTo(
      199.459,
      117.207,
      191.019,
      112.49699999999999,
      191.019,
      112.49699999999999,
    );
    path_31.cubicTo(
      191.019,
      112.49699999999999,
      198.029,
      114.63699999999999,
      206.799,
      113.96699999999998,
    );
    path_31.cubicTo(
      215.579,
      113.29699999999998,
      224.649,
      110.23699999999998,
      224.649,
      110.23699999999998,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8518115, size.height * 0.8840152),
      Offset(size.width * 0.8518115, size.height * 0.8351364),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(229.579, 71.498);
    path_32.cubicTo(
      228.93900000000002,
      78.178,
      207.619,
      60.05800000000001,
      203.03900000000002,
      45.048,
    );
    path_32.cubicTo(
      198.459,
      30.038000000000004,
      198.639,
      27.548000000000002,
      198.639,
      27.548000000000002,
    );
    path_32.cubicTo(
      198.639,
      27.548000000000002,
      232.669,
      39.188,
      229.579,
      71.498,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(162.289, 53.447);
    path_33.cubicTo(162.289, 53.447, 179.839, 60.107, 194.709, 60.387);
    path_33.cubicTo(
      209.579,
      60.677,
      219.499,
      53.367000000000004,
      219.869,
      52.667,
    );
    path_33.cubicTo(221.089, 50.377, 210.379, 44.687, 201.889, 43.537);
    path_33.cubicTo(
      184.839,
      41.247,
      162.28900000000002,
      53.447,
      162.28900000000002,
      53.447,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(201.629, 87.357);
    path_34.cubicTo(
      211.73899999999998,
      79.877,
      168.42899999999997,
      74.237,
      153.129,
      82.507,
    );
    path_34.cubicTo(137.839, 90.777, 184.219, 100.247, 201.629, 87.357);
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = GameColors.islandPainterColor26.withValues(alpha: 1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(206.429, 74.497);
    path_35.cubicTo(
      212.889,
      72.537,
      214.03900000000002,
      59.227000000000004,
      191.359,
      60.467,
    );
    path_35.cubicTo(
      168.679,
      61.717,
      171.00900000000001,
      85.267,
      206.429,
      74.497,
    );
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = GameColors.islandPainterColor26.withValues(alpha: 1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(158.889, 46.357);
    path_36.cubicTo(
      166.03900000000002,
      48.227,
      166.229,
      51.317,
      155.429,
      51.827,
    );
    path_36.cubicTo(
      144.629,
      52.336999999999996,
      142.289,
      48.667,
      142.289,
      48.667,
    );
    path_36.cubicTo(
      142.289,
      48.667,
      152.339,
      44.647000000000006,
      158.88899999999998,
      46.357,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(209.379, 51.118);
    path_37.cubicTo(
      211.41899999999998,
      49.588,
      210.569,
      43.898,
      209.379,
      41.188,
    );
    path_37.cubicTo(
      208.189,
      38.468,
      193.459,
      32.898,
      184.879,
      33.608000000000004,
    );
    path_37.cubicTo(
      176.29899999999998,
      34.318000000000005,
      161.719,
      49.188,
      160.719,
      51.908,
    );
    path_37.cubicTo(159.719, 54.628, 179.159, 56.908, 191.029, 57.338);
    path_37.cubicTo(202.899, 57.768, 207.569, 52.478, 209.379, 51.118);
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7608525, size.height * 0.4345909),
      Offset(size.width * 0.7608525, size.height * 0.2541212),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(209.379, 41.188);
    path_38.cubicTo(
      208.539,
      40.218,
      197.179,
      46.958,
      194.69899999999998,
      49.628,
    );
    path_38.cubicTo(
      192.219,
      52.298,
      184.67899999999997,
      56.988,
      184.67899999999997,
      56.988,
    );
    path_38.cubicTo(
      184.67899999999997,
      56.988,
      191.96899999999997,
      57.918,
      197.02899999999997,
      57.038,
    );
    path_38.cubicTo(
      202.08899999999997,
      56.157999999999994,
      208.94899999999996,
      52.238,
      210.28899999999996,
      50.358,
    );
    path_38.cubicTo(
      211.61899999999997,
      48.477999999999994,
      209.37899999999996,
      41.187999999999995,
      209.37899999999996,
      41.187999999999995,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(207.089, 40.087);
    path_39.cubicTo(
      207.309,
      41.657000000000004,
      198.329,
      47.237,
      186.16899999999998,
      48.377,
    );
    path_39.cubicTo(
      174.009,
      49.517,
      167.99899999999997,
      46.847,
      167.719,
      46.657000000000004,
    );
    path_39.cubicTo(
      167.429,
      46.467000000000006,
      175.149,
      34.647000000000006,
      184.879,
      33.597,
    );
    path_39.cubicTo(
      194.60899999999998,
      32.547000000000004,
      206.879,
      38.547000000000004,
      207.089,
      40.087,
    );
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(201.329, 44.367);
    path_40.cubicTo(
      201.329,
      44.367,
      194.419,
      49.416999999999994,
      192.699,
      50.227,
    );
    path_40.cubicTo(190.979, 51.047, 185.169, 49.247, 185.169, 49.247);
    path_40.lineTo(201.329, 44.367);
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(206.319, 41.308);
    path_41.cubicTo(
      206.319,
      41.308,
      201.969,
      43.698,
      199.82899999999998,
      44.368,
    );
    path_41.cubicTo(
      197.689,
      45.038000000000004,
      188.02899999999997,
      47.778000000000006,
      184.099,
      48.658,
    );
    path_41.cubicTo(
      180.16899999999998,
      49.538000000000004,
      171.97899999999998,
      47.918,
      171.97899999999998,
      47.918,
    );
    path_41.cubicTo(
      171.97899999999998,
      47.918,
      180.98899999999998,
      49.908,
      184.809,
      49.248,
    );
    path_41.cubicTo(
      188.629,
      48.577999999999996,
      196.41899999999998,
      44.858,
      200.319,
      45.448,
    );
    path_41.cubicTo(200.319, 45.458, 203.689, 43.648, 206.319, 41.308);
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(195.679, 41.688);
    path_42.cubicTo(
      197.449,
      42.958000000000006,
      194.109,
      47.908,
      183.379,
      46.478,
    );
    path_42.cubicTo(172.659, 45.048, 194.179, 40.618, 195.679, 41.688);
    path_42.close();
    path_42.moveTo(204.75900000000001, 44.687000000000005);
    path_42.cubicTo(
      208.83900000000003,
      44.597,
      204.75900000000001,
      51.977000000000004,
      201.68900000000002,
      53.977000000000004,
    );
    path_42.cubicTo(
      198.61900000000003,
      55.977000000000004,
      192.39900000000003,
      56.547000000000004,
      192.39900000000003,
      56.547000000000004,
    );
    path_42.cubicTo(
      192.39900000000003,
      56.547000000000004,
      195.24900000000002,
      44.897000000000006,
      204.75900000000001,
      44.687000000000005,
    );
    path_42.close();
    path_42.moveTo(179.30900000000003, 42.617000000000004);
    path_42.cubicTo(
      180.21900000000002,
      43.027,
      175.51900000000003,
      44.977000000000004,
      173.65900000000002,
      44.687000000000005,
    );
    path_42.cubicTo(
      171.799,
      44.397000000000006,
      176.949,
      41.537000000000006,
      179.30900000000003,
      42.617000000000004,
    );
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(158.719, 48.667);
    path_43.cubicTo(
      159.369,
      47.567,
      158.38899999999998,
      43.517,
      151.049,
      42.617000000000004,
    );
    path_43.cubicTo(
      143.709,
      41.70700000000001,
      141.56900000000002,
      48.007000000000005,
      141.56900000000002,
      48.267,
    );
    path_43.cubicTo(
      141.56900000000002,
      48.527,
      146.959,
      50.587,
      150.90900000000002,
      50.707,
    );
    path_43.cubicTo(
      154.859,
      50.807,
      158.23900000000003,
      49.467,
      158.71900000000002,
      48.667,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6156762, size.height * 0.3841364),
      Offset(size.width * 0.6156762, size.height * 0.3221591),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(158.719, 48.667);
    path_44.cubicTo(
      158.879,
      48.117000000000004,
      158.149,
      45.527,
      156.579,
      45.187000000000005,
    );
    path_44.cubicTo(
      155.00900000000001,
      44.837,
      147.03900000000002,
      47.297000000000004,
      145.929,
      48.06700000000001,
    );
    path_44.cubicTo(
      144.819,
      48.83700000000001,
      145.019,
      50.27700000000001,
      150.909,
      50.70700000000001,
    );
    path_44.cubicTo(
      156.789,
      51.117000000000004,
      158.719,
      48.66700000000001,
      158.719,
      48.66700000000001,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(156.069, 44.308);
    path_45.cubicTo(
      156.569,
      44.428,
      150.79899999999998,
      46.808,
      147.969,
      47.188,
    );
    path_45.cubicTo(
      145.129,
      47.568000000000005,
      142.739,
      46.648,
      142.60899999999998,
      46.498000000000005,
    );
    path_45.cubicTo(
      142.47899999999998,
      46.348000000000006,
      144.539,
      43.168000000000006,
      148.58899999999997,
      42.578,
    );
    path_45.cubicTo(
      152.63899999999998,
      41.998000000000005,
      156.06899999999996,
      44.308,
      156.06899999999996,
      44.308,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(153.349, 45.617);
    path_46.cubicTo(
      153.349,
      45.617,
      150.909,
      46.986999999999995,
      149.279,
      47.416999999999994,
    );
    path_46.cubicTo(
      147.649,
      47.846999999999994,
      146.239,
      47.276999999999994,
      146.239,
      47.276999999999994,
    );
    path_46.cubicTo(
      146.239,
      47.276999999999994,
      149.749,
      45.92699999999999,
      153.34900000000002,
      45.617,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(156.069, 44.308);
    path_47.cubicTo(
      156.069,
      44.308,
      154.23899999999998,
      45.208,
      153.51899999999998,
      45.348,
    );
    path_47.cubicTo(
      152.80899999999997,
      45.498,
      149.349,
      45.858,
      147.70899999999997,
      46.378,
    );
    path_47.cubicTo(146.069, 46.898, 144.039, 46.988, 144.039, 46.988);
    path_47.cubicTo(
      144.039,
      46.988,
      146.10899999999998,
      47.418,
      146.369,
      47.278,
    );
    path_47.cubicTo(146.639, 47.138, 148.789, 46.348, 150.519, 46.038);
    path_47.cubicTo(152.249, 45.738, 153.459, 45.568, 153.459, 45.568);
    path_47.cubicTo(
      153.459,
      45.568,
      155.549,
      44.998,
      156.06900000000002,
      44.308,
    );
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(102.429, 54.638);
    path_48.cubicTo(
      110.60900000000001,
      53.077999999999996,
      102.059,
      64.05799999999999,
      95.85900000000001,
      64.55799999999999,
    );
    path_48.cubicTo(
      89.65900000000002,
      65.05799999999999,
      89.85900000000001,
      57.02799999999999,
      102.429,
      54.63799999999999,
    );
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = GameColors.islandPainterColor26.withValues(alpha: 1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(67.74, 56.748);
    path_49.cubicTo(76.85, 56.388, 80.94, 64.098, 66.52, 64.578);
    path_49.cubicTo(
      52.099999999999994,
      65.058,
      59.599999999999994,
      57.068000000000005,
      67.74,
      56.748000000000005,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(99.29, 101.998);
    path_50.cubicTo(99.34, 98.638, 94.26, 96.108, 90.62, 100.53800000000001);
    path_50.cubicTo(
      86.99000000000001,
      104.97800000000001,
      99.22,
      106.86800000000001,
      99.29,
      101.998,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(98.93, 100.458);
    path_51.cubicTo(
      98.93,
      100.458,
      99.60000000000001,
      103.618,
      96.07000000000001,
      104.288,
    );
    path_51.cubicTo(
      92.54,
      104.958,
      89.77000000000001,
      102.928,
      90.37,
      100.88799999999999,
    );
    path_51.cubicTo(
      90.37,
      100.88799999999999,
      89.45,
      101.65799999999999,
      89.18,
      102.87799999999999,
    );
    path_51.cubicTo(
      88.91000000000001,
      104.09799999999998,
      91.75,
      106.28799999999998,
      96.97000000000001,
      105.90799999999999,
    );
    path_51.cubicTo(
      102.19900000000001,
      105.51799999999999,
      99.74000000000001,
      101.54799999999999,
      98.93,
      100.45799999999998,
    );
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(92.53, 100.077);
    path_52.cubicTo(93.74, 100.077, 93.59, 101.92699999999999, 91.67, 101.757);
    path_52.cubicTo(89.76, 101.587, 91.64, 100.077, 92.53, 100.077);
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(171.049, 56.687);
    path_53.cubicTo(
      171.09900000000002,
      53.327,
      166.019,
      50.797,
      162.37900000000002,
      55.227,
    );
    path_53.cubicTo(
      158.75900000000001,
      59.666999999999994,
      170.979,
      61.56699999999999,
      171.049,
      56.687,
    );
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(170.699, 55.148);
    path_54.cubicTo(
      170.699,
      55.148,
      171.369,
      58.30800000000001,
      167.839,
      58.978,
    );
    path_54.cubicTo(164.309, 59.648, 161.539, 57.618, 162.139, 55.578);
    path_54.cubicTo(
      162.139,
      55.578,
      161.21900000000002,
      56.348000000000006,
      160.949,
      57.568000000000005,
    );
    path_54.cubicTo(
      160.68900000000002,
      58.788000000000004,
      163.519,
      60.97800000000001,
      168.739,
      60.598000000000006,
    );
    path_54.cubicTo(
      173.959,
      60.218,
      171.499,
      56.23800000000001,
      170.699,
      55.148,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(164.299, 54.767);
    path_55.cubicTo(
      165.50900000000001,
      54.767,
      165.359,
      56.617000000000004,
      163.439,
      56.447,
    );
    path_55.cubicTo(161.519, 56.277, 163.399, 54.767, 164.299, 54.767);
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(129.939, 48.398);
    path_56.cubicTo(
      133.619,
      49.188,
      126.919,
      51.828,
      124.469,
      51.178000000000004,
    );
    path_56.cubicTo(
      122.029,
      50.528000000000006,
      126.42899999999999,
      47.638000000000005,
      129.939,
      48.398,
    );
    path_56.close();
    path_56.moveTo(157.19899999999998, 71.84700000000001);
    path_56.cubicTo(
      159.249,
      72.927,
      156.89899999999997,
      76.617,
      151.35899999999998,
      75.977,
    );
    path_56.cubicTo(
      145.82899999999998,
      75.327,
      155.129,
      70.747,
      157.19899999999998,
      71.84700000000001,
    );
    path_56.close();
    path_56.moveTo(32.58, 97.118);
    path_56.cubicTo(36.12, 98.458, 32.18, 98.878, 30.65, 98.27799999999999);
    path_56.cubicTo(29.11, 97.678, 31.729999999999997, 96.788, 32.58, 97.118);
    path_56.close();
    path_56.moveTo(62.379999999999995, 76.46799999999999);
    path_56.cubicTo(
      63.279999999999994,
      77.24799999999999,
      61.279999999999994,
      77.42799999999998,
      60.35999999999999,
      76.62799999999999,
    );
    path_56.cubicTo(
      59.42999999999999,
      75.82799999999999,
      61.01999999999999,
      75.29799999999999,
      62.379999999999995,
      76.46799999999999,
    );
    path_56.close();
    path_56.moveTo(48.41, 105.94699999999999);
    path_56.cubicTo(
      50.23,
      105.58699999999999,
      41.48,
      101.737,
      38.12,
      102.13699999999999,
    );
    path_56.cubicTo(
      34.75,
      102.52699999999999,
      43.05,
      107.01699999999998,
      48.41,
      105.94699999999999,
    );
    path_56.close();
    path_56.moveTo(54.699999999999996, 95.59799999999998);
    path_56.cubicTo(
      56.94,
      96.28799999999998,
      53.629999999999995,
      97.23799999999999,
      51.98,
      96.66799999999998,
    );
    path_56.cubicTo(
      50.339999999999996,
      96.08799999999998,
      51.699999999999996,
      94.66799999999998,
      54.699999999999996,
      95.59799999999998,
    );
    path_56.close();
    path_56.moveTo(149.429, 76.36799999999998);
    path_56.cubicTo(
      156.079,
      78.89799999999998,
      148.899,
      83.25799999999998,
      142.00900000000001,
      79.73799999999999,
    );
    path_56.cubicTo(
      135.11900000000003,
      76.21799999999999,
      145.65900000000002,
      74.92799999999998,
      149.429,
      76.36799999999998,
    );
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = GameColors.islandPainterColor49.withValues(alpha: 1.0);
    canvas.drawPath(path_56, paint56Fill);

    Path path_57 = Path();
    path_57.moveTo(88.829, 105.948);
    path_57.cubicTo(
      89.779,
      106.96799999999999,
      85.329,
      108.41799999999999,
      82.609,
      106.848,
    );
    path_57.cubicTo(79.899, 105.268, 86.619, 103.548, 88.829, 105.948);
    path_57.close();
    path_57.moveTo(173.269, 64.39699999999999);
    path_57.cubicTo(
      174.219,
      65.41699999999999,
      169.769,
      66.86699999999999,
      167.049,
      65.297,
    );
    path_57.cubicTo(
      164.329,
      63.727,
      171.049,
      62.007,
      173.269,
      64.39699999999999,
    );
    path_57.close();
    path_57.moveTo(84.259, 101.797);
    path_57.cubicTo(
      87.739,
      102.357,
      86.479,
      103.78699999999999,
      84.909,
      103.89699999999999,
    );
    path_57.cubicTo(
      83.32900000000001,
      104.00699999999999,
      81.52900000000001,
      101.35699999999999,
      84.259,
      101.797,
    );
    path_57.close();
    path_57.moveTo(108.599, 55.717);
    path_57.cubicTo(
      112.07900000000001,
      56.277,
      110.819,
      57.707,
      109.24900000000001,
      57.817,
    );
    path_57.cubicTo(
      107.67900000000002,
      57.927,
      105.86900000000001,
      55.277,
      108.599,
      55.717,
    );
    path_57.close();

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_57, paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(82.539, 103.197);
    path_58.cubicTo(
      84.089,
      104.007,
      81.96900000000001,
      105.387,
      79.889,
      104.757,
    );
    path_58.cubicTo(
      77.829,
      104.12700000000001,
      79.539,
      101.637,
      82.539,
      103.197,
    );
    path_58.close();
    path_58.moveTo(59.019000000000005, 104.107);
    path_58.cubicTo(
      59.749,
      105.737,
      56.449000000000005,
      106.057,
      54.589000000000006,
      104.407,
    );
    path_58.cubicTo(
      52.729000000000006,
      102.767,
      58.309000000000005,
      102.517,
      59.019000000000005,
      104.107,
    );
    path_58.close();
    path_58.moveTo(61.34, 98.907);
    path_58.cubicTo(62.84, 99.597, 60.24, 100.74799999999999, 59.67, 100.078);
    path_58.cubicTo(
      59.1,
      99.408,
      59.800000000000004,
      98.19800000000001,
      61.34,
      98.908,
    );
    path_58.close();
    path_58.moveTo(175.87900000000002, 62.126999999999995);
    path_58.cubicTo(
      177.37900000000002,
      62.81699999999999,
      174.77900000000002,
      63.967,
      174.20900000000003,
      63.297,
    );
    path_58.cubicTo(
      173.63900000000004,
      62.626999999999995,
      174.33900000000003,
      61.407,
      175.87900000000002,
      62.126999999999995,
    );
    path_58.close();
    path_58.moveTo(98.83900000000001, 91.68799999999999);
    path_58.cubicTo(
      101.27900000000001,
      93.118,
      96.41900000000001,
      93.75799999999998,
      95.26900000000002,
      92.90799999999999,
    );
    path_58.cubicTo(
      94.11900000000001,
      92.04799999999999,
      95.89900000000002,
      89.96799999999999,
      98.83900000000001,
      91.68799999999999,
    );
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_58, paint58Fill);

    Path path_59 = Path();
    path_59.moveTo(213.609, 78.067);
    path_59.cubicTo(
      227.859,
      78.83699999999999,
      219.87900000000002,
      96.657,
      194.269,
      95.78699999999999,
    );
    path_59.cubicTo(
      168.659,
      94.89699999999999,
      194.75900000000001,
      77.047,
      213.609,
      78.067,
    );
    path_59.close();

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_59, paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(210.469, 85.347);
    path_60.cubicTo(
      212.049,
      82.517,
      211.069,
      70.917,
      200.329,
      68.28699999999999,
    );
    path_60.cubicTo(
      189.579,
      65.64699999999999,
      180.959,
      79.46699999999998,
      180.56900000000002,
      84.05699999999999,
    );
    path_60.cubicTo(
      180.17900000000003,
      88.64699999999999,
      188.42900000000003,
      93.25699999999999,
      192.15900000000002,
      94.11699999999999,
    );
    path_60.cubicTo(
      195.87900000000002,
      94.96699999999998,
      206.479,
      92.49699999999999,
      210.46900000000002,
      85.347,
    );
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7958443, size.height * 0.7190227),
      Offset(size.width * 0.8158238, size.height * 0.4592424),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_60, paint60Fill);

    Path path_61 = Path();
    path_61.moveTo(204.199, 72.757);
    path_61.cubicTo(207.649, 75.927, 207.679, 86.857, 198.619, 90.037);
    path_61.cubicTo(
      189.559,
      93.21700000000001,
      181.50900000000001,
      85.497,
      182.679,
      80.43700000000001,
    );
    path_61.cubicTo(
      183.849,
      75.37700000000002,
      197.789,
      66.85700000000001,
      204.199,
      72.757,
    );
    path_61.close();

    Paint paint61Fill = Paint()..style = PaintingStyle.fill;
    paint61Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_61, paint61Fill);

    Path path_62 = Path();
    path_62.moveTo(204.199, 70.458);
    path_62.cubicTo(
      205.639,
      72.338,
      200.71900000000002,
      79.958,
      196.03900000000002,
      83.128,
    );
    path_62.cubicTo(
      191.359,
      86.298,
      181.90900000000002,
      84.128,
      181.299,
      83.718,
    );
    path_62.cubicTo(180.679, 83.308, 188.059, 69.688, 194.769, 68.318);
    path_62.cubicTo(201.479, 66.938, 204.199, 70.458, 204.199, 70.458);
    path_62.close();

    Paint paint62Fill = Paint()..style = PaintingStyle.fill;
    paint62Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_62, paint62Fill);

    Path path_63 = Path();
    path_63.moveTo(201.179, 92.357);
    path_63.cubicTo(
      203.139,
      92.67699999999999,
      209.329,
      88.227,
      210.289,
      84.127,
    );
    path_63.cubicTo(
      211.23899999999998,
      80.017,
      207.10899999999998,
      72.077,
      206.63899999999998,
      71.64699999999999,
    );
    path_63.cubicTo(
      206.16899999999998,
      71.22699999999999,
      198.469,
      82.24699999999999,
      197.14899999999997,
      83.88699999999999,
    );
    path_63.cubicTo(
      195.81899999999996,
      85.52699999999999,
      200.48899999999998,
      92.24699999999999,
      201.17899999999997,
      92.35699999999999,
    );
    path_63.close();

    Paint paint63Fill = Paint()..style = PaintingStyle.fill;
    paint63Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_63, paint63Fill);

    Path path_64 = Path();
    path_64.moveTo(199.569, 92.858);
    path_64.cubicTo(
      200.219,
      92.44800000000001,
      197.73899999999998,
      86.64800000000001,
      195.79899999999998,
      85.558,
    );
    path_64.cubicTo(
      193.85899999999998,
      84.468,
      182.129,
      85.048,
      181.58899999999997,
      85.19800000000001,
    );
    path_64.cubicTo(
      181.05899999999997,
      85.358,
      185.76899999999998,
      96.67800000000001,
      199.56899999999996,
      92.858,
    );
    path_64.close();

    Paint paint64Fill = Paint()..style = PaintingStyle.fill;
    paint64Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_64, paint64Fill);

    Path path_65 = Path();
    path_65.moveTo(200.049, 79.457);
    path_65.cubicTo(
      200.329,
      79.27699999999999,
      197.049,
      85.67699999999999,
      196.679,
      85.78699999999999,
    );
    path_65.cubicTo(
      196.309,
      85.907,
      190.139,
      85.02699999999999,
      189.939,
      84.907,
    );
    path_65.cubicTo(
      189.72899999999998,
      84.797,
      195.839,
      82.157,
      200.04899999999998,
      79.457,
    );
    path_65.close();
    path_65.moveTo(187.06900000000002, 84.75699999999999);
    path_65.cubicTo(
      187.06900000000002,
      84.75699999999999,
      184.42900000000003,
      85.07699999999998,
      182.829,
      85.097,
    );
    path_65.cubicTo(
      181.229,
      85.107,
      180.75900000000001,
      83.72699999999999,
      180.889,
      83.55699999999999,
    );
    path_65.cubicTo(
      181.029,
      83.37699999999998,
      183.639,
      84.40699999999998,
      187.06900000000002,
      84.75699999999999,
    );
    path_65.close();

    Paint paint65Fill = Paint()..style = PaintingStyle.fill;
    paint65Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_65, paint65Fill);

    Path path_66 = Path();
    path_66.moveTo(198.999, 79.567);
    path_66.cubicTo(
      202.109,
      76.907,
      197.909,
      71.14699999999999,
      191.599,
      72.607,
    );
    path_66.cubicTo(
      185.289,
      74.077,
      184.48899999999998,
      80.317,
      184.69899999999998,
      82.377,
    );
    path_66.cubicTo(
      184.89899999999997,
      84.437,
      192.10899999999998,
      85.467,
      198.999,
      79.567,
    );
    path_66.close();

    Paint paint66Fill = Paint()..style = PaintingStyle.fill;
    paint66Fill.color = GameColors.islandPainterColor71.withValues(alpha: 1.0);
    canvas.drawPath(path_66, paint66Fill);

    Path path_67 = Path();
    path_67.moveTo(188.149, 95.058);
    path_67.cubicTo(
      192.209,
      95.128,
      197.75900000000001,
      96.388,
      197.839,
      98.11800000000001,
    );
    path_67.cubicTo(
      197.949,
      100.40800000000002,
      190.799,
      102.76800000000001,
      181.029,
      101.578,
    );
    path_67.cubicTo(171.259, 100.388, 183.239, 94.968, 188.149, 95.058);
    path_67.close();

    Paint paint67Fill = Paint()..style = PaintingStyle.fill;
    paint67Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_67, paint67Fill);

    Path path_68 = Path();
    path_68.moveTo(190.269, 91.648);
    path_68.cubicTo(
      191.309,
      95.628,
      189.75900000000001,
      100.838,
      184.439,
      101.458,
    );
    path_68.cubicTo(179.119, 102.078, 172.579, 96.718, 170.439, 92.868);
    path_68.cubicTo(
      168.399,
      89.21799999999999,
      174.929,
      82.008,
      177.559,
      82.478,
    );
    path_68.cubicTo(
      180.179,
      82.948,
      189.22899999999998,
      87.66799999999999,
      190.269,
      91.648,
    );
    path_68.close();

    Paint paint68Fill = Paint()..style = PaintingStyle.fill;
    paint68Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7340656, size.height * 0.7673030),
      Offset(size.width * 0.7475410, size.height * 0.5920985),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_68, paint68Fill);

    Path path_69 = Path();
    path_69.moveTo(180.309, 84.108);
    path_69.cubicTo(182.599, 83.158, 187.529, 89.188, 187.569, 95.828);
    path_69.cubicTo(
      187.60899999999998,
      102.468,
      174.29899999999998,
      101.44800000000001,
      172.319,
      93.938,
    );
    path_69.cubicTo(170.339, 86.418, 180.309, 84.108, 180.309, 84.108);
    path_69.close();

    Paint paint69Fill = Paint()..style = PaintingStyle.fill;
    paint69Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_69, paint69Fill);

    Path path_70 = Path();
    path_70.moveTo(180.899, 84.358);
    path_70.cubicTo(
      181.319,
      84.068,
      189.359,
      88.58800000000001,
      189.949,
      91.688,
    );
    path_70.cubicTo(
      190.549,
      94.778,
      188.87900000000002,
      98.44800000000001,
      188.87900000000002,
      98.798,
    );
    path_70.cubicTo(
      188.87900000000002,
      99.158,
      178.919,
      93.858,
      178.799,
      93.428,
    );
    path_70.cubicTo(178.679, 93.018, 181.189, 90.158, 180.899, 84.358);
    path_70.close();

    Paint paint70Fill = Paint()..style = PaintingStyle.fill;
    paint70Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_70, paint70Fill);

    Path path_71 = Path();
    path_71.moveTo(178.729, 82.808);
    path_71.cubicTo(
      180.09900000000002,
      82.888,
      181.43900000000002,
      89.188,
      178.729,
      92.81800000000001,
    );
    path_71.cubicTo(
      176.829,
      95.35800000000002,
      171.229,
      94.62800000000001,
      170.449,
      92.11800000000001,
    );
    path_71.cubicTo(
      169.77900000000002,
      89.998,
      172.68900000000002,
      82.45800000000001,
      178.729,
      82.808,
    );
    path_71.close();

    Paint paint71Fill = Paint()..style = PaintingStyle.fill;
    paint71Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_71, paint71Fill);

    Path path_72 = Path();
    path_72.moveTo(188.219, 99.488);
    path_72.cubicTo(188.529, 99.138, 179.779, 94.778, 178.789, 94.658);
    path_72.cubicTo(
      177.79899999999998,
      94.548,
      173.009,
      95.468,
      170.439,
      92.858,
    );
    path_72.cubicTo(
      170.439,
      92.858,
      174.57899999999998,
      99.94800000000001,
      181.629,
      100.598,
    );
    path_72.cubicTo(188.679, 101.258, 188.219, 99.488, 188.219, 99.488);
    path_72.close();

    Paint paint72Fill = Paint()..style = PaintingStyle.fill;
    paint72Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_72, paint72Fill);

    Path path_73 = Path();
    path_73.moveTo(180.049, 89.778);
    path_73.cubicTo(
      180.049,
      89.778,
      179.479,
      93.938,
      179.469,
      94.39800000000001,
    );
    path_73.cubicTo(
      179.459,
      94.86800000000001,
      176.629,
      94.168,
      176.629,
      94.168,
    );
    path_73.cubicTo(
      176.629,
      94.168,
      179.339,
      91.83800000000001,
      180.04899999999998,
      89.778,
    );
    path_73.close();

    Paint paint73Fill = Paint()..style = PaintingStyle.fill;
    paint73Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_73, paint73Fill);

    Path path_74 = Path();
    path_74.moveTo(155.579, 92.287);
    path_74.cubicTo(
      158.139,
      92.98700000000001,
      158.489,
      97.757,
      149.859,
      98.31700000000001,
    );
    path_74.cubicTo(
      141.229,
      98.87700000000001,
      145.62900000000002,
      89.57700000000001,
      155.579,
      92.287,
    );
    path_74.close();

    Paint paint74Fill = Paint()..style = PaintingStyle.fill;
    paint74Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_74, paint74Fill);

    Path path_75 = Path();
    path_75.moveTo(156.229, 93.578);
    path_75.cubicTo(
      156.93900000000002,
      92.128,
      152.739,
      87.268,
      148.49900000000002,
      88.418,
    );
    path_75.cubicTo(
      144.25900000000001,
      89.578,
      142.86900000000003,
      92.84800000000001,
      145.08900000000003,
      95.608,
    );
    path_75.cubicTo(
      147.30900000000003,
      98.36800000000001,
      153.93900000000002,
      98.28800000000001,
      156.22900000000004,
      93.578,
    );
    path_75.close();

    Paint paint75Fill = Paint()..style = PaintingStyle.fill;
    paint75Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6127254, size.height * 0.7399848),
      Offset(size.width * 0.6196393, size.height * 0.6500909),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_75, paint75Fill);

    Path path_76 = Path();
    path_76.moveTo(155.109, 92.028);
    path_76.cubicTo(
      155.489,
      93.19800000000001,
      150.18900000000002,
      96.458,
      146.089,
      94.418,
    );
    path_76.cubicTo(141.989, 92.378, 147.759, 88.798, 149.859, 88.738);
    path_76.cubicTo(
      151.96900000000002,
      88.658,
      154.639,
      90.568,
      155.109,
      92.028,
    );
    path_76.close();

    Paint paint76Fill = Paint()..style = PaintingStyle.fill;
    paint76Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_76, paint76Fill);

    Path path_77 = Path();
    path_77.moveTo(154.959, 90.617);
    path_77.cubicTo(
      155.479,
      91.59700000000001,
      152.629,
      93.56700000000001,
      149.119,
      93.807,
    );
    path_77.cubicTo(
      145.609,
      94.047,
      144.509,
      92.31700000000001,
      144.449,
      91.807,
    );
    path_77.cubicTo(
      144.389,
      91.287,
      145.43900000000002,
      88.31700000000001,
      149.739,
      88.327,
    );
    path_77.cubicTo(
      151.859,
      88.327,
      154.28900000000002,
      89.347,
      154.959,
      90.617,
    );
    path_77.close();

    Paint paint77Fill = Paint()..style = PaintingStyle.fill;
    paint77Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_77, paint77Fill);

    Path path_78 = Path();
    path_78.moveTo(151.339, 97.147);
    path_78.cubicTo(
      151.679,
      97.32700000000001,
      154.529,
      95.607,
      155.409,
      94.467,
    );
    path_78.cubicTo(156.289, 93.317, 155.629, 91.727, 155.309, 91.747);
    path_78.cubicTo(154.989, 91.767, 152.299, 93.567, 150.159, 94.047);
    path_78.cubicTo(
      150.179,
      94.03699999999999,
      149.539,
      96.207,
      151.339,
      97.14699999999999,
    );
    path_78.close();

    Paint paint78Fill = Paint()..style = PaintingStyle.fill;
    paint78Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_78, paint78Fill);

    Path path_79 = Path();
    path_79.moveTo(150.179, 97.257);
    path_79.cubicTo(150.579, 97.197, 149.659, 94.477, 149.319, 94.287);
    path_79.cubicTo(
      148.97899999999998,
      94.09700000000001,
      145.60899999999998,
      93.997,
      144.22899999999998,
      92.23700000000001,
    );
    path_79.cubicTo(
      144.22899999999998,
      92.23700000000001,
      143.289,
      96.837,
      150.17899999999997,
      97.257,
    );
    path_79.close();

    Paint paint79Fill = Paint()..style = PaintingStyle.fill;
    paint79Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_79, paint79Fill);

    Path path_80 = Path();
    path_80.moveTo(150.819, 93.647);
    path_80.cubicTo(
      150.819,
      93.647,
      150.29899999999998,
      94.617,
      149.939,
      94.747,
    );
    path_80.cubicTo(
      149.57899999999998,
      94.867,
      147.749,
      93.927,
      147.749,
      93.927,
    );
    path_80.cubicTo(147.749, 93.927, 149.049, 94.007, 150.819, 93.647);
    path_80.close();
    path_80.moveTo(147.279, 93.837);
    path_80.cubicTo(
      147.279,
      93.837,
      145.94899999999998,
      93.277,
      145.429,
      92.947,
    );
    path_80.cubicTo(144.899, 92.617, 144.599, 92.287, 144.599, 92.287);
    path_80.cubicTo(144.599, 92.287, 145.069, 93.807, 147.279, 93.837);
    path_80.close();

    Paint paint80Fill = Paint()..style = PaintingStyle.fill;
    paint80Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_80, paint80Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class ForthIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(75.87, 43.893);
    path_0.cubicTo(84.37, 39.253, 85.81, 31.833, 82.19, 24.393);
    path_0.cubicTo(
      75.45,
      10.553,
      51.2,
      -3.3069999999999986,
      22.339999999999996,
      0.7029999999999994,
    );
    path_0.cubicTo(
      10.609999999999996,
      2.3329999999999993,
      3.6299999999999955,
      8.953,
      1.0999999999999979,
      17.073,
    );
    path_0.cubicTo(
      -5.970000000000002,
      39.613,
      21.279999999999998,
      73.693,
      75.86999999999999,
      43.893,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4943882, size.height * 0.9920179),
      Offset(size.width * 0.4943882, size.height * -0.005357143),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(75.87, 43.892);
    path_1.cubicTo(84.37, 39.252, 85.81, 31.832, 82.19, 24.392000000000003);
    path_1.cubicTo(
      81.91,
      24.302000000000003,
      81.77,
      24.252000000000002,
      81.77,
      24.252000000000002,
    );
    path_1.cubicTo(82.82, 37.142, 64.3, 54.202, 34.66, 50.902);
    path_1.cubicTo(5.05, 47.613, 0.86, 25.453, 1.1, 17.063);
    path_1.cubicTo(
      -5.970000000000001,
      39.613,
      21.28,
      73.693,
      75.86999999999999,
      43.893,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4943882, size.height * 0.9920179),
      Offset(size.width * 0.4943882, size.height * 0.3047679),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(66.96, 48.303);
    path_2.cubicTo(
      66.96,
      48.303,
      42.36999999999999,
      54.452999999999996,
      23.669999999999995,
      48.303,
    );
    path_2.cubicTo(
      4.969999999999999,
      42.153,
      1.1899999999999942,
      32.312999999999995,
      1.1899999999999942,
      32.312999999999995,
    );
    path_2.cubicTo(
      1.1899999999999942,
      32.312999999999995,
      5.459999999999994,
      48.733,
      24.679999999999993,
      54.022999999999996,
    );
    path_2.cubicTo(43.91, 59.32299999999999, 66.96, 48.303, 66.96, 48.303);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4009059, size.height * 0.9904286),
      Offset(size.width * 0.4009059, size.height * 0.5770357),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(62.19, 44.352);
    path_3.cubicTo(
      79.12,
      34.641999999999996,
      74.77,
      -0.5380000000000038,
      22.949999999999996,
      9.711999999999996,
    );
    path_3.cubicTo(
      -28.870000000000005,
      19.961999999999996,
      37.48,
      58.522,
      62.19,
      44.352,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = GameColors.islandPainterColor74.withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(58.18, 42.412);
    path_4.cubicTo(60.04, 40.932, 57.58, 29.622, 43.89, 30.862);
    path_4.cubicTo(30.19, 32.102, 30.18, 40.922, 30.950000000000003, 42.402);
    path_4.cubicTo(
      31.720000000000002,
      43.872,
      47.730000000000004,
      50.702,
      58.18000000000001,
      42.412,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5259294, size.height * 0.8292857),
      Offset(size.width * 0.5259294, size.height * 0.5493571),
      [
        GameColors.islandPainterColor70.withValues(alpha: 1),
        GameColors.islandPainterColor60.withValues(alpha: 1),
        GameColors.islandPainterColor55.withValues(alpha: 1),
      ],
      [0, 0.41, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(58.53, 39.153);
    path_5.cubicTo(
      58.550000000000004,
      41.833,
      56.550000000000004,
      42.623,
      55.61,
      43.013,
    );
    path_5.cubicTo(54.67, 43.403, 58.339999999999996, 33.663, 44.71, 33.933);
    path_5.cubicTo(31.08, 34.203, 30.69, 40.903, 30.69, 40.903);
    path_5.cubicTo(
      30.69,
      40.903,
      30.27,
      30.863,
      44.620000000000005,
      30.852999999999998,
    );
    path_5.cubicTo(58.95, 30.833, 58.53, 39.153, 58.53, 39.153);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5247765, size.height * 0.7683393),
      Offset(size.width * 0.5247765, size.height * 0.5509464),
      [
        GameColors.islandPainterColor77.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor34.withValues(alpha: 1),
      ],
      [0, 0.115, 0.314, 0.572, 0.876, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(56.94, 43.303);
    path_6.cubicTo(
      56.94,
      43.303,
      52.47,
      45.672999999999995,
      44.599999999999994,
      45.672999999999995,
    );
    path_6.cubicTo(
      36.72999999999999,
      45.672999999999995,
      33.129999999999995,
      44.142999999999994,
      33.129999999999995,
      44.142999999999994,
    );
    path_6.cubicTo(
      33.129999999999995,
      44.142999999999994,
      46.519999999999996,
      50.36299999999999,
      56.94,
      43.30299999999999,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(20.7, 43.893);
    path_7.cubicTo(24.68, 41.893, 26.23, 39.083, 25.29, 36.633);
    path_7.cubicTo(
      24.349999999999998,
      34.183,
      16.95,
      36.713,
      16.229999999999997,
      40.853,
    );
    path_7.cubicTo(
      15.519999999999996,
      44.983000000000004,
      19.369999999999997,
      44.553000000000004,
      20.699999999999996,
      43.893,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2453529, size.height * 0.7913750),
      Offset(size.width * 0.2453529, size.height * 0.6368929),
      [
        GameColors.islandPainterColor70.withValues(alpha: 1),
        GameColors.islandPainterColor60.withValues(alpha: 1),
        GameColors.islandPainterColor55.withValues(alpha: 1),
      ],
      [0, 0.41, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(25.52, 38.602);
    path_8.cubicTo(25.3, 36.632, 19.15, 37.791999999999994, 17.39, 39.992);
    path_8.cubicTo(15.63, 42.192, 16.53, 43.302, 16.53, 43.302);
    path_8.cubicTo(
      16.53,
      43.302,
      14.680000000000001,
      40.672,
      18.400000000000002,
      37.592,
    );
    path_8.cubicTo(
      22.110000000000003,
      34.512,
      26.21,
      35.052,
      25.520000000000003,
      38.602,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2451059, size.height * 0.7732857),
      Offset(size.width * 0.2451059, size.height * 0.6353036),
      [
        GameColors.islandPainterColor77.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor34.withValues(alpha: 1),
      ],
      [0, 0.115, 0.314, 0.572, 0.876, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(24.71, 40.623);
    path_9.cubicTo(24.71, 40.623, 21.34, 43.733, 19.09, 44.043);
    path_9.cubicTo(16.84, 44.353, 16.28, 42.813, 16.28, 42.813);
    path_9.cubicTo(16.28, 42.813, 16.59, 44.713, 19.25, 44.483000000000004);
    path_9.cubicTo(
      21.91,
      44.243,
      24.240000000000002,
      41.483000000000004,
      24.71,
      40.623000000000005,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(46.93, 26.943);
    path_10.cubicTo(
      51.85,
      24.233,
      56.15,
      1.8530000000000015,
      29.98,
      1.333000000000002,
    );
    path_10.cubicTo(
      3.8099999999999987,
      0.823000000000002,
      5.120000000000001,
      25.843000000000004,
      10.18,
      29.543000000000003,
    );
    path_10.cubicTo(15.239999999999998, 33.253, 34.46, 33.813, 46.93, 26.943);
    path_10.close();
    path_10.moveTo(80.56, 21.552);
    path_10.cubicTo(77.28, 28.662, 50, 2.192, 50, 2.192);
    path_10.cubicTo(50, 2.192, 70.28999999999999, 6.472, 80.56, 21.552);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(73.27, 38.013);
    path_11.cubicTo(
      73.06,
      33.863,
      70.42999999999999,
      31.572999999999997,
      66.22,
      34.183,
    );
    path_11.cubicTo(62, 36.793, 65.91, 41.693, 68.6, 41.772999999999996);
    path_11.cubicTo(
      71.27,
      41.842999999999996,
      73.33999999999999,
      39.543,
      73.27,
      38.013,
    );
    path_11.close();
    path_11.moveTo(63.839999999999996, 40.622);
    path_11.cubicTo(
      66.22,
      44.022,
      63.459999999999994,
      45.222,
      61.309999999999995,
      41.772,
    );
    path_11.cubicTo(59.16, 38.312, 62.65, 38.912, 63.839999999999996, 40.622);
    path_11.close();
    path_11.moveTo(17.439999999999998, 26.512999999999998);
    path_11.cubicTo(
      25.879999999999995,
      29.333,
      21.949999999999996,
      36.763,
      12.409999999999997,
      36.013,
    );
    path_11.cubicTo(
      2.859999999999996,
      35.253,
      6.269999999999997,
      22.782999999999998,
      17.439999999999998,
      26.512999999999998,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(21.51, 29.232);
    path_12.cubicTo(
      21.51,
      29.232,
      23.200000000000003,
      33.552,
      15.850000000000001,
      35.212,
    );
    path_12.cubicTo(
      8.510000000000002,
      36.872,
      7.040000000000001,
      31.662000000000003,
      6.830000000000002,
      30.742000000000004,
    );
    path_12.cubicTo(
      6.830000000000002,
      30.742000000000004,
      6.4300000000000015,
      32.182,
      7.390000000000002,
      34.51200000000001,
    );
    path_12.cubicTo(
      8.350000000000001,
      36.842000000000006,
      13.490000000000002,
      37.65200000000001,
      18.660000000000004,
      35.54200000000001,
    );
    path_12.cubicTo(
      23.830000000000005,
      33.42200000000001,
      22.320000000000004,
      30.492000000000008,
      21.510000000000005,
      29.23200000000001,
    );
    path_12.close();
    path_12.moveTo(64.64, 42.183);
    path_12.cubicTo(64.91, 44.023, 62.82, 43.273, 61.79, 41.973);
    path_12.cubicTo(60.76, 40.672999999999995, 60.66, 39.763, 60.66, 39.763);
    path_12.cubicTo(60.66, 39.763, 60.22, 40.763, 61.76, 42.913);
    path_12.cubicTo(
      63.28,
      45.062999999999995,
      65.5,
      45.142999999999994,
      64.64,
      42.183,
    );
    path_12.close();
    path_12.moveTo(73.24, 37.662);
    path_12.cubicTo(73.24, 37.662, 72.89999999999999, 41.032, 68.81, 41.032);
    path_12.cubicTo(
      64.72000000000001,
      41.032,
      64.32000000000001,
      36.821999999999996,
      64.75,
      35.611999999999995,
    );
    path_12.cubicTo(64.75, 35.611999999999995, 64.01, 36.352, 64.14, 38.062);
    path_12.cubicTo(64.27, 39.772, 65.75, 42.542, 69.47, 42.282);
    path_12.cubicTo(
      73.19,
      42.01199999999999,
      73.71,
      40.251999999999995,
      73.24,
      37.662,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(32.5, 9.763);
    path_13.cubicTo(
      34.68,
      15.402999999999999,
      22.130000000000003,
      24.153,
      10.02,
      20.533,
    );
    path_13.cubicTo(
      -2.09,
      16.913,
      8.78,
      6.253000000000002,
      21.91,
      6.263000000000002,
    );
    path_13.cubicTo(
      27.96,
      6.263000000000002,
      31.7,
      7.673000000000002,
      32.5,
      9.763000000000002,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2207176, size.height * 0.3818214),
      Offset(size.width * 0.2207176, size.height * 0.1117857),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(32.06, 9.003);
    path_14.cubicTo(34.330000000000005, 13.333, 26.26, 19.613, 16.07, 19.843);
    path_14.cubicTo(5.890000000000001, 20.073, 4.92, 14.693, 4.92, 14.693);
    path_14.cubicTo(4.92, 14.693, 2.92, 17.213, 6.75, 20.183);
    path_14.cubicTo(
      10.58,
      23.143,
      21.369999999999997,
      23.262999999999998,
      29.13,
      17.913,
    );
    path_14.cubicTo(36.91, 12.563, 32.06, 9.003, 32.06, 9.003);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2232588, size.height * 0.3966429),
      Offset(size.width * 0.2232588, size.height * 0.1607143),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_14, paint14Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class FifthIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(17.384, 114.407);
    path_0.cubicTo(55.774, 149.627, 123.994, 138.117, 146.474, 124.497);
    path_0.cubicTo(
      166.754,
      112.227,
      184.394,
      87.59700000000001,
      178.45399999999998,
      67.947,
    );
    path_0.cubicTo(
      176.694,
      62.127,
      172.87399999999997,
      56.747,
      166.43399999999997,
      52.257000000000005,
    );
    path_0.cubicTo(
      132.77399999999997,
      28.757000000000005,
      75.35399999999997,
      9.487000000000002,
      34.60399999999996,
      37.31700000000001,
    );
    path_0.cubicTo(
      24.453999999999958,
      44.257000000000005,
      11.473999999999958,
      53.977000000000004,
      4.653999999999957,
      66.02700000000002,
    );
    path_0.cubicTo(
      -2.9460000000000424,
      79.49700000000001,
      -2.876000000000043,
      95.83700000000002,
      17.383999999999958,
      114.40700000000001,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4989667, size.height * 0.9983696),
      Offset(size.width * 0.4989667, size.height * 0.1707971),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(17.384, 114.407);
    path_1.cubicTo(55.774, 149.627, 123.994, 138.117, 146.474, 124.497);
    path_1.cubicTo(
      166.754,
      112.227,
      184.394,
      87.59700000000001,
      178.45399999999998,
      67.947,
    );
    path_1.lineTo(178.444, 67.937);
    path_1.cubicTo(
      178.444,
      67.937,
      188.024,
      125.697,
      91.64399999999999,
      130.987,
    );
    path_1.cubicTo(
      -4.736000000000004,
      136.267,
      4.663999999999987,
      66.027,
      4.663999999999987,
      66.027,
    );
    path_1.lineTo(4.6539999999999875, 66.027);
    path_1.cubicTo(
      -2.946000000000012,
      79.497,
      -2.8760000000000128,
      95.837,
      17.383999999999986,
      114.40700000000001,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4989667, size.height * 0.9983696),
      Offset(size.width * 0.4989667, size.height * 0.4785362),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(165.505, 108.277);
    path_2.cubicTo(
      165.505,
      108.277,
      121.07499999999999,
      136.027,
      82.85499999999999,
      134.177,
    );
    path_2.cubicTo(
      44.63499999999999,
      132.337,
      9.144999999999996,
      105.64699999999999,
      9.144999999999996,
      105.64699999999999,
    );
    path_2.cubicTo(
      9.144999999999996,
      105.64699999999999,
      28.844999999999995,
      135.68699999999998,
      79.155,
      137.567,
    );
    path_2.cubicTo(
      129.465,
      139.457,
      153.925,
      120.427,
      165.505,
      108.27700000000002,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4851444, size.height * 0.9978406),
      Offset(size.width * 0.4851444, size.height * 0.7655725),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(168.364, 59.178);
    path_3.cubicTo(
      175.214,
      76.30799999999999,
      149.00400000000002,
      116.447,
      87.23400000000001,
      114.92699999999999,
    );
    path_3.cubicTo(
      25.464000000000006,
      113.407,
      9.824000000000012,
      84.437,
      11.824000000000012,
      64.097,
    );
    path_3.cubicTo(
      13.824000000000012,
      43.766999999999996,
      53.33400000000001,
      23.706999999999994,
      98.10400000000001,
      27.496999999999993,
    );
    path_3.cubicTo(
      142.864,
      31.296999999999993,
      165.394,
      51.75699999999999,
      168.36400000000003,
      59.17699999999999,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5030000, size.height * 0.8330942),
      Offset(size.width * 0.5030000, size.height * 0.1959130),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(168.365, 59.177);
    path_4.cubicTo(170.555, 70.547, 149.905, 109.997, 92.055, 111.807);
    path_4.cubicTo(
      34.205000000000005,
      113.617,
      11.14500000000001,
      86.707,
      12.455000000000013,
      60.857,
    );
    path_4.cubicTo(
      12.455000000000013,
      60.857,
      10.905000000000012,
      65.967,
      10.495000000000012,
      73.507,
    );
    path_4.cubicTo(
      10.085000000000012,
      81.04700000000001,
      17.24500000000001,
      119.59700000000001,
      92.465,
      115.667,
    );
    path_4.cubicTo(167.685, 111.727, 173.945, 76.607, 168.365, 59.177);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5010667, size.height * 0.8401812),
      Offset(size.width * 0.5010667, size.height * 0.4288116),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(99.644, 31.607);
    path_5.cubicTo(
      106.894,
      35.787,
      82.424,
      71.37700000000001,
      53.604000000000006,
      71.37700000000001,
    );
    path_5.cubicTo(
      28.154000000000007,
      71.37700000000001,
      22.634000000000007,
      58.97700000000001,
      20.94400000000001,
      53.747000000000014,
    );
    path_5.cubicTo(
      19.25400000000001,
      48.50700000000001,
      55.33400000000001,
      6.0870000000000175,
      99.644,
      31.607000000000014,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5607278, size.height * 0.3437754),
      Offset(size.width * 0.1160222, size.height * 0.3437754),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(89.284, 26.767);
    path_6.cubicTo(
      94.914,
      29.067,
      80.174,
      52.107,
      56.56400000000001,
      56.516999999999996,
    );
    path_6.cubicTo(
      36.284000000000006,
      60.306999999999995,
      24.98400000000001,
      54.977,
      23.294000000000004,
      50.67699999999999,
    );
    path_6.cubicTo(
      21.614000000000004,
      46.36699999999999,
      49.644000000000005,
      10.556999999999995,
      89.28399999999999,
      26.766999999999992,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3158667, size.height * 0.4188986),
      Offset(size.width * 0.3158667, size.height * 0.1636522),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(88.564, 26.487);
    path_7.cubicTo(
      91.604,
      27.666999999999998,
      81.75399999999999,
      47.887,
      58.86399999999999,
      51.447,
    );
    path_7.cubicTo(
      35.983999999999995,
      55.007000000000005,
      24.83399999999999,
      52.207,
      24.18399999999999,
      47.447,
    );
    path_7.cubicTo(
      24.18399999999999,
      47.447,
      22.533999999999992,
      50.217000000000006,
      22.68399999999999,
      51.297000000000004,
    );
    path_7.cubicTo(
      22.83399999999999,
      52.377,
      31.65399999999999,
      62.027,
      57.79399999999999,
      57.81700000000001,
    );
    path_7.cubicTo(
      83.934,
      53.607000000000006,
      91.404,
      30.68700000000001,
      91.44399999999999,
      29.157000000000007,
    );
    path_7.cubicTo(
      91.484,
      27.617000000000008,
      88.564,
      26.48700000000001,
      88.564,
      26.48700000000001,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3169944, size.height * 0.4265652),
      Offset(size.width * 0.3169944, size.height * 0.1919058),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(89.814, 31.387);
    path_8.cubicTo(89.814, 31.387, 81.984, 37.267, 64.344, 37.777);
    path_8.cubicTo(
      46.70399999999999,
      38.277,
      40.64399999999999,
      38.277,
      34.593999999999994,
      39.697,
    );
    path_8.cubicTo(
      28.533999999999995,
      41.107,
      26.733999999999995,
      43.827000000000005,
      26.733999999999995,
      43.827000000000005,
    );
    path_8.cubicTo(
      26.733999999999995,
      43.827000000000005,
      31.253999999999994,
      34.397000000000006,
      54.964,
      27.507000000000005,
    );
    path_8.cubicTo(
      78.674,
      20.617000000000004,
      89.814,
      31.387000000000004,
      89.814,
      31.387000000000004,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = GameColors.islandPainterColor22.withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(99.305, 40.148);
    path_9.cubicTo(99.305, 40.148, 89.275, 60.918000000000006, 64.535, 66.868);
    path_9.cubicTo(
      39.80499999999999,
      72.818,
      21.845,
      57.327999999999996,
      21.165,
      52.05799999999999,
    );
    path_9.cubicTo(
      21.165,
      52.05799999999999,
      19.665,
      53.337999999999994,
      19.665,
      56.007999999999996,
    );
    path_9.cubicTo(19.665, 58.678, 29.275, 74.048, 62.485, 70.158);
    path_9.cubicTo(
      95.705,
      66.258,
      99.305,
      40.147999999999996,
      99.305,
      40.147999999999996,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3304778, size.height * 0.5128913),
      Offset(size.width * 0.3304778, size.height * 0.2909420),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(90.294, 30.367);
    path_10.cubicTo(90.11399999999999, 30.947, 89.814, 31.387, 89.814, 31.387);
    path_10.cubicTo(89.814, 31.387, 80.544, 31.207, 66.774, 31.837);
    path_10.cubicTo(63.114000000000004, 32.007, 59.124, 32.227, 54.904, 32.527);
    path_10.cubicTo(
      34.84400000000001,
      33.957,
      25.444000000000003,
      45.147,
      25.444000000000003,
      45.147,
    );
    path_10.cubicTo(
      24.564000000000004,
      41.647,
      24.294000000000004,
      38.927,
      24.424000000000003,
      36.807,
    );
    path_10.cubicTo(
      24.834000000000003,
      29.167,
      30.224000000000004,
      29.297000000000004,
      30.224000000000004,
      29.297000000000004,
    );
    path_10.cubicTo(
      28.844000000000005,
      22.637000000000004,
      31.494000000000003,
      21.227000000000004,
      31.494000000000003,
      21.227000000000004,
    );
    path_10.cubicTo(
      31.494000000000003,
      21.227000000000004,
      30.174000000000003,
      12.207000000000004,
      35.774,
      9.447000000000005,
    );
    path_10.cubicTo(
      43.634,
      5.567000000000005,
      53.524,
      15.367000000000004,
      53.524,
      15.367000000000004,
    );
    path_10.cubicTo(
      53.374,
      9.107000000000005,
      56.124,
      12.137000000000004,
      56.124,
      11.327000000000005,
    );
    path_10.cubicTo(
      56.124,
      10.527000000000005,
      56.284,
      -8.052999999999994,
      64.254,
      4.127000000000005,
    );
    path_10.cubicTo(
      78.81400000000001,
      -6.602999999999995,
      77.664,
      11.427000000000005,
      77.664,
      11.427000000000005,
    );
    path_10.cubicTo(
      88.014,
      15.157000000000005,
      83.724,
      27.027000000000005,
      83.724,
      27.027000000000005,
    );
    path_10.cubicTo(
      85.804,
      25.787000000000006,
      85.424,
      27.587000000000003,
      85.424,
      27.587000000000003,
    );
    path_10.cubicTo(
      90.444,
      27.237000000000002,
      90.664,
      29.127000000000002,
      90.29400000000001,
      30.367000000000004,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3189056, size.height * 0.3271522),
      Offset(size.width * 0.3189056, 0),
      [
        GameColors.islandPainterColor2.withValues(alpha: 1),
        GameColors.islandPainterColor4.withValues(alpha: 1),
        GameColors.islandPainterColor7.withValues(alpha: 1),
      ],
      [0, 0.42, 1],
    );
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(39.964, 89.877);
    path_11.cubicTo(39.964, 89.877, 34.464, 91.50699999999999, 27.104, 89.877);
    path_11.cubicTo(19.744, 88.247, 15.473999999999998, 78.667, 14.744, 76.447);
    path_11.cubicTo(
      14.024,
      74.217,
      27.113999999999997,
      72.857,
      39.964,
      89.87700000000001,
    );
    path_11.close();
    path_11.moveTo(128.644, 40.38699999999999);
    path_11.cubicTo(
      128.644,
      40.38699999999999,
      115.994,
      43.92699999999999,
      104.804,
      40.39699999999999,
    );
    path_11.cubicTo(
      93.614,
      36.86699999999999,
      89.844,
      29.16699999999999,
      89.81400000000001,
      28.316999999999993,
    );
    path_11.cubicTo(
      89.784,
      27.476999999999993,
      112.774,
      26.036999999999992,
      128.644,
      40.38699999999999,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(128.645, 40.388);
    path_12.cubicTo(
      130.645,
      40.217999999999996,
      124.965,
      21.997999999999998,
      118.98500000000001,
      13.537999999999997,
    );
    path_12.cubicTo(
      113.00500000000002,
      5.077999999999996,
      100.74500000000002,
      7.2979999999999965,
      99.36500000000001,
      9.517999999999997,
    );
    path_12.cubicTo(
      97.98500000000001,
      11.737999999999998,
      94.915,
      30.997999999999998,
      94.915,
      30.997999999999998,
    );
    path_12.cubicTo(
      94.915,
      30.997999999999998,
      95.53500000000001,
      43.19799999999999,
      128.645,
      40.388,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6221444, size.height * 0.2957029),
      Offset(size.width * 0.6221444, size.height * 0.05426087),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(39.314, 90.097);
    path_13.cubicTo(
      43.153999999999996,
      90.157,
      35.734,
      73.947,
      30.374000000000002,
      69.907,
    );
    path_13.cubicTo(
      25.004,
      65.86699999999999,
      19.334000000000003,
      73.53699999999999,
      19.794000000000004,
      79.997,
    );
    path_13.cubicTo(
      20.254000000000005,
      86.457,
      26.644000000000005,
      89.897,
      39.31400000000001,
      90.097,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1670833, size.height * 0.6528986),
      Offset(size.width * 0.1670833, size.height * 0.4984783),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(22.134, 71.997);
    path_14.cubicTo(25.054000000000002, 72.207, 29.814, 84.137, 29.864, 86.357);
    path_14.cubicTo(29.914, 88.577, 27.104, 88.717, 22.714, 85.347);
    path_14.cubicTo(18.314, 81.987, 19.194, 74.317, 22.134, 71.997);
    path_14.close();
    path_14.moveTo(116.384, 40.387);
    path_14.cubicTo(
      119.06400000000001,
      39.697,
      104.324,
      13.367,
      102.184,
      11.126999999999999,
    );
    path_14.cubicTo(
      100.044,
      8.886999999999999,
      99.074,
      10.166999999999998,
      99.074,
      10.166999999999998,
    );
    path_14.cubicTo(
      99.074,
      10.166999999999998,
      95.134,
      29.566999999999997,
      95.234,
      30.996999999999996,
    );
    path_14.cubicTo(
      95.324,
      32.427,
      98.80399999999999,
      40.776999999999994,
      116.38399999999999,
      40.387,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(37.934, 81.917);
    path_15.cubicTo(
      39.413999999999994,
      86.017,
      31.443999999999996,
      83.997,
      28.733999999999998,
      80.667,
    );
    path_15.cubicTo(
      26.023999999999997,
      77.337,
      23.913999999999998,
      72.307,
      23.523999999999997,
      71.537,
    );
    path_15.cubicTo(
      23.124,
      70.76700000000001,
      28.573999999999998,
      68.54700000000001,
      31.593999999999998,
      70.98700000000001,
    );
    path_15.cubicTo(34.614, 73.43700000000001, 37.934, 81.917, 37.934, 81.917);
    path_15.close();
    path_15.moveTo(122.03399999999999, 18.677);
    path_15.cubicTo(
      125.624,
      25.727,
      121.02399999999999,
      30.377,
      118.78399999999999,
      32.187,
    );
    path_15.cubicTo(
      116.53399999999999,
      34.007,
      104.16399999999999,
      14.996999999999996,
      103.35399999999998,
      11.456999999999997,
    );
    path_15.cubicTo(
      102.53399999999999,
      7.926999999999998,
      115.22399999999999,
      5.296999999999997,
      122.03399999999999,
      18.676999999999996,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(28.914, 82.827);
    path_16.cubicTo(28.914, 82.827, 28.754, 80.997, 28.294, 79.447);
    path_16.cubicTo(27.834, 77.897, 25.964, 76.447, 25.964, 76.447);
    path_16.cubicTo(25.964, 76.447, 26.654, 80.787, 28.913999999999998, 82.827);
    path_16.close();
    path_16.moveTo(112.364, 28.826999999999998);
    path_16.cubicTo(
      112.364,
      28.826999999999998,
      111.914,
      24.997,
      110.714,
      22.737,
    );
    path_16.cubicTo(109.514, 20.487, 106.824, 18.517, 106.824, 18.517);
    path_16.cubicTo(
      106.824,
      18.517,
      109.494,
      24.887,
      112.364,
      28.826999999999998,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(116.504, 11.697);
    path_17.cubicTo(
      118.884,
      13.786999999999999,
      112.494,
      19.877,
      110.394,
      19.467,
    );
    path_17.cubicTo(
      108.29400000000001,
      19.057,
      103.854,
      12.876999999999999,
      103.54400000000001,
      11.126999999999999,
    );
    path_17.cubicTo(
      103.24400000000001,
      9.376999999999999,
      111.114,
      6.956999999999999,
      116.50400000000002,
      11.697,
    );
    path_17.close();
    path_17.moveTo(109.58500000000001, 33.667);
    path_17.cubicTo(
      110.11500000000001,
      31.457,
      105.28500000000001,
      14.397000000000002,
      101.09500000000001,
      14.207,
    );
    path_17.cubicTo(
      96.90500000000002,
      14.017000000000001,
      94.555,
      27.247,
      98.59500000000001,
      32.307,
    );
    path_17.cubicTo(
      102.63500000000002,
      37.377,
      109.29500000000002,
      34.877,
      109.58500000000001,
      33.667,
    );
    path_17.close();
    path_17.moveTo(27.155, 86.837);
    path_17.cubicTo(28.045, 87.057, 25.215, 74.047, 22.555, 74.047);
    path_17.cubicTo(
      19.905,
      74.047,
      18.365,
      84.67699999999999,
      27.155,
      86.83699999999999,
    );
    path_17.close();
    path_17.moveTo(25.214000000000002, 72.90700000000001);
    path_17.cubicTo(
      24.874000000000002,
      70.48700000000001,
      30.374000000000002,
      70.04700000000001,
      32.804,
      72.70700000000001,
    );
    path_17.cubicTo(35.234, 75.367, 35.714, 78.927, 35.714, 79.637);
    path_17.cubicTo(35.714, 80.337, 26.514, 78.157, 25.214, 72.907);
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(127.205, 50.687);
    path_18.cubicTo(
      127.205,
      50.687,
      124.495,
      52.446999999999996,
      115.795,
      51.306999999999995,
    );
    path_18.cubicTo(
      107.095,
      50.166999999999994,
      101.035,
      42.907,
      99.565,
      40.266999999999996,
    );
    path_18.cubicTo(
      98.105,
      37.617,
      114.035,
      37.196999999999996,
      127.205,
      50.687,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(103.114, 40.877);
    path_19.cubicTo(
      102.34400000000001,
      37.737,
      108.09400000000001,
      33.387,
      112.804,
      31.997,
    );
    path_19.cubicTo(
      117.514,
      30.597,
      123.214,
      39.457,
      125.45400000000001,
      43.907,
    );
    path_19.cubicTo(
      127.69400000000002,
      48.35699999999999,
      127.474,
      49.456999999999994,
      127.20400000000001,
      50.687,
    );
    path_19.cubicTo(
      126.93400000000001,
      51.907,
      106.10400000000001,
      53.047,
      103.114,
      40.876999999999995,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6416111, size.height * 0.3747899),
      Offset(size.width * 0.6370389, size.height * 0.2305145),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(121.034, 51.367);
    path_20.cubicTo(
      121.034,
      51.367,
      117.974,
      40.06699999999999,
      111.09400000000001,
      37.81699999999999,
    );
    path_20.cubicTo(
      104.224,
      35.56699999999999,
      103.364,
      41.766999999999996,
      103.364,
      41.766999999999996,
    );
    path_20.cubicTo(
      103.364,
      41.766999999999996,
      106.244,
      50.67699999999999,
      121.034,
      51.367,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(126.354, 45.807);
    path_21.cubicTo(126.354, 45.807, 121.874, 47.237, 118.484, 44.137);
    path_21.cubicTo(
      115.08399999999999,
      41.037,
      111.66399999999999,
      35.917,
      111.374,
      35.177,
    );
    path_21.cubicTo(
      111.08399999999999,
      34.437,
      111.564,
      31.377,
      115.624,
      32.516999999999996,
    );
    path_21.cubicTo(
      119.69399999999999,
      33.666999999999994,
      124.764,
      41.876999999999995,
      126.354,
      45.806999999999995,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(119.125, 46.407);
    path_22.cubicTo(
      119.125,
      46.407,
      119.035,
      40.956999999999994,
      113.625,
      39.137,
    );
    path_22.cubicTo(113.625, 39.137, 116.075, 43.127, 119.125, 46.407);
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(121.974, 38.197);
    path_23.cubicTo(
      123.23400000000001,
      40.417,
      116.81400000000001,
      40.507000000000005,
      114.034,
      38.467000000000006,
    );
    path_23.cubicTo(
      111.26400000000001,
      36.42700000000001,
      111.054,
      32.91700000000001,
      113.414,
      32.307,
    );
    path_23.cubicTo(115.764, 31.707, 120.374, 35.377, 121.974, 38.197);
    path_23.close();
    path_23.moveTo(117.944, 50.577000000000005);
    path_23.cubicTo(
      119.364,
      50.697,
      116.56400000000001,
      40.907000000000004,
      111.074,
      40.38700000000001,
    );
    path_23.cubicTo(
      105.584,
      39.867000000000004,
      104.874,
      44.107000000000006,
      105.194,
      44.787000000000006,
    );
    path_23.cubicTo(
      105.514,
      45.467000000000006,
      110.254,
      49.947,
      117.944,
      50.577000000000005,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(154.234, 50.227);
    path_24.cubicTo(
      164.654,
      54.706999999999994,
      146.334,
      67.03699999999999,
      134.334,
      62.647,
    );
    path_24.cubicTo(122.334, 58.257, 131.554, 40.467, 154.234, 50.227);
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8684667, size.height * 0.4256812),
      Offset(size.width * 0.7201056, size.height * 0.3836594),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(156.255, 56.577);
    path_25.cubicTo(
      158.125,
      52.397,
      149.615,
      47.537,
      138.715,
      49.836999999999996,
    );
    path_25.cubicTo(
      127.815,
      52.13699999999999,
      129.345,
      58.016999999999996,
      129.345,
      58.016999999999996,
    );
    path_25.cubicTo(
      129.345,
      58.016999999999996,
      129.665,
      63.477,
      141.775,
      63.497,
    );
    path_25.cubicTo(153.875, 63.517, 156.255, 56.577, 156.255, 56.577);
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = GameColors.islandPainterColor19.withValues(alpha: 1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(71.404, 92.577);
    path_26.cubicTo(
      81.28399999999999,
      96.827,
      63.913999999999994,
      108.517,
      52.53399999999999,
      104.357,
    );
    path_26.cubicTo(
      41.15399999999999,
      100.197,
      49.90399999999999,
      83.31700000000001,
      71.404,
      92.577,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4077278, size.height * 0.7293333),
      Offset(size.width * 0.2670611, size.height * 0.6894928),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(73.324, 98.597);
    path_27.cubicTo(
      75.094,
      94.637,
      67.03399999999999,
      90.02699999999999,
      56.694,
      92.207,
    );
    path_27.cubicTo(46.364000000000004, 94.387, 47.804, 99.967, 47.804, 99.967);
    path_27.cubicTo(
      47.804,
      99.967,
      48.114000000000004,
      105.137,
      59.584,
      105.157,
    );
    path_27.cubicTo(
      71.06400000000001,
      105.17699999999999,
      73.324,
      98.597,
      73.324,
      98.597,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = GameColors.islandPainterColor13.withValues(alpha: 1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(160.685, 65.027);
    path_28.cubicTo(
      166.975,
      68.427,
      159.665,
      89.697,
      127.20500000000001,
      100.687,
    );
    path_28.cubicTo(
      94.745,
      111.687,
      80.84500000000001,
      104.597,
      78.75500000000001,
      102.977,
    );
    path_28.cubicTo(
      76.67500000000001,
      101.357,
      84.185,
      89.857,
      65.17500000000001,
      86.827,
    );
    path_28.cubicTo(
      46.165000000000006,
      83.797,
      40.18500000000002,
      78.207,
      38.80500000000001,
      74.037,
    );
    path_28.cubicTo(
      37.425000000000004,
      69.867,
      53.39500000000001,
      74.357,
      78.75500000000001,
      68.777,
    );
    path_28.cubicTo(
      104.11500000000001,
      63.197,
      99.85500000000002,
      50.287000000000006,
      106.81500000000001,
      51.397000000000006,
    );
    path_28.cubicTo(
      113.775,
      52.507000000000005,
      121.89500000000001,
      67.447,
      139.375,
      66.837,
    );
    path_28.cubicTo(
      156.855,
      66.23700000000001,
      160.685,
      65.027,
      160.685,
      65.027,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(146.014, 91.647);
    path_29.cubicTo(
      163.43400000000003,
      79.387,
      136.424,
      68.617,
      109.23400000000001,
      77.62700000000001,
    );
    path_29.cubicTo(
      82.04400000000001,
      86.63700000000001,
      83.29400000000001,
      103.697,
      83.59400000000001,
      105.15700000000001,
    );
    path_29.cubicTo(
      83.88400000000001,
      106.617,
      117.07400000000001,
      111.99700000000001,
      146.014,
      91.647,
    );
    path_29.close();
    path_29.moveTo(94.19500000000001, 62.70700000000001);
    path_29.cubicTo(
      98.605,
      62.607000000000006,
      82.415,
      82.99700000000001,
      69.42500000000001,
      85.21700000000001,
    );
    path_29.cubicTo(
      56.43500000000001,
      87.43700000000001,
      43.11500000000001,
      75.757,
      42.33500000000001,
      73.96700000000001,
    );
    path_29.cubicTo(
      41.55500000000001,
      72.16700000000002,
      61.01500000000001,
      75.91700000000002,
      94.19500000000001,
      62.707000000000015,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(127.365, 66.037);
    path_30.cubicTo(
      131.495,
      67.31700000000001,
      117.88499999999999,
      74.857,
      110.285,
      72.837,
    );
    path_30.cubicTo(
      102.685,
      70.81700000000001,
      114.13499999999999,
      61.92700000000001,
      127.365,
      66.037,
    );
    path_30.close();
    path_30.moveTo(97.145, 77.04700000000001);
    path_30.cubicTo(100.365, 77.647, 93.615, 81.177, 91.015, 81.57700000000001);
    path_30.cubicTo(
      88.405,
      81.98700000000001,
      91.235,
      75.94700000000002,
      97.145,
      77.04700000000001,
    );
    path_30.close();
    path_30.moveTo(45.583999999999996, 84.21700000000001);
    path_30.cubicTo(
      50.044,
      89.34700000000001,
      42.693999999999996,
      88.05700000000002,
      41.153999999999996,
      84.21700000000001,
    );
    path_30.cubicTo(
      39.623999999999995,
      80.37700000000001,
      44.083999999999996,
      82.48700000000001,
      45.583999999999996,
      84.21700000000001,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = GameColors.islandPainterColor26.withValues(alpha: 1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(96.344, 127.447);
    path_31.cubicTo(
      99.714,
      126.12700000000001,
      82.374,
      119.747,
      56.81399999999999,
      113.857,
    );
    path_31.cubicTo(
      31.243999999999993,
      107.967,
      24.743999999999993,
      109.577,
      23.903999999999996,
      109.977,
    );
    path_31.cubicTo(
      23.063999999999997,
      110.387,
      39.523999999999994,
      131.997,
      96.344,
      127.447,
    );
    path_31.close();
    path_31.moveTo(68.50399999999999, 64.96700000000001);
    path_31.cubicTo(
      81.13399999999999,
      61.12700000000001,
      63.87399999999999,
      58.87700000000001,
      47.733999999999995,
      58.82700000000001,
    );
    path_31.cubicTo(
      31.593999999999994,
      58.777000000000015,
      29.863999999999994,
      60.387000000000015,
      29.863999999999994,
      60.387000000000015,
    );
    path_31.cubicTo(
      29.863999999999994,
      60.387000000000015,
      41.483999999999995,
      73.17700000000002,
      68.50399999999999,
      64.96700000000001,
    );
    path_31.close();
    path_31.moveTo(171.724, 94.76700000000001);
    path_31.cubicTo(
      173.284,
      92.147,
      167.834,
      98.12700000000001,
      141.714,
      105.647,
    );
    path_31.cubicTo(115.584, 113.177, 92.464, 115.667, 92.464, 115.667);
    path_31.cubicTo(92.464, 115.667, 109.304, 127.827, 136.984, 119.647);
    path_31.cubicTo(
      164.674,
      111.46700000000001,
      171.72400000000002,
      94.76700000000001,
      171.72400000000002,
      94.76700000000001,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(38.024, 83.337);
    path_32.cubicTo(38.024, 83.337, 36.434, 84.637, 33.564, 83.727);
    path_32.cubicTo(
      30.694000000000003,
      82.81700000000001,
      29.054000000000002,
      80.777,
      28.904,
      80.217,
    );
    path_32.cubicTo(28.764, 79.657, 27.994, 77.967, 27.054, 77.047);
    path_32.cubicTo(
      26.113999999999997,
      76.127,
      24.843999999999998,
      74.317,
      24.843999999999998,
      74.317,
    );
    path_32.lineTo(25.953999999999997, 76.437);
    path_32.cubicTo(
      25.953999999999997,
      76.437,
      28.043999999999997,
      77.527,
      28.784,
      81.837,
    );
    path_32.cubicTo(28.784, 81.837, 30.194, 83.357, 33.954, 84.20700000000001);
    path_32.cubicTo(37.714, 85.06700000000001, 38.024, 83.337, 38.024, 83.337);
    path_32.close();
    path_32.moveTo(121.275, 45.747);
    path_32.cubicTo(
      121.275,
      45.747,
      119.605,
      46.407,
      119.36500000000001,
      46.407,
    );
    path_32.cubicTo(
      119.12500000000001,
      46.407,
      119.08500000000001,
      43.607,
      116.95500000000001,
      41.626999999999995,
    );
    path_32.cubicTo(
      114.82500000000002,
      39.647,
      113.61500000000001,
      39.13699999999999,
      113.61500000000001,
      39.13699999999999,
    );
    path_32.cubicTo(
      113.61500000000001,
      39.13699999999999,
      112.01500000000001,
      38.04699999999999,
      110.935,
      37.766999999999996,
    );
    path_32.cubicTo(
      110.935,
      37.766999999999996,
      112.325,
      37.946999999999996,
      113.925,
      38.99699999999999,
    );
    path_32.cubicTo(
      115.52499999999999,
      40.04699999999999,
      117.74499999999999,
      39.586999999999996,
      120.02499999999999,
      45.06699999999999,
    );
    path_32.cubicTo(
      120.035,
      45.07699999999999,
      120.425,
      45.81699999999999,
      121.27499999999999,
      45.74699999999999,
    );
    path_32.close();
    path_32.moveTo(115.884, 30.576999999999998);
    path_32.cubicTo(
      115.884,
      30.576999999999998,
      113.144,
      29.956999999999997,
      112.354,
      28.816999999999997,
    );
    path_32.cubicTo(
      112.354,
      28.816999999999997,
      112.224,
      20.776999999999997,
      106.814,
      18.506999999999998,
    );
    path_32.lineTo(103.67399999999999, 13.246999999999998);
    path_32.cubicTo(
      103.67399999999999,
      13.246999999999998,
      107.154,
      17.276999999999997,
      108.53399999999999,
      18.287,
    );
    path_32.cubicTo(
      109.91399999999999,
      19.297,
      112.00399999999999,
      22.366999999999997,
      112.814,
      25.096999999999998,
    );
    path_32.cubicTo(
      113.624,
      27.836999999999996,
      115.88399999999999,
      30.576999999999998,
      115.88399999999999,
      30.576999999999998,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(127.985, 40.737);
    path_33.cubicTo(
      131.665,
      41.787,
      124.965,
      45.247,
      122.515,
      44.397000000000006,
    );
    path_33.cubicTo(
      120.065,
      43.537000000000006,
      124.465,
      39.73700000000001,
      127.985,
      40.73700000000001,
    );
    path_33.close();
    path_33.moveTo(155.244, 71.607);
    path_33.cubicTo(157.294, 73.027, 154.944, 77.897, 149.404, 77.047);
    path_33.cubicTo(143.874, 76.197, 153.164, 70.167, 155.244, 71.607);
    path_33.close();
    path_33.moveTo(56.735, 78.156);
    path_33.cubicTo(60.195, 80.16600000000001, 56.245, 80.436, 54.745, 79.546);
    path_33.cubicTo(
      53.245,
      78.656,
      55.904999999999994,
      77.66600000000001,
      56.735,
      78.156,
    );
    path_33.close();
    path_33.moveTo(60.415, 77.70700000000001);
    path_33.cubicTo(
      61.315,
      78.727,
      59.315,
      78.96700000000001,
      58.394999999999996,
      77.917,
    );
    path_33.cubicTo(
      57.464999999999996,
      76.857,
      59.05499999999999,
      76.157,
      60.415,
      77.70700000000001,
    );
    path_33.close();
    path_33.moveTo(43.434, 99.95700000000001);
    path_33.cubicTo(45.254, 99.477, 36.504, 94.417, 33.144, 94.93700000000001);
    path_33.cubicTo(
      29.773999999999997,
      95.45700000000001,
      38.074,
      101.36700000000002,
      43.434,
      99.95700000000001,
    );
    path_33.close();
    path_33.moveTo(80.215, 91.93700000000001);
    path_33.cubicTo(
      82.455,
      92.84700000000001,
      79.14500000000001,
      94.09700000000001,
      77.495,
      93.33700000000002,
    );
    path_33.cubicTo(
      75.855,
      92.58700000000002,
      77.215,
      90.71700000000001,
      80.215,
      91.93700000000001,
    );
    path_33.close();
    path_33.moveTo(147.464, 77.56600000000002);
    path_33.cubicTo(
      154.114,
      80.89600000000002,
      146.934,
      86.63600000000002,
      140.044,
      82.00600000000001,
    );
    path_33.cubicTo(
      133.16400000000002,
      77.37600000000002,
      143.69400000000002,
      75.67600000000002,
      147.464,
      77.56600000000002,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = GameColors.islandPainterColor49.withValues(alpha: 1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(100.165, 70.207);
    path_34.cubicTo(
      101.20500000000001,
      65.78699999999999,
      96.295,
      66.72699999999999,
      95.73500000000001,
      70.207,
    );
    path_34.cubicTo(
      95.16500000000002,
      73.687,
      99.52500000000002,
      72.94699999999999,
      100.16500000000002,
      70.207,
    );
    path_34.close();
    path_34.moveTo(17.595000000000013, 66.707);
    path_34.cubicTo(
      17.955000000000013,
      67.41699999999999,
      16.375000000000014,
      68.567,
      15.025000000000013,
      66.707,
    );
    path_34.cubicTo(
      13.665000000000013,
      64.847,
      17.24500000000001,
      66.00699999999999,
      17.595000000000013,
      66.707,
    );
    path_34.close();
    path_34.moveTo(89.82500000000002, 93.238);
    path_34.cubicTo(
      90.99500000000002,
      96.468,
      86.30500000000002,
      95.378,
      85.08500000000002,
      93.238,
    );
    path_34.cubicTo(
      83.87500000000003,
      91.098,
      88.98500000000003,
      90.928,
      89.82500000000002,
      93.238,
    );
    path_34.close();
    path_34.moveTo(98.45500000000001, 91.287);
    path_34.cubicTo(
      98.25500000000001,
      92.167,
      96.09500000000001,
      92.81700000000001,
      95.59500000000001,
      90.417,
    );
    path_34.cubicTo(
      95.09500000000001,
      88.017,
      98.95500000000001,
      89.06700000000001,
      98.45500000000001,
      91.287,
    );
    path_34.close();
    path_34.moveTo(94.924, 94.748);
    path_34.cubicTo(
      95.96400000000001,
      95.50800000000001,
      94.974,
      96.39800000000001,
      93.20400000000001,
      95.998,
    );
    path_34.cubicTo(
      91.45400000000001,
      95.608,
      94.07400000000001,
      94.128,
      94.924,
      94.748,
    );
    path_34.close();
    path_34.moveTo(117.98500000000001, 100.557);
    path_34.cubicTo(
      120.04500000000002,
      101.997,
      113.61500000000001,
      105.077,
      111.58500000000001,
      102.797,
    );
    path_34.cubicTo(
      109.56500000000001,
      100.517,
      113.62500000000001,
      97.517,
      117.98500000000001,
      100.557,
    );
    path_34.close();
    path_34.moveTo(122.03500000000001, 83.177);
    path_34.cubicTo(
      123.34500000000001,
      84.947,
      118.525,
      83.977,
      116.805,
      83.177,
    );
    path_34.cubicTo(
      115.08500000000001,
      82.37700000000001,
      119.92500000000001,
      80.32700000000001,
      122.03500000000001,
      83.177,
    );
    path_34.close();
    path_34.moveTo(35.82500000000002, 70.807);
    path_34.cubicTo(
      36.865000000000016,
      72.917,
      34.585000000000015,
      72.497,
      33.91500000000002,
      70.807,
    );
    path_34.cubicTo(
      33.255000000000024,
      69.107,
      35.37500000000002,
      69.877,
      35.82500000000002,
      70.807,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(100.514, 96.548);
    path_35.cubicTo(
      102.154,
      98.08800000000001,
      96.28399999999999,
      100.128,
      94.47399999999999,
      99.218,
    );
    path_35.cubicTo(
      92.66399999999999,
      98.308,
      97.30399999999999,
      93.53800000000001,
      100.514,
      96.548,
    );
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(115.665, 125.217);
    path_36.cubicTo(
      118.855,
      123.007,
      110.75500000000001,
      115.517,
      104.42500000000001,
      115.947,
    );
    path_36.cubicTo(
      98.08500000000001,
      116.37700000000001,
      92.47500000000001,
      121.417,
      91.44500000000001,
      124.62700000000001,
    );
    path_36.cubicTo(
      90.415,
      127.837,
      106.165,
      131.817,
      115.665,
      125.21700000000001,
    );
    path_36.close();
    path_36.moveTo(90.54400000000001, 117.197);
    path_36.cubicTo(
      92.144,
      117.647,
      89.40400000000001,
      124.887,
      79.284,
      123.56700000000001,
    );
    path_36.cubicTo(
      69.164,
      122.23700000000001,
      68.974,
      117.727,
      68.62400000000001,
      117.197,
    );
    path_36.cubicTo(
      68.27400000000002,
      116.667,
      79.87400000000001,
      114.187,
      90.54400000000001,
      117.197,
    );
    path_36.close();
    path_36.moveTo(43.01400000000001, 121.677);
    path_36.cubicTo(
      49.244000000000014,
      121.62700000000001,
      44.83400000000001,
      111.65700000000001,
      36.35400000000001,
      108.947,
    );
    path_36.cubicTo(
      27.874000000000013,
      106.23700000000001,
      24.04400000000001,
      110.647,
      23.504000000000012,
      112.247,
    );
    path_36.cubicTo(
      22.97400000000001,
      113.847,
      28.004000000000012,
      121.787,
      43.01400000000001,
      121.67699999999999,
    );
    path_36.close();
    path_36.moveTo(27.32500000000001, 104.227);
    path_36.cubicTo(
      29.05500000000001,
      107.537,
      20.20500000000001,
      109.12700000000001,
      17.955000000000013,
      103.617,
    );
    path_36.cubicTo(
      15.705000000000013,
      98.09700000000001,
      24.42500000000001,
      98.68700000000001,
      27.32500000000001,
      104.227,
    );
    path_36.close();
    path_36.moveTo(159.40500000000003, 98.397);
    path_36.cubicTo(
      163.38500000000002,
      100.04700000000001,
      162.44500000000002,
      105.667,
      155.96500000000003,
      108.307,
    );
    path_36.cubicTo(
      149.48500000000004,
      110.947,
      145.89500000000004,
      106.137,
      145.85500000000002,
      104.417,
    );
    path_36.cubicTo(
      145.81500000000003,
      102.697,
      155.32500000000002,
      96.697,
      159.40500000000003,
      98.397,
    );
    path_36.close();
    path_36.moveTo(90.01400000000002, 130.197);
    path_36.cubicTo(
      92.86400000000002,
      128.77700000000002,
      86.18400000000003,
      124.807,
      81.96400000000003,
      127.017,
    );
    path_36.cubicTo(
      77.74400000000003,
      129.227,
      84.91400000000003,
      132.737,
      90.01400000000002,
      130.197,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(45.794, 117.947);
    path_37.cubicTo(
      45.794,
      117.947,
      44.934,
      120.967,
      36.193999999999996,
      119.727,
    );
    path_37.cubicTo(
      27.453999999999994,
      118.48700000000001,
      24.543999999999997,
      113.59700000000001,
      24.233999999999995,
      112.947,
    );
    path_37.cubicTo(
      23.923999999999996,
      112.297,
      24.663999999999994,
      110.547,
      24.663999999999994,
      110.547,
    );
    path_37.cubicTo(
      24.663999999999994,
      110.547,
      23.283999999999995,
      111.957,
      23.113999999999994,
      112.887,
    );
    path_37.cubicTo(
      22.943999999999992,
      113.81700000000001,
      26.433999999999994,
      118.667,
      34.053999999999995,
      121.437,
    );
    path_37.cubicTo(
      41.663999999999994,
      124.207,
      45.75399999999999,
      122.907,
      46.31399999999999,
      121.437,
    );
    path_37.cubicTo(
      46.88399999999999,
      119.967,
      45.79399999999999,
      117.947,
      45.79399999999999,
      117.947,
    );
    path_37.close();
    path_37.moveTo(27.323999999999998, 104.227);
    path_37.cubicTo(
      27.323999999999998,
      104.227,
      27.153999999999996,
      107.467,
      22.214,
      106.227,
    );
    path_37.cubicTo(
      17.273999999999997,
      104.98700000000001,
      17.683999999999997,
      101.31700000000001,
      17.683999999999997,
      101.31700000000001,
    );
    path_37.cubicTo(
      17.683999999999997,
      101.31700000000001,
      16.534,
      105.32700000000001,
      21.823999999999998,
      107.23700000000001,
    );
    path_37.cubicTo(
      27.113999999999997,
      109.147,
      28.374,
      106.337,
      27.323999999999998,
      104.227,
    );
    path_37.close();
    path_37.moveTo(89.814, 117.007);
    path_37.cubicTo(
      91.854,
      119.327,
      87.564,
      122.93700000000001,
      79.94399999999999,
      123.077,
    );
    path_37.cubicTo(
      72.33399999999999,
      123.217,
      69.04399999999998,
      117.737,
      69.94399999999999,
      116.657,
    );
    path_37.cubicTo(
      69.94399999999999,
      116.657,
      68.64399999999999,
      116.97699999999999,
      68.39399999999999,
      117.337,
    );
    path_37.cubicTo(
      68.13399999999999,
      117.687,
      70.844,
      123.45700000000001,
      80.25399999999999,
      124.107,
    );
    path_37.cubicTo(
      89.654,
      124.757,
      91.92399999999999,
      119.117,
      91.624,
      118.007,
    );
    path_37.cubicTo(
      91.39399999999999,
      117.15700000000001,
      89.814,
      117.007,
      89.814,
      117.007,
    );
    path_37.close();
    path_37.moveTo(89.68499999999999, 127.87700000000001);
    path_37.cubicTo(
      89.68499999999999,
      127.87700000000001,
      92.32499999999999,
      130.70700000000002,
      85.95499999999998,
      130.797,
    );
    path_37.cubicTo(
      79.76499999999999,
      130.887,
      81.20499999999998,
      127.53699999999999,
      81.20499999999998,
      127.53699999999999,
    );
    path_37.cubicTo(
      81.20499999999998,
      127.53699999999999,
      80.57499999999999,
      128.057,
      80.53499999999998,
      128.78699999999998,
    );
    path_37.cubicTo(
      80.49499999999998,
      129.51699999999997,
      83.04499999999999,
      131.56699999999998,
      86.95499999999998,
      131.307,
    );
    path_37.cubicTo(
      90.85499999999999,
      131.03699999999998,
      92.28499999999998,
      129.617,
      89.68499999999999,
      127.87699999999998,
    );
    path_37.close();
    path_37.moveTo(115.23399999999998, 121.26700000000001);
    path_37.cubicTo(
      115.23399999999998,
      121.26700000000001,
      118.60399999999998,
      126.81700000000001,
      105.80399999999997,
      127.537,
    );
    path_37.cubicTo(
      93.00399999999998,
      128.257,
      92.14399999999998,
      123.177,
      92.14399999999998,
      123.177,
    );
    path_37.cubicTo(
      92.14399999999998,
      123.177,
      91.39399999999998,
      123.34700000000001,
      91.12399999999998,
      125.387,
    );
    path_37.cubicTo(
      90.80399999999999,
      127.797,
      98.51399999999998,
      130.367,
      108.02399999999997,
      128.787,
    );
    path_37.cubicTo(
      117.33399999999997,
      127.23700000000001,
      118.23399999999998,
      125.167,
      115.23399999999997,
      121.26700000000001,
    );
    path_37.close();
    path_37.moveTo(160.914, 99.43800000000002);
    path_37.cubicTo(
      163.45399999999998,
      103.57700000000001,
      158.134,
      107.43800000000002,
      152.594,
      107.52800000000002,
    );
    path_37.cubicTo(
      147.254,
      107.61800000000002,
      146.064,
      105.23700000000002,
      146.064,
      105.23700000000002,
    );
    path_37.cubicTo(
      146.064,
      105.23700000000002,
      146.064,
      110.71800000000002,
      154.914,
      109.88800000000002,
    );
    path_37.cubicTo(
      162.164,
      109.20800000000001,
      163.714,
      101.75700000000002,
      160.914,
      99.43800000000002,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(69.855, 47.437);
    path_38.cubicTo(
      78.97500000000001,
      44.027,
      65.14500000000001,
      37.736999999999995,
      46.485,
      39.196999999999996,
    );
    path_38.cubicTo(
      27.825,
      40.666999999999994,
      27.185,
      48.477,
      27.445,
      49.53699999999999,
    );
    path_38.cubicTo(
      27.695,
      50.60699999999999,
      44.485,
      56.92699999999999,
      69.85499999999999,
      47.43699999999999,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(57.015, 50.317);
    path_39.cubicTo(60.675, 49.357, 54.585, 41.487, 43.255, 43.797);
    path_39.cubicTo(
      31.925000000000004,
      46.107,
      32.695,
      50.867,
      32.815000000000005,
      50.897,
    );
    path_39.cubicTo(32.925000000000004, 50.927, 41.045, 54.527, 57.015, 50.317);
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(85.545, 30.527);
    path_40.cubicTo(
      79.315,
      30.217000000000002,
      78.655,
      26.807000000000002,
      79.83500000000001,
      26.067,
    );
    path_40.cubicTo(81.025, 25.327, 69.465, 27.477, 68.805, 18.887);
    path_40.cubicTo(68.275, 12.167000000000002, 77.665, 11.427, 77.665, 11.427);
    path_40.cubicTo(77.665, 11.427, 68.135, 11.557, 67.545, 17.997);
    path_40.cubicTo(
      66.94500000000001,
      24.437,
      74.205,
      26.487000000000002,
      74.205,
      26.487000000000002,
    );
    path_40.cubicTo(
      74.205,
      26.487000000000002,
      72.735,
      29.897000000000002,
      60.905,
      30.577,
    );
    path_40.cubicTo(
      51.535000000000004,
      31.117,
      50.885000000000005,
      27.467000000000002,
      50.945,
      27.397000000000002,
    );
    path_40.cubicTo(
      60.905,
      15.697000000000003,
      44.885,
      13.277000000000003,
      45.775,
      18.597,
    );
    path_40.cubicTo(
      46.665,
      23.917,
      41.045,
      21.487000000000002,
      37.935,
      20.197000000000003,
    );
    path_40.cubicTo(
      34.975,
      18.957000000000004,
      31.815,
      21.007,
      31.515,
      21.207000000000004,
    );
    path_40.cubicTo(
      31.935000000000002,
      21.067000000000004,
      37.425,
      19.317000000000004,
      38.605000000000004,
      22.627000000000002,
    );
    path_40.cubicTo(
      39.825,
      26.057000000000002,
      37.665000000000006,
      27.027,
      37.665000000000006,
      27.027,
    );
    path_40.cubicTo(
      37.665000000000006,
      27.027,
      42.33500000000001,
      26.467000000000002,
      41.675000000000004,
      31.387,
    );
    path_40.cubicTo(
      41.01500000000001,
      36.297,
      35.745000000000005,
      35.427,
      35.745000000000005,
      35.427,
    );
    path_40.cubicTo(
      35.745000000000005,
      35.427,
      37.33500000000001,
      32.187,
      34.955000000000005,
      30.436999999999998,
    );
    path_40.cubicTo(
      32.565000000000005,
      28.686999999999998,
      30.225000000000005,
      29.296999999999997,
      30.225000000000005,
      29.296999999999997,
    );
    path_40.cubicTo(
      30.225000000000005,
      29.296999999999997,
      35.12500000000001,
      29.156999999999996,
      35.33500000000001,
      33.056999999999995,
    );
    path_40.cubicTo(
      35.53500000000001,
      36.967,
      31.495000000000008,
      40.526999999999994,
      27.81500000000001,
      40.666999999999994,
    );
    path_40.cubicTo(
      24.14500000000001,
      40.806999999999995,
      24.47500000000001,
      36.806999999999995,
      24.47500000000001,
      36.806999999999995,
    );
    path_40.lineTo(24.41500000000001, 36.806999999999995);
    path_40.cubicTo(
      24.29500000000001,
      38.92699999999999,
      24.56500000000001,
      41.64699999999999,
      25.43500000000001,
      45.13699999999999,
    );
    path_40.cubicTo(
      25.43500000000001,
      45.13699999999999,
      34.83500000000001,
      33.946999999999996,
      54.90500000000001,
      32.516999999999996,
    );
    path_40.cubicTo(
      59.11500000000001,
      32.217,
      63.105000000000004,
      31.996999999999996,
      66.775,
      31.826999999999995,
    );
    path_40.cubicTo(
      80.545,
      31.196999999999996,
      89.815,
      31.376999999999995,
      89.815,
      31.376999999999995,
    );
    path_40.cubicTo(
      89.815,
      31.376999999999995,
      90.115,
      30.936999999999994,
      90.295,
      30.356999999999996,
    );
    path_40.cubicTo(
      88.965,
      30.536999999999995,
      87.375,
      30.616999999999997,
      85.545,
      30.526999999999997,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1355167, size.height * 0.2049638),
      Offset(size.width * 0.5016389, size.height * 0.2049638),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(82.834, 32.597);
    path_41.cubicTo(
      82.834,
      32.597,
      80.51400000000001,
      36.067,
      69.59400000000001,
      39.127,
    );
    path_41.cubicTo(
      58.67400000000001,
      42.187000000000005,
      47.79400000000001,
      36.637,
      44.71400000000001,
      34.237,
    );
    path_41.cubicTo(
      41.62400000000001,
      31.837000000000003,
      60.344000000000015,
      23.257,
      82.834,
      32.597,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(49.235, 33.177);
    path_42.cubicTo(46.725, 29.837, 51.355, 21.747, 56.245, 17.707);
    path_42.cubicTo(61.135, 13.657, 72.395, 21.287, 77.315, 25.437);
    path_42.cubicTo(
      82.235,
      29.587000000000003,
      82.52499999999999,
      31.007,
      82.825,
      32.607,
    );
    path_42.cubicTo(83.125, 34.207, 58.965, 46.107, 49.235, 33.177);
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3857833, size.height * 0.2882101),
      Offset(size.width * 0.3242333, size.height * 0.1198261),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(75.855, 36.547);
    path_43.cubicTo(
      75.855,
      36.547,
      66.485,
      24.677,
      57.175000000000004,
      25.486999999999995,
    );
    path_43.cubicTo(
      47.865,
      26.296999999999993,
      49.995000000000005,
      34.096999999999994,
      49.995000000000005,
      34.096999999999994,
    );
    path_43.cubicTo(
      49.995000000000005,
      34.096999999999994,
      57.925000000000004,
      43.227,
      75.855,
      36.547,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(79.345, 27.238);
    path_44.cubicTo(79.345, 27.238, 74.755, 31.208, 69.145, 29.247999999999998);
    path_44.cubicTo(
      63.535,
      27.287999999999997,
      56.875,
      22.947999999999997,
      56.154999999999994,
      22.208,
    );
    path_44.cubicTo(
      55.434999999999995,
      21.477999999999998,
      54.45499999999999,
      17.598,
      59.855,
      16.898,
    );
    path_44.cubicTo(65.265, 16.188, 75.465, 23.368, 79.345, 27.238);
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(71.064, 31.617);
    path_45.cubicTo(71.064, 31.617, 68.184, 25.187, 60.843999999999994, 25.777);
    path_45.cubicTo(
      60.843999999999994,
      25.777,
      65.764,
      29.267000000000003,
      71.064,
      31.617,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(70.284, 20.418);
    path_46.cubicTo(
      72.914,
      22.418,
      65.32400000000001,
      25.788,
      60.99400000000001,
      24.768,
    );
    path_46.cubicTo(
      56.66400000000001,
      23.758,
      54.644000000000005,
      19.688000000000002,
      57.13400000000001,
      17.768,
    );
    path_46.cubicTo(59.614000000000004, 15.858, 66.944, 17.878, 70.284, 20.418);
    path_46.close();
    path_46.moveTo(71.775, 37.177);
    path_46.cubicTo(
      73.525,
      36.597,
      65.235,
      26.387,
      58.44500000000001,
      28.557000000000002,
    );
    path_46.cubicTo(
      51.665000000000006,
      30.727000000000004,
      52.97500000000001,
      36.117000000000004,
      53.68500000000001,
      36.767,
    );
    path_46.cubicTo(
      54.415000000000006,
      37.407000000000004,
      62.32500000000001,
      40.317,
      71.775,
      37.177,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(73.284, 29.737);
    path_47.cubicTo(73.284, 29.737, 71.644, 31.366999999999997, 71.354, 31.487);
    path_47.cubicTo(
      71.064,
      31.607,
      69.594,
      28.296999999999997,
      66.064,
      27.026999999999997,
    );
    path_47.cubicTo(
      62.53399999999999,
      25.756999999999998,
      60.843999999999994,
      25.766999999999996,
      60.843999999999994,
      25.766999999999996,
    );
    path_47.cubicTo(
      60.843999999999994,
      25.766999999999996,
      58.39399999999999,
      25.286999999999995,
      56.96399999999999,
      25.496999999999996,
    );
    path_47.cubicTo(
      56.96399999999999,
      25.496999999999996,
      58.71399999999999,
      25.006999999999998,
      61.14399999999999,
      25.446999999999996,
    );
    path_47.cubicTo(
      63.58399999999999,
      25.876999999999995,
      65.984,
      24.206999999999997,
      71.464,
      29.566999999999997,
    );
    path_47.cubicTo(
      71.464,
      29.576999999999998,
      72.304,
      30.246999999999996,
      73.28399999999999,
      29.737,
    );
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(114.825, 95.767);
    path_48.cubicTo(
      113.385,
      94.327,
      128.455,
      89.75699999999999,
      138.905,
      91.327,
    );
    path_48.cubicTo(149.365, 92.907, 124.645, 105.577, 114.825, 95.767);
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(137.664, 90.757);
    path_49.cubicTo(141.214, 86.497, 141.344, 80.427, 139.274, 76.947);
    path_49.cubicTo(137.204, 73.477, 121.494, 71.527, 116.054, 74.887);
    path_49.cubicTo(
      110.604,
      78.247,
      113.464,
      92.06700000000001,
      116.444,
      95.287,
    );
    path_49.cubicTo(
      119.414,
      98.507,
      131.144,
      98.57700000000001,
      137.664,
      90.757,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6920167, size.height * 0.7112609),
      Offset(size.width * 0.7170222, size.height * 0.4818116),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(138.834, 77.217);
    path_50.cubicTo(143.334, 81.887, 126.854, 96.467, 118.874, 90.187);
    path_50.cubicTo(
      110.904,
      83.907,
      114.42399999999999,
      75.767,
      117.11399999999999,
      74.887,
    );
    path_50.cubicTo(
      119.80399999999999,
      74.007,
      133.494,
      71.677,
      138.834,
      77.217,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(138.864, 76.447);
    path_51.cubicTo(139.614, 78.077, 130.354, 82.907, 123.554, 82.687);
    path_51.cubicTo(
      116.754,
      82.467,
      114.45400000000001,
      78.167,
      114.634,
      76.217,
    );
    path_51.cubicTo(
      114.81400000000001,
      74.267,
      119.594,
      73.197,
      126.384,
      73.17699999999999,
    );
    path_51.cubicTo(
      133.184,
      73.157,
      138.334,
      75.297,
      138.864,
      76.44699999999999,
    );
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(138.994, 77.406);
    path_52.cubicTo(
      140.224,
      77.41600000000001,
      141.034,
      83.736,
      138.464,
      88.156,
    );
    path_52.cubicTo(
      135.894,
      92.58600000000001,
      128.954,
      95.766,
      128.274,
      95.766,
    );
    path_52.cubicTo(127.584, 95.766, 125.404, 84.406, 125.404, 83.956);
    path_52.cubicTo(
      125.404,
      83.506,
      132.82399999999998,
      82.796,
      138.994,
      77.406,
    );
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(126.184, 96.146);
    path_53.cubicTo(127.204, 95.876, 125.494, 86.086, 124.374, 84.746);
    path_53.cubicTo(
      123.25399999999999,
      83.40599999999999,
      116.374,
      81.56599999999999,
      114.50399999999999,
      78.15599999999999,
    );
    path_53.cubicTo(
      114.50399999999999,
      78.15599999999999,
      112.83399999999999,
      80.75599999999999,
      113.984,
      87.416,
    );
    path_53.cubicTo(115.124, 94.086, 118.484, 98.166, 126.184, 96.146);
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(129.244, 81.947);
    path_54.cubicTo(129.414, 81.967, 125.744, 84.437, 124.824, 84.747);
    path_54.cubicTo(123.904, 85.057, 120.314, 82.207, 120.314, 82.207);
    path_54.cubicTo(
      120.314,
      82.207,
      123.39399999999999,
      81.137,
      129.244,
      81.94699999999999,
    );
    path_54.close();
    path_54.moveTo(119.754, 82.037);
    path_54.cubicTo(
      119.754,
      82.037,
      118.214,
      81.70700000000001,
      116.834,
      80.727,
    );
    path_54.cubicTo(
      115.45400000000001,
      79.757,
      115.034,
      78.09700000000001,
      115.034,
      78.09700000000001,
    );
    path_54.cubicTo(
      115.034,
      78.09700000000001,
      117.93400000000001,
      81.23700000000001,
      119.754,
      82.037,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(105.785, 102.527);
    path_55.cubicTo(
      108.865,
      102.177,
      116.935,
      105.057,
      109.80499999999999,
      108.017,
    );
    path_55.cubicTo(
      102.66499999999999,
      110.97699999999999,
      98.68499999999999,
      109.747,
      97.26499999999999,
      108.017,
    );
    path_55.cubicTo(
      95.85499999999999,
      106.28699999999999,
      101.54499999999999,
      103.017,
      105.78499999999998,
      102.527,
    );
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(104.885, 106.547);
    path_56.cubicTo(
      108.47500000000001,
      105.167,
      106.605,
      98.207,
      103.955,
      96.807,
    );
    path_56.cubicTo(
      101.30499999999999,
      95.407,
      94.875,
      98.09700000000001,
      94.16499999999999,
      100.627,
    );
    path_56.cubicTo(
      93.445,
      103.157,
      97.365,
      108.907,
      100.51499999999999,
      108.387,
    );
    path_56.cubicTo(
      103.67499999999998,
      107.877,
      104.88499999999999,
      106.547,
      104.88499999999999,
      106.547,
    );
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5531889, size.height * 0.7869710),
      Offset(size.width * 0.5655667, size.height * 0.6734130),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_56, paint56Fill);

    Path path_57 = Path();
    path_57.moveTo(105.475, 98.577);
    path_57.cubicTo(
      106.955,
      100.777,
      102.96499999999999,
      105.217,
      99.10499999999999,
      104.957,
    );
    path_57.cubicTo(
      95.24499999999999,
      104.687,
      94.52499999999999,
      101.66699999999999,
      94.91499999999999,
      100.357,
    );
    path_57.cubicTo(
      95.29499999999999,
      99.047,
      102.755,
      94.547,
      105.475,
      98.577,
    );
    path_57.close();

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_57, paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(103.955, 96.807);
    path_58.cubicTo(104.725, 97.747, 101.825, 101.027, 99.565, 102.087);
    path_58.cubicTo(
      97.30499999999999,
      103.147,
      94.115,
      101.857,
      94.095,
      100.95700000000001,
    );
    path_58.cubicTo(94.085, 100.057, 94.925, 98.73700000000001, 97.985, 97.397);
    path_58.cubicTo(
      101.045,
      96.04700000000001,
      103.715,
      96.507,
      103.955,
      96.807,
    );
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_58, paint58Fill);

    Path path_59 = Path();
    path_59.moveTo(106.235, 104.967);
    path_59.cubicTo(
      105.735,
      106.367,
      103.465,
      107.517,
      102.80499999999999,
      107.387,
    );
    path_59.cubicTo(
      102.13499999999999,
      107.257,
      99.895,
      102.717,
      100.065,
      102.217,
    );
    path_59.cubicTo(
      100.235,
      101.717,
      103.88499999999999,
      98.197,
      104.215,
      97.707,
    );
    path_59.cubicTo(104.545, 97.217, 107.295, 100.387, 106.235, 104.967);
    path_59.close();

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_59, paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(102.065, 107.617);
    path_60.cubicTo(
      102.485,
      107.527,
      100.075,
      103.31700000000001,
      99.535,
      102.917,
    );
    path_60.cubicTo(
      98.99499999999999,
      102.527,
      96.485,
      102.917,
      94.55499999999999,
      102.037,
    );
    path_60.cubicTo(
      94.55499999999999,
      102.037,
      95.55499999999999,
      105.90700000000001,
      97.87499999999999,
      107.29700000000001,
    );
    path_60.cubicTo(
      100.18499999999999,
      108.69700000000002,
      102.06499999999998,
      107.617,
      102.06499999999998,
      107.617,
    );
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_60, paint60Fill);

    Path path_61 = Path();
    path_61.moveTo(100.975, 101.217);
    path_61.cubicTo(
      101.095,
      101.147,
      100.46499999999999,
      103.707,
      100.30499999999999,
      103.697,
    );
    path_61.cubicTo(
      100.145,
      103.697,
      97.57499999999999,
      102.527,
      97.57499999999999,
      102.527,
    );
    path_61.cubicTo(
      97.57499999999999,
      102.527,
      99.78499999999998,
      101.877,
      100.975,
      101.217,
    );
    path_61.close();

    Paint paint61Fill = Paint()..style = PaintingStyle.fill;
    paint61Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_61, paint61Fill);

    Path path_62 = Path();
    path_62.moveTo(103.994, 97.657);
    path_62.cubicTo(103.994, 97.657, 103.774, 98.707, 102.804, 99.737);
    path_62.cubicTo(101.834, 100.767, 101.024, 101.207, 101.024, 101.207);
    path_62.cubicTo(
      101.024,
      101.207,
      102.494,
      99.55699999999999,
      103.994,
      97.657,
    );
    path_62.close();

    Paint paint62Fill = Paint()..style = PaintingStyle.fill;
    paint62Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_62, paint62Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class SixthIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(44.626, 148.281);
    path_0.cubicTo(
      94.856,
      163.64100000000002,
      123.11599999999999,
      139.851,
      154.926,
      129.411,
    );
    path_0.cubicTo(
      154.946,
      129.401,
      154.976,
      129.391,
      155.02599999999998,
      129.381,
    );
    path_0.cubicTo(
      156.106,
      129.021,
      157.19599999999997,
      128.691,
      158.27599999999998,
      128.361,
    );
    path_0.arcToPoint(
      Offset(164.53599999999997, 126.74099999999999),
      radius: Radius.elliptical(95.78, 95.78),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      200.56599999999997,
      118.73099999999998,
      191.12599999999998,
      96.15099999999998,
      203.70599999999996,
      84.13099999999999,
    );
    path_0.cubicTo(
      211.85599999999997,
      76.36099999999999,
      212.57599999999996,
      68.71099999999998,
      210.42599999999996,
      62.65099999999998,
    );
    path_0.cubicTo(
      210.40599999999995,
      62.61099999999998,
      210.40599999999995,
      62.570999999999984,
      210.39599999999996,
      62.55099999999998,
    );
    path_0.lineTo(210.36599999999996, 62.46099999999998);
    path_0.cubicTo(
      209.18599999999995,
      59.24099999999998,
      207.21599999999995,
      56.48099999999998,
      205.13599999999997,
      54.39099999999998,
    );
    path_0.cubicTo(
      201.70599999999996,
      50.96099999999998,
      198.42599999999996,
      45.430999999999976,
      193.19599999999997,
      39.180999999999976,
    );
    path_0.lineTo(193.18599999999998, 39.180999999999976);
    path_0.cubicTo(
      184.02599999999998,
      28.220999999999975,
      168.87599999999998,
      15.070999999999977,
      136.49599999999998,
      7.210999999999977,
    );
    path_0.cubicTo(
      86.10599999999998,
      -5.019000000000023,
      60.07599999999998,
      20.88099999999998,
      40.195999999999984,
      40.870999999999974,
    );
    path_0.cubicTo(
      36.085999999999984,
      45.000999999999976,
      32.24599999999998,
      48.88099999999997,
      28.495999999999984,
      52.110999999999976,
    );
    path_0.cubicTo(
      25.375999999999983,
      54.81099999999998,
      22.325999999999986,
      57.06099999999998,
      19.255999999999986,
      58.64099999999998,
    );
    path_0.cubicTo(
      19.255999999999986,
      58.64099999999998,
      19.235999999999986,
      58.650999999999975,
      19.205999999999985,
      58.67099999999998,
    );
    path_0.cubicTo(
      14.765999999999984,
      60.96099999999998,
      10.795999999999985,
      64.77099999999997,
      7.645999999999985,
      69.57099999999998,
    );
    path_0.arcToPoint(
      Offset(5.435999999999985, 73.33099999999999),
      radius: Radius.elliptical(39.48, 39.48),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.cubicTo(
      -6.234000000000015,
      95.80099999999999,
      -1.6740000000000155,
      134.13099999999997,
      44.62599999999998,
      148.281,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4987594, size.height * 0.9954805),
      Offset(size.width * 0.4987594, size.height * 0.02630519),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(44.626, 148.281);
    path_1.cubicTo(
      99.846,
      165.161,
      128.506,
      134.741,
      164.546,
      126.74100000000001,
    );
    path_1.cubicTo(
      200.576,
      118.73100000000001,
      191.136,
      96.15100000000001,
      203.716,
      84.13100000000001,
    );
    path_1.cubicTo(
      216.306,
      72.12100000000001,
      211.156,
      60.40100000000001,
      205.14600000000002,
      54.39100000000002,
    );
    path_1.cubicTo(
      201.716,
      50.96100000000002,
      198.436,
      45.43100000000002,
      193.20600000000002,
      39.18100000000002,
    );
    path_1.lineTo(193.19600000000003, 39.18100000000002);
    path_1.cubicTo(
      200.836,
      49.19100000000002,
      205.70600000000002,
      55.26100000000002,
      205.99600000000004,
      66.69100000000002,
    );
    path_1.cubicTo(
      206.28600000000003,
      78.13100000000001,
      201.98600000000005,
      78.12100000000001,
      192.84600000000003,
      98.43100000000001,
    );
    path_1.cubicTo(
      186.47600000000003,
      112.561,
      174.21600000000004,
      118.88100000000001,
      153.09600000000003,
      126.88100000000001,
    );
    path_1.cubicTo(
      143.88600000000002,
      130.371,
      134.06600000000003,
      135.691,
      120.49600000000004,
      139.61100000000002,
    );
    path_1.cubicTo(
      57.01600000000004,
      157.91100000000003,
      2.9660000000000366,
      122.45100000000002,
      2.9660000000000366,
      95.86100000000002,
    );
    path_1.cubicTo(
      2.9660000000000366,
      70.10100000000001,
      18.266000000000037,
      59.31100000000002,
      19.216000000000037,
      58.661000000000016,
    );
    path_1.cubicTo(
      -5.333999999999964,
      71.34100000000001,
      -15.19399999999996,
      130.00100000000003,
      44.62600000000003,
      148.281,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4987642, size.height * 0.9954805),
      Offset(size.width * 0.4987642, size.height * 0.2544091),
      [
        GameColors.islandPainterColor43.withValues(alpha: 1),
        GameColors.islandPainterColor46.withValues(alpha: 1),
        GameColors.islandPainterColor53.withValues(alpha: 1),
        GameColors.islandPainterColor57.withValues(alpha: 1),
        GameColors.islandPainterColor73.withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(185.656, 43.77);
    path_2.cubicTo(201.576, 65.16, 166.996, 115.511, 105.126, 121.231);
    path_2.cubicTo(
      43.246,
      126.951,
      11.986000000000004,
      110.17099999999999,
      20.756,
      78.911,
    );
    path_2.cubicTo(
      29.526,
      47.650999999999996,
      69.556,
      37.731,
      80.99600000000001,
      32.781,
    );
    path_2.cubicTo(
      92.436,
      27.820999999999998,
      74.22600000000001,
      29.730999999999998,
      70.986,
      25.540999999999997,
    );
    path_2.cubicTo(
      67.746,
      21.350999999999996,
      99.226,
      2.6409999999999982,
      137.586,
      12.230999999999996,
    );
    path_2.cubicTo(
      175.936,
      21.820999999999998,
      181.086,
      40.120999999999995,
      181.366,
      41.550999999999995,
    );
    path_2.cubicTo(
      181.656,
      42.971,
      183.126,
      40.370999999999995,
      185.656,
      43.770999999999994,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4924858, size.height * 0.7943636),
      Offset(size.width * 0.4924858, size.height * 0.06175325),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(185.096, 43.09);
    path_3.cubicTo(185.096, 43.09, 195.766, 60.790000000000006, 170.406, 87.29);
    path_3.cubicTo(
      145.046,
      113.79100000000001,
      81.186,
      128.091,
      44.77600000000001,
      114.361,
    );
    path_3.cubicTo(
      8.366000000000014,
      100.631,
      26.81600000000001,
      65.921,
      26.81600000000001,
      65.921,
    );
    path_3.cubicTo(
      26.81600000000001,
      65.921,
      11.516000000000009,
      84.24100000000001,
      22.146000000000008,
      102.541,
    );
    path_3.cubicTo(
      32.77600000000001,
      120.841,
      75.766,
      132.381,
      135.04600000000002,
      119.03099999999999,
    );
    path_3.cubicTo(
      194.32600000000002,
      105.69099999999999,
      195.586,
      49.22099999999999,
      185.096,
      43.090999999999994,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4917736, size.height * 0.8104805),
      Offset(size.width * 0.4917736, size.height * 0.2798117),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(165.536, 115.301);
    path_4.cubicTo(165.536, 115.301, 138.076, 133.231, 97.336, 137.181);
    path_4.cubicTo(
      56.596,
      141.131,
      57.726,
      128.461,
      42.006,
      125.46100000000001,
    );
    path_4.cubicTo(
      26.276,
      122.46100000000001,
      21.556,
      114.02100000000002,
      21.556,
      114.02100000000002,
    );
    path_4.cubicTo(
      21.556,
      114.02100000000002,
      23.276,
      118.64100000000002,
      39.716,
      122.34100000000001,
    );
    path_4.cubicTo(
      56.156000000000006,
      126.031,
      57.436,
      132.121,
      74.316,
      134.901,
    );
    path_4.cubicTo(
      91.206,
      137.67100000000002,
      136.51600000000002,
      130.17100000000002,
      165.536,
      115.30100000000002,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4412642, size.height * 0.8956623),
      Offset(size.width * 0.4412642, size.height * 0.7403571),
      [
        GameColors.islandPainterColor43.withValues(alpha: 1),
        GameColors.islandPainterColor46.withValues(alpha: 1),
        GameColors.islandPainterColor53.withValues(alpha: 1),
        GameColors.islandPainterColor57.withValues(alpha: 1),
        GameColors.islandPainterColor73.withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(122.506, 129.17);
    path_5.cubicTo(
      127.936,
      127.30999999999999,
      83.326,
      123.32999999999998,
      66.02600000000001,
      124.38999999999999,
    );
    path_5.cubicTo(
      48.72600000000001,
      125.44999999999999,
      71.02600000000001,
      143.32,
      122.506,
      129.17,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(123.036, 132.651);
    path_6.cubicTo(
      128.076,
      132.311,
      104.436,
      146.661,
      74.29599999999999,
      144.131,
    );
    path_6.cubicTo(
      44.145999999999994,
      141.601,
      38.855999999999995,
      128.451,
      38.855999999999995,
      128.451,
    );
    path_6.cubicTo(
      38.855999999999995,
      128.451,
      46.86599999999999,
      133.601,
      74.316,
      137.31099999999998,
    );
    path_6.cubicTo(
      101.766,
      141.04099999999997,
      123.036,
      132.65099999999998,
      123.036,
      132.65099999999998,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(138.446, 133.08);
    path_7.cubicTo(138.446, 133.08, 113.506, 148.53, 72.076, 145.61);
    path_7.cubicTo(
      30.645999999999994,
      142.69000000000003,
      16.025999999999996,
      129.73000000000002,
      16.025999999999996,
      129.73000000000002,
    );
    path_7.cubicTo(
      16.025999999999996,
      129.73000000000002,
      39.855999999999995,
      152.47000000000003,
      73.406,
      152.09000000000003,
    );
    path_7.cubicTo(
      106.96600000000001,
      151.71000000000004,
      138.44600000000003,
      133.08000000000004,
      138.44600000000003,
      133.08000000000004,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3643208, size.height * 0.9876623),
      Offset(size.width * 0.3643208, size.height * 0.8424545),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(130.867, 128.461);
    path_8.cubicTo(
      130.867,
      128.461,
      114.49699999999999,
      136.911,
      93.547,
      137.51100000000002,
    );
    path_8.cubicTo(
      72.597,
      138.11100000000002,
      62.42699999999999,
      135.88100000000003,
      57.077,
      132.31100000000004,
    );
    path_8.cubicTo(
      51.727,
      128.74100000000004,
      46.917,
      124.39100000000003,
      46.917,
      124.39100000000003,
    );
    path_8.cubicTo(
      46.917,
      124.39100000000003,
      53.657000000000004,
      127.82100000000004,
      65.027,
      133.11100000000005,
    );
    path_8.cubicTo(
      76.387,
      138.39100000000005,
      109.137,
      133.89100000000005,
      130.86700000000002,
      128.46100000000004,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4192925, size.height * 0.8935325),
      Offset(size.width * 0.4192925, size.height * 0.8077078),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(18.376, 120.451);
    path_9.cubicTo(
      21.556,
      119.02099999999999,
      12.536000000000001,
      89.161,
      23.196,
      69.981,
    );
    path_9.cubicTo(
      33.146,
      52.090999999999994,
      36.996,
      49.340999999999994,
      36.996,
      49.340999999999994,
    );
    path_9.cubicTo(
      36.996,
      49.340999999999994,
      11.986,
      57.45099999999999,
      4.916000000000004,
      81.80099999999999,
    );
    path_9.cubicTo(
      -2.793999999999996,
      108.39099999999999,
      18.376000000000005,
      120.451,
      18.376000000000005,
      120.451,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(143.786, 98.95);
    path_10.cubicTo(
      164.516,
      85.65,
      109.816,
      50.800000000000004,
      54.706,
      65.30000000000001,
    );
    path_10.cubicTo(
      -0.40399999999999636,
      79.79,
      35.82600000000001,
      109.82100000000001,
      77.906,
      113.39100000000002,
    );
    path_10.cubicTo(
      119.976,
      116.97100000000002,
      135.756,
      104.10100000000003,
      143.786,
      98.95100000000002,
    );
    path_10.close();
    path_10.moveTo(158.246, 23.510000000000005);
    path_10.cubicTo(
      175.246,
      36.410000000000004,
      86.96600000000001,
      29.740000000000006,
      82.566,
      20.560000000000006,
    );
    path_10.cubicTo(
      78.156,
      11.370000000000006,
      129.006,
      1.3100000000000058,
      158.246,
      23.510000000000005,
    );
    path_10.close();
    path_10.moveTo(123.71600000000001, 33.531000000000006);
    path_10.cubicTo(
      134.626,
      38.211000000000006,
      123.16600000000001,
      41.791000000000004,
      113.82600000000001,
      39.181000000000004,
    );
    path_10.cubicTo(
      104.486,
      36.571000000000005,
      119.186,
      31.581000000000003,
      123.71600000000001,
      33.531000000000006,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(158.276, 128.36);
    path_11.arcToPoint(
      Offset(164.536, 126.74000000000001),
      radius: Radius.elliptical(95.78, 95.78),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_11.cubicTo(
      200.566,
      118.73,
      191.126,
      96.15,
      203.70600000000002,
      84.13000000000001,
    );
    path_11.cubicTo(
      211.85600000000002,
      76.36000000000001,
      212.57600000000002,
      68.71000000000001,
      210.42600000000002,
      62.650000000000006,
    );
    path_11.cubicTo(
      210.69600000000003,
      63.64000000000001,
      211.656,
      68.42,
      206.656,
      75.08000000000001,
    );
    path_11.cubicTo(
      201.036,
      82.58000000000001,
      198.836,
      85.85000000000001,
      196.26600000000002,
      93.00000000000001,
    );
    path_11.cubicTo(
      193.69600000000003,
      100.15000000000002,
      189.87600000000003,
      114.73000000000002,
      177.20600000000002,
      120.74000000000001,
    );
    path_11.cubicTo(
      169.056,
      124.60000000000001,
      162.156,
      127.08000000000001,
      158.276,
      128.36,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9974953, size.height * 0.6201494),
      Offset(size.width * 0.7465896, size.height * 0.6201494),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(201.286, 54.961);
    path_12.cubicTo(205.356, 59.571, 209.296, 69.111, 196.426, 86.991);
    path_12.cubicTo(
      183.55599999999998,
      104.861,
      177.266,
      105.721,
      176.266,
      105.431,
    );
    path_12.cubicTo(
      175.266,
      105.14099999999999,
      184.656,
      88.021,
      188.326,
      71.92099999999999,
    );
    path_12.cubicTo(
      191.986,
      55.82099999999999,
      198.626,
      51.95099999999999,
      201.286,
      54.96099999999999,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(60.006, 59.46);
    path_13.cubicTo(60.156, 59.95, 58.436, 61.54, 57.046, 60.68);
    path_13.cubicTo(55.656, 59.82, 57.266, 57.42, 57.955999999999996, 57.68);
    path_13.cubicTo(
      58.635999999999996,
      57.94,
      59.68599999999999,
      58.45,
      60.00599999999999,
      59.46,
    );
    path_13.close();
    path_13.moveTo(76.326, 113.251);
    path_13.cubicTo(
      91.43599999999999,
      115.241,
      69.696,
      78.511,
      51.43599999999999,
      74.311,
    );
    path_13.cubicTo(
      33.18599999999999,
      70.12100000000001,
      25.945999999999994,
      82.73100000000001,
      30.035999999999994,
      93.68100000000001,
    );
    path_13.cubicTo(
      34.135999999999996,
      104.63100000000001,
      57.895999999999994,
      110.82100000000001,
      76.326,
      113.251,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(168.696, 11.4);
    path_14.cubicTo(
      170.066,
      9.42,
      159.796,
      0.7300000000000004,
      154.926,
      0.0600000000000005,
    );
    path_14.cubicTo(
      150.05599999999998,
      -0.6099999999999995,
      150.146,
      4.3500000000000005,
      151.006,
      10.73,
    );
    path_14.cubicTo(151.856, 17.12, 167.706, 12.83, 168.696, 11.4);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(181.827, 107.1);
    path_15.cubicTo(187.227, 103.1, 172.837, 84.05, 164.487, 83.94999999999999);
    path_15.cubicTo(
      156.147,
      83.83999999999999,
      139.96699999999998,
      114.71,
      139.667,
      117.86999999999999,
    );
    path_15.cubicTo(
      139.377,
      121.02,
      164.837,
      123.02999999999999,
      181.827,
      107.1,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7610330, size.height * 0.7795260),
      Offset(size.width * 0.7610330, size.height * 0.5451429),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(170.406, 87.291);
    path_16.cubicTo(175.276, 90.481, 175.696, 101.961, 165.536, 108.251);
    path_16.cubicTo(
      155.386,
      114.54100000000001,
      141.746,
      112.741,
      141.656,
      112.93100000000001,
    );
    path_16.cubicTo(
      141.566,
      113.12100000000001,
      158.76600000000002,
      84.281,
      162.736,
      84.33100000000002,
    );
    path_16.cubicTo(
      166.706,
      84.38100000000001,
      170.40599999999998,
      87.29100000000001,
      170.40599999999998,
      87.29100000000001,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(182.806, 105.71);
    path_17.cubicTo(
      183.76600000000002,
      103.89999999999999,
      180.786,
      95.72,
      174.20600000000002,
      99.58,
    );
    path_17.cubicTo(
      173.096,
      100.23,
      170.91600000000003,
      106.03999999999999,
      162.89600000000002,
      109.67,
    );
    path_17.cubicTo(
      154.876,
      113.30000000000001,
      144.116,
      119.81,
      143.79600000000002,
      119.76,
    );
    path_17.cubicTo(
      143.466,
      119.71000000000001,
      144.94600000000003,
      123.93,
      163.67600000000002,
      120.04,
    );
    path_17.cubicTo(
      182.406,
      116.16000000000001,
      182.806,
      105.71000000000001,
      182.806,
      105.71000000000001,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(168.116, 105.201);
    path_18.cubicTo(
      171.67600000000002,
      100.951,
      172.45600000000002,
      95.86099999999999,
      166.54600000000002,
      94.05099999999999,
    );
    path_18.cubicTo(
      160.63600000000002,
      92.24099999999999,
      153.246,
      104.49099999999999,
      153.866,
      107.78099999999999,
    );
    path_18.cubicTo(
      154.48600000000002,
      111.06099999999999,
      165.63600000000002,
      108.151,
      168.116,
      105.201,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(163.636, 87.471);
    path_19.cubicTo(
      164.55599999999998,
      88.041,
      158.77599999999998,
      97.721,
      155.536,
      100.001,
    );
    path_19.cubicTo(
      152.286,
      102.29100000000001,
      158.866,
      84.51100000000001,
      163.636,
      87.471,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(139.666, 97.29);
    path_20.cubicTo(141.396, 91.12, 125.666, 84.9, 102.696, 91.95);
    path_20.cubicTo(
      79.726,
      99,
      90.73599999999999,
      109.801,
      100.666,
      111.20100000000001,
    );
    path_20.cubicTo(
      110.616,
      112.60100000000001,
      137.586,
      104.721,
      139.666,
      97.29100000000001,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6594340, size.height * 0.6499481),
      Offset(size.width * 0.4204009, size.height * 0.6499481),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(139.006, 98.68);
    path_21.cubicTo(140.906, 94.72000000000001, 133.086, 89.09, 111.826, 92.14);
    path_21.cubicTo(
      90.56599999999999,
      95.19,
      89.20599999999999,
      104.141,
      90.23599999999999,
      105.481,
    );
    path_21.cubicTo(
      91.26599999999999,
      106.81099999999999,
      90.386,
      113.50099999999999,
      110.78599999999999,
      111.021,
    );
    path_21.cubicTo(
      131.176,
      108.531,
      139.00599999999997,
      98.681,
      139.00599999999997,
      98.681,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = GameColors.islandPainterColor13.withValues(alpha: 1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(165.536, 78.681);
    path_22.cubicTo(168.576, 76.961, 162.166, 67.711, 145.186, 69.841);
    path_22.cubicTo(
      128.20600000000002,
      71.961,
      150.716,
      87.041,
      165.536,
      78.681,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7842877, size.height * 0.4892987),
      Offset(size.width * 0.6562123, size.height * 0.4892987),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(164.936, 79);
    path_23.cubicTo(
      166.726,
      77.46,
      161.496,
      71.421,
      150.39600000000002,
      71.081,
    );
    path_23.cubicTo(
      139.29600000000002,
      70.751,
      139.066,
      73.751,
      139.276,
      74.211,
    );
    path_23.cubicTo(
      139.48600000000002,
      74.681,
      142.056,
      79.31099999999999,
      150.76600000000002,
      80.741,
    );
    path_23.cubicTo(
      159.47600000000003,
      82.181,
      164.936,
      79.001,
      164.936,
      79.001,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor9.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(143.856, 64.02);
    path_24.cubicTo(
      146.83599999999998,
      66.64999999999999,
      137.846,
      69.72,
      130.706,
      67.06,
    );
    path_24.cubicTo(123.54599999999999, 64.4, 138.896, 59.63, 143.856, 64.02);
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6813160, size.height * 0.4231169),
      Offset(size.width * 0.6077028, size.height * 0.4231169),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(143.656, 66.35);
    path_25.cubicTo(
      145.136,
      64.74,
      134.656,
      61.21999999999999,
      128.966,
      65.91999999999999,
    );
    path_25.cubicTo(
      128.966,
      65.91999999999999,
      129.95600000000002,
      67.73999999999998,
      135.346,
      68.02999999999999,
    );
    path_25.cubicTo(
      140.736,
      68.32999999999998,
      143.656,
      66.34999999999998,
      143.656,
      66.34999999999998,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = GameColors.islandPainterColor9.withValues(alpha: 1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(139.807, 91.951);
    path_26.cubicTo(
      148.277,
      92.041,
      140.707,
      77.08099999999999,
      125.74699999999999,
      74.131,
    );
    path_26.cubicTo(
      110.77699999999999,
      71.181,
      100.19699999999999,
      85.531,
      98.57699999999998,
      87.931,
    );
    path_26.cubicTo(
      96.95699999999998,
      90.331,
      122.08699999999999,
      85.81099999999999,
      139.807,
      91.951,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(165.006, 108.601);
    path_27.cubicTo(165.006, 108.601, 160.496, 109.241, 157.206, 110.121);
    path_27.cubicTo(153.916, 111.011, 152.816, 112.551, 152.816, 112.551);
    path_27.cubicTo(152.816, 112.551, 157.796, 113.301, 165.006, 108.601);
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(171.546, 114.011);
    path_28.cubicTo(
      173.976,
      112.22099999999999,
      165.666,
      109.941,
      158.916,
      112.22099999999999,
    );
    path_28.cubicTo(
      152.166,
      114.511,
      149.736,
      118.94099999999999,
      149.666,
      119.371,
    );
    path_28.cubicTo(149.596, 119.801, 159.816, 119.451, 171.546, 114.011);
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(172.376, 100.761);
    path_29.cubicTo(
      172.376,
      100.761,
      168.076,
      106.89099999999999,
      164.14600000000002,
      107.64099999999999,
    );
    path_29.cubicTo(
      156.086,
      109.181,
      155.17600000000002,
      110.071,
      152.066,
      111.36099999999999,
    );
    path_29.cubicTo(
      148.956,
      112.651,
      143.596,
      113.02099999999999,
      143.596,
      113.02099999999999,
    );
    path_29.cubicTo(
      143.596,
      113.02099999999999,
      147.116,
      113.05099999999999,
      152.826,
      112.54099999999998,
    );
    path_29.cubicTo(
      152.826,
      112.54099999999998,
      154.796,
      110.76099999999998,
      157.986,
      110.11099999999998,
    );
    path_29.cubicTo(
      161.176,
      109.46099999999997,
      165.006,
      108.78099999999998,
      165.006,
      108.78099999999998,
    );
    path_29.cubicTo(
      165.006,
      108.78099999999998,
      169.586,
      106.56099999999998,
      172.376,
      100.76099999999998,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(12.346, 102);
    path_30.cubicTo(13.386, 100.44, 12.306000000000001, 96.95, 9.546, 96.61);
    path_30.cubicTo(
      6.786,
      96.28,
      5.475999999999999,
      98.14,
      4.9559999999999995,
      100.57,
    );
    path_30.cubicTo(4.446, 103, 10.576, 104.66999999999999, 12.346, 102);
    path_30.close();
    path_30.moveTo(14.716000000000001, 95.28);
    path_30.cubicTo(17.666, 95.61, 16.846, 90.81, 13.416, 89.23);
    path_30.cubicTo(
      9.986,
      87.65,
      6.156000000000001,
      94.34,
      14.716000000000001,
      95.28,
    );
    path_30.close();
    path_30.moveTo(27.216, 123.691);
    path_30.cubicTo(
      28.886000000000003,
      122.191,
      25.476000000000003,
      120.471,
      24.216,
      121.971,
    );
    path_30.cubicTo(22.946, 123.471, 25.546, 125.191, 27.216, 123.691);
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(16.356, 92.581);
    path_31.cubicTo(
      16.836000000000002,
      94.281,
      14.786000000000001,
      95.26100000000001,
      11.736,
      94.041,
    );
    path_31.cubicTo(
      8.686,
      92.821,
      9.886000000000001,
      90.461,
      9.886000000000001,
      90.461,
    );
    path_31.cubicTo(9.886000000000001, 90.461, 9.066, 91.751, 8.986, 92.851);
    path_31.cubicTo(8.916, 93.951, 11.226, 96.06099999999999, 15.276, 96.001);
    path_31.cubicTo(19.346, 95.93100000000001, 16.356, 92.581, 16.356, 92.581);
    path_31.close();
    path_31.moveTo(12.536000000000001, 99.291);
    path_31.cubicTo(
      12.536000000000001,
      99.291,
      13.646,
      101.321,
      9.906000000000002,
      101.971,
    );
    path_31.cubicTo(
      6.166000000000002,
      102.611,
      5.246000000000002,
      99.551,
      5.246000000000002,
      99.551,
    );
    path_31.cubicTo(
      5.246000000000002,
      99.551,
      4.646000000000003,
      100.561,
      4.756000000000002,
      101.561,
    );
    path_31.cubicTo(
      4.876000000000002,
      102.561,
      7.116000000000001,
      104.40100000000001,
      11.496000000000002,
      103.54100000000001,
    );
    path_31.cubicTo(
      15.876000000000001,
      102.68100000000001,
      12.536000000000001,
      99.29100000000001,
      12.536000000000001,
      99.29100000000001,
    );
    path_31.close();
    path_31.moveTo(27.336000000000002, 122.091);
    path_31.cubicTo(
      28.226000000000003,
      122.951,
      26.066000000000003,
      123.72099999999999,
      24.916000000000004,
      123.591,
    );
    path_31.cubicTo(
      23.776000000000003,
      123.461,
      23.876000000000005,
      122.701,
      23.876000000000005,
      122.701,
    );
    path_31.cubicTo(
      23.876000000000005,
      122.701,
      23.336000000000006,
      124.131,
      25.766000000000005,
      124.36099999999999,
    );
    path_31.cubicTo(
      28.206000000000007,
      124.60099999999998,
      28.656000000000006,
      122.55099999999999,
      27.336000000000006,
      122.091,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(8.836, 97);
    path_32.cubicTo(10.226, 97.5, 9.556000000000001, 99.47, 7.976, 99.97);
    path_32.cubicTo(6.396, 100.48, 5.416, 99.1, 5.416, 99.1);
    path_32.cubicTo(
      5.416,
      99.1,
      6.316000000000001,
      96.08999999999999,
      8.836,
      97,
    );
    path_32.close();
    path_32.moveTo(12.736, 89.641);
    path_32.cubicTo(14.016, 90.281, 12.666, 91.671, 11.336, 91.501);
    path_32.cubicTo(10.006, 91.331, 10.316, 90.191, 10.316, 90.191);
    path_32.cubicTo(10.316, 90.191, 11.596, 89.061, 12.736, 89.641);
    path_32.close();
    path_32.moveTo(25.927, 122.68);
    path_32.cubicTo(26.247, 122.15, 25.707, 121.57000000000001, 24.987, 121.53);
    path_32.cubicTo(24.267, 121.49, 24.057, 122.7, 24.147, 122.88);
    path_32.cubicTo(
      24.237,
      123.06,
      25.467,
      123.44999999999999,
      25.927,
      122.67999999999999,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(85.897, 101.56);
    path_33.cubicTo(
      87.56700000000001,
      100.06,
      84.15700000000001,
      98.34,
      82.897,
      99.84,
    );
    path_33.cubicTo(81.62700000000001, 101.34, 84.227, 103.06, 85.897, 101.56);
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(86.016, 99.96);
    path_34.cubicTo(
      86.906,
      100.821,
      84.74600000000001,
      101.591,
      83.596,
      101.461,
    );
    path_34.cubicTo(82.446, 101.331, 82.556, 100.571, 82.556, 100.571);
    path_34.cubicTo(
      82.556,
      100.571,
      82.01599999999999,
      102.001,
      84.446,
      102.231,
    );
    path_34.cubicTo(
      86.886,
      102.47099999999999,
      87.336,
      100.42099999999999,
      86.01599999999999,
      99.961,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(84.617, 100.541);
    path_35.cubicTo(84.937, 100.011, 84.397, 99.431, 83.677, 99.39099999999999);
    path_35.cubicTo(
      82.95700000000001,
      99.35099999999998,
      82.747,
      100.56099999999999,
      82.837,
      100.74099999999999,
    );
    path_35.cubicTo(
      82.927,
      100.92099999999999,
      84.147,
      101.31099999999998,
      84.617,
      100.54099999999998,
    );
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(138.207, 124.28);
    path_36.cubicTo(
      140.59699999999998,
      122.13,
      135.707,
      119.67,
      133.897,
      121.82000000000001,
    );
    path_36.cubicTo(
      132.09699999999998,
      123.97000000000001,
      135.81699999999998,
      126.43,
      138.207,
      124.28,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(138.376, 121.99);
    path_37.cubicTo(
      139.64600000000002,
      123.22999999999999,
      136.546,
      124.32,
      134.906,
      124.14,
    );
    path_37.cubicTo(
      133.26600000000002,
      123.96,
      133.416,
      122.87,
      133.416,
      122.87,
    );
    path_37.cubicTo(133.416, 122.87, 132.646, 124.92, 136.136, 125.25);
    path_37.cubicTo(
      139.626,
      125.58,
      140.27599999999998,
      122.65,
      138.376,
      121.99,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(136.366, 122.831);
    path_38.cubicTo(
      136.82600000000002,
      122.071,
      136.04600000000002,
      121.251,
      135.01600000000002,
      121.181,
    );
    path_38.cubicTo(
      133.98600000000002,
      121.121,
      133.686,
      122.851,
      133.81600000000003,
      123.111,
    );
    path_38.cubicTo(
      133.94600000000003,
      123.37100000000001,
      135.69600000000003,
      123.931,
      136.36600000000004,
      122.831,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(79.467, 106.891);
    path_39.cubicTo(
      79.517,
      103.531,
      74.437,
      101.001,
      70.797,
      105.43100000000001,
    );
    path_39.cubicTo(
      67.167,
      109.87100000000001,
      79.39699999999999,
      111.77100000000002,
      79.467,
      106.891,
    );
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(79.106, 105.352);
    path_40.cubicTo(79.106, 105.352, 79.776, 108.512, 76.246, 109.182);
    path_40.cubicTo(
      72.716,
      109.852,
      69.946,
      107.822,
      70.54599999999999,
      105.782,
    );
    path_40.cubicTo(
      70.54599999999999,
      105.782,
      69.62599999999999,
      106.55199999999999,
      69.356,
      107.77199999999999,
    );
    path_40.cubicTo(
      69.086,
      108.99199999999999,
      71.92599999999999,
      111.18199999999999,
      77.146,
      110.80199999999999,
    );
    path_40.cubicTo(
      82.376,
      110.422,
      79.916,
      106.442,
      79.106,
      105.35199999999999,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(72.707, 104.971);
    path_41.cubicTo(
      73.91699999999999,
      104.971,
      73.767,
      106.821,
      71.847,
      106.65100000000001,
    );
    path_41.cubicTo(
      69.937,
      106.48100000000001,
      71.817,
      104.971,
      72.707,
      104.971,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(27.917, 61.841);
    path_42.cubicTo(
      30.347,
      57.971000000000004,
      22.037000000000003,
      49.551,
      19.297000000000004,
      48.831,
    );
    path_42.cubicTo(
      16.557000000000002,
      48.101000000000006,
      7.547000000000004,
      66.15100000000001,
      7.397000000000004,
      68.921,
    );
    path_42.cubicTo(
      7.257000000000004,
      71.691,
      15.977000000000004,
      75.29100000000001,
      27.917,
      61.84100000000001,
    );
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.08434434, size.height * 0.4645260),
      Offset(size.width * 0.08434434, size.height * 0.3169221),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(16.716, 79);
    path_43.cubicTo(18.386000000000003, 77.23, 8.976, 67.01, 5.256, 66.14);
    path_43.cubicTo(
      1.536,
      65.26,
      0.6560000000000006,
      81.55,
      1.7460000000000004,
      82.92,
    );
    path_43.cubicTo(2.8260000000000005, 84.27, 11.076, 84.98, 16.716, 79);
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.04299528, size.height * 0.5444805),
      Offset(size.width * 0.04299528, size.height * 0.4292403),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(19.296, 48.83);
    path_44.cubicTo(20.506, 48.68, 23.796, 51.64, 24.006, 56.16);
    path_44.cubicTo(24.216, 60.69, 10.476, 66.66, 8.026, 66.69999999999999);
    path_44.cubicTo(
      7.406,
      66.71,
      13.466000000000001,
      50.359999999999985,
      19.296,
      48.829999999999984,
    );
    path_44.close();
    path_44.moveTo(5.826, 66.331);
    path_44.cubicTo(
      7.9159999999999995,
      67.37100000000001,
      13.366,
      72.411,
      11.745999999999999,
      76.801,
    );
    path_44.cubicTo(
      10.125999999999998,
      81.181,
      3.305999999999999,
      74.851,
      2.8859999999999992,
      70.751,
    );
    path_44.cubicTo(
      2.4459999999999993,
      66.641,
      4.435999999999999,
      65.631,
      5.825999999999999,
      66.331,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(28.206, 61.361);
    path_45.cubicTo(28.336, 60.461, 27.556, 57.230999999999995, 22.986, 59.461);
    path_45.cubicTo(
      18.406,
      61.681,
      14.456000000000001,
      65.56099999999999,
      13.386000000000001,
      67.06099999999999,
    );
    path_45.cubicTo(
      12.316,
      68.56099999999999,
      12.346,
      71.53099999999999,
      12.346,
      71.53099999999999,
    );
    path_45.cubicTo(
      12.346,
      71.53099999999999,
      18.846,
      77.701,
      28.206,
      61.36099999999999,
    );
    path_45.close();
    path_45.moveTo(2.047, 71.541);
    path_45.cubicTo(2.047, 71.541, 3.8970000000000002, 74.221, 7.397, 77.341);
    path_45.cubicTo(9.967, 79.631, 14.627, 80.851, 14.627, 80.851);
    path_45.cubicTo(14.627, 80.851, 12.037, 84.491, 5.617000000000001, 87.281);
    path_45.cubicTo(
      0.6670000000000007,
      89.43100000000001,
      1.7470000000000008,
      82.911,
      1.7470000000000008,
      82.911,
    );
    path_45.cubicTo(
      1.7470000000000008,
      82.911,
      0.6270000000000007,
      78.821,
      2.0470000000000006,
      71.541,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(9.096, 77.43);
    path_46.cubicTo(
      11.616,
      77.77000000000001,
      7.606,
      71.08000000000001,
      5.136,
      70.53,
    );
    path_46.cubicTo(2.666, 69.97, 4.026, 76.75, 9.096, 77.43);
    path_46.close();
    path_46.moveTo(7.406000000000001, 81.37100000000001);
    path_46.cubicTo(
      10.176,
      80.46100000000001,
      5.976000000000001,
      75.98100000000001,
      3.2360000000000007,
      75.65100000000001,
    );
    path_46.cubicTo(
      0.49600000000000044,
      75.311,
      0.8460000000000005,
      82.08100000000002,
      7.406000000000001,
      81.37100000000001,
    );
    path_46.close();
    path_46.moveTo(22.527, 57.97100000000001);
    path_46.cubicTo(
      24.127000000000002,
      55.05100000000001,
      20.347,
      51.04100000000001,
      17.347,
      51.64100000000001,
    );
    path_46.cubicTo(
      14.347000000000001,
      52.25100000000001,
      11.697000000000001,
      60.72100000000001,
      11.557000000000002,
      62.58100000000001,
    );
    path_46.cubicTo(
      11.407000000000002,
      64.44100000000002,
      20.057000000000002,
      62.46100000000001,
      22.527,
      57.97100000000001,
    );
    path_46.close();
    path_46.moveTo(24.947000000000003, 59.06000000000001);
    path_46.cubicTo(
      27.377000000000002,
      59.03000000000001,
      25.157000000000004,
      62.49000000000001,
      20.837000000000003,
      63.87000000000001,
    );
    path_46.cubicTo(
      16.507000000000005,
      65.26,
      21.317000000000004,
      59.110000000000014,
      24.947000000000003,
      59.06000000000001,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(18.666, 62.14);
    path_47.cubicTo(18.666, 62.14, 16.996000000000002, 64.31, 15.646, 65.14);
    path_47.cubicTo(
      14.296000000000001,
      65.97,
      11.356000000000002,
      65.76,
      11.356000000000002,
      65.76,
    );
    path_47.cubicTo(
      11.356000000000002,
      65.76,
      14.016000000000002,
      63.580000000000005,
      18.666,
      62.14000000000001,
    );
    path_47.close();
    path_47.moveTo(9.046000000000001, 78.53);
    path_47.cubicTo(
      9.046000000000001,
      78.53,
      6.776000000000002,
      76.53,
      5.886000000000001,
      75.64,
    );
    path_47.cubicTo(
      4.996000000000001,
      74.75,
      3.476000000000001,
      73.34,
      3.476000000000001,
      73.34,
    );
    path_47.cubicTo(
      3.476000000000001,
      73.34,
      3.286000000000001,
      76.96000000000001,
      9.046000000000001,
      78.53,
    );
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(13.026, 80.34);
    path_48.cubicTo(13.026, 80.34, 9.736, 79.06, 8.646, 78.27000000000001);
    path_48.cubicTo(
      7.556000000000001,
      77.48,
      4.696000000000001,
      74.47000000000001,
      4.696000000000001,
      74.47000000000001,
    );
    path_48.cubicTo(
      4.696000000000001,
      74.47000000000001,
      11.286000000000001,
      76.63000000000001,
      13.026,
      80.34000000000002,
    );
    path_48.close();
    path_48.moveTo(23.336, 58.151);
    path_48.cubicTo(
      23.336,
      58.151,
      20.526,
      60.471000000000004,
      18.165999999999997,
      61.571000000000005,
    );
    path_48.cubicTo(
      15.805999999999994,
      62.67100000000001,
      13.355999999999998,
      62.971000000000004,
      12.035999999999998,
      63.691,
    );
    path_48.cubicTo(
      10.725999999999997,
      64.401,
      9.795999999999998,
      66.321,
      9.795999999999998,
      66.321,
    );
    path_48.cubicTo(
      9.795999999999998,
      66.321,
      11.125999999999998,
      65.951,
      11.355999999999998,
      65.771,
    );
    path_48.cubicTo(
      11.595999999999998,
      65.591,
      15.515999999999998,
      62.841,
      18.665999999999997,
      62.151,
    );
    path_48.cubicTo(
      18.665999999999997,
      62.141000000000005,
      22.245999999999995,
      59.92100000000001,
      23.336,
      58.151,
    );
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(81.886, 32.9);
    path_49.cubicTo(85.606, 37.47, 93.806, 34.47, 93.806, 34.47);
    path_49.cubicTo(93.806, 34.47, 98.616, 48.45, 118.93599999999999, 42.26);
    path_49.cubicTo(139.066, 36.12, 127.416, 24.04, 127.416, 24.04);
    path_49.cubicTo(
      127.29599999999999,
      19.63,
      126.26599999999999,
      17.54,
      125.12599999999999,
      16.59,
    );
    path_49.cubicTo(
      123.51599999999999,
      15.25,
      121.666,
      16.169999999999998,
      121.666,
      16.169999999999998,
    );
    path_49.cubicTo(
      120.18599999999999,
      4.109999999999998,
      110.806,
      6.769999999999998,
      110.806,
      6.769999999999998,
    );
    path_49.lineTo(111.486, 13.839999999999998);
    path_49.cubicTo(98.896, 9.209999999999997, 98.436, 23.58, 98.436, 23.58);
    path_49.cubicTo(
      96.376,
      21.13,
      95.74600000000001,
      22.029999999999998,
      95.74600000000001,
      22.029999999999998,
    );
    path_49.cubicTo(
      95.74600000000001,
      22.029999999999998,
      93.206,
      15.309999999999999,
      86.75600000000001,
      15.159999999999997,
    );
    path_49.cubicTo(
      80.28600000000002,
      15.019999999999996,
      81.186,
      25.319999999999997,
      81.186,
      25.319999999999997,
    );
    path_49.cubicTo(
      81.186,
      25.319999999999997,
      80.38600000000001,
      26.119999999999997,
      80.126,
      27.529999999999998,
    );
    path_49.lineTo(80.126, 27.54);
    path_49.cubicTo(
      79.85600000000001,
      28.86,
      80.096,
      30.7,
      81.88600000000001,
      32.9,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4971651, size.height * 0.2846948),
      Offset(size.width * 0.4971651, size.height * 0.04237013),
      [
        GameColors.islandPainterColor5.withValues(alpha: 1),
        GameColors.islandPainterColor3.withValues(alpha: 1),
        GameColors.islandPainterColor1.withValues(alpha: 1),
      ],
      [0, 0.59, 1],
    );
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(81.646, 34.05);
    path_50.cubicTo(85.366, 38.62, 93.816, 34.48, 93.816, 34.48);
    path_50.cubicTo(93.816, 34.48, 99.876, 49.37, 120.186, 43.17999999999999);
    path_50.cubicTo(
      140.316,
      37.03999999999999,
      127.426,
      24.039999999999992,
      127.426,
      24.039999999999992,
    );
    path_50.cubicTo(
      127.306,
      19.629999999999992,
      126.276,
      17.539999999999992,
      125.136,
      16.589999999999993,
    );
    path_50.cubicTo(
      126.396,
      23.849999999999994,
      115.836,
      27.679999999999993,
      115.836,
      27.679999999999993,
    );
    path_50.cubicTo(
      124.616,
      29.46999999999999,
      126.79599999999999,
      24.389999999999993,
      126.79599999999999,
      24.389999999999993,
    );
    path_50.cubicTo(
      126.79599999999999,
      24.389999999999993,
      127.43599999999999,
      24.039999999999992,
      128.58599999999998,
      26.749999999999993,
    );
    path_50.cubicTo(
      129.736,
      29.46999999999999,
      129.016,
      41.97999999999999,
      112.57599999999998,
      40.75999999999999,
    );
    path_50.cubicTo(
      96.13599999999998,
      39.54999999999999,
      94.86599999999999,
      30.40999999999999,
      94.86599999999999,
      30.40999999999999,
    );
    path_50.cubicTo(
      94.86599999999999,
      30.40999999999999,
      90.08599999999998,
      33.92999999999999,
      85.87599999999999,
      33.499999999999986,
    );
    path_50.cubicTo(
      81.72599999999998,
      33.079999999999984,
      80.17599999999999,
      27.699999999999985,
      80.12599999999999,
      27.539999999999985,
    );
    path_50.cubicTo(
      79.856,
      28.859999999999985,
      79.84599999999999,
      31.839999999999986,
      81.64599999999999,
      34.04999999999998,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4987594, size.height * 0.2901429),
      Offset(size.width * 0.4987594, size.height * 0.1077273),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(111.486, 13.84);
    path_51.cubicTo(114.986, 15.89, 115.406, 13.51, 113.846, 10.02);
    path_51.cubicTo(112.366, 6.7299999999999995, 110.806, 6.77, 110.806, 6.77);
    path_51.lineTo(111.486, 13.84);
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5318726, size.height * 0.09480519),
      Offset(size.width * 0.5318726, size.height * 0.04398701),
      [
        GameColors.islandPainterColor44.withValues(alpha: 1),
        GameColors.islandPainterColor50.withValues(alpha: 1),
        GameColors.islandPainterColor56.withValues(alpha: 1),
        GameColors.islandPainterColor61.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 1),
      ],
      [0, 0.303, 0.616, 0.859, 1],
    );
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(124.436, 26.8);
    path_52.cubicTo(
      128.576,
      26.75,
      125.47600000000001,
      39.24,
      114.46600000000001,
      39.71,
    );
    path_52.cubicTo(
      103.456,
      40.19,
      97.64600000000002,
      33.75,
      97.49600000000001,
      32.660000000000004,
    );
    path_52.cubicTo(
      97.346,
      31.570000000000004,
      113.57600000000001,
      32.86000000000001,
      124.436,
      26.800000000000004,
    );
    path_52.close();
    path_52.moveTo(115.036, 15.360000000000001);
    path_52.cubicTo(120.976, 18.96, 119.996, 25.990000000000002, 108.266, 27.8);
    path_52.cubicTo(96.546, 29.61, 99.35600000000001, 17.59, 102.566, 14.88);
    path_52.cubicTo(
      105.786,
      12.170000000000002,
      111.856,
      13.440000000000001,
      115.036,
      15.360000000000001,
    );
    path_52.close();
    path_52.moveTo(95.286, 21.07);
    path_52.cubicTo(95.756, 21.66, 89.21600000000001, 25.04, 85.396, 24.68);
    path_52.cubicTo(81.57600000000001, 24.32, 81.556, 17.42, 84.876, 15.92);
    path_52.cubicTo(88.176, 14.42, 91.05600000000001, 15.78, 95.286, 21.07);
    path_52.close();
    path_52.moveTo(93.546, 30.04);
    path_52.cubicTo(95.616, 27.68, 83.35600000000001, 25.57, 81.956, 25.89);
    path_52.cubicTo(80.556, 26.21, 80.666, 32.3, 85.626, 33.27);
    path_52.cubicTo(
      90.586,
      34.24,
      93.546,
      30.040000000000003,
      93.546,
      30.040000000000003,
    );
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(137.086, 16.76);
    path_53.cubicTo(
      140.70600000000002,
      18.62,
      135.67600000000002,
      19.220000000000002,
      133.376,
      17.630000000000003,
    );
    path_53.cubicTo(
      131.076,
      16.050000000000004,
      134.45600000000002,
      15.420000000000002,
      137.086,
      16.76,
    );
    path_53.close();
    path_53.moveTo(133.52700000000002, 13.3);
    path_53.cubicTo(
      137.437,
      15.07,
      133.98700000000002,
      16.61,
      127.38700000000001,
      14,
    );
    path_53.cubicTo(
      120.77700000000002,
      11.370000000000001,
      128.58700000000002,
      11.07,
      133.52700000000002,
      13.3,
    );
    path_53.close();
    path_53.moveTo(131.566, 8.77);
    path_53.cubicTo(133.776, 9.54, 129.566, 10.1, 127.456, 9.29);
    path_53.cubicTo(
      125.336,
      8.489999999999998,
      127.526,
      7.379999999999999,
      131.566,
      8.77,
    );
    path_53.close();
    path_53.moveTo(100.646, 34.681);
    path_53.cubicTo(
      104.07600000000001,
      35.300999999999995,
      100.046,
      36.190999999999995,
      98.916,
      35.830999999999996,
    );
    path_53.cubicTo(97.79599999999999, 35.461, 97.146, 34.041, 100.646, 34.681);
    path_53.close();
    path_53.moveTo(136.917, 36.8);
    path_53.cubicTo(
      141.307,
      38.37,
      134.557,
      39.16,
      132.987,
      38.589999999999996,
    );
    path_53.cubicTo(131.417, 38.01, 130.337, 34.44, 136.917, 36.8);
    path_53.close();
    path_53.moveTo(71.246, 77.65);
    path_53.cubicTo(74.866, 79.51, 69.836, 80.11, 67.536, 78.52000000000001);
    path_53.cubicTo(65.236, 76.93, 68.616, 76.30000000000001, 71.246, 77.65);
    path_53.close();
    path_53.moveTo(67.68599999999999, 74.18);
    path_53.cubicTo(
      71.59599999999999,
      75.95,
      68.14599999999999,
      77.49000000000001,
      61.54599999999999,
      74.88000000000001,
    );
    path_53.cubicTo(
      54.93599999999999,
      72.26,
      62.745999999999995,
      71.95,
      67.68599999999999,
      74.18,
    );
    path_53.close();
    path_53.moveTo(65.726, 69.66000000000001);
    path_53.cubicTo(
      67.93599999999999,
      70.43,
      63.726,
      70.99000000000001,
      61.616,
      70.18,
    );
    path_53.cubicTo(59.496, 69.37, 61.696, 68.26, 65.726, 69.66000000000001);
    path_53.close();
    path_53.moveTo(34.806, 95.56);
    path_53.cubicTo(
      38.236,
      96.18,
      34.205999999999996,
      97.07000000000001,
      33.076,
      96.71000000000001,
    );
    path_53.cubicTo(31.956, 96.34, 31.316, 94.92, 34.806, 95.56);
    path_53.close();
    path_53.moveTo(71.076, 97.68);
    path_53.cubicTo(
      75.466,
      99.25,
      68.716,
      100.04,
      67.14599999999999,
      99.47000000000001,
    );
    path_53.cubicTo(
      65.576,
      98.90000000000002,
      64.50599999999999,
      95.32000000000001,
      71.076,
      97.68,
    );
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = GameColors.islandPainterColor49.withValues(alpha: 1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(90.886, 134.491);
    path_54.cubicTo(
      93.606,
      133.221,
      66.65599999999999,
      127.311,
      59.215999999999994,
      125.97100000000002,
    );
    path_54.cubicTo(
      51.785999999999994,
      124.64100000000002,
      49.245999999999995,
      125.28100000000002,
      49.245999999999995,
      125.28100000000002,
    );
    path_54.cubicTo(
      49.245999999999995,
      125.28100000000002,
      56.54599999999999,
      128.64100000000002,
      62.736,
      132.04100000000003,
    );
    path_54.cubicTo(
      68.93599999999999,
      135.44100000000003,
      87.306,
      135.25100000000003,
      90.886,
      134.491,
    );
    path_54.close();
    path_54.moveTo(70.12599999999999, 143.70100000000002);
    path_54.cubicTo(
      66.00599999999999,
      143.091,
      52.72599999999999,
      134.54100000000003,
      44.06599999999999,
      130.73100000000002,
    );
    path_54.cubicTo(
      35.40599999999999,
      126.93100000000003,
      26.70599999999999,
      128.35100000000003,
      26.70599999999999,
      128.35100000000003,
    );
    path_54.cubicTo(
      26.70599999999999,
      128.35100000000003,
      43.64599999999999,
      139.74100000000004,
      70.12599999999999,
      143.70100000000002,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(111.996, 129.581);
    path_55.cubicTo(
      114.866,
      127.56099999999999,
      112.286,
      125.21099999999998,
      108.01599999999999,
      123.481,
    );
    path_55.cubicTo(
      103.746,
      121.75099999999999,
      93.026,
      126.991,
      91.966,
      128.131,
    );
    path_55.cubicTo(
      90.916,
      129.271,
      102.62599999999999,
      136.191,
      111.996,
      129.581,
    );
    path_55.close();
    path_55.moveTo(90.51599999999999, 125.66999999999999);
    path_55.cubicTo(
      91.89599999999999,
      127.07,
      88.97599999999998,
      129.17999999999998,
      86.93599999999999,
      127.43999999999998,
    );
    path_55.cubicTo(
      84.89599999999999,
      125.68999999999998,
      89.59599999999999,
      124.72999999999999,
      90.51599999999999,
      125.66999999999999,
    );
    path_55.close();
    path_55.moveTo(24.055999999999997, 115.05099999999999);
    path_55.cubicTo(
      26.255999999999997,
      112.85099999999998,
      22.415999999999997,
      104.761,
      14.285999999999998,
      105.731,
    );
    path_55.cubicTo(
      6.165999999999999,
      106.69099999999999,
      16.496,
      122.631,
      24.055999999999997,
      115.05099999999999,
    );
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(112.447, 126.141);
    path_56.cubicTo(112.447, 126.141, 113.077, 131.651, 104.397, 131.811);
    path_56.cubicTo(
      92.117,
      132.041,
      93.01700000000001,
      127.40100000000001,
      93.01700000000001,
      127.40100000000001,
    );
    path_56.cubicTo(
      93.01700000000001,
      127.40100000000001,
      91.977,
      128.131,
      91.68700000000001,
      128.51100000000002,
    );
    path_56.cubicTo(
      91.397,
      128.89100000000002,
      95.40700000000001,
      133.25100000000003,
      104.13700000000001,
      132.77100000000002,
    );
    path_56.cubicTo(
      112.87700000000001,
      132.281,
      113.77700000000002,
      128.52100000000002,
      113.58700000000002,
      127.78100000000002,
    );
    path_56.cubicTo(
      113.38700000000001,
      127.03100000000002,
      112.44700000000002,
      126.14100000000002,
      112.44700000000002,
      126.14100000000002,
    );
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_56, paint56Fill);

    Path path_57 = Path();
    path_57.moveTo(90.516, 125.671);
    path_57.cubicTo(
      90.516,
      125.671,
      91.44600000000001,
      127.221,
      89.226,
      127.561,
    );
    path_57.cubicTo(
      86.996,
      127.90100000000001,
      86.416,
      126.57100000000001,
      86.416,
      126.57100000000001,
    );
    path_57.cubicTo(
      86.416,
      126.57100000000001,
      86.396,
      128.781,
      89.37599999999999,
      128.39100000000002,
    );
    path_57.cubicTo(
      92.356,
      128.00100000000003,
      90.51599999999999,
      125.67100000000002,
      90.51599999999999,
      125.67100000000002,
    );
    path_57.close();

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_57, paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(23.116, 109.29);
    path_58.cubicTo(23.116, 109.29, 24.766, 111.69000000000001, 23.716, 113.78);
    path_58.cubicTo(
      22.656000000000002,
      115.87,
      19.886000000000003,
      116.68,
      15.976,
      114.65,
    );
    path_58.cubicTo(12.065999999999999, 112.62, 11.326, 108.9, 11.326, 108.9);
    path_58.cubicTo(11.326, 108.9, 11.136000000000001, 110.34, 12.406, 112.93);
    path_58.cubicTo(
      13.676,
      115.52000000000001,
      17.446,
      118.74000000000001,
      22.816000000000003,
      117.23,
    );
    path_58.cubicTo(
      28.176000000000002,
      115.72,
      23.976000000000003,
      109.87,
      23.116000000000003,
      109.29,
    );
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_58, paint58Fill);

    Path path_59 = Path();
    path_59.moveTo(89.666, 109.76);
    path_59.cubicTo(
      91.826,
      112.19000000000001,
      86.87599999999999,
      112.46000000000001,
      85.446,
      111.26,
    );
    path_59.cubicTo(84.026, 110.07000000000001, 87.816, 107.67, 89.666, 109.76);
    path_59.close();
    path_59.moveTo(86.746, 105.821);
    path_59.cubicTo(
      88.31599999999999,
      107.06099999999999,
      85.586,
      107.621,
      84.62599999999999,
      106.67099999999999,
    );
    path_59.cubicTo(
      83.666,
      105.711,
      85.606,
      104.92099999999999,
      86.746,
      105.821,
    );
    path_59.close();
    path_59.moveTo(167.226, 34.89099999999999);
    path_59.cubicTo(
      169.386,
      37.32099999999999,
      164.436,
      37.590999999999994,
      163.006,
      36.39099999999999,
    );
    path_59.cubicTo(
      161.576,
      35.20099999999999,
      165.366,
      32.80099999999999,
      167.226,
      34.89099999999999,
    );
    path_59.close();
    path_59.moveTo(164.296, 30.93999999999999);
    path_59.cubicTo(
      165.86599999999999,
      32.17999999999999,
      163.136,
      32.73999999999999,
      162.176,
      31.789999999999992,
    );
    path_59.cubicTo(
      161.21599999999998,
      30.839999999999993,
      163.166,
      30.049999999999994,
      164.296,
      30.93999999999999,
    );
    path_59.close();
    path_59.moveTo(74.45599999999999, 115.761);
    path_59.cubicTo(
      76.33599999999998,
      116.881,
      72.76599999999999,
      117.11099999999999,
      71.54599999999999,
      116.741,
    );
    path_59.cubicTo(
      70.336,
      116.371,
      72.576,
      114.641,
      74.45599999999999,
      115.761,
    );
    path_59.close();
    path_59.moveTo(149.75599999999997, 84.871);
    path_59.cubicTo(
      150.29599999999996,
      86.541,
      146.75599999999997,
      86.261,
      145.89599999999996,
      84.69099999999999,
    );
    path_59.cubicTo(
      145.03599999999994,
      83.121,
      149.32599999999996,
      83.55099999999999,
      149.75599999999997,
      84.871,
    );
    path_59.close();
    path_59.moveTo(145.78599999999997, 82.42999999999999);
    path_59.cubicTo(
      146.13599999999997,
      82.85,
      144.896,
      82.77,
      144.53599999999997,
      82.42999999999999,
    );
    path_59.cubicTo(
      144.18599999999998,
      82.08,
      145.16599999999997,
      81.69999999999999,
      145.78599999999997,
      82.42999999999999,
    );
    path_59.close();
    path_59.moveTo(136.88599999999997, 85.66);
    path_59.cubicTo(
      140.81599999999997,
      87.21,
      138.20599999999996,
      89.8,
      134.99599999999998,
      87.92999999999999,
    );
    path_59.cubicTo(
      131.77599999999998,
      86.05,
      134.706,
      84.8,
      136.88599999999997,
      85.66,
    );
    path_59.close();
    path_59.moveTo(57.65599999999996, 56.041);
    path_59.cubicTo(
      58.19599999999996,
      57.711,
      54.65599999999996,
      57.431,
      53.795999999999964,
      55.861,
    );
    path_59.cubicTo(
      52.935999999999964,
      54.291,
      57.225999999999964,
      54.721,
      57.65599999999996,
      56.041,
    );
    path_59.close();
    path_59.moveTo(53.685999999999964, 53.601);
    path_59.cubicTo(
      54.035999999999966,
      54.021,
      52.795999999999964,
      53.941,
      52.435999999999964,
      53.601,
    );
    path_59.cubicTo(
      52.08599999999996,
      53.260999999999996,
      53.075999999999965,
      52.871,
      53.685999999999964,
      53.601,
    );
    path_59.close();
    path_59.moveTo(44.785999999999966, 56.83);
    path_59.cubicTo(
      48.715999999999966,
      58.379999999999995,
      46.105999999999966,
      60.97,
      42.895999999999965,
      59.1,
    );
    path_59.cubicTo(
      39.675999999999966,
      57.22,
      42.605999999999966,
      55.97,
      44.785999999999966,
      56.83,
    );
    path_59.close();
    path_59.moveTo(97.31599999999997, 89.12);
    path_59.cubicTo(
      99.51599999999998,
      90.65,
      97.45599999999997,
      91.48,
      94.59599999999998,
      90.41000000000001,
    );
    path_59.cubicTo(
      91.74599999999998,
      89.34000000000002,
      96.44599999999997,
      88.52000000000001,
      97.31599999999997,
      89.12,
    );
    path_59.close();
    path_59.moveTo(125.70599999999997, 31.200000000000003);
    path_59.cubicTo(
      128.53599999999997,
      33.11,
      122.63599999999998,
      34.010000000000005,
      121.35599999999998,
      32.34,
    );
    path_59.cubicTo(
      120.07599999999998,
      30.67,
      123.79599999999998,
      29.910000000000004,
      125.70599999999997,
      31.200000000000003,
    );
    path_59.close();
    path_59.moveTo(113.49599999999998, 37.39);
    path_59.cubicTo(
      116.06599999999997,
      37.82,
      113.49599999999998,
      39.730000000000004,
      111.68599999999998,
      38.78,
    );
    path_59.cubicTo(
      109.87599999999998,
      37.82,
      110.92599999999997,
      36.95,
      113.49599999999998,
      37.39,
    );
    path_59.close();
    path_59.moveTo(106.06599999999997, 40.44);
    path_59.cubicTo(
      108.16599999999997,
      41,
      104.06599999999997,
      42.87,
      102.53599999999997,
      42.269999999999996,
    );
    path_59.cubicTo(
      101.01599999999998,
      41.67999999999999,
      101.63599999999997,
      39.24999999999999,
      106.06599999999997,
      40.44,
    );
    path_59.close();

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_59, paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(104.557, 102.871);
    path_60.cubicTo(
      103.557,
      101.651,
      116.507,
      95.28099999999999,
      126.607,
      98.731,
    );
    path_60.cubicTo(134.667, 101.491, 111.377, 111.201, 104.557, 102.871);
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_60, paint60Fill);

    Path path_61 = Path();
    path_61.moveTo(125.996, 98.62);
    path_61.cubicTo(
      130.02599999999998,
      95.01,
      131.36599999999999,
      89.85000000000001,
      130.206,
      86.91,
    );
    path_61.cubicTo(129.046, 83.96, 115.386, 82.31, 109.83599999999998, 85.16);
    path_61.cubicTo(
      104.28599999999999,
      88.00999999999999,
      104.07599999999998,
      99.74,
      106.09599999999999,
      102.46,
    );
    path_61.cubicTo(
      108.11599999999999,
      105.19999999999999,
      118.606,
      105.25999999999999,
      125.99599999999998,
      98.61999999999999,
    );
    path_61.close();

    Paint paint61Fill = Paint()..style = PaintingStyle.fill;
    paint61Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5331321, size.height * 0.6819026),
      Offset(size.width * 0.5544292, size.height * 0.5002597),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_61, paint61Fill);

    Path path_62 = Path();
    path_62.moveTo(129.766, 87.14);
    path_62.cubicTo(
      132.856,
      91.1,
      115.17599999999999,
      103.471,
      109.30599999999998,
      98.15,
    );
    path_62.cubicTo(
      103.43599999999998,
      92.82000000000001,
      108.21599999999998,
      85.92,
      110.79599999999998,
      85.17,
    );
    path_62.cubicTo(
      113.37599999999998,
      84.41,
      126.10599999999998,
      82.44,
      129.76599999999996,
      87.14,
    );
    path_62.close();

    Paint paint62Fill = Paint()..style = PaintingStyle.fill;
    paint62Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_62, paint62Fill);

    Path path_63 = Path();
    path_63.moveTo(129.947, 86.49);
    path_63.cubicTo(130.287, 87.86999999999999, 121.037, 91.97, 114.997, 91.78);
    path_63.cubicTo(108.957, 91.59, 107.757, 87.95, 108.31700000000001, 86.29);
    path_63.cubicTo(
      108.87700000000001,
      84.63000000000001,
      113.35700000000001,
      83.73,
      119.447,
      83.71000000000001,
    );
    path_63.cubicTo(
      125.527,
      83.69000000000001,
      129.707,
      85.50000000000001,
      129.947,
      86.49000000000001,
    );
    path_63.close();

    Paint paint63Fill = Paint()..style = PaintingStyle.fill;
    paint63Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_63, paint63Fill);

    Path path_64 = Path();
    path_64.moveTo(129.876, 87.3);
    path_64.cubicTo(130.976, 87.31, 130.436, 92.67, 127.24600000000001, 96.42);
    path_64.cubicTo(
      124.05600000000001,
      100.181,
      117.21600000000001,
      102.871,
      116.596,
      102.871,
    );
    path_64.cubicTo(115.976, 102.871, 116.306, 93.231, 116.396, 92.851);
    path_64.cubicTo(116.476, 92.481, 123.276, 91.871, 129.876, 87.301);
    path_64.close();

    Paint paint64Fill = Paint()..style = PaintingStyle.fill;
    paint64Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_64, paint64Fill);

    Path path_65 = Path();
    path_65.moveTo(114.656, 103.2);
    path_65.cubicTo(115.616, 102.97, 116.05600000000001, 94.67, 115.316, 93.53);
    path_65.cubicTo(114.57600000000001, 92.39, 108.796, 90.83, 107.806, 87.94);
    path_65.cubicTo(107.806, 87.94, 105.786, 90.14999999999999, 105.476, 95.8);
    path_65.cubicTo(105.166, 101.45, 107.356, 104.91, 114.656, 103.2);
    path_65.close();

    Paint paint65Fill = Paint()..style = PaintingStyle.fill;
    paint65Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_65, paint65Fill);

    Path path_66 = Path();
    path_66.moveTo(120.237, 91.15);
    path_66.cubicTo(120.387, 91.17, 116.607, 93.26, 115.717, 93.52000000000001);
    path_66.cubicTo(114.827, 93.79, 112.187, 91.361, 112.187, 91.361);
    path_66.cubicTo(
      112.187,
      91.361,
      115.167,
      90.461,
      120.237,
      91.15100000000001,
    );
    path_66.close();
    path_66.moveTo(111.726, 91.22);
    path_66.cubicTo(111.726, 91.22, 110.416, 90.94, 109.376, 90.11);
    path_66.cubicTo(108.336, 89.28, 108.296, 87.88, 108.296, 87.88);
    path_66.cubicTo(108.296, 87.88, 110.256, 90.55, 111.72600000000001, 91.22);
    path_66.close();

    Paint paint66Fill = Paint()..style = PaintingStyle.fill;
    paint66Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_66, paint66Fill);

    Path path_67 = Path();
    path_67.moveTo(112.687, 103.191);
    path_67.cubicTo(114.727, 103.891, 114.997, 108.661, 108.137, 109.221);
    path_67.cubicTo(
      101.287,
      109.781,
      104.777,
      100.48100000000001,
      112.687,
      103.191,
    );
    path_67.close();

    Paint paint67Fill = Paint()..style = PaintingStyle.fill;
    paint67Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_67, paint67Fill);

    Path path_68 = Path();
    path_68.moveTo(113.206, 104.481);
    path_68.cubicTo(
      113.766,
      103.03099999999999,
      110.436,
      98.17099999999999,
      107.056,
      99.321,
    );
    path_68.cubicTo(
      103.68599999999999,
      100.481,
      102.586,
      103.751,
      104.346,
      106.511,
    );
    path_68.cubicTo(106.116, 109.271, 111.376, 109.191, 113.206, 104.481);
    path_68.close();

    Paint paint68Fill = Paint()..style = PaintingStyle.fill;
    paint68Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5081321, size.height * 0.7047857),
      Offset(size.width * 0.5160472, size.height * 0.6281688),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_68, paint68Fill);

    Path path_69 = Path();
    path_69.moveTo(112.316, 102.931);
    path_69.cubicTo(
      112.616,
      104.101,
      108.406,
      107.36099999999999,
      105.146,
      105.321,
    );
    path_69.cubicTo(
      101.886,
      103.28099999999999,
      106.466,
      99.701,
      108.146,
      99.64099999999999,
    );
    path_69.cubicTo(
      109.816,
      99.56099999999999,
      111.936,
      101.47099999999999,
      112.316,
      102.931,
    );
    path_69.close();

    Paint paint69Fill = Paint()..style = PaintingStyle.fill;
    paint69Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_69, paint69Fill);

    Path path_70 = Path();
    path_70.moveTo(112.196, 101.621);
    path_70.cubicTo(
      112.606,
      102.601,
      110.346,
      104.571,
      107.556,
      104.81099999999999,
    );
    path_70.cubicTo(
      104.76599999999999,
      105.05099999999999,
      103.896,
      103.321,
      103.846,
      102.81099999999999,
    );
    path_70.cubicTo(
      103.796,
      102.291,
      106.376,
      99.13099999999999,
      108.046,
      99.33099999999999,
    );
    path_70.cubicTo(
      109.71600000000001,
      99.52099999999999,
      111.656,
      100.341,
      112.19600000000001,
      101.621,
    );
    path_70.close();

    Paint paint70Fill = Paint()..style = PaintingStyle.fill;
    paint70Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_70, paint70Fill);

    Path path_71 = Path();
    path_71.moveTo(109.317, 108.051);
    path_71.cubicTo(
      109.58699999999999,
      108.23100000000001,
      111.857,
      106.511,
      112.55699999999999,
      105.371,
    );
    path_71.cubicTo(
      113.25699999999999,
      104.22099999999999,
      112.737,
      102.631,
      112.47699999999999,
      102.651,
    );
    path_71.cubicTo(
      112.22699999999999,
      102.67099999999999,
      110.08699999999999,
      104.47099999999999,
      108.38699999999999,
      104.951,
    );
    path_71.cubicTo(
      108.39699999999999,
      104.94099999999999,
      107.88699999999999,
      107.11099999999999,
      109.317,
      108.05099999999999,
    );
    path_71.close();

    Paint paint71Fill = Paint()..style = PaintingStyle.fill;
    paint71Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_71, paint71Fill);

    Path path_72 = Path();
    path_72.moveTo(108.396, 108.161);
    path_72.cubicTo(108.706, 108.101, 107.986, 105.381, 107.716, 105.191);
    path_72.cubicTo(
      107.446,
      105.001,
      104.76599999999999,
      104.901,
      103.67599999999999,
      103.141,
    );
    path_72.cubicTo(
      103.66599999999998,
      103.141,
      102.92599999999999,
      107.741,
      108.39599999999999,
      108.161,
    );
    path_72.close();

    Paint paint72Fill = Paint()..style = PaintingStyle.fill;
    paint72Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_72, paint72Fill);

    Path path_73 = Path();
    path_73.moveTo(108.906, 104.551);
    path_73.cubicTo(
      108.906,
      104.551,
      108.49600000000001,
      105.521,
      108.206,
      105.651,
    );
    path_73.cubicTo(
      107.916,
      105.771,
      106.46600000000001,
      104.831,
      106.46600000000001,
      104.831,
    );
    path_73.cubicTo(
      106.46600000000001,
      104.831,
      107.49600000000001,
      104.911,
      108.906,
      104.551,
    );
    path_73.close();
    path_73.moveTo(106.087, 104.74);
    path_73.cubicTo(
      106.087,
      104.74,
      105.037,
      104.17999999999999,
      104.617,
      103.85,
    );
    path_73.cubicTo(
      104.197,
      103.52,
      103.95700000000001,
      103.19,
      103.95700000000001,
      103.19,
    );
    path_73.cubicTo(
      103.95700000000001,
      103.19,
      104.337,
      104.71,
      106.087,
      104.74,
    );
    path_73.close();

    Paint paint73Fill = Paint()..style = PaintingStyle.fill;
    paint73Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_73, paint73Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class SeventhIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(13.017, 77.14);
    path_0.cubicTo(23.247, 87.13, 39.827, 96.47, 63.986999999999995, 101.67);
    path_0.cubicTo(121.64699999999999, 114.09, 129.737, 95.87, 145.587, 72.7);
    path_0.cubicTo(
      145.99699999999999,
      72.10000000000001,
      146.387,
      71.51,
      146.75699999999998,
      70.9,
    );
    path_0.cubicTo(
      152.84699999999998,
      61.160000000000004,
      154.95699999999997,
      50.53,
      153.29699999999997,
      40.56,
    );
    path_0.lineTo(153.26699999999997, 40.38);
    path_0.cubicTo(
      153.21699999999996,
      40.120000000000005,
      153.17699999999996,
      39.86,
      153.12699999999998,
      39.6,
    );
    path_0.cubicTo(
      153.04699999999997,
      39.190000000000005,
      152.96699999999998,
      38.79,
      152.87699999999998,
      38.39,
    );
    path_0.cubicTo(
      149.49699999999999,
      23.28,
      137.34699999999998,
      9.920000000000002,
      117.19699999999997,
      3.700000000000003,
    );
    path_0.cubicTo(
      109.48699999999998,
      1.320000000000003,
      100.60699999999997,
      -0.009999999999997122,
      90.58699999999997,
      2.6645352591003757e-15,
    );
    path_0.cubicTo(
      89.27699999999997,
      2.6645352591003757e-15,
      87.95699999999998,
      0.030000000000002663,
      86.60699999999997,
      0.08000000000000267,
    );
    path_0.lineTo(85.26699999999997, 0.14000000000000268);
    path_0.cubicTo(
      81.26699999999997,
      0.3300000000000027,
      77.09699999999997,
      0.7300000000000026,
      72.76699999999997,
      1.3500000000000028,
    );
    path_0.cubicTo(
      54.89699999999996,
      3.9200000000000026,
      42.486999999999966,
      7.030000000000003,
      33.69699999999997,
      10.440000000000003,
    );
    path_0.cubicTo(
      20.146999999999966,
      15.690000000000003,
      15.196999999999967,
      21.650000000000006,
      12.066999999999968,
      27.43,
    );
    path_0.lineTo(12.066999999999968, 27.44);
    path_0.cubicTo(
      9.416999999999968,
      32.35,
      8.096999999999968,
      37.11,
      3.9769999999999683,
      41.21,
    );
    path_0.cubicTo(
      -3.0830000000000313,
      48.21,
      -1.1430000000000318,
      63.29,
      13.016999999999967,
      77.14,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4994416, size.height * 0.9971792),
      Offset(size.width * 0.4994416, size.height * 0.007547170),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(63.987, 101.68);
    path_1.cubicTo(
      121.64699999999999,
      114.10000000000001,
      129.737,
      95.88000000000001,
      145.587,
      72.71000000000001,
    );
    path_1.cubicTo(
      152.577,
      62.49000000000001,
      155.057,
      51.17000000000001,
      153.28699999999998,
      40.57000000000001,
    );
    path_1.cubicTo(
      155.88699999999997,
      59.66000000000001,
      133.707,
      92.42000000000002,
      91.89699999999998,
      95.73,
    );
    path_1.cubicTo(
      48.42699999999998,
      99.16000000000001,
      11.356999999999971,
      75.9,
      4.776999999999973,
      61.6,
    );
    path_1.cubicTo(
      -1.1430000000000273,
      48.730000000000004,
      8.406999999999972,
      38.870000000000005,
      12.066999999999972,
      27.43,
    );
    path_1.cubicTo(
      9.416999999999971,
      32.34,
      8.096999999999971,
      37.1,
      3.976999999999972,
      41.2,
    );
    path_1.cubicTo(
      -8.173000000000028,
      53.25,
      6.3269999999999715,
      89.26,
      63.986999999999966,
      101.68,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4994481, size.height * 0.9971698),
      Offset(size.width * 0.4994481, size.height * 0.2587736),
      [
        GameColors.islandPainterColor43.withValues(alpha: 1),
        GameColors.islandPainterColor46.withValues(alpha: 1),
        GameColors.islandPainterColor53.withValues(alpha: 1),
        GameColors.islandPainterColor57.withValues(alpha: 1),
        GameColors.islandPainterColor73.withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(130.157, 24.26);
    path_2.cubicTo(157.477, 47.1, 132.217, 86.59, 73.137, 78.96000000000001);
    path_2.cubicTo(
      14.057000000000002,
      71.33000000000001,
      18.616999999999997,
      45.99000000000001,
      21.247,
      36.68000000000001,
    );
    path_2.cubicTo(
      23.877,
      27.370000000000005,
      22.707,
      9.820000000000007,
      60.237,
      4.720000000000006,
    );
    path_2.cubicTo(
      97.767,
      -0.3799999999999937,
      104.167,
      5.360000000000006,
      113.477,
      12.290000000000006,
    );
    path_2.cubicTo(
      122.787,
      19.220000000000006,
      128.607,
      22.960000000000008,
      130.157,
      24.260000000000005,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5230065, size.height * 0.7539528),
      Offset(size.width * 0.5230065, size.height * 0.02606604),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(139.027, 35.58);
    path_3.cubicTo(
      139.027,
      35.58,
      146.837,
      59.92,
      117.66699999999999,
      70.97999999999999,
    );
    path_3.cubicTo(
      88.49699999999999,
      82.03999999999999,
      60.47699999999999,
      78.79999999999998,
      38.93699999999998,
      65.82999999999998,
    );
    path_3.cubicTo(
      17.396999999999984,
      52.86999999999998,
      21.776999999999983,
      40.27999999999999,
      22.926999999999982,
      34.56999999999998,
    );
    path_3.cubicTo(
      24.066999999999982,
      28.84999999999998,
      24.59699999999998,
      24.41999999999998,
      24.59699999999998,
      24.41999999999998,
    );
    path_3.cubicTo(
      24.59699999999998,
      24.41999999999998,
      21.20699999999998,
      36.119999999999976,
      18.72699999999998,
      41.34999999999998,
    );
    path_3.cubicTo(
      16.24699999999998,
      46.579999999999984,
      22.826999999999977,
      79.20999999999998,
      74.10699999999999,
      82.65999999999998,
    );
    path_3.cubicTo(
      125.38699999999999,
      86.09999999999998,
      149.707,
      62.70999999999998,
      139.027,
      35.579999999999984,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5187532, size.height * 0.7829340),
      Offset(size.width * 0.5187532, size.height * 0.2302830),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(13.027, 77.14);
    path_4.cubicTo(23.247, 87.13, 39.827, 96.47, 63.987, 101.67);
    path_4.cubicTo(121.64699999999999, 114.09, 129.737, 95.87, 145.587, 72.7);
    path_4.cubicTo(
      145.99699999999999,
      72.10000000000001,
      146.387,
      71.51,
      146.75699999999998,
      70.9,
    );
    path_4.cubicTo(
      146.75699999999998,
      70.9,
      120.23699999999998,
      97.73,
      91.32699999999997,
      99.53,
    );
    path_4.cubicTo(
      62.41699999999997,
      101.33,
      14.976999999999975,
      79.14,
      13.026999999999973,
      77.14,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5187532, size.height * 0.9971792),
      Offset(size.width * 0.5187532, size.height * 0.6689811),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(112.677, 68.08);
    path_5.cubicTo(
      130.02700000000002,
      59.879999999999995,
      85.037,
      20.58,
      51.67700000000001,
      24.409999999999997,
    );
    path_5.cubicTo(
      18.317000000000007,
      28.239999999999995,
      27.697000000000006,
      54.66,
      60.447,
      68.66,
    );
    path_5.cubicTo(
      93.197,
      82.66,
      112.67699999999999,
      68.08,
      112.67699999999999,
      68.08,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(127.357, 26.33);
    path_6.cubicTo(
      132.267,
      41.62,
      85.987,
      30.52,
      61.206999999999994,
      22.139999999999997,
    );
    path_6.cubicTo(
      36.42699999999999,
      13.749999999999996,
      73.137,
      0.6699999999999982,
      94.71699999999998,
      6.159999999999997,
    );
    path_6.cubicTo(
      116.29699999999998,
      11.649999999999997,
      126.49699999999999,
      23.659999999999997,
      127.35699999999999,
      26.33,
    );
    path_6.close();
    path_6.moveTo(119.588, 41.339999999999996);
    path_6.cubicTo(
      128.19799999999998,
      37.91,
      106.678,
      34.69,
      102.71799999999999,
      37.29,
    );
    path_6.cubicTo(
      98.758,
      39.9,
      109.43799999999999,
      45.39,
      119.588,
      41.339999999999996,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(100.527, 11.95);
    path_7.cubicTo(100.527, 11.95, 104.087, 13.729999999999999, 104.117, 16.32);
    path_7.cubicTo(104.117, 16.32, 108.467, 18.21, 109.477, 20.1);
    path_7.cubicTo(
      110.48700000000001,
      21.990000000000002,
      97.337,
      25.28,
      82.217,
      23.69,
    );
    path_7.cubicTo(
      60.346999999999994,
      21.39,
      61.667,
      15.940000000000001,
      61.667,
      15.940000000000001,
    );
    path_7.cubicTo(
      61.667,
      15.940000000000001,
      67.807,
      7.250000000000002,
      72.62700000000001,
      7.990000000000001,
    );
    path_7.cubicTo(
      72.62700000000001,
      7.990000000000001,
      71.96700000000001,
      1.7300000000000013,
      76.37700000000001,
      2.9400000000000013,
    );
    path_7.lineTo(76.647, 5.860000000000001);
    path_7.cubicTo(
      76.647,
      5.860000000000001,
      81.307,
      6.370000000000001,
      82.09700000000001,
      11.680000000000001,
    );
    path_7.cubicTo(
      82.09700000000001,
      11.680000000000001,
      83.537,
      13.030000000000001,
      82.38700000000001,
      13.900000000000002,
    );
    path_7.cubicTo(
      82.38700000000001,
      13.900000000000002,
      86.96700000000001,
      10.680000000000001,
      91.98700000000001,
      16.990000000000002,
    );
    path_7.cubicTo(
      91.98700000000001,
      16.990000000000002,
      92.62700000000001,
      15.930000000000001,
      93.57700000000001,
      15.300000000000002,
    );
    path_7.cubicTo(
      93.58700000000002,
      15.300000000000002,
      94.58700000000002,
      6.710000000000003,
      100.52700000000002,
      11.950000000000003,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5607922, size.height * 0.2274811),
      Offset(size.width * 0.5607922, size.height * 0.02627358),
      [
        GameColors.islandPainterColor5.withValues(alpha: 1),
        GameColors.islandPainterColor3.withValues(alpha: 1),
        GameColors.islandPainterColor1.withValues(alpha: 1),
      ],
      [0, 0.59, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(107.817, 18.41);
    path_8.cubicTo(107.817, 18.41, 108.967, 22.35, 94.11699999999999, 22.98);
    path_8.cubicTo(
      79.267,
      23.6,
      64.49699999999999,
      19.43,
      64.49699999999999,
      19.43,
    );
    path_8.cubicTo(
      64.49699999999999,
      19.43,
      68.81699999999998,
      23.89,
      91.36699999999999,
      25.04,
    );
    path_8.cubicTo(
      113.91699999999999,
      26.189999999999998,
      111.52699999999999,
      20.95,
      111.15699999999998,
      20.4,
    );
    path_8.cubicTo(
      110.80699999999999,
      19.84,
      107.81699999999998,
      18.41,
      107.81699999999998,
      18.41,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5753117, size.height * 0.2377075),
      Offset(size.width * 0.5753117, size.height * 0.1736698),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(102.087, 12.98);
    path_9.cubicTo(102.087, 12.98, 103.867, 14.5, 102.937, 16.92);
    path_9.cubicTo(101.997, 19.340000000000003, 98.007, 18.69, 96.097, 17.73);
    path_9.cubicTo(
      94.187,
      16.77,
      93.58699999999999,
      15.3,
      93.58699999999999,
      15.3,
    );
    path_9.cubicTo(
      93.58699999999999,
      15.3,
      92.50699999999999,
      16.25,
      91.99699999999999,
      16.990000000000002,
    );
    path_9.cubicTo(
      91.99699999999999,
      16.990000000000002,
      94.96699999999998,
      19.05,
      95.40699999999998,
      20.82,
    );
    path_9.cubicTo(
      95.85699999999999,
      22.59,
      85.61699999999999,
      22.8,
      81.63699999999999,
      19.13,
    );
    path_9.cubicTo(
      77.65699999999998,
      15.459999999999999,
      82.75699999999999,
      13.689999999999998,
      82.75699999999999,
      13.689999999999998,
    );
    path_9.cubicTo(
      82.75699999999999,
      13.689999999999998,
      80.237,
      13.399999999999999,
      79.30699999999999,
      16.849999999999998,
    );
    path_9.cubicTo(
      78.37699999999998,
      20.299999999999997,
      82.41699999999999,
      22.599999999999998,
      90.91699999999999,
      22.569999999999997,
    );
    path_9.cubicTo(
      99.41699999999999,
      22.539999999999996,
      97.17699999999999,
      20.489999999999995,
      99.09699999999998,
      19.859999999999996,
    );
    path_9.cubicTo(
      101.01699999999998,
      19.239999999999995,
      103.33699999999997,
      17.749999999999996,
      103.73699999999998,
      17.039999999999996,
    );
    path_9.lineTo(104.13699999999999, 16.319999999999997);
    path_9.cubicTo(
      104.13699999999999,
      16.319999999999997,
      104.15699999999998,
      14.339999999999996,
      102.08699999999999,
      12.979999999999997,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5997338, size.height * 0.2129245),
      Offset(size.width * 0.5997338, size.height * 0.1224906),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(72.637, 7.99);
    path_10.cubicTo(72.637, 7.99, 76.137, 8.69, 77.757, 13.780000000000001);
    path_10.cubicTo(
      77.757,
      13.780000000000001,
      78.397,
      12.090000000000002,
      76.26700000000001,
      9.120000000000001,
    );
    path_10.cubicTo(
      74.13700000000001,
      6.15,
      72.56700000000001,
      7.440000000000001,
      72.56700000000001,
      7.440000000000001,
    );
    path_10.lineTo(72.637, 7.990000000000001);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4914286, size.height * 0.1300377),
      Offset(size.width * 0.4914286, size.height * 0.06757547),
      [
        GameColors.islandPainterColor35.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor15.withValues(alpha: 1),
      ],
      [0, 0.184, 0.501, 0.91, 1],
    );
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(82.107, 11.68);
    path_11.cubicTo(82.107, 11.68, 79.497, 11.64, 78.717, 13.129999999999999);
    path_11.cubicTo(
      78.717,
      13.129999999999999,
      78.087,
      9,
      79.627,
      8.299999999999999,
    );
    path_11.cubicTo(81.167, 7.599999999999999, 82.107, 11.68, 82.107, 11.68);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5322922, size.height * 0.1007358),
      Offset(size.width * 0.5094091, size.height * 0.1050660),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(92.997, 17.78);
    path_12.cubicTo(94.667, 19.32, 93.977, 21.450000000000003, 87.397, 20.51);
    path_12.cubicTo(
      80.81700000000001,
      19.580000000000002,
      81.087,
      15.410000000000002,
      82.147,
      14.580000000000002,
    );
    path_12.cubicTo(
      83.20700000000001,
      13.740000000000002,
      86.84700000000001,
      12.100000000000001,
      92.997,
      17.78,
    );
    path_12.close();
    path_12.moveTo(102.687, 14.000000000000002);
    path_12.cubicTo(
      103.867,
      15.200000000000001,
      104.297,
      18.64,
      98.477,
      17.900000000000002,
    );
    path_12.cubicTo(
      92.65700000000001,
      17.160000000000004,
      93.867,
      12.180000000000003,
      96.247,
      11.200000000000003,
    );
    path_12.cubicTo(
      98.617,
      10.220000000000002,
      102.687,
      14.000000000000004,
      102.687,
      14.000000000000004,
    );
    path_12.close();
    path_12.moveTo(106.597, 18);
    path_12.cubicTo(108.437, 18.1, 107.28699999999999, 20.89, 103.847, 21.64);
    path_12.cubicTo(
      100.407,
      22.39,
      98.847,
      22.18,
      98.61699999999999,
      22.060000000000002,
    );
    path_12.cubicTo(
      98.38699999999999,
      21.950000000000003,
      99.94699999999999,
      17.650000000000002,
      106.597,
      18.000000000000004,
    );
    path_12.close();
    path_12.moveTo(77.697, 20.740000000000002);
    path_12.cubicTo(
      80.507,
      20.150000000000002,
      77.557,
      9.600000000000001,
      72.717,
      8.670000000000002,
    );
    path_12.cubicTo(
      67.887,
      7.740000000000002,
      63.336999999999996,
      13.440000000000001,
      63.257,
      16.42,
    );
    path_12.cubicTo(
      63.187,
      19.400000000000002,
      74.047,
      21.5,
      77.697,
      20.740000000000002,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(65.678, 69.61);
    path_13.cubicTo(
      82.768,
      69.02,
      57.098,
      43.59,
      35.507999999999996,
      44.730000000000004,
    );
    path_13.cubicTo(
      13.927999999999997,
      45.870000000000005,
      32.507999999999996,
      70.75,
      65.678,
      69.61,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4627208, size.height * 0.5393396),
      Offset(size.width * 0.1703766, size.height * 0.5393396),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(105.347, 57.17);
    path_14.cubicTo(
      120.28699999999999,
      62.63,
      95.417,
      70.61,
      83.987,
      64.32000000000001,
    );
    path_14.cubicTo(
      72.547,
      58.03000000000001,
      91.247,
      52.02000000000001,
      105.347,
      57.17000000000001,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7142597, size.height * 0.5747736),
      Offset(size.width * 0.5223377, size.height * 0.5747736),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(68.517, 69.18);
    path_15.cubicTo(
      73.187,
      66.89,
      60.897,
      50.31,
      44.236999999999995,
      47.730000000000004,
    );
    path_15.cubicTo(
      27.576999999999995,
      45.160000000000004,
      26.236999999999995,
      51.02,
      26.236999999999995,
      51.02,
    );
    path_15.cubicTo(
      26.236999999999995,
      51.02,
      27.646999999999995,
      62.17,
      45.236999999999995,
      67.75,
    );
    path_15.cubicTo(62.81699999999999, 73.33, 68.517, 69.18, 68.517, 69.18);
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor13.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(109.537, 62.24);
    path_16.cubicTo(109.537, 62.24, 110.007, 56.42, 95.06700000000001, 56.24);
    path_16.cubicTo(80.12700000000001, 56.06, 80.697, 61.43, 80.697, 61.43);
    path_16.cubicTo(80.697, 61.43, 82.307, 66.15, 94.06700000000001, 66.63);
    path_16.cubicTo(
      105.82700000000001,
      67.11,
      109.557,
      62.559999999999995,
      109.537,
      62.239999999999995,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor9.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(125.877, 55.17);
    path_17.cubicTo(125.92699999999999, 51.81, 120.847, 49.28, 117.207, 53.71);
    path_17.cubicTo(113.577, 58.14, 125.80699999999999, 60.04, 125.877, 55.17);
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(125.517, 53.62);
    path_18.cubicTo(
      125.517,
      53.62,
      126.187,
      56.78,
      122.657,
      57.449999999999996,
    );
    path_18.cubicTo(
      119.127,
      58.12,
      116.357,
      56.089999999999996,
      116.957,
      54.05,
    );
    path_18.cubicTo(116.957, 54.05, 116.03699999999999, 54.82, 115.767, 56.04);
    path_18.cubicTo(
      115.50699999999999,
      57.26,
      118.33699999999999,
      59.45,
      123.557,
      59.07,
    );
    path_18.cubicTo(128.787, 58.69, 126.327, 54.71, 125.517, 53.62);
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(119.117, 53.24);
    path_19.cubicTo(120.327, 53.24, 120.177, 55.09, 118.257, 54.92);
    path_19.cubicTo(
      116.34700000000001,
      54.760000000000005,
      118.227,
      53.24,
      119.117,
      53.24,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(124.797, 63.19);
    path_20.cubicTo(124.827, 61.21, 121.827, 59.72, 119.687, 62.33);
    path_20.cubicTo(117.547, 64.94, 124.757, 66.06, 124.797, 63.19);
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(124.587, 62.28);
    path_21.cubicTo(124.587, 62.28, 124.977, 64.14, 122.897, 64.54);
    path_21.cubicTo(
      120.81700000000001,
      64.93,
      119.177,
      63.74000000000001,
      119.537,
      62.540000000000006,
    );
    path_21.cubicTo(
      119.537,
      62.540000000000006,
      118.997,
      63.00000000000001,
      118.837,
      63.71000000000001,
    );
    path_21.cubicTo(
      118.677,
      64.42,
      120.357,
      65.72000000000001,
      123.437,
      65.50000000000001,
    );
    path_21.cubicTo(
      126.517,
      65.26000000000002,
      125.067,
      62.920000000000016,
      124.587,
      62.280000000000015,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(120.817, 62.05);
    path_22.cubicTo(
      121.52699999999999,
      62.05,
      121.437,
      63.14,
      120.30699999999999,
      63.04,
    );
    path_22.cubicTo(
      119.17699999999999,
      62.94,
      120.28699999999999,
      62.05,
      120.817,
      62.05,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(115.437, 88.31);
    path_23.cubicTo(124.587, 81.48, 93.987, 85.48, 62.387, 82.05);
    path_23.cubicTo(
      30.787,
      78.61999999999999,
      11.777000000000001,
      60.81999999999999,
      8.767000000000003,
      60.92999999999999,
    );
    path_23.cubicTo(
      5.767000000000003,
      61.029999999999994,
      16.207000000000004,
      85.05,
      60.957,
      93.06,
    );
    path_23.cubicTo(105.717, 101.06, 115.437, 88.31, 115.437, 88.31);
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(17.087, 23.08);
    path_24.cubicTo(17.087, 23.08, 17.687, 26.68, 27.997, 29.81);
    path_24.cubicTo(
      34.927,
      31.919999999999998,
      46.197,
      27.009999999999998,
      48.867000000000004,
      24.849999999999998,
    );
    path_24.cubicTo(
      51.527,
      22.689999999999998,
      54.307,
      21.639999999999997,
      44.877,
      18.939999999999998,
    );
    path_24.cubicTo(
      35.447,
      16.24,
      17.087000000000003,
      23.08,
      17.087000000000003,
      23.08,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(47.967, 21.62);
    path_25.cubicTo(48.937, 20.43, 45.237, 10.65, 41.917, 9.080000000000002);
    path_25.cubicTo(
      38.597,
      7.500000000000002,
      31.877000000000002,
      -0.5399999999999974,
      28.277,
      0.9300000000000015,
    );
    path_25.cubicTo(
      23.027,
      3.0700000000000016,
      16.107,
      20.770000000000003,
      15.837000000000002,
      21.86,
    );
    path_25.cubicTo(
      15.567000000000002,
      22.95,
      21.327,
      26.32,
      28.377000000000002,
      28.23,
    );
    path_25.cubicTo(35.447, 30.14, 46.167, 23.82, 47.967, 21.62);
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2076753, size.height * 0.2696509),
      Offset(size.width * 0.2076753, size.height * 0.7056604),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(47.657, 21.551);
    path_26.cubicTo(
      49.227,
      19.520999999999997,
      45.617,
      13.761,
      41.916999999999994,
      12.630999999999998,
    );
    path_26.cubicTo(
      38.21699999999999,
      11.500999999999998,
      29.696999999999996,
      27.061,
      30.546999999999997,
      27.820999999999998,
    );
    path_26.cubicTo(
      31.406999999999996,
      28.581,
      41.757,
      29.200999999999997,
      47.657,
      21.551,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(42.737, 9.621);
    path_27.cubicTo(43.487, 10.211, 37.597, 17.411, 27.597, 17.131);
    path_27.cubicTo(
      15.837000000000002,
      16.801000000000002,
      24.937,
      2.3209999999999997,
      28.277,
      0.9209999999999994,
    );
    path_27.cubicTo(
      31.197000000000003,
      -0.2890000000000006,
      39.447,
      7.031,
      42.737,
      9.620999999999999,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(34.077, 17.481);
    path_28.cubicTo(
      35.117,
      17.561,
      33.257,
      22.351000000000003,
      29.156999999999996,
      24.111,
    );
    path_28.cubicTo(
      25.056999999999995,
      25.871000000000002,
      21.836999999999996,
      24.001,
      21.286999999999995,
      23.691,
    );
    path_28.cubicTo(
      20.726999999999997,
      23.361,
      24.916999999999994,
      16.801,
      34.077,
      17.480999999999998,
    );
    path_28.close();
    path_28.moveTo(40.217, 10.150000000000002);
    path_28.cubicTo(
      41.086999999999996,
      11.820000000000002,
      40.817,
      14.900000000000002,
      31.987,
      15.330000000000002,
    );
    path_28.cubicTo(
      23.156999999999996,
      15.760000000000002,
      31.226999999999997,
      9.05,
      34.927,
      8.730000000000002,
    );
    path_28.cubicTo(
      38.617,
      8.410000000000002,
      39.897,
      9.540000000000003,
      40.217,
      10.150000000000002,
    );
    path_28.close();
    path_28.moveTo(40.547, 16.520000000000003);
    path_28.cubicTo(
      47.876999999999995,
      18.380000000000003,
      35.206999999999994,
      24.080000000000002,
      34.277,
      23.680000000000003,
    );
    path_28.cubicTo(
      33.337,
      23.280000000000005,
      36.937,
      15.610000000000003,
      40.547,
      16.520000000000003,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(39.717, 13.22);
    path_29.cubicTo(39.717, 13.22, 37.867, 16.07, 36.637, 17.14);
    path_29.cubicTo(
      35.407000000000004,
      18.21,
      31.987000000000002,
      17.45,
      31.987000000000002,
      17.45,
    );
    path_29.cubicTo(
      31.987000000000002,
      17.45,
      36.117000000000004,
      14.809999999999999,
      39.717,
      13.219999999999999,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(42.667, 10.22);
    path_30.cubicTo(42.667, 10.22, 40.987, 12.23, 39.717, 12.89);
    path_30.cubicTo(38.457, 13.55, 34.847, 15.31, 31.567, 16.29);
    path_30.cubicTo(
      28.287,
      17.27,
      25.667,
      16.919999999999998,
      25.667,
      16.919999999999998,
    );
    path_30.cubicTo(
      25.667,
      16.919999999999998,
      30.647000000000002,
      17.72,
      31.987000000000002,
      17.27,
    );
    path_30.cubicTo(33.327000000000005, 16.82, 37.017, 14.19, 39.467, 13.6);
    path_30.cubicTo(
      39.467,
      13.6,
      41.357,
      12.559999999999999,
      42.667,
      10.219999999999999,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(34.967, 3.64);
    path_31.cubicTo(
      35.266999999999996,
      4.42,
      28.116999999999997,
      11.47,
      25.666999999999998,
      12.3,
    );
    path_31.cubicTo(
      23.217,
      13.13,
      26.256999999999998,
      2.83,
      28.226999999999997,
      1.6000000000000014,
    );
    path_31.cubicTo(
      30.186999999999998,
      0.36000000000000143,
      34.967,
      3.6400000000000015,
      34.967,
      3.6400000000000015,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(27.997, 1.06);
    path_32.cubicTo(27.997, 1.06, 27.147, 2.9000000000000004, 26.107, 5.76);
    path_32.cubicTo(25.067, 8.62, 22.107, 10.98, 22.107, 10.98);
    path_32.cubicTo(
      22.107,
      10.98,
      21.686999999999998,
      5.760000000000001,
      27.997,
      1.0600000000000005,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(109.197, 92.27);
    path_33.cubicTo(109.887, 90.57, 109.84700000000001, 85.53, 106.867, 83.41);
    path_33.cubicTo(103.887, 81.28999999999999, 96.787, 84.2, 93.137, 88.31);
    path_33.cubicTo(89.487, 92.42, 91.81700000000001, 94.62, 97.767, 95.09);
    path_33.cubicTo(103.717, 95.56, 108.657, 93.59, 109.197, 92.27000000000001);
    path_33.close();
    path_33.moveTo(89.917, 83.63);
    path_33.cubicTo(
      91.357,
      85.03999999999999,
      91.057,
      86.97999999999999,
      88.197,
      87.55,
    );
    path_33.cubicTo(
      85.337,
      88.11999999999999,
      82.977,
      85.39,
      82.767,
      84.39999999999999,
    );
    path_33.cubicTo(
      82.557,
      83.41999999999999,
      88.987,
      82.71999999999998,
      89.917,
      83.63,
    );
    path_33.close();
    path_33.moveTo(71.788, 92.27);
    path_33.cubicTo(
      74.898,
      90.64999999999999,
      72.66799999999999,
      87.97999999999999,
      68.66799999999999,
      85.69,
    );
    path_33.cubicTo(
      64.66799999999999,
      83.4,
      53.337999999999994,
      87.14999999999999,
      52.13799999999999,
      88.14,
    );
    path_33.cubicTo(
      50.93799999999999,
      89.13,
      61.60799999999999,
      97.56,
      71.78799999999998,
      92.27,
    );
    path_33.close();
    path_33.moveTo(54.887, 83.21);
    path_33.cubicTo(
      56.057,
      84.78999999999999,
      52.887,
      86.47999999999999,
      51.097,
      84.47999999999999,
    );
    path_33.cubicTo(
      49.307,
      82.47999999999999,
      54.097,
      82.14999999999999,
      54.887,
      83.21,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(49.117, 90.34);
    path_34.cubicTo(51.817, 88.79, 50.217, 79.98, 42.117, 78.79);
    path_34.cubicTo(
      34.016999999999996,
      77.60000000000001,
      39.836999999999996,
      95.68,
      49.117,
      90.34,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(72.687, 88.93);
    path_35.cubicTo(
      72.687,
      88.93,
      72.567,
      94.48,
      63.946999999999996,
      93.47000000000001,
    );
    path_35.cubicTo(
      51.747,
      92.04,
      53.266999999999996,
      87.56000000000002,
      53.266999999999996,
      87.56000000000002,
    );
    path_35.cubicTo(
      53.266999999999996,
      87.56000000000002,
      52.13699999999999,
      88.15000000000002,
      51.806999999999995,
      88.48000000000002,
    );
    path_35.cubicTo(
      51.477,
      88.81000000000002,
      54.846999999999994,
      93.68000000000002,
      63.577,
      94.38000000000002,
    );
    path_35.cubicTo(
      72.297,
      95.08000000000003,
      73.707,
      91.47000000000003,
      73.607,
      90.71000000000002,
    );
    path_35.cubicTo(
      73.507,
      89.94000000000003,
      72.687,
      88.93000000000002,
      72.687,
      88.93000000000002,
    );
    path_35.close();
    path_35.moveTo(54.887, 83.21000000000001);
    path_35.cubicTo(
      54.887,
      83.21000000000001,
      55.597,
      84.87,
      53.347,
      84.91000000000001,
    );
    path_35.cubicTo(
      51.097,
      84.95000000000002,
      50.697,
      83.55000000000001,
      50.697,
      83.55000000000001,
    );
    path_35.cubicTo(
      50.697,
      83.55000000000001,
      50.377,
      85.74000000000001,
      53.377,
      85.75000000000001,
    );
    path_35.cubicTo(
      56.387,
      85.77000000000001,
      54.887,
      83.21000000000001,
      54.887,
      83.21000000000001,
    );
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(27.147, 69.69);
    path_36.cubicTo(28.317, 71.27, 25.147, 72.96, 23.357, 70.96);
    path_36.cubicTo(
      21.576999999999998,
      68.94999999999999,
      26.366999999999997,
      68.63,
      27.147,
      69.69,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(27.147, 69.69);
    path_37.cubicTo(27.147, 69.69, 27.857, 71.35, 25.607, 71.39);
    path_37.cubicTo(23.357, 71.43, 22.957, 70.03, 22.957, 70.03);
    path_37.cubicTo(22.957, 70.03, 22.637, 72.22, 25.637, 72.23);
    path_37.cubicTo(
      28.657,
      72.24000000000001,
      27.147000000000002,
      69.69,
      27.147000000000002,
      69.69,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(90.677, 94.49);
    path_38.cubicTo(
      91.537,
      95.64999999999999,
      89.20700000000001,
      96.89,
      87.897,
      95.42,
    );
    path_38.cubicTo(86.587, 93.95, 90.107, 93.72, 90.677, 94.49);
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(90.677, 94.49);
    path_39.cubicTo(90.677, 94.49, 91.197, 95.71, 89.54700000000001, 95.74);
    path_39.cubicTo(
      87.897,
      95.77,
      87.60700000000001,
      94.74,
      87.60700000000001,
      94.74,
    );
    path_39.cubicTo(
      87.60700000000001,
      94.74,
      87.37700000000001,
      96.35,
      89.57700000000001,
      96.36,
    );
    path_39.cubicTo(91.787, 96.36, 90.677, 94.49, 90.677, 94.49);
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(84.167, 87.54);
    path_40.cubicTo(
      85.027,
      89.11,
      82.697,
      90.80000000000001,
      81.387,
      88.80000000000001,
    );
    path_40.cubicTo(
      80.077,
      86.82000000000001,
      83.587,
      86.49000000000001,
      84.167,
      87.54,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(84.167, 87.54);
    path_41.cubicTo(84.167, 87.54, 84.687, 89.2, 83.037, 89.23);
    path_41.cubicTo(
      81.387,
      89.27000000000001,
      81.09700000000001,
      87.88000000000001,
      81.09700000000001,
      87.88000000000001,
    );
    path_41.cubicTo(
      81.09700000000001,
      87.88000000000001,
      80.867,
      90.06000000000002,
      83.06700000000001,
      90.07000000000001,
    );
    path_41.cubicTo(85.26700000000001, 90.09, 84.167, 87.54, 84.167, 87.54);
    path_41.close();
    path_41.moveTo(108.937, 86.26);
    path_41.cubicTo(
      108.937,
      86.26,
      109.697,
      91.73,
      105.50699999999999,
      93.41000000000001,
    );
    path_41.cubicTo(
      101.30699999999999,
      95.09000000000002,
      95.63699999999999,
      94.59000000000002,
      93.38699999999999,
      93.70000000000002,
    );
    path_41.cubicTo(
      91.13699999999999,
      92.81000000000002,
      91.49699999999999,
      91.01000000000002,
      91.49699999999999,
      91.01000000000002,
    );
    path_41.cubicTo(
      91.49699999999999,
      91.01000000000002,
      90.92699999999999,
      92.34000000000002,
      91.92699999999999,
      94.13000000000002,
    );
    path_41.cubicTo(
      92.92699999999999,
      95.92000000000003,
      104.797,
      96.49000000000002,
      108.33699999999999,
      94.38000000000002,
    );
    path_41.cubicTo(
      111.86699999999999,
      92.27000000000002,
      108.93699999999998,
      86.26000000000002,
      108.93699999999998,
      86.26000000000002,
    );
    path_41.close();
    path_41.moveTo(90.277, 84.04);
    path_41.cubicTo(90.277, 84.04, 90.937, 85.29, 89.897, 86.27000000000001);
    path_41.cubicTo(
      88.85700000000001,
      87.25000000000001,
      86.15700000000001,
      87.34,
      84.417,
      86.03000000000002,
    );
    path_41.cubicTo(
      82.677,
      84.72000000000001,
      82.857,
      84.16000000000001,
      82.857,
      84.16000000000001,
    );
    path_41.cubicTo(
      82.857,
      84.16000000000001,
      82.737,
      84.35000000000001,
      82.707,
      84.64000000000001,
    );
    path_41.cubicTo(
      82.687,
      84.94000000000001,
      84.077,
      87.56000000000002,
      87.377,
      87.90000000000002,
    );
    path_41.cubicTo(
      90.67699999999999,
      88.26000000000002,
      91.827,
      85.84000000000002,
      90.277,
      84.04000000000002,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(117.067, 82.59);
    path_42.cubicTo(
      119.237,
      84.36,
      118.33699999999999,
      87.64,
      114.377,
      88.63000000000001,
    );
    path_42.cubicTo(
      111.627,
      89.31000000000002,
      109.937,
      86.61000000000001,
      109.797,
      85.63000000000001,
    );
    path_42.cubicTo(
      109.657,
      84.64000000000001,
      115.827,
      81.58000000000001,
      117.067,
      82.59,
    );
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(117.567, 83.1);
    path_43.cubicTo(117.567, 83.1, 118.437, 84.94, 116.657, 86.71);
    path_43.cubicTo(115.167, 88.19, 112.347, 88.44, 110.957, 87.11);
    path_43.cubicTo(109.737, 85.96, 109.857, 85.35, 109.857, 85.35);
    path_43.cubicTo(
      109.857,
      85.35,
      109.777,
      85.55999999999999,
      109.757,
      85.86999999999999,
    );
    path_43.cubicTo(
      109.73700000000001,
      86.17999999999999,
      110.677,
      88.71999999999998,
      113.477,
      89.05999999999999,
    );
    path_43.cubicTo(117.527, 89.57, 119.947, 85.6, 117.56700000000001, 83.1);
    path_43.close();
    path_43.moveTo(49.706999999999994, 84.53);
    path_43.cubicTo(
      49.706999999999994,
      84.53,
      50.67699999999999,
      87.28,
      49.11699999999999,
      89.02,
    );
    path_43.cubicTo(
      47.55699999999999,
      90.75999999999999,
      44.66699999999999,
      90.82,
      41.42699999999999,
      87.83999999999999,
    );
    path_43.cubicTo(
      38.187,
      84.85999999999999,
      38.43699999999999,
      81.07999999999998,
      38.43699999999999,
      81.07999999999998,
    );
    path_43.cubicTo(
      38.43699999999999,
      81.07999999999998,
      37.87699999999999,
      82.41999999999999,
      38.43699999999999,
      85.24999999999999,
    );
    path_43.cubicTo(
      38.98699999999999,
      88.07999999999998,
      41.78699999999999,
      92.17999999999998,
      47.35699999999999,
      92.11999999999999,
    );
    path_43.cubicTo(
      52.916999999999994,
      92.05999999999999,
      50.38699999999999,
      85.32,
      49.706999999999994,
      84.52999999999999,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(85.137, 97.66);
    path_44.cubicTo(87.607, 96.14, 85.217, 89.58, 77.237, 89.64);
    path_44.cubicTo(69.25699999999999, 89.71, 76.637, 102.88, 85.137, 97.66);
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(85.157, 93.13);
    path_45.cubicTo(
      85.157,
      93.13,
      86.36699999999999,
      95.11999999999999,
      85.00699999999999,
      96.64999999999999,
    );
    path_45.cubicTo(
      83.657,
      98.16999999999999,
      80.85699999999999,
      98.57,
      77.41699999999999,
      96.67999999999999,
    );
    path_45.cubicTo(
      73.97699999999999,
      94.78999999999999,
      73.86699999999999,
      91.85,
      73.86699999999999,
      91.85,
    );
    path_45.cubicTo(
      73.86699999999999,
      91.85,
      73.457,
      92.94,
      74.25699999999999,
      95.05,
    );
    path_45.cubicTo(75.067, 97.16, 78.17699999999999, 99.96, 83.577, 99.24);
    path_45.cubicTo(
      88.997,
      98.52,
      85.89699999999999,
      93.64999999999999,
      85.157,
      93.13,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(14.907, 47.45);
    path_46.cubicTo(14.957, 44.09, 9.876999999999999, 41.56, 6.237, 45.99);
    path_46.cubicTo(2.607, 50.42, 14.837, 52.32, 14.907, 47.45);
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(14.547, 45.9);
    path_47.cubicTo(14.547, 45.9, 15.217, 49.06, 11.687000000000001, 49.73);
    path_47.cubicTo(
      8.157000000000002,
      50.4,
      5.387000000000001,
      48.37,
      5.987000000000001,
      46.33,
    );
    path_47.cubicTo(
      5.987000000000001,
      46.33,
      5.067000000000001,
      47.1,
      4.797000000000001,
      48.32,
    );
    path_47.cubicTo(
      4.537000000000001,
      49.54,
      7.367000000000001,
      51.730000000000004,
      12.587,
      51.35,
    );
    path_47.cubicTo(17.817, 50.97, 15.357, 46.99, 14.547, 45.9);
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(8.147, 45.52);
    path_48.cubicTo(9.357, 45.52, 9.207, 47.370000000000005, 7.287, 47.2);
    path_48.cubicTo(5.377, 47.040000000000006, 7.257, 45.52, 8.147, 45.52);
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(88.247, 73.46);
    path_49.cubicTo(90.957, 71.88, 87.027, 70.69999999999999, 82.707, 71.86);
    path_49.cubicTo(78.387, 73.03, 84.317, 75.75, 88.247, 73.46);
    path_49.close();
    path_49.moveTo(85.498, 68.03);
    path_49.cubicTo(86.298, 68.56, 85.92800000000001, 69.41, 84.068, 68.61);
    path_49.cubicTo(82.208, 67.81, 84.108, 67.1, 85.498, 68.03);
    path_49.close();
    path_49.moveTo(68.87700000000001, 72.23);
    path_49.cubicTo(
      74.007,
      72.68,
      72.227,
      76.27000000000001,
      65.65700000000001,
      75.39,
    );
    path_49.cubicTo(
      59.08700000000001,
      74.52,
      66.43700000000001,
      72.02,
      68.87700000000001,
      72.23,
    );
    path_49.close();
    path_49.moveTo(72.30700000000002, 69.10000000000001);
    path_49.cubicTo(
      74.41700000000002,
      69.60000000000001,
      71.63700000000001,
      70.94000000000001,
      71.25700000000002,
      70.67,
    );
    path_49.cubicTo(
      70.87700000000002,
      70.39,
      71.37700000000002,
      68.88,
      72.30700000000002,
      69.10000000000001,
    );
    path_49.close();
    path_49.moveTo(61.86700000000002, 47.510000000000005);
    path_49.cubicTo(
      62.78700000000002,
      49.53000000000001,
      57.71700000000002,
      48.440000000000005,
      56.64700000000002,
      46.650000000000006,
    );
    path_49.cubicTo(
      55.57700000000002,
      44.870000000000005,
      60.36700000000002,
      44.220000000000006,
      61.86700000000002,
      47.510000000000005,
    );
    path_49.close();
    path_49.moveTo(78.45700000000002, 60.93000000000001);
    path_49.cubicTo(
      78.81700000000002,
      62.42000000000001,
      76.38700000000003,
      62.410000000000004,
      75.45700000000002,
      60.93000000000001,
    );
    path_49.cubicTo(
      74.52700000000002,
      59.45000000000001,
      78.16700000000002,
      59.760000000000005,
      78.45700000000002,
      60.93000000000001,
    );
    path_49.close();
    path_49.moveTo(83.76800000000003, 69.65);
    path_49.cubicTo(
      86.06800000000003,
      70.57000000000001,
      83.19800000000004,
      71.76,
      79.88800000000003,
      71.4,
    );
    path_49.cubicTo(
      76.57800000000003,
      71.03,
      81.14800000000004,
      68.60000000000001,
      83.76800000000003,
      69.65,
    );
    path_49.close();
    path_49.moveTo(111.41800000000003, 67.59);
    path_49.cubicTo(
      115.00800000000004,
      68.60000000000001,
      110.83800000000004,
      70.03,
      108.64800000000004,
      69.65,
    );
    path_49.cubicTo(
      106.45800000000004,
      69.27000000000001,
      108.51800000000004,
      66.77000000000001,
      111.41800000000003,
      67.59,
    );
    path_49.close();
    path_49.moveTo(108.74700000000003, 55.690000000000005);
    path_49.cubicTo(
      109.71700000000003,
      56.230000000000004,
      108.12700000000002,
      56.980000000000004,
      107.26700000000002,
      56.24,
    );
    path_49.cubicTo(
      106.40700000000002,
      55.49,
      107.88700000000003,
      55.21,
      108.74700000000003,
      55.690000000000005,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(54.787, 57.61);
    path_50.cubicTo(65.917, 60.93, 56.217, 73.51, 36.117, 67.95);
    path_50.cubicTo(16.026999999999997, 62.38, 40.067, 53.22, 54.787, 57.61);
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(50.917, 62.77);
    path_51.cubicTo(52.697, 60.830000000000005, 54.137, 51.47, 46.137, 47.34);
    path_51.cubicTo(38.137, 43.21, 28.687, 52.5, 27.507, 56.06);
    path_51.cubicTo(26.327, 59.61, 31.977, 64.83, 34.767, 66.22);
    path_51.cubicTo(
      37.547000000000004,
      67.62,
      46.407000000000004,
      67.67,
      50.917,
      62.769999999999996,
    );
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2351883, size.height * 0.6343774),
      Offset(size.width * 0.3025584, size.height * 0.3871792),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(48.358, 51.62);
    path_52.cubicTo(
      50.488,
      54.79,
      48.428,
      63.43,
      40.657999999999994,
      64.22999999999999,
    );
    path_52.cubicTo(
      32.88799999999999,
      65.02999999999999,
      27.987999999999992,
      57.37999999999999,
      29.877999999999993,
      53.60999999999999,
    );
    path_52.cubicTo(
      31.757999999999992,
      49.82999999999999,
      44.407999999999994,
      45.739999999999995,
      48.35799999999999,
      51.61999999999999,
    );
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(48.797, 49.8);
    path_53.cubicTo(
      49.577,
      51.559999999999995,
      44.236999999999995,
      56.66,
      39.927,
      58.269999999999996,
    );
    path_53.cubicTo(
      35.617,
      59.88999999999999,
      28.557000000000002,
      56.379999999999995,
      28.157,
      55.92999999999999,
    );
    path_53.cubicTo(
      27.747,
      55.489999999999995,
      36.167,
      46.11999999999999,
      41.737,
      46.309999999999995,
    );
    path_53.cubicTo(
      47.307,
      46.49999999999999,
      48.797000000000004,
      49.8,
      48.797000000000004,
      49.8,
    );
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(42.237, 66.55);
    path_54.cubicTo(
      43.727000000000004,
      67.17,
      49.477000000000004,
      64.83,
      51.007000000000005,
      61.769999999999996,
    );
    path_54.cubicTo(
      52.537000000000006,
      58.699999999999996,
      50.77700000000001,
      51.629999999999995,
      50.487,
      51.199999999999996,
    );
    path_54.cubicTo(
      50.197,
      50.769999999999996,
      42.007000000000005,
      58.029999999999994,
      40.647000000000006,
      59.08,
    );
    path_54.cubicTo(
      39.297000000000004,
      60.129999999999995,
      41.717000000000006,
      66.33,
      42.23700000000001,
      66.55,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(40.868, 66.65);
    path_55.cubicTo(
      41.468,
      66.45,
      40.608000000000004,
      61.39000000000001,
      39.268,
      60.160000000000004,
    );
    path_55.cubicTo(
      37.938,
      58.93000000000001,
      28.548000000000002,
      57.150000000000006,
      28.098,
      57.17,
    );
    path_55.cubicTo(
      27.657999999999998,
      57.190000000000005,
      29.218,
      67.04,
      40.867999999999995,
      66.65,
    );
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(43.798, 56.13);
    path_56.cubicTo(
      44.058,
      56.04,
      40.238,
      60.480000000000004,
      39.928000000000004,
      60.5,
    );
    path_56.cubicTo(39.608000000000004, 60.52, 34.898, 58.65, 34.758, 58.53);
    path_56.cubicTo(34.618, 58.4, 39.948, 57.47, 43.798, 56.13);
    path_56.close();
    path_56.moveTo(32.517, 57.86);
    path_56.cubicTo(32.517, 57.86, 30.367000000000004, 57.61, 29.097, 57.32);
    path_56.cubicTo(
      27.837,
      57.03,
      27.717000000000002,
      55.85,
      27.857000000000003,
      55.73,
    );
    path_56.cubicTo(28.007, 55.62, 29.877000000000002, 56.93, 32.517, 57.86);
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_56, paint56Fill);

    Path path_57 = Path();
    path_57.moveTo(42.947, 56.02);
    path_57.cubicTo(
      45.907000000000004,
      54.5,
      43.687000000000005,
      49.150000000000006,
      38.417,
      49.11,
    );
    path_57.cubicTo(33.147000000000006, 49.07, 31.327, 53.86, 31.097, 55.53);
    path_57.cubicTo(30.867, 57.19, 36.377, 59.38, 42.947, 56.02);
    path_57.close();

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = GameColors.islandPainterColor71.withValues(alpha: 1.0);
    canvas.drawPath(path_57, paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(58.557, 63.22);
    path_58.cubicTo(61.627, 63.64, 68.887, 67.95, 61.347, 68.78);
    path_58.cubicTo(53.807, 69.61, 50.177, 67.64, 49.157000000000004, 65.85);
    path_58.cubicTo(
      48.127,
      64.05999999999999,
      54.327000000000005,
      62.63999999999999,
      58.557,
      63.21999999999999,
    );
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_58, paint58Fill);

    Path path_59 = Path();
    path_59.moveTo(56.867, 66.4);
    path_59.cubicTo(
      60.637,
      66.07000000000001,
      60.227,
      59.77,
      57.937,
      57.970000000000006,
    );
    path_59.cubicTo(
      55.647,
      56.17000000000001,
      48.846999999999994,
      56.940000000000005,
      47.637,
      58.900000000000006,
    );
    path_59.cubicTo(46.427, 60.870000000000005, 49.077, 66.62, 52.247, 66.93);
    path_59.cubicTo(55.407, 67.23, 56.867, 66.4, 56.867, 66.4);
    path_59.close();

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3337208, size.height * 0.6313774),
      Offset(size.width * 0.3667013, size.height * 0.5103491),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_59, paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(59.047, 59.82);
    path_60.cubicTo(60.037, 62.02, 55.257, 64.83, 51.556999999999995, 63.71);
    path_60.cubicTo(
      47.85699999999999,
      62.58,
      47.776999999999994,
      59.870000000000005,
      48.416999999999994,
      58.86,
    );
    path_60.cubicTo(49.056999999999995, 57.83, 57.217, 55.78, 59.047, 59.82);
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_60, paint60Fill);

    Path path_61 = Path();
    path_61.moveTo(57.937, 57.97);
    path_61.cubicTo(
      58.486999999999995,
      58.94,
      55.016999999999996,
      61.03,
      52.596999999999994,
      61.39,
    );
    path_61.cubicTo(
      50.187,
      61.76,
      47.346999999999994,
      59.92,
      47.50699999999999,
      59.160000000000004,
    );
    path_61.cubicTo(
      47.67699999999999,
      58.400000000000006,
      48.76699999999999,
      57.480000000000004,
      52.00699999999999,
      57.07000000000001,
    );
    path_61.cubicTo(
      55.25699999999999,
      56.650000000000006,
      57.75699999999999,
      57.66000000000001,
      57.93699999999999,
      57.970000000000006,
    );
    path_61.close();

    Paint paint61Fill = Paint()..style = PaintingStyle.fill;
    paint61Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_61, paint61Fill);

    Path path_62 = Path();
    path_62.moveTo(58.497, 65.38);
    path_62.cubicTo(
      57.727,
      66.44999999999999,
      55.287,
      66.89,
      54.667,
      66.61999999999999,
    );
    path_62.cubicTo(
      54.047000000000004,
      66.35,
      52.787,
      61.99999999999999,
      53.057,
      61.61999999999999,
    );
    path_62.cubicTo(
      53.327000000000005,
      61.23999999999999,
      57.587,
      59.12999999999999,
      58.007000000000005,
      58.78999999999999,
    );
    path_62.cubicTo(
      58.42700000000001,
      58.44999999999999,
      60.45700000000001,
      61.75999999999999,
      58.49700000000001,
      65.38,
    );
    path_62.close();

    Paint paint62Fill = Paint()..style = PaintingStyle.fill;
    paint62Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_62, paint62Fill);

    Path path_63 = Path();
    path_63.moveTo(53.897, 66.63);
    path_63.cubicTo(
      54.327,
      66.64999999999999,
      52.827,
      62.53999999999999,
      52.387,
      62.08,
    );
    path_63.cubicTo(51.947, 61.62, 49.427, 61.37, 47.717, 60.17);
    path_63.cubicTo(
      47.717,
      60.17,
      47.907,
      63.660000000000004,
      49.876999999999995,
      65.38,
    );
    path_63.cubicTo(
      51.85699999999999,
      67.11,
      53.89699999999999,
      66.63,
      53.89699999999999,
      66.63,
    );
    path_63.close();

    Paint paint63Fill = Paint()..style = PaintingStyle.fill;
    paint63Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_63, paint63Fill);

    Path path_64 = Path();
    path_64.moveTo(54.137, 60.99);
    path_64.cubicTo(54.267, 60.96, 53.137, 62.97, 52.987, 62.93);
    path_64.cubicTo(52.827000000000005, 62.89, 50.577, 61.31, 50.577, 61.31);
    path_64.cubicTo(50.577, 61.31, 52.847, 61.260000000000005, 54.137, 60.99);
    path_64.close();
    path_64.moveTo(57.797, 58.7);
    path_64.cubicTo(57.797, 58.7, 57.367, 59.540000000000006, 56.217, 60.18);
    path_64.cubicTo(55.057, 60.82, 54.187, 61.01, 54.187, 61.01);
    path_64.cubicTo(54.187, 61.01, 55.957, 59.94, 57.797, 58.699999999999996);
    path_64.close();

    Paint paint64Fill = Paint()..style = PaintingStyle.fill;
    paint64Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_64, paint64Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class EighthIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(5.962, 83.853);
    path_0.cubicTo(
      12.652000000000001,
      91.743,
      25.992,
      97.693,
      50.732,
      99.45299999999999,
    );
    path_0.cubicTo(
      89.46199999999999,
      102.19299999999998,
      111.112,
      89.88299999999998,
      120.612,
      74.90299999999999,
    );
    path_0.cubicTo(
      126.002,
      66.39299999999999,
      127.482,
      57.01299999999999,
      125.942,
      49.03299999999999,
    );
    path_0.cubicTo(
      125.93199999999999,
      49.002999999999986,
      125.93199999999999,
      48.972999999999985,
      125.93199999999999,
      48.942999999999984,
    );
    path_0.cubicTo(
      125.862,
      48.60299999999998,
      125.79199999999999,
      48.27299999999998,
      125.71199999999999,
      47.942999999999984,
    );
    path_0.cubicTo(
      125.70199999999998,
      47.932999999999986,
      125.70199999999998,
      47.92299999999998,
      125.70199999999998,
      47.92299999999998,
    );
    path_0.cubicTo(
      124.38199999999999,
      42.21299999999998,
      121.48199999999999,
      37.29299999999998,
      117.35199999999999,
      34.04299999999998,
    );
    path_0.cubicTo(
      109.862,
      28.14299999999998,
      102.29199999999999,
      12.412999999999979,
      73.27199999999999,
      6.652999999999977,
    );
    path_0.cubicTo(
      44.251999999999995,
      0.8929999999999776,
      7.121999999999986,
      10.592999999999977,
      7.49199999999999,
      28.75299999999998,
    );
    path_0.cubicTo(
      7.5619999999999905,
      31.99299999999998,
      6.51199999999999,
      36.13299999999998,
      5.17199999999999,
      40.80299999999998,
    );
    path_0.cubicTo(
      5.17199999999999,
      40.80299999999998,
      5.17199999999999,
      40.81299999999998,
      5.16199999999999,
      40.81299999999998,
    );
    path_0.cubicTo(
      5.16199999999999,
      40.82299999999998,
      5.16199999999999,
      40.84299999999998,
      5.15199999999999,
      40.85299999999998,
    );
    path_0.cubicTo(
      1.3719999999999906,
      54.03299999999998,
      -4.638000000000009,
      71.36299999999999,
      5.961999999999991,
      83.85299999999998,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4980630, size.height * 0.9982900),
      Offset(size.width * 0.4980630, size.height * 0.04988000),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(50.722, 99.443);
    path_1.cubicTo(
      111.44200000000001,
      103.733,
      130.192,
      71.063,
      125.93199999999999,
      49.022999999999996,
    );
    path_1.cubicTo(
      126.60199999999999,
      53.132999999999996,
      127.082,
      67.943,
      103.97199999999998,
      82.453,
    );
    path_1.cubicTo(
      76.79199999999997,
      99.513,
      36.931999999999974,
      98.043,
      18.05199999999998,
      83.88300000000001,
    );
    path_1.cubicTo(
      -0.3680000000000234,
      70.06300000000002,
      4.891999999999978,
      42.19300000000001,
      5.151999999999978,
      40.84300000000001,
    );
    path_1.cubicTo(
      -1.0080000000000222,
      62.38300000000001,
      -13.138000000000021,
      94.93300000000002,
      50.72199999999998,
      99.44300000000001,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4980630, size.height * 0.9982900),
      Offset(size.width * 0.4980630, size.height * 0.4083800),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(5.962, 83.853);
    path_2.cubicTo(
      12.652000000000001,
      91.743,
      25.992,
      97.693,
      50.732,
      99.45299999999999,
    );
    path_2.cubicTo(
      89.46199999999999,
      102.19299999999998,
      111.112,
      89.88299999999998,
      120.612,
      74.90299999999999,
    );
    path_2.cubicTo(
      120.612,
      74.90299999999999,
      87.91199999999999,
      96.04299999999999,
      61.91199999999999,
      96.863,
    );
    path_2.cubicTo(
      35.91199999999999,
      97.68299999999999,
      5.961999999999989,
      83.853,
      5.961999999999989,
      83.853,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4982835, size.height * 0.9982900),
      Offset(size.width * 0.4982835, size.height * 0.7489400),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(115.172, 41.433);
    path_3.cubicTo(124.082, 50.073, 117.032, 81.643, 70.722, 83.40299999999999);
    path_3.cubicTo(
      10.791999999999994,
      85.68299999999999,
      9.031999999999996,
      57.48299999999999,
      8.521999999999991,
      47.48299999999999,
    );
    path_3.cubicTo(
      8.011999999999992,
      37.48299999999999,
      25.191999999999993,
      32.47299999999999,
      26.38199999999999,
      30.33299999999999,
    );
    path_3.cubicTo(
      27.571999999999992,
      28.19299999999999,
      14.55199999999999,
      6.582999999999991,
      56.751999999999995,
      9.452999999999992,
    );
    path_3.cubicTo(
      98.952,
      12.332999999999991,
      101.43199999999999,
      29.42299999999999,
      99.012,
      32.00299999999999,
    );
    path_3.cubicTo(
      96.592,
      34.59299999999999,
      107.94200000000001,
      34.43299999999999,
      115.172,
      41.43299999999999,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5001024, size.height * 0.8353800),
      Offset(size.width * 0.5001024, size.height * 0.09196000),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(117.872, 46.133);
    path_4.cubicTo(117.872, 46.133, 124.452, 72.503, 79.50200000000001, 79.843);
    path_4.cubicTo(
      34.55200000000001,
      87.183,
      13.922000000000011,
      66.173,
      10.482000000000014,
      55.143,
    );
    path_4.cubicTo(
      8.142000000000014,
      47.633,
      9.372000000000014,
      43.343,
      9.372000000000014,
      43.343,
    );
    path_4.cubicTo(
      9.372000000000014,
      43.343,
      6.572000000000014,
      47.723000000000006,
      9.712000000000014,
      60.143,
    );
    path_4.cubicTo(
      12.862000000000014,
      72.563,
      27.392000000000014,
      83.483,
      65.50200000000001,
      85.163,
    );
    path_4.cubicTo(
      103.61200000000001,
      86.843,
      122.44200000000001,
      69.553,
      117.87200000000001,
      46.132999999999996,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4990945, size.height * 0.8527300),
      Offset(size.width * 0.4990945, size.height * 0.4333800),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(26.472, 17.394);
    path_5.cubicTo(
      24.912000000000003,
      23.473999999999997,
      28.082,
      27.513999999999996,
      30.252000000000002,
      28.494,
    );
    path_5.cubicTo(
      32.422000000000004,
      29.474,
      23.742000000000004,
      32.134,
      23.742000000000004,
      32.134,
    );
    path_5.cubicTo(
      23.742000000000004,
      32.134,
      25.822000000000003,
      30.664,
      25.572000000000003,
      28.804000000000002,
    );
    path_5.cubicTo(
      25.322000000000003,
      26.944000000000003,
      24.172000000000004,
      21.654000000000003,
      26.472,
      17.394000000000002,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2139921, size.height * 0.3213200),
      Offset(size.width * 0.2139921, size.height * 0.1739200),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(90.382, 76.043);
    path_6.cubicTo(
      113.132,
      66.433,
      73.50200000000001,
      39.56300000000001,
      39.312000000000005,
      38.193000000000005,
    );
    path_6.cubicTo(
      5.122000000000007,
      36.833000000000006,
      15.352000000000004,
      60.153000000000006,
      15.352000000000004,
      60.153000000000006,
    );
    path_6.cubicTo(
      15.352000000000004,
      60.153000000000006,
      33.622,
      90.24300000000001,
      90.382,
      76.043,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(96.882, 31.713);
    path_7.cubicTo(
      99.92200000000001,
      29.363,
      87.03200000000001,
      13.163,
      62.26200000000001,
      9.933,
    );
    path_7.cubicTo(
      37.482000000000006,
      6.702999999999999,
      27.25200000000001,
      16.593,
      30.602000000000007,
      25.523,
    );
    path_7.cubicTo(
      33.952000000000005,
      34.453,
      79.45200000000001,
      45.183,
      96.882,
      31.713,
    );
    path_7.close();
    path_7.moveTo(50.01200000000001, 77.65299999999999);
    path_7.cubicTo(
      79.462,
      78.323,
      66.772,
      47.602999999999994,
      40.632000000000005,
      41.962999999999994,
    );
    path_7.cubicTo(
      14.482000000000006,
      36.32299999999999,
      11.192000000000004,
      51.592999999999996,
      17.342000000000006,
      62.75299999999999,
    );
    path_7.cubicTo(
      23.492000000000004,
      73.913,
      50.01200000000001,
      77.65299999999999,
      50.01200000000001,
      77.65299999999999,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(53.882, 14.093);
    path_8.cubicTo(63.182, 17.133, 46.832, 25.483, 36.132, 22.512999999999998);
    path_8.cubicTo(
      25.421999999999997,
      19.532999999999998,
      33.641999999999996,
      7.482999999999999,
      53.882,
      14.092999999999998,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4393780, size.height * 0.2054000),
      Offset(size.width * 0.2515591, size.height * 0.1536100),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(55.682, 18.403);
    path_9.cubicTo(
      57.352000000000004,
      15.572999999999999,
      49.762,
      12.273,
      40.032000000000004,
      13.832999999999998,
    );
    path_9.cubicTo(
      30.312000000000005,
      15.392999999999999,
      31.672000000000004,
      19.372999999999998,
      31.672000000000004,
      19.372999999999998,
    );
    path_9.cubicTo(
      31.672000000000004,
      19.372999999999998,
      31.962000000000003,
      23.072999999999997,
      42.762,
      23.083,
    );
    path_9.cubicTo(53.562, 23.093, 55.682, 18.403, 55.682, 18.403);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = GameColors.islandPainterColor19.withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(89.962, 68.423);
    path_10.cubicTo(
      97.242,
      70.903,
      84.412,
      77.38300000000001,
      76.00200000000001,
      75.043,
    );
    path_10.cubicTo(
      67.58200000000001,
      72.703,
      66.96200000000002,
      60.583000000000006,
      89.96200000000002,
      68.423,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7204252, size.height * 0.7337100),
      Offset(size.width * 0.5570315, size.height * 0.6886400),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(91.382, 71.803);
    path_11.cubicTo(
      92.69200000000001,
      69.573,
      86.72200000000001,
      66.983,
      79.072,
      68.213,
    );
    path_11.cubicTo(71.422, 69.443, 72.492, 72.573, 72.492, 72.573);
    path_11.cubicTo(
      72.492,
      72.573,
      72.72200000000001,
      75.48299999999999,
      81.212,
      75.493,
    );
    path_11.cubicTo(89.712, 75.503, 91.382, 71.803, 91.382, 71.803);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = GameColors.islandPainterColor69.withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(35.142, 41.044);
    path_12.cubicTo(40.432, 42.744, 35.292, 57.684, 21.952000000000005, 56.184);
    path_12.cubicTo(
      8.612000000000009,
      54.684,
      17.912000000000006,
      35.504,
      35.142,
      41.044,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(62.532, 93.983);
    path_13.cubicTo(
      70.952,
      92.24300000000001,
      32.891999999999996,
      80.503,
      20.811999999999998,
      76.543,
    );
    path_13.cubicTo(
      8.741999999999997,
      72.57300000000001,
      9.721999999999998,
      93.30300000000001,
      62.532,
      93.983,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(21.202, 14.983);
    path_14.cubicTo(
      24.522000000000002,
      15.403,
      25.202,
      27.613,
      22.732000000000003,
      30.143,
    );
    path_14.cubicTo(
      20.262000000000004,
      32.673,
      8.522000000000002,
      39.173,
      8.522000000000002,
      39.173,
    );
    path_14.cubicTo(
      8.522000000000002,
      39.173,
      7.852000000000002,
      26.973000000000003,
      9.892000000000003,
      22.043000000000003,
    );
    path_14.cubicTo(
      11.932000000000002,
      17.103,
      21.202000000000005,
      14.983000000000004,
      21.202000000000005,
      14.983000000000004,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(121.972, 59.423);
    path_15.cubicTo(
      121.482,
      62.363,
      116.46199999999999,
      69.443,
      115.82199999999999,
      69.663,
    );
    path_15.cubicTo(
      115.18199999999999,
      69.883,
      122.84199999999998,
      53.553,
      115.82199999999999,
      42.393,
    );
    path_15.cubicTo(
      108.80199999999999,
      31.233000000000004,
      101.28199999999998,
      22.223,
      101.28199999999998,
      22.223,
    );
    path_15.cubicTo(
      101.28199999999998,
      22.223,
      117.92199999999998,
      31.883,
      121.97199999999998,
      40.163,
    );
    path_15.cubicTo(
      126.02199999999998,
      48.452999999999996,
      122.35199999999998,
      57.092999999999996,
      121.97199999999998,
      59.423,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(37.192, 90.413);
    path_16.cubicTo(43.672, 90.73299999999999, 34.722, 81.233, 25.792, 79.103);
    path_16.cubicTo(
      16.862000000000002,
      76.973,
      14.392000000000001,
      80.663,
      14.682000000000002,
      80.95299999999999,
    );
    path_16.cubicTo(
      14.982000000000003,
      81.243,
      23.252000000000002,
      89.73299999999999,
      37.19200000000001,
      90.41299999999998,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor76.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(56.112, 91.653);
    path_17.cubicTo(58.452, 90.983, 59.122, 87.643, 52.742000000000004, 85.373);
    path_17.cubicTo(
      46.362,
      83.10300000000001,
      43.862,
      87.49300000000001,
      43.612,
      88.783,
    );
    path_17.cubicTo(43.362, 90.073, 49.812000000000005, 93.463, 56.112, 91.653);
    path_17.close();
    path_17.moveTo(58.182, 85.833);
    path_17.cubicTo(
      58.312000000000005,
      86.873,
      57.172000000000004,
      87.43299999999999,
      55.942,
      86.113,
    );
    path_17.cubicTo(54.722, 84.793, 58.062, 84.903, 58.182, 85.833);
    path_17.close();
    path_17.moveTo(14.242000000000004, 76.713);
    path_17.cubicTo(
      17.212000000000003,
      75.863,
      16.082000000000004,
      71.693,
      11.972000000000005,
      70.963,
    );
    path_17.cubicTo(
      7.872000000000005,
      70.23299999999999,
      7.882000000000005,
      73.06299999999999,
      8.192000000000005,
      74.01299999999999,
    );
    path_17.cubicTo(
      8.502000000000006,
      74.95299999999999,
      11.842000000000006,
      77.40299999999999,
      14.242000000000004,
      76.713,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(61.002, 91.893);
    path_18.cubicTo(
      58.632000000000005,
      90.243,
      57.272000000000006,
      86.853,
      64.822,
      85.533,
    );
    path_18.cubicTo(
      72.372,
      84.21300000000001,
      76.362,
      88.243,
      76.69200000000001,
      90.923,
    );
    path_18.cubicTo(
      77.03200000000001,
      93.60300000000001,
      64.232,
      94.143,
      61.00200000000001,
      91.893,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(75.152, 88.053);
    path_19.cubicTo(75.152, 88.053, 76.382, 89.743, 75.112, 90.953);
    path_19.cubicTo(
      73.84199999999998,
      92.16300000000001,
      67.622,
      93.223,
      63.221999999999994,
      92.07300000000001,
    );
    path_19.cubicTo(
      58.82199999999999,
      90.92300000000002,
      59.26199999999999,
      88.36300000000001,
      59.26199999999999,
      88.36300000000001,
    );
    path_19.cubicTo(
      59.26199999999999,
      88.36300000000001,
      58.37199999999999,
      89.58300000000001,
      59.87199999999999,
      91.81300000000002,
    );
    path_19.cubicTo(
      61.37199999999999,
      94.03300000000002,
      66.342,
      94.32300000000002,
      72.452,
      93.26300000000002,
    );
    path_19.cubicTo(
      78.562,
      92.19300000000003,
      77.562,
      90.44300000000003,
      75.152,
      88.05300000000003,
    );
    path_19.close();
    path_19.moveTo(57.372, 88.393);
    path_19.cubicTo(57.372, 88.393, 58.772, 92.493, 51.512, 91.753);
    path_19.cubicTo(44.252, 91.013, 44.002, 88.673, 44.242000000000004, 87.403);
    path_19.cubicTo(
      44.242000000000004,
      87.403,
      43.19200000000001,
      88.363,
      43.452000000000005,
      89.403,
    );
    path_19.cubicTo(
      43.712,
      90.433,
      47.26200000000001,
      92.83300000000001,
      52.962,
      92.82300000000001,
    );
    path_19.cubicTo(58.642, 92.813, 58.932, 90.593, 57.372, 88.393);
    path_19.close();
    path_19.moveTo(58.012, 85.534);
    path_19.cubicTo(
      58.182,
      85.834,
      58.032000000000004,
      86.79400000000001,
      56.862,
      86.46400000000001,
    );
    path_19.cubicTo(
      55.682,
      86.13400000000001,
      55.782000000000004,
      85.35400000000001,
      55.782000000000004,
      85.35400000000001,
    );
    path_19.cubicTo(
      55.782000000000004,
      85.35400000000001,
      55.562000000000005,
      85.44400000000002,
      55.582,
      85.82400000000001,
    );
    path_19.cubicTo(
      55.602000000000004,
      86.20400000000001,
      56.442,
      87.09400000000001,
      57.502,
      87.09400000000001,
    );
    path_19.cubicTo(
      58.562000000000005,
      87.10400000000001,
      58.562000000000005,
      86.13400000000001,
      58.012,
      85.534,
    );
    path_19.close();
    path_19.moveTo(15.902000000000001, 74.583);
    path_19.cubicTo(15.902000000000001, 74.583, 14.912, 77.343, 11.782, 76.223);
    path_19.cubicTo(8.642, 75.103, 7.7620000000000005, 73.263, 8.572, 71.673);
    path_19.cubicTo(
      8.572,
      71.673,
      7.291999999999999,
      72.753,
      7.941999999999999,
      74.35300000000001,
    );
    path_19.cubicTo(
      8.581999999999999,
      75.953,
      11.741999999999999,
      77.483,
      14.201999999999998,
      77.22300000000001,
    );
    path_19.cubicTo(
      16.662,
      76.95300000000002,
      15.901999999999997,
      74.58300000000001,
      15.901999999999997,
      74.58300000000001,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(91.682, 87.183);
    path_20.cubicTo(
      93.672,
      84.82300000000001,
      90.422,
      81.99300000000001,
      86.602,
      83.66300000000001,
    );
    path_20.cubicTo(
      82.78200000000001,
      85.33300000000001,
      84.372,
      87.683,
      85.152,
      88.293,
    );
    path_20.cubicTo(
      85.94200000000001,
      88.903,
      90.082,
      89.08300000000001,
      91.682,
      87.183,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(91.882, 84.483);
    path_21.cubicTo(
      91.882,
      84.483,
      92.592,
      87.32300000000001,
      89.36200000000001,
      88.13300000000001,
    );
    path_21.cubicTo(
      86.13200000000002,
      88.94300000000001,
      84.37200000000001,
      87.903,
      84.162,
      86.13300000000001,
    );
    path_21.cubicTo(
      84.162,
      86.13300000000001,
      83.70200000000001,
      87.74300000000001,
      85.122,
      88.71300000000001,
    );
    path_21.cubicTo(
      86.54199999999999,
      89.683,
      90.012,
      89.203,
      91.922,
      87.61300000000001,
    );
    path_21.cubicTo(
      93.832,
      86.03300000000002,
      91.88199999999999,
      84.48300000000002,
      91.88199999999999,
      84.48300000000002,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(69.082, 75.693);
    path_22.cubicTo(
      69.122,
      72.693,
      64.592,
      70.43299999999999,
      61.35199999999999,
      74.393,
    );
    path_22.cubicTo(
      58.11199999999998,
      78.35300000000001,
      69.02199999999999,
      80.043,
      69.082,
      75.693,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(68.772, 74.323);
    path_23.cubicTo(
      68.772,
      74.323,
      69.36200000000001,
      77.14299999999999,
      66.22200000000001,
      77.73299999999999,
    );
    path_23.cubicTo(
      63.07200000000001,
      78.33299999999998,
      60.60200000000001,
      76.523,
      61.132000000000005,
      74.70299999999999,
    );
    path_23.cubicTo(
      61.132000000000005,
      74.70299999999999,
      60.312000000000005,
      75.39299999999999,
      60.072,
      76.48299999999999,
    );
    path_23.cubicTo(
      59.842000000000006,
      77.56299999999999,
      62.372,
      79.523,
      67.022,
      79.18299999999999,
    );
    path_23.cubicTo(
      71.682,
      78.84299999999999,
      69.492,
      75.29299999999999,
      68.772,
      74.323,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(63.062, 73.983);
    path_24.cubicTo(
      64.142,
      73.983,
      64.002,
      75.63300000000001,
      62.291999999999994,
      75.483,
    );
    path_24.cubicTo(
      60.581999999999994,
      75.333,
      62.26199999999999,
      73.983,
      63.062,
      73.983,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(112.112, 33.983);
    path_25.cubicTo(
      112.792,
      32.952999999999996,
      112.082,
      30.653,
      110.262,
      30.432999999999996,
    );
    path_25.cubicTo(
      108.44200000000001,
      30.212999999999997,
      107.582,
      31.432999999999996,
      107.242,
      33.043,
    );
    path_25.cubicTo(
      106.902,
      34.643,
      110.94200000000001,
      35.743,
      112.11200000000001,
      33.983,
    );
    path_25.close();
    path_25.moveTo(21.801999999999992, 21.473);
    path_25.cubicTo(
      24.43199999999999,
      21.762999999999998,
      23.70199999999999,
      17.482999999999997,
      20.641999999999992,
      16.073,
    );
    path_25.cubicTo(
      17.581999999999994,
      14.663,
      14.161999999999992,
      20.633,
      21.801999999999992,
      21.473,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = GameColors.islandPainterColor39.withValues(alpha: 1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(23.272, 19.063);
    path_26.cubicTo(
      23.701999999999998,
      20.583,
      21.872,
      21.453,
      19.151999999999997,
      20.372999999999998,
    );
    path_26.cubicTo(
      16.431999999999995,
      19.292999999999996,
      17.502,
      17.173,
      17.502,
      17.173,
    );
    path_26.cubicTo(
      17.502,
      17.173,
      16.762,
      18.333,
      16.701999999999998,
      19.302999999999997,
    );
    path_26.cubicTo(
      16.642,
      20.282999999999998,
      18.701999999999998,
      22.173,
      22.311999999999998,
      22.112999999999996,
    );
    path_26.cubicTo(
      25.932,
      22.052999999999997,
      23.272,
      19.062999999999995,
      23.272,
      19.062999999999995,
    );
    path_26.close();
    path_26.moveTo(112.232, 32.203);
    path_26.cubicTo(
      112.232,
      32.203,
      112.962,
      33.543000000000006,
      110.492,
      33.963,
    );
    path_26.cubicTo(
      108.03200000000001,
      34.383,
      107.42200000000001,
      32.363,
      107.42200000000001,
      32.363,
    );
    path_26.cubicTo(
      107.42200000000001,
      32.363,
      107.022,
      33.022999999999996,
      107.10200000000002,
      33.683,
    );
    path_26.cubicTo(
      107.18200000000002,
      34.342999999999996,
      108.65200000000002,
      35.553,
      111.54200000000002,
      34.983,
    );
    path_26.cubicTo(
      114.44200000000002,
      34.422999999999995,
      112.23200000000001,
      32.202999999999996,
      112.23200000000001,
      32.202999999999996,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(109.792, 30.693);
    path_27.cubicTo(110.712, 31.023, 110.262, 32.323, 109.232, 32.653);
    path_27.cubicTo(108.192, 32.983, 107.542, 32.083, 107.542, 32.083);
    path_27.cubicTo(
      107.542,
      32.083,
      108.132,
      30.093,
      109.792,
      30.692999999999998,
    );
    path_27.close();
    path_27.moveTo(20.031999999999996, 16.433);
    path_27.cubicTo(
      21.171999999999997,
      17.003,
      19.971999999999998,
      18.243,
      18.781999999999996,
      18.093,
    );
    path_27.cubicTo(
      17.591999999999995,
      17.943,
      17.871999999999996,
      16.923000000000002,
      17.871999999999996,
      16.923000000000002,
    );
    path_27.cubicTo(
      17.871999999999996,
      16.923000000000002,
      19.011999999999997,
      15.923000000000002,
      20.031999999999996,
      16.433000000000003,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = GameColors.islandPainterColor47.withValues(alpha: 1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(70.662, 35.553);
    path_28.cubicTo(
      70.44200000000001,
      36.233,
      88.47200000000001,
      37.683,
      97.822,
      36.403,
    );
    path_28.cubicTo(107.182, 35.123, 110.542, 27.883, 110.092, 26.703);
    path_28.cubicTo(109.642, 25.523, 103.102, 17.653, 87.032, 20.093);
    path_28.cubicTo(
      68.012,
      22.973,
      70.66199999999999,
      35.553,
      70.66199999999999,
      35.553,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor25.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(82.032, 21.743);
    path_29.cubicTo(85.312, 22.453, 79.342, 24.802999999999997, 77.152, 24.223);
    path_29.cubicTo(74.962, 23.643, 78.892, 21.073, 82.032, 21.743);
    path_29.close();
    path_29.moveTo(106.352, 42.664);
    path_29.cubicTo(
      108.182,
      43.624,
      106.08200000000001,
      46.924,
      101.14200000000001,
      46.344,
    );
    path_29.cubicTo(
      96.20200000000001,
      45.774,
      104.50200000000001,
      41.684,
      106.352,
      42.664,
    );
    path_29.close();
    path_29.moveTo(18.462000000000003, 47.094);
    path_29.cubicTo(
      21.552000000000003,
      48.454,
      18.022000000000002,
      48.644,
      16.682000000000002,
      48.034,
    );
    path_29.cubicTo(
      15.352000000000002,
      47.443999999999996,
      17.722,
      46.774,
      18.462000000000003,
      47.094,
    );
    path_29.close();
    path_29.moveTo(21.742000000000004, 46.793);
    path_29.cubicTo(
      22.542000000000005,
      47.483,
      20.762000000000004,
      47.653,
      19.942000000000004,
      46.933,
    );
    path_29.cubicTo(
      19.112000000000005,
      46.223,
      20.532000000000004,
      45.743,
      21.742000000000004,
      46.793,
    );
    path_29.close();
    path_29.moveTo(33.792, 65.673);
    path_29.cubicTo(
      35.412,
      65.35300000000001,
      27.612000000000002,
      61.923,
      24.612000000000002,
      62.273,
    );
    path_29.cubicTo(
      21.612000000000002,
      62.623000000000005,
      29.012,
      66.623,
      33.792,
      65.673,
    );
    path_29.close();
    path_29.moveTo(39.412, 56.433);
    path_29.cubicTo(41.402, 57.043, 38.452, 57.893, 36.992, 57.383);
    path_29.cubicTo(35.522, 56.873000000000005, 36.732, 55.613, 39.412, 56.433);
    path_29.close();
    path_29.moveTo(99.412, 46.693);
    path_29.cubicTo(
      105.34200000000001,
      48.952999999999996,
      98.932,
      52.833,
      92.792,
      49.702999999999996,
    );
    path_29.cubicTo(86.652, 46.57299999999999, 96.052, 45.413, 99.412, 46.693);
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = GameColors.islandPainterColor49.withValues(alpha: 1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(65.992, 33.353);
    path_30.cubicTo(
      66.122,
      33.523,
      66.25200000000001,
      33.613,
      66.36200000000001,
      33.603,
    );
    path_30.lineTo(66.40200000000002, 34.163000000000004);
    path_30.cubicTo(
      81.54200000000002,
      34.11300000000001,
      85.30200000000002,
      24.533,
      84.92200000000001,
      24.013000000000005,
    );
    path_30.cubicTo(
      84.53200000000001,
      23.493000000000006,
      80.98200000000001,
      22.823000000000004,
      82.18200000000002,
      22.823000000000004,
    );
    path_30.cubicTo(
      83.37200000000001,
      22.813000000000002,
      87.91200000000002,
      24.073000000000004,
      91.75200000000001,
      19.973000000000003,
    );
    path_30.cubicTo(
      95.592,
      15.873000000000001,
      101.18200000000002,
      0.9330000000000034,
      99.12200000000001,
      0.22300000000000253,
    );
    path_30.cubicTo(
      98.99200000000002,
      0.18300000000000252,
      98.80200000000002,
      0.14300000000000251,
      98.55200000000002,
      0.10300000000000253,
    );
    path_30.cubicTo(
      94.80200000000002,
      -0.38699999999999746,
      78.06200000000003,
      0.5930000000000025,
      71.14200000000002,
      9.153000000000004,
    );
    path_30.cubicTo(
      61.73200000000003,
      20.813000000000002,
      64.50200000000002,
      31.583000000000006,
      65.99200000000002,
      33.353,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6572992, size.height * 0.3292500),
      Offset(size.width * 0.6375039, size.height * 0.01121000),
      [
        GameColors.islandPainterColor6.withValues(alpha: 1),
        GameColors.islandPainterColor10.withValues(alpha: 1),
        GameColors.islandPainterColor11.withValues(alpha: 1),
        GameColors.islandPainterColor14.withValues(alpha: 1),
      ],
      [0, 0.324, 0.879, 1],
    );
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(97.382, 0.373);
    path_31.cubicTo(
      97.382,
      0.373,
      88.602,
      2.7729999999999997,
      78.052,
      13.302999999999999,
    );
    path_31.cubicTo(
      67.492,
      23.833,
      65.36200000000001,
      32.193,
      65.36200000000001,
      32.193,
    );
    path_31.cubicTo(
      65.36200000000001,
      32.193,
      61.46200000000001,
      20.162999999999997,
      71.17200000000001,
      9.712999999999997,
    );
    path_31.cubicTo(
      80.882,
      -0.7370000000000019,
      97.382,
      0.37299999999999756,
      97.382,
      0.37299999999999756,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6482992, size.height * 0.3084300),
      Offset(size.width * 0.6300236, size.height * 0.01474000),
      [
        GameColors.islandPainterColor28.withValues(alpha: 1),
        GameColors.islandPainterColor37.withValues(alpha: 1),
        GameColors.islandPainterColor45.withValues(alpha: 1),
        GameColors.islandPainterColor54.withValues(alpha: 1),
        GameColors.islandPainterColor59.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 1),
      ],
      [0, 0.265, 0.522, 0.738, 0.904, 1],
    );
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(65.992, 33.353);
    path_32.cubicTo(
      66.122,
      33.523,
      66.25200000000001,
      33.613,
      66.36200000000001,
      33.603,
    );
    path_32.lineTo(66.40200000000002, 34.163000000000004);
    path_32.cubicTo(
      81.54200000000002,
      34.11300000000001,
      85.30200000000002,
      24.533,
      84.92200000000001,
      24.013000000000005,
    );
    path_32.cubicTo(
      84.53200000000001,
      23.493000000000006,
      80.98200000000001,
      22.823000000000004,
      82.18200000000002,
      22.823000000000004,
    );
    path_32.cubicTo(
      83.37200000000001,
      22.813000000000002,
      87.91200000000002,
      24.073000000000004,
      91.75200000000001,
      19.973000000000003,
    );
    path_32.cubicTo(
      95.592,
      15.873000000000001,
      101.18200000000002,
      0.9330000000000034,
      99.12200000000001,
      0.22300000000000253,
    );
    path_32.cubicTo(
      98.99200000000002,
      0.18300000000000252,
      98.80200000000002,
      0.14300000000000251,
      98.55200000000002,
      0.10300000000000253,
    );
    path_32.lineTo(98.57200000000002, 0.26300000000000257);
    path_32.cubicTo(
      98.57200000000002,
      0.26300000000000257,
      95.63200000000002,
      11.813000000000002,
      92.95200000000001,
      16.543000000000003,
    );
    path_32.cubicTo(
      90.26200000000001,
      21.283,
      80.302,
      22.473000000000003,
      80.302,
      22.473000000000003,
    );
    path_32.cubicTo(80.302, 22.473000000000003, 83.432, 23.123, 83.742, 24.693);
    path_32.cubicTo(
      84.052,
      26.263,
      75.56200000000001,
      31.353,
      71.50200000000001,
      32.573,
    );
    path_32.cubicTo(69.45200000000001, 33.203, 67.462, 33.353, 65.992, 33.353);
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = GameColors.islandPainterColor20.withValues(alpha: 1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(96.802, 0.413);
    path_33.cubicTo(
      97.73200000000001,
      -0.017000000000000015,
      95.012,
      14.223,
      91.09200000000001,
      17.983,
    );
    path_33.cubicTo(
      87.162,
      21.753,
      69.94200000000001,
      23.173000000000002,
      69.94200000000001,
      23.173000000000002,
    );
    path_33.cubicTo(
      69.94200000000001,
      23.173000000000002,
      77.792,
      9.303000000000003,
      96.802,
      0.41300000000000026,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(81.372, 37.983);
    path_34.cubicTo(
      84.962,
      35.672999999999995,
      80.162,
      25.452999999999996,
      77.862,
      23.793,
    );
    path_34.cubicTo(
      75.562,
      22.133,
      60.971999999999994,
      33.772999999999996,
      59.88199999999999,
      36.033,
    );
    path_34.cubicTo(
      58.79199999999999,
      38.303000000000004,
      65.642,
      44.653,
      81.37199999999999,
      37.983000000000004,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5409528, size.height * 0.4224000),
      Offset(size.width * 0.6027559, size.height * 0.2323300),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(101.112, 61.613);
    path_35.cubicTo(
      99.43199999999999,
      60.963,
      103.482,
      51.503,
      105.93199999999999,
      49.823,
    );
    path_35.cubicTo(
      108.38199999999999,
      48.143,
      113.39199999999998,
      58.483000000000004,
      112.972,
      59.693,
    );
    path_35.cubicTo(112.562, 60.903, 106.792, 63.823, 101.112, 61.613);
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.8496535, size.height * 0.6250300),
      Offset(size.width * 0.8121102, size.height * 0.5095800),
      [
        GameColors.islandPainterColor24.withValues(alpha: 1),
        GameColors.islandPainterColor27.withValues(alpha: 1),
        GameColors.islandPainterColor31.withValues(alpha: 1),
        GameColors.islandPainterColor33.withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(77.862, 23.793);
    path_36.cubicTo(79.042, 24.133, 81.07199999999999, 27.863, 79.702, 31.733);
    path_36.cubicTo(78.342, 35.603, 63.522, 35.323, 61.232, 34.423);
    path_36.cubicTo(
      60.641999999999996,
      34.193000000000005,
      71.912,
      22.843000000000004,
      77.862,
      23.793,
    );
    path_36.close();
    path_36.moveTo(105.572, 50.123999999999995);
    path_36.cubicTo(
      104.342,
      51.42399999999999,
      101.762,
      56.324,
      104.11200000000001,
      58.693999999999996,
    );
    path_36.cubicTo(
      106.46200000000002,
      61.06399999999999,
      109.68200000000002,
      54.903999999999996,
      108.89200000000001,
      52.114,
    );
    path_36.cubicTo(
      108.102,
      49.324,
      106.39200000000001,
      49.254,
      105.57200000000002,
      50.123999999999995,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = GameColors.islandPainterColor40.withValues(alpha: 1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(81.802, 37.694);
    path_37.cubicTo(82.242, 36.984, 82.632, 33.994, 77.61200000000001, 34.104);
    path_37.cubicTo(
      72.59200000000001,
      34.214,
      67.59200000000001,
      35.934,
      66.072,
      36.774,
    );
    path_37.cubicTo(
      64.562,
      37.614000000000004,
      63.572,
      40.114000000000004,
      63.572,
      40.114000000000004,
    );
    path_37.cubicTo(
      63.572,
      40.114000000000004,
      67.47200000000001,
      47.764,
      81.802,
      37.694,
    );
    path_37.close();
    path_37.moveTo(109.702, 52.383);
    path_37.cubicTo(109.702, 52.383, 109.082, 54.683, 107.392, 57.753);
    path_37.cubicTo(106.152, 60.013, 103.112, 62.193, 103.112, 62.193);
    path_37.cubicTo(
      103.112,
      62.193,
      104.80199999999999,
      63.592999999999996,
      110.192,
      63.492999999999995,
    );
    path_37.cubicTo(114.342, 63.413, 112.972, 59.693, 112.972, 59.693);
    path_37.cubicTo(
      112.972,
      59.693,
      112.68199999999999,
      56.702999999999996,
      109.702,
      52.382999999999996,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(106.192, 58.324);
    path_38.cubicTo(
      104.46199999999999,
      59.294,
      105.562,
      53.744,
      107.202,
      52.653999999999996,
    );
    path_38.cubicTo(
      108.842,
      51.553999999999995,
      109.672,
      56.364,
      106.192,
      58.324,
    );
    path_38.close();
    path_38.moveTo(108.472, 60.373);
    path_38.cubicTo(106.232, 60.613, 108.062, 56.443, 109.952, 55.413);
    path_38.cubicTo(
      111.842,
      54.382999999999996,
      113.402,
      58.882999999999996,
      108.472,
      60.373,
    );
    path_38.close();
    path_38.moveTo(77.702, 32.673);
    path_38.cubicTo(80.202, 30.853, 78.072, 26.043000000000003, 75.072, 25.393);
    path_38.cubicTo(72.072, 24.753, 66.69200000000001, 30.823, 65.922, 32.323);
    path_38.cubicTo(65.142, 33.823, 73.852, 35.483000000000004, 77.702, 32.673);
    path_38.close();
    path_38.moveTo(79.562, 34.513000000000005);
    path_38.cubicTo(
      81.832,
      35.413000000000004,
      78.572,
      37.46300000000001,
      74.082,
      36.96300000000001,
    );
    path_38.cubicTo(
      69.59199999999998,
      36.46300000000001,
      76.18199999999999,
      33.16300000000001,
      79.562,
      34.513000000000005,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(72.682, 34.683);
    path_39.cubicTo(72.682, 34.683, 70.382, 35.853, 68.842, 36.033);
    path_39.cubicTo(
      67.292,
      36.213,
      64.642,
      34.913000000000004,
      64.642,
      34.913000000000004,
    );
    path_39.cubicTo(
      64.642,
      34.913000000000004,
      67.85199999999999,
      34.103,
      72.68199999999999,
      34.68300000000001,
    );
    path_39.close();
    path_39.moveTo(106.53200000000001, 59.022999999999996);
    path_39.cubicTo(
      106.53200000000001,
      59.022999999999996,
      107.632,
      57.043,
      108.04200000000002,
      56.202999999999996,
    );
    path_39.cubicTo(
      108.45200000000001,
      55.36299999999999,
      109.16200000000002,
      53.983,
      109.16200000000002,
      53.983,
    );
    path_39.cubicTo(
      109.16200000000002,
      53.983,
      110.26200000000001,
      56.282999999999994,
      106.53200000000002,
      59.022999999999996,
    );
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = GameColors.islandPainterColor30.withValues(alpha: 1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(104.142, 61.393);
    path_40.cubicTo(104.142, 61.393, 106.172, 59.583, 106.752, 58.743);
    path_40.cubicTo(107.332, 57.903, 108.592, 55.093, 108.592, 55.093);
    path_40.cubicTo(108.592, 55.093, 104.402, 58.453, 104.142, 61.393);
    path_40.close();
    path_40.moveTo(78.38199999999999, 33.132999999999996);
    path_40.cubicTo(
      78.38199999999999,
      33.132999999999996,
      74.972,
      33.992999999999995,
      72.40199999999999,
      34.013,
    );
    path_40.cubicTo(
      69.832,
      34.033,
      67.45199999999998,
      33.333,
      65.98199999999999,
      33.433,
    );
    path_40.cubicTo(
      64.52199999999999,
      33.533,
      62.99199999999998,
      34.773,
      62.99199999999998,
      34.773,
    );
    path_40.cubicTo(
      62.99199999999998,
      34.773,
      64.35199999999999,
      34.973000000000006,
      64.63199999999998,
      34.913000000000004,
    );
    path_40.cubicTo(
      64.91199999999998,
      34.853,
      69.50199999999998,
      34.063,
      72.67199999999997,
      34.68300000000001,
    );
    path_40.cubicTo(
      72.68199999999997,
      34.68300000000001,
      76.76199999999997,
      34.20300000000001,
      78.38199999999996,
      33.13300000000001,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = GameColors.islandPainterColor48.withValues(alpha: 1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(57.262, 33.394);
    path_41.cubicTo(58.192, 30.093999999999998, 53.812, 30.804, 53.312, 33.394);
    path_41.cubicTo(52.802, 35.994, 56.692, 35.443999999999996, 57.262, 33.394);
    path_41.close();
    path_41.moveTo(50.692, 29.363);
    path_41.cubicTo(51.012, 29.893, 49.612, 30.753, 48.392, 29.363);
    path_41.cubicTo(47.192, 27.973, 50.382000000000005, 28.833, 50.692, 29.363);
    path_41.close();
    path_41.moveTo(53.262, 52.084);
    path_41.cubicTo(54.312, 54.494, 50.122, 53.67400000000001, 49.032, 52.084);
    path_41.cubicTo(47.952, 50.494, 52.522, 50.364000000000004, 53.262, 52.084);
    path_41.close();
    path_41.moveTo(60.962, 50.623000000000005);
    path_41.cubicTo(
      60.782000000000004,
      51.283,
      58.862,
      51.763000000000005,
      58.412000000000006,
      49.973000000000006,
    );
    path_41.cubicTo(
      57.97200000000001,
      48.193000000000005,
      61.412000000000006,
      48.973000000000006,
      60.962,
      50.623000000000005,
    );
    path_41.close();
    path_41.moveTo(57.822, 53.21300000000001);
    path_41.cubicTo(
      58.752,
      53.78300000000001,
      57.862,
      54.443000000000005,
      56.292,
      54.153000000000006,
    );
    path_41.cubicTo(
      54.712,
      53.85300000000001,
      57.052,
      52.74300000000001,
      57.822,
      53.21300000000001,
    );
    path_41.close();
    path_41.moveTo(78.382, 57.54400000000001);
    path_41.cubicTo(
      80.22200000000001,
      58.61400000000001,
      74.482,
      60.91400000000001,
      72.67200000000001,
      59.21400000000001,
    );
    path_41.cubicTo(
      70.87200000000001,
      57.50400000000001,
      74.50200000000001,
      55.274000000000015,
      78.382,
      57.54400000000001,
    );
    path_41.close();
    path_41.moveTo(82.00200000000001, 44.58300000000001);
    path_41.cubicTo(
      83.17200000000001,
      45.90300000000001,
      78.87200000000001,
      45.183000000000014,
      77.34200000000001,
      44.58300000000001,
    );
    path_41.cubicTo(
      75.802,
      43.98300000000001,
      80.12200000000001,
      42.463000000000015,
      82.00200000000001,
      44.58300000000001,
    );
    path_41.close();
    path_41.moveTo(33.62200000000001, 25.353000000000012);
    path_41.cubicTo(
      34.55200000000001,
      26.933000000000014,
      32.51200000000001,
      26.613000000000014,
      31.922000000000008,
      25.353000000000012,
    );
    path_41.cubicTo(
      31.322000000000006,
      24.083000000000013,
      33.21200000000001,
      24.653000000000013,
      33.62200000000001,
      25.353000000000012,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(62.802, 54.553);
    path_42.cubicTo(64.262, 55.702999999999996, 59.032, 57.223, 57.412, 56.543);
    path_42.cubicTo(55.802, 55.853, 59.942, 52.303, 62.802, 54.553);
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = GameColors.islandPainterColor29.withValues(alpha: 1.0);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(51.772, 50.053);
    path_43.cubicTo(
      50.192,
      48.842999999999996,
      60.062,
      42.513,
      71.77199999999999,
      45.943,
    );
    path_43.cubicTo(
      81.12199999999999,
      48.683,
      62.54199999999999,
      58.323,
      51.77199999999999,
      50.053,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(71.112, 45.833);
    path_44.cubicTo(
      73.402,
      42.242999999999995,
      72.27199999999999,
      37.123,
      69.71199999999999,
      34.202999999999996,
    );
    path_44.cubicTo(
      67.15199999999999,
      31.282999999999994,
      52.74199999999999,
      29.632999999999996,
      48.57199999999999,
      32.462999999999994,
    );
    path_44.cubicTo(
      44.40199999999999,
      35.29299999999999,
      49.79199999999999,
      46.93299999999999,
      53.11199999999999,
      49.642999999999994,
    );
    path_44.cubicTo(
      56.43199999999999,
      52.36299999999999,
      66.90199999999999,
      52.422999999999995,
      71.112,
      45.83299999999999,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4821102, size.height * 0.5217700),
      Offset(size.width * 0.5125197, size.height * 0.2630000),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(69.382, 34.433);
    path_45.cubicTo(74.352, 38.363, 62.642, 50.653, 54.242000000000004, 45.363);
    path_45.cubicTo(
      45.842000000000006,
      40.073,
      47.312000000000005,
      33.213,
      49.532000000000004,
      32.473,
    );
    path_45.cubicTo(
      51.742000000000004,
      31.723,
      63.482,
      29.762999999999998,
      69.382,
      34.433,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(69.252, 33.784);
    path_46.cubicTo(
      70.252,
      35.153999999999996,
      62.982,
      39.224,
      56.87199999999999,
      39.044,
    );
    path_46.cubicTo(
      50.76199999999999,
      38.864,
      47.831999999999994,
      35.233999999999995,
      47.59199999999999,
      33.593999999999994,
    );
    path_46.cubicTo(
      47.35199999999999,
      31.953999999999994,
      51.39199999999999,
      31.053999999999995,
      57.45199999999999,
      31.033999999999995,
    );
    path_46.cubicTo(
      63.51199999999999,
      31.003999999999994,
      68.54199999999999,
      32.803999999999995,
      69.252,
      33.78399999999999,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(69.572, 34.583);
    path_47.cubicTo(
      70.672,
      34.592999999999996,
      72.69200000000001,
      39.913,
      71.302,
      43.643,
    );
    path_47.cubicTo(69.912, 47.373, 64.382, 50.053, 63.772000000000006, 50.053);
    path_47.cubicTo(
      63.15200000000001,
      50.053,
      58.87200000000001,
      40.483,
      58.782000000000004,
      40.102999999999994,
    );
    path_47.cubicTo(58.682, 39.733, 65.162, 39.123, 69.572, 34.583);
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(61.982, 50.374);
    path_48.cubicTo(62.832, 50.154, 59.302, 41.904, 58.022, 40.774);
    path_48.cubicTo(
      56.742,
      39.644,
      50.232,
      38.094,
      47.861999999999995,
      35.224000000000004,
    );
    path_48.cubicTo(
      47.861999999999995,
      35.224000000000004,
      46.901999999999994,
      37.414,
      49.30199999999999,
      43.024,
    );
    path_48.cubicTo(
      51.69199999999999,
      48.634,
      55.532,
      52.074,
      61.98199999999999,
      50.374,
    );
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(61.792, 38.413);
    path_49.cubicTo(
      61.952,
      38.433,
      59.182,
      40.503,
      58.422000000000004,
      40.772999999999996,
    );
    path_49.cubicTo(
      57.662000000000006,
      41.032999999999994,
      53.882000000000005,
      38.632999999999996,
      53.882000000000005,
      38.632999999999996,
    );
    path_49.cubicTo(
      53.882000000000005,
      38.632999999999996,
      56.412000000000006,
      37.733,
      61.792,
      38.413,
    );
    path_49.close();
    path_49.moveTo(53.342, 38.483);
    path_49.cubicTo(
      53.342,
      38.483,
      51.902,
      38.202999999999996,
      50.472,
      37.382999999999996,
    );
    path_49.cubicTo(49.042, 36.562999999999995, 48.332, 35.163, 48.332, 35.163);
    path_49.cubicTo(48.332, 35.163, 51.562, 37.812999999999995, 53.342, 38.483);
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(45.382, 49.914);
    path_50.cubicTo(
      47.202,
      50.534,
      47.442,
      54.794000000000004,
      41.321999999999996,
      55.294000000000004,
    );
    path_50.cubicTo(
      35.202,
      55.794000000000004,
      38.321999999999996,
      47.49400000000001,
      45.382,
      49.914,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(45.842, 51.063);
    path_51.cubicTo(
      46.342,
      49.763000000000005,
      43.372,
      45.433,
      40.361999999999995,
      46.463,
    );
    path_51.cubicTo(
      37.352,
      47.493,
      36.37199999999999,
      50.423,
      37.94199999999999,
      52.883,
    );
    path_51.cubicTo(
      39.51199999999999,
      55.343,
      44.21199999999999,
      55.273,
      45.84199999999999,
      51.063,
    );
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3224488, size.height * 0.5468800),
      Offset(size.width * 0.3342283, size.height * 0.4416000),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(45.042, 49.684);
    path_52.cubicTo(45.312000000000005, 50.724, 41.552, 53.644, 38.642, 51.814);
    path_52.cubicTo(35.732, 49.994, 39.822, 46.804, 41.312000000000005, 46.744);
    path_52.cubicTo(42.812000000000005, 46.684, 44.712, 48.384, 45.042, 49.684);
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(44.942, 48.513);
    path_53.cubicTo(45.312, 49.382999999999996, 43.292, 51.143, 40.802, 51.363);
    path_53.cubicTo(38.312, 51.573, 37.532, 50.033, 37.492, 49.573);
    path_53.cubicTo(37.442, 49.113, 39.751999999999995, 46.283, 41.242, 46.463);
    path_53.cubicTo(42.732, 46.643, 44.461999999999996, 47.373, 44.942, 48.513);
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(42.372, 54.254);
    path_54.cubicTo(42.612, 54.413999999999994, 44.632, 52.884, 45.262, 51.864);
    path_54.cubicTo(
      45.892,
      50.843999999999994,
      45.422,
      49.413999999999994,
      45.192,
      49.434,
    );
    path_54.cubicTo(
      44.962,
      49.454,
      43.062,
      51.053999999999995,
      41.542,
      51.483999999999995,
    );
    path_54.cubicTo(
      41.542,
      51.483999999999995,
      41.092,
      53.413999999999994,
      42.372,
      54.254,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(41.542, 54.353);
    path_55.cubicTo(
      41.822,
      54.303000000000004,
      41.172000000000004,
      51.873000000000005,
      40.932,
      51.703,
    );
    path_55.cubicTo(
      40.692,
      51.533,
      38.302,
      51.443000000000005,
      37.322,
      49.873000000000005,
    );
    path_55.cubicTo(
      37.332,
      49.873000000000005,
      36.662000000000006,
      53.973000000000006,
      41.542,
      54.35300000000001,
    );
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(42.002, 51.134);
    path_56.cubicTo(
      42.002,
      51.134,
      41.632000000000005,
      52.004,
      41.382000000000005,
      52.114,
    );
    path_56.cubicTo(41.12200000000001, 52.224, 39.822, 51.384, 39.822, 51.384);
    path_56.cubicTo(39.822, 51.384, 40.742000000000004, 51.454, 42.002, 51.134);
    path_56.close();
    path_56.moveTo(39.492000000000004, 51.293);
    path_56.cubicTo(
      39.492000000000004,
      51.293,
      38.55200000000001,
      50.793,
      38.182,
      50.493,
    );
    path_56.cubicTo(
      37.812000000000005,
      50.193000000000005,
      37.592,
      49.903,
      37.592,
      49.903,
    );
    path_56.cubicTo(37.592, 49.903, 37.922, 51.272999999999996, 39.492, 51.293);
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_56, paint56Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class NinthIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.092, 64.485);
    path_0.cubicTo(
      4.1819999999999995,
      94.115,
      55.641999999999996,
      112.005,
      88.532,
      74.41499999999999,
    );
    path_0.cubicTo(
      91.80199999999999,
      70.675,
      92.52199999999999,
      63.37499999999999,
      89.572,
      55.29499999999999,
    );
    path_0.cubicTo(
      85.682,
      44.68499999999999,
      75.462,
      32.72499999999999,
      56.362,
      25.73499999999999,
    );
    path_0.cubicTo(
      53.422000000000004,
      24.66499999999999,
      50.572,
      23.974999999999987,
      47.782000000000004,
      23.614999999999988,
    );
    path_0.lineTo(47.752, 23.614999999999988);
    path_0.cubicTo(
      47.622,
      23.594999999999988,
      47.492000000000004,
      23.57499999999999,
      47.362,
      23.564999999999987,
    );
    path_0.cubicTo(
      46.852000000000004,
      23.514999999999986,
      46.352000000000004,
      23.464999999999986,
      45.852000000000004,
      23.424999999999986,
    );
    path_0.lineTo(45.582, 23.404999999999987);
    path_0.cubicTo(
      35.602000000000004,
      22.734999999999985,
      26.742,
      26.314999999999987,
      19.552,
      31.734999999999985,
    );
    path_0.cubicTo(
      15.042,
      35.124999999999986,
      11.182,
      39.22499999999999,
      8.132,
      43.454999999999984,
    );
    path_0.cubicTo(
      8.132,
      43.454999999999984,
      8.112,
      43.47499999999999,
      8.092,
      43.50499999999998,
    );
    path_0.cubicTo(
      5.192,
      47.50499999999998,
      3.0120000000000005,
      51.60499999999998,
      1.6520000000000001,
      55.30499999999998,
    );
    path_0.cubicTo(
      0.32200000000000006,
      58.90499999999998,
      -0.22799999999999976,
      62.11499999999998,
      0.09200000000000008,
      64.48499999999999,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4461413, size.height * 1.011875),
      Offset(size.width * 0.5893587, size.height * 0.04639583),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(13.462, 31.004);
    path_1.cubicTo(15.562, 31.364, 17.592, 31.594, 19.552, 31.734);
    path_1.cubicTo(
      32.332,
      32.574000000000005,
      41.962,
      28.724000000000004,
      47.352000000000004,
      23.564,
    );
    path_1.lineTo(47.362, 23.554);
    path_1.cubicTo(
      51.532000000000004,
      19.584,
      53.142,
      14.823999999999998,
      51.672000000000004,
      10.863999999999999,
    );
    path_1.lineTo(51.662000000000006, 10.854);
    path_1.cubicTo(
      50.922000000000004,
      8.824,
      49.36200000000001,
      7.004,
      46.932,
      5.613999999999999,
    );
    path_1.cubicTo(
      26.742,
      -5.976000000000001,
      8.132000000000005,
      2.383999999999999,
      2.0620000000000047,
      12.613999999999999,
    );
    path_1.cubicTo(
      2.0620000000000047,
      12.613999999999999,
      2.0420000000000047,
      12.643999999999998,
      2.0220000000000047,
      12.693999999999999,
    );
    path_1.cubicTo(
      -2.3879999999999955,
      20.204,
      -0.017999999999995353,
      28.694,
      13.462000000000003,
      31.003999999999998,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1539239, size.height * 1.048281),
      Offset(size.width * 0.3119239, size.height * -1.684375),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(0.092, 64.485);
    path_2.cubicTo(
      4.1819999999999995,
      94.115,
      55.641999999999996,
      112.005,
      88.532,
      74.41499999999999,
    );
    path_2.cubicTo(
      91.80199999999999,
      70.675,
      92.52199999999999,
      63.37499999999999,
      89.572,
      55.29499999999999,
    );
    path_2.lineTo(89.552, 55.264999999999986);
    path_2.cubicTo(
      90.14200000000001,
      71.84499999999998,
      69.732,
      95.92499999999998,
      40.702000000000005,
      92.15499999999999,
    );
    path_2.cubicTo(
      11.682000000000006,
      88.39499999999998,
      1.9220000000000041,
      68.90499999999999,
      1.1520000000000081,
      60.56499999999998,
    );
    path_2.cubicTo(
      0.9920000000000081,
      58.804999999999986,
      1.2120000000000082,
      57.014999999999986,
      1.6520000000000081,
      55.31499999999998,
    );
    path_2.cubicTo(
      0.32200000000000806,
      58.90499999999999,
      -0.22799999999999176,
      62.11499999999998,
      0.09200000000000808,
      64.48499999999999,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4968913, size.height * 0.9967708),
      Offset(size.width * 0.4968913, size.height * 0.5756562),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(13.462, 31.004);
    path_3.cubicTo(15.562, 31.364, 17.592, 31.594, 19.552, 31.734);
    path_3.lineTo(20.922, 30.174000000000003);
    path_3.cubicTo(
      20.922,
      30.174000000000003,
      11.732000000000001,
      27.874000000000002,
      6.102,
      24.254000000000005,
    );
    path_3.cubicTo(
      -0.9979999999999993,
      19.684000000000005,
      1.6820000000000004,
      13.534000000000004,
      2.032,
      12.694000000000004,
    );
    path_3.cubicTo(
      -2.388,
      20.204000000000004,
      -0.017999999999999794,
      28.694000000000003,
      13.462,
      31.004000000000005,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1137065, size.height * 0.3305729),
      Offset(size.width * 0.1137065, size.height * 0.1322292),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(44.791, 23.324);
    path_4.lineTo(45.580999999999996, 23.404);
    path_4.lineTo(45.851, 23.424);
    path_4.lineTo(47.361, 23.573999999999998);
    path_4.lineTo(47.760999999999996, 23.624);
    path_4.cubicTo(
      47.63099999999999,
      23.604,
      47.501,
      23.584,
      47.370999999999995,
      23.573999999999998,
    );
    path_4.cubicTo(
      51.541,
      19.604,
      53.150999999999996,
      14.843999999999998,
      51.681,
      10.883999999999999,
    );
    path_4.lineTo(51.671, 10.873999999999999);
    path_4.cubicTo(
      52.621,
      19.204,
      44.791,
      23.323999999999998,
      44.791,
      23.323999999999998,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5271304, size.height * 0.2459687),
      Offset(size.width * 0.5271304, size.height * 0.1131042),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(80.152, 42.585);
    path_5.cubicTo(88.462, 53.355000000000004, 70.752, 74.125, 38.452, 78.015);
    path_5.cubicTo(
      6.152000000000001,
      81.905,
      6.872,
      41.225,
      20.921999999999997,
      30.174999999999997,
    );
    path_5.cubicTo(
      34.971999999999994,
      19.114999999999995,
      65.842,
      24.044999999999998,
      80.15199999999999,
      42.584999999999994,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = GameColors.islandPainterColor74.withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(50.002, 9.195);
    path_6.cubicTo(
      57.662000000000006,
      15.285,
      45.652,
      22.515,
      26.112000000000002,
      24.335,
    );
    path_6.cubicTo(
      6.572000000000003,
      26.155,
      2.682000000000002,
      15.925,
      2.3820000000000014,
      14.275,
    );
    path_6.cubicTo(
      2.0620000000000016,
      12.615,
      23.122,
      -12.155,
      50.001999999999995,
      9.195,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = GameColors.islandPainterColor74.withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(59.882, 66.214);
    path_7.cubicTo(62.102, 64.544, 59.172, 51.774, 42.852, 53.174);
    path_7.cubicTo(
      26.531999999999996,
      54.574,
      26.511999999999997,
      64.53399999999999,
      27.431999999999995,
      66.204,
    );
    path_7.cubicTo(
      28.351999999999997,
      67.86399999999999,
      47.431999999999995,
      75.574,
      59.882,
      66.214,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4763478, size.height * 0.7370937),
      Offset(size.width * 0.4763478, size.height * 0.5527083),
      [
        GameColors.islandPainterColor70.withValues(alpha: 1),
        GameColors.islandPainterColor60.withValues(alpha: 1),
        GameColors.islandPainterColor55.withValues(alpha: 1),
      ],
      [0, 0.41, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(70.712, 50.924);
    path_8.cubicTo(71.732, 47.884, 61.722, 40.504, 52.22200000000001, 44.054);
    path_8.cubicTo(42.71200000000001, 47.594, 68.462, 57.584, 70.712, 50.924);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6570761, size.height * 0.5537500),
      Offset(size.width * 0.6570761, size.height * 0.4489896),
      [
        GameColors.islandPainterColor70.withValues(alpha: 1),
        GameColors.islandPainterColor60.withValues(alpha: 1),
        GameColors.islandPainterColor55.withValues(alpha: 1),
      ],
      [0, 0.41, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(60.302, 62.534);
    path_9.cubicTo(60.332, 65.564, 57.942, 66.444, 56.822, 66.894);
    path_9.cubicTo(
      55.702000000000005,
      67.334,
      60.072,
      56.334,
      43.832,
      56.644000000000005,
    );
    path_9.cubicTo(
      27.592000000000002,
      56.95400000000001,
      27.122,
      64.51400000000001,
      27.122,
      64.51400000000001,
    );
    path_9.cubicTo(
      27.122,
      64.51400000000001,
      26.622,
      53.18400000000001,
      43.712,
      53.16400000000001,
    );
    path_9.cubicTo(
      60.80200000000001,
      53.144000000000005,
      60.30200000000001,
      62.534000000000006,
      60.30200000000001,
      62.534000000000006,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4750761, size.height * 0.6969375),
      Offset(size.width * 0.4750761, size.height * 0.5537500),
      [
        GameColors.islandPainterColor77.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor34.withValues(alpha: 1),
      ],
      [0, 0.115, 0.314, 0.572, 0.876, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(69.622, 52.295);
    path_10.cubicTo(71.362, 49.765, 68.112, 45.215, 59.592, 44.915);
    path_10.cubicTo(
      51.072,
      44.615,
      51.501999999999995,
      48.125,
      51.501999999999995,
      48.125,
    );
    path_10.cubicTo(
      51.501999999999995,
      48.125,
      50.272,
      47.335,
      50.12199999999999,
      45.435,
    );
    path_10.cubicTo(
      49.971999999999994,
      43.535000000000004,
      55.49199999999999,
      42.235,
      61.70199999999999,
      43.405,
    );
    path_10.cubicTo(
      67.90199999999999,
      44.575,
      73.282,
      49.895,
      69.62199999999999,
      52.295,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6572174, size.height * 0.5447812),
      Offset(size.width * 0.6572174, size.height * 0.4475104),
      [
        GameColors.islandPainterColor77.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor34.withValues(alpha: 1),
      ],
      [0, 0.115, 0.314, 0.572, 0.876, 1],
    );
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(84.892, 63.885);
    path_11.cubicTo(84.892, 63.885, 82.422, 84.475, 50.831999999999994, 88.275);
    path_11.cubicTo(
      19.241999999999994,
      92.075,
      8.521999999999991,
      73.385,
      6.5319999999999965,
      68.69500000000001,
    );
    path_11.cubicTo(
      6.5319999999999965,
      68.69500000000001,
      19.162,
      87.81500000000001,
      48.672,
      85.775,
    );
    path_11.cubicTo(
      78.182,
      83.745,
      84.892,
      63.885000000000005,
      84.892,
      63.885000000000005,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4968913, size.height * 0.9248437),
      Offset(size.width * 0.4968913, size.height * 0.6655104),
      [
        GameColors.islandPainterColor43.withValues(alpha: 1),
        GameColors.islandPainterColor46.withValues(alpha: 1),
        GameColors.islandPainterColor53.withValues(alpha: 1),
        GameColors.islandPainterColor57.withValues(alpha: 1),
        GameColors.islandPainterColor73.withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(63.992, 85.274);
    path_12.cubicTo(63.992, 85.274, 49.532, 88.154, 33.012, 84.804);
    path_12.cubicTo(16.492, 81.45400000000001, 12.962, 77.834, 12.962, 77.834);
    path_12.cubicTo(
      12.962,
      77.834,
      30.392,
      96.48400000000001,
      63.992000000000004,
      85.274,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4183043, size.height * 0.9255833),
      Offset(size.width * 0.4183043, size.height * 0.8107292),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(45.712, 8.024);
    path_13.cubicTo(
      51.742000000000004,
      12.613999999999999,
      43.942,
      21.253999999999998,
      24.292,
      21.054,
    );
    path_13.cubicTo(
      4.642000000000003,
      20.854,
      3.8320000000000007,
      11.993999999999998,
      6.532,
      9.233999999999998,
    );
    path_13.cubicTo(
      8.762,
      6.953999999999999,
      28.742,
      -4.886000000000001,
      45.712,
      8.023999999999997,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2886630, size.height * 0.2194062),
      Offset(size.width * 0.2886630, size.height * 0.02178125),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(46.642, 8.935);
    path_14.cubicTo(48.462, 14.035, 38.932, 18.915, 25.512000000000004, 19.525);
    path_14.cubicTo(
      12.092000000000004,
      20.134999999999998,
      5.572000000000003,
      14.204999999999998,
      5.402000000000005,
      11.384999999999998,
    );
    path_14.cubicTo(
      5.402000000000005,
      11.384999999999998,
      1.8320000000000047,
      21.214999999999996,
      25.742000000000004,
      21.775,
    );
    path_14.cubicTo(
      40.69200000000001,
      22.115,
      51.22200000000001,
      16.005,
      46.642,
      8.934999999999999,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2877391, size.height * 0.2269479),
      Offset(size.width * 0.2877391, size.height * 0.09309375),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(38.392, 6.014);
    path_15.cubicTo(
      47.952000000000005,
      9.084,
      37.092000000000006,
      17.524,
      25.362000000000002,
      18.734,
    );
    path_15.cubicTo(
      13.632000000000001,
      19.944000000000003,
      8.342000000000002,
      12.224000000000002,
      8.042000000000002,
      10.844000000000001,
    );
    path_15.cubicTo(
      7.732000000000002,
      9.484000000000002,
      19.232,
      -0.12599999999999945,
      38.392,
      6.014000000000001,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(44.792, 43.754);
    path_16.cubicTo(44.712, 47.004, 31.582, 50.403999999999996, 23.262, 56.434);
    path_16.cubicTo(
      14.942,
      62.45399999999999,
      6.922000000000001,
      47.623999999999995,
      16.052,
      36.013999999999996,
    );
    path_16.cubicTo(
      25.171999999999997,
      24.413999999999994,
      44.891999999999996,
      39.254,
      44.792,
      43.754,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(75.802, 73.175);
    path_17.cubicTo(
      78.152,
      70.175,
      51.97200000000001,
      75.265,
      46.952000000000005,
      79.335,
    );
    path_17.cubicTo(
      41.922000000000004,
      83.405,
      60.782000000000004,
      92.375,
      75.802,
      73.175,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(19.152, 73.955);
    path_18.cubicTo(
      22.692,
      73.755,
      22.922,
      68.115,
      19.502000000000002,
      63.754999999999995,
    );
    path_18.cubicTo(
      16.082,
      59.394999999999996,
      11.372000000000002,
      62.154999999999994,
      10.232000000000003,
      65.785,
    );
    path_18.cubicTo(
      9.092000000000002,
      69.405,
      9.642000000000003,
      74.475,
      19.152,
      73.955,
    );
    path_18.close();
    path_18.moveTo(29.122, 76.92399999999999);
    path_18.cubicTo(
      30.822,
      74.80399999999999,
      28.122,
      69.984,
      23.752,
      73.36399999999999,
    );
    path_18.cubicTo(
      19.381999999999998,
      76.734,
      26.052,
      80.74399999999999,
      29.122,
      76.92399999999999,
    );
    path_18.close();
    path_18.moveTo(88.24199999999999, 55.794);
    path_18.cubicTo(
      90.34199999999998,
      63.964,
      81.172,
      66.78399999999999,
      78.56199999999998,
      53.974,
    );
    path_18.cubicTo(
      75.96199999999999,
      41.163999999999994,
      86.19199999999998,
      47.824,
      88.24199999999999,
      55.794,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(88.382, 56.395);
    path_19.cubicTo(
      88.382,
      56.395,
      89.452,
      60.785000000000004,
      85.72200000000001,
      61.915000000000006,
    );
    path_19.cubicTo(
      81.992,
      63.035000000000004,
      78.20200000000001,
      53.22500000000001,
      78.31200000000001,
      48.75500000000001,
    );
    path_19.cubicTo(
      78.31200000000001,
      48.75500000000001,
      77.24200000000002,
      52.86500000000001,
      79.69200000000001,
      59.51500000000001,
    );
    path_19.cubicTo(
      82.14200000000001,
      66.14500000000001,
      89.962,
      66.20500000000001,
      88.382,
      56.39500000000001,
    );
    path_19.close();
    path_19.moveTo(28.872000000000007, 73.255);
    path_19.cubicTo(
      28.872000000000007,
      73.255,
      31.132000000000005,
      76.865,
      26.922000000000008,
      77.82499999999999,
    );
    path_19.cubicTo(
      22.70200000000001,
      78.78499999999998,
      22.622000000000007,
      74.60499999999999,
      22.622000000000007,
      74.60499999999999,
    );
    path_19.cubicTo(
      22.622000000000007,
      74.60499999999999,
      22.112000000000005,
      75.23499999999999,
      22.22200000000001,
      76.445,
    );
    path_19.cubicTo(
      22.34200000000001,
      77.65499999999999,
      23.422000000000008,
      79.145,
      27.11200000000001,
      78.54499999999999,
    );
    path_19.cubicTo(
      30.81200000000001,
      77.945,
      30.53200000000001,
      75.34499999999998,
      28.87200000000001,
      73.25499999999998,
    );
    path_19.close();
    path_19.moveTo(21.352000000000007, 67.07499999999999);
    path_19.cubicTo(
      21.352000000000007,
      67.07499999999999,
      22.672000000000008,
      70.78499999999998,
      19.47200000000001,
      72.865,
    );
    path_19.cubicTo(
      16.27200000000001,
      74.94500000000001,
      11.322000000000008,
      72.865,
      10.322000000000008,
      69.725,
    );
    path_19.cubicTo(
      9.642000000000008,
      67.60499999999999,
      10.772000000000007,
      64.54499999999999,
      10.772000000000007,
      64.54499999999999,
    );
    path_19.cubicTo(
      10.772000000000007,
      64.54499999999999,
      9.152000000000008,
      66.86499999999998,
      9.462000000000007,
      69.49499999999999,
    );
    path_19.cubicTo(
      9.762000000000008,
      72.12499999999999,
      10.972000000000007,
      74.70499999999998,
      17.002000000000006,
      75.225,
    );
    path_19.cubicTo(
      23.032000000000007,
      75.74499999999999,
      22.792000000000005,
      70.49499999999999,
      21.352000000000004,
      67.07499999999999,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(58.402, 67.225);
    path_20.cubicTo(58.402, 67.225, 53.082, 69.895, 43.702, 69.905);
    path_20.cubicTo(
      34.332,
      69.905,
      30.031999999999996,
      68.175,
      30.031999999999996,
      68.175,
    );
    path_20.cubicTo(30.031999999999996, 68.175, 45.992, 75.185, 58.402, 67.225);
    path_20.close();
    path_20.moveTo(69.622, 52.294999999999995);
    path_20.cubicTo(
      69.622,
      52.294999999999995,
      63.622,
      53.404999999999994,
      54.412,
      50.13499999999999,
    );
    path_20.cubicTo(
      54.402,
      50.14499999999999,
      61.852,
      54.49499999999999,
      69.622,
      52.29499999999999,
    );
    path_20.close();
    path_20.moveTo(48.251999999999995, 92.52499999999999);
    path_20.cubicTo(
      48.251999999999995,
      92.52499999999999,
      39.431999999999995,
      90.32499999999999,
      27.111999999999995,
      86.20499999999998,
    );
    path_20.cubicTo(
      14.791999999999994,
      82.08499999999998,
      8.431999999999995,
      75.97499999999998,
      8.431999999999995,
      75.97499999999998,
    );
    path_20.cubicTo(
      8.431999999999995,
      75.97499999999998,
      19.321999999999996,
      92.98499999999999,
      48.251999999999995,
      92.52499999999998,
    );
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_20, paint20Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class TenthIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.172, 29.65);
    path_0.cubicTo(
      0.182,
      29.799999999999997,
      0.212,
      29.959999999999997,
      0.242,
      30.119999999999997,
    );
    path_0.cubicTo(
      0.282,
      30.33,
      0.312,
      30.549999999999997,
      0.352,
      30.749999999999996,
    );
    path_0.cubicTo(
      0.362,
      30.759999999999998,
      0.362,
      30.779999999999998,
      0.362,
      30.799999999999997,
    );
    path_0.cubicTo(
      1.322,
      36.199999999999996,
      3.122,
      40.769999999999996,
      5.5520000000000005,
      44.55,
    );
    path_0.lineTo(5.5520000000000005, 44.559999999999995);
    path_0.cubicTo(13.892, 57.56999999999999, 29.562, 61.36, 43.532, 58.44);
    path_0.cubicTo(
      46.872,
      57.739999999999995,
      49.611999999999995,
      57.269999999999996,
      51.961999999999996,
      56.879999999999995,
    );
    path_0.cubicTo(
      62.452,
      55.13999999999999,
      65.05199999999999,
      55.099999999999994,
      76.472,
      44.599999999999994,
    );
    path_0.cubicTo(
      80.71199999999999,
      40.699999999999996,
      83.002,
      36.129999999999995,
      83.672,
      31.459999999999994,
    );
    path_0.cubicTo(
      83.702,
      31.279999999999994,
      83.722,
      31.099999999999994,
      83.74199999999999,
      30.919999999999995,
    );
    path_0.cubicTo(
      85.01199999999999,
      20.349999999999994,
      78.192,
      9.349999999999994,
      67.452,
      4.329999999999995,
    );
    path_0.cubicTo(42.782, -7.23, -3.158, 5.42, 0.172, 29.65);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4994286, size.height * 0.9893167),
      Offset(size.width * 0.4994286, size.height * -0.006666667),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0.362, 30.79);
    path_1.cubicTo(
      4.612,
      54.769999999999996,
      25.491999999999997,
      62.2,
      43.532000000000004,
      58.42,
    );
    path_1.cubicTo(
      61.72200000000001,
      54.61,
      62.492000000000004,
      57.440000000000005,
      76.482,
      44.58,
    );
    path_1.cubicTo(80.722, 40.68, 83.012, 36.11, 83.682, 31.439999999999998);
    path_1.cubicTo(
      81.952,
      42.67,
      62.992000000000004,
      55.129999999999995,
      40.142,
      55.129999999999995,
    );
    path_1.cubicTo(
      10.882000000000001,
      55.129999999999995,
      1.9320000000000022,
      36.42999999999999,
      0.3620000000000019,
      30.789999999999996,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5002381, size.height * 0.9893167),
      Offset(size.width * 0.5002381, size.height * 0.5132333),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(5.552, 44.55);
    path_2.cubicTo(
      13.892,
      57.559999999999995,
      29.562,
      61.349999999999994,
      43.532,
      58.43,
    );
    path_2.cubicTo(
      46.872,
      57.73,
      49.611999999999995,
      57.26,
      51.961999999999996,
      56.87,
    );
    path_2.lineTo(51.961999999999996, 56.86);
    path_2.cubicTo(
      51.961999999999996,
      56.86,
      40.041999999999994,
      57.12,
      26.661999999999995,
      54.15,
    );
    path_2.cubicTo(
      13.271999999999995,
      51.17,
      5.551999999999996,
      44.55,
      5.551999999999996,
      44.55,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3423095, size.height * 0.9893000),
      Offset(size.width * 0.3423095, size.height * 0.7425000),
      [
        GameColors.islandPainterColor34.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor77.withValues(alpha: 1),
      ],
      [0, 0.124, 0.428, 0.686, 0.885, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(56.892, 48.34);
    path_3.cubicTo(
      58.422000000000004,
      47.010000000000005,
      56.402,
      36.84,
      45.182,
      37.95,
    );
    path_3.cubicTo(33.962, 39.06, 33.942, 47, 34.572, 48.330000000000005);
    path_3.cubicTo(
      35.212,
      49.650000000000006,
      48.332,
      55.800000000000004,
      56.892,
      48.34,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5458571, size.height * 0.8660667),
      Offset(size.width * 0.5458571, size.height * 0.6310667),
      [
        GameColors.islandPainterColor70.withValues(alpha: 1),
        GameColors.islandPainterColor60.withValues(alpha: 1),
        GameColors.islandPainterColor55.withValues(alpha: 1),
      ],
      [0, 0.41, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(57.181, 45.41);
    path_4.cubicTo(
      57.201,
      47.81999999999999,
      55.561,
      48.529999999999994,
      54.781,
      48.879999999999995,
    );
    path_4.cubicTo(
      54.010999999999996,
      49.23,
      57.010999999999996,
      40.47,
      45.851,
      40.709999999999994,
    );
    path_4.cubicTo(
      34.681,
      40.959999999999994,
      34.361,
      46.97999999999999,
      34.361,
      46.97999999999999,
    );
    path_4.cubicTo(
      34.361,
      46.97999999999999,
      34.010999999999996,
      37.94999999999999,
      45.771,
      37.93999999999999,
    );
    path_4.cubicTo(
      57.531,
      37.92999999999999,
      57.181,
      45.40999999999999,
      57.181,
      45.40999999999999,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5448929, size.height * 0.8149000),
      Offset(size.width * 0.5448929, size.height * 0.6324167),
      [
        GameColors.islandPainterColor77.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor34.withValues(alpha: 1),
      ],
      [0, 0.115, 0.314, 0.572, 0.876, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(55.882, 49.14);
    path_5.cubicTo(55.882, 49.14, 52.221999999999994, 51.27, 45.772, 51.27);
    path_5.cubicTo(39.321999999999996, 51.27, 36.372, 49.89, 36.372, 49.89);
    path_5.cubicTo(36.372, 49.89, 47.342, 55.49, 55.882000000000005, 49.14);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(23.412, 44.23);
    path_6.cubicTo(
      29.592,
      41.62,
      31.991999999999997,
      37.949999999999996,
      30.541999999999998,
      34.739999999999995,
    );
    path_6.cubicTo(
      29.092,
      31.539999999999996,
      17.592,
      34.839999999999996,
      16.482,
      40.24999999999999,
    );
    path_6.cubicTo(
      15.372,
      45.66,
      21.352,
      45.10999999999999,
      23.412,
      44.22999999999999,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2815714, size.height * 0.7465500),
      Offset(size.width * 0.2815714, size.height * 0.5581500),
      [
        GameColors.islandPainterColor70.withValues(alpha: 1),
        GameColors.islandPainterColor60.withValues(alpha: 1),
        GameColors.islandPainterColor55.withValues(alpha: 1),
      ],
      [0, 0.41, 1],
    );
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(30.892, 37.33);
    path_7.cubicTo(30.541999999999998, 34.75, 21.002, 36.28, 18.262, 39.14);
    path_7.cubicTo(
      15.522,
      42.01,
      16.932000000000002,
      43.47,
      16.932000000000002,
      43.47,
    );
    path_7.cubicTo(
      16.932000000000002,
      43.47,
      14.062000000000001,
      40.04,
      19.832,
      36.01,
    );
    path_7.cubicTo(
      25.602,
      31.979999999999997,
      31.962000000000003,
      32.69,
      30.892000000000003,
      37.33,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2811786, size.height * 0.7244833),
      Offset(size.width * 0.2811786, size.height * 0.5562333),
      [
        GameColors.islandPainterColor77.withValues(alpha: 1),
        GameColors.islandPainterColor58.withValues(alpha: 1),
        GameColors.islandPainterColor52.withValues(alpha: 1),
        GameColors.islandPainterColor42.withValues(alpha: 1),
        GameColors.islandPainterColor36.withValues(alpha: 1),
        GameColors.islandPainterColor34.withValues(alpha: 1),
      ],
      [0, 0.115, 0.314, 0.572, 0.876, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(29.642, 39.96);
    path_8.cubicTo(29.642, 39.96, 24.412, 44.03, 20.921999999999997, 44.43);
    path_8.cubicTo(
      17.431999999999995,
      44.83,
      16.551999999999996,
      42.82,
      16.551999999999996,
      42.82,
    );
    path_8.cubicTo(
      16.551999999999996,
      42.82,
      17.031999999999996,
      45.3,
      21.151999999999994,
      45,
    );
    path_8.cubicTo(
      25.291999999999994,
      44.7,
      28.901999999999994,
      41.09,
      29.641999999999996,
      39.96,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(68.292, 9.94);
    path_9.cubicTo(77.582, 21.4, 48.972, 34.67, 33.702, 32.21);
    path_9.cubicTo(
      18.432,
      29.75,
      14.521999999999998,
      34.27,
      7.941999999999997,
      34.7,
    );
    path_9.cubicTo(
      1.3619999999999965,
      35.13,
      -3.278000000000004,
      13.820000000000004,
      22.291999999999994,
      6.140000000000004,
    );
    path_9.cubicTo(
      47.87199999999999,
      -1.5399999999999956,
      65.822,
      6.900000000000004,
      68.292,
      9.940000000000005,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(69.162, 45.08);
    path_10.cubicTo(
      77.36200000000001,
      44.53,
      84.06200000000001,
      32.62,
      79.92200000000001,
      25.639999999999997,
    );
    path_10.cubicTo(
      75.78200000000001,
      18.65,
      54.122000000000014,
      31.559999999999995,
      52.46200000000001,
      34.269999999999996,
    );
    path_10.cubicTo(
      50.81200000000001,
      36.97,
      61.85200000000001,
      45.56999999999999,
      69.162,
      45.08,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = GameColors.islandPainterColor74.withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(36.371, 54.12);
    path_11.cubicTo(
      37.881,
      54.089999999999996,
      35.771,
      49.12,
      25.281000000000002,
      48.199999999999996,
    );
    path_11.cubicTo(
      14.791000000000002,
      47.279999999999994,
      19.751,
      54.42999999999999,
      36.371,
      54.12,
    );
    path_11.close();
    path_11.moveTo(55.882, 4.65);
    path_11.cubicTo(
      66.932,
      6.76,
      39.952,
      30.660000000000004,
      13.921999999999997,
      28.53,
    );
    path_11.cubicTo(
      -12.118000000000002,
      26.400000000000002,
      9.981999999999998,
      -4.109999999999999,
      55.882,
      4.650000000000002,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = GameColors.islandPainterColor75.withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(71.652, 42.93);
    path_12.cubicTo(71.542, 39.56, 67.302, 37.55, 62.272, 38.75);
    path_12.cubicTo(57.232, 39.95, 60.202, 47.81, 63.032, 48.12);
    path_12.cubicTo(
      65.85199999999999,
      48.419999999999995,
      71.782,
      47.05,
      71.652,
      42.93,
    );
    path_12.close();
    path_12.moveTo(29.642000000000003, 44.55);
    path_12.cubicTo(
      33.432,
      48.339999999999996,
      26.572000000000003,
      50.699999999999996,
      23.652,
      48.16,
    );
    path_12.cubicTo(
      20.732,
      45.62,
      26.342000000000002,
      41.25,
      29.642000000000003,
      44.55,
    );
    path_12.close();
    path_12.moveTo(22.202, 50.5);
    path_12.cubicTo(23.532000000000004, 48.86, 21.282, 46.57, 19.402, 47.87);
    path_12.cubicTo(
      17.522000000000002,
      49.169999999999995,
      21.362000000000002,
      51.54,
      22.202,
      50.5,
    );
    path_12.close();
    path_12.moveTo(73.162, 25.71);
    path_12.cubicTo(
      76.322,
      31.87,
      59.592000000000006,
      33.96,
      58.422000000000004,
      28,
    );
    path_12.cubicTo(57.252, 22.05, 69.482, 18.53, 73.162, 25.71);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(73.162, 25.71);
    path_13.cubicTo(73.852, 29.76, 67.322, 31.130000000000003, 62.212, 30.25);
    path_13.cubicTo(57.102000000000004, 29.37, 58.642, 25.71, 58.642, 25.71);
    path_13.cubicTo(58.642, 25.71, 57.292, 27.96, 58.762, 30.02);
    path_13.cubicTo(60.232, 32.08, 65.252, 33.21, 70.102, 31.54);
    path_13.cubicTo(74.962, 29.869999999999997, 73.162, 25.71, 73.162, 25.71);
    path_13.close();
    path_13.moveTo(71.652, 42.7);
    path_13.cubicTo(
      71.652,
      42.7,
      71.972,
      45.370000000000005,
      67.142,
      46.480000000000004,
    );
    path_13.cubicTo(62.312, 47.59, 60.672, 46.46, 59.581999999999994, 43.09);
    path_13.cubicTo(
      59.581999999999994,
      43.09,
      59.422,
      47.59,
      61.94199999999999,
      48.89,
    );
    path_13.cubicTo(
      64.46199999999999,
      50.2,
      71.88199999999999,
      48.31,
      71.65199999999999,
      42.7,
    );
    path_13.close();
    path_13.moveTo(30.592, 45.89);
    path_13.cubicTo(30.592, 45.89, 30.842, 48.17, 27.631999999999998, 48.71);
    path_13.cubicTo(
      24.421999999999997,
      49.25,
      23.101999999999997,
      47.32,
      22.842,
      46.04,
    );
    path_13.cubicTo(
      22.842,
      46.04,
      21.802,
      49.339999999999996,
      26.532,
      50.019999999999996,
    );
    path_13.cubicTo(31.252, 50.72, 31.332, 47.01, 30.592, 45.88999999999999);
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(77.012, 33.58);
    path_14.cubicTo(80.802, 37.37, 73.94200000000001, 39.73, 71.022, 37.19);
    path_14.cubicTo(68.102, 34.65, 73.712, 30.279999999999998, 77.012, 33.58);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(77.951, 34.92);
    path_15.cubicTo(77.951, 34.92, 78.201, 37.2, 74.991, 37.74);
    path_15.cubicTo(71.781, 38.28, 70.461, 36.35, 70.201, 35.07);
    path_15.cubicTo(
      70.201,
      35.07,
      69.16099999999999,
      38.37,
      73.89099999999999,
      39.05,
    );
    path_15.cubicTo(
      78.621,
      39.739999999999995,
      78.701,
      36.04,
      77.951,
      34.919999999999995,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(81.492, 29.34);
    path_16.cubicTo(
      83.64200000000001,
      31.49,
      79.75200000000001,
      32.82,
      78.102,
      31.38,
    );
    path_16.cubicTo(
      76.44200000000001,
      29.939999999999998,
      79.622,
      27.47,
      81.492,
      29.34,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(82.022, 30.09);
    path_17.cubicTo(82.022, 30.09, 82.00200000000001, 30.98, 80.182, 31.29);
    path_17.cubicTo(
      78.36200000000001,
      31.599999999999998,
      77.782,
      30.91,
      77.632,
      30.18,
    );
    path_17.cubicTo(77.632, 30.18, 77.042, 32.05, 79.72200000000001, 32.44);
    path_17.cubicTo(
      82.40200000000002,
      32.83,
      82.45200000000001,
      30.729999999999997,
      82.022,
      30.089999999999996,
    );
    path_17.close();
    path_17.moveTo(22.512000000000008, 48.870000000000005);
    path_17.cubicTo(
      22.512000000000008,
      48.870000000000005,
      23.032000000000007,
      50.00000000000001,
      21.642000000000007,
      50.28,
    );
    path_17.cubicTo(
      20.252000000000006,
      50.56,
      19.052000000000007,
      49.42,
      19.102000000000007,
      48.14,
    );
    path_17.cubicTo(
      19.102000000000007,
      48.14,
      18.732000000000006,
      48.32,
      18.70200000000001,
      49.230000000000004,
    );
    path_17.cubicTo(
      18.672000000000008,
      50.14,
      20.16200000000001,
      50.980000000000004,
      21.64200000000001,
      51.120000000000005,
    );
    path_17.cubicTo(
      23.13200000000001,
      51.25000000000001,
      22.75200000000001,
      49.580000000000005,
      22.51200000000001,
      48.870000000000005,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(10.342, 39.06);
    path_18.cubicTo(11.672, 37.42, 9.422, 35.13, 7.542000000000001, 36.43);
    path_18.cubicTo(5.652000000000001, 37.73, 9.492, 40.1, 10.342, 39.06);
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = GameColors.islandPainterColor51.withValues(alpha: 1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(10.642, 37.43);
    path_19.cubicTo(
      10.642,
      37.43,
      11.161999999999999,
      38.56,
      9.772,
      38.839999999999996,
    );
    path_19.cubicTo(8.382, 39.12, 7.182, 37.98, 7.232, 36.699999999999996);
    path_19.cubicTo(
      7.232,
      36.699999999999996,
      6.862,
      36.879999999999995,
      6.832,
      37.79,
    );
    path_19.cubicTo(6.802, 38.699999999999996, 8.292, 39.54, 9.772, 39.68);
    path_19.cubicTo(11.272, 39.81, 10.882, 38.14, 10.642, 37.43);
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = GameColors.islandPainterColor38.withValues(alpha: 1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(65.031, 5.08);
    path_20.cubicTo(
      72.361,
      15.67,
      61.56100000000001,
      25.85,
      44.42100000000001,
      28.049999999999997,
    );
    path_20.cubicTo(
      27.281000000000006,
      30.249999999999996,
      31.381000000000007,
      17.749999999999996,
      32.291000000000004,
      16.569999999999997,
    );
    path_20.cubicTo(
      33.201,
      15.389999999999997,
      26.661000000000005,
      17.339999999999996,
      25.181000000000004,
      19.859999999999996,
    );
    path_20.cubicTo(
      24.131000000000004,
      21.639999999999997,
      30.541000000000004,
      19.189999999999994,
      29.971000000000004,
      23.829999999999995,
    );
    path_20.cubicTo(
      29.401000000000003,
      28.469999999999995,
      9.001000000000005,
      33.879999999999995,
      2.821000000000005,
      27.589999999999996,
    );
    path_20.cubicTo(-3.358, 21.3, 7.172, 9.31, 30.762, 3);
    path_20.cubicTo(49.912, -2.12, 63.552, 2.94, 65.03200000000001, 5.08);
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4074405, size.height * 0.5073167),
      Offset(size.width * 0.4074405, size.height * 1.300000),
      [
        GameColors.islandPainterColor8.withValues(alpha: 1),
        GameColors.islandPainterColor12.withValues(alpha: 1),
        GameColors.islandPainterColor17.withValues(alpha: 1),
        GameColors.islandPainterColor21.withValues(alpha: 1),
      ],
      [0, 0.417, 0.769, 1],
    );
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(66.742, 7.91);
    path_21.cubicTo(66.742, 7.91, 68.272, 17.68, 56.342000000000006, 22.86);
    path_21.cubicTo(
      44.422000000000004,
      28.05,
      36.852000000000004,
      28.15,
      33.432,
      24.099999999999998,
    );
    path_21.cubicTo(
      30.012,
      20.049999999999997,
      33.362,
      16.29,
      32.952000000000005,
      15.269999999999998,
    );
    path_21.cubicTo(
      32.54200000000001,
      14.239999999999998,
      22.552000000000007,
      18.83,
      21.602000000000004,
      20.06,
    );
    path_21.cubicTo(
      20.642000000000003,
      21.29,
      26.802000000000003,
      19.52,
      28.752000000000002,
      21.7,
    );
    path_21.cubicTo(30.702, 23.89, 18.542, 29.52, 10.742, 29.03);
    path_21.cubicTo(
      2.9320000000000013,
      28.540000000000003,
      1.2220000000000013,
      24.720000000000002,
      1.2220000000000013,
      24.720000000000002,
    );
    path_21.cubicTo(
      1.2220000000000013,
      24.720000000000002,
      -0.07799999999999874,
      31.080000000000002,
      13.062000000000001,
      31.290000000000003,
    );
    path_21.cubicTo(
      26.192,
      31.490000000000002,
      29.472,
      24.810000000000002,
      30.632,
      24.430000000000003,
    );
    path_21.cubicTo(
      31.782,
      24.050000000000004,
      33.122,
      30.820000000000004,
      43.062,
      29.03,
    );
    path_21.cubicTo(
      52.992,
      27.240000000000002,
      71.672,
      22.630000000000003,
      66.74199999999999,
      7.91,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4091667, size.height * 0.5216000),
      Offset(size.width * 0.4091667, size.height * 0.1317833),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(55.882, 21.7);
    path_22.cubicTo(
      69.52199999999999,
      11.92,
      56.751999999999995,
      6.049999999999999,
      40.702,
      12.1,
    );
    path_22.cubicTo(24.651999999999997, 18.16, 33.872, 33.67, 55.882, 21.7);
    path_22.close();
    path_22.moveTo(27.461, 21.029999999999998);
    path_22.cubicTo(
      30.401,
      23.159999999999997,
      18.801,
      29.639999999999997,
      9.401,
      28.659999999999997,
    );
    path_22.cubicTo(
      0.0009999999999994458,
      27.679999999999996,
      0.24099999999999966,
      20.269999999999996,
      7.010999999999999,
      15.869999999999997,
    );
    path_22.cubicTo(
      13.780999999999999,
      11.459999999999997,
      18.790999999999997,
      19.4,
      20.430999999999997,
      20.4,
    );
    path_22.cubicTo(
      22.070999999999998,
      21.4,
      25.980999999999998,
      19.959999999999997,
      27.461,
      21.029999999999998,
    );
    path_22.close();
    path_22.moveTo(56.191, 2.4399999999999977);
    path_22.cubicTo(
      59.411,
      2.9899999999999975,
      43.761,
      11.559999999999997,
      32.601,
      13.469999999999997,
    );
    path_22.cubicTo(
      21.441,
      15.379999999999997,
      14.061,
      11.369999999999997,
      14.061,
      11.369999999999997,
    );
    path_22.cubicTo(
      14.061,
      11.369999999999997,
      27.741,
      -2.400000000000002,
      56.191,
      2.4399999999999977,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = GameColors.islandPainterColor18.withValues(alpha: 1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(53.862, 18.32);
    path_23.cubicTo(54.772, 14.22, 39.222, 12.4, 35.742000000000004, 20.65);
    path_23.cubicTo(
      32.272000000000006,
      28.89,
      52.092000000000006,
      26.31,
      53.86200000000001,
      18.32,
    );
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6416429, size.height * 0.3380333),
      Offset(size.width * 0.4206905, size.height * 0.3380333),
      [
        GameColors.islandPainterColor15.withValues(alpha: 1),
        GameColors.islandPainterColor16.withValues(alpha: 1),
        GameColors.islandPainterColor23.withValues(alpha: 1),
        GameColors.islandPainterColor32.withValues(alpha: 1),
        GameColors.islandPainterColor35.withValues(alpha: 1),
      ],
      [0, 0.09, 0.499, 0.816, 1],
    );
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(53.681, 18.95);
    path_24.cubicTo(
      54.491,
      15.26,
      39.830999999999996,
      15.76,
      36.92099999999999,
      20.759999999999998,
    );
    path_24.cubicTo(
      34.020999999999994,
      25.75,
      40.57099999999999,
      26.13,
      45.71099999999999,
      24.979999999999997,
    );
    path_24.cubicTo(
      50.85099999999999,
      23.819999999999997,
      53.46099999999999,
      19.949999999999996,
      53.68099999999999,
      18.949999999999996,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = GameColors.islandPainterColor69.withValues(alpha: 1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(57.122, 9.44);
    path_25.cubicTo(60.642, 9.68, 67.882, 13.08, 58.582, 13.629999999999999);
    path_25.cubicTo(
      51.692,
      14.03,
      48.902,
      12.329999999999998,
      48.102000000000004,
      11.1,
    );
    path_25.cubicTo(
      47.19200000000001,
      9.719999999999999,
      52.662000000000006,
      9.14,
      57.122,
      9.44,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(55.462, 13.05);
    path_26.cubicTo(
      59.522000000000006,
      13.370000000000001,
      62.702000000000005,
      7.340000000000001,
      60.502,
      4.58,
    );
    path_26.cubicTo(
      57.962,
      1.3900000000000001,
      47.722,
      2.3000000000000003,
      46.382000000000005,
      4.96,
    );
    path_26.cubicTo(
      45.30200000000001,
      7.09,
      48.182,
      12.18,
      50.97200000000001,
      12.79,
    );
    path_26.cubicTo(
      53.85200000000001,
      13.399999999999999,
      55.46200000000001,
      13.049999999999999,
      55.46200000000001,
      13.049999999999999,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5937738, size.height * 0.2097667),
      Offset(size.width * 0.6818690, size.height * -2.073333),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(60.932, 7.26);
    path_27.cubicTo(
      60.922000000000004,
      9.86,
      54.222,
      11.69,
      50.612,
      10.309999999999999,
    );
    path_27.cubicTo(
      46.922000000000004,
      8.899999999999999,
      46.632000000000005,
      6.129999999999999,
      47.292,
      4.959999999999999,
    );
    path_27.cubicTo(
      48.022,
      3.639999999999999,
      60.952,
      0.7199999999999989,
      60.932,
      7.259999999999999,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(60.502, 4.58);
    path_28.cubicTo(60.692, 6.04, 54.962, 8.18, 52.002, 8.280000000000001);
    path_28.cubicTo(
      49.292,
      8.38,
      46.152,
      6.150000000000001,
      46.262,
      5.260000000000002,
    );
    path_28.cubicTo(
      46.372,
      4.300000000000002,
      47.652,
      3.1200000000000014,
      52.032,
      2.7000000000000015,
    );
    path_28.cubicTo(
      57.05199999999999,
      2.2200000000000015,
      60.431999999999995,
      4.080000000000002,
      60.501999999999995,
      4.580000000000002,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(57.482, 12.56);
    path_29.cubicTo(56.322, 13.21, 53.802, 13.16, 53.262, 12.9);
    path_29.cubicTo(52.712, 12.63, 52.122, 8.91, 52.482, 8.57);
    path_29.cubicTo(52.862, 8.21, 59.222, 6.2, 60.052, 5.78);
    path_29.cubicTo(60.922, 5.34, 61.632, 9.66, 57.482, 12.56);
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(52.532, 12.81);
    path_30.cubicTo(
      52.931999999999995,
      12.88,
      52.081999999999994,
      9.440000000000001,
      51.662,
      8.950000000000001,
    );
    path_30.cubicTo(
      51.232,
      8.450000000000001,
      48.482,
      7.920000000000001,
      46.592,
      6.470000000000001,
    );
    path_30.cubicTo(46.592, 6.470000000000001, 47.022, 9.84, 48.902, 11.41);
    path_30.cubicTo(
      50.612,
      12.85,
      52.532000000000004,
      12.81,
      52.532000000000004,
      12.81,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(53.902, 8.03);
    path_31.cubicTo(
      54.062,
      8.01,
      52.352000000000004,
      9.85,
      52.192,
      9.799999999999999,
    );
    path_31.cubicTo(
      52.032000000000004,
      9.739999999999998,
      49.742,
      7.959999999999999,
      49.742,
      7.959999999999999,
    );
    path_31.cubicTo(
      49.742,
      7.959999999999999,
      52.321999999999996,
      8.18,
      53.902,
      8.03,
    );
    path_31.close();
    path_31.moveTo(59.812, 5.629999999999999);
    path_31.cubicTo(
      59.812,
      5.629999999999999,
      58.702,
      6.699999999999999,
      56.812,
      7.359999999999999,
    );
    path_31.cubicTo(
      55.092,
      7.959999999999999,
      53.961999999999996,
      8.059999999999999,
      53.961999999999996,
      8.059999999999999,
    );
    path_31.cubicTo(
      53.961999999999996,
      8.059999999999999,
      56.562,
      7.049999999999999,
      59.812,
      5.629999999999999,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(49.342, 11.14);
    path_32.cubicTo(51.172, 11.71, 50.192, 15.46, 43.961999999999996, 15.15);
    path_32.cubicTo(
      38.181999999999995,
      14.860000000000001,
      41.312,
      8.620000000000001,
      49.342,
      11.14,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(48.552, 11.73);
    path_33.cubicTo(49.062, 10.68, 46.032, 7.180000000000001, 42.972, 8.01);
    path_33.cubicTo(39.912, 8.84, 38.912, 11.21, 40.512, 13.2);
    path_33.cubicTo(
      42.122,
      15.19,
      46.892,
      15.129999999999999,
      48.552,
      11.729999999999999,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5202500, size.height * 0.2448167),
      Offset(size.width * 0.5347381, size.height * 0.1021667),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(47.742, 10.61);
    path_34.cubicTo(48.022, 11.45, 44.192, 13.809999999999999, 41.232, 12.33);
    path_34.cubicTo(38.272, 10.86, 42.432, 8.280000000000001, 43.952, 8.23);
    path_34.cubicTo(45.472, 8.190000000000001, 47.402, 9.56, 47.742, 10.61);
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(47.632, 9.6);
    path_35.cubicTo(
      48.001999999999995,
      10.309999999999999,
      45.952,
      11.73,
      43.422,
      11.899999999999999,
    );
    path_35.cubicTo(
      40.891999999999996,
      12.069999999999999,
      40.102,
      10.829999999999998,
      40.052,
      10.459999999999999,
    );
    path_35.cubicTo(
      40.002,
      10.09,
      40.762,
      7.9399999999999995,
      43.872,
      7.949999999999999,
    );
    path_35.cubicTo(45.392, 7.949999999999999, 47.152, 8.68, 47.632, 9.6);
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(45.032, 14.3);
    path_36.cubicTo(
      45.282,
      14.430000000000001,
      47.331999999999994,
      13.190000000000001,
      47.971999999999994,
      12.370000000000001,
    );
    path_36.cubicTo(
      48.611999999999995,
      11.540000000000001,
      48.13199999999999,
      10.39,
      47.901999999999994,
      10.41,
    );
    path_36.cubicTo(
      47.672,
      10.43,
      45.73199999999999,
      11.72,
      44.19199999999999,
      12.07,
    );
    path_36.cubicTo(
      44.181999999999995,
      12.06,
      43.721999999999994,
      13.63,
      45.032,
      14.3,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(44.182, 14.39);
    path_37.cubicTo(
      44.472,
      14.350000000000001,
      43.802,
      12.39,
      43.562000000000005,
      12.25,
    );
    path_37.cubicTo(43.322, 12.11, 40.882000000000005, 12.04, 39.892, 10.77);
    path_37.cubicTo(39.902, 10.77, 39.222, 14.08, 44.182, 14.39);
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(44.652, 11.78);
    path_38.cubicTo(
      44.652,
      11.78,
      44.282000000000004,
      12.479999999999999,
      44.022,
      12.57,
    );
    path_38.cubicTo(43.762, 12.66, 42.442, 11.98, 42.442, 11.98);
    path_38.cubicTo(
      42.442,
      11.98,
      43.372,
      12.040000000000001,
      44.652,
      11.780000000000001,
    );
    path_38.close();
    path_38.moveTo(42.092, 11.92);
    path_38.cubicTo(42.092, 11.92, 41.132, 11.51, 40.751999999999995, 11.27);
    path_38.cubicTo(
      40.37199999999999,
      11.03,
      40.151999999999994,
      10.799999999999999,
      40.151999999999994,
      10.799999999999999,
    );
    path_38.cubicTo(
      40.151999999999994,
      10.799999999999999,
      40.501999999999995,
      11.899999999999999,
      42.09199999999999,
      11.919999999999998,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(19.502, 20.41);
    path_39.cubicTo(20.482, 21.16, 18.302, 23.83, 14.282, 22.53);
    path_39.cubicTo(10.552, 21.32, 15.192, 17.11, 19.502, 20.41);
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(18.732, 20.72);
    path_40.cubicTo(
      19.502,
      20.009999999999998,
      18.922,
      16.83,
      16.541999999999998,
      16.939999999999998,
    );
    path_40.cubicTo(
      14.161999999999999,
      17.049999999999997,
      12.531999999999998,
      18.669999999999998,
      12.781999999999998,
      20.459999999999997,
    );
    path_40.cubicTo(
      13.031999999999998,
      22.24,
      16.241999999999997,
      23.019999999999996,
      18.732,
      20.72,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1701667, size.height * 0.3689167),
      Offset(size.width * 0.2076071, size.height * 0.2551000),
      [
        GameColors.islandPainterColor67.withValues(alpha: 1),
        GameColors.islandPainterColor66.withValues(alpha: 1),
        GameColors.islandPainterColor65.withValues(alpha: 1),
        GameColors.islandPainterColor64.withValues(alpha: 1),
        GameColors.islandPainterColor63.withValues(alpha: 1),
        GameColors.islandPainterColor62.withValues(alpha: 1),
      ],
      [0, 0.017, 0.359, 0.648, 0.871, 1],
    );
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(18.652, 19.73);
    path_41.cubicTo(
      18.492,
      20.42,
      14.982000000000001,
      21.55,
      13.612000000000002,
      19.92,
    );
    path_41.cubicTo(
      12.252000000000002,
      18.290000000000003,
      16.072000000000003,
      17.05,
      17.102000000000004,
      17.270000000000003,
    );
    path_41.cubicTo(
      18.142000000000003,
      17.500000000000004,
      18.852000000000004,
      18.880000000000003,
      18.652000000000005,
      19.730000000000004,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(18.992, 18.94);
    path_42.cubicTo(
      18.952,
      19.540000000000003,
      17.002000000000002,
      20.270000000000003,
      15.242,
      19.96,
    );
    path_42.cubicTo(13.492, 19.66, 13.472000000000001, 18.57, 13.592, 18.28);
    path_42.cubicTo(
      13.712,
      17.990000000000002,
      15.092,
      16.490000000000002,
      17.162,
      17.03,
    );
    path_42.cubicTo(18.182, 17.3, 19.052, 18.16, 18.991999999999997, 18.94);
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(15.332, 22.07);
    path_43.cubicTo(15.442, 22.21, 17.322, 21.62, 18.082, 21.1);
    path_43.cubicTo(
      18.842000000000002,
      20.580000000000002,
      19.002000000000002,
      19.62,
      18.842000000000002,
      19.6,
    );
    path_43.cubicTo(
      18.682000000000002,
      19.57,
      16.862000000000002,
      20.220000000000002,
      15.692000000000002,
      20.220000000000002,
    );
    path_43.cubicTo(
      15.692000000000002,
      20.220000000000002,
      14.742000000000003,
      21.330000000000002,
      15.332000000000003,
      22.070000000000004,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = GameColors.islandPainterColor68.withValues(alpha: 1.0);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(14.742, 21.99);
    path_44.cubicTo(
      14.952000000000002,
      22.009999999999998,
      15.312000000000001,
      20.4,
      15.212000000000002,
      20.259999999999998,
    );
    path_44.cubicTo(
      15.102000000000002,
      20.11,
      13.512000000000002,
      19.639999999999997,
      13.372000000000002,
      18.509999999999998,
    );
    path_44.cubicTo(
      13.372000000000002,
      18.499999999999996,
      11.562000000000001,
      20.9,
      14.742,
      21.99,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = GameColors.islandPainterColor41.withValues(alpha: 1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(16.112, 20.09);
    path_45.cubicTo(16.112, 20.09, 15.572, 20.56, 15.361999999999998, 20.58);
    path_45.cubicTo(
      15.151999999999997,
      20.599999999999998,
      14.551999999999998,
      19.86,
      14.551999999999998,
      19.86,
    );
    path_45.cubicTo(
      14.551999999999998,
      19.86,
      15.161999999999997,
      20.07,
      16.112,
      20.09,
    );
    path_45.close();
    path_45.moveTo(14.361999999999998, 19.75);
    path_45.cubicTo(
      14.361999999999998,
      19.75,
      13.891999999999998,
      19.28,
      13.731999999999998,
      19.03,
    );
    path_45.cubicTo(
      13.571999999999997,
      18.78,
      13.531999999999998,
      18.57,
      13.531999999999998,
      18.57,
    );
    path_45.cubicTo(
      13.531999999999998,
      18.57,
      13.301999999999998,
      19.47,
      14.361999999999998,
      19.75,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = GameColors.yellow.withValues(alpha: 1.0);
    canvas.drawPath(path_45, paint45Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
