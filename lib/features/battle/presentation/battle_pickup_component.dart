import 'dart:math' as math;

import 'package:balanco_game/features/game/models/race_pickup.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BattlePickupComponent extends PositionComponent {
  BattlePickupComponent({
    required this.type,
    required this.typeIndex,
    required Vector2 position,
  }) : _baseY = position.y,
       super(
         position: position,
         size: Vector2(44, 34),
         anchor: Anchor.center,
         priority: 8,
       );

  final RacePickupType type;
  final int typeIndex;
  final double _baseY;

  bool isCollected = false;
  double _elapsed = 0;

  String get pickupKey => '${type.wireName}:$typeIndex';

  Color get color => switch (type) {
    RacePickupType.battleRocket => const Color(0xFFFF5A4F),
    RacePickupType.battleBomb => const Color(0xFF8C6BE8),
    RacePickupType.battleNails => const Color(0xFF5D708B),
    RacePickupType.battleShield => const Color(0xFF25CBE6),
    RacePickupType.battleTurbo => const Color(0xFFFFC83D),
    _ => Colors.white,
  };

  IconData get icon => switch (type) {
    RacePickupType.battleRocket => Icons.rocket_launch_rounded,
    RacePickupType.battleBomb => Icons.brightness_1_rounded,
    RacePickupType.battleNails => Icons.change_history_rounded,
    RacePickupType.battleShield => Icons.shield_rounded,
    RacePickupType.battleTurbo => Icons.bolt_rounded,
    _ => Icons.help_rounded,
  };

  void collect() {
    isCollected = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (!isCollected) {
      position.y = _baseY + math.sin(_elapsed * 3.4 + typeIndex) * 4;
      angle = math.sin(_elapsed * 2.2 + typeIndex) * 0.04;
    }
  }

  @override
  void render(Canvas canvas) {
    if (isCollected) return;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final capsule = RRect.fromRectAndRadius(rect, const Radius.circular(17));
    canvas.drawRRect(
      capsule.shift(const Offset(0, 4)),
      Paint()..color = Colors.black.withValues(alpha: 0.34),
    );
    canvas.drawRRect(
      capsule,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.96),
            color.withValues(alpha: 0.58),
          ],
        ).createShader(rect),
    );
    canvas.drawRRect(
      capsule,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
          fontSize: 21,
          shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size.x - iconPainter.width) / 2,
        (size.y - iconPainter.height) / 2 - 1,
      ),
    );
  }
}
