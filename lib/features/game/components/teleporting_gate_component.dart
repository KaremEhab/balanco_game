import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class TeleportingGateComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  bool isClosing = false;
  bool isOpening = false;
  bool isClosed = false;
  double _time = 0;
  double _doorProgress = 0.0;

  TeleportingGateComponent() {
    size = Vector2(100, 100);
    anchor = Anchor.center;
  }

  void reset() {
    isClosing = false;
    isOpening = false;
    isClosed = false;
    _doorProgress = 0.0;
  }

  void startClosed() {
    isClosing = false;
    isOpening = false;
    isClosed = true;
    _doorProgress = 1.0;
  }

  void open() {
    isClosing = false;
    isOpening = true;
    isClosed = false;
  }

  void spit() {
    // A quick punchy scale jump to simulate spitting an object
    add(
      ScaleEffect.by(
        Vector2.all(1.15),
        EffectController(
          duration: 0.1,
          reverseDuration: 0.1,
          curve: Curves.easeOutQuad,
        ),
      ),
    );

    // Add a simple burst of energy/water rings (placeholder for full particle effect)
    // We could add a simple particle system if needed.
  }

  void applyReplicaState({
    required bool closing,
    required bool opening,
    required bool closed,
  }) {
    isClosing = closing;
    isOpening = opening;
    isClosed = closed;
    if (closed) {
      _doorProgress = 1.0;
    } else if (!closing && !opening) {
      _doorProgress = 0.0;
    }
  }

  @override
  void update(double dt) {
    _time += dt;
    if (isClosing) {
      _doorProgress += dt * 1.5; // Closes in ~0.66 seconds
      if (_doorProgress >= 1.0) {
        _doorProgress = 1.0;
        isClosing = false;
        isClosed = true;
      }
    } else if (isOpening) {
      _doorProgress -= dt * 1.5;
      if (_doorProgress <= 0.0) {
        _doorProgress = 0.0;
        isOpening = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (size.x <= 0) return;

    double scale = 1.0 - _doorProgress;

    if (scale > 0) {
      canvas.save();
      // Move origin to the exact center of the component
      canvas.translate(size.x / 2, size.y / 2);
      // Scale down to nothingness when closing
      canvas.scale(scale);

      // Draw a bright, highly visible glowing shadow around the gate
      // By drawing multiple fading concentric circles, we guarantee it renders everywhere
      for (int i = 6; i >= 0; i--) {
        final Paint glowPaint = Paint()
          // Start with a very low base opacity and softly fade inwards
          ..color = GameColors.teleporterLightPurple.withValues(
            alpha: 0.02 + (6 - i) * 0.05,
          )
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, 36 + i * 2.5, glowPaint);
      }

      // Clip to a perfect circle at the center for the portal itself
      canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 36)),
      );

      // Draw base outer color to prevent empty gaps at the edge
      final Paint basePaint = Paint()
        ..color = GameColors.teleporterVeryLightPurple
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 36, basePaint);

      // Draw shrinking concentric circles
      int numCircles = 14;
      List<double> phases = List.generate(
        numCircles,
        (i) => ((i / numCircles) - (_time * 0.4)) % 1.0,
      );
      // Sort descending so larger circles are drawn first
      phases.sort((a, b) => b.compareTo(a));

      for (double phase in phases) {
        // Linear radius looks like a perfect tunnel
        double r = phase * 36.0;

        // Grade colors from light (edge) to dark (center)
        Color c;
        if (phase > 0.5) {
          c = Color.lerp(
            GameColors.teleporterDeepPurple,
            GameColors.teleporterVeryLightPurple,
            (phase - 0.5) * 2,
          )!;
        } else {
          c = Color.lerp(
            GameColors.teleporterDarkBg,
            GameColors.teleporterDeepPurple,
            phase * 2,
          )!;
        }

        final Paint circlePaint = Paint()
          ..color = c
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset.zero, r, circlePaint);

        // Add subtle edge shadows for a stepped 3D look
        final Paint strokePaint = Paint()
          ..color = GameColors.black.withValues(alpha: 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawCircle(Offset.zero, r, strokePaint);

        final Paint highlightPaint = Paint()
          ..color = GameColors.white.withValues(alpha: 0.1 * phase)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawCircle(Offset(0, -1), r, highlightPaint);
      }

      canvas.restore();
    }
  }
}
