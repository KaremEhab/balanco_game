import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Layer 1: PyramidSkyPainter  (parallax speed 0.0 – static)
// ─────────────────────────────────────────────────────────────────────────────
class PyramidSkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB57BCC),
            Color(0xFFE8909E),
            Color(0xFFD06090),
            Color(0xFF8B3FA0),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Layer 2: WispyCloudPainter  (parallax speed 0.1)
// ─────────────────────────────────────────────────────────────────────────────
class WispyCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void drawWisp(
      double cx,
      double cy,
      double halfW,
      double halfH,
      double alpha,
    ) {
      final Paint paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      final Path path = Path();
      path.moveTo(cx - halfW, cy);
      path.cubicTo(
        cx - halfW * 0.5,
        cy - halfH,
        cx + halfW * 0.5,
        cy - halfH,
        cx + halfW,
        cy,
      );
      path.cubicTo(
        cx + halfW * 0.5,
        cy + halfH * 0.4,
        cx - halfW * 0.5,
        cy + halfH * 0.4,
        cx - halfW,
        cy,
      );
      canvas.drawPath(path, paint);
    }

    drawWisp(size.width * 0.40, size.height * 0.18, 160, 9, 0.45);
    drawWisp(size.width * 0.70, size.height * 0.12, 110, 6, 0.35);
    drawWisp(size.width * 0.20, size.height * 0.22, 90, 5, 0.30);
    drawWisp(size.width * 0.55, size.height * 0.28, 130, 7, 0.25);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Layer 3: DistantMountainsPainter  (parallax speed 0.2)
// ─────────────────────────────────────────────────────────────────────────────
class DistantMountainsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF9B3B8A)
      ..style = PaintingStyle.fill;

    final Path left = Path();
    left.moveTo(0, size.height);
    left.lineTo(0, size.height * 0.60);
    left.cubicTo(
      size.width * 0.10,
      size.height * 0.35,
      size.width * 0.28,
      size.height * 0.32,
      size.width * 0.42,
      size.height * 0.50,
    );
    left.lineTo(size.width * 0.42, size.height);
    left.close();
    canvas.drawPath(left, paint);

    final Path right = Path();
    right.moveTo(size.width, size.height);
    right.lineTo(size.width, size.height * 0.55);
    right.cubicTo(
      size.width * 0.88,
      size.height * 0.38,
      size.width * 0.70,
      size.height * 0.35,
      size.width * 0.58,
      size.height * 0.55,
    );
    right.lineTo(size.width * 0.58, size.height);
    right.close();
    canvas.drawPath(right, paint);

    final Path centre = Path();
    centre.moveTo(size.width * 0.35, size.height);
    centre.lineTo(size.width * 0.50, size.height * 0.38);
    centre.lineTo(size.width * 0.65, size.height);
    centre.close();
    canvas.drawPath(centre, paint..color = const Color(0xFF7A2878));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Config classes for Layer 4
// ─────────────────────────────────────────────────────────────────────────────

/// Position + size of one pyramid (all values 0.0 – 1.0 fractions of canvas).
class PyramidConfig {
  final double cx; // horizontal centre  (fraction of width)
  final double peakYF; // peak tip Y         (fraction of height)
  final double baseYF; // base line Y        (fraction of height)
  final double halfWF; // half-width at base (fraction of width)

  const PyramidConfig({
    required this.cx,
    required this.peakYF,
    required this.baseYF,
    required this.halfWF,
  });
}

/// Face colours for all three pyramids.
class PyramidColorConfig {
  final Color leftShadow; // dark outer edge of left face
  final Color leftMid; // mid-tone of left face
  final Color leftLight; // lit inner edge of left face (centre ridge)
  final Color rightLight; // lit inner edge of right face (centre ridge)
  final Color rightMid; // mid-tone of right face
  final Color rightShadow; // dark outer edge of right face
  final Color ridgeLine; // centre ridge line colour
  final Color brickLeft; // brick lines on left face
  final Color brickRight; // brick lines on right face

