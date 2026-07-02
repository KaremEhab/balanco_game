import 'package:flutter/material.dart';

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
  @override
  void paint(Canvas canvas, Size size) {
    // A classic folded ribbon shape
    final ribbonPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF6EDC4F), Color(0xFF389E23)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final darkRibbonPaint = Paint()
      ..color = const Color(0xFF1E6310); // Dark green for folds

    double h = size.height;
    double w = size.width;
    
    // Main center block
    double centerStartX = 40;
    double centerEndX = w - 40;
    
    // 1. Draw back tails
    Path leftTail = Path()
      ..moveTo(0, h * 0.4)
      ..lineTo(30, h * 0.3)
      ..lineTo(50, h * 0.8)
      ..lineTo(0, h)
      ..lineTo(15, h * 0.7)
      ..close();
      
    Path rightTail = Path()
      ..moveTo(w, h * 0.4)
      ..lineTo(w - 30, h * 0.3)
      ..lineTo(w - 50, h * 0.8)
      ..lineTo(w, h)
      ..lineTo(w - 15, h * 0.7)
      ..close();

    canvas.drawPath(leftTail, darkRibbonPaint);
    canvas.drawPath(rightTail, darkRibbonPaint);

    // 2. Draw front folded ribbon
    Path frontRibbon = Path()
      ..moveTo(centerStartX, h * 0.2) // Top left
      ..quadraticBezierTo(w / 2, 0, centerEndX, h * 0.2) // Top curve
      ..lineTo(centerEndX, h * 0.8) // Right edge
      ..quadraticBezierTo(w / 2, h * 0.6, centerStartX, h * 0.8) // Bottom curve
      ..close();

    // Shadow under the front ribbon
    canvas.drawPath(
      frontRibbon.shift(const Offset(0, 5)), 
      Paint()..color = const Color(0x66000000)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawPath(frontRibbon, ribbonPaint);
    
    // Inner bright highlight curve
    Path highlight = Path()
      ..moveTo(centerStartX + 5, h * 0.25)
      ..quadraticBezierTo(w / 2, h * 0.05, centerEndX - 5, h * 0.25);
    
    canvas.drawPath(highlight, Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
