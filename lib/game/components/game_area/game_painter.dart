import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GamePainter extends CustomPainter {
  final double innerCornerRadius;

  GamePainter({this.innerCornerRadius = 75.0});

  @override
  void paint(Canvas canvas, Size size) {
    double R = innerCornerRadius;
    double ctrlOffset = R * 0.552284749831;

    Path path_0 = Path();
    path_0.moveTo(298, 832.873);
    path_0.lineTo(294.214, 832.873);
    path_0.cubicTo(
      287.49399999999997,
      834.635,
      284.909,
      836.815,
      284.24,
      841.8580000000001,
    );
    path_0.cubicTo(
      284.24,
      859.3270000000001,
      273.175,
      872.128,
      261.752,
      867.859,
    );
    path_0.lineTo(244.085, 861.2750000000001);
    path_0.cubicTo(
      239.17700000000002,
      859.4570000000001,
      234.624,
      865.6080000000001,
      235.406,
      873.0210000000001,
    );
    path_0.lineTo(235.406, 873.119);
    path_0.cubicTo(
      235.89600000000002,
      877.849,
      232.90800000000002,
      881.687,
      229.785,
      880.429,
    );
    path_0.cubicTo(
      221.642,
      877.087,
      214.59199999999998,
      876.689,
      209.463,
      881.9159999999999,
    );
    path_0.cubicTo(
      206.74099999999999,
      884.693,
      203.262,
      884.693,
      200.54,
      881.9159999999999,
    );
    path_0.cubicTo(
      195.408,
      876.689,
      188.381,
      877.087,
      180.21699999999998,
      880.429,
    );
    path_0.cubicTo(
      177.094,
      881.687,
      174.10399999999998,
      877.8489999999999,
      174.59599999999998,
      873.119,
    );
    path_0.lineTo(174.61699999999996, 873.0210000000001);
    path_0.cubicTo(
      175.39699999999996,
      865.6120000000001,
      170.82399999999996,
      859.4570000000001,
      165.93899999999996,
      861.2750000000001,
    );
    path_0.lineTo(148.26999999999995, 867.859);
    path_0.cubicTo(
      136.84899999999996,
      872.128,
      125.75999999999995,
      859.327,
      125.75999999999995,
      841.8580000000001,
    );
    path_0.cubicTo(
      124.35399999999994,
      836.6750000000001,
      121.95099999999995,
      834.5740000000001,
      115.67599999999995,
      832.873,
    );
    path_0.lineTo(112, 832.873);
    path_0.lineTo(112, 825);
    path_0.lineTo(298, 825);
    path_0.lineTo(298, 832.873);
    path_0.close();
    path_0.moveTo(193.438, 19.319);
    path_0.cubicTo(
      199.37199999999999,
      14.466999999999999,
      206.701,
      13.703,
      213.07399999999998,
      17.027,
    );
    path_0.arcToPoint(
      Offset(216.541, 19.319000000000003),
      radius: Radius.elliptical(20.273, 20.273),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      227.738,
      28.436000000000003,
      242.462,
      29.277,
      259.438,
      25.171000000000003,
    );
    path_0.cubicTo(
      262.579,
      24.411,
      265.79699999999997,
      23.481,
      269.085,
      22.402,
    );
    path_0.arcToPoint(
      Offset(271.35999999999996, 21.936),
      radius: Radius.elliptical(10.27, 10.27),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      271.36899999999997,
      21.935,
      271.37699999999995,
      21.933,
      271.38599999999997,
      21.933,
    );
    path_0.cubicTo(271.498, 21.923, 271.609, 21.916, 271.72099999999995, 21.91);
    path_0.lineTo(271.76899999999995, 21.908);
    path_0.cubicTo(
      271.86599999999993,
      21.904,
      271.96399999999994,
      21.900000000000002,
      272.06199999999995,
      21.898,
    );
    path_0.lineTo(272.16999999999996, 21.898);
    path_0.arcToPoint(
      Offset(272.58599999999996, 21.903),
      radius: Radius.elliptical(9.988, 9.988),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(272.68399999999997, 21.907999999999998);
    path_0.arcToPoint(
      Offset(272.965, 21.924999999999997),
      radius: Radius.elliptical(9.8, 9.8),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      272.976,
      21.924999999999997,
      272.988,
      21.924999999999997,
      272.99899999999997,
      21.926999999999996,
    );
    path_0.cubicTo(
      279.23299999999995,
      22.412999999999997,
      284.32599999999996,
      28.817999999999998,
      283.748,
      36.602,
    );
    path_0.cubicTo(283.726, 36.907, 283.694, 37.214, 283.654, 37.522);
    path_0.lineTo(283.654, 37.769999999999996);
    path_0.arcToPoint(
      Offset(284.335, 47.858),
      radius: Radius.elliptical(25.17, 25.17),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(284.407, 47.858);
    path_0.lineTo(284.407, 47.864999999999995);
    path_0.cubicTo(
      285.774,
      52.770999999999994,
      288.57399999999996,
      56.88799999999999,
      292.186,
      59.52799999999999,
    );
    path_0.cubicTo(
      294.897,
      61.48799999999999,
      298.05899999999997,
      62.63099999999999,
      301.412,
      62.669999999999995,
    );
    path_0.arcToPoint(
      Offset(306.121, 61.980999999999995),
      radius: Radius.elliptical(15.865, 15.865),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(351.83, 48.370999999999995);
    path_0.cubicTo(
      357.066,
      46.815999999999995,
      362.276,
      46.370999999999995,
      367.304,
      46.891,
    );
    path_0.cubicTo(
      378.80499999999995,
      48.068,
      389.344,
      54.307,
      397.07099999999997,
      63.893,
    );
    path_0.cubicTo(405.018, 73.733, 410, 87.096, 410, 102.128);
    path_0.lineTo(410, 115.127);
    path_0.lineTo(410.049, 115.127);
    path_0.lineTo(410.049, 774.731);
    path_0.cubicTo(410.049, 798.636, 395.62199999999996, 819.171, 375, 828.105);
    path_0.lineTo(375, 819.862);
    path_0.cubicTo(
      391.586,
      811.6899999999999,
      403,
      794.6179999999999,
      403,
      774.8779999999999,
    );
    path_0.lineTo(403, 124 + R);
    path_0.cubicTo(
      403,
      124 + R - ctrlOffset,
      403 - R + ctrlOffset,
      124,
      403 - R,
      124,
    );
    path_0.lineTo(6 + R, 124);
    path_0.cubicTo(
      6 + R - ctrlOffset,
      124,
      6,
      124 + R - ctrlOffset,
      6,
      124 + R,
    );
    path_0.lineTo(6, 774.878);
    path_0.cubicTo(
      6,
      795.0120000000001,
      17.874000000000002,
      812.3710000000001,
      35,
      820.341,
    );
    path_0.lineTo(35, 828.063);
    path_0.cubicTo(14.43, 819.107, 0.049, 798.599, 0.049, 774.731);
    path_0.lineTo(0.049, 122.544);
    path_0.lineTo(0.02, 122.544);
    path_0.lineTo(0.02, 103.13499999999999);
    path_0.arcToPoint(
      Offset(0, 104.85199999999999),
      radius: Radius.elliptical(67.91, 67.91),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(0, 102.18499999999999);
    path_0.cubicTo(
      0,
      79.59099999999998,
      11.218,
      60.77499999999999,
      26.85,
      52.00699999999999,
    );
    path_0.arcToPoint(
      Offset(36.425, 48.06899999999999),
      radius: Radius.elliptical(41.978, 41.978),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      43.334999999999994,
      46.188999999999986,
      50.75,
      46.14999999999999,
      58.218999999999994,
      48.37099999999999,
    );
    path_0.lineTo(103.922, 61.98099999999999);
    path_0.cubicTo(
      105.49799999999999,
      62.45899999999999,
      107.06099999999999,
      62.67799999999999,
      108.586,
      62.66899999999999,
    );
    path_0.cubicTo(
      111.032,
      62.64699999999999,
      113.38,
      62.03399999999999,
      115.52799999999999,
      60.94299999999999,
    );
    path_0.cubicTo(
      120.22699999999999,
      58.51699999999999,
      123.945,
      53.76299999999999,
      125.59299999999999,
      47.87899999999999,
    );
    path_0.lineTo(125.70799999999998, 47.87899999999999);
    path_0.cubicTo(
      126.05799999999998,
      46.63299999999999,
      126.31399999999998,
      45.33699999999999,
      126.46599999999998,
      44.00099999999999,
    );
    path_0.arcToPoint(
      Offset(126.38999999999999, 37.77099999999999),
      radius: Radius.elliptical(25.7, 25.7),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.lineTo(126.31499999999998, 37.52299999999999);
    path_0.cubicTo(
      125.73999999999998,
      33.08399999999999,
      127.02499999999998,
      29.02599999999999,
      129.35699999999997,
      26.160999999999987,
    );
    path_0.arcToPoint(
      Offset(132.44399999999996, 23.428999999999988),
      radius: Radius.elliptical(12.139, 12.139),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(132.52099999999996, 23.38299999999999);
    path_0.cubicTo(
      132.59499999999997,
      23.337999999999987,
      132.66899999999995,
      23.29299999999999,
      132.74399999999997,
      23.250999999999987,
    );
    path_0.arcToPoint(
      Offset(136.76199999999997, 21.94699999999999),
      radius: Radius.elliptical(10.158, 10.158),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(136.83499999999998, 21.939999999999987);
    path_0.arcToPoint(
      Offset(137.38299999999998, 21.904999999999987),
      radius: Radius.elliptical(9.862, 9.862),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(
      138.52499999999998,
      21.860999999999986,
      139.70199999999997,
      22.014999999999986,
      140.88599999999997,
      22.394999999999985,
    );
    path_0.cubicTo(
      153.41999999999996,
      26.494999999999983,
      164.91699999999997,
      28.452999999999985,
      174.96799999999996,
      27.106999999999985,
    );
    path_0.cubicTo(
      181.84199999999996,
      26.182999999999986,
      188.03999999999996,
      23.711999999999986,
      193.42999999999995,
      19.326999999999984,
    );
    path_0.lineTo(193.43799999999996, 19.318999999999985);
    path_0.close();
    path_0.moveTo(74.388, 0);
    path_0.arcToPoint(
      Offset(113.811, 19.71),
      radius: Radius.elliptical(49.28, 49.28),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(119.161, 26.846);
    path_0.arcToPoint(
      Offset(122.534, 35.5),
      radius: Radius.elliptical(17.288, 17.288),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.cubicTo(122.661, 39.068, 122.226, 41.546, 120.75, 44.679);
    path_0.cubicTo(
      119.531,
      47.267,
      117.85,
      49.623000000000005,
      115.894,
      51.711,
    );
    path_0.cubicTo(
      114.936,
      52.733,
      114.004,
      53.609,
      113.04700000000001,
      54.341,
    );
    path_0.cubicTo(
      107.60100000000001,
      58.505,
      100.02700000000002,
      56.111000000000004,
      93.47200000000001,
      54.103,
    );
    path_0.lineTo(51.534, 41.257);
    path_0.cubicTo(42.974, 39.269, 38.922, 39.851, 32.824, 43.175999999999995);
    path_0.arcToPoint(
      Offset(24.048, 47.492999999999995),
      radius: Radius.elliptical(140.677, 140.677),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.cubicTo(13.607, 53.551, 5, 52.257, 5, 40.185);
    path_0.lineTo(5, 35.5);
    path_0.cubicTo(5, 15.894, 20.894, 0, 40.5, 0);
    path_0.lineTo(74.38900000000001, 0);
    path_0.close();
    path_0.moveTo(370.05499999999995, 0);
    path_0.cubicTo(
      389.66099999999994,
      0,
      405.55499999999995,
      15.894,
      405.55499999999995,
      35.5,
    );
    path_0.lineTo(405.55499999999995, 40.185);
    path_0.cubicTo(
      405.55499999999995,
      52.257000000000005,
      396.948,
      53.551,
      386.50699999999995,
      47.493,
    );
    path_0.arcToPoint(
      Offset(377.72999999999996, 43.176),
      radius: Radius.elliptical(140.514, 140.514),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_0.cubicTo(
      371.63199999999995,
      39.851,
      367.58,
      39.269000000000005,
      359.02099999999996,
      41.256,
    );
    path_0.lineTo(317.08299999999997, 54.103);
    path_0.cubicTo(
      310.52799999999996,
      56.111000000000004,
      302.95399999999995,
      58.505,
      297.508,
      54.341,
    );
    path_0.cubicTo(
      296.551,
      53.609,
      295.61899999999997,
      52.733000000000004,
      294.661,
      51.711,
    );
    path_0.cubicTo(
      292.705,
      49.623,
      291.024,
      47.266999999999996,
      289.805,
      44.679,
    );
    path_0.cubicTo(288.329, 41.546, 287.894, 39.068000000000005, 288.021, 35.5);
    path_0.arcToPoint(
      Offset(291.394, 26.846),
      radius: Radius.elliptical(17.28, 17.28),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_0.lineTo(296.744, 19.711);
    path_0.arcToPoint(
      Offset(336.166, 0),
      radius: Radius.elliptical(49.278, 49.278),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    // Smooth, borderless premium gradient (Golden Sand)
    Rect bounds = path_0.getBounds();
    final Paint basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFE082), // Soft bright sand
          Color(0xFFFFCA28), // Golden sand
          Color(0xFFFFB300), // Warm amber
        ],
      ).createShader(bounds);
    canvas.drawPath(path_0, basePaint);

    // Add a subtle 45-degree diagonal stripe pattern for a premium texture
    canvas.save();
    canvas.clipPath(path_0);

    final Paint patternPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw diagonal lines across the bounding box
    for (
      double i = -bounds.height;
      i < bounds.width + bounds.height;
      i += 16.0
    ) {
      canvas.drawLine(
        Offset(bounds.left + i, bounds.top),
        Offset(bounds.left + i + bounds.height, bounds.bottom),
        patternPaint,
      );
    }

    // Add a very soft inner highlight to give the frame a tiny bit of depth without being cartoonish
    final Paint innerGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.1);
    canvas.drawPath(path_0, innerGlow);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PauseBtnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double barWidth = size.width * 0.35;
    double barHeight = size.height;
    double spacing = size.width * 0.12;
    double cx = size.width / 2;
    double cy = size.height / 2;

    Rect leftBar = Rect.fromCenter(
      center: Offset(cx - spacing - barWidth / 2, cy),
      width: barWidth,
      height: barHeight,
    );
    Rect rightBar = Rect.fromCenter(
      center: Offset(cx + spacing + barWidth / 2, cy),
      width: barWidth,
      height: barHeight,
    );
    double radius = barWidth / 2;

    // 3D Glossy Metallic Red/Orange Base
    final Paint iconPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF8A80), // Bright highlight
          Color(0xFFFF5252), // Main red
          Color(0xFFD32F2F), // Deep shadow
        ],
      ).createShader(leftBar);

    canvas.drawRRect(
      RRect.fromRectAndRadius(leftBar, Radius.circular(radius)),
      iconPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightBar, Radius.circular(radius)),
      iconPaint,
    );

    // Inner Gloss Highlight for sleek 3D effect
    Rect innerLeft = leftBar.deflate(1.5);
    Rect innerRight = rightBar.deflate(1.5);
    final Paint glossPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x99FFFFFF), Color(0x00FFFFFF)],
      ).createShader(innerLeft);

    canvas.drawRRect(
      RRect.fromRectAndRadius(innerLeft, Radius.circular(radius - 1.5)),
      glossPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRight, Radius.circular(radius - 1.5)),
      glossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
