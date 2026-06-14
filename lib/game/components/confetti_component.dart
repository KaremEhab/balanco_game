import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ConfettiComponent extends PositionComponent {
  final Random _random = Random();
  final List<ConfettiPiece> _pieces = [];
  final List<Color> _colors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
  ];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Generate 150 confetti pieces bursting from the top middle of the screen
    for (int i = 0; i < 150; i++) {
      _pieces.add(_generatePiece());
    }
  }

  ConfettiPiece _generatePiece() {
    double speed = _random.nextDouble() * 600 + 200; // 200 to 800
    double angle = _random.nextDouble() * pi; // Burst upwards (0 to pi radians)
    // Actually, screen coordinates: Y goes down. So we want angle between pi and 2*pi
    angle = _random.nextDouble() * pi + pi;
    
    return ConfettiPiece(
      position: Vector2(size.x / 2, size.y * 0.2), // Start at top 20%
      velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
      color: _colors[_random.nextInt(_colors.length)],
      rotation: _random.nextDouble() * pi * 2,
      rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      width: _random.nextDouble() * 10 + 5,
      height: _random.nextDouble() * 15 + 8,
      flutterSpeed: _random.nextDouble() * 5 + 2,
      flutterOffset: _random.nextDouble() * pi * 2,
      paint: Paint()..color = _colors[_random.nextInt(_colors.length)],
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    bool allDead = true;
    for (var piece in _pieces) {
      if (piece.position.y > size.y + 50) continue; // Off screen
      allDead = false;

      // Gravity
      piece.velocity.y += 800 * dt; // Gravity pull

      // Air resistance
      piece.velocity.x *= 0.98;

      // Update position
      piece.position += piece.velocity * dt;

      // Update rotations for the 3D flutter effect
      piece.rotation += piece.rotationSpeed * dt;
      piece.flutterOffset += piece.flutterSpeed * dt;
    }

    if (allDead) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    for (var piece in _pieces) {
      if (piece.position.y > size.y + 50) continue;

      canvas.save();
      canvas.translate(piece.position.x, piece.position.y);
      canvas.rotate(piece.rotation);

      // Simulate 3D tumbling by scaling the width with a sine wave
      double scaleX = cos(piece.flutterOffset).abs();
      canvas.scale(scaleX, 1.0);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.width,
          height: piece.height,
        ),
        piece.paint,
      );

      canvas.restore();
    }
  }
}

class ConfettiPiece {
  Vector2 position;
  Vector2 velocity;
  Color color;
  double rotation;
  double rotationSpeed;
  double width;
  double height;
  double flutterSpeed;
  double flutterOffset;
  Paint paint;

  ConfettiPiece({
    required this.position,
    required this.velocity,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.width,
    required this.height,
    required this.flutterSpeed,
    required this.flutterOffset,
    required this.paint,
  });
}
