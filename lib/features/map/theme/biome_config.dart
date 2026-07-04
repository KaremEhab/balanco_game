import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';

class BiomeConfig {
  static const BiomeModel tropicalBeach = BiomeModel(
    startLevel: 1,
    endLevel: 10,
    primaryColor: GameColors.beachMapThemeColor1, // Deep Teal
    secondaryColor: GameColors.beachMapThemeColor2, // Aquamarine
    nodeUnlockedColor: GameColors.beachMapThemeColor2,
    nodeUnlockedBorderColor: GameColors.beachMapThemeColor1,
    nodeUnlockedTeethColor: GameColors.beachMapThemeColor2,
    nodeUnlockedOuterEdgeColor: GameColors.white,
    nodeUnlockedRivetColor: GameColors.beachMapThemeColor1,
    nodeUnlockedInnerColors: [
      GameColors.beachMapThemeColor1,
      Color(0xFF0D8BB8),
      Color(0xFF0A6E94),
      Color(0xFF064E6C),
      Color(0xFF032D40),
      GameColors.blackSolid,
    ],
    nodeLockedColor: GameColors.woodMediumDark,
    nodeLockedBorderColor: GameColors.woodDark,
    nodeLockedTeethColor: GameColors.woodDark,
    nodeLockedOuterEdgeColor: GameColors.blueGray100,
    nodeLockedRivetColor: GameColors.woodDark,
    nodeLockedInnerColors: [
      GameColors.woodMediumDark,
      GameColors.woodDark,
      GameColors.woodVeryDark,
      GameColors.woodDeep,
      GameColors.blackSolid,
    ],
    pathColor:
        GameColors.beachMapThemeColor2, // Aquamarine to match button/ball
    bgTopColor: GameColors.beachMapThemeColor1,
    bgBottomColor: GameColors.beachMapThemeColor2,
  );

  static const BiomeModel crystalCave = BiomeModel(
    startLevel: 11,
    endLevel: 30,
    primaryColor: GameColors.holeDarkPurple, // Deep dark purple
    secondaryColor: GameColors.purple800, // Navy blue / deep violet
    nodeUnlockedColor: GameColors.purple300,
    nodeUnlockedBorderColor: GameColors
        .purple300, // Solid purple for the ring just like HoleComponent!
    nodeUnlockedTeethColor: GameColors.purple300, // From HoleComponent
    nodeUnlockedOuterEdgeColor: GameColors.purple100,
    nodeUnlockedRivetColor: GameColors.purple800,
    nodeUnlockedInnerColors: [
      Color.fromARGB(255, 133, 42, 194), // purple600
      Color.fromARGB(255, 125, 36, 170), // purple600
      Color(0xFF6A1B9A), // purple800
      Color(0xFF4A148C), // purple900
      Color(0xFF280659), // very dark purple
      GameColors.blackSolid,
    ],
    nodeLockedColor: GameColors.gray700, // Dark steel
    nodeLockedBorderColor: GameColors.holeDeepPurple,
    nodeLockedTeethColor: GameColors.holeDeepPurple,
    nodeLockedOuterEdgeColor: GameColors.blueGray100,
    nodeLockedRivetColor: GameColors.holeDeepPurple,
    nodeLockedInnerColors: [
      GameColors.holeDeepPurple,
      GameColors.holeIndigo,
      GameColors.holeVeryDark,
      GameColors.blackSolid,
    ],
    pathColor: GameColors.purple300, // Glowing neon path
    bgTopColor: GameColors.holeVeryDark, // Very dark purple
    bgBottomColor: GameColors.holeIndigo,
  );

  static final List<BiomeModel> biomes = [tropicalBeach, crystalCave];

  static BiomeModel getBiomeForLevel(int level) {
    for (final biome in biomes) {
      if (level >= biome.startLevel && level <= biome.endLevel) {
        return biome;
      }
    }
    // Fallback to last biome if level exceeds
    return biomes.last;
  }
}
