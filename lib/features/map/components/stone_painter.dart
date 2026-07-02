import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FirstStonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(50.454, 43.458);
    path_0.cubicTo(60.344, 42.367999999999995, 65.784, 30.758, 63.134, 19.778);
    path_0.lineTo(63.134, 19.767999999999997);
    path_0.cubicTo(
      61.524,
      13.107999999999997,
      56.954,
      6.6679999999999975,
      48.604,
      2.937999999999999,
    );
    path_0.cubicTo(
      30.724,
      -5.022000000000001,
      12.804000000000002,
      4.677999999999999,
      4.494,
      14.377999999999998,
    );
    path_0.cubicTo(
      2.5039999999999996,
      16.688,
      1.0739999999999998,
      19.008,
      0.31400000000000006,
      21.087999999999997,
    );
    path_0.cubicTo(-3.636, 31.867999999999995, 31.714, 45.528, 50.454, 43.458);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4984062, size.height * 0.9924318),
      Offset(size.width * 0.4984062, size.height * -0.004545455),
      [
        Color(0xffA93D54).withValues(alpha: 1),
        Color(0xffAC454A).withValues(alpha: 1),
        Color(0xffB3592E).withValues(alpha: 1),
        Color(0xffB8661D).withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(50.454, 43.458);
    path_1.cubicTo(60.344, 42.367999999999995, 65.784, 30.758, 63.134, 19.778);
    path_1.cubicTo(63.114, 20.298, 62.154, 37.888, 38.994, 38.778);
    path_1.cubicTo(
      15.494,
      39.668,
      1.524000000000001,
      20.997999999999998,
      4.484000000000002,
      14.387999999999998,
    );
    path_1.cubicTo(
      2.4940000000000015,
      16.697999999999997,
      1.0640000000000018,
      19.017999999999997,
      0.30400000000000205,
      21.098,
    );
    path_1.cubicTo(
      -3.635999999999998,
      31.868,
      31.714000000000002,
      45.528,
      50.454,
      43.458,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4984062, size.height * 0.9924318),
      Offset(size.width * 0.4984062, size.height * 0.3268864),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(58.304, 29.028);
    path_2.cubicTo(
      60.754000000000005,
      18.878,
      47.714,
      5.827999999999999,
      27.734,
      17.578,
    );
    path_2.cubicTo(
      7.764000000000003,
      29.317999999999998,
      44.874,
      46.458,
      58.304,
      29.028,
    );
    path_2.close();
    path_2.moveTo(31.154000000000003, 2.227999999999998);
    path_2.cubicTo(
      43.81400000000001,
      3.6179999999999977,
      26.724000000000004,
      19.087999999999997,
      12.674000000000003,
      19.637999999999998,
    );
    path_2.cubicTo(
      -1.3759999999999977,
      20.188,
      13.314000000000004,
      0.26799999999999713,
      31.154000000000003,
      2.227999999999998,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(57.114, 32.208);
    path_3.cubicTo(
      56.614,
      31.438,
      49.763999999999996,
      30.947999999999997,
      46.224,
      33.397999999999996,
    );
    path_3.cubicTo(
      42.684,
      35.848,
      42.303999999999995,
      38.888,
      42.303999999999995,
      38.888,
    );
    path_3.cubicTo(
      42.303999999999995,
      38.888,
      46.163999999999994,
      41.558,
      51.39399999999999,
      40.738,
    );
    path_3.cubicTo(
      56.623999999999995,
      39.928,
      57.11399999999999,
      32.208,
      57.11399999999999,
      32.208,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7767969, size.height * 0.9296136),
      Offset(size.width * 0.7767969, size.height * 0.7178864),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(10.794, 28.438);
    path_4.cubicTo(
      11.994,
      28.247999999999998,
      9.394,
      24.387999999999998,
      6.134,
      23.448,
    );
    path_4.cubicTo(
      2.8740000000000006,
      22.508,
      3.2640000000000002,
      29.658,
      10.794,
      28.438000000000002,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1193750, size.height * 0.6495455),
      Offset(size.width * 0.1193750, size.height * 0.5309318),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(9.914, 25.968);
    path_5.cubicTo(
      11.634,
      27.448,
      7.273999999999999,
      28.218,
      5.4239999999999995,
      25.968,
    );
    path_5.cubicTo(
      3.574,
      23.718,
      6.023999999999999,
      23.758,
      6.023999999999999,
      23.758,
    );
    path_5.cubicTo(
      6.023999999999999,
      23.758,
      7.993999999999999,
      24.308,
      9.914,
      25.968,
    );
    path_5.close();
    path_5.moveTo(56.264, 31.837);
    path_5.cubicTo(57.844, 31.977, 54.704, 37.837, 49.714000000000006, 38.877);
    path_5.cubicTo(
      44.73400000000001,
      39.907000000000004,
      43.31400000000001,
      37.107,
      43.31400000000001,
      37.107,
    );
    path_5.cubicTo(
      43.31400000000001,
      37.107,
      44.56400000000001,
      30.777,
      56.26400000000001,
      31.837,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffCC81B3).withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(56.414, 35.618);
    path_6.cubicTo(56.414, 35.618, 52.914, 38.828, 49.994, 39.518);
    path_6.cubicTo(47.084, 40.208, 43.834, 39.708, 43.834, 39.708);
    path_6.cubicTo(
      43.834,
      39.708,
      46.394000000000005,
      41.458,
      51.214000000000006,
      40.897999999999996,
    );
    path_6.cubicTo(
      56.034000000000006,
      40.337999999999994,
      56.41400000000001,
      35.617999999999995,
      56.41400000000001,
      35.617999999999995,
    );
    path_6.close();
    path_6.moveTo(10.634, 28.578000000000003);
    path_6.cubicTo(
      10.634,
      28.578000000000003,
      5.664000000000001,
      28.368000000000002,
      4.214,
      25.268000000000004,
    );
    path_6.cubicTo(
      4.214,
      25.268000000000004,
      4.214,
      27.378000000000004,
      6.314,
      28.228000000000005,
    );
    path_6.cubicTo(
      8.424,
      29.088000000000005,
      10.634,
      28.578000000000007,
      10.634,
      28.578000000000007,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffD46D31).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(51.904, 6.768);
    path_7.cubicTo(57.884, 13.408, 38.994, 8.368, 36.744, 4.518);
    path_7.cubicTo(
      34.494,
      0.6679999999999993,
      44.074,
      -1.9420000000000002,
      51.903999999999996,
      6.768,
    );
    path_7.close();
    path_7.moveTo(56.034000000000006, 14.378);
    path_7.cubicTo(
      59.16400000000001,
      18.838,
      53.20400000000001,
      15.538,
      52.114000000000004,
      14.008000000000001,
    );
    path_7.cubicTo(
      51.034000000000006,
      12.498000000000001,
      54.004000000000005,
      11.488000000000001,
      56.034000000000006,
      14.378,
    );
    path_7.close();
    path_7.moveTo(20.314000000000007, 26.328);
    path_7.cubicTo(
      23.044000000000008,
      31.938,
      12.074000000000007,
      27.178,
      11.094000000000007,
      23.768,
    );
    path_7.cubicTo(
      10.104000000000006,
      20.348,
      17.244000000000007,
      20.018,
      20.314000000000007,
      26.328,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffCC7CD4).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(50.984, 26.028);
    path_8.cubicTo(
      58.464,
      22.907999999999998,
      49.124,
      13.717999999999998,
      36.814,
      18.518,
    );
    path_8.cubicTo(24.514, 23.328, 44.994, 28.528, 50.984, 26.028);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffF3CAB6).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(53.514, 23.767);
    path_9.cubicTo(53.734, 21.457, 49.264, 17.017, 41.134, 18.267);
    path_9.cubicTo(33.004, 19.517, 33.634, 22.837, 33.634, 22.837);
    path_9.cubicTo(33.634, 22.837, 32.294, 22.117, 32.954, 20.537);
    path_9.cubicTo(
      33.614,
      18.957,
      37.854,
      16.296999999999997,
      47.004000000000005,
      17.157,
    );
    path_9.cubicTo(56.164, 18.017, 53.514, 23.767, 53.514, 23.767);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6768437, size.height * 0.5401818),
      Offset(size.width * 0.6768437, size.height * 0.3861136),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(59.144, 29.948);
    path_10.cubicTo(58.504, 30.738, 51.034, 30.088, 46.784, 31.938);
    path_10.cubicTo(42.544, 33.788, 36.123999999999995, 36.288, 31.894, 36.958);
    path_10.cubicTo(27.663999999999998, 37.638, 20.304, 35.068, 20.304, 35.068);
    path_10.cubicTo(
      20.304,
      35.068,
      25.894,
      39.837999999999994,
      42.304,
      38.897999999999996,
    );
    path_10.cubicTo(
      42.304,
      38.897999999999996,
      43.774,
      33.967999999999996,
      48.484,
      32.297999999999995,
    );
    path_10.cubicTo(
      53.194,
      30.627999999999993,
      57.104,
      32.20799999999999,
      57.104,
      32.20799999999999,
    );
    path_10.lineTo(59.144, 29.947999999999993);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffC55A40).withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(27.254, 37.908);
    path_11.cubicTo(27.254, 37.908, 15.474000000000002, 35.138, 10.634, 28.588);
    path_11.cubicTo(10.634, 28.578, 24.424, 35.608000000000004, 27.254, 37.908);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xffD96E40).withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(49.994, 43.498);
    path_12.cubicTo(
      49.994,
      43.498,
      45.544,
      40.848,
      39.724000000000004,
      39.617999999999995,
    );
    path_12.cubicTo(
      33.914,
      38.388,
      23.344000000000005,
      38.52799999999999,
      16.334000000000003,
      36.458,
    );
    path_12.cubicTo(
      16.334000000000003,
      36.467999999999996,
      29.884000000000004,
      44.048,
      49.994,
      43.498,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xffCC81B3).withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(58.984, 27.658);
    path_13.cubicTo(
      59.864000000000004,
      25.868000000000002,
      55.984,
      25.758000000000003,
      55.224000000000004,
      27.258000000000003,
    );
    path_13.cubicTo(
      54.474000000000004,
      28.748,
      58.284000000000006,
      29.058000000000003,
      58.984,
      27.658,
    );
    path_13.close();
    path_13.moveTo(40.284000000000006, 34.138000000000005);
    path_13.cubicTo(
      44.224000000000004,
      34.778000000000006,
      41.13400000000001,
      38.218,
      36.45400000000001,
      37.26800000000001,
    );
    path_13.cubicTo(
      31.774000000000008,
      36.318000000000005,
      37.58400000000001,
      33.708000000000006,
      40.284000000000006,
      34.138000000000005,
    );
    path_13.close();
    path_13.moveTo(33.16400000000001, 29.707000000000004);
    path_13.cubicTo(
      33.48400000000001,
      30.147000000000006,
      32.20400000000001,
      30.357000000000003,
      31.76400000000001,
      29.947000000000003,
    );
    path_13.cubicTo(
      31.33400000000001,
      29.537000000000003,
      32.60400000000001,
      28.947000000000003,
      33.16400000000001,
      29.707000000000004,
    );
    path_13.close();
    path_13.moveTo(41.76400000000001, 31.538000000000004);
    path_13.cubicTo(
      42.08400000000001,
      31.978000000000005,
      40.80400000000001,
      32.188,
      40.36400000000001,
      31.778000000000002,
    );
    path_13.cubicTo(
      39.93400000000001,
      31.378000000000004,
      41.204000000000015,
      30.778000000000002,
      41.76400000000001,
      31.538000000000004,
    );
    path_13.close();
    path_13.moveTo(26.08400000000001, 33.478);
    path_13.cubicTo(
      28.98400000000001,
      36.628,
      23.15400000000001,
      35.678000000000004,
      21.28400000000001,
      33.478,
    );
    path_13.cubicTo(
      19.41400000000001,
      31.278000000000002,
      24.63400000000001,
      31.898000000000003,
      26.08400000000001,
      33.478,
    );
    path_13.close();
    path_13.moveTo(5.69400000000001, 18.868000000000002);
    path_13.cubicTo(
      8.224000000000009,
      21.878,
      6.43400000000001,
      22.358000000000004,
      5.00400000000001,
      20.378000000000004,
    );
    path_13.cubicTo(
      3.5640000000000103,
      18.398000000000003,
      5.09400000000001,
      18.158000000000005,
      5.69400000000001,
      18.868000000000002,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xffD96E40).withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class SecondStonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(6.473, 45.93);
    path_0.cubicTo(17.613, 53.54, 51.882999999999996, 50.06, 61.973, 38.7);
    path_0.cubicTo(
      67.293,
      32.71,
      70.243,
      21.460000000000004,
      65.473,
      12.630000000000003,
    );
    path_0.lineTo(65.463, 12.620000000000003);
    path_0.cubicTo(61.493, 5.24, 52.133, -0.46, 34.273, 0.03);
    path_0.cubicTo(11.223, 0.64, 1.813, 13.77, 0.242, 26.02);
    path_0.lineTo(0.242, 26.04);
    path_0.cubicTo(
      -0.8580000000000001,
      34.629999999999995,
      1.882,
      42.8,
      6.472,
      45.93,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4990882, size.height * 0.9997800),
      Offset(size.width * 0.4990882, size.height * 0.01400000),
      [
        Color(0xffC35934).withValues(alpha: 1),
        Color(0xffC5632E).withValues(alpha: 1),
        Color(0xffC97F1F).withValues(alpha: 1),
        Color(0xffCA821D).withValues(alpha: 1),
      ],
      [0, 0.347, 0.945, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(6.473, 45.93);
    path_1.cubicTo(17.613, 53.54, 51.882999999999996, 50.06, 61.973, 38.7);
    path_1.cubicTo(
      67.293,
      32.71,
      70.243,
      21.460000000000004,
      65.473,
      12.630000000000003,
    );
    path_1.lineTo(65.463, 12.620000000000003);
    path_1.cubicTo(
      67.273,
      27.89,
      62.702999999999996,
      34.660000000000004,
      52.12299999999999,
      40.35,
    );
    path_1.cubicTo(
      41.54299999999999,
      46.04,
      17.782999999999987,
      46.42,
      8.652999999999992,
      41.42,
    );
    path_1.cubicTo(
      2.6929999999999916,
      38.160000000000004,
      0.8229999999999915,
      30.78,
      0.24299999999999145,
      26.03,
    );
    path_1.cubicTo(
      -0.8570000000000086,
      34.63,
      1.8829999999999913,
      42.8,
      6.472999999999992,
      45.93,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4990882, size.height * 0.9997600),
      Offset(size.width * 0.4990882, size.height * 0.2525400),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(53.502, 38.35);
    path_2.cubicTo(
      63.562000000000005,
      29.87,
      35.562,
      10.870000000000001,
      14.602000000000004,
      18.200000000000003,
    );
    path_2.cubicTo(
      -6.357999999999997,
      25.520000000000003,
      2.8220000000000045,
      58.64,
      53.502,
      38.35,
    );
    path_2.close();
    path_2.moveTo(62.692, 10.150000000000002);
    path_2.cubicTo(
      65.762,
      21.090000000000003,
      28.522,
      8.630000000000003,
      25.372,
      6.740000000000002,
    );
    path_2.cubicTo(
      22.212,
      4.850000000000002,
      47.912,
      -6.359999999999998,
      62.692,
      10.150000000000002,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(30.543, 43.149);
    path_3.cubicTo(
      37.003,
      42.089,
      24.262999999999998,
      28.349,
      12.742999999999999,
      29.619,
    );
    path_3.cubicTo(
      1.222999999999999,
      30.889,
      3.552999999999999,
      47.579,
      30.543,
      43.149,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(19.232, 6.05);
    path_4.cubicTo(
      23.612,
      5.4399999999999995,
      19.962,
      9.379999999999999,
      14.392,
      10.16,
    );
    path_4.cubicTo(8.812, 10.93, 15.771999999999998, 6.52, 19.232, 6.05);
    path_4.close();
    path_4.moveTo(27.762, 11.21);
    path_4.cubicTo(33.672, 12.280000000000001, 25.082, 16.14, 15.132, 16.55);
    path_4.cubicTo(5.182, 16.96, 14.552, 8.82, 27.762, 11.21);
    path_4.close();
    path_4.moveTo(60.492, 27.319000000000003);
    path_4.cubicTo(
      62.372,
      24.519000000000002,
      58.482,
      19.449,
      49.681999999999995,
      19.199000000000005,
    );
    path_4.cubicTo(
      40.88199999999999,
      18.949000000000005,
      59.44199999999999,
      28.889000000000003,
      60.492,
      27.319000000000003,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffCC7CD4).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(58.962, 35.74);
    path_5.cubicTo(58.962, 35.74, 38.262, 44.33, 36.08200000000001, 44.52);
    path_5.cubicTo(
      33.912000000000006,
      44.71,
      53.89200000000001,
      47.06,
      58.962,
      35.74,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6977206, size.height * 0.8969000),
      Offset(size.width * 0.6977206, size.height * 0.7147600),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(55.842, 37.02);
    path_6.cubicTo(55.842, 37.02, 53.132, 42.09, 47.662, 43.410000000000004);
    path_6.cubicTo(
      42.192,
      44.730000000000004,
      38.861999999999995,
      43.89,
      38.861999999999995,
      43.89,
    );
    path_6.lineTo(55.842, 37.02);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffDB90D4).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(46.992, 40.59);
    path_7.cubicTo(
      46.992,
      40.59,
      31.351999999999997,
      43.56,
      24.651999999999997,
      44.160000000000004,
    );
    path_7.cubicTo(
      17.951999999999998,
      44.75000000000001,
      9.231999999999998,
      41.720000000000006,
      9.231999999999998,
      41.720000000000006,
    );
    path_7.cubicTo(
      9.231999999999998,
      41.720000000000006,
      19.241999999999997,
      46.660000000000004,
      36.902,
      44.84,
    );
    path_7.cubicTo(36.902, 44.85, 40.772, 42.03, 46.992000000000004, 40.59);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffDB7F40).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(23.613, 40.229);
    path_8.cubicTo(
      29.333,
      37.839,
      22.192999999999998,
      30.808999999999997,
      12.773,
      34.489,
    );
    path_8.cubicTo(3.3529999999999998, 38.169, 19.023, 42.149, 23.613, 40.229);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffF3CAB6).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(25.543, 38.5);
    path_9.cubicTo(25.713, 36.73, 22.293, 33.34, 16.073, 34.29);
    path_9.cubicTo(9.853000000000002, 35.25, 10.333, 37.78, 10.333, 37.78);
    path_9.cubicTo(10.333, 37.78, 9.313, 37.230000000000004, 9.813, 36.02);
    path_9.cubicTo(
      10.323,
      34.81,
      13.563,
      32.77,
      20.563000000000002,
      33.440000000000005,
    );
    path_9.cubicTo(
      27.563000000000002,
      34.11000000000001,
      25.543000000000003,
      38.50000000000001,
      25.543000000000003,
      38.50000000000001,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2608971, size.height * 0.7700600),
      Offset(size.width * 0.2608971, size.height * 0.6663200),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(35.213, 32.749);
    path_10.cubicTo(
      38.433,
      36.059000000000005,
      31.053,
      35.359,
      29.853,
      33.449000000000005,
    );
    path_10.cubicTo(
      28.663,
      31.539000000000005,
      32.993,
      30.459000000000003,
      35.213,
      32.749,
    );
    path_10.close();
    path_10.moveTo(36.023, 37.899);
    path_10.cubicTo(37.313, 38.769, 36.003, 38.859, 34.733000000000004, 38.499);
    path_10.cubicTo(33.453, 38.149, 35.473000000000006, 37.529, 36.023, 37.899);
    path_10.close();
    path_10.moveTo(42.832, 28.48);
    path_10.cubicTo(
      46.592,
      30.810000000000002,
      39.012,
      31.830000000000002,
      37.232,
      30.09,
    );
    path_10.cubicTo(35.452, 28.36, 39.482, 26.41, 42.832, 28.48);
    path_10.close();
    path_10.moveTo(11.613, 25.37);
    path_10.cubicTo(14.763, 26.46, 8.302999999999999, 30.42, 5.443, 29.55);
    path_10.cubicTo(
      2.5829999999999997,
      28.68,
      5.763,
      23.330000000000002,
      11.613,
      25.37,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffDB7F40).withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class ThirdStonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.19, 25.515);
    path_0.cubicTo(3.28, 38.145, 45.239999999999995, 38.825, 54.87, 27.595);
    path_0.cubicTo(
      57.349999999999994,
      24.705,
      57.39,
      19.994999999999997,
      54.94,
      15.264999999999999,
    );
    path_0.lineTo(54.93, 15.254999999999999);
    path_0.cubicTo(
      51.71,
      9.035,
      44.16,
      2.754999999999999,
      32.11,
      0.4949999999999992,
    );
    path_0.cubicTo(
      19.35,
      -1.9050000000000007,
      9.7,
      4.8149999999999995,
      4.460000000000001,
      12.245,
    );
    path_0.cubicTo(
      4.460000000000001,
      12.245,
      4.460000000000001,
      12.254999999999999,
      4.450000000000001,
      12.264999999999999,
    );
    path_0.cubicTo(
      0.9700000000000011,
      17.185,
      -0.5699999999999985,
      22.424999999999997,
      0.19000000000000128,
      25.515,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4977544, size.height * 0.9871667),
      Offset(size.width * 0.4977544, size.height * -0.005555556),
      [
        Color(0xffA93D54).withValues(alpha: 1),
        Color(0xffAC454A).withValues(alpha: 1),
        Color(0xffB3592E).withValues(alpha: 1),
        Color(0xffB8661D).withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0.19, 25.515);
    path_1.cubicTo(3.28, 38.145, 45.239999999999995, 38.825, 54.87, 27.595);
    path_1.cubicTo(
      57.349999999999994,
      24.705,
      57.39,
      19.994999999999997,
      54.94,
      15.264999999999999,
    );
    path_1.lineTo(54.93, 15.254999999999999);
    path_1.cubicTo(
      54.93,
      15.254999999999999,
      56.81,
      33.885,
      25.87,
      32.974999999999994,
    );
    path_1.cubicTo(
      -4.559999999999999,
      32.084999999999994,
      4.150000000000002,
      12.904999999999994,
      4.440000000000001,
      12.264999999999993,
    );
    path_1.cubicTo(
      0.9700000000000011,
      17.184999999999995,
      -0.5699999999999985,
      22.424999999999994,
      0.19000000000000128,
      25.514999999999993,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4977719, size.height * 0.9871667),
      Offset(size.width * 0.4977719, size.height * 0.3406667),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(47.28, 24.345);
    path_2.cubicTo(52.61, 15.065, 31.53, -0.715, 16, 7.965);
    path_2.cubicTo(
      0.47000000000000064,
      16.655,
      1.6099999999999994,
      29.235,
      25.75,
      32.095,
    );
    path_2.cubicTo(38, 33.545, 47.28, 24.345, 47.28, 24.345);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(50.88, 11.895);
    path_3.cubicTo(52.77, 14.674999999999999, 35.27, 5.335, 32.78, 3.215);
    path_3.cubicTo(
      30.28,
      1.0949999999999998,
      43.480000000000004,
      1.0549999999999997,
      50.88,
      11.895,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(23.94, 30.815);
    path_4.cubicTo(
      34.370000000000005,
      31.315,
      17.14,
      17.285000000000004,
      9.660000000000002,
      17.825000000000003,
    );
    path_4.cubicTo(
      2.1800000000000015,
      18.355000000000004,
      7.560000000000002,
      30.025000000000002,
      23.94,
      30.815000000000005,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(51.74, 22.625);
    path_5.cubicTo(51.74, 22.625, 49.89, 19.905, 43.480000000000004, 23.075);
    path_5.cubicTo(
      37.080000000000005,
      26.244999999999997,
      37.99,
      31.155,
      37.99,
      31.155,
    );
    path_5.cubicTo(37.99, 31.155, 50.61, 30.335, 51.74, 22.625);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7867193, size.height * 0.8656389),
      Offset(size.width * 0.7867193, size.height * 0.5983611),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(48.13, 22.095);
    path_6.cubicTo(
      52.1,
      21.955,
      46.61,
      28.104999999999997,
      42.300000000000004,
      28.974999999999998,
    );
    path_6.cubicTo(
      37.99,
      29.845,
      38.93000000000001,
      27.444999999999997,
      38.93000000000001,
      27.444999999999997,
    );
    path_6.cubicTo(
      38.93000000000001,
      27.444999999999997,
      41.49000000000001,
      22.324999999999996,
      48.13000000000001,
      22.095,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffCC81B3).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(51.74, 22.625);
    path_7.cubicTo(
      51.74,
      22.625,
      49.440000000000005,
      27.115000000000002,
      44.36,
      28.785,
    );
    path_7.cubicTo(39.279999999999994, 30.455, 38.04, 29.405, 38.04, 29.405);
    path_7.cubicTo(
      38.04,
      29.405,
      37.839999999999996,
      30.935000000000002,
      38.04,
      31.335,
    );
    path_7.cubicTo(38.24, 31.735, 49.4, 30.975, 51.739999999999995, 22.625);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffD46D31).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(30.85, 7.315);
    path_8.cubicTo(
      39.410000000000004,
      8.945,
      30.75,
      13.365,
      27.200000000000003,
      10.815000000000001,
    );
    path_8.cubicTo(
      23.650000000000002,
      8.275000000000002,
      27.340000000000003,
      6.645000000000001,
      30.85,
      7.315000000000001,
    );
    path_8.close();
    path_8.moveTo(22.12, 2.3950000000000005);
    path_8.cubicTo(
      31.630000000000003,
      3.0750000000000006,
      17.98,
      6.905,
      14.530000000000001,
      7.165,
    );
    path_8.cubicTo(
      11.07,
      7.425,
      12.940000000000001,
      1.745,
      22.12,
      2.3950000000000005,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffCC7CD4).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(37.74, 32.185);
    path_9.cubicTo(
      37.74,
      32.185,
      21.900000000000002,
      33.155,
      14.470000000000002,
      30.825000000000003,
    );
    path_9.cubicTo(
      7.0500000000000025,
      28.495000000000005,
      4.5500000000000025,
      24.615000000000002,
      4.5500000000000025,
      24.615000000000002,
    );
    path_9.cubicTo(
      4.5500000000000025,
      24.615000000000002,
      9.440000000000001,
      36.665000000000006,
      37.74,
      32.185,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xffD96E40).withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(37.74, 32.185);
    path_10.cubicTo(
      37.74,
      32.185,
      32.77,
      31.805000000000003,
      29.090000000000003,
      31.545,
    );
    path_10.cubicTo(
      25.42,
      31.295,
      21.140000000000004,
      32.945,
      21.140000000000004,
      32.945,
    );
    path_10.cubicTo(
      21.140000000000004,
      32.945,
      29.610000000000007,
      35.075,
      37.74000000000001,
      32.185,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xff9A3116).withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(21.14, 32.945);
    path_11.cubicTo(21.14, 32.945, 25, 31.635, 28.69, 31.525);
    path_11.cubicTo(
      32.39,
      31.424999999999997,
      38.27,
      32.074999999999996,
      38.27,
      32.074999999999996,
    );
    path_11.cubicTo(
      38.27,
      32.074999999999996,
      31.78,
      30.934999999999995,
      27.190000000000005,
      31.154999999999994,
    );
    path_11.cubicTo(
      22.600000000000005,
      31.384999999999994,
      16.450000000000003,
      32.184999999999995,
      16.450000000000003,
      32.184999999999995,
    );
    path_11.cubicTo(
      16.450000000000003,
      32.184999999999995,
      19.640000000000004,
      32.955,
      21.140000000000004,
      32.94499999999999,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xffD96E40).withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(21.41, 17.634);
    path_12.cubicTo(25.92, 14.874, 20.29, 6.744, 12.870000000000001, 10.994);
    path_12.cubicTo(5.450000000000001, 15.244, 17.79, 19.854, 21.41, 17.634);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xffF3CAB6).withValues(alpha: 1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(22.93, 15.635);
    path_13.cubicTo(
      23.06,
      13.594999999999999,
      20.37,
      9.665,
      15.46,
      10.774999999999999,
    );
    path_13.cubicTo(
      10.55,
      11.884999999999998,
      10.940000000000001,
      14.814999999999998,
      10.940000000000001,
      14.814999999999998,
    );
    path_13.cubicTo(
      10.940000000000001,
      14.814999999999998,
      10.13,
      14.174999999999997,
      10.530000000000001,
      12.774999999999999,
    );
    path_13.cubicTo(
      10.930000000000001,
      11.384999999999998,
      13.48,
      9.024999999999999,
      19,
      9.784999999999998,
    );
    path_13.cubicTo(
      24.52,
      10.544999999999998,
      22.93,
      15.634999999999998,
      22.93,
      15.634999999999998,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2945088, size.height * 0.4344167),
      Offset(size.width * 0.2945088, size.height * 0.2678333),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(26.65, 31.135);
    path_14.cubicTo(
      29.669999999999998,
      29.485000000000003,
      22.799999999999997,
      27.405,
      19.169999999999998,
      29.895000000000003,
    );
    path_14.cubicTo(
      15.54,
      32.385000000000005,
      25.009999999999998,
      32.035000000000004,
      26.65,
      31.135,
    );
    path_14.close();
    path_14.moveTo(27.869999999999997, 24.825000000000003);
    path_14.cubicTo(
      28.63,
      26.075000000000003,
      26.139999999999997,
      26.015000000000004,
      25.58,
      24.905,
    );
    path_14.cubicTo(
      25.009999999999998,
      23.805,
      27.389999999999997,
      24.035,
      27.869999999999997,
      24.825000000000003,
    );
    path_14.close();
    path_14.moveTo(28.119999999999997, 27.025000000000002);
    path_14.cubicTo(
      27.9,
      26.215000000000003,
      27.099999999999998,
      26.335,
      27.369999999999997,
      27.025000000000002,
    );
    path_14.cubicTo(
      27.639999999999997,
      27.715000000000003,
      28.24,
      27.435000000000002,
      28.119999999999997,
      27.025000000000002,
    );
    path_14.close();
    path_14.moveTo(37.739999999999995, 23.015);
    path_14.cubicTo(
      39.60999999999999,
      23.965,
      37.62,
      26.545,
      34.519999999999996,
      25.625,
    );
    path_14.cubicTo(
      31.409999999999997,
      24.715,
      35.08,
      21.655,
      37.739999999999995,
      23.015,
    );
    path_14.close();
    path_14.moveTo(32.089999999999996, 22.874000000000002);
    path_14.cubicTo(
      32.959999999999994,
      23.074,
      31.859999999999996,
      23.814000000000004,
      31.449999999999996,
      23.664,
    );
    path_14.cubicTo(
      31.029999999999994,
      23.514000000000003,
      31.109999999999996,
      22.644000000000002,
      32.089999999999996,
      22.874000000000002,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = Color(0xffD96E40).withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(23.7, 27.254);
    path_15.cubicTo(
      24.77,
      28.354000000000003,
      22.88,
      28.894000000000002,
      21.29,
      27.994,
    );
    path_15.cubicTo(19.71, 27.094, 22.71, 26.244, 23.7, 27.254);
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = Color(0xffD96E40).withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class FourthStonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(21.65, 23.783);
    path_0.cubicTo(
      34.96,
      25.823,
      38.64,
      13.443000000000001,
      38.07,
      11.103000000000002,
    );
    path_0.cubicTo(
      37.75,
      9.803,
      36.85,
      8.373000000000001,
      35.51,
      6.993000000000001,
    );
    path_0.cubicTo(
      35.5,
      6.983000000000001,
      35.5,
      6.973000000000002,
      35.48,
      6.963000000000001,
    );
    path_0.cubicTo(
      29.849999999999998,
      1.2230000000000008,
      16.509999999999998,
      -3.7569999999999997,
      5.229999999999997,
      3.943000000000001,
    );
    path_0.cubicTo(
      3.499999999999997,
      5.123000000000001,
      2.2399999999999967,
      6.283000000000001,
      1.3999999999999968,
      7.423000000000001,
    );
    path_0.cubicTo(
      -4.610000000000003,
      15.433,
      9.979999999999997,
      21.993000000000002,
      21.65,
      23.783,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4887692, size.height * 1.000458),
      Offset(size.width * 0.4887692, size.height * -0.02083333),
      [
        Color(0xffA93D54).withValues(alpha: 1),
        Color(0xffAC454A).withValues(alpha: 1),
        Color(0xffB3592E).withValues(alpha: 1),
        Color(0xffB8661D).withValues(alpha: 1),
      ],
      [0, 0.277, 0.754, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(21.65, 23.783);
    path_1.cubicTo(
      34.96,
      25.823,
      38.64,
      13.443000000000001,
      38.07,
      11.103000000000002,
    );
    path_1.cubicTo(
      37.75,
      9.803,
      36.85,
      8.373000000000001,
      35.51,
      6.993000000000001,
    );
    path_1.cubicTo(
      38.93,
      10.533000000000001,
      33.8,
      21.573,
      20.61,
      21.743000000000002,
    );
    path_1.cubicTo(
      7.399999999999999,
      21.913000000000004,
      1.2100000000000009,
      9.813000000000002,
      1.3999999999999986,
      7.413000000000002,
    );
    path_1.cubicTo(
      -4.610000000000001,
      15.433000000000002,
      9.979999999999999,
      21.993000000000002,
      21.65,
      23.783,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4887692, size.height * 1.000417),
      Offset(size.width * 0.4887692, size.height * 0.2912917),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(32.34, 16.573);
    path_2.cubicTo(
      38.910000000000004,
      10.783000000000001,
      25.42,
      0.6029999999999998,
      13.520000000000003,
      2.453000000000001,
    );
    path_2.cubicTo(
      1.6200000000000028,
      4.293000000000001,
      4.4200000000000035,
      15.943000000000001,
      14.670000000000003,
      19.313000000000002,
    );
    path_2.cubicTo(
      24.910000000000004,
      22.683000000000003,
      32.34,
      16.573,
      32.34,
      16.573,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(32.34, 15.504);
    path_3.cubicTo(
      35.07,
      10.783999999999999,
      16.980000000000004,
      12.824,
      13.670000000000002,
      16.323999999999998,
    );
    path_3.cubicTo(
      10.360000000000001,
      19.823999999999998,
      27.62,
      23.653999999999996,
      32.34,
      15.503999999999998,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(33.149, 4.953);
    path_4.cubicTo(33.959, 5.583, 25.529, 1.4730000000000003, 16.129, 2.233);
    path_4.cubicTo(
      6.729000000000001,
      2.9930000000000003,
      3.6090000000000018,
      5.953,
      3.6090000000000018,
      5.953,
    );
    path_4.cubicTo(
      3.6090000000000018,
      5.953,
      7.159000000000002,
      1.1230000000000002,
      16.949,
      0.35300000000000065,
    );
    path_4.cubicTo(26.739, -0.41699999999999937, 33.149, 4.953, 33.149, 4.953);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffCC7CD4).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(30.509, 19.013);
    path_5.cubicTo(
      30.509,
      19.013,
      21.319000000000003,
      21.493000000000002,
      14.199000000000002,
      19.793000000000003,
    );
    path_5.cubicTo(
      7.0790000000000015,
      18.093000000000004,
      3.269000000000002,
      12.003000000000004,
      3.269000000000002,
      12.003000000000004,
    );
    path_5.cubicTo(
      3.269000000000002,
      12.003000000000004,
      5.339000000000002,
      18.633000000000003,
      14.919000000000002,
      21.323000000000004,
    );
    path_5.cubicTo(
      24.509,
      24.013000000000005,
      30.509,
      19.013000000000005,
      30.509,
      19.013000000000005,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffCC6D40).withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(19.39, 19.874);
    path_6.cubicTo(
      24.36,
      18.253999999999998,
      19.29,
      15.593999999999998,
      15,
      17.064,
    );
    path_6.cubicTo(10.719999999999999, 18.524, 17.78, 20.404, 19.39, 19.874);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffDB7F40).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(18.799, 15.864);
    path_7.cubicTo(20.479, 17.084, 17.269, 16.384, 16.889, 15.864);
    path_7.cubicTo(
      16.509,
      15.344000000000001,
      17.628999999999998,
      15.024000000000001,
      18.799,
      15.864,
    );
    path_7.close();
    path_7.moveTo(14.37, 13.864);
    path_7.cubicTo(17.48, 15.724, 10.969999999999999, 18.664, 9.61, 16.924);
    path_7.cubicTo(8.25, 15.184, 12.37, 12.664, 14.37, 13.863999999999999);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffDB7F40).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class FifthStonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.024, 9.5);
    path_0.lineTo(0.024, 9.52);
    path_0.cubicTo(-0.516, 16.5, 8.254, 25.16, 12.963999999999999, 26.8);
    path_0.cubicTo(
      19.793999999999997,
      29.18,
      36.244,
      23.25,
      38.403999999999996,
      14.59,
    );
    path_0.cubicTo(
      39.083999999999996,
      11.85,
      38.684,
      9.42,
      37.474,
      7.359999999999999,
    );
    path_0.cubicTo(
      33.434,
      0.5099999999999998,
      20.313999999999997,
      -2.1799999999999997,
      7.513999999999996,
      1.9699999999999998,
    );
    path_0.cubicTo(2.384, 3.63, 0.274, 6.4, 0.024, 9.5);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4965897, size.height * 0.9759286),
      Offset(size.width * 0.4965897, size.height * 0.01071429),
      [
        Color(0xffC35934).withValues(alpha: 1),
        Color(0xffC5632E).withValues(alpha: 1),
        Color(0xffC97F1F).withValues(alpha: 1),
        Color(0xffCA821D).withValues(alpha: 1),
      ],
      [0, 0.347, 0.945, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0.024, 9.51);
    path_1.cubicTo(
      -0.516,
      16.490000000000002,
      8.254,
      25.15,
      12.963999999999999,
      26.79,
    );
    path_1.cubicTo(
      19.793999999999997,
      29.169999999999998,
      36.244,
      23.24,
      38.403999999999996,
      14.579999999999998,
    );
    path_1.cubicTo(
      39.083999999999996,
      11.839999999999998,
      38.684,
      9.409999999999998,
      37.474,
      7.349999999999998,
    );
    path_1.arcToPoint(
      Offset(37.45399999999999, 7.339999999999998),
      radius: Radius.elliptical(0.031, 0.031),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.cubicTo(
      37.45399999999999,
      7.339999999999998,
      40.28399999999999,
      20.54,
      23.623999999999995,
      22.56,
    );
    path_1.cubicTo(
      7.2039999999999935,
      24.56,
      0.6139999999999937,
      12.94,
      0.023999999999993804,
      9.509999999999998,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4965897, size.height * 0.9759286),
      Offset(size.width * 0.4965897, size.height * 0.2627500),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(29.634, 20.181);
    path_2.cubicTo(
      38.374,
      15.351,
      21.954,
      4.651000000000002,
      6.693999999999999,
      7.711,
    );
    path_2.cubicTo(-8.566, 10.771, 13.854, 28.901000000000003, 29.634, 20.181);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(23.624, 22.57);
    path_3.cubicTo(
      27.933999999999997,
      21.87,
      16.394,
      16.97,
      9.553999999999998,
      15.89,
    );
    path_3.cubicTo(
      2.7139999999999986,
      14.810000000000002,
      9.423999999999998,
      24.89,
      23.624,
      22.57,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(31.294, 20.31);
    path_4.cubicTo(31.294, 20.31, 29.464, 19.04, 26.514, 19.95);
    path_4.cubicTo(
      23.564,
      20.86,
      23.253999999999998,
      22.63,
      23.253999999999998,
      22.63,
    );
    path_4.cubicTo(
      23.253999999999998,
      22.63,
      29.413999999999998,
      24.259999999999998,
      31.293999999999997,
      20.31,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6992308, size.height * 0.8201071),
      Offset(size.width * 0.6992308, size.height * 0.7007857),
      [
        Color(0xffB8661D).withValues(alpha: 1),
        Color(0xffB55F1E).withValues(alpha: 1),
        Color(0xffA33224).withValues(alpha: 1),
        Color(0xff971628).withValues(alpha: 1),
        Color(0xff930C29).withValues(alpha: 1),
      ],
      [0, 0.059, 0.482, 0.81, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(29.544, 19.7);
    path_5.cubicTo(30.964, 20.13, 28.734, 22.119999999999997, 26.734, 22.36);
    path_5.cubicTo(
      24.734,
      22.61,
      23.624000000000002,
      21.82,
      23.624000000000002,
      21.82,
    );
    path_5.cubicTo(
      23.624000000000002,
      21.82,
      25.364,
      19.37,
      29.544000000000004,
      19.7,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffCC81B3).withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(31.174, 20.541);
    path_6.cubicTo(31.174, 20.541, 29.244, 23.141000000000002, 23.634, 22.721);
    path_6.cubicTo(23.634, 22.721, 28.754, 24.521, 31.174, 20.541);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffD46D31).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(36.514, 14.85);
    path_7.cubicTo(36.514, 14.85, 33.534000000000006, 18.45, 32.064, 18.99);
    path_7.cubicTo(
      30.604,
      19.529999999999998,
      28.914,
      18.919999999999998,
      26.254,
      19.66,
    );
    path_7.cubicTo(23.584000000000003, 20.4, 22.824, 22.04, 19.854, 22.4);
    path_7.cubicTo(16.884, 22.77, 12.134, 21.61, 12.134, 21.61);
    path_7.cubicTo(12.134, 21.61, 17.954, 23.96, 23.253999999999998, 22.62);
    path_7.cubicTo(
      23.253999999999998,
      22.62,
      24.073999999999998,
      20.64,
      26.813999999999997,
      19.89,
    );
    path_7.cubicTo(
      29.553999999999995,
      19.14,
      31.293999999999997,
      20.3,
      31.293999999999997,
      20.3,
    );
    path_7.cubicTo(
      31.293999999999997,
      20.3,
      35.763999999999996,
      18.62,
      36.513999999999996,
      14.850000000000001,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffDB7F40).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(26.354, 1.39);
    path_8.cubicTo(32.194, 2.17, 30.564, 7.55, 29.994, 8.22);
    path_8.cubicTo(29.424, 8.89, 21.734, 7.07, 12.134, 7.0600000000000005);
    path_8.cubicTo(2.534, 7.05, 0.694, 9.23, 0.694, 9.23);
    path_8.cubicTo(
      0.694,
      9.23,
      1.024,
      -1.9699999999999989,
      26.354,
      1.3900000000000006,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffCC7CD4).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(23.634, 17.01);
    path_9.cubicTo(
      26.224,
      18.41,
      23.874,
      18.96,
      21.624000000000002,
      17.970000000000002,
    );
    path_9.cubicTo(
      19.364000000000004,
      16.970000000000002,
      22.004,
      16.130000000000003,
      23.634,
      17.01,
    );
    path_9.close();
    path_9.moveTo(24.184, 18.951);
    path_9.cubicTo(
      25.354,
      19.171,
      24.284000000000002,
      19.631,
      23.804000000000002,
      19.671,
    );
    path_9.cubicTo(23.314000000000004, 19.701, 23.614, 18.841, 24.184, 18.951);
    path_9.close();
    path_9.moveTo(6.154, 14.64);
    path_9.cubicTo(10.254, 16.44, 9.533999999999999, 19.4, 6.514, 17.34);
    path_9.cubicTo(3.494, 15.29, 4.784000000000001, 14.03, 6.154, 14.64);
    path_9.close();
    path_9.moveTo(35.034, 12.361);
    path_9.cubicTo(38.464, 12.381, 35.494, 15.971, 33.954, 16.011);
    path_9.cubicTo(
      32.424,
      16.051,
      32.274,
      12.350999999999999,
      35.034,
      12.360999999999999,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xffE88C40).withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class SixthStonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.107, 13.217);
    path_0.cubicTo(
      2.067,
      21.907,
      16.436999999999998,
      31.767000000000003,
      33.037,
      26.847,
    );
    path_0.cubicTo(49.647, 21.917, 50.747, 14.387, 47.027, 9.407);
    path_0.cubicTo(46.757, 9.057, 46.407000000000004, 8.657, 45.967, 8.227);
    path_0.lineTo(45.957, 8.217);
    path_0.cubicTo(
      43.207,
      5.477,
      37.247,
      1.3770000000000007,
      30.987000000000002,
      0.19700000000000095,
    );
    path_0.cubicTo(
      25.427000000000003,
      -0.8329999999999991,
      9.197000000000003,
      2.2470000000000008,
      2.7170000000000023,
      7.627000000000001,
    );
    path_0.cubicTo(
      2.7170000000000023,
      7.6370000000000005,
      2.7070000000000025,
      7.6370000000000005,
      2.7070000000000025,
      7.6370000000000005,
    );
    path_0.cubicTo(
      0.7070000000000025,
      9.287,
      -0.35299999999999754,
      11.167,
      0.10700000000000243,
      13.217,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4976735, size.height * 0.9710690),
      Offset(size.width * 0.4976735, size.height * -0.02758621),
      [
        Color(0xffC35934).withValues(alpha: 1),
        Color(0xffC5632E).withValues(alpha: 1),
        Color(0xffC97F1F).withValues(alpha: 1),
        Color(0xffCA821D).withValues(alpha: 1),
      ],
      [0, 0.347, 0.945, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0.107, 13.218);
    path_1.cubicTo(2.067, 21.908, 16.436999999999998, 31.768, 33.037, 26.848);
    path_1.cubicTo(
      49.647,
      21.918,
      50.747,
      14.387999999999998,
      47.027,
      9.407999999999998,
    );
    path_1.cubicTo(
      46.757,
      9.057999999999998,
      46.407000000000004,
      8.657999999999998,
      45.967,
      8.227999999999998,
    );
    path_1.cubicTo(
      46.117,
      8.647999999999998,
      49.817,
      16.528,
      37.227,
      21.467999999999996,
    );
    path_1.cubicTo(
      24.357,
      26.507999999999996,
      13.066999999999997,
      25.427999999999997,
      5.796999999999997,
      18.067999999999998,
    );
    path_1.cubicTo(
      0.6369999999999969,
      12.837999999999997,
      1.676999999999997,
      9.277999999999999,
      2.706999999999997,
      7.637999999999998,
    );
    path_1.cubicTo(
      0.7069999999999972,
      9.287999999999998,
      -0.35300000000000287,
      11.167999999999997,
      0.1069999999999971,
      13.217999999999998,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4976735, size.height * 0.9710690),
      Offset(size.width * 0.4976735, size.height * 0.2632414),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(41.796, 17.047);
    path_2.cubicTo(
      47.436,
      10.017,
      36.106,
      -2.4529999999999994,
      14.136,
      3.8369999999999997,
    );
    path_2.cubicTo(
      -2.474,
      8.597,
      6.715999999999999,
      23.187,
      22.485999999999997,
      23.557,
    );
    path_2.cubicTo(
      38.256,
      23.927,
      41.79599999999999,
      17.046999999999997,
      41.79599999999999,
      17.046999999999997,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(42.056, 16.707);
    path_3.cubicTo(
      44.296,
      12.847000000000001,
      32.775999999999996,
      16.697,
      31.355999999999998,
      19.917,
    );
    path_3.cubicTo(
      29.926,
      23.127000000000002,
      38.666,
      22.537000000000003,
      42.056,
      16.707,
    );
    path_3.close();
    path_3.moveTo(25.386999999999997, 22.497);
    path_3.cubicTo(
      33.596999999999994,
      18.617,
      19.397,
      8.047,
      10.646999999999997,
      8.207,
    );
    path_3.cubicTo(
      1.8969999999999967,
      8.377,
      4.716999999999997,
      24.827,
      25.386999999999997,
      22.497,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffFCC400).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(34.106, 4.717);
    path_4.cubicTo(
      38.546,
      7.0569999999999995,
      26.506,
      10.317,
      20.306,
      9.056999999999999,
    );
    path_4.cubicTo(
      14.106000000000002,
      7.796999999999999,
      13.546000000000001,
      6.166999999999998,
      13.546000000000001,
      6.166999999999998,
    );
    path_4.cubicTo(
      13.546000000000001,
      6.166999999999998,
      23.046,
      -1.1130000000000022,
      34.106,
      4.716999999999998,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffCC7CD4).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(30.326, 23.618);
    path_5.cubicTo(30.326, 23.618, 15.076, 25.238, 4.815999999999999, 17.008);
    path_5.cubicTo(4.815999999999999, 17.008, 11.186, 28.198, 30.326, 23.618);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffDB7F40).withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(44.896, 21.207);
    path_6.cubicTo(44.896, 21.207, 33.516, 25.927, 22.186, 24.717);
    path_6.cubicTo(
      10.856000000000002,
      23.506999999999998,
      1.716000000000001,
      17.037,
      1.716000000000001,
      17.037,
    );
    path_6.cubicTo(
      1.716000000000001,
      17.037,
      6.536000000000001,
      25.557,
      18.806,
      27.677,
    );
    path_6.cubicTo(31.076, 29.807, 44.896, 21.207, 44.896, 21.207);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.9162449, size.height * 0.7769655),
      Offset(size.width * 0.03514286, size.height * 0.7769655),
      [
        Color(0xffB1765E).withValues(alpha: 1),
        Color(0xffC28E72).withValues(alpha: 1),
        Color(0xffE3BB97).withValues(alpha: 1),
        Color(0xffF7D7AD).withValues(alpha: 1),
        Color(0xffFFE1B6).withValues(alpha: 1),
      ],
      [0, 0.176, 0.547, 0.834, 1],
    );
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(26.337, 21.237);
    path_7.cubicTo(29.367, 24.357, 25.747, 24.096999999999998, 22.457, 22.717);
    path_7.cubicTo(19.167, 21.346999999999998, 25.287, 20.147, 26.337, 21.237);
    path_7.close();
    path_7.moveTo(16.657, 20.506999999999998);
    path_7.cubicTo(
      17.777,
      21.366999999999997,
      15.187,
      21.487,
      14.527000000000001,
      20.647,
    );
    path_7.cubicTo(
      13.857000000000001,
      19.807,
      16.057000000000002,
      20.046999999999997,
      16.657,
      20.506999999999998,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffE88C40).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(22.876, 19.347);
    path_8.cubicTo(
      24.066000000000003,
      20.837,
      19.866,
      21.807000000000002,
      17.876,
      20.087,
    );
    path_8.cubicTo(15.886000000000001, 18.367, 21.196, 17.247, 22.876, 19.347);
    path_8.close();
    path_8.moveTo(4.817, 9.697);
    path_8.cubicTo(
      5.9670000000000005,
      10.167,
      6.627000000000001,
      13.007,
      4.817,
      12.167,
    );
    path_8.cubicTo(3.007, 11.327, 3.967, 9.347, 4.817, 9.697);
    path_8.close();
    path_8.moveTo(37.376, 12.117999999999999);
    path_8.cubicTo(
      38.916,
      14.457999999999998,
      35.955999999999996,
      14.447999999999999,
      35.056,
      13.287999999999998,
    );
    path_8.cubicTo(
      34.166,
      12.117999999999999,
      36.775999999999996,
      11.207999999999998,
      37.376,
      12.117999999999999,
    );
    path_8.close();
    path_8.moveTo(44.897, 12.078);
    path_8.cubicTo(
      45.887,
      12.048,
      44.707,
      13.338,
      44.376999999999995,
      13.427999999999999,
    );
    path_8.cubicTo(
      44.047,
      13.517999999999999,
      43.24699999999999,
      12.127999999999998,
      44.897,
      12.078,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffE88C40).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
