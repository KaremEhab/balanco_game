import 'package:flutter/material.dart';

class BiomeModel {
  final int startLevel;
  final int endLevel;

  final Color primaryColor;
  final Color secondaryColor;
  final Color nodeUnlockedColor;
  final Color nodeUnlockedBorderColor;
  final Color nodeUnlockedTeethColor;
  final Color nodeUnlockedOuterEdgeColor;
  final Color nodeUnlockedRivetColor;
  final List<Color> nodeUnlockedInnerColors;
  final Color nodeLockedColor;
  final Color nodeLockedBorderColor;
  final Color nodeLockedTeethColor;
  final Color nodeLockedOuterEdgeColor;
  final Color nodeLockedRivetColor;
  final List<Color> nodeLockedInnerColors;
  final Color pathColor;

  // Background gradient for parallax fallback or sky
  final Color bgTopColor;
  final Color bgBottomColor;

  const BiomeModel({
    required this.startLevel,
    required this.endLevel,
    required this.primaryColor,
    required this.secondaryColor,
    required this.nodeUnlockedColor,
    required this.nodeUnlockedBorderColor,
    required this.nodeUnlockedTeethColor,
    required this.nodeUnlockedOuterEdgeColor,
    required this.nodeUnlockedRivetColor,
    required this.nodeUnlockedInnerColors,
    required this.nodeLockedColor,
    required this.nodeLockedBorderColor,
    required this.nodeLockedTeethColor,
    required this.nodeLockedOuterEdgeColor,
    required this.nodeLockedRivetColor,
    required this.nodeLockedInnerColors,
    required this.pathColor,
    required this.bgTopColor,
    required this.bgBottomColor,
  });

  static BiomeModel lerp(BiomeModel a, BiomeModel b, double t) {
    return BiomeModel(
      startLevel: t < 0.5 ? a.startLevel : b.startLevel,
      endLevel: t < 0.5 ? a.endLevel : b.endLevel,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t) ?? a.primaryColor,
      secondaryColor: Color.lerp(a.secondaryColor, b.secondaryColor, t) ?? a.secondaryColor,
      nodeUnlockedColor: Color.lerp(a.nodeUnlockedColor, b.nodeUnlockedColor, t) ?? a.nodeUnlockedColor,
      nodeUnlockedBorderColor: Color.lerp(a.nodeUnlockedBorderColor, b.nodeUnlockedBorderColor, t) ?? a.nodeUnlockedBorderColor,
      nodeUnlockedTeethColor: Color.lerp(a.nodeUnlockedTeethColor, b.nodeUnlockedTeethColor, t) ?? a.nodeUnlockedTeethColor,
      nodeUnlockedOuterEdgeColor: Color.lerp(a.nodeUnlockedOuterEdgeColor, b.nodeUnlockedOuterEdgeColor, t) ?? a.nodeUnlockedOuterEdgeColor,
      nodeUnlockedRivetColor: Color.lerp(a.nodeUnlockedRivetColor, b.nodeUnlockedRivetColor, t) ?? a.nodeUnlockedRivetColor,
      nodeUnlockedInnerColors: t < 0.5 ? a.nodeUnlockedInnerColors : b.nodeUnlockedInnerColors,
      nodeLockedColor: Color.lerp(a.nodeLockedColor, b.nodeLockedColor, t) ?? a.nodeLockedColor,
      nodeLockedBorderColor: Color.lerp(a.nodeLockedBorderColor, b.nodeLockedBorderColor, t) ?? a.nodeLockedBorderColor,
      nodeLockedTeethColor: Color.lerp(a.nodeLockedTeethColor, b.nodeLockedTeethColor, t) ?? a.nodeLockedTeethColor,
      nodeLockedOuterEdgeColor: Color.lerp(a.nodeLockedOuterEdgeColor, b.nodeLockedOuterEdgeColor, t) ?? a.nodeLockedOuterEdgeColor,
      nodeLockedRivetColor: Color.lerp(a.nodeLockedRivetColor, b.nodeLockedRivetColor, t) ?? a.nodeLockedRivetColor,
      nodeLockedInnerColors: t < 0.5 ? a.nodeLockedInnerColors : b.nodeLockedInnerColors,
      pathColor: Color.lerp(a.pathColor, b.pathColor, t) ?? a.pathColor,
      bgTopColor: Color.lerp(a.bgTopColor, b.bgTopColor, t) ?? a.bgTopColor,
      bgBottomColor: Color.lerp(a.bgBottomColor, b.bgBottomColor, t) ?? a.bgBottomColor,
    );
  }
}
