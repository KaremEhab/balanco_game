import 'package:flutter/material.dart';
import 'package:balanco_game/features/map/theme/map_theme.dart';

class BeachMapTheme extends MapTheme {
  BeachMapTheme()
      : super(
          pathLineColor: const Color(0xFFFFD54F), // Sand color for path
          lockedNodeDecoration: BoxDecoration(
            color: const Color(0xFFB0BEC5), // Grey out
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF78909C), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          unlockedNodeDecoration: BoxDecoration(
            color: const Color(0xFFFFD54F), // Sand/Gold
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFA000), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          activeNodeDecoration: BoxDecoration(
            color: const Color(0xFF4CAF50), // Green for current level
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF388E3C), width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF81C784),
                blurRadius: 8,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
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
                  Color(0xFF10A8E0), // Deep Teal at top
                  Color(0xFF52FEDA), // Aquamarine at bottom
                ],
              ),
            ),
          ),
        );
}
