import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GameplayEnergyPainter extends CustomPainter {
  final int energy;
  GameplayEnergyPainter({this.energy = 5});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(133.49, 28.982);
    path_0.lineTo(56.691, 28.982);
    path_0.cubicTo(
      56.028000000000006,
      28.982,
      55.42,
      29.34,
      55.077000000000005,
      29.912,
    );
    path_0.cubicTo(
      54.38700000000001,
      31.061,
      54.986000000000004,
      53.391999999999996,
      55.069,
      53.536,
    );
    path_0.cubicTo(
      55.412000000000006,
      54.107,
      56.021,
      54.457,
      56.684000000000005,
      54.457,
    );
    path_0.lineTo(133.49, 54.457);
    path_0.arcToPoint(
      Offset(135.371, 52.577),
      radius: Radius.elliptical(1.885, 1.885),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(135.371, 30.87);
    path_0.arcToPoint(
      Offset(133.49, 28.982),
      radius: Radius.elliptical(1.887, 1.887),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(133.62, 30.69);
    path_1.lineTo(57.196, 30.69);
    path_1.lineTo(57.196, 52.515);
    path_1.lineTo(133.62, 52.515);
    path_1.lineTo(133.62, 30.69);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(64.79, 50.786);
    path_2.lineTo(64.79, 32.28);
    path_2.cubicTo(
      64.79,
      31.886000000000003,
      65.12700000000001,
      31.567,
      65.543,
      31.567,
    );
    path_2.lineTo(74.138, 31.567);
    path_2.cubicTo(
      74.554,
      31.567,
      74.89200000000001,
      31.887,
      74.89200000000001,
      32.28,
    );
    path_2.lineTo(74.89200000000001, 50.787000000000006);
    path_2.cubicTo(
      74.89200000000001,
      51.181000000000004,
      74.555,
      51.50000000000001,
      74.138,
      51.50000000000001,
    );
    path_2.lineTo(65.543, 51.50000000000001);
    path_2.cubicTo(
      65.12700000000001,
      51.50000000000001,
      64.789,
      51.18000000000001,
      64.789,
      50.787000000000006,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xff6BABFF).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(74.138, 51.498);
    path_3.lineTo(74.138, 31.566);
    path_3.cubicTo(74.554, 31.566, 74.891, 31.886, 74.891, 32.278999999999996);
    path_3.lineTo(74.891, 50.786);
    path_3.cubicTo(74.891, 51.181000000000004, 74.554, 51.5, 74.138, 51.5);
    path_3.close();
    path_3.moveTo(64.79, 50.785999999999994);
    path_3.lineTo(64.79, 32.28);
    path_3.cubicTo(
      64.79,
      31.886000000000003,
      65.12700000000001,
      31.567,
      65.543,
      31.567,
    );
    path_3.lineTo(65.57300000000001, 31.567);
    path_3.lineTo(65.57300000000001, 51.5);
    path_3.lineTo(65.543, 51.5);
    path_3.cubicTo(65.12700000000001, 51.5, 64.789, 51.18, 64.789, 50.787);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xff6BABFF).withOpacity(energy >= 4 ? 1.0 : 0.2);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(66.203, 51.499);
    path_4.lineTo(73.48, 51.499);
    path_4.lineTo(73.48, 31.567);
    path_4.lineTo(66.203, 31.567);
    path_4.lineTo(66.203, 51.5);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xff6BABFF).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(68.501, 51.499);
    path_5.lineTo(71.18100000000001, 51.499);
    path_5.lineTo(71.18100000000001, 31.567);
    path_5.lineTo(68.501, 31.567);
    path_5.lineTo(68.501, 51.5);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xff6BABFF).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(76.295, 50.786);
    path_6.lineTo(76.295, 32.28);
    path_6.cubicTo(76.295, 31.886000000000003, 76.632, 31.567, 77.049, 31.567);
    path_6.lineTo(85.644, 31.567);
    path_6.cubicTo(
      86.06,
      31.567,
      86.39800000000001,
      31.887,
      86.39800000000001,
      32.28,
    );
    path_6.lineTo(86.39800000000001, 50.787000000000006);
    path_6.cubicTo(
      86.39800000000001,
      51.181000000000004,
      86.06000000000002,
      51.50000000000001,
      85.644,
      51.50000000000001,
    );
    path_6.lineTo(77.05, 51.50000000000001);
    path_6.cubicTo(
      76.633,
      51.50000000000001,
      76.29599999999999,
      51.18000000000001,
      76.29599999999999,
      50.787000000000006,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xff6BABFF).withOpacity(energy >= 4 ? 1.0 : 0.2);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(85.643, 51.498);
    path_7.lineTo(85.643, 31.566);
    path_7.cubicTo(86.06, 31.566, 86.397, 31.886, 86.397, 32.278999999999996);
    path_7.lineTo(86.397, 50.786);
    path_7.cubicTo(86.397, 51.181000000000004, 86.06, 51.5, 85.643, 51.5);
    path_7.close();
    path_7.moveTo(76.295, 50.785999999999994);
    path_7.lineTo(76.295, 32.28);
    path_7.cubicTo(76.295, 31.886000000000003, 76.632, 31.567, 77.049, 31.567);
    path_7.lineTo(77.07900000000001, 31.567);
    path_7.lineTo(77.07900000000001, 51.5);
    path_7.lineTo(77.049, 51.5);
    path_7.cubicTo(76.632, 51.5, 76.295, 51.18, 76.295, 50.787);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xff6BABFF).withOpacity(energy >= 5 ? 1.0 : 0.2);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(77.709, 51.499);
    path_8.lineTo(84.986, 51.499);
    path_8.lineTo(84.986, 31.567);
    path_8.lineTo(77.709, 31.567);
    path_8.lineTo(77.709, 51.5);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xff6BABFF).withOpacity(energy >= 4 ? 1.0 : 0.2);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(80.007, 51.499);
    path_9.lineTo(82.68700000000001, 51.499);
    path_9.lineTo(82.68700000000001, 31.567);
    path_9.lineTo(80.007, 31.567);
    path_9.lineTo(80.007, 51.5);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xff6BABFF).withOpacity(energy >= 4 ? 1.0 : 0.2);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(87.8, 50.786);
    path_10.lineTo(87.8, 32.28);
    path_10.cubicTo(
      87.8,
      31.886000000000003,
      88.13799999999999,
      31.567,
      88.554,
      31.567,
    );
    path_10.lineTo(97.149, 31.567);
    path_10.cubicTo(97.566, 31.567, 97.903, 31.887, 97.903, 32.28);
    path_10.lineTo(97.903, 50.787000000000006);
    path_10.cubicTo(
      97.903,
      51.181000000000004,
      97.566,
      51.50000000000001,
      97.149,
      51.50000000000001,
    );
    path_10.lineTo(88.554, 51.50000000000001);
    path_10.cubicTo(
      88.138,
      51.50000000000001,
      87.8,
      51.18000000000001,
      87.8,
      50.787000000000006,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xff6BABFF).withOpacity(energy >= 5 ? 1.0 : 0.2);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(97.15, 51.498);
    path_11.lineTo(97.15, 31.566);
    path_11.cubicTo(
      97.56500000000001,
      31.566,
      97.903,
      31.886,
      97.903,
      32.278999999999996,
    );
    path_11.lineTo(97.903, 50.786);
    path_11.cubicTo(
      97.903,
      51.181000000000004,
      97.56500000000001,
      51.5,
      97.149,
      51.5,
    );
    path_11.close();
    path_11.moveTo(87.80000000000001, 50.785999999999994);
    path_11.lineTo(87.80000000000001, 32.28);
    path_11.cubicTo(
      87.80000000000001,
      31.886000000000003,
      88.138,
      31.567,
      88.55400000000002,
      31.567,
    );
    path_11.lineTo(88.58400000000002, 31.567);
    path_11.lineTo(88.58400000000002, 51.5);
    path_11.lineTo(88.55400000000002, 51.5);
    path_11.cubicTo(
      88.13800000000002,
      51.5,
      87.80000000000001,
      51.18,
      87.80000000000001,
      50.787,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xff6BABFF).withOpacity(energy >= 5 ? 1.0 : 0.2);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(89.214, 51.499);
    path_12.lineTo(96.491, 51.499);
    path_12.lineTo(96.491, 31.567);
    path_12.lineTo(89.214, 31.567);
    path_12.lineTo(89.214, 51.5);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xff6BABFF).withOpacity(energy >= 5 ? 1.0 : 0.2);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(91.512, 51.499);
    path_13.lineTo(94.19200000000001, 51.499);
    path_13.lineTo(94.19200000000001, 31.567);
    path_13.lineTo(91.512, 31.567);
    path_13.lineTo(91.512, 51.5);
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xff6BABFF).withOpacity(energy >= 5 ? 1.0 : 0.2);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(41.474, 20);
    path_14.cubicTo(29.618, 20, 20, 29.618, 20, 41.474);
    path_14.cubicTo(
      20,
      53.330999999999996,
      29.618000000000002,
      62.940999999999995,
      41.474000000000004,
      62.940999999999995,
    );
    path_14.cubicTo(
      53.331,
      62.940999999999995,
      62.941,
      53.330999999999996,
      62.941,
      41.474,
    );
    path_14.cubicTo(62.94, 29.618, 53.33, 20, 41.474, 20);
    path_14.close();
    path_14.moveTo(41.474, 60.27);
    path_14.cubicTo(
      31.089999999999996,
      60.27,
      22.670999999999996,
      51.85,
      22.670999999999996,
      41.474000000000004,
    );
    path_14.cubicTo(
      22.670999999999996,
      31.090000000000003,
      31.089999999999996,
      22.671000000000003,
      41.474,
      22.671000000000003,
    );
    path_14.cubicTo(
      51.858999999999995,
      22.671000000000003,
      60.269999999999996,
      31.090000000000003,
      60.269999999999996,
      41.474000000000004,
    );
    path_14.cubicTo(60.269, 51.85, 51.86, 60.27, 41.474, 60.27);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(61.72, 41.474);
    path_15.cubicTo(
      61.72,
      52.650999999999996,
      52.66,
      61.72,
      41.474000000000004,
      61.72,
    );
    path_15.cubicTo(
      30.288000000000004,
      61.72,
      21.220000000000002,
      52.650999999999996,
      21.220000000000002,
      41.474000000000004,
    );
    path_15.cubicTo(
      21.220000000000002,
      30.288000000000004,
      30.288000000000004,
      21.220000000000002,
      41.474000000000004,
      21.220000000000002,
    );
    path_15.cubicTo(
      52.661,
      21.220000000000002,
      61.72,
      30.288000000000004,
      61.72,
      41.474000000000004,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(61.204, 41.474);
    path_16.cubicTo(
      61.204,
      52.366,
      52.376000000000005,
      61.202999999999996,
      41.475,
      61.202999999999996,
    );
    path_16.cubicTo(
      30.573999999999998,
      61.202999999999996,
      21.736,
      52.366,
      21.736,
      41.474,
    );
    path_16.cubicTo(
      21.736,
      30.572999999999997,
      30.573999999999998,
      21.734999999999996,
      41.476,
      21.734999999999996,
    );
    path_16.cubicTo(
      52.376,
      21.734999999999996,
      61.204,
      30.572999999999993,
      61.204,
      41.474999999999994,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(60.269, 41.474);
    path_17.cubicTo(60.269, 51.849, 51.858999999999995, 60.269, 41.474, 60.269);
    path_17.cubicTo(
      31.089,
      60.269,
      22.669999999999998,
      51.849,
      22.669999999999998,
      41.474,
    );
    path_17.cubicTo(
      22.669999999999998,
      31.089,
      31.089,
      22.669999999999998,
      41.474,
      22.669999999999998,
    );
    path_17.cubicTo(
      51.858999999999995,
      22.669999999999998,
      60.269,
      31.089,
      60.269,
      41.473,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(60.269, 41.474);
    path_18.cubicTo(60.269, 51.849, 51.858999999999995, 60.269, 41.474, 60.269);
    path_18.cubicTo(
      31.089,
      60.269,
      22.669999999999998,
      51.849,
      22.669999999999998,
      41.474,
    );
    path_18.cubicTo(
      22.669999999999998,
      31.089,
      31.089,
      22.669999999999998,
      41.474,
      22.669999999999998,
    );
    path_18.cubicTo(
      51.858999999999995,
      22.669999999999998,
      60.269,
      31.089,
      60.269,
      41.473,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(52.463, 28.251);
    path_19.arcToPoint(
      Offset(50.987, 27.256),
      radius: Radius.elliptical(2.03, 2.03),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_19.cubicTo(47.472, 26.752, 40.981, 27.273, 37.423, 27.628);
    path_19.arcToPoint(
      Offset(34.239000000000004, 29.876),
      radius: Radius.elliptical(3.983, 3.983),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_19.lineTo(30.406000000000006, 39.918);
    path_19.cubicTo(
      29.699000000000005,
      41.369,
      30.885000000000005,
      43.241,
      32.528000000000006,
      43.144999999999996,
    );
    path_19.lineTo(36.309000000000005, 43.361999999999995);
    path_19.arcToPoint(
      Offset(35.69500000000001, 45.09199999999999),
      radius: Radius.elliptical(35.29, 35.29),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_19.lineTo(35.68300000000001, 45.08999999999999);
    path_19.cubicTo(
      35.358000000000004,
      46.13599999999999,
      35.02700000000001,
      47.27199999999999,
      34.793000000000006,
      48.32999999999999,
    );
    path_19.arcToPoint(
      Offset(34.043000000000006, 53.10999999999999),
      radius: Radius.elliptical(34.98, 34.98),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_19.cubicTo(
      33.86900000000001,
      54.59899999999999,
      35.184000000000005,
      55.96499999999999,
      36.663000000000004,
      55.891999999999996,
    );
    path_19.cubicTo(
      36.801,
      55.879,
      36.998000000000005,
      55.87199999999999,
      37.124,
      55.831999999999994,
    );
    path_19.cubicTo(
      37.466,
      55.75599999999999,
      37.784,
      55.614999999999995,
      38.069,
      55.41,
    );
    path_19.cubicTo(
      40.017,
      54,
      42.166000000000004,
      52.117999999999995,
      44.455000000000005,
      49.815,
    );
    path_19.cubicTo(
      47.504000000000005,
      46.684999999999995,
      49.86500000000001,
      44.019999999999996,
      51.282000000000004,
      41.931999999999995,
    );
    path_19.cubicTo(
      51.393,
      41.751999999999995,
      51.431000000000004,
      41.644,
      51.495000000000005,
      41.407,
    );
    path_19.cubicTo(
      51.81700000000001,
      40.331999999999994,
      51.304,
      39.081999999999994,
      50.316,
      38.532,
    );
    path_19.arcToPoint(
      Offset(50.193000000000005, 38.459999999999994),
      radius: Radius.elliptical(1.797, 1.797),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_19.lineTo(49.245000000000005, 38.03999999999999);
    path_19.lineTo(49.063, 37.92199999999999);
    path_19.cubicTo(
      50.105000000000004,
      35.68499999999999,
      51.95,
      31.69199999999999,
      52.598,
      30.04199999999999,
    );
    path_19.arcToPoint(
      Offset(52.463, 28.251999999999992),
      radius: Radius.elliptical(2.052, 2.052),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = Color(0xffF68B55).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(54.509, 41.473);
    path_20.cubicTo(54.509, 48.67, 48.676, 54.509, 41.473, 54.509);
    path_20.cubicTo(34.269999999999996, 54.509, 28.432, 48.669, 28.432, 41.473);
    path_20.cubicTo(28.432, 34.269999999999996, 34.271, 28.432, 41.473, 28.432);
    path_20.cubicTo(48.676, 28.432, 54.509, 34.269999999999996, 54.509, 41.473);
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = Color(0xff412636).withOpacity(1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(43.017, 57.89);
    path_21.arcToPoint(
      Offset(39.92700000000001, 57.785000000000004),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_21.arcToPoint(
      Offset(43.01700000000001, 57.89),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(43.017, 57.89);
    path_22.arcToPoint(
      Offset(39.92700000000001, 57.785000000000004),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_22.arcToPoint(
      Offset(43.01700000000001, 57.89),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(43.017, 57.894);
    path_23.arcToPoint(
      Offset(41.423, 59.384),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(39.924, 57.789),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(39.958999999999996, 57.543),
      radius: Radius.elliptical(1.13, 1.13),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_23.arcToPoint(
      Offset(42.998999999999995, 57.646),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_23.cubicTo(43.013, 57.726, 43.019, 57.806, 43.016999999999996, 57.894);
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(42.325, 57.241);
    path_24.cubicTo(
      42.312000000000005,
      57.614,
      41.931000000000004,
      57.739,
      41.467000000000006,
      57.723,
    );
    path_24.cubicTo(
      41.00300000000001,
      57.708,
      40.632000000000005,
      57.557,
      40.644000000000005,
      57.184,
    );
    path_24.cubicTo(
      40.656000000000006,
      56.812,
      41.043000000000006,
      56.522,
      41.507000000000005,
      56.538,
    );
    path_24.cubicTo(
      41.971000000000004,
      56.553,
      42.337,
      56.867999999999995,
      42.325,
      57.241,
    );
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = Color(0xffffffff).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(31.394, 53.459);
    path_25.arcToPoint(
      Offset(28.416999999999998, 52.624),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_25.arcToPoint(
      Offset(31.394, 53.459),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(31.394, 53.459);
    path_26.arcToPoint(
      Offset(28.416999999999998, 52.624),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: false,
    );
    path_26.arcToPoint(
      Offset(31.394, 53.459),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(31.442, 53.1);
    path_27.arcToPoint(
      Offset(29.848, 54.589),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_27.arcToPoint(
      Offset(28.348, 52.995),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_27.arcToPoint(
      Offset(28.384, 52.748999999999995),
      radius: Radius.elliptical(1.13, 1.13),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_27.arcToPoint(
      Offset(31.424, 52.852),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_27.cubicTo(
      31.438,
      52.931999999999995,
      31.444,
      53.01199999999999,
      31.442,
      53.099,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(30.75, 52.447);
    path_28.cubicTo(30.736, 52.82, 30.355, 52.945, 29.892, 52.929);
    path_28.cubicTo(
      29.428,
      52.914,
      29.056,
      52.763000000000005,
      29.067999999999998,
      52.39,
    );
    path_28.cubicTo(
      29.081,
      52.018,
      29.467999999999996,
      51.728,
      29.930999999999997,
      51.744,
    );
    path_28.cubicTo(
      30.395999999999997,
      51.76,
      30.760999999999996,
      52.074,
      30.749,
      52.447,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = Color(0xffffffff).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(26.272, 41.522);
    path_29.arcToPoint(
      Offset(23.182, 41.418),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_29.arcToPoint(
      Offset(26.272, 41.522),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(26.272, 41.522);
    path_30.arcToPoint(
      Offset(23.182, 41.418),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_30.arcToPoint(
      Offset(26.272, 41.522),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(26.272, 41.525);
    path_31.arcToPoint(
      Offset(24.677999999999997, 43.015),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_31.arcToPoint(
      Offset(23.179, 41.42),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_31.arcToPoint(
      Offset(23.214, 41.175000000000004),
      radius: Radius.elliptical(1.14, 1.14),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_31.arcToPoint(
      Offset(26.253999999999998, 41.278000000000006),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_31.cubicTo(
      26.269,
      41.358000000000004,
      26.275,
      41.437000000000005,
      26.272,
      41.525000000000006,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = Color(0xffF8AE00).withOpacity(1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(25.58, 40.872);
    path_32.cubicTo(
      25.566999999999997,
      41.245,
      25.186999999999998,
      41.37,
      24.723,
      41.354,
    );
    path_32.cubicTo(24.259, 41.338, 23.887, 41.188, 23.898999999999997, 40.815);
    path_32.cubicTo(
      23.912,
      40.442,
      24.298999999999996,
      40.153,
      24.761999999999997,
      40.169,
    );
    path_32.cubicTo(
      25.225999999999996,
      40.184,
      25.591999999999995,
      40.498999999999995,
      25.58,
      40.872,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(43.017, 25.152);
    path_33.arcToPoint(
      Offset(39.92700000000001, 25.047),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_33.arcToPoint(
      Offset(43.01700000000001, 25.152),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(43.017, 25.152);
    path_34.arcToPoint(
      Offset(39.92700000000001, 25.047),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_34.arcToPoint(
      Offset(43.01700000000001, 25.152),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(43.017, 25.155);
    path_35.arcToPoint(
      Offset(41.423, 26.645),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.arcToPoint(
      Offset(39.924, 25.05),
      radius: Radius.elliptical(1.553, 1.553),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.arcToPoint(
      Offset(39.958999999999996, 24.805),
      radius: Radius.elliptical(1.13, 1.13),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_35.arcToPoint(
      Offset(42.998999999999995, 24.908),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_35.cubicTo(43.013, 24.988, 43.019, 25.068, 43.016999999999996, 25.155);
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(42.325, 24.503);
    path_36.cubicTo(
      42.312000000000005,
      24.876,
      41.931000000000004,
      25.001,
      41.467000000000006,
      24.985,
    );
    path_36.cubicTo(
      41.00300000000001,
      24.969,
      40.632000000000005,
      24.819,
      40.644000000000005,
      24.445999999999998,
    );
    path_36.cubicTo(
      40.657000000000004,
      24.072999999999997,
      41.043000000000006,
      23.784,
      41.507000000000005,
      23.799,
    );
    path_36.cubicTo(
      41.971000000000004,
      23.814999999999998,
      42.337,
      24.131,
      42.325,
      24.503,
    );
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = Color(0xffffffff).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(55.634, 31.732);
    path_37.arcToPoint(
      Offset(52.544, 31.627),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_37.arcToPoint(
      Offset(55.634, 31.732),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = Color(0xffF8AE00).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(55.634, 31.732);
    path_38.arcToPoint(
      Offset(52.544, 31.627),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_38.arcToPoint(
      Offset(55.634, 31.732),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = Color(0xffF8AE00).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(55.634, 31.736);
    path_39.arcToPoint(
      Offset(54.04, 33.226),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.arcToPoint(
      Offset(52.54, 31.631),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_39.cubicTo(52.544, 31.543, 52.556, 31.465, 52.576, 31.386);
    path_39.arcToPoint(
      Offset(55.616, 31.489),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_39.cubicTo(55.63, 31.568, 55.636, 31.648, 55.634, 31.736);
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = Color(0xffF8AE00).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(54.942, 31.083);
    path_40.cubicTo(54.929, 31.456, 54.548, 31.581, 54.084, 31.564999999999998);
    path_40.cubicTo(
      53.620000000000005,
      31.549,
      53.249,
      31.398999999999997,
      53.261,
      31.025999999999996,
    );
    path_40.cubicTo(
      53.273,
      30.652999999999995,
      53.660000000000004,
      30.363999999999997,
      54.124,
      30.379999999999995,
    );
    path_40.cubicTo(
      54.589000000000006,
      30.394999999999996,
      54.954,
      30.709999999999994,
      54.942,
      31.082999999999995,
    );
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = Color(0xffffffff).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(30.283, 31.732);
    path_41.arcToPoint(
      Offset(27.193, 31.627),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_41.arcToPoint(
      Offset(30.283, 31.732),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(30.283, 31.732);
    path_42.arcToPoint(
      Offset(27.193, 31.627),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_42.arcToPoint(
      Offset(30.283, 31.732),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(30.283, 31.736);
    path_43.arcToPoint(
      Offset(28.689, 33.226),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_43.arcToPoint(
      Offset(27.19, 31.631),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_43.arcToPoint(
      Offset(27.225, 31.386),
      radius: Radius.elliptical(1.13, 1.13),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_43.arcToPoint(
      Offset(30.265, 31.489),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_43.cubicTo(30.28, 31.568, 30.285, 31.648, 30.283, 31.736);
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = Color(0xffF8AE00).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(29.59, 31.083);
    path_44.cubicTo(
      29.576999999999998,
      31.456,
      29.197,
      31.581,
      28.733,
      31.564999999999998,
    );
    path_44.cubicTo(
      28.269000000000002,
      31.549,
      27.897000000000002,
      31.398999999999997,
      27.91,
      31.025999999999996,
    );
    path_44.cubicTo(
      27.922,
      30.652999999999995,
      28.309,
      30.363999999999997,
      28.773,
      30.379999999999995,
    );
    path_44.cubicTo(
      29.237,
      30.394999999999996,
      29.602999999999998,
      30.709999999999994,
      29.59,
      31.082999999999995,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(59.79, 41.522);
    path_45.arcToPoint(
      Offset(56.701, 41.418),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_45.arcToPoint(
      Offset(59.791, 41.522),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(59.79, 41.522);
    path_46.arcToPoint(
      Offset(56.701, 41.418),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_46.arcToPoint(
      Offset(59.791, 41.522),
      radius: Radius.elliptical(1.545, 1.545),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(59.79, 41.525);
    path_47.arcToPoint(
      Offset(58.196, 43.015),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_47.arcToPoint(
      Offset(56.698, 41.42),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_47.arcToPoint(
      Offset(56.733, 41.175000000000004),
      radius: Radius.elliptical(1.08, 1.08),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_47.arcToPoint(
      Offset(59.772999999999996, 41.278000000000006),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_47.cubicTo(
      59.787,
      41.358000000000004,
      59.793,
      41.437000000000005,
      59.79,
      41.525000000000006,
    );
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = Color(0xffF8AE00).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(59.098, 40.872);
    path_48.cubicTo(59.085, 41.245, 58.704, 41.37, 58.24, 41.354);
    path_48.cubicTo(57.776, 41.338, 57.405, 41.188, 57.417, 40.815);
    path_48.cubicTo(57.429, 40.442, 57.817, 40.153, 58.28, 40.169);
    path_48.cubicTo(
      58.745000000000005,
      40.184,
      59.11,
      40.498999999999995,
      59.098,
      40.872,
    );
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = Color(0xffffffff).withOpacity(energy >= 3 ? 1.0 : 0.2);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(54.591, 53.096);
    path_49.arcToPoint(
      Offset(51.501000000000005, 52.991),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_49.arcToPoint(
      Offset(54.59100000000001, 53.096),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = Color(0xffF8AE00).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(54.591, 53.096);
    path_50.arcToPoint(
      Offset(51.501000000000005, 52.991),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: true,
      clockwise: true,
    );
    path_50.arcToPoint(
      Offset(54.59100000000001, 53.096),
      radius: Radius.elliptical(1.546, 1.546),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = Color(0xffF8AE00).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(54.592, 53.1);
    path_51.arcToPoint(
      Offset(52.997, 54.59),
      radius: Radius.elliptical(1.55, 1.55),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_51.arcToPoint(
      Offset(51.499, 52.996),
      radius: Radius.elliptical(1.552, 1.552),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_51.cubicTo(51.502, 52.908, 51.513000000000005, 52.829, 51.534, 52.75);
    path_51.arcToPoint(
      Offset(54.574, 52.853),
      radius: Radius.elliptical(1.543, 1.543),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_51.cubicTo(54.588, 52.933, 54.594, 53.013, 54.591, 53.1);
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.color = Color(0xffF8AE00).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(53.9, 52.448);
    path_52.cubicTo(53.887, 52.821, 53.506, 52.946, 53.042, 52.931);
    path_52.cubicTo(52.578, 52.915, 52.206, 52.763999999999996, 52.219, 52.391);
    path_52.cubicTo(52.231, 52.019, 52.618, 51.729, 53.082, 51.745);
    path_52.cubicTo(
      53.546,
      51.760999999999996,
      53.912,
      52.074999999999996,
      53.9,
      52.448,
    );
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = Color(0xffffffff).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(37.516, 28.57);
    path_53.cubicTo(40.656, 28.257, 47.363, 27.693, 50.851, 28.193);
    path_53.cubicTo(51.557, 28.295, 51.976, 29.032, 51.714999999999996, 29.695);
    path_53.cubicTo(
      50.812,
      31.992,
      47.464999999999996,
      39.095,
      47.464999999999996,
      39.095,
    );
    path_53.lineTo(49.355, 39.158);
    path_53.cubicTo(50.512, 39.394, 51.035, 40.75, 50.324999999999996, 41.695);
    path_53.cubicTo(47.913, 44.905, 42.488, 51.041, 37.513, 54.64);
    path_53.cubicTo(36.402, 55.444, 34.866, 54.558, 34.985, 53.192);
    path_53.cubicTo(35.21, 50.6, 35.864, 46.672, 37.689, 42.493);
    path_53.lineTo(32.541, 42.198);
    path_53.arcToPoint(
      Offset(31.278, 40.286),
      radius: Radius.elliptical(1.339, 1.339),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_53.lineTo(35.092, 30.282000000000004);
    path_53.arcToPoint(
      Offset(37.516, 28.570000000000004),
      radius: Radius.elliptical(3.008, 3.008),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = Color(0xff6BABFF).withOpacity(energy >= 1 ? 1.0 : 0.2);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(50.666, 30.211);
    path_54.cubicTo(
      50.605999999999995,
      30.365,
      50.532,
      30.540999999999997,
      50.449,
      30.738,
    );
    path_54.cubicTo(49.189, 33.716, 47.065999999999995, 36.278, 44.302, 37.953);
    path_54.lineTo(44.25, 37.984);
    path_54.cubicTo(
      40.238,
      40.394000000000005,
      36.004,
      41.454,
      32.624,
      41.157000000000004,
    );
    path_54.arcToPoint(
      Offset(32.31, 39.716),
      radius: Radius.elliptical(1.21, 1.21),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_54.lineTo(35.735, 30.731);
    path_54.arcToPoint(
      Offset(37.915, 29.201),
      radius: Radius.elliptical(2.692, 2.692),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_54.cubicTo(40.73, 28.917, 46.754, 28.408, 49.885, 28.861);
    path_54.arcToPoint(
      Offset(50.666, 30.211000000000002),
      radius: Radius.elliptical(0.994, 0.994),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2357821, size.height * 0.2240602),
      Offset(size.width * 0.2812372, size.height * 0.5242651),
      [Color(0xffffffff).withOpacity(energy >= 2 ? 1.0 : 0.2), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(50.322, 41.691);
    path_55.cubicTo(
      47.915000000000006,
      44.903000000000006,
      42.492000000000004,
      51.037000000000006,
      37.512,
      54.641000000000005,
    );
    path_55.cubicTo(
      36.398,
      55.440000000000005,
      34.863,
      54.559000000000005,
      34.985,
      53.191,
    );
    path_55.arcToPoint(
      Offset(36.345, 46.158),
      radius: Radius.elliptical(34.272, 34.272),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_55.cubicTo(41.062, 46.902, 46.397, 44.366, 49.595, 39.416000000000004);
    path_55.cubicTo(
      49.626999999999995,
      39.362,
      49.658,
      39.316,
      49.690999999999995,
      39.263000000000005,
    );
    path_55.cubicTo(
      50.602999999999994,
      39.665000000000006,
      50.964,
      40.843,
      50.321999999999996,
      41.691,
    );
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = Color(0xff6BABFF).withOpacity(energy >= 2 ? 1.0 : 0.2);
    canvas.drawPath(path_55, paint55Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
