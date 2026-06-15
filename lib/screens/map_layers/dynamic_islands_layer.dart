import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../map/components/island_painter.dart';
import '../../map/components/level_button_painter.dart';
import '../../map/components/stone_painter.dart';
import '../../map/map_layout_config.dart';

class DynamicIslandsLayerPainter extends CustomPainter {
  final int totalLevels;
  final int highestLevel;
  final Map<int, int> levelStars;
  final int? pressedLevel;
  final double pressedScale;
  final double islandBounceProgress;
  final List<Offset> islandNodes;
  final List<StoneData> stones;
  final List<IslandData> islands;
  final Offset? ballGroundPosition;

  DynamicIslandsLayerPainter({
    required this.totalLevels,
    required this.highestLevel,
    required this.levelStars,
    required this.islandNodes,
    required this.stones,
    required this.islands,
    this.pressedLevel,
    this.pressedScale = 1.0,
    this.islandBounceProgress = 0.0,
    this.ballGroundPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / 400.0;
    
    // Viewport bounds removed, draw everything so it caches properly!
    double startY = -1000;
    double endY = size.height + 1000;

    List<Offset> nodeCenters = islandNodes
        .map((p) => Offset(p.dx * scaleX, p.dy))
        .toList();

    // 1. Draw Stepping Stones Pathway
    List<CustomPainter> stonePainters = [
      FirstStonePainter(),
      SecondStonePainter(),
      ThirdStonePainter(),
      FourthStonePainter(),
      FifthStonePainter(),
      SixthStonePainter(),
    ];

    double highestUnlockedY = double.infinity;
    if (highestLevel > 0 && highestLevel <= nodeCenters.length) {
      highestUnlockedY = nodeCenters[highestLevel - 1].dy;
    } else if (highestLevel > nodeCenters.length) {
      highestUnlockedY = -double.infinity;
    }

    for (int i = 0; i < stones.length; i++) {
      var stone = stones[i];
      // Viewport Culling!
      if (stone.y < startY || stone.y > endY) continue;

      double stoneSize = 60.0;
      CustomPainter painter = stonePainters[stone.type - 1];

      // Gentle bob for stepping stones
      double bobOffset = sin((islandBounceProgress * pi * 2) + (i * 0.7)) * 4.0;

      // Squish physics if ball is overhead
      double squishY = 0.0;
      double squishScale = 1.0;

      if (ballGroundPosition != null) {
        double dist = (Offset(stone.x * scaleX, stone.y) - ballGroundPosition!).distance;
        if (dist < 60.0 * scaleX) {
          // Calculate elastic depression factor
          double factor = 1.0 - (dist / (60.0 * scaleX));
          double easeFactor = Curves.easeInOut.transform(factor);
          squishY = easeFactor * 15.0; // Physically pushes down into the sand
          squishScale = 1.0 - (easeFactor * 0.2); // Squashes down by 20%
        }
      }

      canvas.save();
      canvas.translate(stone.x * scaleX, stone.y + bobOffset + squishY);
      canvas.rotate(stone.rotation);
      canvas.scale(stone.scale * scaleX * squishScale, stone.scale * scaleX * squishScale);
      canvas.translate(-stoneSize / 2, -stoneSize / 2);

      bool isStoneLocked = false;
      // Find the island this stone leads to. Islands are sorted from bottom to top (L1..L9)
      // The island it leads to is the first island with Y < stone.y
      for (var island in islands) {
        if (island.y < stone.y) {
          if (island.level > highestLevel) {
            isStoneLocked = true;
          }
          break;
        }
      }

      if (isStoneLocked) {
        canvas.saveLayer(
          null,
          Paint()
            ..colorFilter = const ColorFilter.matrix([
              0.33, 0.33, 0.33, 0, 0,
              0.33, 0.33, 0.33, 0, 0,
              0.33, 0.33, 0.33, 0, 0,
              0, 0, 0, 1, 0,
            ]),
        );
      }

      painter.paint(canvas, Size(stoneSize, stoneSize));

      if (isStoneLocked) {
        canvas.restore();
      }

      canvas.restore();
    }

    // 2. Procedural Asymmetrical 2.5D Island Generation
    for (int i = 0; i < totalLevels; i++) {
      if (i >= nodeCenters.length) break;
      
      // Viewport Culling!
      if (nodeCenters[i].dy < startY || nodeCenters[i].dy > endY) continue;
      
      int level = i + 1;
      bool isLocked = level > highestLevel;
      
      // Random independent bounce for each island
      double islandBob = sin((islandBounceProgress * pi * 2) + (level * 1.3)) * 8.0;
      Offset center = Offset(nodeCenters[i].dx, nodeCenters[i].dy + islandBob);

      _drawIsland(canvas, center, scaleX, level, isLocked);
    }

    // 3. Draw Badges on top of everything
    for (int i = 0; i < totalLevels; i++) {
      if (i >= nodeCenters.length) break;
      
      // Viewport Culling!
      if (nodeCenters[i].dy < startY || nodeCenters[i].dy > endY) continue;

      int level = i + 1;
      bool isLocked = level > highestLevel;
      
      // Must match exactly the island bounce!
      double islandBob = sin((islandBounceProgress * pi * 2) + (level * 1.3)) * 8.0;
      Offset center = Offset(nodeCenters[i].dx, nodeCenters[i].dy + islandBob);

      double buttonDx = 0;
      double buttonDy = 0;
      if (level - 1 >= 0 && level - 1 < islands.length) {
        buttonDx = islands[level - 1].buttonDx;
        buttonDy = islands[level - 1].buttonDy;
      }

      _drawBadges(
        canvas,
        center,
        scaleX,
        level,
        isLocked,
        levelStars[level] ?? 0,
        buttonDx,
        buttonDy,
      );
    }
  }

  void _drawIsland(
    Canvas canvas,
    Offset center,
    double scaleX,
    int level,
    bool isLocked,
  ) {
    canvas.save();
    double islandDrawSize = 120.0;
    double extraScale = 1.2;
    double drawScale = scaleX * extraScale;
    double rotation = islands[level - 1].rotation;
    
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.scale(drawScale, drawScale);
    canvas.translate(-islandDrawSize / 2, -islandDrawSize / 2);

    if (isLocked) {
      canvas.saveLayer(
        null,
        Paint()
          ..colorFilter = const ColorFilter.matrix([
            0.33, 0.33, 0.33, 0, 0,
            0.33, 0.33, 0.33, 0, 0,
            0.33, 0.33, 0.33, 0, 0,
            0, 0, 0, 1, 0,
          ]),
      );
    }

    int type = islands[level - 1].type;
    switch (type) {
      case 1: FirstIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 2: SecondIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 3: ThirdIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 4: ForthIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 5: FifthIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 6: SixthIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 7: SeventhIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 8: EighthIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 9: NinthIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
      case 10: TenthIslandPainter().paint(canvas, Size(islandDrawSize, islandDrawSize)); break;
    }

    if (isLocked) {
      canvas.restore();
    }
    canvas.restore();
  }

  void _drawBadges(
    Canvas canvas,
    Offset center,
    double scaleX,
    int level,
    bool isLocked,
    int starsCount,
    double buttonDx,
    double buttonDy,
  ) {
    double badgeY = center.dy - 10.0 + (buttonDy * scaleX);
    double badgeX = center.dx + (buttonDx * scaleX);

    bool isPressed = level == pressedLevel;
    double bounceScale = isPressed ? pressedScale : 1.0;
    double buttonDrawSize = 56.0;
    double drawScale = scaleX * bounceScale;

    canvas.save();
    canvas.translate(
      badgeX - (buttonDrawSize / 2) * drawScale,
      badgeY - (buttonDrawSize / 2) * drawScale,
    );
    canvas.scale(drawScale, drawScale);

    if (isLocked) {
      canvas.saveLayer(
        Rect.fromLTWH(-50, -50, buttonDrawSize + 100, buttonDrawSize + 100),
        Paint()
          ..colorFilter = const ColorFilter.matrix([
            0.33, 0.33, 0.33, 0, 0,
            0.33, 0.33, 0.33, 0, 0,
            0.33, 0.33, 0.33, 0, 0,
            0, 0, 0, 1, 0,
          ]),
      );
    }

    LevelButtonPainter().paint(canvas, Size(buttonDrawSize, buttonDrawSize));

    // Draw the text INSIDE the button's scaled coordinates so the text and its shadow 
    // perfectly move and scale together.
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$level',
        style: GoogleFonts.luckiestGuy(
          textStyle: TextStyle(
            color: isLocked ? const Color.fromARGB(255, 125, 125, 125) : const Color(0xFFD32F2F),
            fontSize: 22.0, // Unscaled, relies on canvas.scale
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(color: Colors.white, offset: const Offset(0, 0), blurRadius: 2),
              Shadow(color: Colors.black.withValues(alpha: 0.8), offset: const Offset(0, 3), blurRadius: 4),
            ],
          ),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        (buttonDrawSize / 2) - (textPainter.width / 2),
        (buttonDrawSize / 2) - (textPainter.height / 2) - 2.0, // -2 for visual centering on the button
      ),
    );

