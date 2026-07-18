import 'dart:math' as math;

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class RacePickupClaimEffect extends PositionComponent {
  RacePickupClaimEffect({required super.position, required this.claimantName})
    : super(size: Vector2(96, 58), anchor: Anchor.center, priority: 90);

  final String claimantName;
  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    position.y -= 28 * dt;
    if (_elapsed >= 0.9) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / 0.9).clamp(0.0, 1.0);
    final alpha = (1 - Curves.easeIn.transform(progress)).clamp(0.0, 1.0);
    final burst = 0.85 + math.sin(progress * math.pi) * 0.24;
    final center = Offset(size.x / 2, size.y / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(burst, burst);
    canvas.drawCircle(
      Offset.zero,
      23,
      Paint()
        ..color = GameColors.red300.withValues(alpha: 0.22 * alpha)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset.zero,
      20,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.82 * alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.restore();

    final shortName = claimantName.trim().isEmpty
        ? 'RIVAL'
        : claimantName.trim().split(RegExp(r'\s+')).first.toUpperCase();
    final painter = TextPainter(
      text: TextSpan(
        text: '$shortName TOOK IT!',
        style: TextStyle(
          color: GameColors.red300.withValues(alpha: alpha),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.75 * alpha),
              offset: const Offset(1, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    )..layout(maxWidth: size.x);
    painter.paint(canvas, Offset((size.x - painter.width) / 2, size.y - 13));
  }
}
