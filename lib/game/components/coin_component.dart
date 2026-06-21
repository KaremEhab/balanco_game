import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_area.dart';
import 'game_area/coin_painter.dart';

class CoinComponent extends PositionComponent with HasGameReference<BalancoGame> {
  Vector2 fractionalPosition;
  double _time = 0.0;
  bool isCollected = false;
  double _collectedTime = 0.0;

  late final CoinPainter _painter;
  late final Paint _dropShadowPaint;
  late final Paint _fadePaint;

  CoinComponent(this.fractionalPosition) {
    size = Vector2(34, 34);
    anchor = Anchor.center;
    _painter = CoinPainter();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _dropShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    _fadePaint = Paint();
  }

  void reset() {
    isCollected = false;
    _collectedTime = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!game.isSpawningLevel && game.size.x > 0 && game.size.y > 0 && !isCollected) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        fractionalPosition.y * game.size.y,
      );
    }
    
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

    // Coins can bob up and down slightly
    double bobOffset = sin(_time * 3) * 5.0;
    double fade = 1.0;
    double scale = 1.0;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);

    if (isCollected) {
      double progress = _collectedTime / 0.5; // 0.0 to 1.0
      canvas.translate(0, -progress * 60.0); // Float upwards much faster
      scale = 1.0 + progress * 0.5; // Scale up a bit
      fade = 1.0 - progress; // Fade out
      bobOffset = 0;
    }

    if (fade < 1.0) {
      _fadePaint.color = Colors.white.withValues(alpha: fade);
      canvas.saveLayer(
        Rect.fromCircle(center: Offset.zero, radius: 50 * scale),
        _fadePaint,
      );
    }

    canvas.translate(0, bobOffset);
    canvas.scale(scale, scale);

    if (!isCollected) {
      // Draw shadow further down
      canvas.save();
      canvas.translate(4.0, 15.0 - bobOffset); // Shadow stays on ground while coin bobs
      canvas.scale(1.0, 0.4);
      canvas.drawCircle(Offset.zero, 15.0, _dropShadowPaint);
      canvas.restore();
    }

    // Paint coin
    canvas.save();
    canvas.translate(-size.x / 2, -size.y / 2);
    _painter.paint(canvas, Size(size.x, size.y));
    canvas.restore();

    if (fade < 1.0) {
      canvas.restore();
    }

    canvas.restore();
  }
}
