// ignore_for_file: non_constant_identifier_names
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SmallPyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 115.333);
    path_0.lineTo(43.765, 52.775999999999996);
    path_0.lineTo(77.2, 0);
    path_0.lineTo(126.361, 116.314);
    path_0.lineTo(0, 115.333);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3112414, size.height * 0.9774034),
      Offset(size.width * 0.3112414, size.height * 0.0008403361),
      [
        Color(0xff8B1757).withValues(alpha: 1),
        Color(0xffD65C9A).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(121.149, 116.426);
    path_1.lineTo(202.19, 118.752);
    path_1.lineTo(77.202, 0);
    path_1.lineTo(96.13499999999999, 48.908);
    path_1.lineTo(94.17299999999999, 49.623000000000005);
    path_1.lineTo(108.53699999999999, 91.65);
    path_1.lineTo(114.36699999999999, 96.62400000000001);
    path_1.lineTo(121.14899999999999, 116.42600000000002);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6881724, size.height * 0.9979496),
      Offset(size.width * 0.6881724, size.height * 0.0008403361),
      [
        Color(0xff52003B).withValues(alpha: 1),
        Color(0xff6A1B72).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(59.476, 29.26);
    path_2.lineTo(88.54, 29.26);
    path_2.lineTo(84.63000000000001, 18.54);
    path_2.lineTo(99.12, 20.81);
    path_2.lineTo(77.203, 0);
    path_2.lineTo(59.476, 29.26);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffB3407A).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MediumPyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(109.487, 0);
    path_0.lineTo(166.072, 53.173);
    path_0.lineTo(165.593, 54.4);
    path_0.lineTo(277.327, 164.511);
    path_0.lineTo(234.41, 164.511);
    path_0.lineTo(126.047, 44.914);
    path_0.lineTo(109.487, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6956978, size.height * 0.9970545),
      Offset(size.width * 0.6956978, size.height * 0.002424242),
      [
        Color(0xff52003B).withValues(alpha: 1),
        Color(0xff6A1B72).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(0, 158.416);
    path_1.lineTo(81.548, 42.189);
    path_1.lineTo(80.113, 41.003);
    path_1.lineTo(109.487, 0);
    path_1.lineTo(143.5, 47.618);
    path_1.lineTo(140.629, 47.618);
    path_1.lineTo(234.409, 164.511);
    path_1.lineTo(0, 158.416);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4215971, size.height * 0.9970545),
      Offset(size.width * 0.4215971, size.height * 0.002424242),
      [
        Color(0xff8B1757).withValues(alpha: 1),
        Color(0xffD65C9A).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(80.112, 41.003);
    path_2.lineTo(143.499, 47.618);
    path_2.lineTo(166.071, 53.173);
    path_2.lineTo(109.486, 0);
    path_2.lineTo(80.112, 41.003);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffB166D9).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(165.592, 54.4);
    path_3.lineTo(143.853, 48.991);
    path_3.lineTo(141.731, 48.991);
    path_3.lineTo(103.41199999999999, 45.829);
    path_3.lineTo(81.02799999999999, 42.896);
    path_3.lineTo(80.112, 41.003);
    path_3.lineTo(128.375, 46.349000000000004);
    path_3.lineTo(142.272, 44.852000000000004);
    path_3.lineTo(147.265, 47.764);
    path_3.lineTo(166.071, 53.173);
    path_3.lineTo(165.59199999999998, 54.4);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4427554, size.height * 0.3296667),
      Offset(size.width * 0.4427554, size.height * 0.2485636),
      [
        Color(0xff52003B).withValues(alpha: 1),
        Color(0xff6A1B72).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LargePyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 219.423);
    path_0.lineTo(105.984, 79.763);
    path_0.lineTo(137.59699999999998, 39.43300000000001);
    path_0.lineTo(167.446, 0);
    path_0.lineTo(232.46699999999998, 111.209);
    path_0.lineTo(325.241, 219.423);
    path_0.lineTo(0, 219.423);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4076015, size.height * 0.9973273),
      Offset(size.width * 0.4076015, size.height * 0.005909091),
      [
        Color(0xff8B1757).withValues(alpha: 1),
        Color(0xffD65C9A).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(398.349, 219.922);
    path_1.lineTo(305.642, 219.423);
    path_1.lineTo(292.897, 198.292);
    path_1.lineTo(289.86899999999997, 197.327);
    path_1.lineTo(280.452, 184.117);
    path_1.lineTo(264.08, 166.015);
    path_1.lineTo(267.60699999999997, 166.015);
    path_1.lineTo(232.46799999999996, 111.20899999999999);
    path_1.lineTo(227.77599999999995, 109.978);
    path_1.lineTo(167.446, 0);
    path_1.lineTo(219.257, 47.751);
    path_1.lineTo(333.86, 169.841);
    path_1.lineTo(347.47, 173.30200000000002);
    path_1.lineTo(352.062, 177.794);
    path_1.lineTo(357.819, 183.45100000000002);
    path_1.lineTo(367.07, 192.502);
    path_1.lineTo(376.52, 201.75300000000001);
    path_1.lineTo(397.717, 219.423);
    path_1.lineTo(398.349, 219.922);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.7090401, size.height * 0.9997136),
      Offset(size.width * 0.7090401, size.height * 0.003636364),
      [
        Color(0xff52003B).withValues(alpha: 1),
        Color(0xff6A1B72).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(162.621, 103.689);
    path_2.lineTo(163.985, 87.749);
    path_2.lineTo(195.23200000000003, 86.086);
    path_2.lineTo(198.95900000000003, 103.689);
    path_2.lineTo(162.62100000000004, 103.689);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffB3407A).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(334.556, 170.141);
    path_3.lineTo(308.834, 172.10399999999998);
    path_3.lineTo(348.166, 173.601);
    path_3.lineTo(334.556, 170.141);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFB86BD).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ZoserPyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(61.682, 0);
    path_0.lineTo(78.254, 0.954);
    path_0.lineTo(80.845, 12.974);
    path_0.lineTo(92.81099999999999, 12.974);
    path_0.lineTo(96.53599999999999, 28.178);
    path_0.lineTo(107.56599999999999, 28.178);
    path_0.lineTo(110.841, 45.075);
    path_0.lineTo(42.15799999999999, 44.175000000000004);
    path_0.lineTo(45.721, 1.26);
    path_0.lineTo(61.681, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6892162, size.height * 0.9799565),
      Offset(size.width * 0.6892162, size.height * 0.006521739),
      [
        Color(0xff52003B).withValues(alpha: 1),
        Color(0xff6A1B72).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(0, 44.23);
    path_1.lineTo(3.797, 27.728999999999996);
    path_1.lineTo(14.827, 27.548999999999996);
    path_1.lineTo(17.4, 13.71);
    path_1.lineTo(26.900999999999996, 13.71);
    path_1.lineTo(31.956999999999997, 2.3560000000000016);
    path_1.lineTo(61.683, 0);
    path_1.lineTo(61.683, 13.316);
    path_1.lineTo(73.703, 13.711);
    path_1.lineTo(75.287, 28.358);
    path_1.lineTo(88.26, 28.358);
    path_1.lineTo(91.427, 45.075);
    path_1.lineTo(0, 44.229);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.4118468, size.height * 0.9799565),
      Offset(size.width * 0.4118468, size.height * 0.006521739),
      [
        Color(0xff8B1757).withValues(alpha: 1),
        Color(0xffD65C9A).withValues(alpha: 1),
      ],
      [0.028, 1],
    );
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(107.568, 28.18);
    path_2.lineTo(88.25999999999999, 28.36);
    path_2.lineTo(3.2029999999999887, 28.503999999999998);
    path_2.lineTo(75.12499999999999, 26.775999999999996);
    path_2.lineTo(107.56799999999998, 28.179999999999996);
    path_2.close();
    path_2.moveTo(17.4, 13.712);
    path_2.lineTo(73.702, 13.712);
    path_2.lineTo(92.812, 12.975);
    path_2.lineTo(80.648, 12.093);
    path_2.lineTo(27.296, 13.316);
    path_2.lineTo(17.399, 13.712000000000002);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFB86BD).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