    if (isLocked) {
      canvas.restore();
    }
    canvas.restore();

    if (!isLocked) {
      _drawStars(canvas, badgeX, badgeY, scaleX, starsCount);
    }
  }

  void _drawStars(
    Canvas canvas,
    double cx,
    double badgeY,
    double scaleX,
    int starsCount,
  ) {
    double r1 = 11.0 * scaleX;
    double r2 = 5.5 * scaleX;
    double archRadius = 45.0 * scaleX;
    List<double> angles = [-pi * 0.70, -pi * 0.5, -pi * 0.30];

    for (int i = 0; i < 3; i++) {
      bool isEarned = i < starsCount;
      Paint starPaint = Paint()
        ..color = isEarned ? const Color(0xFFFFD700) : const Color(0x66000000);

      Path starPath = Path();
      double px = cx + cos(angles[i]) * archRadius;
      double py = badgeY + sin(angles[i]) * archRadius;

      for (int j = 0; j < 10; j++) {
        double r = j % 2 == 0 ? r1 : r2;
        double a = j * (pi / 5) - (pi / 2);
        if (j == 0) {
          starPath.moveTo(px + cos(a) * r, py + sin(a) * r);
        } else {
          starPath.lineTo(px + cos(a) * r, py + sin(a) * r);
        }
      }
      starPath.close();

      Paint strokePaint = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * scaleX;

      canvas.drawPath(starPath, starPaint);
      if (isEarned) canvas.drawPath(starPath, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant DynamicIslandsLayerPainter oldDelegate) {
    return oldDelegate.islandBounceProgress != islandBounceProgress ||
           oldDelegate.highestLevel != highestLevel ||
           oldDelegate.pressedLevel != pressedLevel ||
           oldDelegate.pressedScale != pressedScale ||
           oldDelegate.ballGroundPosition != ballGroundPosition;
  }
}
