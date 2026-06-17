import 'dart:ui' as ui;

import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class LevelButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(22.396, 50.992);
    path_0.cubicTo(
      5.366,
      49.412,
      -1.5139999999999993,
      34.952,
      0.2759999999999998,
      22.101999999999997,
    );
    path_0.lineTo(0.2759999999999998, 22.071999999999996);
    path_0.cubicTo(
      1.2359999999999998,
      15.041999999999994,
      4.816,
      8.501999999999995,
      10.746,
      4.811999999999994,
    );
    path_0.cubicTo(
      26.576,
      -5.018000000000006,
      45.146,
      1.2019999999999942,
      51.836000000000006,
      14.541999999999994,
    );
    path_0.cubicTo(
      51.836000000000006,
      14.541999999999994,
      51.836000000000006,
      14.551999999999994,
      51.846000000000004,
      14.581999999999994,
    );
    path_0.arcToPoint(
      Offset(53.956, 20.851999999999993),
      radius: Radius.elliptical(24.13, 24.13),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      56.496,
      34.562,
      48.756,
      53.46199999999999,
      22.396000000000004,
      50.99199999999999,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4945818, size.height * 0.9849038),
      Offset(size.width * 0.4945818, size.height * 0.02307692),
      [
        Color(0xff740054).withOpacity(1),
        Color(0xff7E034E).withOpacity(1),
        Color(0xff9A0A3E).withOpacity(1),
        Color(0xffC71724).withOpacity(1),
        Color(0xffD41A1D).withOpacity(1),
      ],
      [0, 0.181, 0.493, 0.895, 1],
    );
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(22.616, 49.201);
    path_1.cubicTo(
      6.385999999999999,
      47.731,
      -0.1739999999999995,
      34.301,
      1.5259999999999998,
      22.351,
    );
    path_1.lineTo(1.5259999999999998, 22.331);
    path_1.cubicTo(
      2.4459999999999997,
      15.800999999999998,
      5.856,
      9.721,
      11.506,
      6.300999999999998,
    );
    path_1.cubicTo(
      26.596,
      -2.8290000000000024,
      44.296,
      2.9509999999999983,
      50.666,
      15.340999999999998,
    );
    path_1.cubicTo(
      50.666,
      15.340999999999998,
      50.666,
      15.350999999999997,
      50.675999999999995,
      15.380999999999997,
    );
    path_1.cubicTo(
      51.605999999999995,
      17.190999999999995,
      52.285999999999994,
      19.141,
      52.68599999999999,
      21.211,
    );
    path_1.cubicTo(
      55.12599999999999,
      33.931,
      47.745999999999995,
      51.491,
      22.615999999999993,
      49.20099999999999,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4945818, size.height * 0.9500000),
      Offset(size.width * 0.4945818, size.height * 0.03511538),
      [
        Color(0xffC90054).withOpacity(1),
        Color(0xffD10A4C).withOpacity(1),
        Color(0xffE62637).withOpacity(1),
        Color(0xffFF481D).withOpacity(1),
      ],
      [0, 0.226, 0.613, 1],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(18.056, 13.431);
    path_2.cubicTo(8.746, 19.521, 9.876000000000001, 39.051, 24.526, 40.491);
    path_2.cubicTo(
      39.176,
      41.931,
      43.486000000000004,
      30.860999999999997,
      42.066,
      22.841,
    );
    path_2.cubicTo(
      40.246,
      12.591000000000001,
      28.146,
      6.8309999999999995,
      18.056,
      13.431000000000001,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4944364, size.height * 0.7810385),
      Offset(size.width * 0.4944364, size.height * 0.2041346),
      [
        Color(0xffFFBD00).withOpacity(1),
        Color(0xffFFC700).withOpacity(1),
        Color(0xffFFE300).withOpacity(1),
        Color(0xffFFE500).withOpacity(1),
      ],
      [0, 0.354, 0.963, 1],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(22.616, 49.201);
    path_3.cubicTo(
      6.385999999999999,
      47.731,
      -0.1739999999999995,
      34.301,
      1.5259999999999998,
      22.351,
    );
    path_3.cubicTo(
      1.4359999999999997,
      24.541,
      1.1559999999999997,
      39.351,
      17.566,
      45.480999999999995,
    );
    path_3.cubicTo(
      31.985999999999997,
      50.861,
      46.465999999999994,
      44.080999999999996,
      49.736000000000004,
      33.770999999999994,
    );
    path_3.cubicTo(
      52.886,
      23.840999999999994,
      50.82600000000001,
      15.930999999999994,
      50.676,
      15.360999999999994,
    );
    path_3.cubicTo(
      51.606,
      17.170999999999992,
      52.286,
      19.120999999999995,
      52.686,
      21.190999999999995,
    );
    path_3.cubicTo(55.126, 33.931, 47.746, 51.491, 22.616, 49.20099999999999);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4945818, size.height * 0.9500000),
      Offset(size.width * 0.4945818, size.height * 0.2955577),
      [
        Color(0xffB1255E).withOpacity(1),
        Color(0xffC34F72).withOpacity(1),
        Color(0xffDC8D8F).withOpacity(1),
        Color(0xffEFBBA4).withOpacity(1),
        Color(0xffFBD7B1).withOpacity(1),
        Color(0xffFFE1B6).withOpacity(1),
      ],
      [0, 0.178, 0.463, 0.706, 0.892, 1],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(12.515, 29.791);
    path_4.cubicTo(8.585, 22.031, 12.015, 8.591000000000001, 26.725, 8.041);
    path_4.cubicTo(
      41.335,
      7.4910000000000005,
      44.405,
      21.541,
      41.995000000000005,
      29.121,
    );
    path_4.cubicTo(
      41.995000000000005,
      29.121,
      42.315000000000005,
      13.120999999999999,
      27.205000000000005,
      12.721,
    );
    path_4.cubicTo(
      10.405000000000005,
      12.271,
      12.515000000000006,
      29.791,
      12.515000000000006,
      29.791,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4885636, size.height * 0.5728462),
      Offset(size.width * 0.4885636, size.height * 0.1542500),
      [
        Color(0xffFFE1B6).withOpacity(1),
        Color(0xffFDD7B2).withOpacity(1),
        Color(0xffF8BBA7).withOpacity(1),
        Color(0xffEF8D95).withOpacity(1),
        Color(0xffE24E7D).withOpacity(1),
        Color(0xffD3005E).withOpacity(1),
      ],
      [0, 0.094, 0.257, 0.468, 0.72, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(4.396, 17.841);
    path_5.cubicTo(
      3.9659999999999997,
      21.471,
      9.806000000000001,
      9.261000000000001,
      25.626,
      8.021,
    );
    path_5.cubicTo(41.446, 6.791, 43.606, 20.271, 48.196, 20.951);
    path_5.cubicTo(
      52.775999999999996,
      21.631,
      48.196,
      2.4110000000000014,
      28.075999999999997,
      2.401,
    );
    path_5.cubicTo(
      7.955999999999996,
      2.401,
      4.545999999999996,
      16.570999999999998,
      4.395999999999997,
      17.841,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffFFDBFF).withOpacity(1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(13.446, 38.542);
    path_6.cubicTo(10.206, 37.302, 12.536, 46.232, 30.516, 46.202);
    path_6.cubicTo(40.215999999999994, 46.192, 40.896, 41.042, 41.336, 40.172);
    path_6.cubicTo(
      41.766,
      39.291999999999994,
      30.035999999999998,
      44.902,
      13.445999999999998,
      38.541999999999994,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Colors.yellow.withOpacity(1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(4.996, 15.712);
    path_7.cubicTo(3.1560000000000006, 20.512, 9.816, 17.612, 10.406, 14.192);
    path_7.cubicTo(
      10.996,
      10.782,
      6.486000000000001,
      11.812000000000001,
      4.996,
      15.712,
    );
    path_7.close();
    path_7.moveTo(42.736000000000004, 39.012);
    path_7.cubicTo(
      42.376000000000005,
      38.922,
      45.816,
      32.802,
      48.04600000000001,
      32.382,
    );
    path_7.cubicTo(
      50.276,
      31.961999999999996,
      47.07600000000001,
      40.152,
      42.736000000000004,
      39.012,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Colors.yellow.withOpacity(1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(2.256, 18.892);
    path_8.cubicTo(2.256, 18.892, 9.746, 43.012, 18.296, 46.212);
    path_8.cubicTo(
      18.296,
      46.202000000000005,
      -1.5040000000000013,
      42.692,
      2.2560000000000002,
      18.892000000000003,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.03245455, size.height * 0.6258654),
      Offset(size.width * 0.3327455, size.height * 0.6258654),
      [
        Color(0xff1E72EA).withOpacity(1),
        Color(0xff1F6FE4).withOpacity(1),
        Color(0xff2652AE).withOpacity(1),
        Color(0xff2D3B81).withOpacity(1),
        Color(0xff32295E).withOpacity(1),
        Color(0xff351C44).withOpacity(1),
        Color(0xff371435).withOpacity(1),
        Color(0xff381130).withOpacity(1),
      ],
      [0.011, 0.031, 0.217, 0.398, 0.571, 0.733, 0.88, 1],
    );
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(48.776, 19.922);
    path_9.cubicTo(47.136, 20.322, 47.816, 22.932000000000002, 48.966, 23.482);
    path_9.cubicTo(
      50.126,
      24.041999999999998,
      50.686,
      19.451999999999998,
      48.776,
      19.922,
    );
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Colors.yellow.withOpacity(1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(12.795, 23.912);
    path_10.cubicTo(12.795, 23.912, 14.675, 15.021999999999998, 27.095, 14.292);
    path_10.cubicTo(
      39.515,
      13.562,
      41.475,
      24.752000000000002,
      41.475,
      24.752000000000002,
    );
    path_10.cubicTo(
      41.475,
      24.752000000000002,
      40.385,
      11.252000000000002,
      27.205000000000002,
      11.682000000000002,
    );
    path_10.cubicTo(
      13.745000000000001,
      12.132000000000001,
      12.795000000000002,
      23.912000000000003,
      12.795000000000002,
      23.912000000000003,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffFFF91D).withOpacity(1.0);
    canvas.drawPath(path_10, paint10Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

