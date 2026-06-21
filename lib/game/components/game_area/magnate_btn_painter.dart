import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MagnateBtnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF02300).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.02173913,
          size.height * 0.02000000,
          size.width * 0.9565217,
          size.height * 0.8800000,
        ),
        bottomRight: Radius.circular(size.width * 0.3260870),
        bottomLeft: Radius.circular(size.width * 0.3260870),
        topLeft: Radius.circular(size.width * 0.3260870),
        topRight: Radius.circular(size.width * 0.3260870),
      ),
      paint_0_fill,
    );

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_1_stroke.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.01086957,
          size.height * 0.01000000,
          size.width * 0.9782609,
          size.height * 0.9000000,
        ),
        bottomRight: Radius.circular(size.width * 0.3369565),
        bottomLeft: Radius.circular(size.width * 0.3369565),
        topLeft: Radius.circular(size.width * 0.3369565),
        topRight: Radius.circular(size.width * 0.3369565),
      ),
      paint_1_stroke,
    );

    canvas.save();
    // Shift icon to visually center it more inside the button background
    canvas.translate(size.width * 0.015, size.height * -0.08);

    Path path_2 = Path();
    path_2.moveTo(33.539, 13.162);
    path_2.cubicTo(
      36.879000000000005,
      22.636000000000003,
      35.581,
      28.568,
      32.649,
      32.114000000000004,
    );
    path_2.cubicTo(
      29.771,
      35.594,
      25.504,
      36.537000000000006,
      23.335,
      36.43900000000001,
    );
    path_2.cubicTo(
      21.247,
      36.34400000000001,
      18.490000000000002,
      35.93200000000001,
      16.086000000000002,
      34.50900000000001,
    );
    path_2.cubicTo(
      13.640000000000002,
      33.06100000000001,
      11.620000000000001,
      30.599000000000007,
      11.016000000000002,
      26.567000000000007,
    );
    path_2.cubicTo(
      10.077000000000002,
      20.317000000000007,
      11.716000000000001,
      15.012000000000008,
      12.399000000000001,
      13.157000000000007,
    );
    path_2.cubicTo(
      12.712000000000002,
      12.309000000000006,
      13.591000000000001,
      11.893000000000008,
      14.412,
      12.075000000000006,
    );
    path_2.lineTo(18.532, 12.989000000000006);
    path_2.cubicTo(
      19.576999999999998,
      13.221000000000005,
      20.155,
      14.299000000000007,
      19.86,
      15.281000000000006,
    );
    path_2.cubicTo(
      18.064,
      21.241000000000007,
      18.679,
      24.321000000000005,
      19.647,
      25.878000000000007,
    );
    path_2.cubicTo(
      20.488999999999997,
      27.23100000000001,
      21.712,
      27.61200000000001,
      22.314999999999998,
      27.694000000000006,
    );
    path_2.lineTo(22.531, 27.714000000000006);
    path_2.cubicTo(
      24.430999999999997,
      27.762000000000004,
      25.578,
      27.199000000000005,
      26.298,
      26.404000000000007,
    );
    path_2.cubicTo(
      27.046,
      25.576000000000008,
      27.45,
      24.369000000000007,
      27.586,
      22.928000000000008,
    );
    path_2.cubicTo(
      27.86,
      20.03600000000001,
      27.019,
      16.652000000000008,
      26.520999999999997,
      14.980000000000008,
    );
    path_2.cubicTo(
      26.217999999999996,
      13.964000000000008,
      26.842,
      12.850000000000009,
      27.932999999999996,
      12.652000000000008,
    );
    path_2.lineTo(31.535999999999998, 11.995000000000008);
    path_2.arcToPoint(
      Offset(33.539, 13.162000000000008),
      radius: Radius.elliptical(1.793, 1.793),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03886957;
    paint_2_stroke.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02173913,
      [Color(0xffFE9988).withOpacity(1), Color(0xff662115).withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_2, paint_2_fill);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
