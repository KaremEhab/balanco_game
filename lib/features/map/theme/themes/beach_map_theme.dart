import 'package:flutter/material.dart';
import 'package:balanco_game/features/map/theme/map_theme.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class BeachMapTheme extends MapTheme {
  BeachMapTheme()
    : super(
        pathLineColor: GameColors.beachMapThemeColor6, // Sand color for path
        lockedNodeDecoration: BoxDecoration(
          color: GameColors.beachMapThemeColor4, // Grey out
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GameColors.beachMapThemeColor3, width: 3),
          boxShadow: [
            BoxShadow(
              color: GameColors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        unlockedNodeDecoration: BoxDecoration(
          color: GameColors.beachMapThemeColor6, // Sand/Gold
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GameColors.beachMapThemeColor5, width: 3),
          boxShadow: [
            BoxShadow(
              color: GameColors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        activeNodeDecoration: BoxDecoration(
          color: GameColors.settingsScreenColor1, // Green for current level
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GameColors.green700, width: 4),
          boxShadow: [
            BoxShadow(
              color: GameColors.green300,
              blurRadius: 8,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: GameColors.black.withValues(alpha: 0.4),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                GameColors.beachMapThemeColor1, // Deep Teal at top
                GameColors.beachMapThemeColor2, // Aquamarine at bottom
              ],
            ),
          ),
        ),
      );
}
