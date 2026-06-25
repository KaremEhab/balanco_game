import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_area.dart';

class BarComponent extends Component with HasGameReference<BalancoGame> {
  @override
  void render(Canvas canvas) {
    if (game.isBoardHidden) return;
    Vector2 leftPoint = Vector2(game.barPadding, game.leftY);
    Vector2 rightPoint = Vector2(game.size.x - game.barPadding, game.rightY);

    double barLength = (rightPoint - leftPoint).length;
    double angle = atan2(
      rightPoint.y - leftPoint.y,
      rightPoint.x - leftPoint.x,
    );

    canvas.save();
    canvas.translate(leftPoint.x, leftPoint.y);
    canvas.rotate(angle);

    // --- 3D GLOSSY SURFBOARD BAR (Beach Theme) ---
    double barHeight = 24.0; // Increased height slightly
    Rect surfboardRect = Rect.fromLTRB(
      0,
      -barHeight / 2,
      barLength,
      barHeight / 2,
    );

    // Surfboard outline path (symmetrically tapered twin-tip wakeboard/surfboard shape)
    Path surfboardPath = Path();
    surfboardPath.moveTo(12, -barHeight / 2);
    surfboardPath.lineTo(barLength - 12, -barHeight / 2);
    // Right tip (smoothly curved)
    surfboardPath.quadraticBezierTo(barLength + 4, 0, barLength - 12, barHeight / 2);
    surfboardPath.lineTo(12, barHeight / 2);
    // Left tip (smoothly curved)
    surfboardPath.quadraticBezierTo(-4, 0, 12, -barHeight / 2);
    surfboardPath.close();

    // 1. Drop shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
    
    canvas.save();
    canvas.rotate(-angle); // Undo rotation to cast shadow straight down
    canvas.translate(0, 10);
    canvas.rotate(angle);
    canvas.drawPath(surfboardPath, shadowPaint);
    canvas.restore();

    // 2. Surfboard Base Color (Vibrant Glossy Cyan/Teal)
    final Paint boardPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF80DEEA), // Top highlight
          Color(0xFF00BCD4), // Main color
          Color(0xFF0097A7), // Mid shadow
          Color(0xFF006064), // Deep bottom shadow
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ).createShader(surfboardRect);
      
    canvas.drawPath(surfboardPath, boardPaint);

    // 3. Surfboard Center Racing Stripe (White to Orange gradient)
    Path stripePath = Path();
    stripePath.moveTo(10, -barHeight / 4);
    stripePath.lineTo(barLength - 10, -barHeight / 4);
    stripePath.quadraticBezierTo(barLength + 1, 0, barLength - 10, barHeight / 4);
    stripePath.lineTo(10, barHeight / 4);
    stripePath.quadraticBezierTo(-1, 0, 10, -barHeight / 4);
    stripePath.close();

    final Paint stripePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF), // Bright top
          Color(0xFFFFF3E0), // Warm transition
          Color(0xFFFFB74D), // Orange
          Color(0xFFF57C00)  // Deep Orange shadow
        ],
        stops: [0.0, 0.4, 0.7, 1.0],
      ).createShader(surfboardRect);
    canvas.drawPath(stripePath, stripePaint);

    // 4. Glossy Specular Highlight (The Glass/Epoxy finish reflection)
    Path highlightPath = Path();
    highlightPath.moveTo(12, -barHeight / 2 + 0.5);
    highlightPath.lineTo(barLength - 12, -barHeight / 2 + 0.5);
    highlightPath.quadraticBezierTo(barLength - 2, -barHeight / 4, barLength - 12, -1);
    highlightPath.lineTo(12, -1);
    highlightPath.quadraticBezierTo(2, -barHeight / 4, 12, -barHeight / 2 + 0.5);
    highlightPath.close();

    final Paint specPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xAAFFFFFF), // Strong white reflection at top
          Color(0x00FFFFFF)  // Fading out
        ],
      ).createShader(surfboardRect);
    canvas.drawPath(highlightPath, specPaint);

    // 5. Central Groove for the ball to roll in securely
    Rect grooveRect = Rect.fromLTRB(20, -3.0, barLength - 20, 3.0);
    final Paint groovePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB71C1C), // Deep red inset shadow
          Color(0xFFD32F2F), // Mid red
          Color(0xFFFF5252), // Bright bottom catching light
        ],
      ).createShader(grooveRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(grooveRect, const Radius.circular(3)),
      groovePaint,
    );
    
    // Outer highlight rim for the groove for extra 3D depth
    final Paint grooveRimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(grooveRect, const Radius.circular(3)),
      grooveRimPaint,
    );

    canvas.restore();
  }
}
