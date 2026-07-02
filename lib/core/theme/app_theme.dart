import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
}