  const PyramidColorConfig({
    this.leftShadow = const Color(0xFF2A0E60),
    this.leftMid = const Color(0xFF5B3AA8),
    this.leftLight = const Color(0xFF9B7FDC),
    this.rightLight = const Color(0xFFD0C0F8),
    this.rightMid = const Color(0xFFAA90E8),
    this.rightShadow = const Color(0xFF7B5CC0),
    this.ridgeLine = const Color(0xFF1A0840),
    this.brickLeft = const Color(0xFFBBA8E8),
    this.brickRight = const Color(0xFF8060B8),
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Layer 4: MainPyramidsPainter  (parallax speed 0.4)
// ─────────────────────────────────────────────────────────────────────────────
class MainPyramidsPainter extends CustomPainter {
  final PyramidConfig left;
  final PyramidConfig centre;
  final PyramidConfig right;
  final PyramidColorConfig colors;

  const MainPyramidsPainter({
    this.left = const PyramidConfig(
      cx: 0.4033,
      peakYF: 0.3673,
      baseYF: 0.7135,
      halfWF: 0.1624,
    ),
    this.centre = const PyramidConfig(
      cx: 0.5000,
      peakYF: 0.2600,
      baseYF: 0.7069,
      halfWF: 0.1742,
    ),
    this.right = const PyramidConfig(
      cx: 0.5865,
      peakYF: 0.3344,
      baseYF: 0.7901,
      halfWF: 0.1981,
    ),
    this.colors = const PyramidColorConfig(
      leftShadow: Color(0xFF2A0E60),
      leftMid: Color(0xFF5B3AA8),
      leftLight: Color(0xFF9B7FDC),
      rightLight: Color(0xFFD0C0F8),
      rightMid: Color(0xFFAA90E8),
      rightShadow: Color(0xFF7B5CC0),
      ridgeLine: Color(0xFF1A0840),
    ),
  });

  @override
  void paint(Canvas canvas, Size size) {
    void drawDetailedPyramid(PyramidConfig cfg) {
      final double cx = size.width * cfg.cx;
      final double peakY = size.height * cfg.peakYF;
      final double baseY = size.height * cfg.baseYF;
      final double halfW = size.width * cfg.halfWF;
      final double leftX = cx - halfW;
      final double rightX = cx + halfW;

      // Left face
      final Rect leftRect = Rect.fromLTRB(leftX, peakY, cx, baseY);
      canvas.save();
      canvas.clipPath(
        Path()
          ..moveTo(leftX, baseY)
          ..lineTo(cx, peakY)
          ..lineTo(cx, baseY)
          ..close(),
      );
      canvas.drawRect(
        leftRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [colors.leftShadow, colors.leftMid, colors.leftLight],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(leftRect),
      );
      canvas.restore();

      // Right face
      final Rect rightRect = Rect.fromLTRB(cx, peakY, rightX, baseY);
      canvas.save();
      canvas.clipPath(
        Path()
          ..moveTo(rightX, baseY)
          ..lineTo(cx, peakY)
          ..lineTo(cx, baseY)
          ..close(),
      );
      canvas.drawRect(
        rightRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [colors.rightLight, colors.rightMid, colors.rightShadow],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(rightRect),
      );
      canvas.restore();

      // Brick lines
      final double totalH = baseY - peakY;
      const int rows = 18;
      final Paint bPaintL = Paint()
        ..color = colors.brickLeft.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      final Paint bPaintR = Paint()
        ..color = colors.brickRight.withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      final Random rng = Random(42);
      for (int row = 1; row < rows; row++) {
        final double t = row / rows;
        final double y = peakY + totalH * t;
        final double rowW = halfW * t;
        double x = cx - rowW;
        while (x < cx - 2) {
          final double dl = 6 + rng.nextDouble() * 10;
          final double gap = 2 + rng.nextDouble() * 5;
          final double end = min(x + dl, cx - 2);
          canvas.drawLine(Offset(x, y), Offset(end, y), bPaintL);
          x = end + gap;
        }
        x = cx + 2;
        while (x < cx + rowW) {
          final double dl = 6 + rng.nextDouble() * 10;
          final double gap = 2 + rng.nextDouble() * 5;
          final double end = min(x + dl, cx + rowW);
          canvas.drawLine(Offset(x, y), Offset(end, y), bPaintR);
          x = end + gap;
        }
      }

      // Ridge line
      canvas.drawLine(
        Offset(cx, peakY),
        Offset(cx, baseY),
        Paint()
          ..color = colors.ridgeLine
          ..strokeWidth = 1.5,
      );
    }

    // Draw back-to-front so centre is on top
    drawDetailedPyramid(left);
    drawDetailedPyramid(right);
    drawDetailedPyramid(centre);
  }

  @override
  bool shouldRepaint(MainPyramidsPainter old) =>
      old.left != left ||
      old.centre != centre ||
      old.right != right ||
      old.colors != colors;
}

// ─────────────────────────────────────────────────────────────────────────────
// Config class for Layer 5
// ─────────────────────────────────────────────────────────────────────────────

/// Configures the midground (sand + purple side dunes + camels).
/// All `*F` values are fractions of canvas height (0 = top, 1 = bottom).
class MidgroundDunesConfig {
  final Color sandColor; // colour of the sandy centre dune
  final Color duneColor; // colour of the purple side dunes
  final Color camelColor; // camel silhouette colour
  final double sandTopF; // where the left edge of the sand starts (Y frac)
  final double
  sandPeakF; // lowest point of the sand arc (Y frac, higher = lower arc)
  final double duneLeftTopF; // top of the left purple dune (Y frac)
  final double duneRightTopF; // top of the right purple dune (Y frac)
  final bool showCamels;

  const MidgroundDunesConfig({
    this.sandColor = const Color(0xFFD397D0),
    this.duneColor = const Color(0xFF6A2CA0),
    this.camelColor = const Color(0xFF8B5E3C),
    this.sandTopF = 0.6869,
    this.sandPeakF = 0.5138,
    this.duneLeftTopF = 0.5860,
    this.duneRightTopF = 0.5797,
    this.showCamels = true,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Layer 5: MidgroundDunesPainter  (parallax speed 0.7)
// ─────────────────────────────────────────────────────────────────────────────
class MidgroundDunesPainter extends CustomPainter {
  final MidgroundDunesConfig config;

  const MidgroundDunesPainter({this.config = const MidgroundDunesConfig()});

  @override
  void paint(Canvas canvas, Size size) {
    final cfg = config;

    // Sandy centre dune
    final Path sandPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * cfg.sandTopF)
      ..cubicTo(
        size.width * 0.20,
        size.height * (cfg.sandPeakF + 0.04),
        size.width * 0.45,
        size.height * cfg.sandPeakF,
        size.width * 0.55,
        size.height * (cfg.sandPeakF + 0.10),
      )
      ..cubicTo(
        size.width * 0.70,
        size.height * (cfg.sandPeakF + 0.24),
        size.width * 0.85,
        size.height * (cfg.sandPeakF + 0.22),
        size.width,
        size.height * (cfg.sandPeakF + 0.17),
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      sandPath,
      Paint()
        ..color = cfg.sandColor
        ..style = PaintingStyle.fill,
    );

    // Right purple dune
    final Path rightDune = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height * cfg.duneRightTopF)
      ..cubicTo(
        size.width * 0.38,
        size.height * (cfg.duneRightTopF - 0.04),
        size.width * 0.50,
        size.height * (cfg.duneRightTopF + 0.15),
        size.width * 0.18,
        size.height,
      )
      ..close();
    canvas.drawPath(
      rightDune,
      Paint()
        ..color = cfg.duneColor
        ..style = PaintingStyle.fill,
    );

    // Left purple dune
    final Path leftDune = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * cfg.duneLeftTopF)
      ..cubicTo(
        size.width * 0.12,
        size.height * (cfg.duneLeftTopF - 0.10),
        size.width * 0.28,
        size.height * (cfg.duneLeftTopF + 0.02),
        size.width * 0.38,
        size.height,
      )
      ..close();
    canvas.drawPath(
      leftDune,
      Paint()
        ..color = cfg.duneColor
        ..style = PaintingStyle.fill,
    );

    // Camel silhouettes
    if (!cfg.showCamels) return;
    final Paint camelPaint = Paint()
      ..color = cfg.camelColor
      ..style = PaintingStyle.fill;

    void drawCamel(double bx, double by, double sc) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(bx + 8 * sc, by - 10 * sc),
          width: 16 * sc,
          height: 8 * sc,
        ),
        camelPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(bx + 7 * sc, by - 15 * sc),
          width: 7 * sc,
          height: 7 * sc,
        ),
        camelPaint,
      );
      final Path neck = Path()
        ..moveTo(bx + 14 * sc, by - 10 * sc)
        ..quadraticBezierTo(
          bx + 18 * sc,
          by - 14 * sc,
          bx + 17 * sc,
          by - 20 * sc,
        )
        ..quadraticBezierTo(
          bx + 20 * sc,
          by - 21 * sc,
          bx + 18 * sc,
          by - 22 * sc,
        )
        ..lineTo(bx + 16 * sc, by - 20 * sc)
        ..close();
      canvas.drawPath(neck, camelPaint);
      final Paint legPaint = Paint()
        ..color = cfg.camelColor
        ..strokeWidth = 1.5 * sc
        ..style = PaintingStyle.stroke;
      for (final ox in [3.0, 7.0, 11.0, 15.0]) {
        canvas.drawLine(
          Offset(bx + ox * sc, by - 6 * sc),
          Offset(bx + ox * sc, by),
          legPaint,
        );
      }
    }

