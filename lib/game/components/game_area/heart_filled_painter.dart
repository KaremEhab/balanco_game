import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class HeartFilledPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF02300).withOpacity(1.0);
    final RRect baseRRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        size.width * 0.09415000,
        size.height * 0.01990000,
        size.width * 0.8750000,
        size.height * 0.8750000,
      ),
      bottomRight: Radius.circular(size.width * 0.3713000),
      bottomLeft: Radius.circular(size.width * 0.3713000),
      topLeft: Radius.circular(size.width * 0.3713000),
      topRight: Radius.circular(size.width * 0.3713000),
    );
    canvas.drawRRect(baseRRect, paint_0_fill);

    // Inner white shadow (bevel highlight on top-left)
    canvas.save();
    canvas.clipRRect(baseRRect);
    canvas.translate(1.5, 1.5);
    Paint innerShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.white.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawRRect(baseRRect, innerShadowPaint);
    canvas.restore();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01987500;
    paint_1_stroke.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.08420000,
          size.height * 0.009950000,
          size.width * 0.8948750,
          size.height * 0.8948750,
        ),
        bottomRight: Radius.circular(size.width * 0.3812250),
        bottomLeft: Radius.circular(size.width * 0.3812250),
        topLeft: Radius.circular(size.width * 0.3812250),
        topRight: Radius.circular(size.width * 0.3812250),
      ),
      paint_1_stroke,
    );

    canvas.save();
    // The inner heart's hardcoded bounding box center is approx (20.674, 18.401)
    // The red box's center is at (size.width * 0.53165, size.height * 0.4574)
    double tx = (size.width * 0.53165) - 20.674;
    double ty = (size.height * 0.4574) - 18.401;
    canvas.translate(tx, ty);

    Path path_2 = Path();
    path_2.moveTo(32.072, 15.838);
    path_2.arcToPoint(
      Offset(31.564000000000004, 18.397),
      radius: Radius.elliptical(7.046, 7.046),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      30.234,
      21.724999999999998,
      26.483000000000004,
      25.894,
      20.778000000000006,
      28.159,
    );
    path_2.lineTo(20.672000000000004, 28.197);
    path_2.arcToPoint(
      Offset(20.566000000000003, 28.159),
      radius: Radius.elliptical(3.184, 3.184),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      14.862000000000002,
      25.895,
      11.111000000000002,
      21.724999999999998,
      9.780000000000003,
      18.397,
    );
    path_2.arcToPoint(
      Offset(9.293000000000003, 16.290999999999997),
      radius: Radius.elliptical(6.925, 6.925),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(9.273000000000003, 15.837999999999997),
      radius: Radius.elliptical(4.205, 4.205),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      9.268000000000002,
      15.752999999999997,
      9.273000000000003,
      15.662999999999997,
      9.277000000000003,
      15.577999999999998,
    );
    path_2.cubicTo(
      9.334000000000003,
      13.117999999999999,
      10.694000000000003,
      10.835999999999999,
      12.937000000000003,
      9.857999999999997,
    );
    path_2.cubicTo(
      15.804000000000002,
      8.605999999999996,
      19.108000000000004,
      9.921999999999997,
      20.647000000000002,
      12.805999999999997,
    );
    path_2.cubicTo(
      20.660000000000004,
      12.826999999999998,
      20.685000000000002,
      12.826999999999998,
      20.697000000000003,
      12.805999999999997,
    );
    path_2.cubicTo(
      22.237000000000002,
      9.921999999999997,
      25.541000000000004,
      8.605999999999998,
      28.407000000000004,
      9.857999999999997,
    );
    path_2.cubicTo(
      30.651000000000003,
      10.835999999999997,
      32.011,
      13.117999999999997,
      32.06700000000001,
      15.577999999999996,
    );
    path_2.cubicTo(
      32.07200000000001,
      15.662999999999997,
      32.07500000000001,
      15.752999999999997,
      32.07200000000001,
      15.837999999999996,
    );
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffF8B5B5).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(32.072, 15.838);
    path_3.arcToPoint(
      Offset(31.564000000000004, 18.397),
      radius: Radius.elliptical(7.046, 7.046),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      30.234,
      21.724999999999998,
      26.483000000000004,
      25.894,
      20.778000000000006,
      28.159,
    );
    path_3.lineTo(20.672000000000004, 28.197);
    path_3.arcToPoint(
      Offset(20.566000000000003, 28.159),
      radius: Radius.elliptical(3.184, 3.184),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      14.862000000000002,
      25.895,
      11.111000000000002,
      21.724999999999998,
      9.780000000000003,
      18.397,
    );
    path_3.arcToPoint(
      Offset(9.293000000000003, 16.290999999999997),
      radius: Radius.elliptical(6.925, 6.925),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(9.273000000000003, 15.837999999999997),
      radius: Radius.elliptical(4.205, 4.205),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      9.268000000000002,
      15.752999999999997,
      9.273000000000003,
      15.662999999999997,
      9.277000000000003,
      15.577999999999998,
    );
    path_3.cubicTo(
      9.334000000000003,
      13.117999999999999,
      10.694000000000003,
      10.835999999999999,
      12.937000000000003,
      9.857999999999997,
    );
    path_3.cubicTo(
      15.804000000000002,
      8.605999999999996,
      19.108000000000004,
      9.921999999999997,
      20.647000000000002,
      12.805999999999997,
    );
    path_3.cubicTo(
      20.660000000000004,
      12.826999999999998,
      20.685000000000002,
      12.826999999999998,
      20.697000000000003,
      12.805999999999997,
    );
    path_3.cubicTo(
      22.237000000000002,
      9.921999999999997,
      25.541000000000004,
      8.605999999999998,
      28.407000000000004,
      9.857999999999997,
    );
    path_3.cubicTo(
      30.651000000000003,
      10.835999999999997,
      32.011,
      13.117999999999997,
      32.06700000000001,
      15.577999999999996,
    );
    path_3.cubicTo(
      32.07200000000001,
      15.662999999999997,
      32.07500000000001,
      15.752999999999997,
      32.07200000000001,
      15.837999999999996,
    );
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffF8B5B5).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(29.287, 16.74);
    path_4.arcToPoint(
      Offset(28.904, 18.673),
      radius: Radius.elliptical(5.328, 5.328),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      27.898,
      21.189,
      25.063,
      24.339999999999996,
      20.752000000000002,
      26.051,
    );
    path_4.lineTo(20.672000000000004, 26.08);
    path_4.arcToPoint(
      Offset(20.591000000000005, 26.049999999999997),
      radius: Radius.elliptical(2.073, 2.073),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      16.280000000000005,
      24.339999999999996,
      13.445000000000004,
      21.188999999999997,
      12.439000000000005,
      18.673999999999996,
    );
    path_4.arcToPoint(
      Offset(12.071000000000005, 17.081999999999997),
      radius: Radius.elliptical(5.222, 5.222),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.arcToPoint(
      Offset(12.056000000000004, 16.74),
      radius: Radius.elliptical(3.243, 3.243),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.cubicTo(
      12.053000000000004,
      16.674999999999997,
      12.056000000000004,
      16.607,
      12.059000000000005,
      16.543,
    );
    path_4.cubicTo(
      12.102000000000004,
      14.683,
      13.129000000000005,
      12.959999999999999,
      14.826000000000004,
      12.219999999999999,
    );
    path_4.cubicTo(
      16.992000000000004,
      11.274,
      19.489000000000004,
      12.267999999999999,
      20.653000000000006,
      14.447999999999999,
    );
    path_4.cubicTo(
      20.663000000000007,
      14.463999999999999,
      20.681000000000004,
      14.463999999999999,
      20.690000000000005,
      14.447999999999999,
    );
    path_4.cubicTo(
      21.854000000000006,
      12.267999999999999,
      24.352000000000004,
      11.274,
      26.517000000000003,
      12.219999999999999,
    );
    path_4.cubicTo(
      28.213000000000005,
      12.959999999999999,
      29.241000000000003,
      14.683,
      29.284000000000002,
      16.543,
    );
    path_4.cubicTo(
      29.287000000000003,
      16.608,
      29.290000000000003,
      16.676,
      29.287000000000003,
      16.74,
    );
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffF8B5B5).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(11.732, 13.695);
    path_5.cubicTo(11.732, 12.675, 12.559, 11.849, 13.578999999999999, 11.849);
    path_5.lineTo(16.04, 11.849);
    path_5.cubicTo(17.06, 11.849, 17.887, 12.675, 17.887, 13.695);
    path_5.lineTo(17.887, 17.388);
    path_5.cubicTo(17.887, 18.408, 17.060000000000002, 19.234, 16.04, 19.234);
    path_5.lineTo(13.579999999999998, 19.234);
    path_5.arcToPoint(
      Offset(11.732999999999999, 17.388),
      radius: Radius.elliptical(1.846, 1.846),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_5.lineTo(11.732999999999999, 13.695000000000002);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6318000, size.height * 0.09620000),
      Offset(size.width * 0.7084500, size.height * 0.4649000),
      [Color(0xffffffff).withOpacity(1), Color(0xffffffff).withOpacity(0)],
      [0.253, 0.807],
    );
    canvas.drawPath(path_5, paint_5_fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
