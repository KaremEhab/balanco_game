import 'dart:math' as math;

import 'package:balanco_game/features/game/components/ball_component.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:flutter/material.dart';

class BallThemeUnlockDialog extends StatefulWidget {
  const BallThemeUnlockDialog({super.key, required this.biome});

  final BiomeModel biome;

  static Future<void> show(BuildContext context, BiomeModel biome) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'New ball colors unlocked',
      barrierColor: const Color(0xB3002745),
      transitionDuration: const Duration(milliseconds: 520),
      pageBuilder: (_, _, _) => BallThemeUnlockDialog(biome: biome),
      transitionBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.72, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<BallThemeUnlockDialog> createState() => _BallThemeUnlockDialogState();
}

class _BallThemeUnlockDialogState extends State<BallThemeUnlockDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biome = widget.biome;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final phase = _controller.value * math.pi * 2;
            return Container(
              width: math.min(MediaQuery.sizeOf(context).width * 0.86, 390),
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color.lerp(Colors.white, biome.secondaryColor, 0.16)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: biome.primaryColor.withValues(alpha: 0.48),
                    blurRadius: 28,
                    spreadRadius: 4,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < 8; i++)
                    Positioned(
                      left: 10 + (i * 41) % 300,
                      top: 45 + math.sin(phase + i) * 16 + (i.isOdd ? 65 : 0),
                      child: Transform.rotate(
                        angle: phase + i,
                        child: Icon(
                          i.isEven ? Icons.star_rounded : Icons.auto_awesome,
                          size: 12 + i % 3 * 3,
                          color:
                              (i.isEven
                                      ? biome.secondaryColor
                                      : biome.primaryColor)
                                  .withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: biome.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: biome.primaryColor.withValues(alpha: 0.35),
                              blurRadius: 9,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          'NEW BALL COLORS!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'CONGRATULATIONS!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF154D78),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        BiomeConfig.getSceneName(biome).toUpperCase(),
                        style: TextStyle(
                          color: biome.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Transform.translate(
                        offset: Offset(0, math.sin(phase) * 5),
                        child: Transform.rotate(
                          angle: math.sin(phase) * 0.08,
                          child: Container(
                            width: 112,
                            height: 112,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white,
                                  biome.secondaryColor.withValues(alpha: 0.22),
                                ],
                              ),
                              border: Border.all(
                                color: biome.secondaryColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: biome.secondaryColor.withValues(
                                    alpha: 0.38,
                                  ),
                                  blurRadius: 18,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: CustomPaint(
                              painter: BallPainter(biome: biome),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        'Your ball can now wear this world’s color theme.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF476779),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: biome.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 7,
                            shadowColor: biome.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Text(
                            'AWESOME!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
