import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';

class DarknessOverlay extends PositionComponent
    with HasGameReference<BalancoGame> {
  double overlayOpacity = 0.0;
  bool isIlluminated = true;

  @override
  int get priority => 100; // Render above everything else on the board

  @override
  void update(double dt) {
    super.update(dt);
    if (isIlluminated) {
      overlayOpacity -= dt * 3.33; // Fades out over ~300ms
      if (overlayOpacity < 0.0) overlayOpacity = 0.0;
    } else {
      overlayOpacity += dt * 10.0; // Fades in over ~100ms
      if (overlayOpacity > 0.95) overlayOpacity = 0.95;
    }
  }

  @override
  void render(Canvas canvas) {
    if (overlayOpacity <= 0.0) return;
    if (game.activeBalls.isEmpty) return;

    final ball = game.activeBalls.firstWhere(
      (b) => !b.isDead,
      orElse: () => game.activeBalls[0],
    );

    final ballPos = ball.pos2D;

    final ballCenter = Offset(ballPos.x, ballPos.y - game.cameraOffsetY);

    // Save a layer to compose the darkness and the hole
    canvas.saveLayer(Rect.fromLTWH(0, 0, game.size.x, game.size.y), Paint());

    // Draw the full darkness overlay
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF0A0A1A).withValues(alpha: overlayOpacity);
    canvas.drawRect(Rect.fromLTWH(0, 0, game.size.x, game.size.y), bgPaint);

    // Punch out the soft spotlight using BlendMode.dstOut
    final Paint holePaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..shader = RadialGradient(
        colors: [
          Colors.black, // Center core is completely transparent
          Colors.black, // Core extends out a bit
          Colors.black.withValues(alpha: 0.6), // Smooth fade starts
          Colors.black.withValues(alpha: 0.2), // Fades out
          Colors.transparent, // Edges are dark
        ],
        stops: const [0.0, 0.25, 0.45, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: ballCenter, radius: 65.0));

    canvas.drawCircle(ballCenter, 65.0, holePaint);

    canvas.restore();
  }
}
