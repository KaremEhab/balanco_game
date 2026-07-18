import 'package:flutter/material.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';

class LevelGradientBackground extends StatelessWidget {
  const LevelGradientBackground({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final palette = LevelPalette.forLevel(level);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.25,
          colors: palette.backdrop,
          stops: const [0, 0.54, 1],
        ),
      ),
    );
  }
}

class LevelPalette {
  const LevelPalette({
    required this.backdrop,
    required this.border,
    required this.board,
  });

  final List<Color> backdrop;
  final List<Color> border;
  final List<Color> board;

  static LevelPalette forLevel(int level) {
    final biome = BiomeConfig.getBiomeForLevel(level);

    return LevelPalette(
      backdrop: [
        Color.lerp(biome.pathColor, Colors.white, 0.1)!,
        Color.lerp(biome.pathColor, biome.bgTopColor, 0.54)!,
        biome.bgTopColor,
      ],
      border: [
        biome.nodeUnlockedColor,
        biome.primaryColor,
        biome.nodeUnlockedBorderColor,
      ],
      board: [
        biome.bgTopColor.withValues(alpha: 0.5),
        biome.bgBottomColor.withValues(alpha: 0.5),
        biome.bgTopColor.withValues(alpha: 0.5),
      ],
    );
  }
}
