import 'package:flutter/material.dart';
import '../../game/components/game_area/gameplay_card_painter.dart';
import '../../game/game_area.dart';
import '../../widgets/svg_with_shadow.dart';

class GameplayHeader extends StatelessWidget {
  final BalancoGame game;
  final List<Color> cardBaseGradient;
  final List<Color> cardHighlightGradient;

  const GameplayHeader({
    super.key,
    required this.game,
    required this.cardBaseGradient,
    required this.cardHighlightGradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: SizedBox(
          width: 411,
          height: 105,
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(411, 105),
                painter: GameplayTopPainter(
                  baseGradient: cardBaseGradient,
                  highlightGradient: cardHighlightGradient,
                ),
              ),
              
              // Energy Indicator
              Positioned(
                left: 0,
                top: 30,
                child: ValueListenableBuilder<int>(
                  valueListenable: game.currentPoints, // Or energy variable when fully implemented
                  builder: (context, energy, child) {
                    return SvgWithShadow(
                      assetName: 'assets/images/energy.svg',
                      width: 100,
                      height: 80,
                    );
                  },
                ),
              ),
              
              // Hearts Indicator
              Center(
                child: ValueListenableBuilder<int>(
                  valueListenable: game.currentLives,
                  builder: (context, lives, child) {
                    return SvgWithShadow(
                      assetName: 'assets/images/hearts.svg',
                      width: 150,
                      height: 105,
                    );
                  },
                ),
              ),
              
              // Stars Indicator
              Positioned(
                right: 0,
                top: 30,
                child: ValueListenableBuilder<int>(
                  valueListenable: game.currentPoints, // Points represent collected stars
                  builder: (context, stars, child) {
                    return SvgWithShadow(
                      assetName: 'assets/images/stars.svg',
                      width: 100,
                      height: 80,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
