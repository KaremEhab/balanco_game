import 'package:flutter/material.dart';

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0.5, 0.5);
    path_0.lineTo(51.22, 0.5);
    path_0.lineTo(51.22, 917.547);
    path_0.lineTo(0.5, 917.547);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffF0CF91).withValues(alpha: 1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0.5, 0.5);
    path_1.lineTo(51.22, 0.5);
    path_1.lineTo(51.22, 917.547);
    path_1.lineTo(0.5, 917.547);
    path_1.close();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint1Stroke.color = Color(0xffffffff).withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Color(0xff000000).withValues(alpha: 1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(8.458, 5.952);
    path_2.lineTo(43.262, 5.952);
    path_2.lineTo(43.262, 910.858);
    path_2.lineTo(8.458, 910.858);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffC6A26B).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
