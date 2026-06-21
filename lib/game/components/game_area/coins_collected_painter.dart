import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CoinsCollectedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(8.744, 19.711);
    path_0.arcToPoint(
      Offset(48.166, 0),
      radius: Radius.elliptical(49.277, 49.277),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(82.054, 0);
    path_0.cubicTo(101.661, 0, 117.554, 15.894, 117.554, 35.5);
    path_0.cubicTo(116.054, 32.167, 110.854, 28.1, 102.054, 38.5);
    path_0.cubicTo(93.254, 48.9, 96.022, 35.833, 98.506, 28);
    path_0.cubicTo(102.435, 8.014, 97.426, 5.527000000000001, 79.054, 12.5);
    path_0.lineTo(51.054, 28);
    path_0.cubicTo(38.466, 34.984, 35.526, 32.968, 36.054, 21);
    path_0.cubicTo(
      37.462,
      10.15,
      27.967000000000002,
      15.030000000000001,
      0.021000000000000796,
      35.5,
    );
    path_0.arcToPoint(
      Offset(3.3930000000000007, 26.846),
      radius: Radius.elliptical(17.292, 17.292),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(8.744, 19.711);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4981102, 0),
      Offset(size.width * 0.4981102, size.height),
      [Color(0xffFFD46C).withOpacity(1), Color(0xffEF9600).withOpacity(1)],
      [0, 0.663],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(6.66, 51.711);
    path_1.cubicTo(
      4.705,
      49.623,
      3.024,
      47.266999999999996,
      1.8049999999999997,
      44.679,
    );
    path_1.cubicTo(0.329, 41.546, -0.105, 39.07, 0.02, 35.5);
    path_1.cubicTo(27.967, 15.03, 37.462, 10.15, 36.054, 21);
    path_1.cubicTo(35.526, 32.968, 38.466, 34.984, 51.054, 28);
    path_1.lineTo(79.054, 12.5);
    path_1.cubicTo(97.426, 5.527, 102.435, 8.014, 98.506, 28);
    path_1.cubicTo(96.022, 35.833, 93.254, 48.9, 102.054, 38.5);
    path_1.cubicTo(110.854, 28.1, 116.054, 32.167, 117.554, 35.5);
    path_1.lineTo(117.554, 40.185);
    path_1.cubicTo(
      117.554,
      52.257000000000005,
      108.94800000000001,
      53.551,
      98.506,
      47.493,
    );
    path_1.arcToPoint(
      Offset(89.73, 43.176),
      radius: Radius.elliptical(140.726, 140.726),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_1.cubicTo(
      83.632,
      39.851,
      79.58,
      39.269000000000005,
      71.02000000000001,
      41.256,
    );
    path_1.lineTo(29.084, 54.105);
    path_1.cubicTo(22.529, 56.113, 14.953999999999999, 58.506, 9.508, 54.342);
    path_1.cubicTo(
      8.550999999999998,
      53.61,
      7.619999999999999,
      52.734,
      6.661999999999999,
      51.711999999999996,
    );
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffF7A417).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01152542;
    paint_2_stroke.color = Color(0xff62573F).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.06133898,
          size.height * 0.4112113,
          size.width * 0.2052119,
          size.height * 0.3410563,
        ),
        bottomRight: Radius.circular(size.width * 0.1026017),
        bottomLeft: Radius.circular(size.width * 0.1026017),
        topLeft: Radius.circular(size.width * 0.1026017),
        topRight: Radius.circular(size.width * 0.1026017),
      ),
      paint_2_stroke,
    );

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.06133898,
          size.height * 0.4112113,
          size.width * 0.2052119,
          size.height * 0.3410563,
        ),
        bottomRight: Radius.circular(size.width * 0.1026017),
        bottomLeft: Radius.circular(size.width * 0.1026017),
        topLeft: Radius.circular(size.width * 0.1026017),
        topRight: Radius.circular(size.width * 0.1026017),
      ),
      paint_2_fill,
    );

    Path path_3 = Path();
    path_3.moveTo(24.852, 27.023);
    path_3.lineTo(26.192, 31.04);
    path_3.arcToPoint(
      Offset(25.625, 31.195),
      radius: Radius.elliptical(3.544, 3.544),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.arcToPoint(
      Offset(25.094, 31.421),
      radius: Radius.elliptical(5.628, 5.628),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.arcToPoint(
      Offset(23.92, 32.214999999999996),
      radius: Radius.elliptical(4.88, 4.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.arcToPoint(
      Offset(23.113000000000003, 33.260999999999996),
      radius: Radius.elliptical(3.475, 3.475),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.arcToPoint(
      Offset(22.816000000000003, 34.513),
      radius: Radius.elliptical(2.991, 2.991),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.cubicTo(
      22.812,
      34.958,
      22.927000000000003,
      35.422,
      23.163000000000004,
      35.905,
    );
    path_3.cubicTo(
      23.314000000000004,
      36.215,
      23.493000000000002,
      36.46,
      23.698000000000004,
      36.64,
    );
    path_3.cubicTo(
      23.910000000000004,
      36.817,
      24.142000000000003,
      36.936,
      24.394000000000005,
      36.998,
    );
    path_3.cubicTo(
      24.645000000000007,
      37.059999999999995,
      24.911000000000005,
      37.067,
      25.190000000000005,
      37.019,
    );
    path_3.cubicTo(
      25.470000000000006,
      36.972,
      25.755000000000006,
      36.876999999999995,
      26.047000000000004,
      36.734,
    );
    path_3.arcToPoint(
      Offset(26.701000000000004, 36.327000000000005),
      radius: Radius.elliptical(3.99, 3.99),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.cubicTo(
      26.916000000000004,
      36.163000000000004,
      27.121000000000006,
      35.98500000000001,
      27.315000000000005,
      35.794000000000004,
    );
    path_3.arcToPoint(
      Offset(28.319000000000006, 34.584),
      radius: Radius.elliptical(8.023, 8.023),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.lineTo(30.011000000000006, 38.962);
    path_3.arcToPoint(
      Offset(29.408000000000005, 39.655),
      radius: Radius.elliptical(6.596, 6.596),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      29.184000000000005,
      39.875,
      28.946000000000005,
      40.091,
      28.695000000000004,
      40.302,
    );
    path_3.arcToPoint(
      Offset(27.910000000000004, 40.872),
      radius: Radius.elliptical(9.594, 9.594),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(27.114000000000004, 41.327),
      radius: Radius.elliptical(7.394, 7.394),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(22.519000000000005, 41.62),
      radius: Radius.elliptical(5.937, 5.937),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(20.533000000000005, 40.452999999999996),
      radius: Radius.elliptical(6.069, 6.069),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(19.071000000000005, 38.498),
      radius: Radius.elliptical(6.248, 6.248),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(18.105000000000004, 35.405),
      radius: Radius.elliptical(10.288, 10.288),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(18.232000000000003, 32.399),
      radius: Radius.elliptical(7.843, 7.843),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(19.548000000000002, 29.765),
      radius: Radius.elliptical(6.738, 6.738),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      20.197000000000003,
      28.961000000000002,
      21.067,
      28.294,
      22.158,
      27.762,
    );
    path_3.arcToPoint(
      Offset(23.466, 27.245),
      radius: Radius.elliptical(9.248, 9.248),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      23.933,
      27.098000000000003,
      24.396,
      27.025000000000002,
      24.852,
      27.023,
    );
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffD4B367).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(18.622, 35.483);
    path_4.cubicTo(
      18.442,
      32.82899999999999,
      19.447,
      29.912999999999997,
      21.326999999999998,
      28.727999999999998,
    );
    path_4.cubicTo(
      21.503999999999998,
      28.616,
      21.737,
      28.688,
      21.898999999999997,
      28.820999999999998,
    );
    path_4.cubicTo(
      22.392999999999997,
      29.229,
      23.375999999999998,
      29.570999999999998,
      24.194999999999997,
      29.855999999999998,
    );
    path_4.cubicTo(
      24.476999999999997,
      29.953999999999997,
      24.546999999999997,
      30.317999999999998,
      24.337999999999997,
      30.531,
    );
    path_4.cubicTo(
      22.982999999999997,
      31.907999999999998,
      21.575999999999997,
      34.104,
      21.391999999999996,
      35.836999999999996,
    );
    path_4.cubicTo(
      21.358999999999995,
      36.151999999999994,
      21.011999999999997,
      36.391,
      20.717999999999996,
      36.270999999999994,
    );
    path_4.cubicTo(
      20.150999999999996,
      36.038999999999994,
      19.590999999999998,
      35.88399999999999,
      19.113999999999997,
      35.88099999999999,
    );
    path_4.cubicTo(
      18.874,
      35.88099999999999,
      18.637999999999998,
      35.721999999999994,
      18.621999999999996,
      35.48299999999999,
    );
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.1525932, size.height * 0.4363662),
      Offset(size.width * 0.1866610, size.height * 0.4604085),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(37.228, 13.26);
    path_5.lineTo(60.531000000000006, 13.26);
    path_5.lineTo(60.531000000000006, 37.448);
    path_5.lineTo(37.228, 37.448);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(54.93, 24.02);
    path_6.lineTo(54.196, 24.578);
    path_6.lineTo(56.702, 28.347);
    path_6.lineTo(53.12, 31.467000000000002);
    path_6.lineTo(50.480999999999995, 27.407000000000004);
    path_6.lineTo(46.032999999999994, 30.793000000000003);
    path_6.lineTo(41.88499999999999, 22.448);
    path_6.lineTo(45.084999999999994, 20.122);
    path_6.lineTo(47.919, 25.982);
    path_6.lineTo(49.012, 25.136);
    path_6.lineTo(44.671, 18.483);
    path_6.lineTo(48.346, 15.813);
    path_6.lineTo(52.656, 22.281);
    path_6.lineTo(53.293, 21.767);
    path_6.lineTo(54.929, 24.019);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(54.93, 24.02);
    path_7.lineTo(54.196, 24.578);
    path_7.lineTo(56.702, 28.347);
    path_7.lineTo(53.12, 31.467000000000002);
    path_7.lineTo(50.480999999999995, 27.407000000000004);
    path_7.lineTo(46.032999999999994, 30.793000000000003);
    path_7.lineTo(41.88499999999999, 22.448);
    path_7.lineTo(45.084999999999994, 20.122);
    path_7.lineTo(47.919, 25.982);
    path_7.lineTo(49.012, 25.136);
    path_7.lineTo(44.671, 18.483);
    path_7.lineTo(48.346, 15.813);
    path_7.lineTo(52.656, 22.281);
    path_7.lineTo(53.293, 21.767);
    path_7.lineTo(54.929, 24.019);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffECCA93).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(54.93, 24.02);
    path_8.lineTo(55.587, 24.883);
    path_8.lineTo(56.431000000000004, 24.24);
    path_8.lineTo(55.80800000000001, 23.381);
    path_8.lineTo(54.92900000000001, 24.019000000000002);
    path_8.close();
    path_8.moveTo(54.196, 24.578);
    path_8.lineTo(53.538, 23.714);
    path_8.lineTo(52.727999999999994, 24.331);
    path_8.lineTo(53.291999999999994, 25.179);
    path_8.lineTo(54.196, 24.578);
    path_8.close();
    path_8.moveTo(56.702, 28.347);
    path_8.lineTo(57.415, 29.165000000000003);
    path_8.lineTo(58.134, 28.539);
    path_8.lineTo(57.606, 27.746000000000002);
    path_8.lineTo(56.702, 28.346000000000004);
    path_8.close();
    path_8.moveTo(53.12, 31.467000000000002);
    path_8.lineTo(52.21, 32.058);
    path_8.lineTo(52.891, 33.106);
    path_8.lineTo(53.833, 32.285000000000004);
    path_8.lineTo(53.12, 31.466000000000005);
    path_8.close();
    path_8.moveTo(50.480999999999995, 27.407000000000004);
    path_8.lineTo(51.39099999999999, 26.815000000000005);
    path_8.lineTo(50.75399999999999, 25.834000000000003);
    path_8.lineTo(49.82399999999999, 26.543000000000003);
    path_8.lineTo(50.480999999999995, 27.406000000000002);
    path_8.close();
    path_8.moveTo(46.032999999999994, 30.793000000000003);
    path_8.lineTo(45.06099999999999, 31.277);
    path_8.lineTo(45.645999999999994, 32.453);
    path_8.lineTo(46.690999999999995, 31.657000000000004);
    path_8.lineTo(46.032999999999994, 30.793000000000003);
    path_8.close();
    path_8.moveTo(41.88499999999999, 22.448);
    path_8.lineTo(41.24599999999999, 21.57);
    path_8.lineTo(40.50399999999999, 22.11);
    path_8.lineTo(40.91199999999999, 22.931);
    path_8.lineTo(41.88499999999999, 22.448);
    path_8.close();
    path_8.moveTo(45.084999999999994, 20.122);
    path_8.lineTo(46.062999999999995, 19.649);
    path_8.lineTo(45.498, 18.481);
    path_8.lineTo(44.448, 19.244000000000003);
    path_8.lineTo(45.085, 20.122000000000003);
    path_8.close();
    path_8.moveTo(47.919, 25.982);
    path_8.lineTo(46.942, 26.454);
    path_8.lineTo(47.525, 27.66);
    path_8.lineTo(48.583999999999996, 26.84);
    path_8.lineTo(47.919, 25.982);
    path_8.close();
    path_8.moveTo(49.012, 25.136);
    path_8.lineTo(49.677, 25.994);
    path_8.lineTo(50.469, 25.381);
    path_8.lineTo(49.922000000000004, 24.542);
    path_8.lineTo(49.01200000000001, 25.135);
    path_8.close();
    path_8.moveTo(44.671, 18.483);
    path_8.lineTo(44.032, 17.605);
    path_8.lineTo(43.196999999999996, 18.212);
    path_8.lineTo(43.760999999999996, 19.076);
    path_8.lineTo(44.67099999999999, 18.483);
    path_8.close();
    path_8.moveTo(48.346, 15.813);
    path_8.lineTo(49.248999999999995, 15.211);
    path_8.lineTo(48.62199999999999, 14.27);
    path_8.lineTo(47.70799999999999, 14.934);
    path_8.lineTo(48.34599999999999, 15.812999999999999);
    path_8.close();
    path_8.moveTo(52.656, 22.281);
    path_8.lineTo(51.753, 22.883);
    path_8.lineTo(52.413, 23.872999999999998);
    path_8.lineTo(53.339, 23.124999999999996);
    path_8.lineTo(52.657, 22.280999999999995);
    path_8.close();
    path_8.moveTo(53.293, 21.767);
    path_8.lineTo(54.171, 21.128999999999998);
    path_8.lineTo(53.499, 20.203999999999997);
    path_8.lineTo(52.61, 20.921999999999997);
    path_8.lineTo(53.293, 21.766999999999996);
    path_8.close();
    path_8.moveTo(54.929, 24.019);
    path_8.lineTo(54.271, 23.156);
    path_8.lineTo(53.538000000000004, 23.714);
    path_8.lineTo(54.196000000000005, 24.578);
    path_8.lineTo(54.854000000000006, 25.441);
    path_8.lineTo(55.587, 24.883);
    path_8.lineTo(54.929, 24.019);
    path_8.close();
    path_8.moveTo(54.196000000000005, 24.578);
    path_8.lineTo(53.292, 25.178);
    path_8.lineTo(55.797000000000004, 28.948);
    path_8.lineTo(56.702000000000005, 28.347);
    path_8.lineTo(57.60600000000001, 27.746000000000002);
    path_8.lineTo(55.10000000000001, 23.976000000000003);
    path_8.lineTo(54.196000000000005, 24.578000000000003);
    path_8.close();
    path_8.moveTo(56.702000000000005, 28.347);
    path_8.lineTo(55.989000000000004, 27.528000000000002);
    path_8.lineTo(52.407000000000004, 30.648000000000003);
    path_8.lineTo(53.120000000000005, 31.466000000000005);
    path_8.lineTo(53.833000000000006, 32.285000000000004);
    path_8.lineTo(57.415000000000006, 29.165000000000003);
    path_8.lineTo(56.702000000000005, 28.347);
    path_8.close();
    path_8.moveTo(53.120000000000005, 31.467000000000002);
    path_8.lineTo(54.03, 30.875000000000004);
    path_8.lineTo(51.391, 26.815000000000005);
    path_8.lineTo(50.481, 27.406000000000006);
    path_8.lineTo(49.571000000000005, 27.998000000000005);
    path_8.lineTo(52.21000000000001, 32.05800000000001);
    path_8.lineTo(53.120000000000005, 31.466000000000008);
    path_8.close();
    path_8.moveTo(50.481, 27.407000000000004);
    path_8.lineTo(49.823, 26.543000000000003);
    path_8.lineTo(45.375, 29.930000000000003);
    path_8.lineTo(46.033, 30.793000000000003);
    path_8.lineTo(46.691, 31.657000000000004);
    path_8.lineTo(51.139, 28.270000000000003);
    path_8.lineTo(50.481, 27.406000000000002);
    path_8.close();
    path_8.moveTo(46.033, 30.793000000000003);
    path_8.lineTo(47.005, 30.310000000000002);
    path_8.lineTo(42.857, 21.965000000000003);
    path_8.lineTo(41.885, 22.448000000000004);
    path_8.lineTo(40.912, 22.931000000000004);
    path_8.lineTo(45.061, 31.277000000000005);
    path_8.lineTo(46.033, 30.793000000000006);
    path_8.close();
    path_8.moveTo(41.885000000000005, 22.448);
    path_8.lineTo(42.523, 23.326);
    path_8.lineTo(45.723000000000006, 21.001);
    path_8.lineTo(45.08500000000001, 20.122);
    path_8.lineTo(44.44700000000001, 19.244);
    path_8.lineTo(41.24700000000001, 21.57);
    path_8.lineTo(41.885000000000005, 22.448);
    path_8.close();
    path_8.moveTo(45.08500000000001, 20.122);
    path_8.lineTo(44.10800000000001, 20.595);
    path_8.lineTo(46.942000000000014, 26.455);
    path_8.lineTo(47.91900000000001, 25.982);
    path_8.lineTo(48.89700000000001, 25.509);
    path_8.lineTo(46.06300000000001, 19.649);
    path_8.lineTo(45.08500000000001, 20.122);
    path_8.close();
    path_8.moveTo(47.91900000000001, 25.982);
    path_8.lineTo(48.58400000000001, 26.84);
    path_8.lineTo(49.67700000000001, 25.994);
    path_8.lineTo(49.01200000000001, 25.136);
    path_8.lineTo(48.348000000000006, 24.276);
    path_8.lineTo(47.25500000000001, 25.123);
    path_8.lineTo(47.91900000000001, 25.981);
    path_8.close();
    path_8.moveTo(49.012000000000015, 25.136);
    path_8.lineTo(49.92200000000001, 24.541999999999998);
    path_8.lineTo(45.58000000000001, 17.889999999999997);
    path_8.lineTo(44.670000000000016, 18.482999999999997);
    path_8.lineTo(43.76100000000002, 19.075999999999997);
    path_8.lineTo(48.103000000000016, 25.728999999999996);
    path_8.lineTo(49.01300000000001, 25.135999999999996);
    path_8.close();
    path_8.moveTo(44.671000000000014, 18.483);
    path_8.lineTo(45.30900000000001, 19.361);
    path_8.lineTo(48.98400000000001, 16.691000000000003);
    path_8.lineTo(48.34600000000001, 15.813000000000002);
    path_8.lineTo(47.70800000000001, 14.934000000000003);
    path_8.lineTo(44.03200000000001, 17.604000000000003);
    path_8.lineTo(44.671000000000014, 18.483000000000004);
    path_8.close();
    path_8.moveTo(48.34600000000001, 15.813);
    path_8.lineTo(47.44200000000001, 16.415);
    path_8.lineTo(51.75300000000001, 22.883);
    path_8.lineTo(52.65700000000001, 22.281);
    path_8.lineTo(53.56000000000001, 21.679);
    path_8.lineTo(49.25000000000001, 15.210999999999999);
    path_8.lineTo(48.346000000000004, 15.812999999999999);
    path_8.close();
    path_8.moveTo(52.65600000000001, 22.281);
    path_8.lineTo(53.33900000000001, 23.125);
    path_8.lineTo(53.975000000000016, 22.611);
    path_8.lineTo(53.29300000000001, 21.767);
    path_8.lineTo(52.610000000000014, 20.922);
    path_8.lineTo(51.97400000000001, 21.436);
    path_8.lineTo(52.65700000000001, 22.281);
    path_8.close();
    path_8.moveTo(53.29300000000001, 21.767);
    path_8.lineTo(52.414000000000016, 22.405);
    path_8.lineTo(54.051000000000016, 24.658);
    path_8.lineTo(54.929000000000016, 24.019000000000002);
    path_8.lineTo(55.808000000000014, 23.381);
    path_8.lineTo(54.171000000000014, 21.129);
    path_8.lineTo(53.29300000000001, 21.767000000000003);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(49.725, 8.645);
    path_9.lineTo(68.922, 8.645);
    path_9.lineTo(68.922, 30.376);
    path_9.lineTo(49.725, 30.376);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(62.528, 14.238);
    path_10.arcToPoint(
      Offset(63.128, 22.070999999999998),
      radius: Radius.elliptical(20816.656, 20816.656),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_10.cubicTo(
      63.181,
      22.772999999999996,
      63.228,
      23.416999999999998,
      63.267,
      24.002999999999997,
    );
    path_10.cubicTo(
      63.309000000000005,
      24.578999999999997,
      63.347,
      25.066999999999997,
      63.379000000000005,
      25.464999999999996,
    );
    path_10.cubicTo(
      63.411,
      25.862999999999996,
      63.429,
      26.110999999999997,
      63.435,
      26.207999999999995,
    );
    path_10.lineTo(58.296, 28.151999999999994);
    path_10.lineTo(58.483, 16.679999999999993);
    path_10.lineTo(53.407999999999994, 19.282999999999994);
    path_10.lineTo(51.568999999999996, 15.152999999999995);
    path_10.lineTo(60.979, 10.756999999999994);
    path_10.lineTo(62.528, 14.236999999999995);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(62.528, 14.238);
    path_11.arcToPoint(
      Offset(63.128, 22.070999999999998),
      radius: Radius.elliptical(20816.656, 20816.656),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_11.cubicTo(
      63.181,
      22.772999999999996,
      63.228,
      23.416999999999998,
      63.267,
      24.002999999999997,
    );
    path_11.cubicTo(
      63.309000000000005,
      24.578999999999997,
      63.347,
      25.066999999999997,
      63.379000000000005,
      25.464999999999996,
    );
    path_11.cubicTo(
      63.411,
      25.862999999999996,
      63.429,
      26.110999999999997,
      63.435,
      26.207999999999995,
    );
    path_11.lineTo(58.296, 28.151999999999994);
    path_11.lineTo(58.483, 16.679999999999993);
    path_11.lineTo(53.407999999999994, 19.282999999999994);
    path_11.lineTo(51.568999999999996, 15.152999999999995);
    path_11.lineTo(60.979, 10.756999999999994);
    path_11.lineTo(62.528, 14.236999999999995);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffECCA93).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(62.528, 14.238);
    path_12.lineTo(63.611, 14.155);
    path_12.lineTo(63.596, 13.966999999999999);
    path_12.lineTo(63.519999999999996, 13.796);
    path_12.lineTo(62.528, 14.238);
    path_12.close();
    path_12.moveTo(62.961999999999996, 19.922);
    path_12.lineTo(64.045, 19.84);
    path_12.lineTo(62.962, 19.922);
    path_12.close();
    path_12.moveTo(63.12799999999999, 22.071);
    path_12.lineTo(64.211, 21.989);
    path_12.lineTo(64.211, 21.986);
    path_12.lineTo(63.128, 22.071);
    path_12.close();
    path_12.moveTo(63.266999999999996, 24.003);
    path_12.lineTo(62.18299999999999, 24.076);
    path_12.lineTo(62.18299999999999, 24.083000000000002);
    path_12.lineTo(63.266999999999996, 24.003000000000004);
    path_12.close();
    path_12.moveTo(63.434999999999995, 26.208);
    path_12.lineTo(63.818999999999996, 27.223);
    path_12.lineTo(64.56, 26.942999999999998);
    path_12.lineTo(64.52, 26.151999999999997);
    path_12.lineTo(63.434999999999995, 26.208);
    path_12.close();
    path_12.moveTo(58.29599999999999, 28.151999999999997);
    path_12.lineTo(57.21099999999999, 28.133999999999997);
    path_12.lineTo(57.18499999999999, 29.733999999999998);
    path_12.lineTo(58.68099999999999, 29.166999999999998);
    path_12.lineTo(58.29699999999999, 28.151999999999997);
    path_12.close();
    path_12.moveTo(58.48299999999999, 16.68);
    path_12.lineTo(59.56799999999999, 16.698);
    path_12.lineTo(59.59799999999999, 14.888);
    path_12.lineTo(57.986999999999995, 15.714);
    path_12.lineTo(58.48199999999999, 16.68);
    path_12.close();
    path_12.moveTo(53.40799999999999, 19.283);
    path_12.lineTo(52.41599999999999, 19.725);
    path_12.lineTo(52.88299999999999, 20.773000000000003);
    path_12.lineTo(53.90299999999999, 20.249000000000002);
    path_12.lineTo(53.407999999999994, 19.283);
    path_12.close();
    path_12.moveTo(51.56899999999999, 15.153000000000002);
    path_12.lineTo(51.10899999999999, 14.168000000000003);
    path_12.lineTo(50.143999999999984, 14.620000000000003);
    path_12.lineTo(50.576999999999984, 15.594000000000003);
    path_12.lineTo(51.56899999999998, 15.152000000000003);
    path_12.close();
    path_12.moveTo(60.978999999999985, 10.757000000000001);
    path_12.lineTo(61.969999999999985, 10.315000000000001);
    path_12.lineTo(61.51999999999998, 9.305000000000001);
    path_12.lineTo(60.518999999999984, 9.773000000000001);
    path_12.lineTo(60.978999999999985, 10.757000000000001);
    path_12.close();
    path_12.moveTo(62.527999999999984, 14.237000000000002);
    path_12.lineTo(61.444999999999986, 14.320000000000002);
    path_12.lineTo(61.878999999999984, 20.005000000000003);
    path_12.lineTo(62.96199999999998, 19.922000000000004);
    path_12.lineTo(64.04499999999999, 19.839000000000006);
    path_12.lineTo(63.61099999999999, 14.155000000000005);
    path_12.lineTo(62.52799999999999, 14.238000000000005);
    path_12.close();
    path_12.moveTo(62.96199999999998, 19.922);
    path_12.lineTo(61.878999999999984, 20.004);
    path_12.lineTo(62.045999999999985, 22.156000000000002);
    path_12.lineTo(63.127999999999986, 22.071);
    path_12.lineTo(64.21099999999998, 21.986);
    path_12.cubicTo(
      64.15499999999999,
      21.278000000000002,
      64.09999999999998,
      20.563000000000002,
      64.04499999999999,
      19.84,
    );
    path_12.lineTo(62.96199999999999, 19.922);
    path_12.close();
    path_12.moveTo(63.12799999999998, 22.071);
    path_12.lineTo(62.04499999999998, 22.152);
    path_12.cubicTo(
      62.09799999999998,
      22.852,
      62.14499999999998,
      23.493000000000002,
      62.18299999999998,
      24.076,
    );
    path_12.lineTo(63.26699999999998, 24.003);
    path_12.lineTo(64.34999999999998, 23.93);
    path_12.cubicTo(
      64.30999999999997,
      23.34,
      64.26399999999998,
      22.694,
      64.20999999999998,
      21.99,
    );
    path_12.lineTo(63.12799999999998, 22.069999999999997);
    path_12.close();
    path_12.moveTo(63.26699999999998, 24.003);
    path_12.lineTo(62.18399999999998, 24.083);
    path_12.cubicTo(
      62.22699999999998,
      24.660999999999998,
      62.26399999999998,
      25.151,
      62.29699999999998,
      25.552999999999997,
    );
    path_12.lineTo(63.378999999999984, 25.464999999999996);
    path_12.lineTo(64.46099999999998, 25.377999999999997);
    path_12.cubicTo(
      64.42899999999999,
      24.982999999999997,
      64.39199999999998,
      24.497999999999998,
      64.34899999999999,
      23.921999999999997,
    );
    path_12.lineTo(63.26599999999999, 24.001999999999995);
    path_12.close();
    path_12.moveTo(63.378999999999984, 25.465);
    path_12.lineTo(62.29699999999998, 25.552);
    path_12.cubicTo(
      62.329999999999984,
      25.957,
      62.34699999999998,
      26.186,
      62.34999999999998,
      26.264,
    );
    path_12.lineTo(63.43499999999998, 26.208);
    path_12.lineTo(64.51899999999998, 26.151999999999997);
    path_12.arcToPoint(
      Offset(64.46099999999997, 25.377999999999997),
      radius: Radius.elliptical(37.296, 37.296),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_12.lineTo(63.37899999999997, 25.464999999999996);
    path_12.close();
    path_12.moveTo(63.43499999999998, 26.208);
    path_12.lineTo(63.05099999999998, 25.192);
    path_12.lineTo(57.91199999999998, 27.136);
    path_12.lineTo(58.296999999999976, 28.152);
    path_12.lineTo(58.680999999999976, 29.167);
    path_12.lineTo(63.818999999999974, 27.223000000000003);
    path_12.lineTo(63.434999999999974, 26.208000000000002);
    path_12.close();
    path_12.moveTo(58.29599999999998, 28.151999999999997);
    path_12.lineTo(59.38199999999998, 28.168999999999997);
    path_12.lineTo(59.56799999999998, 16.697999999999997);
    path_12.lineTo(58.482999999999976, 16.679999999999996);
    path_12.lineTo(57.39699999999998, 16.662999999999997);
    path_12.lineTo(57.21099999999998, 28.133999999999997);
    path_12.lineTo(58.296999999999976, 28.151999999999997);
    path_12.close();
    path_12.moveTo(58.482999999999976, 16.68);
    path_12.lineTo(57.98699999999997, 15.714);
    path_12.lineTo(52.912999999999975, 18.317);
    path_12.lineTo(53.40799999999997, 19.283);
    path_12.lineTo(53.903999999999975, 20.249000000000002);
    path_12.lineTo(58.97799999999997, 17.646);
    path_12.lineTo(58.482999999999976, 16.68);
    path_12.close();
    path_12.moveTo(53.40799999999997, 19.283);
    path_12.lineTo(54.39999999999997, 18.841);
    path_12.lineTo(52.56099999999997, 14.711000000000002);
    path_12.lineTo(51.568999999999974, 15.152000000000003);
    path_12.lineTo(50.57699999999998, 15.594000000000003);
    path_12.lineTo(52.41699999999998, 19.724000000000004);
    path_12.lineTo(53.40799999999998, 19.284000000000002);
    path_12.close();
    path_12.moveTo(51.568999999999974, 15.153000000000002);
    path_12.lineTo(52.028999999999975, 16.136000000000003);
    path_12.lineTo(61.437999999999974, 11.741000000000003);
    path_12.lineTo(60.97799999999997, 10.757000000000003);
    path_12.lineTo(60.51799999999997, 9.773000000000003);
    path_12.lineTo(51.10999999999997, 14.169000000000004);
    path_12.lineTo(51.56999999999997, 15.152000000000005);
    path_12.close();
    path_12.moveTo(60.97899999999997, 10.757000000000001);
    path_12.lineTo(59.98599999999997, 11.198000000000002);
    path_12.lineTo(61.535999999999966, 14.679000000000002);
    path_12.lineTo(62.52799999999996, 14.238000000000001);
    path_12.lineTo(63.51999999999996, 13.796000000000001);
    path_12.lineTo(61.96999999999996, 10.316);
    path_12.lineTo(60.977999999999966, 10.756);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(60.231, 7.388);
    path_13.lineTo(77.875, 7.388);
    path_13.lineTo(77.875, 28.884);
    path_13.lineTo(60.231, 28.884);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(74.56, 19.24);
    path_14.cubicTo(
      74.75,
      20.125999999999998,
      74.753,
      20.932,
      74.571,
      21.654999999999998,
    );
    path_14.arcToPoint(
      Offset(73.627, 23.557),
      radius: Radius.elliptical(4.63, 4.63),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.arcToPoint(
      Offset(71.907, 24.929),
      radius: Radius.elliptical(5.67, 5.67),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.arcToPoint(
      Offset(69.61, 25.749),
      radius: Radius.elliptical(8.729, 8.729),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.arcToPoint(
      Offset(68.405, 25.919),
      radius: Radius.elliptical(8.726, 8.726),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.cubicTo(68.002, 25.941, 67.6, 25.944, 67.19800000000001, 25.93);
    path_14.arcToPoint(
      Offset(65.998, 25.820999999999998),
      radius: Radius.elliptical(18.154, 18.154),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.arcToPoint(
      Offset(64.792, 25.639),
      radius: Radius.elliptical(28.954, 28.954),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.lineTo(64.315, 21.480999999999998);
    path_14.arcToPoint(
      Offset(67.04899999999999, 21.808999999999997),
      radius: Radius.elliptical(7.851, 7.851),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.cubicTo(
      67.36699999999999,
      21.791999999999998,
      67.669,
      21.752999999999997,
      67.955,
      21.691999999999997,
    );
    path_14.cubicTo(
      68.126,
      21.655999999999995,
      68.331,
      21.597999999999995,
      68.571,
      21.517999999999997,
    );
    path_14.arcToPoint(
      Offset(69.241, 21.193999999999996),
      radius: Radius.elliptical(3.52, 3.52),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(69.741, 20.723999999999997),
      radius: Radius.elliptical(1.88, 1.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(69.861, 20.087999999999997),
      radius: Radius.elliptical(0.772, 0.772),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(69.543, 19.545999999999996),
      radius: Radius.elliptical(0.932, 0.932),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(68.96700000000001, 19.250999999999994),
      radius: Radius.elliptical(1.393, 1.393),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(68.23700000000001, 19.138999999999996),
      radius: Radius.elliptical(2.787, 2.787),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(67.438, 19.158999999999995),
      radius: Radius.elliptical(7.422, 7.422),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.cubicTo(
      67.178,
      19.178999999999995,
      66.932,
      19.208999999999996,
      66.69800000000001,
      19.251999999999995,
    );
    path_14.arcToPoint(
      Offset(66.13300000000001, 19.361999999999995),
      radius: Radius.elliptical(19.49, 19.49),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(65.2, 19.601999999999993),
      radius: Radius.elliptical(11.04, 11.04),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.arcToPoint(
      Offset(64.313, 19.961999999999993),
      radius: Radius.elliptical(5.337, 5.337),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_14.lineTo(62.964000000000006, 11.601999999999993);
    path_14.lineTo(71.21000000000001, 9.613999999999994);
    path_14.lineTo(72.34500000000001, 13.845999999999993);
    path_14.lineTo(67.14400000000002, 14.651999999999994);
    path_14.lineTo(67.42900000000002, 16.495999999999995);
    path_14.cubicTo(
      67.72000000000001,
      16.355999999999995,
      68.01600000000002,
      16.235999999999994,
      68.31600000000002,
      16.135999999999996,
    );
    path_14.cubicTo(
      68.61400000000002,
      16.029999999999994,
      68.91600000000001,
      15.943999999999996,
      69.22400000000002,
      15.878999999999996,
    );
    path_14.arcToPoint(
      Offset(71.01900000000002, 15.818999999999996),
      radius: Radius.elliptical(4.887, 4.887),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.arcToPoint(
      Offset(72.60500000000002, 16.379999999999995),
      radius: Radius.elliptical(4.12, 4.12),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_14.cubicTo(
      73.08800000000002,
      16.669999999999995,
      73.49800000000002,
      17.056999999999995,
      73.83600000000001,
      17.541999999999994,
    );
    path_14.cubicTo(
      74.18,
      18.017999999999994,
      74.42200000000001,
      18.583999999999996,
      74.561,
      19.238999999999994,
    );
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(74.56, 19.24);
    path_15.cubicTo(
      74.75,
      20.125999999999998,
      74.753,
      20.932,
      74.571,
      21.654999999999998,
    );
    path_15.arcToPoint(
      Offset(73.627, 23.557),
      radius: Radius.elliptical(4.63, 4.63),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(71.907, 24.929),
      radius: Radius.elliptical(5.67, 5.67),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(69.61, 25.749),
      radius: Radius.elliptical(8.729, 8.729),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(68.405, 25.919),
      radius: Radius.elliptical(8.726, 8.726),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.cubicTo(68.002, 25.941, 67.6, 25.944, 67.19800000000001, 25.93);
    path_15.arcToPoint(
      Offset(65.998, 25.820999999999998),
      radius: Radius.elliptical(18.154, 18.154),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(64.792, 25.639),
      radius: Radius.elliptical(28.954, 28.954),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.lineTo(64.315, 21.480999999999998);
    path_15.arcToPoint(
      Offset(67.04899999999999, 21.808999999999997),
      radius: Radius.elliptical(7.851, 7.851),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.cubicTo(
      67.36699999999999,
      21.791999999999998,
      67.669,
      21.752999999999997,
      67.955,
      21.691999999999997,
    );
    path_15.cubicTo(
      68.126,
      21.655999999999995,
      68.331,
      21.597999999999995,
      68.571,
      21.517999999999997,
    );
    path_15.arcToPoint(
      Offset(69.241, 21.193999999999996),
      radius: Radius.elliptical(3.52, 3.52),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(69.741, 20.723999999999997),
      radius: Radius.elliptical(1.88, 1.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(69.861, 20.087999999999997),
      radius: Radius.elliptical(0.772, 0.772),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(69.543, 19.545999999999996),
      radius: Radius.elliptical(0.932, 0.932),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(68.96700000000001, 19.250999999999994),
      radius: Radius.elliptical(1.393, 1.393),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(68.23700000000001, 19.138999999999996),
      radius: Radius.elliptical(2.787, 2.787),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(67.438, 19.158999999999995),
      radius: Radius.elliptical(7.422, 7.422),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.cubicTo(
      67.178,
      19.178999999999995,
      66.932,
      19.208999999999996,
      66.69800000000001,
      19.251999999999995,
    );
    path_15.arcToPoint(
      Offset(66.13300000000001, 19.361999999999995),
      radius: Radius.elliptical(19.49, 19.49),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(65.2, 19.601999999999993),
      radius: Radius.elliptical(11.04, 11.04),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.arcToPoint(
      Offset(64.313, 19.961999999999993),
      radius: Radius.elliptical(5.337, 5.337),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.lineTo(62.964000000000006, 11.601999999999993);
    path_15.lineTo(71.21000000000001, 9.613999999999994);
    path_15.lineTo(72.34500000000001, 13.845999999999993);
    path_15.lineTo(67.14400000000002, 14.651999999999994);
    path_15.lineTo(67.42900000000002, 16.495999999999995);
    path_15.cubicTo(
      67.72000000000001,
      16.355999999999995,
      68.01600000000002,
      16.235999999999994,
      68.31600000000002,
      16.135999999999996,
    );
    path_15.cubicTo(
      68.61400000000002,
      16.029999999999994,
      68.91600000000001,
      15.943999999999996,
      69.22400000000002,
      15.878999999999996,
    );
    path_15.arcToPoint(
      Offset(71.01900000000002, 15.818999999999996),
      radius: Radius.elliptical(4.887, 4.887),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(72.60500000000002, 16.379999999999995),
      radius: Radius.elliptical(4.12, 4.12),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.cubicTo(
      73.08800000000002,
      16.669999999999995,
      73.49800000000002,
      17.056999999999995,
      73.83600000000001,
      17.541999999999994,
    );
    path_15.cubicTo(
      74.18,
      18.017999999999994,
      74.42200000000001,
      18.583999999999996,
      74.561,
      19.238999999999994,
    );
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffECCA93).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(74.572, 21.655);
    path_16.lineTo(73.518, 21.391000000000002);
    path_16.lineTo(73.516, 21.400000000000002);
    path_16.lineTo(74.57100000000001, 21.655);
    path_16.close();
    path_16.moveTo(68.405, 25.919);
    path_16.lineTo(68.462, 27.004);
    path_16.lineTo(68.47200000000001, 27.004);
    path_16.lineTo(68.48100000000001, 27.003);
    path_16.lineTo(68.40500000000002, 25.919);
    path_16.close();
    path_16.moveTo(67.19800000000001, 25.93);
    path_16.lineTo(67.13600000000001, 27.014);
    path_16.lineTo(67.147, 27.014);
    path_16.lineTo(67.159, 27.015);
    path_16.lineTo(67.19800000000001, 25.93);
    path_16.close();
    path_16.moveTo(65.998, 25.820999999999998);
    path_16.lineTo(65.858, 26.897999999999996);
    path_16.lineTo(65.864, 26.897999999999996);
    path_16.lineTo(65.997, 25.820999999999998);
    path_16.close();
    path_16.moveTo(64.792, 25.639);
    path_16.lineTo(63.714, 25.762);
    path_16.lineTo(63.806, 26.57);
    path_16.lineTo(64.607, 26.709);
    path_16.lineTo(64.792, 25.639);
    path_16.close();
    path_16.moveTo(64.315, 21.480999999999998);
    path_16.lineTo(64.634, 20.442999999999998);
    path_16.lineTo(63.047, 19.956);
    path_16.lineTo(63.236999999999995, 21.605);
    path_16.lineTo(64.315, 21.481);
    path_16.close();
    path_16.moveTo(66.107, 21.805999999999997);
    path_16.lineTo(66.039, 22.889999999999997);
    path_16.lineTo(66.046, 22.889999999999997);
    path_16.lineTo(66.10700000000001, 21.805999999999997);
    path_16.close();
    path_16.moveTo(67.04899999999999, 21.808999999999997);
    path_16.lineTo(67.106, 22.894);
    path_16.lineTo(67.109, 22.894);
    path_16.lineTo(67.04899999999999, 21.81);
    path_16.close();
    path_16.moveTo(68.571, 21.519);
    path_16.lineTo(68.913, 22.549);
    path_16.lineTo(68.92699999999999, 22.544);
    path_16.lineTo(68.94099999999999, 22.539);
    path_16.lineTo(68.57099999999998, 21.519000000000002);
    path_16.close();
    path_16.moveTo(69.241, 21.194);
    path_16.lineTo(69.816, 22.114);
    path_16.lineTo(69.828, 22.107);
    path_16.lineTo(69.84, 22.099);
    path_16.lineTo(69.24000000000001, 21.194);
    path_16.close();
    path_16.moveTo(69.741, 20.724);
    path_16.lineTo(70.623, 21.356);
    path_16.lineTo(70.62400000000001, 21.354000000000003);
    path_16.lineTo(69.74000000000001, 20.724000000000004);
    path_16.close();
    path_16.moveTo(69.543, 19.546);
    path_16.lineTo(68.82900000000001, 20.364);
    path_16.lineTo(68.83900000000001, 20.373);
    path_16.lineTo(68.85100000000001, 20.383000000000003);
    path_16.lineTo(69.543, 19.546000000000003);
    path_16.close();
    path_16.moveTo(68.96700000000001, 19.250999999999998);
    path_16.lineTo(68.65100000000001, 20.29);
    path_16.lineTo(68.67300000000002, 20.296);
    path_16.lineTo(68.69300000000001, 20.302);
    path_16.lineTo(68.96700000000001, 19.252);
    path_16.close();
    path_16.moveTo(67.43800000000002, 19.159);
    path_16.lineTo(67.52000000000001, 20.241);
    path_16.lineTo(67.52400000000002, 20.241);
    path_16.lineTo(67.43800000000002, 19.159);
    path_16.close();
    path_16.moveTo(66.69800000000002, 19.252);
    path_16.lineTo(66.89200000000002, 20.32);
    path_16.lineTo(66.69800000000002, 19.252);
    path_16.close();
    path_16.moveTo(65.20000000000002, 19.602);
    path_16.lineTo(64.88500000000002, 18.563);
    path_16.lineTo(64.88300000000002, 18.563);
    path_16.lineTo(65.20000000000002, 19.602999999999998);
    path_16.close();
    path_16.moveTo(64.31300000000002, 19.962);
    path_16.lineTo(63.241000000000014, 20.134999999999998);
    path_16.lineTo(63.48000000000001, 21.613);
    path_16.lineTo(64.81000000000002, 20.927);
    path_16.lineTo(64.31300000000002, 19.962);
    path_16.close();
    path_16.moveTo(62.96400000000002, 11.602);
    path_16.lineTo(62.71000000000002, 10.547);
    path_16.lineTo(61.73200000000002, 10.783000000000001);
    path_16.lineTo(61.89200000000002, 11.775000000000002);
    path_16.lineTo(62.96400000000002, 11.602000000000002);
    path_16.close();
    path_16.moveTo(71.21000000000002, 9.614);
    path_16.lineTo(72.25800000000002, 9.334000000000001);
    path_16.lineTo(71.98400000000002, 8.311000000000002);
    path_16.lineTo(70.95500000000003, 8.559000000000001);
    path_16.lineTo(71.21000000000002, 9.614);
    path_16.close();
    path_16.moveTo(72.34500000000003, 13.846);
    path_16.lineTo(72.51100000000002, 14.919);
    path_16.lineTo(73.70700000000002, 14.734);
    path_16.lineTo(73.39300000000003, 13.564);
    path_16.lineTo(72.34400000000002, 13.846);
    path_16.close();
    path_16.moveTo(67.14400000000003, 14.652000000000001);
    path_16.lineTo(66.97800000000004, 13.579);
    path_16.lineTo(65.90500000000004, 13.745000000000001);
    path_16.lineTo(66.07100000000004, 14.818000000000001);
    path_16.lineTo(67.14400000000003, 14.652000000000001);
    path_16.close();
    path_16.moveTo(67.42900000000003, 16.496000000000002);
    path_16.lineTo(66.35600000000004, 16.662000000000003);
    path_16.lineTo(66.58000000000004, 18.111000000000004);
    path_16.lineTo(67.90000000000003, 17.474000000000004);
    path_16.lineTo(67.42900000000003, 16.496000000000002);
    path_16.close();
    path_16.moveTo(68.31600000000003, 16.136000000000003);
    path_16.lineTo(68.65700000000002, 17.167);
    path_16.lineTo(68.66800000000002, 17.163);
    path_16.lineTo(68.68000000000002, 17.159);
    path_16.lineTo(68.31600000000002, 16.136);
    path_16.close();
    path_16.moveTo(71.01900000000003, 15.819000000000003);
    path_16.lineTo(70.84900000000003, 16.891000000000002);
    path_16.lineTo(70.85700000000003, 16.892000000000003);
    path_16.lineTo(70.86500000000002, 16.893000000000004);
    path_16.lineTo(71.01900000000002, 15.818000000000005);
    path_16.close();
    path_16.moveTo(72.60500000000003, 16.380000000000003);
    path_16.lineTo(72.03800000000004, 17.306);
    path_16.lineTo(72.04600000000003, 17.311);
    path_16.lineTo(72.60500000000003, 16.381);
    path_16.close();
    path_16.moveTo(73.83600000000003, 17.542);
    path_16.lineTo(72.94600000000003, 18.164);
    path_16.lineTo(72.95100000000002, 18.17);
    path_16.lineTo(72.95600000000002, 18.177000000000003);
    path_16.lineTo(73.83600000000001, 17.542);
    path_16.close();
    path_16.moveTo(74.56100000000002, 19.239);
    path_16.lineTo(73.49900000000002, 19.465);
    path_16.cubicTo(
      73.66000000000003,
      20.225,
      73.65200000000003,
      20.858999999999998,
      73.51900000000002,
      21.391,
    );
    path_16.lineTo(74.57100000000003, 21.654999999999998);
    path_16.lineTo(75.62500000000003, 21.918999999999997);
    path_16.cubicTo(
      75.85500000000003,
      21.004999999999995,
      75.83900000000003,
      20.028999999999996,
      75.62300000000003,
      19.012999999999998,
    );
    path_16.lineTo(74.56100000000004, 19.238999999999997);
    path_16.close();
    path_16.moveTo(74.57100000000003, 21.655);
    path_16.lineTo(73.51600000000002, 21.400000000000002);
    path_16.arcToPoint(
      Offset(72.79300000000002, 22.863000000000003),
      radius: Radius.elliptical(3.546, 3.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(73.62700000000002, 23.557000000000002);
    path_16.lineTo(74.46200000000002, 24.252000000000002);
    path_16.arcToPoint(
      Offset(75.62700000000002, 21.911),
      radius: Radius.elliptical(5.715, 5.715),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(74.57200000000002, 21.655);
    path_16.close();
    path_16.moveTo(73.62700000000002, 23.557000000000002);
    path_16.lineTo(72.79300000000002, 22.863000000000003);
    path_16.arcToPoint(
      Offset(71.39700000000002, 23.970000000000002),
      radius: Radius.elliptical(4.588, 4.588),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(71.90700000000002, 24.929000000000002);
    path_16.lineTo(72.41700000000003, 25.887);
    path_16.arcToPoint(
      Offset(74.46200000000003, 24.252),
      radius: Radius.elliptical(6.754, 6.754),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(73.62700000000004, 23.557);
    path_16.close();
    path_16.moveTo(71.90700000000002, 24.929000000000002);
    path_16.lineTo(71.39700000000002, 23.970000000000002);
    path_16.arcToPoint(
      Offset(69.38400000000001, 24.687),
      radius: Radius.elliptical(7.645, 7.645),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(69.61000000000001, 25.749000000000002);
    path_16.lineTo(69.83500000000001, 26.811000000000003);
    path_16.arcToPoint(
      Offset(72.417, 25.887000000000004),
      radius: Radius.elliptical(9.808, 9.808),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(71.907, 24.929000000000006);
    path_16.close();
    path_16.moveTo(69.61000000000003, 25.749000000000002);
    path_16.lineTo(69.38400000000003, 24.687);
    path_16.arcToPoint(
      Offset(68.32900000000002, 24.837),
      radius: Radius.elliptical(7.639, 7.639),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(68.40500000000002, 25.919);
    path_16.lineTo(68.48100000000001, 27.003);
    path_16.arcToPoint(
      Offset(69.83500000000001, 26.811),
      radius: Radius.elliptical(9.812, 9.812),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(69.61000000000001, 25.749);
    path_16.close();
    path_16.moveTo(68.40500000000003, 25.919000000000004);
    path_16.lineTo(68.34700000000002, 24.835000000000004);
    path_16.cubicTo(
      67.97700000000002,
      24.855000000000004,
      67.60700000000003,
      24.858000000000004,
      67.23700000000002,
      24.845000000000006,
    );
    path_16.lineTo(67.19700000000002, 25.930000000000007);
    path_16.lineTo(67.15900000000002, 27.015000000000008);
    path_16.cubicTo(
      67.59400000000002,
      27.03000000000001,
      68.02800000000002,
      27.027000000000008,
      68.46200000000002,
      27.00400000000001,
    );
    path_16.lineTo(68.40500000000002, 25.919000000000008);
    path_16.close();
    path_16.moveTo(67.19800000000004, 25.930000000000003);
    path_16.lineTo(67.25900000000004, 24.846000000000004);
    path_16.arcToPoint(
      Offset(66.13100000000004, 24.744000000000003),
      radius: Radius.elliptical(17.072, 17.072),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(65.99800000000005, 25.821000000000005);
    path_16.lineTo(65.86400000000005, 26.899000000000004);
    path_16.cubicTo(
      66.29000000000005,
      26.951000000000004,
      66.71400000000004,
      26.990000000000006,
      67.13600000000005,
      27.014000000000003,
    );
    path_16.lineTo(67.19800000000005, 25.930000000000003);
    path_16.close();
    path_16.moveTo(65.99800000000003, 25.821);
    path_16.lineTo(66.13700000000003, 24.744);
    path_16.arcToPoint(
      Offset(64.97700000000003, 24.569),
      radius: Radius.elliptical(27.89, 27.89),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(64.79200000000003, 25.639);
    path_16.lineTo(64.60700000000003, 26.709);
    path_16.cubicTo(
      65.02900000000002,
      26.781,
      65.44700000000003,
      26.845,
      65.85700000000003,
      26.898,
    );
    path_16.lineTo(65.99700000000003, 25.820999999999998);
    path_16.close();
    path_16.moveTo(64.79200000000003, 25.639000000000003);
    path_16.lineTo(65.87100000000002, 25.515000000000004);
    path_16.lineTo(65.39400000000002, 21.357000000000003);
    path_16.lineTo(64.31500000000003, 21.481);
    path_16.lineTo(63.23700000000002, 21.605);
    path_16.lineTo(63.71400000000002, 25.762);
    path_16.lineTo(64.79200000000002, 25.639);
    path_16.close();
    path_16.moveTo(64.31500000000003, 21.481);
    path_16.lineTo(63.99700000000003, 22.519000000000002);
    path_16.cubicTo(
      64.31400000000002,
      22.616000000000003,
      64.64400000000003,
      22.696,
      64.98600000000003,
      22.759,
    );
    path_16.lineTo(65.18400000000003, 21.692);
    path_16.lineTo(65.38200000000002, 20.625);
    path_16.arcToPoint(
      Offset(64.63400000000001, 20.443),
      radius: Radius.elliptical(6.765, 6.765),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(64.31500000000001, 21.481);
    path_16.close();
    path_16.moveTo(65.18400000000003, 21.692);
    path_16.lineTo(64.98600000000003, 22.76);
    path_16.cubicTo(
      65.33400000000003,
      22.824,
      65.68500000000003,
      22.868000000000002,
      66.03900000000003,
      22.89,
    );
    path_16.lineTo(66.10700000000003, 21.806);
    path_16.lineTo(66.17500000000003, 20.723000000000003);
    path_16.arcToPoint(
      Offset(65.38200000000002, 20.625000000000004),
      radius: Radius.elliptical(6.607, 6.607),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(65.18400000000003, 21.692000000000004);
    path_16.close();
    path_16.moveTo(66.10700000000003, 21.806);
    path_16.lineTo(66.04600000000002, 22.89);
    path_16.cubicTo(
      66.40100000000002,
      22.91,
      66.75500000000002,
      22.912,
      67.10600000000002,
      22.894000000000002,
    );
    path_16.lineTo(67.05000000000003, 21.810000000000002);
    path_16.lineTo(66.99300000000002, 20.725);
    path_16.cubicTo(
      66.72300000000003,
      20.739,
      66.44800000000002,
      20.738000000000003,
      66.16900000000003,
      20.722,
    );
    path_16.lineTo(66.10700000000003, 21.806);
    path_16.close();
    path_16.moveTo(67.04900000000002, 21.809);
    path_16.lineTo(67.10900000000002, 22.894000000000002);
    path_16.cubicTo(
      67.47800000000002,
      22.874000000000002,
      67.83600000000003,
      22.827,
      68.18100000000003,
      22.754,
    );
    path_16.lineTo(67.95600000000003, 21.692);
    path_16.lineTo(67.73000000000003, 20.63);
    path_16.arcToPoint(
      Offset(66.99000000000004, 20.724999999999998),
      radius: Radius.elliptical(4.84, 4.84),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(67.05000000000004, 21.808999999999997);
    path_16.close();
    path_16.moveTo(67.95500000000003, 21.692);
    path_16.lineTo(68.18100000000003, 22.754);
    path_16.cubicTo(
      68.40400000000002,
      22.706000000000003,
      68.65100000000002,
      22.636000000000003,
      68.91300000000003,
      22.549000000000003,
    );
    path_16.lineTo(68.57100000000003, 21.519000000000002);
    path_16.lineTo(68.23000000000003, 20.488000000000003);
    path_16.arcToPoint(
      Offset(67.73000000000003, 20.630000000000003),
      radius: Radius.elliptical(4.87, 4.87),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(67.95500000000003, 21.692000000000004);
    path_16.close();
    path_16.moveTo(68.57100000000003, 21.518);
    path_16.lineTo(68.94100000000003, 22.539);
    path_16.cubicTo(
      69.24900000000004,
      22.428,
      69.54100000000003,
      22.286,
      69.81600000000003,
      22.115000000000002,
    );
    path_16.lineTo(69.24100000000003, 21.194000000000003);
    path_16.lineTo(68.66600000000003, 20.273000000000003);
    path_16.arcToPoint(
      Offset(68.20200000000003, 20.497000000000003),
      radius: Radius.elliptical(2.431, 2.431),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(68.57200000000003, 21.518000000000004);
    path_16.close();
    path_16.moveTo(69.24100000000003, 21.194);
    path_16.lineTo(69.84000000000003, 22.099);
    path_16.cubicTo(
      70.14200000000004,
      21.899,
      70.41000000000003,
      21.654,
      70.62300000000003,
      21.356,
    );
    path_16.lineTo(69.74000000000004, 20.724);
    path_16.lineTo(68.85700000000004, 20.092);
    path_16.arcToPoint(
      Offset(68.64100000000005, 20.288999999999998),
      radius: Radius.elliptical(0.803, 0.803),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(69.24100000000004, 21.194);
    path_16.close();
    path_16.moveTo(69.74100000000003, 20.724);
    path_16.lineTo(70.62400000000002, 21.354);
    path_16.cubicTo(
      70.94700000000002,
      20.901,
      71.03300000000003,
      20.374,
      70.92400000000002,
      19.862,
    );
    path_16.lineTo(69.86200000000002, 20.087999999999997);
    path_16.lineTo(68.80000000000003, 20.313999999999997);
    path_16.arcToPoint(
      Offset(68.85600000000002, 20.093999999999998),
      radius: Radius.elliptical(0.335, 0.335),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(69.74000000000002, 20.723999999999997);
    path_16.close();
    path_16.moveTo(69.86100000000003, 20.088);
    path_16.lineTo(70.92400000000004, 19.862000000000002);
    path_16.arcToPoint(
      Offset(70.23600000000003, 18.71),
      radius: Radius.elliptical(2.017, 2.017),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(69.54300000000003, 19.546);
    path_16.lineTo(68.85100000000004, 20.381999999999998);
    path_16.arcToPoint(
      Offset(68.81100000000004, 20.334),
      radius: Radius.elliptical(0.19, 0.19),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.cubicTo(
      68.79800000000003,
      20.314,
      68.79800000000003,
      20.304,
      68.80000000000004,
      20.314,
    );
    path_16.lineTo(69.86200000000004, 20.088);
    path_16.close();
    path_16.moveTo(69.54300000000003, 19.546);
    path_16.lineTo(70.25700000000003, 18.727999999999998);
    path_16.arcToPoint(
      Offset(69.24000000000004, 18.2),
      radius: Radius.elliptical(2.478, 2.478),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(68.96700000000004, 19.250999999999998);
    path_16.lineTo(68.69400000000005, 20.301);
    path_16.arcToPoint(
      Offset(68.82900000000005, 20.363999999999997),
      radius: Radius.elliptical(0.318, 0.318),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_16.lineTo(69.54300000000005, 19.545999999999996);
    path_16.close();
    path_16.moveTo(68.96700000000004, 19.250999999999998);
    path_16.lineTo(69.28200000000004, 18.211999999999996);
    path_16.arcToPoint(
      Offset(68.26800000000004, 18.052999999999997),
      radius: Radius.elliptical(3.869, 3.869),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(68.23700000000004, 19.138999999999996);
    path_16.lineTo(68.20500000000004, 20.223999999999997);
    path_16.cubicTo(
      68.38800000000005,
      20.228999999999996,
      68.53500000000004,
      20.253999999999998,
      68.65200000000004,
      20.289999999999996,
    );
    path_16.lineTo(68.96700000000004, 19.250999999999994);
    path_16.close();
    path_16.moveTo(68.23700000000004, 19.139);
    path_16.lineTo(68.26800000000004, 18.054);
    path_16.arcToPoint(
      Offset(67.35300000000004, 18.075999999999997),
      radius: Radius.elliptical(8.505, 8.505),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(67.43800000000003, 19.158999999999995);
    path_16.lineTo(67.52400000000003, 20.240999999999996);
    path_16.cubicTo(
      67.75200000000002,
      20.222999999999995,
      67.97900000000003,
      20.216999999999995,
      68.20500000000003,
      20.223999999999997,
    );
    path_16.lineTo(68.23700000000002, 19.138999999999996);
    path_16.close();
    path_16.moveTo(67.43800000000003, 19.159);
    path_16.lineTo(67.35700000000003, 18.076);
    path_16.arcToPoint(
      Offset(66.50400000000003, 18.183),
      radius: Radius.elliptical(8.23, 8.23),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(66.69800000000004, 19.252);
    path_16.lineTo(66.89300000000003, 20.32);
    path_16.cubicTo(
      67.08600000000003,
      20.285,
      67.29400000000003,
      20.258,
      67.52000000000002,
      20.241,
    );
    path_16.lineTo(67.43800000000003, 19.159);
    path_16.close();
    path_16.moveTo(66.69800000000004, 19.252);
    path_16.lineTo(66.50500000000004, 18.183);
    path_16.cubicTo(
      66.27200000000003,
      18.226,
      66.07200000000003,
      18.264,
      65.90700000000004,
      18.299,
    );
    path_16.lineTo(66.13300000000004, 19.361);
    path_16.lineTo(66.35900000000004, 20.423000000000002);
    path_16.cubicTo(
      66.49500000000003,
      20.394000000000002,
      66.67100000000003,
      20.360000000000003,
      66.89200000000004,
      20.32,
    );
    path_16.lineTo(66.69800000000004, 19.252);
    path_16.close();
    path_16.moveTo(66.13300000000004, 19.362);
    path_16.lineTo(65.90700000000004, 18.299);
    path_16.cubicTo(
      65.56900000000005,
      18.371,
      65.22700000000003,
      18.459,
      64.88500000000003,
      18.563,
    );
    path_16.lineTo(65.20000000000003, 19.602999999999998);
    path_16.lineTo(65.51500000000003, 20.641);
    path_16.cubicTo(
      65.80200000000004,
      20.554,
      66.08300000000003,
      20.480999999999998,
      66.35900000000002,
      20.423,
    );
    path_16.lineTo(66.13300000000002, 19.360999999999997);
    path_16.close();
    path_16.moveTo(65.20000000000003, 19.601999999999997);
    path_16.lineTo(64.88300000000004, 18.563999999999997);
    path_16.cubicTo(
      64.51300000000003,
      18.676999999999996,
      64.15800000000004,
      18.820999999999998,
      63.81600000000004,
      18.996999999999996,
    );
    path_16.lineTo(64.31300000000005, 19.961999999999996);
    path_16.lineTo(64.81100000000005, 20.926999999999996);
    path_16.cubicTo(
      65.03500000000005,
      20.811999999999998,
      65.27100000000004,
      20.716999999999995,
      65.51700000000005,
      20.640999999999995,
    );
    path_16.lineTo(65.20000000000006, 19.601999999999993);
    path_16.close();
    path_16.moveTo(64.31300000000003, 19.961999999999996);
    path_16.lineTo(65.38500000000003, 19.788999999999998);
    path_16.lineTo(64.03600000000003, 11.428999999999998);
    path_16.lineTo(62.96400000000003, 11.601999999999999);
    path_16.lineTo(61.89300000000003, 11.774999999999999);
    path_16.lineTo(63.24100000000003, 20.134999999999998);
    path_16.lineTo(64.31300000000003, 19.962);
    path_16.close();
    path_16.moveTo(62.964000000000034, 11.601999999999997);
    path_16.lineTo(63.21900000000004, 12.657999999999998);
    path_16.lineTo(71.46400000000004, 10.669999999999998);
    path_16.lineTo(71.21000000000004, 9.613999999999997);
    path_16.lineTo(70.95500000000004, 8.558999999999997);
    path_16.lineTo(62.71000000000004, 10.546999999999997);
    path_16.lineTo(62.96400000000004, 11.601999999999997);
    path_16.close();
    path_16.moveTo(71.21000000000004, 9.613999999999997);
    path_16.lineTo(70.16000000000004, 9.895999999999997);
    path_16.lineTo(71.29600000000003, 14.126999999999997);
    path_16.lineTo(72.34400000000004, 13.846999999999998);
    path_16.lineTo(73.39400000000003, 13.564999999999998);
    path_16.lineTo(72.25800000000004, 9.332999999999998);
    path_16.lineTo(71.21000000000004, 9.613999999999999);
    path_16.close();
    path_16.moveTo(72.34500000000004, 13.845999999999997);
    path_16.lineTo(72.17800000000004, 12.772999999999996);
    path_16.lineTo(66.97800000000004, 13.578999999999997);
    path_16.lineTo(67.14400000000003, 14.651999999999997);
    path_16.lineTo(67.31000000000003, 15.724999999999998);
    path_16.lineTo(72.51000000000003, 14.918999999999997);
    path_16.lineTo(72.34400000000004, 13.845999999999997);
    path_16.close();
    path_16.moveTo(67.14400000000005, 14.651999999999997);
    path_16.lineTo(66.07100000000005, 14.817999999999998);
    path_16.lineTo(66.35600000000005, 16.662);
    path_16.lineTo(67.42900000000004, 16.496);
    path_16.lineTo(68.50200000000004, 16.33);
    path_16.lineTo(68.21700000000004, 14.485999999999999);
    path_16.lineTo(67.14400000000005, 14.652);
    path_16.close();
    path_16.moveTo(67.42900000000004, 16.496);
    path_16.lineTo(67.90000000000005, 17.474);
    path_16.cubicTo(
      68.15000000000005,
      17.354,
      68.40300000000005,
      17.251,
      68.65700000000005,
      17.167,
    );
    path_16.lineTo(68.31600000000006, 16.137);
    path_16.lineTo(67.97400000000006, 15.106);
    path_16.arcToPoint(
      Offset(66.95700000000006, 15.518),
      radius: Radius.elliptical(8.499, 8.499),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(67.42900000000006, 16.496000000000002);
    path_16.close();
    path_16.moveTo(68.31600000000005, 16.136);
    path_16.lineTo(68.68000000000005, 17.159);
    path_16.cubicTo(
      68.93300000000005,
      17.069,
      69.19000000000005,
      16.996,
      69.45000000000005,
      16.941,
    );
    path_16.lineTo(69.22400000000005, 15.879);
    path_16.lineTo(68.99800000000005, 14.817);
    path_16.arcToPoint(
      Offset(67.95100000000005, 15.114),
      radius: Radius.elliptical(8.215, 8.215),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(68.31600000000005, 16.136);
    path_16.close();
    path_16.moveTo(69.22400000000005, 15.879);
    path_16.lineTo(69.45000000000005, 16.941);
    path_16.cubicTo(
      69.95200000000004,
      16.834,
      70.41600000000004,
      16.820999999999998,
      70.84900000000005,
      16.891,
    );
    path_16.lineTo(71.01900000000005, 15.818999999999999);
    path_16.lineTo(71.19000000000005, 14.745999999999999);
    path_16.arcToPoint(
      Offset(68.99800000000005, 14.816999999999998),
      radius: Radius.elliptical(5.973, 5.973),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(69.22400000000005, 15.878999999999998);
    path_16.close();
    path_16.moveTo(71.01900000000005, 15.818999999999999);
    path_16.lineTo(70.86500000000005, 16.893);
    path_16.cubicTo(
      71.30800000000005,
      16.957,
      71.69500000000005,
      17.096,
      72.03800000000005,
      17.306,
    );
    path_16.lineTo(72.60500000000005, 16.380000000000003);
    path_16.lineTo(73.17200000000004, 15.454000000000002);
    path_16.arcToPoint(
      Offset(71.17400000000004, 14.744000000000003),
      radius: Radius.elliptical(5.204, 5.204),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(71.01900000000003, 15.819000000000003);
    path_16.close();
    path_16.moveTo(72.60500000000005, 16.38);
    path_16.lineTo(72.04500000000004, 17.311);
    path_16.cubicTo(
      72.39100000000005,
      17.518,
      72.69100000000005,
      17.798,
      72.94600000000004,
      18.164,
    );
    path_16.lineTo(73.83600000000004, 17.542);
    path_16.lineTo(74.72600000000004, 16.92);
    path_16.arcToPoint(
      Offset(73.16400000000004, 15.450000000000001),
      radius: Radius.elliptical(5.102, 5.102),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_16.lineTo(72.60500000000005, 16.380000000000003);
    path_16.close();
    path_16.moveTo(73.83600000000004, 17.541999999999998);
    path_16.lineTo(72.95600000000005, 18.177);
    path_16.cubicTo(
      73.20000000000005,
      18.515,
      73.38600000000005,
      18.937,
      73.49900000000005,
      19.465,
    );
    path_16.lineTo(74.56100000000005, 19.239);
    path_16.lineTo(75.62300000000005, 19.013);
    path_16.cubicTo(
      75.45700000000005,
      18.231,
      75.16000000000005,
      17.521,
      74.71700000000004,
      16.906000000000002,
    );
    path_16.lineTo(73.83700000000005, 17.542);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(71.347, 8.019);
    path_17.lineTo(82.347, 8.019);
    path_17.lineTo(82.347, 26.019);
    path_17.lineTo(71.347, 26.019);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(81.197, 9.967);
    path_18.lineTo(80.59, 24.85);
    path_18.lineTo(76.02600000000001, 24.64);
    path_18.lineTo(76.278, 14.739);
    path_18.lineTo(74.60300000000001, 15.89);
    path_18.lineTo(73.03300000000002, 12.31);
    path_18.lineTo(76.44500000000002, 9.757000000000001);
    path_18.lineTo(81.19700000000002, 9.966000000000001);
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(81.197, 9.967);
    path_19.lineTo(80.59, 24.85);
    path_19.lineTo(76.02600000000001, 24.64);
    path_19.lineTo(76.278, 14.739);
    path_19.lineTo(74.60300000000001, 15.89);
    path_19.lineTo(73.03300000000002, 12.31);
    path_19.lineTo(76.44500000000002, 9.757000000000001);
    path_19.lineTo(81.19700000000002, 9.966000000000001);
    path_19.close();

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffECCA93).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(81.197, 9.967);
    path_20.lineTo(82.282, 10.011000000000001);
    path_20.lineTo(82.326, 8.930000000000001);
    path_20.lineTo(81.24499999999999, 8.882000000000001);
    path_20.lineTo(81.19699999999999, 9.967000000000002);
    path_20.close();
    path_20.moveTo(80.59, 24.85);
    path_20.lineTo(80.54, 25.935000000000002);
    path_20.lineTo(81.63000000000001, 25.985000000000003);
    path_20.lineTo(81.67500000000001, 24.895000000000003);
    path_20.lineTo(80.59000000000002, 24.85);
    path_20.close();
    path_20.moveTo(76.02600000000001, 24.64);
    path_20.lineTo(74.94100000000002, 24.613);
    path_20.lineTo(74.91400000000002, 25.677);
    path_20.lineTo(75.97700000000002, 25.724999999999998);
    path_20.lineTo(76.02700000000002, 24.641);
    path_20.close();
    path_20.moveTo(76.278, 14.739);
    path_20.lineTo(77.363, 14.766);
    path_20.lineTo(77.417, 12.638);
    path_20.lineTo(75.662, 13.844);
    path_20.lineTo(76.277, 14.738999999999999);
    path_20.close();
    path_20.moveTo(74.60300000000001, 15.89);
    path_20.lineTo(73.608, 16.326);
    path_20.lineTo(74.13600000000001, 17.529);
    path_20.lineTo(75.218, 16.785);
    path_20.lineTo(74.60300000000001, 15.89);
    path_20.close();
    path_20.moveTo(73.03300000000002, 12.31);
    path_20.lineTo(72.38300000000001, 11.441);
    path_20.lineTo(71.69300000000001, 11.958);
    path_20.lineTo(72.03800000000001, 12.747);
    path_20.lineTo(73.03300000000002, 12.311);
    path_20.close();
    path_20.moveTo(76.44500000000002, 9.757000000000001);
    path_20.lineTo(76.49300000000002, 8.672);
    path_20.lineTo(76.10500000000002, 8.655000000000001);
    path_20.lineTo(75.79500000000002, 8.887);
    path_20.lineTo(76.44500000000002, 9.757);
    path_20.close();
    path_20.moveTo(81.19700000000002, 9.966000000000001);
    path_20.lineTo(80.11200000000002, 9.922);
    path_20.lineTo(79.50500000000002, 24.806);
    path_20.lineTo(80.59000000000002, 24.85);
    path_20.lineTo(81.67500000000001, 24.894000000000002);
    path_20.lineTo(82.28200000000001, 10.010000000000002);
    path_20.lineTo(81.19700000000002, 9.966000000000001);
    path_20.close();
    path_20.moveTo(80.59, 24.85);
    path_20.lineTo(80.64, 23.766000000000002);
    path_20.lineTo(76.076, 23.556);
    path_20.lineTo(76.026, 24.641000000000002);
    path_20.lineTo(75.976, 25.725);
    path_20.lineTo(80.53999999999999, 25.935000000000002);
    path_20.lineTo(80.58999999999999, 24.85);
    path_20.close();
    path_20.moveTo(76.02600000000001, 24.64);
    path_20.lineTo(77.11200000000001, 24.668);
    path_20.lineTo(77.36200000000001, 14.766);
    path_20.lineTo(76.278, 14.739);
    path_20.lineTo(75.19200000000001, 14.711);
    path_20.lineTo(74.941, 24.613);
    path_20.lineTo(76.026, 24.641);
    path_20.close();
    path_20.moveTo(76.278, 14.739);
    path_20.lineTo(75.662, 13.844000000000001);
    path_20.lineTo(73.988, 14.996);
    path_20.lineTo(74.603, 15.89);
    path_20.lineTo(75.21799999999999, 16.785);
    path_20.lineTo(76.89299999999999, 15.634);
    path_20.lineTo(76.27799999999999, 14.739);
    path_20.close();
    path_20.moveTo(74.60300000000001, 15.89);
    path_20.lineTo(75.59700000000001, 15.454);
    path_20.lineTo(74.02700000000002, 11.874);
    path_20.lineTo(73.03300000000002, 12.311);
    path_20.lineTo(72.03800000000001, 12.747);
    path_20.lineTo(73.608, 16.326999999999998);
    path_20.lineTo(74.60300000000001, 15.889999999999999);
    path_20.close();
    path_20.moveTo(73.03300000000002, 12.31);
    path_20.lineTo(73.68300000000002, 13.18);
    path_20.lineTo(77.09500000000003, 10.626);
    path_20.lineTo(76.44500000000002, 9.756);
    path_20.lineTo(75.79500000000002, 8.887);
    path_20.lineTo(72.38200000000002, 11.441);
    path_20.lineTo(73.03200000000002, 12.311);
    path_20.close();
    path_20.moveTo(76.44500000000002, 9.757000000000001);
    path_20.lineTo(76.39700000000002, 10.841000000000001);
    path_20.lineTo(81.14900000000002, 11.051000000000002);
    path_20.lineTo(81.19700000000002, 9.966000000000001);
    path_20.lineTo(81.24500000000002, 8.881);
    path_20.lineTo(76.49300000000002, 8.671);
    path_20.lineTo(76.44500000000002, 9.757);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(79.472, 8.973);
    path_21.lineTo(97.11599999999999, 8.973);
    path_21.lineTo(97.11599999999999, 30.469);
    path_21.lineTo(79.472, 30.469);
    path_21.close();

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(92.877, 22.97);
    path_22.cubicTo(
      92.689,
      23.857,
      92.36399999999999,
      24.593999999999998,
      91.904,
      25.180999999999997,
    );
    path_22.arcToPoint(
      Offset(90.268, 26.534999999999997),
      radius: Radius.elliptical(4.63, 4.63),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(88.138, 27.087999999999997),
      radius: Radius.elliptical(5.669, 5.669),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(85.706, 26.903),
      radius: Radius.elliptical(8.729, 8.729),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(84.536, 26.569),
      radius: Radius.elliptical(8.724, 8.724),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(83.429, 26.087),
      radius: Radius.elliptical(13.645, 13.645),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(82.377, 25.5),
      radius: Radius.elliptical(18.127, 18.127),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(81.35, 24.843),
      radius: Radius.elliptical(28.873, 28.873),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.lineTo(82.60499999999999, 20.851);
    path_22.arcToPoint(
      Offset(84.96999999999998, 22.262999999999998),
      radius: Radius.elliptical(7.848, 7.848),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.cubicTo(
      85.26699999999998,
      22.375999999999998,
      85.55799999999998,
      22.462999999999997,
      85.84499999999998,
      22.523,
    );
    path_22.cubicTo(
      86.01499999999999,
      22.56,
      86.22699999999999,
      22.59,
      86.47799999999998,
      22.615,
    );
    path_22.cubicTo(
      86.73099999999998,
      22.633999999999997,
      86.97899999999998,
      22.625,
      87.22199999999998,
      22.592,
    );
    path_22.arcToPoint(
      Offset(87.86899999999999, 22.365),
      radius: Radius.elliptical(1.88, 1.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(88.23899999999999, 21.834),
      radius: Radius.elliptical(0.772, 0.772),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(88.169, 21.209),
      radius: Radius.elliptical(0.933, 0.933),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(87.762, 20.705),
      radius: Radius.elliptical(1.394, 1.394),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(87.141, 20.305),
      radius: Radius.elliptical(2.786, 2.786),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(86.403, 19.999),
      radius: Radius.elliptical(7.423, 7.423),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(85.68900000000001, 19.782999999999998),
      radius: Radius.elliptical(7.109, 7.109),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.cubicTo(
      85.465,
      19.727999999999998,
      85.27900000000001,
      19.685,
      85.129,
      19.653,
    );
    path_22.arcToPoint(
      Offset(84.17800000000001, 19.494),
      radius: Radius.elliptical(11.403, 11.403),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.arcToPoint(
      Offset(83.22100000000002, 19.462),
      radius: Radius.elliptical(5.29, 5.29),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_22.lineTo(85.38900000000002, 11.276);
    path_22.lineTo(93.73000000000002, 12.814);
    path_22.lineTo(93.04600000000002, 17.141);
    path_22.lineTo(87.96700000000003, 15.761999999999999);
    path_22.lineTo(87.47700000000003, 17.561999999999998);
    path_22.arcToPoint(
      Offset(88.43400000000003, 17.595),
      radius: Radius.elliptical(7.6, 7.6),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.cubicTo(
      88.75000000000003,
      17.619,
      89.06100000000002,
      17.665,
      89.36800000000002,
      17.729,
    );
    path_22.arcToPoint(
      Offset(91.03300000000003, 18.404),
      radius: Radius.elliptical(4.885, 4.885),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(92.25300000000003, 19.563),
      radius: Radius.elliptical(4.12, 4.12),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.cubicTo(
      92.57600000000002,
      20.023,
      92.79300000000003,
      20.544,
      92.90500000000003,
      21.124,
    );
    path_22.cubicTo(
      93.02500000000003,
      21.698999999999998,
      93.01600000000003,
      22.314,
      92.87700000000002,
      22.97,
    );
    path_22.close();

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(92.877, 22.97);
    path_23.cubicTo(
      92.689,
      23.857,
      92.36399999999999,
      24.593999999999998,
      91.904,
      25.180999999999997,
    );
    path_23.arcToPoint(
      Offset(90.268, 26.534999999999997),
      radius: Radius.elliptical(4.63, 4.63),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(88.138, 27.087999999999997),
      radius: Radius.elliptical(5.669, 5.669),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(85.706, 26.903),
      radius: Radius.elliptical(8.729, 8.729),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(84.536, 26.569),
      radius: Radius.elliptical(8.724, 8.724),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(83.429, 26.087),
      radius: Radius.elliptical(13.645, 13.645),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(82.377, 25.5),
      radius: Radius.elliptical(18.127, 18.127),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(81.35, 24.843),
      radius: Radius.elliptical(28.873, 28.873),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.lineTo(82.60499999999999, 20.851);
    path_23.arcToPoint(
      Offset(84.96999999999998, 22.262999999999998),
      radius: Radius.elliptical(7.848, 7.848),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.cubicTo(
      85.26699999999998,
      22.375999999999998,
      85.55799999999998,
      22.462999999999997,
      85.84499999999998,
      22.523,
    );
    path_23.cubicTo(
      86.01499999999999,
      22.56,
      86.22699999999999,
      22.59,
      86.47799999999998,
      22.615,
    );
    path_23.cubicTo(
      86.73099999999998,
      22.633999999999997,
      86.97899999999998,
      22.625,
      87.22199999999998,
      22.592,
    );
    path_23.arcToPoint(
      Offset(87.86899999999999, 22.365),
      radius: Radius.elliptical(1.88, 1.88),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(88.23899999999999, 21.834),
      radius: Radius.elliptical(0.772, 0.772),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(88.169, 21.209),
      radius: Radius.elliptical(0.933, 0.933),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(87.762, 20.705),
      radius: Radius.elliptical(1.394, 1.394),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(87.141, 20.305),
      radius: Radius.elliptical(2.786, 2.786),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(86.403, 19.999),
      radius: Radius.elliptical(7.423, 7.423),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(85.68900000000001, 19.782999999999998),
      radius: Radius.elliptical(7.109, 7.109),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.cubicTo(
      85.465,
      19.727999999999998,
      85.27900000000001,
      19.685,
      85.129,
      19.653,
    );
    path_23.arcToPoint(
      Offset(84.17800000000001, 19.494),
      radius: Radius.elliptical(11.403, 11.403),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.arcToPoint(
      Offset(83.22100000000002, 19.462),
      radius: Radius.elliptical(5.29, 5.29),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.lineTo(85.38900000000002, 11.276);
    path_23.lineTo(93.73000000000002, 12.814);
    path_23.lineTo(93.04600000000002, 17.141);
    path_23.lineTo(87.96700000000003, 15.761999999999999);
    path_23.lineTo(87.47700000000003, 17.561999999999998);
    path_23.arcToPoint(
      Offset(88.43400000000003, 17.595),
      radius: Radius.elliptical(7.6, 7.6),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.cubicTo(
      88.75000000000003,
      17.619,
      89.06100000000002,
      17.665,
      89.36800000000002,
      17.729,
    );
    path_23.arcToPoint(
      Offset(91.03300000000003, 18.404),
      radius: Radius.elliptical(4.885, 4.885),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(92.25300000000003, 19.563),
      radius: Radius.elliptical(4.12, 4.12),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.cubicTo(
      92.57600000000002,
      20.023,
      92.79300000000003,
      20.544,
      92.90500000000003,
      21.124,
    );
    path_23.cubicTo(
      93.02500000000003,
      21.698999999999998,
      93.01600000000003,
      22.314,
      92.87700000000002,
      22.97,
    );
    path_23.close();

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xffECCA93).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(91.904, 25.181);
    path_24.lineTo(91.04899999999999, 24.511);
    path_24.lineTo(91.044, 24.519);
    path_24.lineTo(91.904, 25.180999999999997);
    path_24.close();
    path_24.moveTo(84.536, 26.568);
    path_24.lineTo(84.147, 27.582);
    path_24.lineTo(84.156, 27.586000000000002);
    path_24.lineTo(84.165, 27.589000000000002);
    path_24.lineTo(84.53500000000001, 26.569000000000003);
    path_24.close();
    path_24.moveTo(83.429, 26.088);
    path_24.lineTo(82.932, 27.052);
    path_24.lineTo(82.94200000000001, 27.058);
    path_24.lineTo(82.95200000000001, 27.063);
    path_24.lineTo(83.42900000000002, 26.087);
    path_24.close();
    path_24.moveTo(82.377, 25.5);
    path_24.lineTo(81.81099999999999, 26.427);
    path_24.lineTo(81.817, 26.43);
    path_24.lineTo(82.377, 25.5);
    path_24.close();
    path_24.moveTo(81.35, 24.843);
    path_24.lineTo(80.314, 24.517);
    path_24.lineTo(80.07, 25.293);
    path_24.lineTo(80.746, 25.745);
    path_24.lineTo(81.35, 24.843);
    path_24.close();
    path_24.moveTo(82.60499999999999, 20.851);
    path_24.lineTo(83.31799999999998, 20.031);
    path_24.lineTo(82.06799999999998, 18.942);
    path_24.lineTo(81.56899999999999, 20.525);
    path_24.lineTo(82.60499999999999, 20.851);
    path_24.close();
    path_24.moveTo(84.10999999999999, 21.877);
    path_24.lineTo(83.60699999999999, 22.839);
    path_24.lineTo(83.61299999999999, 22.842);
    path_24.lineTo(84.10999999999999, 21.877);
    path_24.close();
    path_24.moveTo(84.96999999999998, 22.262999999999998);
    path_24.lineTo(84.57999999999998, 23.275999999999996);
    path_24.lineTo(84.58299999999998, 23.276999999999997);
    path_24.lineTo(84.96999999999998, 22.262999999999998);
    path_24.close();
    path_24.moveTo(86.47799999999998, 22.615);
    path_24.lineTo(86.37099999999998, 23.695);
    path_24.lineTo(86.38599999999998, 23.697);
    path_24.lineTo(86.40099999999998, 23.698);
    path_24.lineTo(86.47799999999998, 22.615000000000002);
    path_24.close();
    path_24.moveTo(87.22199999999998, 22.592);
    path_24.lineTo(87.37199999999999, 23.666999999999998);
    path_24.lineTo(87.38699999999999, 23.665);
    path_24.lineTo(87.40099999999998, 23.662);
    path_24.lineTo(87.22099999999998, 22.592);
    path_24.close();
    path_24.moveTo(87.86899999999999, 22.365);
    path_24.lineTo(88.41899999999998, 23.302);
    path_24.lineTo(88.41999999999999, 23.301);
    path_24.lineTo(87.86999999999999, 22.365);
    path_24.close();
    path_24.moveTo(88.16899999999998, 21.209);
    path_24.lineTo(87.18299999999998, 21.666);
    path_24.lineTo(87.18899999999998, 21.678);
    path_24.lineTo(87.19599999999998, 21.691000000000003);
    path_24.lineTo(88.16799999999998, 21.209000000000003);
    path_24.close();
    path_24.moveTo(87.76199999999999, 20.705);
    path_24.lineTo(87.05199999999999, 21.526);
    path_24.lineTo(87.068, 21.541);
    path_24.lineTo(87.085, 21.554000000000002);
    path_24.lineTo(87.762, 20.705000000000002);
    path_24.close();
    path_24.moveTo(86.403, 20);
    path_24.lineTo(86.037, 21.022);
    path_24.lineTo(86.04100000000001, 21.023999999999997);
    path_24.lineTo(86.403, 19.999999999999996);
    path_24.close();
    path_24.moveTo(85.68900000000001, 19.784);
    path_24.lineTo(85.43100000000001, 20.839);
    path_24.lineTo(85.43200000000002, 20.839);
    path_24.lineTo(85.68900000000002, 19.784);
    path_24.close();
    path_24.moveTo(84.17800000000001, 19.494999999999997);
    path_24.lineTo(84.31300000000002, 18.418);
    path_24.lineTo(84.31100000000002, 18.418);
    path_24.lineTo(84.17800000000003, 19.494999999999997);
    path_24.close();
    path_24.moveTo(83.22100000000002, 19.462999999999997);
    path_24.lineTo(82.17100000000002, 19.185);
    path_24.lineTo(81.78900000000002, 20.631999999999998);
    path_24.lineTo(83.28300000000002, 20.546999999999997);
    path_24.lineTo(83.22100000000002, 19.462999999999997);
    path_24.close();
    path_24.moveTo(85.38900000000002, 11.276999999999997);
    path_24.lineTo(85.58600000000003, 10.209999999999997);
    path_24.lineTo(84.59700000000002, 10.026999999999997);
    path_24.lineTo(84.34000000000002, 10.998999999999997);
    path_24.lineTo(85.39000000000001, 11.276999999999997);
    path_24.close();
    path_24.moveTo(93.73000000000002, 12.814999999999998);
    path_24.lineTo(94.80300000000001, 12.984999999999998);
    path_24.lineTo(94.96800000000002, 11.938999999999998);
    path_24.lineTo(93.92700000000002, 11.746999999999998);
    path_24.lineTo(93.73000000000002, 12.814999999999998);
    path_24.close();
    path_24.moveTo(93.04600000000002, 17.141999999999996);
    path_24.lineTo(92.76100000000002, 18.189999999999998);
    path_24.lineTo(93.92900000000003, 18.506999999999998);
    path_24.lineTo(94.11900000000003, 17.311999999999998);
    path_24.lineTo(93.04600000000003, 17.141999999999996);
    path_24.close();
    path_24.moveTo(87.96700000000003, 15.762999999999996);
    path_24.lineTo(88.25200000000002, 14.714999999999996);
    path_24.lineTo(87.20400000000002, 14.430999999999996);
    path_24.lineTo(86.91900000000003, 15.477999999999996);
    path_24.lineTo(87.96700000000003, 15.762999999999996);
    path_24.close();
    path_24.moveTo(87.47700000000003, 17.562999999999995);
    path_24.lineTo(86.43000000000004, 17.278999999999996);
    path_24.lineTo(86.04500000000003, 18.693999999999996);
    path_24.lineTo(87.51000000000003, 18.648999999999994);
    path_24.lineTo(87.47700000000003, 17.563999999999993);
    path_24.close();
    path_24.moveTo(88.43400000000003, 17.595999999999997);
    path_24.lineTo(88.32600000000002, 18.675999999999995);
    path_24.lineTo(88.33800000000002, 18.677999999999994);
    path_24.lineTo(88.35000000000002, 18.677999999999994);
    path_24.lineTo(88.43400000000003, 17.595999999999993);
    path_24.close();
    path_24.moveTo(91.03400000000002, 18.405999999999995);
    path_24.lineTo(90.44100000000002, 19.315999999999995);
    path_24.lineTo(90.44800000000002, 19.319999999999997);
    path_24.lineTo(90.45500000000003, 19.324999999999996);
    path_24.lineTo(91.03300000000003, 18.404999999999994);
    path_24.close();
    path_24.moveTo(92.25300000000001, 19.562999999999995);
    path_24.lineTo(91.35800000000002, 20.178999999999995);
    path_24.lineTo(91.36400000000002, 20.185999999999996);
    path_24.lineTo(92.25300000000001, 19.563999999999997);
    path_24.close();
    path_24.moveTo(92.90500000000002, 21.124999999999996);
    path_24.lineTo(91.83900000000001, 21.330999999999996);
    path_24.lineTo(91.84100000000001, 21.339999999999996);
    path_24.lineTo(91.843, 21.347999999999995);
    path_24.lineTo(92.905, 21.124999999999996);
    path_24.close();
    path_24.moveTo(92.87700000000001, 22.970999999999997);
    path_24.lineTo(91.81500000000001, 22.744999999999997);
    path_24.cubicTo(
      91.653,
      23.505,
      91.388,
      24.080999999999996,
      91.049,
      24.512999999999998,
    );
    path_24.lineTo(91.90400000000001, 25.183);
    path_24.lineTo(92.75900000000001, 25.852);
    path_24.cubicTo(
      93.34100000000001,
      25.11,
      93.72300000000001,
      24.212,
      93.93900000000002,
      23.196,
    );
    path_24.lineTo(92.87700000000002, 22.971);
    path_24.close();
    path_24.moveTo(91.90400000000001, 25.181999999999995);
    path_24.lineTo(91.04400000000001, 24.519999999999996);
    path_24.arcToPoint(
      Offset(89.78800000000001, 25.561999999999998),
      radius: Radius.elliptical(3.545, 3.545),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(90.26800000000001, 26.535999999999998);
    path_24.lineTo(90.74800000000002, 27.509999999999998);
    path_24.arcToPoint(
      Offset(92.76400000000002, 25.845),
      radius: Radius.elliptical(5.714, 5.714),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(91.90400000000002, 25.182);
    path_24.close();
    path_24.moveTo(90.26800000000001, 26.535999999999994);
    path_24.lineTo(89.78800000000001, 25.561999999999994);
    path_24.arcToPoint(
      Offset(88.06300000000002, 26.005999999999993),
      radius: Radius.elliptical(4.588, 4.588),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(88.13900000000001, 27.08899999999999);
    path_24.lineTo(88.215, 28.17199999999999);
    path_24.arcToPoint(
      Offset(90.748, 27.50999999999999),
      radius: Radius.elliptical(6.754, 6.754),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(90.268, 26.53599999999999);
    path_24.close();
    path_24.moveTo(88.13800000000002, 27.088999999999995);
    path_24.lineTo(88.06300000000002, 26.005999999999997);
    path_24.arcToPoint(
      Offset(85.93200000000002, 25.841999999999995),
      radius: Radius.elliptical(7.641, 7.641),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(85.70600000000002, 26.903999999999996);
    path_24.lineTo(85.48000000000002, 27.965999999999998);
    path_24.cubicTo(
      86.41000000000003,
      28.162999999999997,
      87.32200000000002,
      28.234999999999996,
      88.21500000000002,
      28.171999999999997,
    );
    path_24.lineTo(88.13900000000002, 27.089);
    path_24.close();
    path_24.moveTo(85.70600000000002, 26.903999999999996);
    path_24.lineTo(85.93200000000002, 25.841999999999995);
    path_24.arcToPoint(
      Offset(84.90700000000001, 25.548999999999996),
      radius: Radius.elliptical(7.638, 7.638),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(84.53600000000002, 26.568999999999996);
    path_24.lineTo(84.16500000000002, 27.588999999999995);
    path_24.cubicTo(
      84.59100000000002,
      27.744999999999994,
      85.02900000000002,
      27.869999999999994,
      85.48000000000002,
      27.965999999999994,
    );
    path_24.lineTo(85.70600000000002, 26.903999999999993);
    path_24.close();
    path_24.moveTo(84.53600000000002, 26.569999999999997);
    path_24.lineTo(84.92400000000002, 25.555999999999997);
    path_24.cubicTo(
      84.57800000000002,
      25.423,
      84.23900000000002,
      25.275999999999996,
      83.90600000000002,
      25.112999999999996,
    );
    path_24.lineTo(83.42900000000002, 26.087999999999997);
    path_24.lineTo(82.95200000000001, 27.063999999999997);
    path_24.cubicTo(
      83.34300000000002,
      27.253999999999998,
      83.74200000000002,
      27.427999999999997,
      84.147,
      27.583999999999996,
    );
    path_24.lineTo(84.536, 26.569999999999997);
    path_24.close();
    path_24.moveTo(83.42900000000002, 26.087999999999997);
    path_24.lineTo(83.92600000000002, 25.122999999999998);
    path_24.arcToPoint(
      Offset(82.93600000000002, 24.570999999999998),
      radius: Radius.elliptical(17.03, 17.03),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(82.37600000000002, 25.500999999999998);
    path_24.lineTo(81.81600000000002, 26.430999999999997);
    path_24.cubicTo(
      82.18500000000002,
      26.651999999999997,
      82.55600000000001,
      26.859999999999996,
      82.93200000000002,
      27.052999999999997,
    );
    path_24.lineTo(83.42900000000002, 26.087999999999997);
    path_24.close();
    path_24.moveTo(82.37700000000001, 25.500999999999998);
    path_24.lineTo(82.94200000000001, 24.573999999999998);
    path_24.cubicTo(
      82.61500000000001,
      24.374,
      82.28500000000001,
      24.163999999999998,
      81.95400000000001,
      23.941,
    );
    path_24.lineTo(81.35000000000001, 24.843999999999998);
    path_24.lineTo(80.74600000000001, 25.746);
    path_24.cubicTo(81.102, 25.983999999999998, 81.456, 26.211, 81.811, 26.427);
    path_24.lineTo(82.37700000000001, 25.501);
    path_24.close();
    path_24.moveTo(81.35000000000001, 24.843999999999998);
    path_24.lineTo(82.38600000000001, 25.168999999999997);
    path_24.lineTo(83.641, 21.176999999999996);
    path_24.lineTo(82.605, 20.851999999999997);
    path_24.lineTo(81.569, 20.525999999999996);
    path_24.lineTo(80.31400000000001, 24.517999999999997);
    path_24.lineTo(81.35000000000001, 24.843999999999998);
    path_24.close();
    path_24.moveTo(82.605, 20.851999999999997);
    path_24.lineTo(81.89200000000001, 21.669999999999998);
    path_24.cubicTo(
      82.14200000000001,
      21.887999999999998,
      82.412,
      22.095,
      82.69800000000001,
      22.291999999999998,
    );
    path_24.lineTo(83.313, 21.398);
    path_24.lineTo(83.928, 20.503);
    path_24.arcToPoint(
      Offset(83.318, 20.033),
      radius: Radius.elliptical(6.778, 6.778),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(82.605, 20.852);
    path_24.close();
    path_24.moveTo(83.313, 21.397999999999996);
    path_24.lineTo(82.69800000000001, 22.292999999999996);
    path_24.cubicTo(
      82.989,
      22.492999999999995,
      83.292,
      22.674999999999997,
      83.60700000000001,
      22.839999999999996,
    );
    path_24.lineTo(84.11000000000001, 21.877999999999997);
    path_24.lineTo(84.61300000000001, 20.914999999999996);
    path_24.arcToPoint(
      Offset(83.92800000000001, 20.502999999999997),
      radius: Radius.elliptical(6.594, 6.594),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(83.31300000000002, 21.397999999999996);
    path_24.close();
    path_24.moveTo(84.11, 21.877999999999997);
    path_24.lineTo(83.613, 22.842999999999996);
    path_24.arcToPoint(
      Offset(84.58, 23.276999999999997),
      radius: Radius.elliptical(9.9, 9.9),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(84.97, 22.263999999999996);
    path_24.lineTo(85.36, 21.249999999999996);
    path_24.arcToPoint(
      Offset(84.607, 20.911999999999995),
      radius: Radius.elliptical(7.592, 7.592),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(84.11, 21.877999999999997);
    path_24.close();
    path_24.moveTo(84.97, 22.263999999999996);
    path_24.lineTo(84.583, 23.277999999999995);
    path_24.cubicTo(
      84.928,
      23.409999999999997,
      85.273,
      23.512999999999995,
      85.619,
      23.586999999999996,
    );
    path_24.lineTo(85.845, 22.524999999999995);
    path_24.lineTo(86.071, 21.462999999999994);
    path_24.arcToPoint(
      Offset(85.356, 21.248999999999995),
      radius: Radius.elliptical(4.832, 4.832),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(84.97, 22.263999999999996);
    path_24.close();
    path_24.moveTo(85.845, 22.523999999999997);
    path_24.lineTo(85.619, 23.586999999999996);
    path_24.cubicTo(
      85.842,
      23.633999999999997,
      86.096,
      23.669999999999995,
      86.371,
      23.696999999999996,
    );
    path_24.lineTo(86.478, 22.616999999999997);
    path_24.lineTo(86.585, 21.535999999999998);
    path_24.arcToPoint(
      Offset(86.071, 21.462999999999997),
      radius: Radius.elliptical(4.884, 4.884),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(85.845, 22.525);
    path_24.close();
    path_24.moveTo(86.478, 22.615999999999996);
    path_24.lineTo(86.401, 23.698999999999995);
    path_24.cubicTo(
      86.72699999999999,
      23.722999999999995,
      87.051,
      23.712999999999994,
      87.37299999999999,
      23.667999999999996,
    );
    path_24.lineTo(87.222, 22.591999999999995);
    path_24.lineTo(87.071, 21.516999999999996);
    path_24.arcToPoint(
      Offset(86.556, 21.533999999999995),
      radius: Radius.elliptical(2.442, 2.442),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(86.478, 22.615999999999996);
    path_24.close();
    path_24.moveTo(87.222, 22.592999999999996);
    path_24.lineTo(87.401, 23.662999999999997);
    path_24.cubicTo(
      87.758,
      23.602999999999998,
      88.10199999999999,
      23.487999999999996,
      88.41799999999999,
      23.302999999999997,
    );
    path_24.lineTo(87.86899999999999, 22.365999999999996);
    path_24.lineTo(87.31899999999999, 21.429999999999996);
    path_24.arcToPoint(
      Offset(87.04299999999999, 21.521999999999995),
      radius: Radius.elliptical(0.803, 0.803),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(87.222, 22.591999999999995);
    path_24.close();
    path_24.moveTo(87.869, 22.365999999999996);
    path_24.lineTo(88.42, 23.301999999999996);
    path_24.cubicTo(
      88.9,
      23.018999999999995,
      89.19200000000001,
      22.571999999999996,
      89.3,
      22.060999999999996,
    );
    path_24.lineTo(88.239, 21.834999999999997);
    path_24.lineTo(87.177, 21.608999999999998);
    path_24.arcToPoint(
      Offset(87.31800000000001, 21.430999999999997),
      radius: Radius.elliptical(0.336, 0.336),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.lineTo(87.86900000000001, 22.365999999999996);
    path_24.close();
    path_24.moveTo(88.239, 21.834999999999997);
    path_24.lineTo(89.301, 22.060999999999996);
    path_24.arcToPoint(
      Offset(89.141, 20.727999999999998),
      radius: Radius.elliptical(2.017, 2.017),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(88.168, 21.209999999999997);
    path_24.lineTo(87.19600000000001, 21.691999999999997);
    path_24.arcToPoint(
      Offset(87.17800000000001, 21.631999999999998),
      radius: Radius.elliptical(0.19, 0.19),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_24.cubicTo(
      87.17600000000002,
      21.608999999999998,
      87.17800000000001,
      21.599999999999998,
      87.177,
      21.608999999999998,
    );
    path_24.lineTo(88.239, 21.834999999999997);
    path_24.close();
    path_24.moveTo(88.16900000000001, 21.209999999999997);
    path_24.lineTo(89.153, 20.752999999999997);
    path_24.arcToPoint(
      Offset(88.43900000000001, 19.856999999999996),
      radius: Radius.elliptical(2.479, 2.479),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(87.762, 20.706999999999997);
    path_24.lineTo(87.085, 21.554999999999996);
    path_24.cubicTo(
      87.15199999999999,
      21.608999999999995,
      87.175,
      21.646999999999995,
      87.18299999999999,
      21.666999999999994,
    );
    path_24.lineTo(88.16799999999999, 21.209999999999994);
    path_24.close();
    path_24.moveTo(87.76200000000001, 20.705999999999996);
    path_24.lineTo(88.47200000000001, 19.885999999999996);
    path_24.arcToPoint(
      Offset(87.611, 19.327999999999996),
      radius: Radius.elliptical(3.872, 3.872),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(87.141, 20.306999999999995);
    path_24.lineTo(86.671, 21.284999999999997);
    path_24.cubicTo(
      86.83500000000001,
      21.364999999999995,
      86.959,
      21.446999999999996,
      87.051,
      21.526999999999997,
    );
    path_24.lineTo(87.761, 20.706999999999997);
    path_24.close();
    path_24.moveTo(87.14100000000002, 20.305999999999997);
    path_24.lineTo(87.61100000000002, 19.327999999999996);
    path_24.arcToPoint(
      Offset(86.76500000000001, 18.976999999999997),
      radius: Radius.elliptical(8.497, 8.497),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(86.403, 20);
    path_24.lineTo(86.04100000000001, 21.024);
    path_24.cubicTo(
      86.25600000000001,
      21.1,
      86.46600000000001,
      21.187,
      86.671,
      21.285,
    );
    path_24.lineTo(87.141, 20.307);
    path_24.close();
    path_24.moveTo(86.403, 20);
    path_24.lineTo(86.769, 18.978);
    path_24.arcToPoint(
      Offset(85.94600000000001, 18.729000000000003),
      radius: Radius.elliptical(8.18, 8.18),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(85.68900000000001, 19.784000000000002);
    path_24.lineTo(85.432, 20.839000000000002);
    path_24.cubicTo(85.622, 20.885, 85.824, 20.946, 86.037, 21.022000000000002);
    path_24.lineTo(86.403, 20);
    path_24.close();
    path_24.moveTo(85.68900000000001, 19.784);
    path_24.lineTo(85.947, 18.729);
    path_24.cubicTo(85.717, 18.673, 85.519, 18.627, 85.354, 18.592);
    path_24.lineTo(85.128, 19.654);
    path_24.lineTo(84.903, 20.716);
    path_24.cubicTo(
      85.03800000000001,
      20.746000000000002,
      85.21300000000001,
      20.786,
      85.43100000000001,
      20.839000000000002,
    );
    path_24.lineTo(85.68900000000001, 19.784000000000002);
    path_24.close();
    path_24.moveTo(85.129, 19.654);
    path_24.lineTo(85.354, 18.592);
    path_24.cubicTo(85.015, 18.52, 84.66799999999999, 18.462, 84.313, 18.418);
    path_24.lineTo(84.178, 19.494999999999997);
    path_24.lineTo(84.04299999999999, 20.571999999999996);
    path_24.cubicTo(
      84.33999999999999,
      20.609999999999996,
      84.627,
      20.657999999999994,
      84.90299999999999,
      20.715999999999994,
    );
    path_24.lineTo(85.12799999999999, 19.653999999999993);
    path_24.close();
    path_24.moveTo(84.17800000000001, 19.495);
    path_24.lineTo(84.311, 18.417);
    path_24.arcToPoint(
      Offset(83.16000000000001, 18.379),
      radius: Radius.elliptical(6.412, 6.412),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(83.22100000000002, 19.463);
    path_24.lineTo(83.28300000000002, 20.547);
    path_24.cubicTo(
      83.53500000000001,
      20.533,
      83.78900000000002,
      20.541,
      84.04500000000002,
      20.573,
    );
    path_24.lineTo(84.17800000000001, 19.495);
    path_24.close();
    path_24.moveTo(83.22100000000002, 19.463);
    path_24.lineTo(84.27100000000002, 19.741);
    path_24.lineTo(86.43900000000002, 11.555);
    path_24.lineTo(85.38900000000002, 11.277);
    path_24.lineTo(84.33900000000003, 10.998999999999999);
    path_24.lineTo(82.17200000000003, 19.185);
    path_24.lineTo(83.22200000000002, 19.462999999999997);
    path_24.close();
    path_24.moveTo(85.38900000000002, 11.277000000000001);
    path_24.lineTo(85.19200000000002, 12.345);
    path_24.lineTo(93.53300000000002, 13.883000000000001);
    path_24.lineTo(93.73000000000002, 12.815000000000001);
    path_24.lineTo(93.92700000000002, 11.747000000000002);
    path_24.lineTo(85.58700000000002, 10.21);
    path_24.lineTo(85.38900000000002, 11.277000000000001);
    path_24.close();
    path_24.moveTo(93.73000000000002, 12.815000000000001);
    path_24.lineTo(92.65800000000002, 12.645000000000001);
    path_24.lineTo(91.97300000000001, 16.973000000000003);
    path_24.lineTo(93.046, 17.143000000000004);
    path_24.lineTo(94.11800000000001, 17.312000000000005);
    path_24.lineTo(94.80300000000001, 12.984000000000005);
    path_24.lineTo(93.73000000000002, 12.814000000000005);
    path_24.close();
    path_24.moveTo(93.04600000000002, 17.142000000000003);
    path_24.lineTo(93.33000000000003, 16.095000000000002);
    path_24.lineTo(88.25200000000002, 14.715000000000003);
    path_24.lineTo(87.96700000000003, 15.763000000000003);
    path_24.lineTo(87.68300000000002, 16.811000000000003);
    path_24.lineTo(92.76100000000002, 18.191000000000003);
    path_24.lineTo(93.04600000000002, 17.142000000000003);
    path_24.close();
    path_24.moveTo(87.96700000000003, 15.763000000000003);
    path_24.lineTo(86.91900000000003, 15.478000000000003);
    path_24.lineTo(86.42900000000003, 17.279000000000003);
    path_24.lineTo(87.47700000000003, 17.564000000000004);
    path_24.lineTo(88.52500000000003, 17.849000000000004);
    path_24.lineTo(89.01500000000003, 16.049000000000003);
    path_24.lineTo(87.96700000000003, 15.763000000000003);
    path_24.close();
    path_24.moveTo(87.47700000000003, 17.563000000000002);
    path_24.lineTo(87.51000000000003, 18.649);
    path_24.cubicTo(
      87.78800000000004,
      18.641000000000002,
      88.06000000000003,
      18.650000000000002,
      88.32600000000004,
      18.676000000000002,
    );
    path_24.lineTo(88.43400000000004, 17.596000000000004);
    path_24.lineTo(88.54100000000004, 16.516000000000005);
    path_24.arcToPoint(
      Offset(87.44400000000005, 16.479000000000006),
      radius: Radius.elliptical(8.506, 8.506),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(87.47700000000005, 17.564000000000007);
    path_24.close();
    path_24.moveTo(88.43400000000003, 17.596000000000004);
    path_24.lineTo(88.35000000000002, 18.678000000000004);
    path_24.cubicTo(
      88.61900000000003,
      18.699000000000005,
      88.88300000000002,
      18.738000000000003,
      89.14200000000002,
      18.792000000000005,
    );
    path_24.lineTo(89.36800000000002, 17.730000000000004);
    path_24.lineTo(89.59400000000002, 16.668000000000003);
    path_24.arcToPoint(
      Offset(88.51700000000002, 16.513),
      radius: Radius.elliptical(8.2, 8.2),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(88.43400000000003, 17.596);
    path_24.close();
    path_24.moveTo(89.36800000000002, 17.730000000000004);
    path_24.lineTo(89.14200000000002, 18.792000000000005);
    path_24.cubicTo(
      89.64500000000002,
      18.899000000000004,
      90.07400000000003,
      19.077000000000005,
      90.44200000000002,
      19.315000000000005,
    );
    path_24.lineTo(91.03300000000002, 18.405000000000005);
    path_24.lineTo(91.62500000000001, 17.495000000000005);
    path_24.arcToPoint(
      Offset(89.59400000000001, 16.668000000000006),
      radius: Radius.elliptical(5.971, 5.971),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(89.36800000000001, 17.730000000000008);
    path_24.close();
    path_24.moveTo(91.03300000000003, 18.405000000000005);
    path_24.lineTo(90.45500000000003, 19.325000000000006);
    path_24.cubicTo(
      90.83400000000003,
      19.563000000000006,
      91.13000000000002,
      19.847000000000005,
      91.35800000000003,
      20.179000000000006,
    );
    path_24.lineTo(92.25300000000003, 19.563000000000006);
    path_24.lineTo(93.14700000000003, 18.948000000000008);
    path_24.arcToPoint(
      Offset(91.61100000000003, 17.486000000000008),
      radius: Radius.elliptical(5.205, 5.205),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(91.03300000000003, 18.40600000000001);
    path_24.close();
    path_24.moveTo(92.25300000000003, 19.564000000000004);
    path_24.lineTo(91.36300000000003, 20.186000000000003);
    path_24.cubicTo(
      91.59500000000003,
      20.516000000000002,
      91.75500000000002,
      20.893000000000004,
      91.83900000000003,
      21.331000000000003,
    );
    path_24.lineTo(92.90500000000003, 21.125000000000004);
    path_24.lineTo(93.97200000000002, 20.920000000000005);
    path_24.arcToPoint(
      Offset(93.14200000000002, 18.940000000000005),
      radius: Radius.elliptical(5.101, 5.101),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_24.lineTo(92.25300000000003, 19.563000000000006);
    path_24.close();
    path_24.moveTo(92.90500000000003, 21.125000000000004);
    path_24.lineTo(91.84300000000003, 21.348000000000003);
    path_24.cubicTo(
      91.92800000000003,
      21.756000000000004,
      91.92700000000004,
      22.217000000000002,
      91.81500000000003,
      22.745,
    );
    path_24.lineTo(92.87700000000002, 22.971);
    path_24.lineTo(93.93900000000002, 23.196);
    path_24.cubicTo(
      94.10500000000002,
      22.414,
      94.12400000000002,
      21.646,
      93.96900000000002,
      20.903000000000002,
    );
    path_24.lineTo(92.90500000000003, 21.125000000000004);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(88.776, 11.375);
    path_25.lineTo(108.166, 11.375);
    path_25.lineTo(108.166, 33.183);
    path_25.lineTo(88.776, 33.183);
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(104.553, 21.238);
    path_26.arcToPoint(
      Offset(99.03399999999999, 26.83),
      radius: Radius.elliptical(11840.413, 11840.413),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_26.cubicTo(
      98.53899999999999,
      27.33,
      98.08399999999999,
      27.787999999999997,
      97.66699999999999,
      28.201999999999998,
    );
    path_26.cubicTo(
      97.25999999999999,
      28.612,
      96.91699999999999,
      28.961,
      96.63699999999999,
      29.246,
    );
    path_26.cubicTo(
      96.35699999999999,
      29.532,
      96.18299999999999,
      29.708,
      96.11299999999999,
      29.776,
    );
    path_26.lineTo(91.27499999999999, 27.172);
    path_26.lineTo(100.05499999999999, 19.788);
    path_26.lineTo(94.76199999999999, 17.665);
    path_26.lineTo(96.67399999999999, 13.567);
    path_26.lineTo(106.163, 17.786);
    path_26.lineTo(104.553, 21.238);
    path_26.close();

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(104.553, 21.238);
    path_27.arcToPoint(
      Offset(99.03399999999999, 26.83),
      radius: Radius.elliptical(11840.413, 11840.413),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_27.cubicTo(
      98.53899999999999,
      27.33,
      98.08399999999999,
      27.787999999999997,
      97.66699999999999,
      28.201999999999998,
    );
    path_27.cubicTo(
      97.25999999999999,
      28.612,
      96.91699999999999,
      28.961,
      96.63699999999999,
      29.246,
    );
    path_27.cubicTo(
      96.35699999999999,
      29.532,
      96.18299999999999,
      29.708,
      96.11299999999999,
      29.776,
    );
    path_27.lineTo(91.27499999999999, 27.172);
    path_27.lineTo(100.05499999999999, 19.788);
    path_27.lineTo(94.76199999999999, 17.665);
    path_27.lineTo(96.67399999999999, 13.567);
    path_27.lineTo(106.163, 17.786);
    path_27.lineTo(104.553, 21.238);
    path_27.close();

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xffECCA93).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(104.553, 21.238);
    path_28.lineTo(105.325, 22.002);
    path_28.lineTo(105.45700000000001, 21.868);
    path_28.lineTo(105.537, 21.697999999999997);
    path_28.lineTo(104.55300000000001, 21.237999999999996);
    path_28.close();
    path_28.moveTo(100.547, 25.295);
    path_28.lineTo(101.319, 26.058000000000003);
    path_28.lineTo(101.32000000000001, 26.058000000000003);
    path_28.lineTo(100.54700000000001, 25.295);
    path_28.close();
    path_28.moveTo(99.03399999999999, 26.830000000000002);
    path_28.lineTo(99.806, 27.594);
    path_28.lineTo(99.80799999999999, 27.591);
    path_28.lineTo(99.03399999999999, 26.831);
    path_28.close();
    path_28.moveTo(97.66699999999999, 28.202);
    path_28.lineTo(96.90099999999998, 27.432000000000002);
    path_28.lineTo(96.89599999999999, 27.438000000000002);
    path_28.lineTo(97.66599999999998, 28.202);
    path_28.close();
    path_28.moveTo(96.11299999999999, 29.775000000000002);
    path_28.lineTo(95.59799999999998, 30.732000000000003);
    path_28.lineTo(96.29599999999998, 31.107000000000003);
    path_28.lineTo(96.86599999999997, 30.557000000000002);
    path_28.lineTo(96.11299999999997, 29.776000000000003);
    path_28.close();
    path_28.moveTo(91.27499999999999, 27.173000000000002);
    path_28.lineTo(90.576, 26.342000000000002);
    path_28.lineTo(89.35199999999999, 27.371000000000002);
    path_28.lineTo(90.75999999999999, 28.129);
    path_28.lineTo(91.27499999999999, 27.172);
    path_28.close();
    path_28.moveTo(100.05499999999999, 19.788000000000004);
    path_28.lineTo(100.75399999999999, 20.618000000000002);
    path_28.lineTo(102.139, 19.453000000000003);
    path_28.lineTo(100.45899999999999, 18.78);
    path_28.lineTo(100.05499999999999, 19.788);
    path_28.close();
    path_28.moveTo(94.76199999999999, 17.665000000000003);
    path_28.lineTo(93.77799999999999, 17.206000000000003);
    path_28.lineTo(93.29299999999999, 18.246000000000002);
    path_28.lineTo(94.35799999999999, 18.673000000000002);
    path_28.lineTo(94.76199999999999, 17.665000000000003);
    path_28.close();
    path_28.moveTo(96.67399999999999, 13.567000000000004);
    path_28.lineTo(97.11399999999999, 12.575000000000003);
    path_28.lineTo(96.13999999999999, 12.142000000000003);
    path_28.lineTo(95.68999999999998, 13.108000000000002);
    path_28.lineTo(96.67399999999998, 13.568000000000003);
    path_28.close();
    path_28.moveTo(106.163, 17.786000000000005);
    path_28.lineTo(107.14699999999999, 18.245000000000005);
    path_28.lineTo(107.615, 17.243000000000006);
    path_28.lineTo(106.604, 16.793000000000006);
    path_28.lineTo(106.163, 17.786000000000005);
    path_28.close();
    path_28.moveTo(104.553, 21.238000000000007);
    path_28.lineTo(103.78, 20.476000000000006);
    path_28.lineTo(99.774, 24.532000000000007);
    path_28.lineTo(100.547, 25.29500000000001);
    path_28.lineTo(101.32, 26.05800000000001);
    path_28.lineTo(105.32499999999999, 22.00200000000001);
    path_28.lineTo(104.55299999999998, 21.23800000000001);
    path_28.close();
    path_28.moveTo(100.547, 25.29500000000001);
    path_28.lineTo(99.77499999999999, 24.532000000000007);
    path_28.lineTo(98.25999999999999, 26.069000000000006);
    path_28.lineTo(99.03399999999999, 26.830000000000005);
    path_28.lineTo(99.80799999999999, 27.591000000000005);
    path_28.lineTo(101.31899999999999, 26.058000000000003);
    path_28.lineTo(100.54699999999998, 25.295);
    path_28.close();
    path_28.moveTo(99.03399999999999, 26.83000000000001);
    path_28.lineTo(98.26199999999999, 26.067000000000007);
    path_28.cubicTo(
      97.76899999999999,
      26.56500000000001,
      97.31499999999998,
      27.020000000000007,
      96.90199999999999,
      27.432000000000006,
    );
    path_28.lineTo(97.66699999999999, 28.202000000000005);
    path_28.lineTo(98.43199999999999, 28.972000000000005);
    path_28.cubicTo(
      98.85199999999999,
      28.555000000000003,
      99.30899999999998,
      28.096000000000004,
      99.80599999999998,
      27.594000000000005,
    );
    path_28.lineTo(99.03399999999998, 26.830000000000005);
    path_28.close();
    path_28.moveTo(97.66699999999999, 28.20200000000001);
    path_28.lineTo(96.89599999999999, 27.43700000000001);
    path_28.cubicTo(
      96.48699999999998,
      27.849000000000007,
      96.14199999999998,
      28.19900000000001,
      95.86099999999999,
      28.48700000000001,
    );
    path_28.lineTo(96.63699999999999, 29.24700000000001);
    path_28.lineTo(97.41299999999998, 30.00600000000001);
    path_28.cubicTo(
      97.68999999999998,
      29.722000000000012,
      98.03199999999998,
      29.376000000000012,
      98.43799999999999,
      28.96600000000001,
    );
    path_28.lineTo(97.66699999999999, 28.202000000000012);
    path_28.close();
    path_28.moveTo(96.63699999999999, 29.24600000000001);
    path_28.lineTo(95.86099999999999, 28.486000000000008);
    path_28.cubicTo(
      95.57699999999998,
      28.776000000000007,
      95.41499999999999,
      28.94000000000001,
      95.359,
      28.994000000000007,
    );
    path_28.lineTo(96.113, 29.776000000000007);
    path_28.lineTo(96.866, 30.557000000000006);
    path_28.cubicTo(
      96.95,
      30.477000000000007,
      97.138,
      30.287000000000006,
      97.413,
      30.006000000000007,
    );
    path_28.lineTo(96.637, 29.246000000000006);
    path_28.close();
    path_28.moveTo(96.11299999999999, 29.77600000000001);
    path_28.lineTo(96.62699999999998, 28.81900000000001);
    path_28.lineTo(91.78899999999999, 26.216000000000008);
    path_28.lineTo(91.27499999999999, 27.172000000000008);
    path_28.lineTo(90.75999999999999, 28.12900000000001);
    path_28.lineTo(95.59799999999998, 30.73200000000001);
    path_28.lineTo(96.11299999999999, 29.77600000000001);
    path_28.close();
    path_28.moveTo(91.27499999999999, 27.17200000000001);
    path_28.lineTo(91.97399999999999, 28.00300000000001);
    path_28.lineTo(100.75399999999999, 20.61900000000001);
    path_28.lineTo(100.05499999999999, 19.78800000000001);
    path_28.lineTo(99.356, 18.95700000000001);
    path_28.lineTo(90.576, 26.342000000000013);
    path_28.lineTo(91.27499999999999, 27.17200000000001);
    path_28.close();
    path_28.moveTo(100.05499999999999, 19.78800000000001);
    path_28.lineTo(100.45899999999999, 18.780000000000012);
    path_28.lineTo(95.16599999999998, 16.65700000000001);
    path_28.lineTo(94.76199999999999, 17.66500000000001);
    path_28.lineTo(94.35799999999999, 18.67300000000001);
    path_28.lineTo(99.651, 20.79500000000001);
    path_28.lineTo(100.05499999999999, 19.788000000000007);
    path_28.close();
    path_28.moveTo(94.76199999999999, 17.66500000000001);
    path_28.lineTo(95.74599999999998, 18.12500000000001);
    path_28.lineTo(97.65799999999999, 14.02600000000001);
    path_28.lineTo(96.67399999999999, 13.56700000000001);
    path_28.lineTo(95.689, 13.108000000000011);
    path_28.lineTo(93.779, 17.20600000000001);
    path_28.lineTo(94.762, 17.66600000000001);
    path_28.close();
    path_28.moveTo(96.67399999999999, 13.56700000000001);
    path_28.lineTo(96.232, 14.559000000000012);
    path_28.lineTo(105.722, 18.778000000000013);
    path_28.lineTo(106.163, 17.786000000000012);
    path_28.lineTo(106.604, 16.79400000000001);
    path_28.lineTo(97.114, 12.57500000000001);
    path_28.lineTo(96.674, 13.56700000000001);
    path_28.close();
    path_28.moveTo(106.163, 17.786000000000012);
    path_28.lineTo(105.179, 17.32600000000001);
    path_28.lineTo(103.569, 20.780000000000012);
    path_28.lineTo(104.553, 21.23800000000001);
    path_28.lineTo(105.53699999999999, 21.69800000000001);
    path_28.lineTo(107.14699999999999, 18.24500000000001);
    path_28.lineTo(106.163, 17.78500000000001);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Color(0xff413726).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
