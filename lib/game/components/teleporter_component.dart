import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class TeleporterComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final Vector2 fractionalPosition;
  final double radius;
  final int index; // To pair teleporters (0 and 1)

  // Cached Paints
  late final Paint _vortexPaint;
  late final Paint _corePaint;
  late final Paint _rimPaint;

  double _rotation = 0.0;
  bool isClosed = false;
  double _currentScale = 1.0;

  TeleporterComponent(this.fractionalPosition, this.radius, this.index)
      : super(
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Outer swirling blue vortex
    _vortexPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.cyanAccent.withValues(alpha: 0.1),
          Colors.blueAccent.withValues(alpha: 0.8),
          Colors.indigo.withValues(alpha: 0.9),
          Colors.cyanAccent.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    // Dark core
    _corePaint = Paint()
      ..color = Colors.black
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    // Mechanical outer rim
    _rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = RadialGradient(
        colors: [Colors.blueGrey.shade800, Colors.grey.shade400],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isSpawningLevel && game.size.x > 0 && game.size.y > 0) {
      position = Vector2(
        fractionalPosition.x * game.size.x,
        120.0 + fractionalPosition.y * (game.size.y - 320.0),
      );
    }
    
    // Rotate the vortex
    _rotation -= dt * 3.0; // Spin counter-clockwise

    if (isClosed) {
      _currentScale -= dt * 3.0; // Shrink fast
      if (_currentScale < 0) _currentScale = 0;
    } else {
      _currentScale += dt * 3.0;
      if (_currentScale > 1.0) _currentScale = 1.0;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    if (_currentScale <= 0) return;

    canvas.save();
    canvas.translate(radius, radius);
    canvas.scale(_currentScale);

    // Rim
    canvas.drawCircle(Offset.zero, radius, _rimPaint);

    // Vortex
    canvas.save();
    canvas.rotate(_rotation);
    canvas.drawCircle(Offset.zero, radius * 0.9, _vortexPaint);
    canvas.restore();

    // Core
    canvas.drawCircle(Offset.zero, radius * 0.5, _corePaint);

    canvas.restore();
  }
}
