import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: GameColors.blue,
      scaffoldBackgroundColor: GameColors.appThemeColor1,
      colorScheme: const ColorScheme.light(
        primary: GameColors.blueAccent,
        secondary: GameColors.orangeAccent,
        surface: GameColors.white,
        onSurface: GameColors.black87,
        error: GameColors.redAccent,
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: GameColors.black87,
        displayColor: GameColors.black,
      ),
      iconTheme: const IconThemeData(color: GameColors.black87),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GameColors.blueAccent,
          foregroundColor: GameColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