    drawCamel(size.width * 0.20 - 10, size.height * cfg.sandTopF - 2, 1.3);
    drawCamel(size.width * 0.20 + 28, size.height * cfg.sandTopF - 1, 1.1);
    drawCamel(size.width * 0.20 + 54, size.height * cfg.sandTopF, 0.95);
  }

  @override
  bool shouldRepaint(MidgroundDunesPainter old) => old.config != config;
}

// ─────────────────────────────────────────────────────────────────────────────
// Config class for Layer 6
// ─────────────────────────────────────────────────────────────────────────────

/// Configures the dark foreground dune strip.
/// All `*F` values are fractions of canvas height.
class ForegroundDunesConfig {
  final Color fgColor; // main foreground dune colour
  final Color crestColor; // crest highlight colour
  final double leftHeightF; // Y frac where left edge of dune starts
  final double rightHeightF; // Y frac where right edge of dune ends
  final double crestAlpha; // opacity of the crest highlight (0–1)

  const ForegroundDunesConfig({
    this.fgColor = const Color(0xFF390F5E),
    this.crestColor = const Color(0xFF7947BA),
    this.leftHeightF = 0.6980,
    this.rightHeightF = 0.6892,
    this.crestAlpha = 1.0000,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Layer 6: ForegroundDunesPainter  (parallax speed 1.0)
// ─────────────────────────────────────────────────────────────────────────────
class ForegroundDunesPainter extends CustomPainter {
  final ForegroundDunesConfig config;

  const ForegroundDunesPainter({this.config = const ForegroundDunesConfig()});

  @override
  void paint(Canvas canvas, Size size) {
    final cfg = config;
    final lh = cfg.leftHeightF;
    final rh = cfg.rightHeightF;

    final Path dunePath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * lh)
      ..cubicTo(
        size.width * 0.25,
        size.height * (lh - 0.12),
        size.width * 0.55,
        size.height * (lh + 0.02),
        size.width * 0.75,
        size.height * rh,
      )
      ..cubicTo(
        size.width * 0.88,
        size.height * (rh - 0.09),
        size.width * 0.95,
        size.height * rh,
        size.width,
        size.height * rh,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      dunePath,
      Paint()
        ..color = cfg.fgColor
        ..style = PaintingStyle.fill,
    );

    // Crest highlight
    final Path crest = Path()
      ..moveTo(0, size.height * lh)
      ..cubicTo(
        size.width * 0.25,
        size.height * (lh - 0.12),
        size.width * 0.55,
        size.height * (lh + 0.02),
        size.width * 0.75,
        size.height * rh,
      )
      ..lineTo(size.width * 0.75, size.height * (rh + 0.03))
      ..cubicTo(
        size.width * 0.55,
        size.height * (lh + 0.05),
        size.width * 0.25,
        size.height * (lh - 0.09),
        0,
        size.height * (lh + 0.03),
      )
      ..close();
    canvas.drawPath(
      crest,
      Paint()
        ..color = cfg.crestColor.withValues(alpha: cfg.crestAlpha)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(ForegroundDunesPainter old) => old.config != config;
}
