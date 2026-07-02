import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BrokenHeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Apply 50% opacity to the entire composite graphic
    canvas.saveLayer(
      Offset.zero & size,
      Paint()..color = const Color.fromRGBO(255, 255, 255, 0.5),
    );

    // Scale the entire broken heart (including the red box) to be smaller than the filled one
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(0.85);
    canvas.translate(-size.width / 2, -size.height / 2);

    double scale = size.width / 40.0;
    canvas.scale(scale, scale);
    Size virtualSize = const Size(40.0, 40.0);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffF02300).withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          virtualSize.width * 0.09494118,
          virtualSize.height * 0.02005882,
          virtualSize.width * 0.8823529,
          virtualSize.height * 0.8823529,
        ),
        bottomRight: Radius.circular(virtualSize.width * 0.3744118),
        bottomLeft: Radius.circular(virtualSize.width * 0.3744118),
        topLeft: Radius.circular(virtualSize.width * 0.3744118),
        topRight: Radius.circular(virtualSize.width * 0.3744118),
      ),
      paint0Fill,
    );

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = virtualSize.width * 0.02005882;
    paint1Stroke.color = Color(0xffffffff).withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          virtualSize.width * 0.08491176,
          virtualSize.height * 0.01002941,
          virtualSize.width * 0.9024118,
          virtualSize.height * 0.9024118,
        ),
        bottomRight: Radius.circular(virtualSize.width * 0.3844412),
        bottomLeft: Radius.circular(virtualSize.width * 0.3844412),
        topLeft: Radius.circular(virtualSize.width * 0.3844412),
        topRight: Radius.circular(virtualSize.width * 0.3844412),
      ),
      paint1Stroke,
    );

    canvas.save();
    // The broken heart's hardcoded bounding box center is approx (17.66, 17.04)
    // The red box's center is at (virtualSize.width * 0.5361, virtualSize.height * 0.4612)
    double tx = (virtualSize.width * 0.5361) - 17.66;
    double ty = (virtualSize.height * 0.4612) - 17.04;

    // Scale slightly to better match the filled heart size, keeping it centered.
    // The broken heart is ~78% the size of the filled heart.
    // We scale by 1.25 around its center to match.
    canvas.translate(tx + 17.66, ty + 17.04);
    canvas.scale(1.25);
    canvas.translate(-17.66, -17.04);

    Path path_2 = Path();
    path_2.moveTo(26.66, 14.706);
    path_2.arcToPoint(
      Offset(26.262, 16.726),
      radius: Radius.elliptical(5.518, 5.518),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      25.211000000000002,
      19.355,
      22.251,
      22.643,
      17.748,
      24.430999999999997,
    );
    path_2.cubicTo(
      17.723000000000003,
      24.441,
      17.694000000000003,
      24.452999999999996,
      17.662000000000003,
      24.461999999999996,
    );
    path_2.cubicTo(
      17.633000000000003,
      24.452999999999996,
      17.605000000000004,
      24.439999999999998,
      17.579000000000004,
      24.430999999999997,
    );
    path_2.cubicTo(
      13.077000000000005,
      22.642999999999997,
      10.117000000000004,
      19.354999999999997,
      9.065000000000005,
      16.726,
    );
    path_2.arcToPoint(
      Offset(8.683000000000005, 15.065999999999999),
      radius: Radius.elliptical(5.426, 5.426),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(8.663000000000006, 14.706),
      radius: Radius.elliptical(2.669, 2.669),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      8.661000000000005,
      14.639,
      8.663000000000006,
      14.568999999999999,
      8.667000000000005,
      14.501999999999999,
    );
    path_2.cubicTo(
      8.715000000000005,
      12.558,
      9.785000000000005,
      10.758,
      11.557000000000006,
      9.986999999999998,
    );
    path_2.arcToPoint(
      Offset(14.444000000000006, 9.756999999999998),
      radius: Radius.elliptical(4.424, 4.424),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(14.374000000000006, 10.391999999999998);
    path_2.lineTo(13.994000000000005, 13.749999999999998);
    path_2.lineTo(16.442000000000004, 14.599999999999998);
    path_2.lineTo(16.132000000000005, 16.581999999999997);
    path_2.lineTo(18.863000000000007, 18.949999999999996);
    path_2.lineTo(18.500000000000007, 16.142999999999997);
    path_2.lineTo(19.787000000000006, 14.676999999999998);
    path_2.lineTo(19.042000000000005, 12.331999999999997);
    path_2.lineTo(20.842000000000006, 10.410999999999998);
    path_2.lineTo(21.565000000000005, 9.635999999999997);
    path_2.cubicTo(
      21.578000000000007,
      9.635999999999997,
      21.587000000000003,
      9.632999999999997,
      21.600000000000005,
      9.632999999999997,
    );
    path_2.arcToPoint(
      Offset(21.730000000000004, 9.622999999999998),
      radius: Radius.elliptical(0.915, 0.915),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.arcToPoint(
      Offset(23.766000000000005, 9.985999999999997),
      radius: Radius.elliptical(4.425, 4.425),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.cubicTo(
      25.539000000000005,
      10.757999999999997,
      26.612000000000005,
      12.558999999999997,
      26.657000000000004,
      14.501999999999997,
    );
    path_2.cubicTo(
      26.660000000000004,
      14.568999999999997,
      26.663000000000004,
      14.638999999999998,
      26.660000000000004,
      14.705999999999998,
    );
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(26.66, 14.706);
    path_3.arcToPoint(
      Offset(26.262, 16.726),
      radius: Radius.elliptical(5.518, 5.518),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      25.211000000000002,
      19.355,
      22.251,
      22.643,
      17.748,
      24.430999999999997,
    );
    path_3.cubicTo(
      17.723000000000003,
      24.441,
      17.694000000000003,
      24.452999999999996,
      17.662000000000003,
      24.461999999999996,
    );
    path_3.cubicTo(
      17.633000000000003,
      24.452999999999996,
      17.605000000000004,
      24.439999999999998,
      17.579000000000004,
      24.430999999999997,
    );
    path_3.cubicTo(
      13.077000000000005,
      22.642999999999997,
      10.117000000000004,
      19.354999999999997,
      9.065000000000005,
      16.726,
    );
    path_3.arcToPoint(
      Offset(8.683000000000005, 15.065999999999999),
      radius: Radius.elliptical(5.426, 5.426),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(8.663000000000006, 14.706),
      radius: Radius.elliptical(2.669, 2.669),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      8.661000000000005,
      14.639,
      8.663000000000006,
      14.568999999999999,
      8.667000000000005,
      14.501999999999999,
    );
    path_3.cubicTo(
      8.715000000000005,
      12.558,
      9.785000000000005,
      10.758,
      11.557000000000006,
      9.986999999999998,
    );
    path_3.arcToPoint(
      Offset(14.444000000000006, 9.756999999999998),
      radius: Radius.elliptical(4.424, 4.424),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(14.374000000000006, 10.391999999999998);
    path_3.lineTo(13.994000000000005, 13.749999999999998);
    path_3.lineTo(16.442000000000004, 14.599999999999998);
    path_3.lineTo(16.132000000000005, 16.581999999999997);
    path_3.lineTo(18.863000000000007, 18.949999999999996);
    path_3.lineTo(18.500000000000007, 16.142999999999997);
    path_3.lineTo(19.787000000000006, 14.676999999999998);
    path_3.lineTo(19.042000000000005, 12.331999999999997);
    path_3.lineTo(20.842000000000006, 10.410999999999998);
    path_3.lineTo(21.565000000000005, 9.635999999999997);
    path_3.cubicTo(
      21.578000000000007,
      9.635999999999997,
      21.587000000000003,
      9.632999999999997,
      21.600000000000005,
      9.632999999999997,
    );
    path_3.arcToPoint(
      Offset(21.730000000000004, 9.622999999999998),
      radius: Radius.elliptical(0.915, 0.915),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(23.766000000000005, 9.985999999999997),
      radius: Radius.elliptical(4.425, 4.425),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      25.539000000000005,
      10.757999999999997,
      26.612000000000005,
      12.558999999999997,
      26.657000000000004,
      14.501999999999997,
    );
    path_3.cubicTo(
      26.660000000000004,
      14.568999999999997,
      26.663000000000004,
      14.638999999999998,
      26.660000000000004,
      14.705999999999998,
    );
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(21.565, 9.637);
    path_4.lineTo(17.494, 11.195);
    path_4.lineTo(19.042, 12.332);
    path_4.lineTo(21.565, 9.637);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(21.565, 9.637);
    path_5.lineTo(17.494, 11.195);
    path_5.lineTo(19.042, 12.332);
    path_5.lineTo(21.565, 9.637);
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(19.787, 14.678);
    path_6.lineTo(19.041999999999998, 12.333);
    path_6.lineTo(17.494, 11.195);
    path_6.lineTo(19.018, 14.281);
    path_6.lineTo(18.5, 16.144000000000002);
    path_6.lineTo(19.787, 14.678000000000003);
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(19.787, 14.678);
    path_7.lineTo(19.041999999999998, 12.333);
    path_7.lineTo(17.494, 11.195);
    path_7.lineTo(19.018, 14.281);
    path_7.lineTo(18.5, 16.144000000000002);
    path_7.lineTo(19.787, 14.678000000000003);
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(14.444, 9.758);
    path_8.lineTo(13.994000000000002, 13.75);
    path_8.lineTo(15.821000000000002, 14.392);
    path_8.lineTo(14.444, 9.758);
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(14.444, 9.758);
    path_9.lineTo(13.994000000000002, 13.75);
    path_9.lineTo(15.821000000000002, 14.392);
    path_9.lineTo(14.444, 9.758);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(16.442, 14.602);
    path_10.lineTo(16.132, 16.584);
    path_10.lineTo(18.863, 18.951);
    path_10.lineTo(16.442, 14.601);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(16.442, 14.602);
    path_11.lineTo(16.132, 16.584);
    path_11.lineTo(18.863, 18.951);
    path_11.lineTo(16.442, 14.601);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(24.42, 17.306);
    path_12.cubicTo(
      22.734,
      18.352,
      20.243000000000002,
      19.014,
      17.461000000000002,
      19.014,
    );
    path_12.cubicTo(
      14.982000000000003,
      19.014,
      12.736000000000002,
      18.492,
      11.089000000000002,
      17.637999999999998,
    );
    path_12.cubicTo(
      9.769000000000002,
      16.956,
      9.037000000000003,
      15.416999999999998,
      9.369000000000002,
      13.922999999999998,
    );
    path_12.cubicTo(
      9.680000000000001,
      12.497999999999998,
      10.599000000000002,
      11.262999999999998,
      11.956000000000001,
      10.668999999999999,
    );
    path_12.arcToPoint(
      Offset(14.374000000000002, 10.392),
      radius: Radius.elliptical(4.112, 4.112),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_12.lineTo(13.995000000000003, 13.75);
    path_12.lineTo(16.442000000000004, 14.600999999999999);
    path_12.lineTo(16.133000000000003, 16.583);
    path_12.lineTo(18.863000000000003, 18.95);
    path_12.lineTo(18.500000000000004, 16.143);
    path_12.lineTo(19.788000000000004, 14.678);
    path_12.lineTo(19.042000000000005, 12.333);
    path_12.lineTo(20.842000000000006, 10.411);
    path_12.arcToPoint(
      Offset(23.369000000000007, 10.669),
      radius: Radius.elliptical(4.135, 4.135),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_12.cubicTo(
      24.554000000000006,
      11.189,
      25.40500000000001,
      12.196,
      25.809000000000008,
      13.394,
    );
    path_12.cubicTo(
      26.306000000000008,
      14.862,
      25.701000000000008,
      16.51,
      24.42000000000001,
      17.306,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.shader = ui.Gradient.linear(
      Offset(virtualSize.width * 0.5187059, virtualSize.height * 0.2164706),
      Offset(virtualSize.width * 0.5187059, virtualSize.height * 0.5168235),
      [
        Color(0xffffffff).withValues(alpha: 1),
        Color(0xffffffff).withValues(alpha: 0),
      ],
      [0.216, 0.923],
    );
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(26.648, 15.035);
    path_13.arcToPoint(
      Offset(26.261, 16.728),
      radius: Radius.elliptical(5.573, 5.573),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_13.cubicTo(
      25.211,
      19.354000000000003,
      22.25,
      22.645000000000003,
      17.747,
      24.432000000000002,
    );
    path_13.lineTo(17.663, 24.462000000000003);
    path_13.lineTo(17.579, 24.432000000000002);
    path_13.cubicTo(
      13.077000000000002,
      22.645000000000003,
      10.117,
      19.354000000000003,
      9.066,
      16.728,
    );
    path_13.arcToPoint(
      Offset(8.682, 15.065000000000001),
      radius: Radius.elliptical(5.471, 5.471),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_13.cubicTo(
      8.802,
      15.349000000000002,
      8.950000000000001,
      15.628000000000002,
      9.122,
      15.895000000000001,
    );
    path_13.cubicTo(
      10.663,
      18.345000000000002,
      14.082,
      20.072000000000003,
      17.657,
      20.072000000000003,
    );
    path_13.cubicTo(
      21.422,
      20.072000000000003,
      24.683,
      17.915000000000003,
      26.369999999999997,
      15.462000000000003,
    );
    path_13.cubicTo(
      26.467,
      15.322000000000003,
      26.560999999999996,
      15.180000000000003,
      26.647999999999996,
      15.035000000000004,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(26.438, 16.334);
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(26.661, 14.71);
    path_15.cubicTo(
      26.664,
      14.81,
      26.661,
      14.915000000000001,
      26.658,
      15.020000000000001,
    );
    path_15.lineTo(26.648, 15.037);
    path_15.arcToPoint(
      Offset(26.261, 16.729),
      radius: Radius.elliptical(5.573, 5.573),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.cubicTo(25.211, 19.355999999999998, 22.25, 22.647, 17.747, 24.433);
    path_15.lineTo(17.663, 24.463);
    path_15.lineTo(17.579, 24.433);
    path_15.cubicTo(13.077000000000002, 22.646, 10.117, 19.355, 9.066, 16.729);
    path_15.arcToPoint(
      Offset(8.682, 15.067),
      radius: Radius.elliptical(5.472, 5.472),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.arcToPoint(
      Offset(8.669, 15.040000000000001),
      radius: Radius.elliptical(0.107, 0.107),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_15.cubicTo(8.666, 14.929, 8.662, 14.817, 8.666, 14.71);
    path_15.cubicTo(
      8.662,
      14.642000000000001,
      8.666,
      14.571000000000002,
      8.669,
      14.503,
    );
    path_15.cubicTo(8.675, 14.413, 8.682, 14.322000000000001, 8.691, 14.23);
    path_15.arcToPoint(
      Offset(9.121, 15.896),
      radius: Radius.elliptical(5.486, 5.486),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.cubicTo(10.214, 18.499000000000002, 13.151, 21.712, 17.579, 23.469);
    path_15.lineTo(17.663, 23.499000000000002);
    path_15.lineTo(17.747, 23.469);
    path_15.cubicTo(
      22.25,
      21.682000000000002,
      25.21,
      18.391000000000002,
      26.261,
      15.765,
    );
    path_15.cubicTo(26.299, 15.664, 26.338, 15.566, 26.371, 15.465);
    path_15.arcToPoint(
      Offset(26.636, 14.23),
      radius: Radius.elliptical(5.4, 5.4),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_15.cubicTo(
      26.646,
      14.322000000000001,
      26.651999999999997,
      14.413,
      26.657999999999998,
      14.504000000000001,
    );
    path_15.cubicTo(
      26.660999999999998,
      14.571000000000002,
      26.663999999999998,
      14.642000000000001,
      26.660999999999998,
      14.709000000000001,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = Color(0xffF2ACAC).withValues(alpha: 1.0);
    canvas.drawPath(path_15, paint15Fill);

    canvas.restore(); // restore the inner canvas save for heart alignment
    canvas.restore(); // restore the global scale save
    canvas.restore(); // restore the saveLayer for opacity
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
