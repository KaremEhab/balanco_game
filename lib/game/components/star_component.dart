import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../game_area.dart';

class StarComponent extends Component with HasGameReference<BalancoGame> {
  final Vector2 fractionalPosition;
  double _time = 0.0;
  bool isCollected = false;
  double _collectedTime = 0.0;

  late TextPainter textPainter;
  
  // Cached Paints
  late final Paint _dropShadowPaint;
  late final Paint _coinBasePaint;
  late final Paint _innerCoinPaint;
  late final Paint _rimHighlightPaint;
  late final Paint _innerShadowPaint;
  late final Paint _fadePaint;

  StarComponent(this.fractionalPosition) {
    textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(IconlyBold.star.codePoint),
        style: TextStyle(
          fontFamily: IconlyBold.star.fontFamily,
          package: IconlyBold.star.fontPackage,
          color: Colors.yellow.shade100,
          fontSize: 14,
          shadows: [
            const Shadow(
              color: Colors.black45,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    double radius = 14.0;

    _dropShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    _coinBasePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: [Colors.yellow.shade300, Colors.amber.shade700],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    _innerCoinPaint = Paint()
      ..shader = RadialGradient(
            center: const Alignment(0.3, 0.3),
            radius: 1.0,
            colors: [Colors.amber.shade300, Colors.orange.shade600],
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius - 3.0));

    _rimHighlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        radius: 1.0,
        colors: [Colors.white.withValues(alpha: 0.8), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    _innerShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.black38;
      
    _fadePaint = Paint();
  }

  void reset() {
    isCollected = false;
    _collectedTime = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isCollected) {
      _collectedTime += dt;
    } else {
      _time += dt;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.size.x == 0) return;
    if (isCollected && _collectedTime > 0.5) return;

    Vector2 pos = Vector2(
      fractionalPosition.x * game.size.x,
      fractionalPosition.y * game.size.y,
    );

    double pulseScale = 1.0 + 0.1 * sin(_time * 4);
    double fade = 1.0;

    if (isCollected) {
      double progress = _collectedTime / 0.5; // 0.0 to 1.0
      pos.y -= progress * 40.0; // Float upwards
      pulseScale = 1.0 + progress * 1.5; // Scale up
      fade = 1.0 - progress; // Fade out
    }

    canvas.save();
    canvas.translate(pos.x, pos.y);

    if (fade < 1.0) {
      _fadePaint.color = Colors.white.withValues(alpha: fade);
      canvas.saveLayer(
        Rect.fromCircle(center: Offset.zero, radius: 50 * pulseScale),
        _fadePaint,
      );
    }

    if (!isCollected) {
      canvas.save();
      canvas.translate(4.0, 8.0);
      canvas.scale(1.0, 0.5);
      canvas.drawCircle(Offset.zero, 14.0 * pulseScale, _dropShadowPaint);
      canvas.restore();
    }

    canvas.scale(pulseScale, pulseScale);

    double radius = 14.0;

    canvas.drawCircle(Offset.zero, radius, _coinBasePaint);
    canvas.drawCircle(Offset.zero, radius - 3.0, _innerCoinPaint);
    canvas.drawCircle(Offset.zero, radius, _rimHighlightPaint);
    canvas.drawCircle(Offset.zero, radius - 3.0, _innerShadowPaint);

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    if (fade < 1.0) {
      canvas.restore();
    }

    canvas.restore();
  }
}
