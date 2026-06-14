import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Global notifier to toggle between light and dark modes
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF0F2F5),
      colorScheme: const ColorScheme.light(
        primary: Colors.blueAccent,
        secondary: Colors.orangeAccent,
        surface: Colors.white,
        onSurface: Colors.black87,
        error: Colors.redAccent,
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black87,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Colors.deepPurpleAccent,
        secondary: Colors.cyanAccent,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        error: Colors.redAccent,
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
