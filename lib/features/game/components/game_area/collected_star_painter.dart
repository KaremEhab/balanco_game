import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class CollectedStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = GameColors.starFilledPainterColor1.withValues(
      alpha: 1.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1478125,
          size.height * 0.04366667,
          size.width * 0.7291667,
          size.height * 0.7291667,
        ),
        bottomRight: Radius.circular(size.width * 0.3645833),
        bottomLeft: Radius.circular(size.width * 0.3645833),
        topLeft: Radius.circular(size.width * 0.3645833),
        topRight: Radius.circular(size.width * 0.3645833),
      ),
      paint0Fill,
    );

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01656250;
    paint1Stroke.color = GameColors.collectedItemPainterColor2.withValues(
      alpha: 1.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1395417,
          size.height * 0.03537500,
          size.width * 0.7457292,
          size.height * 0.7457292,
        ),
        bottomRight: Radius.circular(size.width * 0.3728750),
        bottomLeft: Radius.circular(size.width * 0.3728750),
        topLeft: Radius.circular(size.width * 0.3728750),
        topRight: Radius.circular(size.width * 0.3728750),
      ),
      paint1Stroke,
    );

    Path path_2 = Path();
    path_2.moveTo(24.613, 9.586);
    path_2.arcToPoint(
      Offset(26.698, 10.774000000000001),
      radius: Radius.elliptical(2.422, 2.422),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(26.778, 10.923);
    path_2.lineTo(26.779999999999998, 10.927);
    path_2.lineTo(28.386999999999997, 14.204);
    path_2.arcToPoint(
      Offset(29.433999999999997, 14.964),
      radius: Radius.elliptical(1.39, 1.39),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(33.041999999999994, 15.482000000000001);
    path_2.arcToPoint(
      Offset(34.492, 19.472),
      radius: Radius.elliptical(2.41, 2.41),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(34.376, 19.595000000000002);
    path_2.lineTo(31.766999999999996, 22.127000000000002);
    path_2.lineTo(31.764999999999997, 22.129);
    path_2.arcToPoint(
      Offset(31.368, 23.385),
      radius: Radius.elliptical(1.375, 1.375),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(31.371, 23.397000000000002);
    path_2.lineTo(31.977999999999998, 26.993000000000002);
    path_2.lineTo(31.977999999999998, 26.994000000000003);
    path_2.arcToPoint(
      Offset(28.493, 29.532000000000004),
      radius: Radius.elliptical(2.41, 2.41),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(28.488, 29.529000000000003);
    path_2.lineTo(25.262, 27.809000000000005);
    path_2.arcToPoint(
      Offset(23.964, 27.809000000000005),
      radius: Radius.elliptical(1.401, 1.401),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(23.962999999999997, 27.809000000000005);
    path_2.lineTo(20.734999999999996, 29.505000000000006);
    path_2.lineTo(20.732999999999997, 29.507000000000005);
    path_2.arcToPoint(
      Offset(17.247999999999998, 26.969000000000005),
      radius: Radius.elliptical(2.41, 2.41),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(17.247999999999998, 26.968000000000004);
    path_2.lineTo(17.854999999999997, 23.398000000000003);
    path_2.lineTo(17.855999999999998, 23.394000000000002);
    path_2.arcToPoint(
      Offset(17.572, 22.289),
      radius: Radius.elliptical(1.377, 1.377),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(17.459, 22.165000000000003);
    path_2.lineTo(14.85, 19.633000000000003);
    path_2.lineTo(14.85, 19.632);
    path_2.arcToPoint(
      Offset(16.184, 15.482000000000001),
      radius: Radius.elliptical(2.409, 2.409),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(19.792, 14.964);
    path_2.lineTo(19.957, 14.93);
    path_2.arcToPoint(
      Offset(20.839000000000002, 14.204),
      radius: Radius.elliptical(1.39, 1.39),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(22.446, 10.927);
    path_2.lineTo(22.448, 10.923);
    path_2.arcToPoint(
      Offset(24.613, 9.586),
      radius: Radius.elliptical(2.423, 2.423),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();

    Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02125000;
    paint2Stroke.color = GameColors.collectedItemPainterColor2.withValues(
      alpha: 1.0,
    );
    canvas.drawPath(path_2, paint2Stroke);

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = GameColors.collectedItemPainterColor4.withValues(
      alpha: 1.0,
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(18.658, 21.693);
    path_3.cubicTo(
      18.73,
      21.915000000000003,
      18.746000000000002,
      22.151,
      18.706,
      22.380000000000003,
    );
    path_3.lineTo(20.926, 15.538000000000004);
    path_3.arcToPoint(
      Offset(19.843999999999998, 16.323000000000004),
      radius: Radius.elliptical(1.435, 1.435),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(17.116999999999997, 16.715000000000003);
    path_3.arcToPoint(
      Offset(16.322999999999997, 19.194000000000003),
      radius: Radius.elliptical(1.436, 1.436),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.lineTo(18.293999999999997, 21.108000000000004);
    path_3.cubicTo(
      18.461999999999996,
      21.270000000000003,
      18.586999999999996,
      21.471000000000004,
      18.657999999999998,
      21.693000000000005,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2266250, size.height * 0.2070833),
      Offset(size.width * 0.4860208, size.height * 0.3357708),
      [
        GameColors.whiteSolid.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 0),
      ],
      [0.611, 0.807],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(21.57, 15.316);
    path_4.arcToPoint(
      Offset(20.932, 15.576),
      radius: Radius.elliptical(1.425, 1.425),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.lineTo(28.125, 15.538);
    path_4.arcToPoint(
      Offset(27.041, 14.758000000000001),
      radius: Radius.elliptical(1.434, 1.434),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.lineTo(25.813, 12.291);
    path_4.arcToPoint(
      Offset(23.209999999999997, 12.314),
      radius: Radius.elliptical(1.435, 1.435),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_4.lineTo(22.010999999999996, 14.786999999999999);
    path_4.cubicTo(
      21.909999999999997,
      14.997,
      21.757999999999996,
      15.177999999999999,
      21.569999999999997,
      15.315999999999999,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.6310000, size.height * 0.08835417),
      Offset(size.width * 0.5901875, size.height * 0.3750208),
      [
        GameColors.whiteSolid.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 0),
      ],
      [0.611, 0.807],
    );
    canvas.drawPath(path_4, paint4Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
