import 'package:flutter/material.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';

class BiomeConfig {
  static const BiomeModel tropicalBeach = BiomeModel(
    startLevel: 1,
    endLevel: 15,
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

  static const BiomeModel pyramids = BiomeModel(
    startLevel: 16,
    endLevel: 45,
    primaryColor: Color(0xFFD99A3D),
    secondaryColor: Color(0xFFFFD36A),
    nodeUnlockedColor: Color(0xFFFFD36A),
    nodeUnlockedBorderColor: Color(0xFFD99A3D),
    nodeUnlockedTeethColor: Color(0xFFFFD36A),
    nodeUnlockedOuterEdgeColor: GameColors.white,
    nodeUnlockedRivetColor: Color(0xFF6B3E16),
    nodeUnlockedInnerColors: [
      Color(0xFFFFD36A),
      Color(0xFFF4BA54),
      Color(0xFFD99A3D),
      Color(0xFFA56B2D),
      Color(0xFF6B3E16),
      GameColors.blackSolid,
    ],
    nodeLockedColor: Color(0xFF6A513E),
    nodeLockedBorderColor: Color(0xFF6B3E16),
    nodeLockedTeethColor: Color(0xFF6B3E16),
    nodeLockedOuterEdgeColor: GameColors.blueGray100,
    nodeLockedRivetColor: Color(0xFF6B3E16),
    nodeLockedInnerColors: [
      Color(0xFFD99A3D),
      Color(0xFF6B3E16),
      GameColors.blackSolid,
    ],
    pathColor: Color(0xFFFFD36A),
    bgTopColor: Color(0xFF6B3E16),
    bgBottomColor: Color(0xFFD99A3D),
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

  static final List<BiomeModel> biomes = [
    tropicalBeach,
    pyramids,
    _simpleBiome(
      startLevel: 46,
      endLevel: 75,
      primary: const Color(0xFF278447),
      secondary: const Color(0xFF8FD15D),
      dark: const Color(0xFF123D24),
    ),
    _simpleBiome(
      startLevel: 76,
      endLevel: 105,
      primary: const Color(0xFF6DAFDB),
      secondary: const Color(0xFFE1F7FF),
      dark: const Color(0xFF244C70),
    ),
    _simpleBiome(
      startLevel: 106,
      endLevel: 135,
      primary: const Color(0xFFC43A31),
      secondary: const Color(0xFFFFB14A),
      dark: const Color(0xFF431816),
    ),
    _simpleBiome(
      startLevel: 136,
      endLevel: 165,
      primary: const Color(0xFF00B8D9),
      secondary: const Color(0xFFFF4FD8),
      dark: const Color(0xFF151044),
    ),
    _simpleBiome(
      startLevel: 166,
      endLevel: 195,
      primary: const Color(0xFF4756D6),
      secondary: const Color(0xFFA9F3FF),
      dark: const Color(0xFF080B25),
    ),
    _simpleBiome(
      startLevel: 196,
      endLevel: 225,
      primary: const Color(0xFF067A8A),
      secondary: const Color(0xFF5BE7D1),
      dark: const Color(0xFF043B47),
    ),
    _simpleBiome(
      startLevel: 226,
      endLevel: 255,
      primary: const Color(0xFFE84D8A),
      secondary: const Color(0xFFFFD166),
      dark: const Color(0xFF7C2854),
    ),
    _simpleBiome(
      startLevel: 256,
      endLevel: 285,
      primary: const Color(0xFF5F4B8B),
      secondary: const Color(0xFF9EE493),
      dark: const Color(0xFF21182F),
    ),
    _simpleBiome(
      startLevel: 286,
      endLevel: 315,
      primary: const Color(0xFF78A7FF),
      secondary: const Color(0xFFFFF5A5),
      dark: const Color(0xFF334B8D),
    ),
    _simpleBiome(
      startLevel: 316,
      endLevel: 345,
      primary: const Color(0xFF7D5FFF),
      secondary: const Color(0xFF8FFFE1),
      dark: const Color(0xFF2C246B),
    ),
    _simpleBiome(
      startLevel: 346,
      endLevel: 375,
      primary: const Color(0xFFE05A47),
      secondary: const Color(0xFF7BD389),
      dark: const Color(0xFF35424A),
    ),
    _simpleBiome(
      startLevel: 376,
      endLevel: 405,
      primary: const Color(0xFF8C98A8),
      secondary: const Color(0xFFE8ECF2),
      dark: const Color(0xFF2A2F3A),
    ),
    _simpleBiome(
      startLevel: 406,
      endLevel: 435,
      primary: const Color(0xFF00D084),
      secondary: const Color(0xFF53A7FF),
      dark: const Color(0xFF061E2E),
    ),
    _simpleBiome(
      startLevel: 436,
      endLevel: 465,
      primary: const Color(0xFFB7853D),
      secondary: const Color(0xFF61C0A8),
      dark: const Color(0xFF2C2516),
    ),
    _simpleBiome(
      startLevel: 466,
      endLevel: 495,
      primary: const Color(0xFF2F2A8F),
      secondary: const Color(0xFFFF6B6B),
      dark: const Color(0xFF09071E),
    ),
    _simpleBiome(
      startLevel: 496,
      endLevel: 500,
      primary: const Color(0xFFB00020),
      secondary: const Color(0xFFFFC857),
      dark: const Color(0xFF120006),
    ),
  ];

  static const List<String> sceneNames = [
    'Tropical Beach',
    'Mystic Pyramids',
    'Jungle Ruins',
    'Frozen Peaks',
    'Volcanic Ridge',
    'Neon Carnival',
    'Star Station',
    'Sunken Temple',
    'Candy Coast',
    'Enchanted Forest',
    'Cloud Kingdom',
    'Crystal Caverns',
    'Autumn Canyon',
    'Steel Factory',
    'Cyber City',
    'Ancient Swamp',
    'Nightmare Realm',
    'Final Eclipse',
  ];

  static int getBiomeIndex(BiomeModel biome) {
    final index = biomes.indexOf(biome);
    if (index >= 0) return index;
    return biomes.indexWhere(
      (item) =>
          item.startLevel == biome.startLevel &&
          item.endLevel == biome.endLevel,
    );
  }

  static int getBiomeIndexForLevel(int level) =>
      getBiomeIndex(getBiomeForLevel(level));

  static String getSceneName(BiomeModel biome) {
    final index = getBiomeIndex(biome);
    if (index < 0 || index >= sceneNames.length) return 'New World';
    return sceneNames[index];
  }

  static BiomeModel _simpleBiome({
    required int startLevel,
    required int endLevel,
    required Color primary,
    required Color secondary,
    required Color dark,
  }) {
    return BiomeModel(
      startLevel: startLevel,
      endLevel: endLevel,
      primaryColor: primary,
      secondaryColor: secondary,
      nodeUnlockedColor: secondary,
      nodeUnlockedBorderColor: primary,
      nodeUnlockedTeethColor: secondary,
      nodeUnlockedOuterEdgeColor: GameColors.white,
      nodeUnlockedRivetColor: dark,
      nodeUnlockedInnerColors: [
        secondary,
        Color.lerp(secondary, primary, 0.35) ?? secondary,
        primary,
        Color.lerp(primary, dark, 0.45) ?? primary,
        dark,
        GameColors.blackSolid,
      ],
      nodeLockedColor: Color.lerp(dark, GameColors.gray700, 0.35) ?? dark,
      nodeLockedBorderColor: dark,
      nodeLockedTeethColor: dark,
      nodeLockedOuterEdgeColor: GameColors.blueGray100,
      nodeLockedRivetColor: dark,
      nodeLockedInnerColors: [primary, dark, GameColors.blackSolid],
      pathColor: secondary,
      bgTopColor: dark,
      bgBottomColor: primary,
    );
  }

  static BiomeModel getDynamicScoreBiome(int score) {
    // The hue shifts smoothly based on the current score.
    // 360 degrees of hue, shift a little bit for every point.
    // Score / 5 means 1800 points for a full rainbow cycle.
    final double hue = ((score / 5.0) % 360).toDouble();

    final Color primary = HSVColor.fromAHSV(1, hue, 0.82, 0.58).toColor();
    final Color secondary = HSVColor.fromAHSV(
      1,
      (hue + 56) % 360,
      0.78,
      0.88,
    ).toColor();
    final Color dark = HSVColor.fromAHSV(
      1,
      (hue + 24) % 360,
      0.86,
      0.28,
    ).toColor();
    final Color deep = HSVColor.fromAHSV(
      1,
      (hue + 220) % 360,
      0.72,
      0.18,
    ).toColor();
    final Color glow = HSVColor.fromAHSV(
      1,
      (hue + 112) % 360,
      0.62,
      1.0,
    ).toColor();

    return BiomeModel(
      startLevel: 999, // Infinity
      endLevel: 999,
      primaryColor: primary,
      secondaryColor: secondary,
      nodeUnlockedColor: secondary,
      nodeUnlockedBorderColor: primary,
      nodeUnlockedTeethColor: glow,
      nodeUnlockedOuterEdgeColor: GameColors.white,
      nodeUnlockedRivetColor: dark,
      nodeUnlockedInnerColors: [
        glow,
        secondary,
        primary,
        dark,
        deep,
        GameColors.blackSolid,
      ],
      nodeLockedColor: dark,
      nodeLockedBorderColor: deep,
      nodeLockedTeethColor: deep,
      nodeLockedOuterEdgeColor: GameColors.blueGray100,
      nodeLockedRivetColor: deep,
      nodeLockedInnerColors: [primary, dark, deep, GameColors.blackSolid],
      pathColor: glow,
      bgTopColor: deep,
      bgBottomColor: primary,
    );
  }

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
