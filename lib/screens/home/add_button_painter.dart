import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AddButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5420294, size.height * 0.06222581),
      Offset(size.width * 0.5420294, size.height * 0.9331935),
      [Color(0xffFFA428).withOpacity(1), Color(0xffF54812).withOpacity(1)],
      [0, 1],
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1449706,
          size.height * 0.06222581,
          size.width * 0.7941176,
          size.height * 0.8709677,
        ),
        bottomRight: Radius.circular(size.width * 0.3970588),
        bottomLeft: Radius.circular(size.width * 0.3970588),
        topLeft: Radius.circular(size.width * 0.3970588),
        topRight: Radius.circular(size.width * 0.3970588),
      ),
      paint_0_fill,
    );

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05673529;
    paint_1_stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.9832059, size.height * 0.8041613),
      Offset(size.width * 2.732353, size.height * 0.2073871),
      [Color(0xffFFA428).withOpacity(1), Color(0xffF54812).withOpacity(1)],
      [0, 1],
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.1165882,
          size.height * 0.03109677,
          size.width * 0.8508529,
          size.height * 0.9331935,
        ),
        bottomRight: Radius.circular(size.width * 0.4254118),
        bottomLeft: Radius.circular(size.width * 0.4254118),
        topLeft: Radius.circular(size.width * 0.4254118),
        topRight: Radius.circular(size.width * 0.4254118),
      ),
      paint_1_stroke,
    );

    Path path_2 = Path();
    path_2.moveTo(25.2, 12.744);
    path_2.lineTo(23.628, 12.744);
    path_2.arcToPoint(
      Offset(21.112000000000002, 10.228),
      radius: Radius.elliptical(2.516, 2.516),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(21.112000000000002, 8.656);
    path_2.cubicTo(
      21.112000000000002,
      8.406,
      21.012,
      8.166,
      20.836000000000002,
      7.989000000000001,
    );
    path_2.cubicTo(
      20.659000000000002,
      7.812000000000001,
      19.161,
      7.713000000000001,
      18.911,
      7.713000000000001,
    );
    path_2.cubicTo(
      18.661,
      7.713000000000001,
      17.163,
      7.813000000000001,
      16.986,
      7.989000000000001,
    );
    path_2.arcToPoint(
      Offset(16.71, 8.656),
      radius: Radius.elliptical(0.943, 0.943),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(16.71, 10.228000000000002);
    path_2.arcToPoint(
      Offset(14.194, 12.744000000000002),
      radius: Radius.elliptical(2.516, 2.516),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(12.622, 12.744000000000002);
    path_2.cubicTo(
      12.372,
      12.744000000000002,
      12.132,
      12.844000000000001,
      11.955,
      13.020000000000001,
    );
    path_2.cubicTo(
      11.778,
      13.197000000000001,
      11.679,
      14.695000000000002,
      11.679,
      14.945000000000002,
    );
    path_2.cubicTo(11.679, 15.195000000000002, 11.779, 16.693, 11.955, 16.87);
    path_2.arcToPoint(
      Offset(12.622, 17.146),
      radius: Radius.elliptical(0.943, 0.943),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(14.193999999999999, 17.146);
    path_2.arcToPoint(
      Offset(16.71, 19.662),
      radius: Radius.elliptical(2.516, 2.516),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(16.71, 21.233999999999998);
    path_2.cubicTo(
      16.71,
      21.483999999999998,
      16.810000000000002,
      21.723999999999997,
      16.986,
      21.901,
    );
    path_2.cubicTo(17.163, 22.078, 18.661, 22.177, 18.911, 22.177);
    path_2.cubicTo(
      19.161,
      22.177,
      20.659000000000002,
      22.076999999999998,
      20.836000000000002,
      21.901,
    );
    path_2.arcToPoint(
      Offset(21.112000000000002, 21.233999999999998),
      radius: Radius.elliptical(0.943, 0.943),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.lineTo(21.112000000000002, 19.662);
    path_2.arcToPoint(
      Offset(23.628, 17.146),
      radius: Radius.elliptical(2.516, 2.516),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_2.lineTo(25.2, 17.146);
    path_2.cubicTo(25.45, 17.146, 25.689999999999998, 17.046, 25.867, 16.87);
    path_2.cubicTo(26.044, 16.693, 26.143, 15.195, 26.143, 14.945);
    path_2.cubicTo(26.143, 14.695, 26.043, 13.197000000000001, 25.867, 13.02);
    path_2.arcToPoint(
      Offset(25.2, 12.744),
      radius: Radius.elliptical(0.943, 0.943),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFFDDC3).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(18.911, 7.084);
    path_3.cubicTo(
      19.069000000000003,
      7.084,
      19.531000000000002,
      7.111,
      19.970000000000002,
      7.159,
    );
    path_3.cubicTo(
      20.191000000000003,
      7.183,
      20.424000000000003,
      7.215,
      20.62,
      7.255,
    );
    path_3.cubicTo(
      20.717000000000002,
      7.2749999999999995,
      20.82,
      7.2989999999999995,
      20.913,
      7.33,
    );
    path_3.cubicTo(20.977, 7.352, 21.146, 7.41, 21.28, 7.545);
    path_3.cubicTo(21.575000000000003, 7.84, 21.741, 8.239, 21.741, 8.656);
    path_3.lineTo(21.741, 10.228000000000002);
    path_3.cubicTo(
      21.741,
      11.270000000000001,
      22.586,
      12.115000000000002,
      23.628,
      12.115000000000002,
    );
    path_3.lineTo(25.199, 12.115000000000002);
    path_3.cubicTo(
      25.616000000000003,
      12.115000000000002,
      26.017000000000003,
      12.280000000000001,
      26.311,
      12.575000000000003,
    );
    path_3.arcToPoint(
      Offset(26.525, 12.942000000000004),
      radius: Radius.elliptical(0.94, 0.94),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      26.557,
      13.036000000000003,
      26.581,
      13.139000000000003,
      26.601,
      13.236000000000004,
    );
    path_3.cubicTo(
      26.641,
      13.432000000000004,
      26.672,
      13.666000000000004,
      26.695999999999998,
      13.886000000000005,
    );
    path_3.cubicTo(
      26.743999999999996,
      14.326000000000004,
      26.770999999999997,
      14.788000000000004,
      26.770999999999997,
      14.946000000000005,
    );
    path_3.cubicTo(
      26.770999999999997,
      15.103000000000005,
      26.743999999999996,
      15.566000000000004,
      26.695999999999998,
      16.004000000000005,
    );
    path_3.arcToPoint(
      Offset(26.601, 16.654000000000003),
      radius: Radius.elliptical(7.653, 7.653),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      26.581,
      16.751000000000005,
      26.557,
      16.854000000000003,
      26.525,
      16.947000000000003,
    );
    path_3.arcToPoint(
      Offset(26.311999999999998, 17.314000000000004),
      radius: Radius.elliptical(0.941, 0.941),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(25.198999999999998, 17.775000000000002),
      radius: Radius.elliptical(1.575, 1.575),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(23.627999999999997, 17.775000000000002);
    path_3.arcToPoint(
      Offset(21.740999999999996, 19.662000000000003),
      radius: Radius.elliptical(1.887, 1.887),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.lineTo(21.740999999999996, 21.233000000000004);
    path_3.cubicTo(
      21.740999999999996,
      21.650000000000006,
      21.574999999999996,
      22.051000000000005,
      21.280999999999995,
      22.346000000000004,
    );
    path_3.arcToPoint(
      Offset(20.912999999999997, 22.560000000000002),
      radius: Radius.elliptical(0.941, 0.941),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(20.619999999999997, 22.635),
      radius: Radius.elliptical(2.477, 2.477),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      20.423999999999996,
      22.675,
      20.191,
      22.706000000000003,
      19.97,
      22.73,
    );
    path_3.cubicTo(19.532, 22.779, 19.069, 22.806, 18.910999999999998, 22.806);
    path_3.cubicTo(
      18.752999999999997,
      22.806,
      18.290999999999997,
      22.779,
      17.851999999999997,
      22.73,
    );
    path_3.arcToPoint(
      Offset(17.201999999999998, 22.635),
      radius: Radius.elliptical(7.665, 7.665),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      17.104999999999997,
      22.615000000000002,
      17.002,
      22.591,
      16.907999999999998,
      22.560000000000002,
    );
    path_3.arcToPoint(
      Offset(16.540999999999997, 22.346000000000004),
      radius: Radius.elliptical(0.941, 0.941),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(16.080999999999996, 21.233000000000004),
      radius: Radius.elliptical(1.573, 1.573),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.lineTo(16.080999999999996, 19.663000000000004);
    path_3.arcToPoint(
      Offset(14.193999999999996, 17.775000000000006),
      radius: Radius.elliptical(1.887, 1.887),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.lineTo(12.621999999999996, 17.775000000000006);
    path_3.cubicTo(
      12.204999999999997,
      17.775000000000006,
      11.805999999999996,
      17.609000000000005,
      11.510999999999996,
      17.315000000000005,
    );
    path_3.arcToPoint(
      Offset(11.295999999999996, 16.947000000000006),
      radius: Radius.elliptical(0.946, 0.946),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(11.220999999999997, 16.654000000000007),
      radius: Radius.elliptical(2.482, 2.482),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(11.124999999999996, 16.00400000000001),
      radius: Radius.elliptical(7.653, 7.653),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      11.076999999999996,
      15.566000000000008,
      11.049999999999997,
      15.104000000000008,
      11.049999999999997,
      14.94500000000001,
    );
    path_3.cubicTo(
      11.049999999999997,
      14.78800000000001,
      11.076999999999996,
      14.32500000000001,
      11.124999999999996,
      13.88700000000001,
    );
    path_3.cubicTo(
      11.148999999999996,
      13.66500000000001,
      11.180999999999996,
      13.43200000000001,
      11.220999999999997,
      13.237000000000009,
    );
    path_3.arcToPoint(
      Offset(11.295999999999996, 12.942000000000009),
      radius: Radius.elliptical(2.45, 2.45),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.arcToPoint(
      Offset(11.510999999999996, 12.57500000000001),
      radius: Radius.elliptical(0.945, 0.945),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      11.805999999999996,
      12.28100000000001,
      12.204999999999995,
      12.115000000000009,
      12.621999999999996,
      12.115000000000009,
    );
    path_3.lineTo(14.193999999999996, 12.115000000000009);
    path_3.arcToPoint(
      Offset(16.080999999999996, 10.22900000000001),
      radius: Radius.elliptical(1.887, 1.887),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_3.lineTo(16.080999999999996, 8.655);
    path_3.cubicTo(
      16.080999999999996,
      8.238,
      16.245999999999995,
      7.8389999999999995,
      16.540999999999997,
      7.544,
    );
    path_3.arcToPoint(
      Offset(16.907999999999998, 7.329),
      radius: Radius.elliptical(0.945, 0.945),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.cubicTo(
      17.002,
      7.298,
      17.104999999999997,
      7.273,
      17.201999999999998,
      7.254,
    );
    path_3.cubicTo(
      17.398,
      7.2139999999999995,
      17.631999999999998,
      7.1819999999999995,
      17.851999999999997,
      7.1579999999999995,
    );
    path_3.arcToPoint(
      Offset(18.911999999999995, 7.082999999999999),
      radius: Radius.elliptical(12.86, 12.86),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_3.close();

    Paint paint_3_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03700000;
    paint_3_stroke.color = Color(0xff8D4C00).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
