import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class StarFilledPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Scale the canvas so the hardcoded paths fluidly scale with the widget's Size
    double scale = size.width / 35.0;
    canvas.scale(scale, scale);
    Size virtualSize = const Size(35.0, 35.0);

    // Center the whole icon in the 35x35 canvas.
    // Red box center is at ~16.008, so we shift it to 17.5.
    canvas.translate(1.492, 1.491);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = GameColors.starFilledPainterColor1.withValues(
      alpha: 1.0,
    );
    final RRect baseRRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        virtualSize.width * 0.01987500,
        virtualSize.height * 0.01990000,
        virtualSize.width * 0.8750000,
        virtualSize.height * 0.8750000,
      ),
      bottomRight: Radius.circular(virtualSize.width * 0.3713000),
      bottomLeft: Radius.circular(virtualSize.width * 0.3713000),
      topLeft: Radius.circular(virtualSize.width * 0.3713000),
      topRight: Radius.circular(virtualSize.width * 0.3713000),
    );
    canvas.drawRRect(baseRRect, paint0Fill);

    // Inner white shadow (bevel highlight on top-left)
    canvas.save();
    canvas.clipRRect(baseRRect);
    canvas.translate(1.5, 1.5);
    Paint innerShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = GameColors.white.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawRRect(baseRRect, innerShadowPaint);
    canvas.restore();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = virtualSize.width * 0.01987500;
    paint1Stroke.color = GameColors.whiteSolid.withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          virtualSize.width * 0.009950000,
          virtualSize.height * 0.009950000,
          virtualSize.width * 0.8948750,
          virtualSize.height * 0.8948750,
        ),
        bottomRight: Radius.circular(virtualSize.width * 0.3812250),
        bottomLeft: Radius.circular(virtualSize.width * 0.3812250),
        topLeft: Radius.circular(virtualSize.width * 0.3812250),
        topRight: Radius.circular(virtualSize.width * 0.3812250),
      ),
      paint1Stroke,
    );

    canvas.save();
    // Center the star within the red box.
    // Inner star center is at ~18.582, 18.213, Red box center is at 16.008, 16.009
    canvas.translate(-2.574, -2.204);

    Path path_2 = Path();
    path_2.moveTo(20.258, 9.429);
    path_2.lineTo(21.833, 12.642);
    path_2.arcToPoint(
      Offset(23.235, 13.66),
      radius: Radius.elliptical(1.86, 1.86),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(26.771, 14.168);
    path_2.arcToPoint(
      Offset(27.801000000000002, 17.345),
      radius: Radius.elliptical(1.861, 1.861),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(25.245, 19.826);
    path_2.arcToPoint(
      Offset(24.712, 21.514),
      radius: Radius.elliptical(1.848, 1.848),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(25.307, 25.037);
    path_2.arcToPoint(
      Offset(22.615, 26.997),
      radius: Radius.elliptical(1.861, 1.861),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(19.45, 25.31);
    path_2.arcToPoint(
      Offset(17.713, 25.31),
      radius: Radius.elliptical(1.873, 1.873),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(14.549000000000001, 26.973);
    path_2.arcToPoint(
      Offset(11.857000000000001, 25.012999999999998),
      radius: Radius.elliptical(1.86, 1.86),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(12.452000000000002, 21.512999999999998);
    path_2.arcToPoint(
      Offset(11.919000000000002, 19.863),
      radius: Radius.elliptical(1.849, 1.849),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(9.363000000000003, 17.381999999999998);
    path_2.arcToPoint(
      Offset(10.393000000000002, 14.167999999999997),
      radius: Radius.elliptical(1.862, 1.862),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(13.929000000000002, 13.659999999999997);
    path_2.arcToPoint(
      Offset(15.331000000000001, 12.641999999999996),
      radius: Radius.elliptical(1.862, 1.862),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(16.906000000000002, 9.428999999999995);
    path_2.arcToPoint(
      Offset(20.256000000000004, 9.428999999999995),
      radius: Radius.elliptical(1.874, 1.874),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = GameColors.starFilledPainterColor2.withValues(
      alpha: 1.0,
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(12.747, 19.759);
    path_3.arcToPoint(
      Offset(12.794, 20.433),
      radius: Radius.elliptical(1.4, 1.4),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(14.969000000000001, 13.727);
    path_3.arcToPoint(
      Offset(13.909, 14.497),
      radius: Radius.elliptical(1.407, 1.407),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(11.237, 14.881);
    path_3.arcToPoint(
      Offset(10.459, 17.31),
      radius: Radius.elliptical(1.408, 1.408),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.lineTo(12.39, 19.186);
    path_3.cubicTo(12.554, 19.345, 12.677000000000001, 19.541, 12.747, 19.759);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.linear(
      Offset(virtualSize.width * 0.1280750, virtualSize.height * 0.2060500),
      Offset(virtualSize.width * 0.4331000, virtualSize.height * 0.3573750),
      [
        GameColors.whiteSolid.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 0),
      ],
      [0.611, 0.807],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(15.6, 13.51);
    path_4.arcToPoint(
      Offset(14.975, 13.766),
      radius: Radius.elliptical(1.4, 1.4),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.lineTo(22.025, 13.728);
    path_4.arcToPoint(
      Offset(20.962, 12.963),
      radius: Radius.elliptical(1.406, 1.406),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_4.lineTo(19.758, 10.546);
    path_4.arcToPoint(
      Offset(17.208, 10.568999999999999),
      radius: Radius.elliptical(1.407, 1.407),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_4.lineTo(16.032999999999998, 12.991);
    path_4.cubicTo(
      15.932999999999998,
      13.197,
      15.784999999999998,
      13.375,
      15.599999999999998,
      13.511,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.linear(
      Offset(virtualSize.width * 0.6036000, virtualSize.height * 0.06645000),
      Offset(virtualSize.width * 0.5556000, virtualSize.height * 0.4035500),
      [
        GameColors.whiteSolid.withValues(alpha: 1),
        GameColors.whiteSolid.withValues(alpha: 0),
      ],
      [0.611, 0.807],
    );
    canvas.drawPath(path_4, paint4Fill);

    canvas.restore(); // restore star center
    canvas.restore(); // restore whole icon center
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
