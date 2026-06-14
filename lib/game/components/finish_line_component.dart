import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../game_area.dart';

class FinishLineComponent extends PositionComponent
    with HasGameReference<BalancoGame>, TapCallbacks {
  final Paint basePaint = Paint()..color = Colors.blueGrey.shade800;
  final Paint highlightPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.3);
  final Paint shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.5);
  final Paint whiteCheckPaint = Paint()..color = Colors.white70;
  final Paint blackCheckPaint = Paint()..color = Colors.black87;
  final Paint bracketPaint = Paint()..color = Colors.blueGrey.shade900;
  final Paint rivetPaint = Paint()..color = Colors.blueGrey.shade400;
  double currentHeight = 24.0;
  double targetHeight = 24.0;
  double uiTimer = 0.0;

  late final TextPaint titlePaint;
  late final TextPaint labelPaint;
  Rect nextLevelButtonRect = Rect.zero;
  Rect restartButtonRect = Rect.zero;
  Rect returnToLobbyButtonRect = Rect.zero;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = game.size;
    titlePaint = TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
    labelPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (nextLevelButtonRect.contains(event.localPosition.toOffset())) {
      game.retractCurtainAndStartNextLevel();
    } else if (restartButtonRect.contains(event.localPosition.toOffset())) {
      game.retractCurtainAndRestartLevel();
    } else if (returnToLobbyButtonRect.contains(event.localPosition.toOffset())) {
      game.onLevelComplete?.call();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (currentHeight != targetHeight) {
      // Smooth spring/lerp towards target height
      currentHeight += (targetHeight - currentHeight) * 10.0 * dt;
      if ((targetHeight - currentHeight).abs() < 1.0) {
        currentHeight = targetHeight;
      }
    }

    if (currentHeight > game.size.y * 0.5) {
      uiTimer += dt;
    } else {
      uiTimer = 0.0;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.size.isZero()) return;

    double width = game.size.x;
    double height = currentHeight;
    double yPos = 25.0;

    // Base metal bar spanning the screen
    Rect barRect = Rect.fromLTRB(10.0, yPos, width - 10.0, yPos + height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
      basePaint,
    );

    // Draw the checkered pattern painted onto the metal
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
    );

    int segments = (width / 16).ceil();
    double dx = width / segments;

    // Instead of fixing rows to 2, dynamically calculate rows so the squares stretch,
    // or keep them proportional. The user asked for it to look like it's "stretching down".
    int rows = (height / dx).ceil();
    if (rows < 2) rows = 2; // minimum 2 rows
    double dy = height / rows;

    double fadeRatio = ((currentHeight - 24.0) / (game.size.y - 24.0)).clamp(
      0.0,
      1.0,
    );
    Color currentBlack =
        Color.lerp(Colors.black87, Colors.white, fadeRatio) ?? Colors.white;
    Color currentWhite =
        Color.lerp(Colors.white70, Colors.white, fadeRatio) ?? Colors.white;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < segments; c++) {
        bool isBlack = (r + c) % 2 == 0;
        Paint p = Paint()..color = isBlack ? currentBlack : currentWhite;
        Rect sq = Rect.fromLTWH(c * dx, yPos + r * dy, dx, dy);
        canvas.drawRect(sq, p);
      }
    }

    canvas.restore(); // Restore clip so highlights extend slightly if needed

    // 3D edge highlights (on top of checkers to make it look like a physical volume)
    Rect topHighlight = Rect.fromLTRB(12.0, yPos + 1, width - 12.0, yPos + 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(topHighlight, const Radius.circular(2)),
      highlightPaint,
    );

    Rect bottomShadow = Rect.fromLTRB(
      12.0,
      yPos + height - 4,
      width - 12.0,
      yPos + height - 1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bottomShadow, const Radius.circular(2)),
      shadowPaint,
    );

    // Side mounting brackets (similar to the game bar)
    double bracketW = 18.0;

    // Left bracket
    Rect leftBracket = Rect.fromLTRB(0, yPos - 4, bracketW, yPos + height + 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftBracket, const Radius.circular(4)),
      bracketPaint,
    );
    Rect leftHl = Rect.fromLTRB(2, yPos - 2, bracketW - 2, yPos - 2 + 3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftHl, const Radius.circular(1)),
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(bracketW / 2, yPos + height / 2 + 1),
      3,
      shadowPaint,
    );
    canvas.drawCircle(Offset(bracketW / 2, yPos + height / 2), 2, rivetPaint);

    // Right bracket
    Rect rightBracket = Rect.fromLTRB(
      width - bracketW,
      yPos - 4,
      width,
      yPos + height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightBracket, const Radius.circular(4)),
      bracketPaint,
    );
    Rect rightHl = Rect.fromLTRB(
      width - bracketW + 2,
      yPos - 2,
      width - 2,
      yPos - 2 + 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightHl, const Radius.circular(1)),
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(width - bracketW / 2, yPos + height / 2 + 1),
      3,
      shadowPaint,
    );
    canvas.drawCircle(
      Offset(width - bracketW / 2, yPos + height / 2),
      2,
      rivetPaint,
    );

    // Draw Native Flame UI if the curtain is down
    if (currentHeight > game.size.y * 0.5 && uiTimer > 0) {
      bool isVictory = game.currentLevel.value >= 9;

      // Title Animation (starts at 0.0s)
      double titleProgress = ((uiTimer - 0.0) / 0.4).clamp(0.0, 1.0);
      double titleScale = Curves.easeOutBack.transform(titleProgress);
      if (titleProgress > 0) {
        canvas.save();
        canvas.translate(width / 2, currentHeight / 2 - 80);
        canvas.scale(titleScale);
        titlePaint.render(
          canvas,
          isVictory ? 'VICTORY!' : 'LEVEL COMPLETE!',
          Vector2.zero(),
          anchor: Anchor.center,
        );
        canvas.restore();
      }

      // Stars Animation (staggered at 0.2s, 0.4s, 0.6s)
      int stars = game.currentPoints.value;
      for (int i = 0; i < 3; i++) {
        double starProgress = ((uiTimer - (0.2 + i * 0.15)) / 0.4).clamp(
          0.0,
          1.0,
        );
        if (starProgress > 0) {
          double starScale = Curves.easeOutBack.transform(starProgress);
          canvas.save();
          canvas.translate(width / 2 - 60 + i * 60, currentHeight / 2 - 20);
          canvas.scale(starScale);
          _drawStar(canvas, Vector2.zero().toOffset(), i < stars, starProgress);
          canvas.restore();
        }
      }

      // Next Level / Return to Lobby Button Animation (starts at 0.8s)
      double nextBtnProgress = ((uiTimer - 0.8) / 0.4).clamp(0.0, 1.0);
      if (!isVictory) {
        if (nextBtnProgress > 0) {
          double nextBtnScale = Curves.easeOutBack.transform(nextBtnProgress);
          nextLevelButtonRect = Rect.fromCenter(
            center: Offset(width / 2, currentHeight / 2 + 50),
            width: 200,
            height: 48,
          );

          canvas.save();
          canvas.translate(width / 2, currentHeight / 2 + 50);
          canvas.scale(nextBtnScale);

          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: 200, height: 48),
              const Radius.circular(12),
            ),
            Paint()
              ..color = Colors.cyanAccent.shade700.withValues(
                alpha: nextBtnProgress,
              ),
          );
          labelPaint.render(
            canvas,
            'Next Level',
            Vector2.zero(),
            anchor: Anchor.center,
          );
          canvas.restore();
        } else {
          nextLevelButtonRect = Rect.zero;
        }
        returnToLobbyButtonRect = Rect.zero;
      } else {
        nextLevelButtonRect = Rect.zero;
        if (nextBtnProgress > 0) {
          double btnScale = Curves.easeOutBack.transform(nextBtnProgress);
          returnToLobbyButtonRect = Rect.fromCenter(
            center: Offset(width / 2, currentHeight / 2 + 50),
            width: 200,
            height: 48,
          );

          canvas.save();
          canvas.translate(width / 2, currentHeight / 2 + 50);
          canvas.scale(btnScale);

          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: 200, height: 48),
              const Radius.circular(12),
            ),
            Paint()
              ..color = Colors.green.withValues(
                alpha: nextBtnProgress,
              ),
          );
          labelPaint.render(
            canvas,
            'Return to Lobby',
            Vector2.zero(),
            anchor: Anchor.center,
          );
          canvas.restore();
        } else {
          returnToLobbyButtonRect = Rect.zero;
        }
      }

      // Restart Button Animation (starts at 1.0s)
      double restartBtnProgress = ((uiTimer - 1.0) / 0.4).clamp(0.0, 1.0);
      if (restartBtnProgress > 0) {
        double restartBtnScale = Curves.easeOutBack.transform(
          restartBtnProgress,
        );
        restartButtonRect = Rect.fromCenter(
          center: Offset(width / 2, currentHeight / 2 + 110),
          width: 200,
          height: 48,
        );

        canvas.save();
        canvas.translate(width / 2, currentHeight / 2 + 110);
        canvas.scale(restartBtnScale);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: 200, height: 48),
            const Radius.circular(12),
          ),
          Paint()
            ..color = Colors.orangeAccent.withValues(alpha: restartBtnProgress),
        );
        labelPaint.render(
          canvas,
          'Restart',
          Vector2.zero(),
          anchor: Anchor.center,
        );
        canvas.restore();
      } else {
        restartButtonRect = Rect.zero;
      }
    } else {
      nextLevelButtonRect = Rect.zero;
      restartButtonRect = Rect.zero;
      returnToLobbyButtonRect = Rect.zero;
    }
  }

  void _drawStar(Canvas canvas, Offset center, bool filled, double alpha) {
    IconData starIcon = filled ? Icons.star : Icons.star_border;
    Color starColor = filled ? Colors.orange : Colors.orange;

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(starIcon.codePoint),
        style: TextStyle(
          color: starColor.withValues(alpha: alpha),
          fontSize: 48,
          fontFamily: starIcon.fontFamily,
          package: starIcon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Draw centered on the requested point
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
}
