import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:flutter/material.dart';

/// A lightweight, painter-free background shared by menus and gameplay.
///
/// Every layer is a composited Flutter gradient, so biome changes can animate
/// without rebuilding the large decorative parallax painter stacks.
class BiomeGradientBackground extends StatelessWidget {
  const BiomeGradientBackground({
    super.key,
    required this.biome,
    this.animate = true,
    this.deep = false,
  });

  final BiomeModel biome;
  final bool animate;
  final bool deep;

  Duration get _duration => animate
      ? const Duration(milliseconds: 1050)
      : Duration.zero;

  @override
  Widget build(BuildContext context) {
    final top = Color.lerp(
      biome.bgTopColor,
      biome.primaryColor,
      deep ? 0.08 : 0.24,
    )!;
    final middle = Color.lerp(
      biome.primaryColor,
      biome.secondaryColor,
      deep ? 0.24 : 0.46,
    )!;
    final lower = Color.lerp(
      biome.bgBottomColor,
      biome.secondaryColor,
      deep ? 0.12 : 0.32,
    )!;
    final bottom = Color.lerp(
      biome.bgTopColor,
      Colors.black,
      deep ? 0.48 : 0.25,
    )!;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            duration: _duration,
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-0.9, -1),
                end: const Alignment(0.85, 1),
                colors: [top, middle, lower, bottom],
                stops: const [0, 0.34, 0.7, 1],
              ),
            ),
          ),
          AnimatedContainer(
            duration: _duration,
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.82, -0.78),
                radius: 0.92,
                colors: [
                  biome.secondaryColor.withValues(alpha: deep ? 0.24 : 0.42),
                  biome.primaryColor.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0, 0.38, 1],
              ),
            ),
          ),
          AnimatedContainer(
            duration: _duration,
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.88, 0.9),
                radius: 1.05,
                colors: [
                  biome.primaryColor.withValues(alpha: deep ? 0.3 : 0.4),
                  biome.bgBottomColor.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
                stops: const [0, 0.42, 1],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: deep ? 0.025 : 0.055),
                  Colors.transparent,
                  Colors.black.withValues(alpha: deep ? 0.18 : 0.08),
                ],
                stops: const [0, 0.48, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
