import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/models/level_data.dart';

class LevelDebugOverlay extends PositionComponent
    with HasGameReference<BalancoGame> {
  bool showSafePath;
  bool showSafeCorridor;
  bool showObstacleRadius;
  bool showMovingTrajectories;
  bool showTeleportLinks;
  bool showMetadata;

  LevelDebugOverlay({
    this.showSafePath = true,
    this.showSafeCorridor = true,
    this.showObstacleRadius = true,
    this.showMovingTrajectories = true,
    this.showTeleportLinks = true,
    this.showMetadata = true,
  }) : super(priority: 1000);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    final data = game.currentLevelData;
    if (data == null || game.isInfinityMode) return;

    canvas.save();
    canvas.translate(0, -game.cameraOffsetY);

    if (showSafeCorridor && data.safePath.length >= 2) {
      _drawCorridor(canvas, data);
    }
    if (showSafePath && data.safePath.length >= 2) {
      _drawSafePath(canvas, data);
    }
    if (showObstacleRadius) {
      _drawObstacleRadii(canvas);
    }
    if (showMovingTrajectories) {
      _drawMovingTrajectories(canvas);
    }
    if (showTeleportLinks) {
      _drawTeleportLinks(canvas);
    }

    canvas.restore();

    if (showMetadata) {
      _drawMetadata(canvas, data);
    }
  }

  void _drawSafePath(Canvas canvas, LevelData data) {
    final paint = Paint()
      ..color = GameColors.mapAppBarGreenAccent.withValues(alpha: 0.9)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    for (var i = 0; i < data.safePath.length; i++) {
      final p = _toWorld(data.safePath[i]);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawCorridor(Canvas canvas, LevelData data) {
    final paint = Paint()
      ..color = GameColors.mapAppBarGreenAccent.withValues(alpha: 0.12)
      ..strokeWidth = max(24.0, data.safeCorridorWidth * game.size.x)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path();
    for (var i = 0; i < data.safePath.length; i++) {
      final p = _toWorld(data.safePath[i]);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawObstacleRadii(Canvas canvas) {
    final paint = Paint()
      ..color = GameColors.redAccent.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final suctionPaint = Paint()
      ..color = GameColors.purpleAccent.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final hole in game.holes) {
      canvas.drawCircle(hole.position.toOffset(), hole.size.x / 2, paint);
      if (hole.isSuckingHole) {
        canvas.drawCircle(
          hole.position.toOffset(),
          hole.suckRadius,
          suctionPaint,
        );
      }
    }
    for (final bumper in game.bumpers) {
      canvas.drawCircle(bumper.position.toOffset(), bumper.radius, paint);
    }
  }

  void _drawMovingTrajectories(Canvas canvas) {
    final paint = Paint()
      ..color = GameColors.cyanAccent.withValues(alpha: 0.65)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (final hole in game.holes.where((hole) => hole.isMovingHole)) {
      if (hole.moveAxis == 'vertical') {
        canvas.drawLine(
          Offset(
            hole.position.x,
            hole.position.y - hole.moveRange * game.levelHeight,
          ),
          Offset(
            hole.position.x,
            hole.position.y + hole.moveRange * game.levelHeight,
          ),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(
            hole.position.x - hole.moveRange * game.size.x,
            hole.position.y,
          ),
          Offset(
            hole.position.x + hole.moveRange * game.size.x,
            hole.position.y,
          ),
          paint,
        );
      }
    }
  }

  void _drawTeleportLinks(Canvas canvas) {
    final byPair = <int, List<Offset>>{};
    for (final teleporter in game.teleporters) {
      byPair
          .putIfAbsent(teleporter.index, () => [])
          .add(teleporter.position.toOffset());
    }
    final paint = Paint()
      ..color = GameColors.blueAccent.withValues(alpha: 0.72)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (final points in byPair.values) {
      if (points.length == 2) {
        canvas.drawLine(points[0], points[1], paint);
      }
    }
  }

  void _drawMetadata(Canvas canvas, LevelData data) {
    final text = [
      'Level ${game.currentLevel.value}',
      if (data.themeId != null) 'theme ${data.themeId}',
      if (data.difficulty != null)
        'difficulty ${data.difficulty!.toStringAsFixed(3)}',
      if (data.generationSeed != null) 'seed ${data.generationSeed}',
    ].join('\n');
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: GameColors.whiteSolid,
          fontSize: 12,
          height: 1.25,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 220);
    final rect = Rect.fromLTWH(8, 8, painter.width + 16, painter.height + 14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      Paint()..color = GameColors.black.withValues(alpha: 0.58),
    );
    painter.paint(canvas, const Offset(16, 15));
  }

  Offset _toWorld(Vector2 fractional) => Offset(
    fractional.x * game.size.x,
    120.0 + fractional.y * (game.levelHeight - 320.0),
  );
}
