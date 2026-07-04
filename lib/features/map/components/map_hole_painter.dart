import 'dart:math';
import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class MapHolePainter extends CustomPainter {
  final bool isUnlocked;
  final double teethClosure;

  MapHolePainter({required this.isUnlocked, this.teethClosure = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double trapInnerRadius = radius * 0.60; // Thick outer ring (wider sides)
    Offset center = Offset(radius, radius);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // If locked, we could draw it in greyscale or just draw a lock overlay.
    // The previous MapHolePainter drew a lock overlay for locked levels. Let's keep that.

    // 1. The Deep Hole Background (Stepped Concentric Circles)
    List<Color> holeColors = !isUnlocked
        ? [
            GameColors.mapHolePainterColor2,
            GameColors.blueGray900,
            GameColors.mapHolePainterColor1,
            GameColors.blackSolid,
            GameColors.blackSolid,
          ] // Grey locked
        : [
            GameColors.woodLight,
            GameColors.woodMedium,
            GameColors.woodMediumDark,
            GameColors.woodDark,
            GameColors.woodVeryDark,
            GameColors.woodDeep,
          ]; // Gold unlocked

    double step = trapInnerRadius / holeColors.length;
    for (int i = 0; i < holeColors.length; i++) {
      Paint circlePaint = Paint()..color = holeColors[i];
      canvas.drawCircle(Offset.zero, trapInnerRadius - (i * step), circlePaint);
    }

    // 2. The Spikes (Teeth)
    int numTeeth = 8;
    double toothAngle = (2 * pi) / numTeeth;
    double toothBaseHalfWidth =
        0.15 + (teethClosure * ((toothAngle / 2) - 0.15)); // Radians

    Path teethPath = Path();
    for (int i = 0; i < numTeeth; i++) {
      double angle = i * toothAngle;
      double startAngle = angle - toothBaseHalfWidth;
      double endAngle = angle + toothBaseHalfWidth;

      teethPath.moveTo(
        cos(startAngle) * trapInnerRadius,
        sin(startAngle) * trapInnerRadius,
      );
      // Tip of the tooth pointing inward
      double tipRadius = trapInnerRadius * (0.25 - (teethClosure * 0.30));
      teethPath.lineTo(cos(angle) * tipRadius, sin(angle) * tipRadius);
      teethPath.lineTo(
        cos(endAngle) * trapInnerRadius,
        sin(endAngle) * trapInnerRadius,
      );
    }

    Paint teethPaint = Paint();
    if (!isUnlocked) {
      teethPaint.color = GameColors.beachMapThemeColor3;
    } else {
      teethPaint.color = GameColors.peachPuff;
    }
    canvas.drawPath(teethPath, teethPaint);

    // Dark radial shadow to make teeth fade into the deep hole
    Paint teethShadow = Paint()
      ..shader =
          RadialGradient(
            colors: [GameColors.black87, Colors.transparent],
            stops: const [0.2, 1.0],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: trapInnerRadius),
          );
    canvas.drawCircle(Offset.zero, trapInnerRadius, teethShadow);

    // 3. The Brass/Gold Ring
    Paint ringShadow = Paint()
      ..color = GameColors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(Offset.zero, radius, ringShadow); // Outer drop shadow

    Paint ringPaint = Paint();
    if (!isUnlocked) {
      ringPaint.color = GameColors.blueGray300;
    } else {
      ringPaint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [GameColors.goldenYellow, GameColors.goldenBrown],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    }

    Path ringPath = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: radius))
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: trapInnerRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(ringPath, ringPaint);

    // Bright outer edge
    Paint outerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = !isUnlocked ? GameColors.blueGray100 : GameColors.lightGold;
    canvas.drawCircle(Offset.zero, radius - 1.0, outerEdgePaint);

    // Subtle inner dark edge
    Paint innerEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = GameColors.black38;
    canvas.drawCircle(Offset.zero, trapInnerRadius, innerEdgePaint);

    // 4. The Rivets
    double rivetDistance = (radius + trapInnerRadius) / 2;
    double rivetRadius = (radius - trapInnerRadius) * 0.18;

    Paint rivetBasePaint = Paint()
      ..color = !isUnlocked
          ? GameColors.mapHolePainterColor3
          : GameColors.darkGold;
    Paint rivetHighlightPaint = Paint()..color = GameColors.white54;

    for (int i = 0; i < numTeeth; i++) {
      // Offset the rivets to sit exactly between the teeth
      double angle = (i * toothAngle) + (toothAngle / 2);
      Offset rivetCenter = Offset(
        cos(angle) * rivetDistance,
        sin(angle) * rivetDistance,
      );

      canvas.drawCircle(rivetCenter, rivetRadius, rivetBasePaint);
      // Bright highlight for a 3D spherical bump look
      canvas.drawCircle(
        rivetCenter + Offset(-rivetRadius * 0.3, -rivetRadius * 0.3),
        rivetRadius * 0.4,
        rivetHighlightPaint,
      );
    }

    // 5. If locked, draw a subtle lock icon in the center
    if (!isUnlocked) {
      final IconData lockIcon = Icons.lock_rounded;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(lockIcon.codePoint),
          style: TextStyle(
            fontSize: size.width * 0.45,
            fontFamily: lockIcon.fontFamily,
            package: lockIcon.fontPackage,
            color: GameColors.white.withValues(alpha: 0.5),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapHolePainter oldDelegate) {
    return oldDelegate.isUnlocked != isUnlocked ||
        oldDelegate.teethClosure != teethClosure;
  }
}
