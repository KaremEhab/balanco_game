import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_area.dart';
import 'game_area/collected_heart_painter.dart';

class HeartComponent extends PositionComponent with HasGameReference<BalancoGame> {
  Vector2 fractionalPosition;
  double _time = 0.0;
  bool isCollected = false;
  double _collectedTime = 0.0;

  late final CollectedHeartPainter _painter;

  // Cached Paints
  late final Paint _dropShadowPaint;
  late final Paint _fadePaint;

  HeartComponent(this.fractionalPosition) {
    size = Vector2(34, 34);
    anchor = Anchor.center;
    _painter = CollectedHeartPainter();
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
        120.0 + fractionalPosition.y * (game.levelHeight - 320.0),
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

    double pulseScale = 1.0 + 0.1 * sin(_time * 4);
    double fade = 1.0;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);

    if (isCollected) {
      double progress = _collectedTime / 0.5; // 0.0 to 1.0
      canvas.translate(0, -progress * 40.0); // Float upwards
      pulseScale = 1.0 + progress * 1.5; // Scale up
      fade = 1.0 - progress; // Fade out
    }

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
      canvas.drawCircle(Offset.zero, 17.0 * pulseScale, _dropShadowPaint);
      canvas.restore();
    }

    canvas.scale(pulseScale, pulseScale);

    // The exported SVG paths inside CollectedHeartPainter assume a 48x48 canvas.
    // We scale the drawing to match this component's size.
    canvas.save();
    canvas.scale(size.x / 48.0, size.y / 48.0);
    canvas.translate(-24.0, -24.0); // Shift so the center of 48x48 box sits at (0,0)
    _painter.paint(canvas, const Size(48, 48));
    canvas.restore();

    if (fade < 1.0) {
      canvas.restore();
    }

    canvas.restore();
  }
}
