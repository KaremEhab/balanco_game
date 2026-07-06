import 'dart:ui';
import 'package:flame/components.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/components/floating_text_component.dart';

class CoinComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final double radius = 15.0;
  bool isCollected = false;

  double _time = 0.0;
  double _scale = 1.0;

  CoinComponent({required Vector2 position}) {
    this.position = position;
    size = Vector2(radius * 2, radius * 2);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isCollected) {
      _scale -= dt * 5;
      if (_scale <= 0) {
        removeFromParent();
      }
    } else {
      _time += dt;
      // Gentle bobbing
      _scale = 1.0 + 0.08 * ((_time * 2.5).remainder(1.0) < 0.5
          ? (_time * 2.5).remainder(1.0)
          : 1.0 - (_time * 2.5).remainder(1.0));
    }
  }

  @override
  void render(Canvas canvas) {
    if (_scale <= 0) return;
    canvas.save();
    canvas.translate(radius, radius);
    canvas.scale(_scale, _scale);

    // Outer gold ring
    final paintOuter = Paint()..color = GameColors.amber800;
    canvas.drawCircle(Offset.zero, radius, paintOuter);

    // Inner face
    final paintInner = Paint()..color = GameColors.amber400;
    canvas.drawCircle(Offset.zero, radius * 0.78, paintInner);

    // Subtle inner gradient ring
    final paintMid = Paint()..color = const Color(0xFFFFE066);
    canvas.drawCircle(Offset.zero, radius * 0.58, paintMid);

    // Coin shine highlight
    final paintShine = Paint()
      ..color = GameColors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius * 0.48),
      -1.4,
      1.2,
      false,
      paintShine,
    );

    canvas.restore();
  }

  void collect() {
    if (isCollected) return;
    isCollected = true;

    game.collectedCoins.value += 1;

    // Spawn floating text
    parent?.add(
      FloatingTextComponent(
        text: '+1🪙',
        position: position.clone(),
        color: GameColors.amber400,
      ),
    );
  }
}
