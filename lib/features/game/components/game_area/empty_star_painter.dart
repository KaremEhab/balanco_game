import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class EmptyStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Apply 50% opacity to the entire composite graphic
    canvas.saveLayer(
      Offset.zero & size,
      Paint()..color = const Color.fromRGBO(255, 255, 255, 0.5),
    );

    // Scale the entire empty star to be smaller than the filled one
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(0.85);
    canvas.translate(-size.width / 2, -size.height / 2);

    // Center the whole icon regardless of size
    canvas.translate(size.width * 0.0488, size.height * 0.0488);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = GameColors.starFilledPainterColor1.withValues(
      alpha: 1.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.02005882,
          size.height * 0.02005882,
          size.width * 0.8823529,
          size.height * 0.8823529,
        ),
        bottomRight: Radius.circular(size.width * 0.3744118),
        bottomLeft: Radius.circular(size.width * 0.3744118),
        topLeft: Radius.circular(size.width * 0.3744118),
        topRight: Radius.circular(size.width * 0.3744118),
      ),
      paint0Fill,
    );

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02005882;
    paint1Stroke.color = GameColors.whiteSolid.withValues(alpha: 1.0);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.01002941,
          size.height * 0.01002941,
          size.width * 0.9024118,
          size.height * 0.9024118,
        ),
        bottomRight: Radius.circular(size.width * 0.3844412),
        bottomLeft: Radius.circular(size.width * 0.3844412),
        topLeft: Radius.circular(size.width * 0.3844412),
        topRight: Radius.circular(size.width * 0.3844412),
      ),
      paint1Stroke,
    );

    canvas.restore(); // restore scale and translate
    canvas.restore(); // restore layer
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
