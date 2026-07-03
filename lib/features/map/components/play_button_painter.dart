import 'dart:ui' as ui;

import 'package:flutter/material.dart';



class PlayButtonPainter extends CustomPainter {
  final bool isLocked;

  PlayButtonPainter({this.isLocked = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.008928571;

    paint0Stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000000, size.height * 0.1071429),
      Offset(size.width * 0.5000000, size.height * 0.9761905),
      isLocked
          ? [Color(0xff444444).withValues(alpha: 1), Color(0xff222222).withValues(alpha: 1)]
          : [Color(0xff420F00).withValues(alpha: 1), Color(0xff641200).withValues(alpha: 1)],

      [0, 1],

    );

    canvas.drawRRect(

      RRect.fromRectAndCorners(

        Rect.fromLTWH(

          size.width * 0.004464286,

          size.height * 0.01190476,

          size.width * 0.9910714,

          size.height * 0.9761905,

        ),

        bottomRight: Radius.circular(size.width * 0.1160714),

        bottomLeft: Radius.circular(size.width * 0.1160714),

        topLeft: Radius.circular(size.width * 0.1160714),

        topRight: Radius.circular(size.width * 0.1160714),

      ),

      paint0Stroke,

    );



    Paint paint0Fill = Paint()..style = PaintingStyle.fill;

    paint0Fill.color = isLocked 
        ? Color(0xff777777).withValues(alpha: 1.0) 
        : Color(0xff9F1601).withValues(alpha: 1.0);

    canvas.drawRRect(

      RRect.fromRectAndCorners(

        Rect.fromLTWH(

          size.width * 0.004464286,

          size.height * 0.01190476,

          size.width * 0.9910714,

          size.height * 0.9761905,

        ),

        bottomRight: Radius.circular(size.width * 0.1160714),

        bottomLeft: Radius.circular(size.width * 0.1160714),

        topLeft: Radius.circular(size.width * 0.1160714),

        topRight: Radius.circular(size.width * 0.1160714),

      ),

      paint0Fill,

    );



    Paint paint1Fill = Paint()..style = PaintingStyle.fill;

    paint1Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000000, size.height * 0.02380952),
      Offset(size.width * 0.5000000, size.height * 0.8809524),
      isLocked
          ? [Color(0xffBBBBBB).withValues(alpha: 1), Color(0xff888888).withValues(alpha: 1)]
          : [Color(0xffFFA428).withValues(alpha: 1), Color(0xffF54812).withValues(alpha: 1)],

      [0, 1],

    );

    final innerRRect = RRect.fromRectAndCorners(

      Rect.fromLTWH(

        size.width * 0.008928571,

        size.height * 0.02380952,

        size.width * 0.9821429,

        size.height * 0.8571429,

      ),

      bottomRight: Radius.circular(size.width * 0.1116071),

      bottomLeft: Radius.circular(size.width * 0.1116071),

      topLeft: Radius.circular(size.width * 0.1116071),

      topRight: Radius.circular(size.width * 0.1116071),

    );



    canvas.drawRRect(innerRRect, paint1Fill);



    // Inner White Shadows

    canvas.save();

    canvas.clipRRect(innerRRect);



    // 1. Broad soft inner white glow

    Paint innerGlow = Paint()

      ..style = PaintingStyle.stroke

      ..strokeWidth = 10.0

      ..color = Colors.white.withValues(alpha: 0.4)

      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

    canvas.drawRRect(innerRRect, innerGlow);



    // 2. Sharper top inner highlight for a glossy jelly effect

    Paint topHighlight = Paint()

      ..style = PaintingStyle.stroke

      ..strokeWidth = 4.0

      ..color = Colors.white.withValues(alpha: 0.6)

      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    canvas.drawRRect(innerRRect.shift(const Offset(0, 1.5)), topHighlight);



    canvas.restore();



    // 3D Specular Highlights (Glass/Candy Reflections)

    canvas.save();

    canvas.clipRRect(innerRRect);



    // Top-Left Bubble Reflection

    final Paint topLeftPaint = Paint()

      ..shader = ui.Gradient.linear(

        Offset(size.width * 0.05, size.height * 0.05),

        Offset(size.width * 0.35, size.height * 0.4),

        [

          Colors.white.withValues(alpha: 0.4),

          Colors.white.withValues(alpha: 0.0),

        ],

      )

      ..style = PaintingStyle.fill;



    canvas.drawRRect(

      RRect.fromRectAndRadius(

        Rect.fromLTWH(

          size.width * 0.05,

          size.height * 0.05,

          size.width * 0.35,

          size.height * 0.35,

        ),

        Radius.circular(size.width * 0.1),

      ),

      topLeftPaint,

    );



    // Bottom-Right Bounce Reflection

    final Paint bottomRightPaint = Paint()

      ..shader = ui.Gradient.linear(

        Offset(size.width * 0.95, size.height * 0.95),

        Offset(size.width * 0.65, size.height * 0.6),

        [

          Colors.white.withValues(alpha: 0.4),

          Colors.white.withValues(alpha: 0.0),

        ],

      )

      ..style = PaintingStyle.fill;



    canvas.drawRRect(

      RRect.fromRectAndRadius(

        Rect.fromLTWH(

          size.width * 0.6,

          size.height * 0.6,

          size.width * 0.35,

          size.height * 0.35,

        ),

        Radius.circular(size.width * 0.1),

      ),

      bottomRightPaint,

    );



    canvas.restore();

  }



  @override

  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return true;

  }

}

