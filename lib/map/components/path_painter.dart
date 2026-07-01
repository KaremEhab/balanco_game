import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  final List<Offset> nodes;
  final Color pathColor;

  PathPainter({
    required this.nodes,
    required this.pathColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final Paint pathPaint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Path path = Path();
    path.moveTo(nodes.first.dx, nodes.first.dy);

    for (int i = 0; i < nodes.length - 1; i++) {
      Offset p1 = nodes[i];
      Offset p2 = nodes[i + 1];

      // Draw a wavy bezier curve between nodes
      // To mimic the reference video, the path is relatively straight vertically but curves between X offsets
      double controlPointYOffset = (p2.dy - p1.dy) * 0.5;
      
      Offset cp1 = Offset(p1.dx, p1.dy + controlPointYOffset);
      Offset cp2 = Offset(p2.dx, p2.dy - controlPointYOffset);

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    // Draw border first for outline/shadow
    canvas.drawPath(path, borderPaint);
    // Draw inner path
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.pathColor != pathColor;
  }
}
