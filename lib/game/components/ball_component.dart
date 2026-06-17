import 'dart:ui' as ui;

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class BallComponent extends Component with HasGameReference<BalancoGame> {
  final Paint basePaint = Paint()..color = Colors.redAccent;

  // Cached Paints
  late final Paint _dropShadowPaint;
  late final Paint _stripePaint;
  late final Paint _highlightPaint;
  late final Paint _borderPaint;

  // Cached Paints for fading
  late final Paint _fadePaint;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _dropShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    _stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    _highlightPaint = Paint()
      ..shader =
          RadialGradient(
            center: const Alignment(-0.3, -0.3), // Highlight from top-left
            radius: 0.8,
            colors: [
              Colors.white.withValues(alpha: 0.6),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.4, 1.0],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: game.ballRadius),
          );

    _borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _fadePaint = Paint();
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    if (game.ballPos2D.isZero()) return;

    canvas.save();
    canvas.translate(game.ballPos2D.x, game.ballPos2D.y);
    canvas.scale(game.ballScale * game.squashX, game.ballScale * game.squashY);

    // 1. Fade out if falling into a hole
    double fallFade = 1.0;
    if (game.isFallingInHole) {
      fallFade = game.ballScale.clamp(0.0, 1.0);
    }

    if (fallFade < 1.0) {
      _fadePaint.color = Colors.white.withValues(alpha: fallFade);
      canvas.saveLayer(
        Rect.fromCircle(center: Offset.zero, radius: 50 * game.ballScale),
        _fadePaint,
      );
    }

    // 2. Drop shadow (cast on the bar)
    canvas.save();
    canvas.translate(6.0, 10.0);
    canvas.scale(1.0, 0.5);
    canvas.drawCircle(Offset.zero, game.ballRadius, _dropShadowPaint);
    canvas.restore();

    // Draw rotating BallPainter graphic
    canvas.save();
    double angle = (game.isFalling || game.isFallingInHole)
        ? game.fallRotation
        : (game.ballP / game.ballRadius);
    canvas.rotate(angle);

    // Scale BallPainter (41.46x42.056) to fit within game.ballRadius * 2
    double scale = (game.ballRadius * 2) / 42.0;
    canvas.scale(scale, scale);
    canvas.translate(-20.73, -21.028);

    BallPainter().paint(canvas, const Size(42.0, 42.0));

    canvas.restore();

    // 3. 3D shading overlay (stationary highlight)
    canvas.drawCircle(Offset.zero, game.ballRadius, _highlightPaint);

    // 4. Outer border
    canvas.drawCircle(Offset.zero, game.ballRadius, _borderPaint);

    // 5. Shield Effect
    if (game.isShieldActive) {
      // Create a nice pulsing effect based on the shieldTimer
      double pulse = (game.shieldTimer * 3).remainder(1.0);
      double shieldRadius = game.ballRadius + 6.0 + (pulse * 4.0);
      
      final shieldFill = Paint()
        ..color = const Color(0x446BABFF) // Light transparent blue
        ..style = PaintingStyle.fill;
        
      final shieldStroke = Paint()
        ..color = const Color(0xAA6BABFF) // Solid blue border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(Offset.zero, shieldRadius, shieldFill);
      canvas.drawCircle(Offset.zero, shieldRadius, shieldStroke);
    }

    if (fallFade < 1.0) {
      canvas.restore(); // Restore saveLayer
    }

    canvas.restore();
  }
}

class BallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(20.73, 42.056);
    path_0.cubicTo(9.298, 42.056, 0, 32.6, 0, 21.028);
    path_0.cubicTo(0, 9.455, 9.32, 0, 20.73, 0);
    path_0.cubicTo(32.14, 0, 41.46, 9.455, 41.46, 21.028);
    path_0.cubicTo(41.46, 32.623999999999995, 32.14, 42.056, 20.73, 42.056);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffEBEBEB).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(14.307, 1.048);
    path_1.cubicTo(9.635, 2.597, 5.705, 5.764, 3.144, 9.91);
    path_1.cubicTo(3.346, 9.705, 4.088, 9.227, 4.447, 9.09);
    path_1.cubicTo(5.166, 8.794, 5.952, 8.657, 6.715, 8.565999999999999);
    path_1.arcToPoint(
      Offset(8.467, 8.475),
      radius: Radius.elliptical(15.042, 15.042),
      rotation: 0,
      largeArc: false,
      clockwise: true,
    );
    path_1.cubicTo(10.174000000000001, 8.475, 11.903, 8.657, 13.61, 8.862);
    path_1.cubicTo(
      13.139,
      4.966,
      13.722999999999999,
      2.324,
      14.306999999999999,
      1.048,
    );
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02380952,
      [
        Color(0xffFFE300).withOpacity(1),
        Color(0xffFFDA00).withOpacity(1),
        Color(0xffC77500).withOpacity(1),
        Color(0xffFFDA00).withOpacity(1),
      ],
      [0, 0.351, 0.714, 0.918],
    );
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(40.427, 27.59);
    path_2.arcToPoint(
      Offset(41.46, 21.029),
      radius: Radius.elliptical(20.999, 20.999),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.arcToPoint(
      Offset(33.083, 4.1469999999999985),
      radius: Radius.elliptical(21.09, 21.09),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_2.cubicTo(29.6, 2.962, 21.74, 1.892, 13.61, 8.84);
    path_2.cubicTo(21.606, 9.843, 38.226, 16.108, 40.427, 27.59);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02380952,
      [
        Color(0xffFFE300).withOpacity(1),
        Color(0xffFFDA00).withOpacity(1),
        Color(0xffC77500).withOpacity(1),
        Color(0xffFFDA00).withOpacity(1),
      ],
      [0, 0.351, 0.714, 0.918],
    );
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(4.02, 33.49);
    path_3.cubicTo(
      7.792999999999999,
      38.683,
      13.879999999999999,
      42.055,
      20.73,
      42.055,
    );
    path_3.cubicTo(22.28, 42.055, 23.785, 41.873, 25.244, 41.554);
    path_3.cubicTo(18.394, 35.334, 14.711, 17.655, 13.61, 8.838999999999999);
    path_3.cubicTo(4.716, 16.449, 0.606, 26.13, 4.02, 33.489);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02380952,
      [
        Color(0xffFFE300).withOpacity(1),
        Color(0xffFFDA00).withOpacity(1),
        Color(0xffC77500).withOpacity(1),
        Color(0xffFFDA00).withOpacity(1),
      ],
      [0, 0.351, 0.714, 0.918],
    );
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(25.244, 41.554);
    path_4.cubicTo(32.409, 39.936, 38.158, 34.56, 40.427, 27.588);
    path_4.cubicTo(38.226, 16.107, 21.606, 9.864, 13.61, 8.838);
    path_4.cubicTo(
      14.709999999999999,
      17.656,
      18.394,
      35.333999999999996,
      25.244,
      41.554,
    );
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02380952,
      [
        Color(0xffF03100).withOpacity(1),
        Color(0xffED0009).withOpacity(1),
        Color(0xffE00008).withOpacity(1),
        Color(0xffAA0006).withOpacity(1),
        Color(0xffF53200).withOpacity(1),
      ],
      [0.104, 0.383, 0.56, 0.816, 1],
    );
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(14.306, 1.049);
    path_5.cubicTo(
      13.722999999999999,
      2.347,
      13.116,
      4.9670000000000005,
      13.61,
      8.863,
    );
    path_5.cubicTo(
      21.740000000000002,
      1.9369999999999994,
      29.601,
      2.9849999999999994,
      33.083,
      4.17,
    );
    path_5.cubicTo(29.623, 1.573, 25.357, 0.023, 20.73, 0.023);
    path_5.arcToPoint(
      Offset(14.306000000000001, 1.049),
      radius: Radius.elliptical(19.38, 19.38),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_5.close();

    Paint paint5Fill = Paint()..style = PaintingStyle.fill;
    paint5Fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02380952,
      [
        Color(0xffF03100).withOpacity(1),
        Color(0xffED0009).withOpacity(1),
        Color(0xffE00008).withOpacity(1),
        Color(0xffAA0006).withOpacity(1),
        Color(0xffF53200).withOpacity(1),
      ],
      [0.104, 0.383, 0.56, 0.816, 1],
    );
    canvas.drawPath(path_5, paint5Fill);

    Path path_6 = Path();
    path_6.moveTo(3.144, 9.888);
    path_6.arcToPoint(
      Offset(0, 21.028),
      radius: Radius.elliptical(21.087, 21.087),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_6.arcToPoint(
      Offset(4.02, 33.491),
      radius: Radius.elliptical(21.24, 21.24),
      rotation: 0,
      largeArc: false,
      clockwise: false,
    );
    path_6.cubicTo(
      0.5839999999999996,
      26.109,
      4.694,
      16.45,
      13.61,
      8.841000000000001,
    );
    path_6.cubicTo(
      8.062999999999999,
      8.134,
      4.760999999999999,
      8.339,
      3.144,
      9.888000000000002,
    );
    path_6.close();

    Paint paint6Fill = Paint()..style = PaintingStyle.fill;
    paint6Fill.shader = ui.Gradient.radial(
      Offset(0, 0),
      size.width * 0.02380952,
      [
        Color(0xffF03100).withOpacity(1),
        Color(0xffED0009).withOpacity(1),
        Color(0xffE00008).withOpacity(1),
        Color(0xffAA0006).withOpacity(1),
        Color(0xffF53200).withOpacity(1),
      ],
      [0.104, 0.383, 0.56, 0.816, 1],
    );
    canvas.drawPath(path_6, paint6Fill);

    Path path_7 = Path();
    path_7.moveTo(11.903, 6.379);
    path_7.cubicTo(9.973, 7.585999999999999, 9.298, 9.637, 10.22, 11.14);
    path_7.cubicTo(11.14, 12.644, 13.544, 13.054, 15.476, 11.870000000000001);
    path_7.cubicTo(
      17.407,
      10.662,
      18.193,
      8.520000000000001,
      17.227,
      6.926000000000001,
    );
    path_7.cubicTo(
      16.239,
      5.308000000000001,
      13.836,
      5.194000000000001,
      11.905000000000001,
      6.379000000000001,
    );
    path_7.close();

    Paint paint7Fill = Paint()..style = PaintingStyle.fill;
    paint7Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.2814524, size.height * 0.1405116),
      Offset(size.width * 0.3721667, size.height * 0.2765116),
      [
        Color(0xffffffff).withOpacity(1),
        Color(0xffC1D8E8).withOpacity(1),
        Color(0xff84B2D2).withOpacity(1),
      ],
      [0, 0.49, 1],
    );
    canvas.drawPath(path_7, paint7Fill);

    Path path_8 = Path();
    path_8.moveTo(11.971, 6.424);
    path_8.cubicTo(10.107, 7.586, 9.456, 9.568000000000001, 10.331, 11.026);
    path_8.cubicTo(
      11.206999999999999,
      12.484,
      13.520999999999999,
      12.871,
      15.385,
      11.709,
    );
    path_8.cubicTo(17.249, 10.547, 18.012, 8.474, 17.069, 6.925);
    path_8.cubicTo(
      16.148999999999997,
      5.375,
      13.834999999999999,
      5.262,
      11.971,
      6.4239999999999995,
    );
    path_8.close();

    Paint paint8Fill = Paint()..style = PaintingStyle.fill;
    paint8Fill.color = Color(0xffB2D2DF).withOpacity(1.0);
    canvas.drawPath(path_8, paint8Fill);

    Path path_9 = Path();
    path_9.moveTo(12.06, 6.424);
    path_9.cubicTo(
      10.242,
      7.563000000000001,
      9.613,
      9.477,
      10.466000000000001,
      10.912,
    );
    path_9.cubicTo(
      11.32,
      12.324000000000002,
      13.588000000000001,
      12.712000000000002,
      15.407,
      11.595,
    );
    path_9.cubicTo(17.227, 10.479000000000001, 17.967, 8.451, 17.047, 6.948);
    path_9.cubicTo(16.126, 5.421, 13.88, 5.285, 12.061, 6.424);
    path_9.close();

    Paint paint9Fill = Paint()..style = PaintingStyle.fill;
    paint9Fill.color = Color(0xffB4D3E0).withOpacity(1.0);
    canvas.drawPath(path_9, paint9Fill);

    Path path_10 = Path();
    path_10.moveTo(12.128, 6.424);
    path_10.cubicTo(
      10.354,
      7.540000000000001,
      9.748000000000001,
      9.408000000000001,
      10.578,
      10.798,
    );
    path_10.cubicTo(11.41, 12.188, 13.610999999999999, 12.552, 15.385, 11.458);
    path_10.cubicTo(17.159, 10.365, 17.878, 8.383, 16.979, 6.925);
    path_10.cubicTo(
      16.104,
      5.445,
      13.902999999999999,
      5.33,
      12.129,
      6.4239999999999995,
    );
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xffB7D5E1).withOpacity(1.0);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(12.218, 6.423);
    path_11.cubicTo(
      10.488,
      7.493,
      9.882,
      9.315999999999999,
      10.713000000000001,
      10.683,
    );
    path_11.cubicTo(11.522, 12.027, 13.678, 12.392, 15.385000000000002, 11.321);
    path_11.cubicTo(
      17.115000000000002,
      10.251,
      17.810000000000002,
      8.336,
      16.935000000000002,
      6.901,
    );
    path_11.cubicTo(
      16.081000000000003,
      5.465999999999999,
      13.947000000000003,
      5.351,
      12.218000000000004,
      6.423,
    );
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xffB9D6E2).withOpacity(1.0);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(12.308, 6.424);
    path_12.cubicTo(10.623, 7.472, 10.04, 9.249, 10.847999999999999, 10.548);
    path_12.cubicTo(
      11.633999999999999,
      11.869,
      13.722999999999999,
      12.211,
      15.407999999999998,
      11.163,
    );
    path_12.cubicTo(17.092, 10.115, 17.764999999999997, 8.247, 16.935, 6.857);
    path_12.cubicTo(
      16.058999999999997,
      5.513,
      13.969999999999999,
      5.399,
      12.308,
      6.424,
    );
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xffBCD8E3).withOpacity(1.0);
    canvas.drawPath(path_12, paint12Fill);

    Path path_13 = Path();
    path_13.moveTo(12.375, 6.423);
    path_13.cubicTo(10.758, 7.448, 10.175, 9.157, 10.938, 10.433);
    path_13.cubicTo(11.701, 11.708, 13.723, 12.05, 15.362000000000002, 11.048);
    path_13.cubicTo(
      16.98,
      10.045,
      17.653000000000002,
      8.222999999999999,
      16.845000000000002,
      6.878,
    );
    path_13.cubicTo(
      16.036,
      5.534,
      14.015000000000002,
      5.421,
      12.375000000000004,
      6.423,
    );
    path_13.close();

    Paint paint13Fill = Paint()..style = PaintingStyle.fill;
    paint13Fill.color = Color(0xffBED9E4).withOpacity(1.0);
    canvas.drawPath(path_13, paint13Fill);

    Path path_14 = Path();
    path_14.moveTo(12.465, 6.424);
    path_14.cubicTo(10.893, 7.404, 10.331, 9.089, 11.073, 10.319);
    path_14.cubicTo(
      11.813,
      11.549000000000001,
      13.790000000000001,
      11.891000000000002,
      15.363,
      10.912,
    );
    path_14.cubicTo(16.935, 9.932, 17.586, 8.178, 16.8, 6.857000000000001);
    path_14.cubicTo(
      16.014,
      5.557000000000001,
      14.037,
      5.444000000000001,
      12.465,
      6.424000000000001,
    );
    path_14.close();

    Paint paint14Fill = Paint()..style = PaintingStyle.fill;
    paint14Fill.color = Color(0xffC0DAE5).withOpacity(1.0);
    canvas.drawPath(path_14, paint14Fill);

    Path path_15 = Path();
    path_15.moveTo(12.555, 6.447);
    path_15.cubicTo(11.028, 7.404, 10.489, 9.022, 11.206999999999999, 10.229);
    path_15.cubicTo(
      11.927,
      11.437,
      13.834999999999999,
      11.755999999999998,
      15.361999999999998,
      10.799,
    );
    path_15.cubicTo(
      16.889999999999997,
      9.841999999999999,
      17.517999999999997,
      8.133,
      16.755,
      6.858,
    );
    path_15.cubicTo(
      15.991,
      5.582,
      14.081999999999999,
      5.491,
      12.555,
      6.4479999999999995,
    );
    path_15.close();

    Paint paint15Fill = Paint()..style = PaintingStyle.fill;
    paint15Fill.color = Color(0xffC3DCE6).withOpacity(1.0);
    canvas.drawPath(path_15, paint15Fill);

    Path path_16 = Path();
    path_16.moveTo(12.622, 6.446);
    path_16.cubicTo(11.14, 7.38, 10.623, 8.952, 11.32, 10.114);
    path_16.cubicTo(12.016, 11.275, 13.88, 11.594000000000001, 15.362, 10.66);
    path_16.cubicTo(16.845, 9.749, 17.451999999999998, 8.086, 16.71, 6.856);
    path_16.cubicTo(
      15.969000000000001,
      5.6259999999999994,
      14.105,
      5.512,
      12.622,
      6.446,
    );
    path_16.close();

    Paint paint16Fill = Paint()..style = PaintingStyle.fill;
    paint16Fill.color = Color(0xffC5DDE7).withOpacity(1.0);
    canvas.drawPath(path_16, paint16Fill);

    Path path_17 = Path();
    path_17.moveTo(12.712, 6.446);
    path_17.cubicTo(
      11.275,
      7.356999999999999,
      10.780999999999999,
      8.861,
      11.454,
      10,
    );
    path_17.cubicTo(
      12.128,
      11.116,
      13.924000000000001,
      11.435,
      15.362,
      10.524000000000001,
    );
    path_17.cubicTo(
      16.8,
      9.635000000000002,
      17.384,
      8.018,
      16.665,
      6.833000000000001,
    );
    path_17.cubicTo(
      15.946,
      5.6480000000000015,
      14.149999999999999,
      5.557000000000001,
      12.712,
      6.4460000000000015,
    );
    path_17.close();

    Paint paint17Fill = Paint()..style = PaintingStyle.fill;
    paint17Fill.color = Color(0xffC8DFE8).withOpacity(1.0);
    canvas.drawPath(path_17, paint17Fill);

    Path path_18 = Path();
    path_18.moveTo(12.78, 6.446);
    path_18.cubicTo(
      11.386999999999999,
      7.311999999999999,
      10.892999999999999,
      8.793,
      11.567,
      9.886,
    );
    path_18.cubicTo(12.218, 10.979999999999999, 13.947, 11.276, 15.34, 10.411);
    path_18.cubicTo(16.732, 9.545, 17.294, 7.9959999999999996, 16.598, 6.834);
    path_18.cubicTo(
      15.924,
      5.672,
      14.171999999999999,
      5.5809999999999995,
      12.78,
      6.446,
    );
    path_18.close();

    Paint paint18Fill = Paint()..style = PaintingStyle.fill;
    paint18Fill.color = Color(0xffCAE0E9).withOpacity(1.0);
    canvas.drawPath(path_18, paint18Fill);

    Path path_19 = Path();
    path_19.moveTo(12.87, 6.447);
    path_19.cubicTo(
      11.521999999999998,
      7.29,
      11.049999999999999,
      8.703,
      11.678999999999998,
      9.773,
    );
    path_19.cubicTo(
      12.307999999999998,
      10.821,
      13.991999999999999,
      11.118,
      15.338999999999999,
      10.275,
    );
    path_19.cubicTo(
      16.686999999999998,
      9.432,
      17.226999999999997,
      7.9510000000000005,
      16.552999999999997,
      6.835000000000001,
    );
    path_19.cubicTo(
      15.878999999999998,
      5.695000000000001,
      14.216999999999997,
      5.605,
      12.868999999999996,
      6.447000000000001,
    );
    path_19.close();

    Paint paint19Fill = Paint()..style = PaintingStyle.fill;
    paint19Fill.color = Color(0xffCCE1EA).withOpacity(1.0);
    canvas.drawPath(path_19, paint19Fill);

    Path path_20 = Path();
    path_20.moveTo(12.96, 6.447);
    path_20.cubicTo(11.656, 7.267, 11.207, 8.634, 11.814, 9.659);
    path_20.cubicTo(
      12.42,
      10.684000000000001,
      14.036999999999999,
      10.935,
      15.34,
      10.137,
    );
    path_20.cubicTo(16.642, 9.34, 17.16, 7.882000000000001, 16.508, 6.811);
    path_20.cubicTo(15.856, 5.741, 14.238999999999999, 5.649, 12.959, 6.447);
    path_20.close();

    Paint paint20Fill = Paint()..style = PaintingStyle.fill;
    paint20Fill.color = Color(0xffCFE3EB).withOpacity(1.0);
    canvas.drawPath(path_20, paint20Fill);

    Path path_21 = Path();
    path_21.moveTo(13.027, 6.447);
    path_21.cubicTo(
      11.768999999999998,
      7.222,
      11.341999999999999,
      8.543,
      11.925999999999998,
      9.523,
    );
    path_21.cubicTo(
      12.509999999999998,
      10.503,
      14.081999999999999,
      10.753,
      15.316999999999998,
      9.979,
    );
    path_21.cubicTo(
      16.575,
      9.203999999999999,
      17.069,
      7.813999999999999,
      16.439999999999998,
      6.765999999999999,
    );
    path_21.cubicTo(
      15.833999999999998,
      5.763999999999999,
      14.283999999999997,
      5.672999999999999,
      13.025999999999998,
      6.446999999999999,
    );
    path_21.close();

    Paint paint21Fill = Paint()..style = PaintingStyle.fill;
    paint21Fill.color = Color(0xffD1E4EC).withOpacity(1.0);
    canvas.drawPath(path_21, paint21Fill);

    Path path_22 = Path();
    path_22.moveTo(13.116, 6.446);
    path_22.cubicTo(
      11.904,
      7.197,
      11.498999999999999,
      8.472999999999999,
      12.061,
      9.407,
    );
    path_22.cubicTo(12.622, 10.341, 14.126999999999999, 10.592, 15.318, 9.863);
    path_22.cubicTo(
      16.53,
      9.110999999999999,
      17.002,
      7.7669999999999995,
      16.418,
      6.786999999999999,
    );
    path_22.cubicTo(
      15.812,
      5.784999999999999,
      14.328999999999999,
      5.716999999999999,
      13.116,
      6.445999999999999,
    );
    path_22.close();

    Paint paint22Fill = Paint()..style = PaintingStyle.fill;
    paint22Fill.color = Color(0xffD4E6ED).withOpacity(1.0);
    canvas.drawPath(path_22, paint22Fill);

    Path path_23 = Path();
    path_23.moveTo(13.206, 6.47);
    path_23.cubicTo(
      12.061,
      7.1979999999999995,
      11.655999999999999,
      8.405999999999999,
      12.196,
      9.317,
    );
    path_23.cubicTo(12.735, 10.228, 14.172, 10.457, 15.34, 9.75);
    path_23.cubicTo(16.485, 9.044, 16.957, 7.745, 16.395, 6.788);
    path_23.cubicTo(15.789, 5.831, 14.352, 5.74, 13.206, 6.469);
    path_23.close();

    Paint paint23Fill = Paint()..style = PaintingStyle.fill;
    paint23Fill.color = Color(0xffD6E7EE).withOpacity(1.0);
    canvas.drawPath(path_23, paint23Fill);

    Path path_24 = Path();
    path_24.moveTo(13.274, 6.47);
    path_24.cubicTo(12.174, 7.153, 11.768999999999998, 8.338, 12.308, 9.203);
    path_24.cubicTo(
      12.825,
      10.068999999999999,
      14.217,
      10.296999999999999,
      15.318,
      9.613,
    );
    path_24.cubicTo(16.418, 8.93, 16.868, 7.699999999999999, 16.328, 6.766);
    path_24.cubicTo(15.767, 5.854, 14.396999999999998, 5.786, 13.274, 6.469);
    path_24.close();

    Paint paint24Fill = Paint()..style = PaintingStyle.fill;
    paint24Fill.color = Color(0xffD9E9EF).withOpacity(1.0);
    canvas.drawPath(path_24, paint24Fill);

    Path path_25 = Path();
    path_25.moveTo(13.364, 6.47);
    path_25.cubicTo(12.308, 7.13, 11.926, 8.247, 12.443000000000001, 9.09);
    path_25.cubicTo(
      12.937000000000001,
      9.91,
      14.262,
      10.138,
      15.317000000000002,
      9.477,
    );
    path_25.cubicTo(16.373, 8.817, 16.8, 7.632000000000001, 16.283, 6.767);
    path_25.cubicTo(
      15.744000000000002,
      5.877000000000001,
      14.419,
      5.8100000000000005,
      13.363000000000001,
      6.470000000000001,
    );
    path_25.close();

    Paint paint25Fill = Paint()..style = PaintingStyle.fill;
    paint25Fill.color = Color(0xffDBEAF0).withOpacity(1.0);
    canvas.drawPath(path_25, paint25Fill);

    Path path_26 = Path();
    path_26.moveTo(13.453, 6.469);
    path_26.cubicTo(12.443, 7.107, 12.082999999999998, 8.178, 12.555, 8.975);
    path_26.cubicTo(13.027, 9.772, 14.285, 9.977, 15.317, 9.362);
    path_26.cubicTo(
      16.328,
      8.724,
      16.732,
      7.6080000000000005,
      16.238,
      6.765000000000001,
    );
    path_26.cubicTo(
      15.722,
      5.899000000000001,
      14.463999999999999,
      5.831,
      13.453,
      6.469,
    );
    path_26.close();

    Paint paint26Fill = Paint()..style = PaintingStyle.fill;
    paint26Fill.color = Color(0xffDDEBF1).withOpacity(1.0);
    canvas.drawPath(path_26, paint26Fill);

    Path path_27 = Path();
    path_27.moveTo(13.52, 6.469);
    path_27.cubicTo(12.555, 7.0840000000000005, 12.218, 8.086, 12.667, 8.861);
    path_27.cubicTo(
      13.116999999999999,
      9.612,
      14.329,
      9.817,
      15.295,
      9.225000000000001,
    );
    path_27.cubicTo(
      16.261,
      8.633000000000001,
      16.642,
      7.5390000000000015,
      16.171,
      6.742000000000001,
    );
    path_27.cubicTo(
      15.699,
      5.945000000000001,
      14.485999999999999,
      5.876000000000001,
      13.520999999999999,
      6.469000000000001,
    );
    path_27.close();

    Paint paint27Fill = Paint()..style = PaintingStyle.fill;
    paint27Fill.color = Color(0xffE0EDF2).withOpacity(1.0);
    canvas.drawPath(path_27, paint27Fill);

    Path path_28 = Path();
    path_28.moveTo(13.61, 6.47);
    path_28.cubicTo(12.69, 7.039, 12.375, 8.018, 12.802, 8.747);
    path_28.cubicTo(13.229, 9.477, 14.373999999999999, 9.659, 15.295, 9.089);
    path_28.cubicTo(16.215, 8.519, 16.598, 7.494000000000001, 16.126, 6.743);
    path_28.cubicTo(
      15.676000000000002,
      5.968,
      14.531,
      5.9,
      13.610000000000001,
      6.469,
    );
    path_28.close();

    Paint paint28Fill = Paint()..style = PaintingStyle.fill;
    paint28Fill.color = Color(0xffE2EEF3).withOpacity(1.0);
    canvas.drawPath(path_28, paint28Fill);

    Path path_29 = Path();
    path_29.moveTo(13.678, 6.47);
    path_29.cubicTo(
      12.802000000000001,
      7.016,
      12.510000000000002,
      7.949999999999999,
      12.914000000000001,
      8.61,
    );
    path_29.cubicTo(
      13.319,
      9.293999999999999,
      14.419,
      9.477,
      15.273000000000001,
      8.93,
    );
    path_29.cubicTo(
      16.148000000000003,
      8.383,
      16.508000000000003,
      7.426,
      16.059,
      6.696999999999999,
    );
    path_29.cubicTo(
      15.654000000000002,
      5.991,
      14.554000000000002,
      5.944999999999999,
      13.678,
      6.468999999999999,
    );
    path_29.close();

    Paint paint29Fill = Paint()..style = PaintingStyle.fill;
    paint29Fill.color = Color(0xffE5F0F4).withOpacity(1.0);
    canvas.drawPath(path_29, paint29Fill);

    Path path_30 = Path();
    path_30.moveTo(13.768, 6.493);
    path_30.cubicTo(
      12.937000000000001,
      7.017,
      12.645000000000001,
      7.883,
      13.049000000000001,
      8.521,
    );
    path_30.cubicTo(
      13.431000000000001,
      9.159,
      14.464000000000002,
      9.341000000000001,
      15.295000000000002,
      8.817,
    );
    path_30.cubicTo(16.125, 8.316, 16.463, 7.382, 16.036, 6.698);
    path_30.cubicTo(
      15.632000000000001,
      6.038,
      14.599000000000002,
      5.969,
      13.768,
      6.493,
    );
    path_30.close();

    Paint paint30Fill = Paint()..style = PaintingStyle.fill;
    paint30Fill.color = Color(0xffE7F1F5).withOpacity(1.0);
    canvas.drawPath(path_30, paint30Fill);

    Path path_31 = Path();
    path_31.moveTo(13.857, 6.49);
    path_31.cubicTo(
      13.072,
      6.970000000000001,
      12.802,
      7.812,
      13.184,
      8.405000000000001,
    );
    path_31.cubicTo(
      13.543999999999999,
      9.020000000000001,
      14.508999999999999,
      9.179000000000002,
      15.293999999999999,
      8.701,
    );
    path_31.cubicTo(
      16.081,
      8.222000000000001,
      16.395,
      7.357,
      15.990999999999998,
      6.696000000000001,
    );
    path_31.cubicTo(
      15.586999999999998,
      6.058000000000001,
      14.620999999999999,
      5.99,
      13.857999999999997,
      6.4910000000000005,
    );
    path_31.close();

    Paint paint31Fill = Paint()..style = PaintingStyle.fill;
    paint31Fill.color = Color(0xffE9F2F6).withOpacity(1.0);
    canvas.drawPath(path_31, paint31Fill);

    Path path_32 = Path();
    path_32.moveTo(13.925, 6.492);
    path_32.cubicTo(
      13.184000000000001,
      6.948,
      12.937000000000001,
      7.7219999999999995,
      13.274000000000001,
      8.292,
    );
    path_32.cubicTo(13.611, 8.862, 14.531, 9.020999999999999, 15.25, 8.565);
    path_32.cubicTo(15.991, 8.11, 16.283, 7.289, 15.901, 6.696999999999999);
    path_32.cubicTo(
      15.565,
      6.081999999999999,
      14.666,
      6.036999999999999,
      13.925,
      6.491999999999999,
    );
    path_32.close();

    Paint paint32Fill = Paint()..style = PaintingStyle.fill;
    paint32Fill.color = Color(0xffECF4F7).withOpacity(1.0);
    canvas.drawPath(path_32, paint32Fill);

    Path path_33 = Path();
    path_33.moveTo(14.015, 6.493);
    path_33.cubicTo(
      13.341000000000001,
      6.926,
      13.094000000000001,
      7.655,
      13.408000000000001,
      8.179,
    );
    path_33.cubicTo(13.723, 8.703, 14.576, 8.862, 15.273000000000001, 8.429);
    path_33.cubicTo(
      15.969000000000001,
      7.996,
      16.238000000000003,
      7.245,
      15.901000000000002,
      6.675000000000001,
    );
    path_33.cubicTo(
      15.542000000000002,
      6.105,
      14.689000000000002,
      6.0600000000000005,
      14.015000000000002,
      6.493,
    );
    path_33.close();

    Paint paint33Fill = Paint()..style = PaintingStyle.fill;
    paint33Fill.color = Color(0xffEEF5F8).withOpacity(1.0);
    canvas.drawPath(path_33, paint33Fill);

    Path path_34 = Path();
    path_34.moveTo(14.105, 6.492);
    path_34.cubicTo(
      13.475,
      6.88,
      13.251000000000001,
      7.563,
      13.543000000000001,
      8.064,
    );
    path_34.cubicTo(13.835, 8.565, 14.643, 8.702, 15.273000000000001, 8.292);
    path_34.cubicTo(
      15.901000000000002,
      7.904999999999999,
      16.171000000000003,
      7.199,
      15.857000000000001,
      6.652,
    );
    path_34.cubicTo(
      15.520000000000001,
      6.151,
      14.734000000000002,
      6.105,
      14.105,
      6.492,
    );
    path_34.close();

    Paint paint34Fill = Paint()..style = PaintingStyle.fill;
    paint34Fill.color = Color(0xffF1F7F9).withOpacity(1.0);
    canvas.drawPath(path_34, paint34Fill);

    Path path_35 = Path();
    path_35.moveTo(14.172, 6.491);
    path_35.cubicTo(
      13.588000000000001,
      6.856,
      13.386000000000001,
      7.494,
      13.655000000000001,
      7.949,
    );
    path_35.cubicTo(13.925, 8.405, 14.666, 8.541, 15.250000000000002, 8.177);
    path_35.cubicTo(
      15.834000000000001,
      7.811999999999999,
      16.081000000000003,
      7.151999999999999,
      15.790000000000003,
      6.673,
    );
    path_35.cubicTo(
      15.497000000000003,
      6.173,
      14.756000000000002,
      6.127,
      14.172000000000002,
      6.491,
    );
    path_35.close();

    Paint paint35Fill = Paint()..style = PaintingStyle.fill;
    paint35Fill.color = Color(0xffF3F8FA).withOpacity(1.0);
    canvas.drawPath(path_35, paint35Fill);

    Path path_36 = Path();
    path_36.moveTo(14.262, 6.491);
    path_36.cubicTo(
      13.722000000000001,
      6.832999999999999,
      13.521,
      7.401999999999999,
      13.790000000000001,
      7.835,
    );
    path_36.cubicTo(14.037, 8.268, 14.711, 8.382, 15.25, 8.04);
    path_36.cubicTo(
      15.79,
      7.698999999999999,
      16.014,
      7.105999999999999,
      15.744,
      6.6499999999999995,
    );
    path_36.cubicTo(15.474, 6.194999999999999, 14.801, 6.172, 14.262, 6.491);
    path_36.close();

    Paint paint36Fill = Paint()..style = PaintingStyle.fill;
    paint36Fill.color = Color(0xffF5F9FB).withOpacity(1.0);
    canvas.drawPath(path_36, paint36Fill);

    Path path_37 = Path();
    path_37.moveTo(14.352, 6.492);
    path_37.cubicTo(13.858, 6.811, 13.678, 7.335, 13.925, 7.7219999999999995);
    path_37.cubicTo(
      14.15,
      8.109,
      14.778,
      8.222999999999999,
      15.273000000000001,
      7.904,
    );
    path_37.cubicTo(
      15.767000000000001,
      7.608,
      15.969000000000001,
      7.039,
      15.722000000000001,
      6.629,
    );
    path_37.cubicTo(
      15.452000000000002,
      6.218999999999999,
      14.846000000000002,
      6.196,
      14.352,
      6.491999999999999,
    );
    path_37.close();

    Paint paint37Fill = Paint()..style = PaintingStyle.fill;
    paint37Fill.color = Color(0xffF8FBFC).withOpacity(1.0);
    canvas.drawPath(path_37, paint37Fill);

    Path path_38 = Path();
    path_38.moveTo(14.42, 6.516);
    path_38.cubicTo(13.97, 6.789, 13.813, 7.268, 14.036999999999999, 7.609);
    path_38.cubicTo(
      14.238999999999999,
      7.951,
      14.800999999999998,
      8.042,
      15.25,
      7.769,
    );
    path_38.cubicTo(15.7, 7.495, 15.879, 6.994, 15.654, 6.6290000000000004);
    path_38.cubicTo(15.43, 6.265000000000001, 14.868, 6.219, 14.419, 6.516);
    path_38.close();

    Paint paint38Fill = Paint()..style = PaintingStyle.fill;
    paint38Fill.color = Color(0xffFAFCFD).withOpacity(1.0);
    canvas.drawPath(path_38, paint38Fill);

    Path path_39 = Path();
    path_39.moveTo(14.509, 6.516);
    path_39.cubicTo(
      14.105,
      6.766,
      13.969000000000001,
      7.199,
      14.149000000000001,
      7.496,
    );
    path_39.cubicTo(
      14.329,
      7.814,
      14.846,
      7.883000000000001,
      15.228000000000002,
      7.655,
    );
    path_39.cubicTo(
      15.632000000000001,
      7.405,
      15.789000000000001,
      6.971,
      15.587000000000002,
      6.630000000000001,
    );
    path_39.cubicTo(
      15.407000000000002,
      6.288000000000001,
      14.913000000000002,
      6.265000000000001,
      14.509000000000002,
      6.516000000000001,
    );
    path_39.close();

    Paint paint39Fill = Paint()..style = PaintingStyle.fill;
    paint39Fill.color = Color(0xffFDFEFE).withOpacity(1.0);
    canvas.drawPath(path_39, paint39Fill);

    Path path_40 = Path();
    path_40.moveTo(14.576, 6.515);
    path_40.cubicTo(
      14.216000000000001,
      6.742,
      14.105,
      7.106999999999999,
      14.262,
      7.38,
    );
    path_40.cubicTo(
      14.419,
      7.654,
      14.868,
      7.7219999999999995,
      15.228,
      7.5169999999999995,
    );
    path_40.cubicTo(15.587, 7.289, 15.722, 6.901999999999999, 15.542, 6.606);
    path_40.cubicTo(15.385, 6.31, 14.936, 6.286, 14.576, 6.515);
    path_40.close();

    Paint paint40Fill = Paint()..style = PaintingStyle.fill;
    paint40Fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_40, paint40Fill);

    Path path_41 = Path();
    path_41.moveTo(12.398, 6.88);
    path_41.cubicTo(
      11.094999999999999,
      7.7,
      10.623,
      9.09,
      11.251999999999999,
      10.115,
    );
    path_41.cubicTo(
      11.858999999999998,
      11.14,
      13.498,
      11.414,
      14.800999999999998,
      10.594,
    );
    path_41.cubicTo(
      16.102999999999998,
      9.774,
      16.642,
      8.315999999999999,
      15.990999999999998,
      7.244,
    );
    path_41.cubicTo(
      15.316999999999998,
      6.1739999999999995,
      13.700999999999997,
      6.083,
      12.397999999999998,
      6.88,
    );
    path_41.close();

    Paint paint41Fill = Paint()..style = PaintingStyle.fill;
    paint41Fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.3111190, size.height * 0.1530930),
      Offset(size.width * 0.3388333, size.height * 0.2542791),
      [
        Color(0xffffffff).withOpacity(1),
        Color(0xffC1D8E8).withOpacity(1),
        Color(0xff84B2D2).withOpacity(1),
      ],
      [0, 0.49, 1],
    );
    canvas.drawPath(path_41, paint41Fill);

    Path path_42 = Path();
    path_42.moveTo(12.443, 6.925);
    path_42.cubicTo(
      11.184999999999999,
      7.723,
      10.735999999999999,
      9.044,
      11.341999999999999,
      10.046,
    );
    path_42.cubicTo(
      11.947999999999999,
      11.049,
      13.498,
      11.299,
      14.777999999999999,
      10.524999999999999,
    );
    path_42.cubicTo(
      16.035999999999998,
      9.749999999999998,
      16.552999999999997,
      8.338,
      15.924,
      7.289999999999999,
    );
    path_42.cubicTo(
      15.272,
      6.218999999999999,
      13.7,
      6.127999999999999,
      12.443,
      6.924999999999999,
    );
    path_42.close();

    Paint paint42Fill = Paint()..style = PaintingStyle.fill;
    paint42Fill.color = Color(0xffB2D2DF).withOpacity(1.0);
    canvas.drawPath(path_42, paint42Fill);

    Path path_43 = Path();
    path_43.moveTo(12.465, 6.925);
    path_43.cubicTo(11.251999999999999, 7.677, 10.825, 8.975, 11.387, 9.933);
    path_43.cubicTo(11.971, 10.889, 13.476, 11.14, 14.688, 10.388);
    path_43.cubicTo(
      15.901,
      9.636,
      16.395,
      8.269,
      15.789000000000001,
      7.2669999999999995,
    );
    path_43.cubicTo(
      15.205000000000002,
      6.241999999999999,
      13.700000000000001,
      6.172999999999999,
      12.465000000000002,
      6.925,
    );
    path_43.close();

    Paint paint43Fill = Paint()..style = PaintingStyle.fill;
    paint43Fill.color = Color(0xffB6D4E0).withOpacity(1.0);
    canvas.drawPath(path_43, paint43Fill);

    Path path_44 = Path();
    path_44.moveTo(12.51, 6.925);
    path_44.cubicTo(11.342, 7.654, 10.937999999999999, 8.885, 11.477, 9.818);
    path_44.cubicTo(12.038, 10.729, 13.476, 10.98, 14.644, 10.251);
    path_44.cubicTo(15.812, 9.522, 16.284, 8.222999999999999, 15.699, 7.244);
    path_44.cubicTo(
      15.138,
      6.287,
      13.678,
      6.218999999999999,
      12.51,
      6.9239999999999995,
    );
    path_44.close();

    Paint paint44Fill = Paint()..style = PaintingStyle.fill;
    paint44Fill.color = Color(0xffB9D6E2).withOpacity(1.0);
    canvas.drawPath(path_44, paint44Fill);

    Path path_45 = Path();
    path_45.moveTo(12.555, 6.949);
    path_45.cubicTo(11.432, 7.654999999999999, 11.05, 8.839, 11.567, 9.729);
    path_45.cubicTo(
      12.106,
      10.616999999999999,
      13.498000000000001,
      10.844,
      14.621,
      10.139,
    );
    path_45.cubicTo(
      15.744,
      9.431999999999999,
      16.193,
      8.178999999999998,
      15.631,
      7.267999999999999,
    );
    path_45.cubicTo(
      15.071,
      6.333999999999999,
      13.678,
      6.241999999999999,
      12.555,
      6.947999999999999,
    );
    path_45.close();

    Paint paint45Fill = Paint()..style = PaintingStyle.fill;
    paint45Fill.color = Color(0xffBDD8E3).withOpacity(1.0);
    canvas.drawPath(path_45, paint45Fill);

    Path path_46 = Path();
    path_46.moveTo(12.6, 6.949);
    path_46.cubicTo(11.522, 7.632, 11.14, 8.771, 11.655999999999999, 9.614);
    path_46.cubicTo(
      12.172999999999998,
      10.457,
      13.498,
      10.685,
      14.575999999999999,
      10.024000000000001,
    );
    path_46.cubicTo(
      15.653999999999998,
      9.364,
      16.081,
      8.156,
      15.541999999999998,
      7.268000000000001,
    );
    path_46.cubicTo(
      15.024999999999999,
      6.356000000000001,
      13.677999999999997,
      6.288,
      12.599999999999998,
      6.948,
    );
    path_46.close();

    Paint paint46Fill = Paint()..style = PaintingStyle.fill;
    paint46Fill.color = Color(0xffC0DAE5).withOpacity(1.0);
    canvas.drawPath(path_46, paint46Fill);

    Path path_47 = Path();
    path_47.moveTo(12.645, 6.972);
    path_47.cubicTo(
      11.610999999999999,
      7.61,
      11.251999999999999,
      8.703000000000001,
      11.745999999999999,
      9.524000000000001,
    );
    path_47.cubicTo(
      12.239999999999998,
      10.321000000000002,
      13.52,
      10.549000000000001,
      14.553999999999998,
      9.911000000000001,
    );
    path_47.cubicTo(
      15.586999999999998,
      9.273000000000001,
      15.990999999999998,
      8.134000000000002,
      15.496999999999998,
      7.268000000000002,
    );
    path_47.cubicTo(
      14.956999999999997,
      6.402000000000002,
      13.676999999999998,
      6.334000000000001,
      12.644999999999998,
      6.972000000000001,
    );
    path_47.close();

    Paint paint47Fill = Paint()..style = PaintingStyle.fill;
    paint47Fill.color = Color(0xffC4DCE6).withOpacity(1.0);
    canvas.drawPath(path_47, paint47Fill);

    Path path_48 = Path();
    path_48.moveTo(12.69, 6.97);
    path_48.cubicTo(
      11.700999999999999,
      7.585999999999999,
      11.365,
      8.634,
      11.836,
      9.408,
    );
    path_48.cubicTo(12.308, 10.183, 13.521, 10.388, 14.509, 9.773);
    path_48.cubicTo(15.497, 9.158, 15.901, 8.064, 15.407, 7.244);
    path_48.cubicTo(14.891, 6.4239999999999995, 13.677, 6.356, 12.69, 6.971);
    path_48.close();

    Paint paint48Fill = Paint()..style = PaintingStyle.fill;
    paint48Fill.color = Color(0xffC7DEE8).withOpacity(1.0);
    canvas.drawPath(path_48, paint48Fill);

    Path path_49 = Path();
    path_49.moveTo(12.735, 6.97);
    path_49.cubicTo(11.791, 7.563, 11.477, 8.542, 11.902999999999999, 9.271);
    path_49.cubicTo(
      12.352999999999998,
      10.001000000000001,
      13.52,
      10.205,
      14.440999999999999,
      9.613000000000001,
    );
    path_49.cubicTo(
      15.384999999999998,
      9.043000000000001,
      15.765999999999998,
      7.995000000000001,
      15.294999999999998,
      7.221000000000002,
    );
    path_49.cubicTo(
      14.822999999999999,
      6.469000000000002,
      13.654999999999998,
      6.401000000000002,
      12.734999999999998,
      6.971000000000002,
    );
    path_49.close();

    Paint paint49Fill = Paint()..style = PaintingStyle.fill;
    paint49Fill.color = Color(0xffCBE0E9).withOpacity(1.0);
    canvas.drawPath(path_49, paint49Fill);

    Path path_50 = Path();
    path_50.moveTo(12.757, 6.994);
    path_50.cubicTo(11.858, 7.5409999999999995, 11.567, 8.498, 11.971, 9.181);
    path_50.cubicTo(
      12.398,
      9.886999999999999,
      13.498,
      10.069999999999999,
      14.396,
      9.523,
    );
    path_50.cubicTo(
      15.295000000000002,
      8.975999999999999,
      15.654,
      7.973,
      15.205,
      7.244999999999999,
    );
    path_50.cubicTo(
      14.755,
      6.492999999999999,
      13.655,
      6.446999999999999,
      12.757,
      6.993999999999999,
    );
    path_50.close();

    Paint paint50Fill = Paint()..style = PaintingStyle.fill;
    paint50Fill.color = Color(0xffCEE2EB).withOpacity(1.0);
    canvas.drawPath(path_50, paint50Fill);

    Path path_51 = Path();
    path_51.moveTo(12.802, 6.994);
    path_51.cubicTo(11.948, 7.518, 11.655999999999999, 8.407, 12.061, 9.067);
    path_51.cubicTo(12.465, 9.728, 13.498, 9.91, 14.350999999999999, 9.387);
    path_51.cubicTo(
      15.204999999999998,
      8.862,
      15.540999999999999,
      7.928000000000001,
      15.114999999999998,
      7.222,
    );
    path_51.cubicTo(
      14.710999999999999,
      6.538,
      13.654999999999998,
      6.470000000000001,
      12.801999999999998,
      6.994000000000001,
    );
    path_51.close();

    Paint paint51Fill = Paint()..style = PaintingStyle.fill;
    paint51Fill.color = Color(0xffD2E4EC).withOpacity(1.0);
    canvas.drawPath(path_51, paint51Fill);

    Path path_52 = Path();
    path_52.moveTo(12.847, 7.017);
    path_52.cubicTo(12.061, 7.518000000000001, 11.769, 8.361, 12.151, 8.977);
    path_52.cubicTo(
      12.532,
      9.591000000000001,
      13.521,
      9.774000000000001,
      14.307,
      9.272,
    );
    path_52.cubicTo(15.093, 8.772, 15.43, 7.882000000000001, 15.025, 7.222);
    path_52.cubicTo(
      14.644,
      6.562,
      13.655000000000001,
      6.516,
      12.847000000000001,
      7.017,
    );
    path_52.close();

    Paint paint52Fill = Paint()..style = PaintingStyle.fill;
    paint52Fill.color = Color(0xffD5E6EE).withOpacity(1.0);
    canvas.drawPath(path_52, paint52Fill);

    Path path_53 = Path();
    path_53.moveTo(12.892, 7.017);
    path_53.cubicTo(12.151, 7.496, 11.882, 8.293000000000001, 12.24, 8.863);
    path_53.cubicTo(12.6, 9.455, 13.52, 9.615, 14.284, 9.136);
    path_53.cubicTo(
      15.025,
      8.681,
      15.34,
      7.837999999999999,
      14.958,
      7.2219999999999995,
    );
    path_53.cubicTo(
      14.576,
      6.606999999999999,
      13.633000000000001,
      6.561999999999999,
      12.892,
      7.0169999999999995,
    );
    path_53.close();

    Paint paint53Fill = Paint()..style = PaintingStyle.fill;
    paint53Fill.color = Color(0xffD9E9EF).withOpacity(1.0);
    canvas.drawPath(path_53, paint53Fill);

    Path path_54 = Path();
    path_54.moveTo(12.937, 7.039);
    path_54.cubicTo(
      12.24,
      7.4719999999999995,
      11.992999999999999,
      8.224,
      12.306999999999999,
      8.77,
    );
    path_54.cubicTo(
      12.644999999999998,
      9.317,
      13.52,
      9.477,
      14.216999999999999,
      9.020999999999999,
    );
    path_54.cubicTo(
      14.912999999999998,
      8.588,
      15.204999999999998,
      7.790999999999999,
      14.845999999999998,
      7.220999999999999,
    );
    path_54.cubicTo(
      14.508999999999999,
      6.629,
      13.633,
      6.582999999999999,
      12.935999999999998,
      7.038999999999999,
    );
    path_54.close();

    Paint paint54Fill = Paint()..style = PaintingStyle.fill;
    paint54Fill.color = Color(0xffDCEBF0).withOpacity(1.0);
    canvas.drawPath(path_54, paint54Fill);

    Path path_55 = Path();
    path_55.moveTo(12.982, 7.038);
    path_55.cubicTo(
      12.33,
      7.448,
      12.082999999999998,
      8.155000000000001,
      12.398,
      8.656,
    );
    path_55.cubicTo(
      12.712,
      9.18,
      13.520999999999999,
      9.316,
      14.193999999999999,
      8.906,
    );
    path_55.cubicTo(
      14.845999999999998,
      8.496,
      15.114999999999998,
      7.767,
      14.777999999999999,
      7.221,
    );
    path_55.cubicTo(14.440999999999999, 6.674, 13.633, 6.628, 12.982, 7.038);
    path_55.close();

    Paint paint55Fill = Paint()..style = PaintingStyle.fill;
    paint55Fill.color = Color(0xffDFEDF2).withOpacity(1.0);
    canvas.drawPath(path_55, paint55Fill);

    Path path_56 = Path();
    path_56.moveTo(13.027, 7.04);
    path_56.cubicTo(
      12.42,
      7.427,
      12.194999999999999,
      8.065,
      12.486999999999998,
      8.543,
    );
    path_56.cubicTo(
      12.778999999999998,
      9.021999999999998,
      13.543,
      9.158999999999999,
      14.148999999999997,
      8.770999999999999,
    );
    path_56.cubicTo(
      14.755999999999997,
      8.383999999999999,
      15.002999999999997,
      7.700999999999999,
      14.710999999999997,
      7.198999999999999,
    );
    path_56.cubicTo(
      14.395999999999997,
      6.720999999999999,
      13.632999999999997,
      6.674999999999999,
      13.026999999999997,
      7.038999999999999,
    );
    path_56.close();

    Paint paint56Fill = Paint()..style = PaintingStyle.fill;
    paint56Fill.color = Color(0xffE3EFF3).withOpacity(1.0);
    canvas.drawPath(path_56, paint56Fill);

    Path path_57 = Path();
    path_57.moveTo(13.071, 7.062);
    path_57.cubicTo(12.488, 7.404, 12.308, 7.996, 12.555, 8.452);
    path_57.cubicTo(
      12.825,
      8.885,
      13.520999999999999,
      9.022,
      14.081999999999999,
      8.657,
    );
    path_57.cubicTo(
      14.643999999999998,
      8.315,
      14.867999999999999,
      7.677,
      14.598999999999998,
      7.199,
    );
    path_57.cubicTo(
      14.328999999999999,
      6.742999999999999,
      13.633,
      6.6979999999999995,
      13.070999999999998,
      7.061999999999999,
    );
    path_57.close();

    Paint paint57Fill = Paint()..style = PaintingStyle.fill;
    paint57Fill.color = Color(0xffE6F1F5).withOpacity(1.0);
    canvas.drawPath(path_57, paint57Fill);

    Path path_58 = Path();
    path_58.moveTo(13.094, 7.062);
    path_58.cubicTo(12.577, 7.381, 12.398, 7.928, 12.644, 8.338000000000001);
    path_58.cubicTo(
      12.892,
      8.748000000000001,
      13.544,
      8.862000000000002,
      14.06,
      8.520000000000001,
    );
    path_58.cubicTo(
      14.576,
      8.201,
      14.778,
      7.631000000000001,
      14.531,
      7.199000000000002,
    );
    path_58.cubicTo(
      14.261000000000001,
      6.7890000000000015,
      13.611,
      6.743000000000001,
      13.094000000000001,
      7.062000000000001,
    );
    path_58.close();

    Paint paint58Fill = Paint()..style = PaintingStyle.fill;
    paint58Fill.color = Color(0xffEAF3F6).withOpacity(1.0);
    canvas.drawPath(path_58, paint58Fill);

    Path path_59 = Path();
    path_59.moveTo(13.139, 7.084);
    path_59.cubicTo(
      12.667,
      7.38,
      12.508999999999999,
      7.880999999999999,
      12.735,
      8.245999999999999,
    );
    path_59.cubicTo(
      12.959,
      8.61,
      13.543,
      8.723999999999998,
      14.014999999999999,
      8.427999999999999,
    );
    path_59.cubicTo(
      14.485999999999999,
      8.132,
      14.665999999999999,
      7.607999999999999,
      14.440999999999999,
      7.219999999999999,
    );
    path_59.cubicTo(
      14.193999999999999,
      6.809999999999999,
      13.610999999999999,
      6.7879999999999985,
      13.139,
      7.083999999999999,
    );
    path_59.close();

    Paint paint59Fill = Paint()..style = PaintingStyle.fill;
    paint59Fill.color = Color(0xffEDF5F8).withOpacity(1.0);
    canvas.drawPath(path_59, paint59Fill);

    Path path_60 = Path();
    path_60.moveTo(13.184, 7.086);
    path_60.cubicTo(12.757, 7.359, 12.6, 7.792, 12.802, 8.134);
    path_60.cubicTo(13.004, 8.475, 13.520999999999999, 8.544, 13.947, 8.294);
    path_60.cubicTo(
      14.373999999999999,
      8.02,
      14.553999999999998,
      7.564,
      14.328999999999999,
      7.2,
    );
    path_60.cubicTo(14.149, 6.8580000000000005, 13.61, 6.812, 13.184, 7.086);
    path_60.close();

    Paint paint60Fill = Paint()..style = PaintingStyle.fill;
    paint60Fill.color = Color(0xffF1F7F9).withOpacity(1.0);
    canvas.drawPath(path_60, paint60Fill);

    Path path_61 = Path();
    path_61.moveTo(13.229, 7.084);
    path_61.cubicTo(
      12.847,
      7.311999999999999,
      12.712,
      7.7219999999999995,
      12.892,
      8.017999999999999,
    );
    path_61.cubicTo(
      13.072,
      8.313999999999998,
      13.543,
      8.382,
      13.924999999999999,
      8.155,
    );
    path_61.cubicTo(
      14.306999999999999,
      7.927,
      14.463999999999999,
      7.494,
      14.261999999999999,
      7.174999999999999,
    );
    path_61.cubicTo(
      14.081999999999999,
      6.878999999999999,
      13.61,
      6.855999999999999,
      13.227999999999998,
      7.083999999999999,
    );
    path_61.close();

    Paint paint61Fill = Paint()..style = PaintingStyle.fill;
    paint61Fill.color = Color(0xffF4F9FB).withOpacity(1.0);
    canvas.drawPath(path_61, paint61Fill);

    Path path_62 = Path();
    path_62.moveTo(13.274, 7.107);
    path_62.cubicTo(
      12.937,
      7.312,
      12.824,
      7.6770000000000005,
      12.982,
      7.9270000000000005,
    );
    path_62.cubicTo(13.139, 8.177, 13.543, 8.247, 13.879999999999999, 8.041);
    path_62.cubicTo(
      14.216999999999999,
      7.836,
      14.351999999999999,
      7.471,
      14.171999999999999,
      7.198,
    );
    path_62.cubicTo(
      14.014999999999999,
      6.925000000000001,
      13.61,
      6.902,
      13.273,
      7.1080000000000005,
    );
    path_62.close();

    Paint paint62Fill = Paint()..style = PaintingStyle.fill;
    paint62Fill.color = Color(0xffF8FBFC).withOpacity(1.0);
    canvas.drawPath(path_62, paint62Fill);

    Path path_63 = Path();
    path_63.moveTo(13.318, 7.108);
    path_63.cubicTo(13.027, 7.29, 12.937, 7.585999999999999, 13.071, 7.814);
    path_63.cubicTo(13.206, 8.042, 13.565999999999999, 8.087, 13.858, 7.928);
    path_63.cubicTo(
      14.149000000000001,
      7.7459999999999996,
      14.262,
      7.427,
      14.127,
      7.199,
    );
    path_63.cubicTo(
      13.947000000000001,
      6.949,
      13.588000000000001,
      6.926,
      13.318000000000001,
      7.108,
    );
    path_63.close();

    Paint paint63Fill = Paint()..style = PaintingStyle.fill;
    paint63Fill.color = Color(0xffFBFDFE).withOpacity(1.0);
    canvas.drawPath(path_63, paint63Fill);

    Path path_64 = Path();
    path_64.moveTo(13.363, 7.131);
    path_64.cubicTo(13.116, 7.291, 13.049, 7.541, 13.161, 7.723);
    path_64.cubicTo(
      13.274,
      7.906,
      13.565999999999999,
      7.951,
      13.812999999999999,
      7.814,
    );
    path_64.cubicTo(
      14.059999999999999,
      7.655,
      14.149,
      7.404,
      14.036999999999999,
      7.199,
    );
    path_64.cubicTo(
      13.879999999999999,
      6.994,
      13.588,
      6.9719999999999995,
      13.363,
      7.131,
    );
    path_64.close();

    Paint paint64Fill = Paint()..style = PaintingStyle.fill;
    paint64Fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_64, paint64Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
