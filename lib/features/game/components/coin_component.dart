import 'dart:ui';
import 'package:flame/components.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/components/floating_text_component.dart';
import 'package:balanco_game/features/game/components/game_area/collected_star_painter.dart';

class CoinComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  final double radius = 15.0;
  bool isCollected = false;

  double _time = 0.0;
  double _scale = 1.0;

  late final CollectedStarPainter _painter;

  CoinComponent({required Vector2 position}) {
    this.position = position;
    size = Vector2(radius * 2, radius * 2);
    anchor = Anchor.center;
    _painter = CollectedStarPainter();
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
      _scale =
          1.0 +
          0.08 *
              ((_time * 2.5).remainder(1.0) < 0.5
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

    // Use the star painter instead of coin design
    canvas.save();
    canvas.scale(size.x / 48.0, size.y / 48.0);
    canvas.translate(
      -24.0,
      -24.0,
    ); // Shift so the center of 48x48 box sits at (0,0)
    _painter.paint(canvas, const Size(48, 48));
    canvas.restore();

    canvas.restore();
  }

  void collect() {
    if (isCollected) return;
    isCollected = true;

    game.collectedCoins.value += 1;

    // Spawn floating text
    parent?.add(
      FloatingTextComponent(
        text: '+1⭐',
        position: position.clone(),
        color: GameColors.amber400,
      ),
    );
  }
}
