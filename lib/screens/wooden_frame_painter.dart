import 'package:flutter/material.dart';

class WoodenFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double logThickness = 32.0; // Thick cartoon logs
    final double logExtension = 16.0; // Sticking out past corners

    final Paint borderPaint = Paint()
      ..color = const Color(0xFF3E1F06) // Dark outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final Paint logPaint = Paint()
      ..color = const Color(0xFFD34919) // Base bright orange-brown wood matching the image
      ..style = PaintingStyle.fill;

    final Paint highlightPaint = Paint()
      ..color = const Color(0xFFF07B4A) // Light highlight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
      
    final Paint shadowPaint = Paint()
      ..color = const Color(0xFF8B2B0A) // Shadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final Paint woodLinePaint = Paint()
      ..color = const Color(0xFFA13512)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    void drawLog(Rect rect, bool isHorizontal) {
      // Draw base
      final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10.0));
      canvas.drawRRect(rrect, logPaint);
      
      // Draw simple wood grain lines
      if (isHorizontal) {
        canvas.drawLine(
          Offset(rect.left + 15, rect.top + 8),
          Offset(rect.right - 15, rect.top + 8),
          highlightPaint,
        );
        canvas.drawLine(
          Offset(rect.left + 20, rect.top + 16),
          Offset(rect.right - 25, rect.top + 16),
          woodLinePaint,
        );
        canvas.drawLine(
          Offset(rect.left + 10, rect.bottom - 8),
          Offset(rect.right - 10, rect.bottom - 8),
          shadowPaint,
        );
      } else {
        canvas.drawLine(
          Offset(rect.left + 8, rect.top + 15),
          Offset(rect.left + 8, rect.bottom - 15),
          highlightPaint,
        );
        canvas.drawLine(
          Offset(rect.left + 16, rect.top + 20),
          Offset(rect.left + 16, rect.bottom - 25),
          woodLinePaint,
        );
        canvas.drawLine(
          Offset(rect.right - 8, rect.top + 10),
          Offset(rect.right - 8, rect.bottom - 10),
          shadowPaint,
        );
      }
      
      // Draw border last
      canvas.drawRRect(rrect, borderPaint);
    }

    // Right log (underneath top/bottom)
    drawLog(Rect.fromLTWH(size.width - logThickness / 2, -logExtension, logThickness, size.height + logExtension * 2), false);
    // Left log (underneath top/bottom)
    drawLog(Rect.fromLTWH(-logThickness / 2, -logExtension, logThickness, size.height + logExtension * 2), false);

    // Top log (overlaps left/right)
    drawLog(Rect.fromLTWH(-logExtension, -logThickness / 2, size.width + logExtension * 2, logThickness), true);
    // Bottom log (overlaps left/right)
    drawLog(Rect.fromLTWH(-logExtension, size.height - logThickness / 2, size.width + logExtension * 2, logThickness), true);

    // Draw ropes at corners
    final Paint ropePaint = Paint()
      ..color = const Color(0xFFF39C12) // Bright tan/orange rope
      ..style = PaintingStyle.fill;
    final Paint ropeHighlight = Paint()
      ..color = const Color(0xFFFAD7A1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final Paint ropeBorder = Paint()
      ..color = const Color(0xFF4A2A04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    void drawRope(Offset center) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(0.785398); // 45 degrees
      
      // Draw 3 overlapping oval segments for the rope knots
      for (int i = -1; i <= 1; i++) {
        final Rect ropeRect = Rect.fromCenter(center: Offset(i * 8.0, 0), width: 14, height: 45);
        final RRect rRope = RRect.fromRectAndRadius(ropeRect, const Radius.circular(7));
        
        canvas.drawRRect(rRope, ropePaint);
        // Rope highlight
        canvas.drawLine(
          Offset(i * 8.0 - 2, -15),
          Offset(i * 8.0 - 2, 15),
          ropeHighlight,
        );
        canvas.drawRRect(rRope, ropeBorder);
      }
      
      canvas.restore();
    }

    // Top-Left
    drawRope(const Offset(0, 0));
    // Top-Right
    drawRope(Offset(size.width, 0));
    // Bottom-Left
    drawRope(Offset(0, size.height));
    // Bottom-Right
    drawRope(Offset(size.width, size.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
