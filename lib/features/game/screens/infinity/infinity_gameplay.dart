import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/screens/overlays/time_stop_overlay.dart';
import 'package:balanco_game/features/game/widgets/gameplay_header.dart';

class InfinityGameplay extends StatelessWidget {
  final BalancoGame game;

  const InfinityGameplay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: game),
        TimeStopOverlay(timeNotifier: game.timeStopNotifier),
        _InfinityCountdownOverlay(countdownNotifier: game.countdownNotifier),
      ],
    );
  }
}

class InfinityScoreHeader extends StatelessWidget {
  final BalancoGame game;

  const InfinityScoreHeader({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.currentScore,
      builder: (context, score, _) {
        final currentBiome = game.currentBiome;
        return GameplayHeader(
          game: game,
          cardBaseGradient: [
            currentBiome.primaryColor,
            currentBiome.primaryColor,
          ],
          cardHighlightGradient: [
            currentBiome.nodeUnlockedColor,
            currentBiome.nodeUnlockedColor,
          ],
        );
      },
    );
  }
}

class _InfinityCountdownOverlay extends StatelessWidget {
  final ValueNotifier<int> countdownNotifier;

  const _InfinityCountdownOverlay({required this.countdownNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: countdownNotifier,
      builder: (context, countdown, _) {
        if (countdown == 0) return const SizedBox.shrink();

        final text = countdown > 1 ? '${countdown - 1}' : 'GO!';
        return Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'LuckiestGuy',
              fontSize: 100,
              color: GameColors.white,
              shadows: [
                Shadow(
                  color: GameColors.brownDarkUi,
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
