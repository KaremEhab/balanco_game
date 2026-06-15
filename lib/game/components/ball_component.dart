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
      ..strokeWidth = 2;

    _fadePaint = Paint();
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    if (game.ballPos2D.isZero()) return;

    canvas.save();
    canvas.translate(game.ballPos2D.x, game.ballPos2D.y);
    canvas.scale(game.ballScale, game.ballScale);

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

    // 1. Base color (Shell white)
    canvas.drawCircle(Offset.zero, game.ballRadius, Paint()..color = const Color(0xFFFFF3E0));

    // 2. Rotating swirl markings
    canvas.save();
    double angle = (game.isFalling || game.isFallingInHole)
        ? game.fallRotation
        : (game.ballP / game.ballRadius);
    canvas.rotate(angle);

    Paint swirlPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      canvas.rotate(2 * pi / 3);
      Path stripe = Path();
      stripe.moveTo(0, 0);
      stripe.quadraticBezierTo(
        game.ballRadius * 0.5, 
        -game.ballRadius * 0.8, 
        game.ballRadius, 
        0,
      );
      canvas.drawPath(stripe, swirlPaint);
    }
    canvas.restore();

    // 3. 3D shading overlay (stationary highlight)
    canvas.drawCircle(Offset.zero, game.ballRadius, _highlightPaint);

    // 4. Outer border
    canvas.drawCircle(Offset.zero, game.ballRadius, _borderPaint);

    if (fallFade < 1.0) {
      canvas.restore(); // Restore saveLayer
    }

    canvas.restore();
  }
}
