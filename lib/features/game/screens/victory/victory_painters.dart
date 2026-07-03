import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VictoryCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Thick dark outer stroke / shadow
    final outerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(32),
    );
    canvas.drawRRect(
      outerRRect,
      Paint()
        ..color = const Color(0xFF7A4A28) // Dark wood
        ..style = PaintingStyle.fill,
    );

    // 2. Thick golden rim
    final goldRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 4, size.width - 8, size.height - 8),
      const Radius.circular(28),
    );
    final goldGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF9C650), Color(0xFFD68F2C)],
    ).createShader(Rect.fromLTWH(4, 4, size.width - 8, size.height - 8));
    canvas.drawRRect(goldRRect, Paint()..shader = goldGradient);

    // 3. Inner shadow line (darker gold)
    final innerGoldRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(12, 12, size.width - 24, size.height - 24),
      const Radius.circular(22),
    );
    canvas.drawRRect(
      innerGoldRRect,
      Paint()
        ..color = const Color(0xFFB5701B)
        ..style = PaintingStyle.fill,
    );

    // 4. Main Beige Card Background
    final beigeRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(14, 14, size.width - 28, size.height - 28),
      const Radius.circular(20),
    );
    final beigeGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFF1D0), Color(0xFFEADBBA)],
    ).createShader(Rect.fromLTWH(14, 14, size.width - 28, size.height - 28));
    canvas.drawRRect(beigeRRect, Paint()..shader = beigeGradient);
    
    // 5. Very subtle inner glow/highlight on the beige card
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(16, 16, size.width - 32, size.height - 32),
        const Radius.circular(18),
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class VictoryRibbonPainter extends CustomPainter {
  final String text;

  VictoryRibbonPainter({this.text = 'LEVEL CLEARED'});

  @override
  void paint(Canvas canvas, Size size) {
    double h = size.height;
    double w = size.width;
    
    // Main center block
    double centerStartX = 65;
    double centerEndX = w - 65;
    
    // 1. Draw back tails getting closer to the center
    Path leftTail = Path()
      ..moveTo(15, h * 0.45)
      ..lineTo(centerStartX + 10, h * 0.35)
      ..lineTo(centerStartX + 10, h * 0.85)
      ..lineTo(15, h * 0.95)
      ..lineTo(30, h * 0.7)
      ..close();
      
    Path rightTail = Path()
      ..moveTo(w - 15, h * 0.45)
      ..lineTo(centerEndX - 10, h * 0.35)
      ..lineTo(centerEndX - 10, h * 0.85)
      ..lineTo(w - 15, h * 0.95)
      ..lineTo(w - 30, h * 0.7)
      ..close();

    // 2. Draw front folded ribbon
    Path frontRibbon = Path()
      ..moveTo(centerStartX, h * 0.2) // Top left
      ..quadraticBezierTo(w / 2, 0, centerEndX, h * 0.2) // Top curve
      ..lineTo(centerEndX, h * 0.8) // Right edge
      ..quadraticBezierTo(w / 2, h * 0.6, centerStartX, h * 0.8) // Bottom curve
      ..close();

    final shadowPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeJoin = StrokeJoin.round;

    final tailFillPaint = Paint()
      ..color = const Color(0xFF388E3C) // Darker green for tails
      ..style = PaintingStyle.fill;
      
    final frontFillPaint = Paint()
      ..color = const Color(0xFF4CAF50) // Brighter green for front
      ..style = PaintingStyle.fill;

    // Draw Shadows (shifted down)
    canvas.drawPath(leftTail.shift(const Offset(0, 6)), shadowPaint);
    canvas.drawPath(rightTail.shift(const Offset(0, 6)), shadowPaint);
    canvas.drawPath(frontRibbon.shift(const Offset(0, 6)), shadowPaint);

    // Draw Tails Fill and Border
    canvas.drawPath(leftTail, tailFillPaint);
    canvas.drawPath(rightTail, tailFillPaint);
    canvas.drawPath(leftTail, borderPaint);
    canvas.drawPath(rightTail, borderPaint);

    // Draw Front Fill and Border
    canvas.drawPath(frontRibbon, frontFillPaint);
    canvas.drawPath(frontRibbon, borderPaint);

    // Draw curved text
    _drawCurvedText(canvas, size, centerStartX, centerEndX, h);
  }

  void _drawCurvedText(Canvas canvas, Size size, double startX, double endX, double h) {
    if (text.isEmpty) return;

    final textStyle = GoogleFonts.luckiestGuy(
      color: Colors.white,
      fontSize: 27,
    );
    final shadowStyle = GoogleFonts.luckiestGuy(
      color: const Color(0xFF1E6310),
      fontSize: 27,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    // Calculate total width of the text
    double totalTextWidth = 0;
    List<double> charWidths = [];
    for (int i = 0; i < text.length; i++) {
      textPainter.text = TextSpan(text: text[i], style: textStyle);
      textPainter.layout();
      totalTextWidth += textPainter.width;
      charWidths.add(textPainter.width);
    }
    
    // The curve for the text should run roughly parallel to the ribbon's top edge
    // Ribbon is drawn from h*0.2 to h*0.8, so h*0.5 is exactly the middle.
    // Let's adjust P1 to make the curve match the visual center.
    final p0 = Offset(startX, h * 0.5);
    final p1 = Offset(size.width / 2, h * 0.3);
    final p2 = Offset(endX, h * 0.5);

    Offset getPoint(double t) {
      return Offset(
        pow(1 - t, 2).toDouble() * p0.dx + 2 * (1 - t) * t * p1.dx + pow(t, 2).toDouble() * p2.dx,
        pow(1 - t, 2).toDouble() * p0.dy + 2 * (1 - t) * t * p1.dy + pow(t, 2).toDouble() * p2.dy,
      );
    }
    
    Offset getDerivative(double t) {
      return Offset(
        2 * (1 - t) * (p1.dx - p0.dx) + 2 * t * (p2.dx - p1.dx),
        2 * (1 - t) * (p1.dy - p0.dy) + 2 * t * (p2.dy - p1.dy),
      );
    }

    // Since the path length is roughly the chord length for shallow curves, we can approximate:
    double curveWidth = endX - startX;
    
    // Add some letter spacing
    double letterSpacing = 3.0;
    totalTextWidth += (text.length - 1) * letterSpacing;

    double currentX = (curveWidth - totalTextWidth) / 2;
    
    for (int i = 0; i < text.length; i++) {
      double charW = charWidths[i];
      double charMidX = currentX + charW / 2;
      double t = charMidX / curveWidth;
      
      Offset pt = getPoint(t);
      Offset dPt = getDerivative(t);
      double angle = atan2(dPt.dy, dPt.dx);
      
      canvas.save();
      // Translate to the point on the curve. Add a little Y offset to center it properly.
      canvas.translate(pt.dx, pt.dy + 2);
      canvas.rotate(angle);
      
      // Draw shadow
      textPainter.text = TextSpan(text: text[i], style: shadowStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(-charW / 2, -textPainter.height / 2 + 3));
      
      // Draw text
      textPainter.text = TextSpan(text: text[i], style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(-charW / 2, -textPainter.height / 2));
      
      canvas.restore();
      
      currentX += charW + letterSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GamifiedButtonPainter extends CustomPainter {
  final Color innerColor1;
  final Color innerColor2;

  GamifiedButtonPainter({required this.innerColor1, required this.innerColor2});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(radius, radius);

    // 1. Dark outer drop shadow
    canvas.drawCircle(
      center.translate(0, 4), 
      radius, 
      Paint()..color = const Color(0x66000000)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
    );

    // 2. Wood/Bronze thick border
    canvas.drawCircle(
      center, 
      radius, 
      Paint()..color = const Color(0xFF7A4A28)
    );

    canvas.drawCircle(
      center, 
      radius - 2, 
      Paint()..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE8AD4A), Color(0xFFB5701B)]
      ).createShader(Rect.fromCircle(center: center, radius: radius))
    );

    // 3. Inner dark ring
    canvas.drawCircle(
      center, 
      radius - 8, 
      Paint()..color = const Color(0xFF5A3117)
    );

    // 4. Colored button face
    canvas.drawCircle(
      center, 
      radius - 10, 
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [innerColor1, innerColor2]
      ).createShader(Rect.fromCircle(center: center, radius: radius))
    );

    // 5. Button face inner highlight
    canvas.drawCircle(
      center.translate(0, -1), 
      radius - 12, 
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
    );

    // 6. Draw 4 diamond studs on the rim
    final studPaint = Paint()..color = const Color(0xFFFFDB70);
    final studShadowPaint = Paint()..color = const Color(0xFF5A3117);
    
    void drawStud(Offset pos) {
      Path studPath = Path()
        ..moveTo(pos.dx, pos.dy - 3)
        ..lineTo(pos.dx + 3, pos.dy)
        ..lineTo(pos.dx, pos.dy + 3)
        ..lineTo(pos.dx - 3, pos.dy)
        ..close();
      canvas.drawPath(studPath.shift(const Offset(0, 1)), studShadowPaint);
      canvas.drawPath(studPath, studPaint);
    }

    drawStud(Offset(center.dx, 5)); // Top
    drawStud(Offset(center.dx, size.height - 5)); // Bottom
    drawStud(Offset(5, center.dy)); // Left
    drawStud(Offset(size.width - 5, center.dy)); // Right
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
