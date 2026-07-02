import 'dart:ui';

import 'package:balanco_game/features/map/components/gem_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';
import 'package:balanco_game/features/settings/screens/profile_dialog.dart';
import 'package:balanco_game/features/game/components/game_area/collected_star_painter.dart';

class MapAppBar extends StatelessWidget {
  final int highestLevel;
  final int coins;
  final int sparks;
  final int maxSparks;

  const MapAppBar({
    super.key,
    required this.highestLevel,
    required this.coins,
    required this.sparks,
    this.maxSparks = 5,
  });

  Widget _buildStrokedText(
    String text, {
    required double fontSize,
    required Color textColor,
    required Color strokeColor,
    required Color shadowColor,
  }) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.luckiestGuy(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = strokeColor,
            shadows: [Shadow(color: shadowColor, offset: const Offset(0, 4))],
          ),
        ),
        Text(
          text,
          style: GoogleFonts.luckiestGuy(fontSize: fontSize, color: textColor),
        ),
      ],
    );
  }

  Widget _buildStrokedSvg(
    String assetName, {
    required double width,
    required double height,
    required Color strokeColor,
    required Color shadowColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Shadow
        Positioned(
          left: 0,
          top: 4,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(shadowColor, BlendMode.srcIn),
          ),
        ),
        // Stroke
        Positioned(
          left: -2,
          top: 0,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: 2,
          top: 0,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: 0,
          top: -2,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        Positioned(
          left: 0,
          top: 2,
          child: SvgPicture.asset(
            assetName,
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(strokeColor, BlendMode.srcIn),
          ),
        ),
        // Original
        SvgPicture.asset(assetName, width: width, height: height),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(
              0xFF6DE8F8,
            ).withValues(alpha: 0.4), // Light blue semi-transparent HUD bar
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Side: Avatar + Name + Level/Coins
              Expanded(
                child: Row(
                  children: [
                    // Game Style Profile Avatar with Diamond overlay
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showProfileDialog(
                              context,
                              name: 'KAREEM EHAB',
                              level: highestLevel,
                              coins: coins,
                              sparks: sparks,
                            );
                          },
                          child: ValueListenableBuilder<AvatarShape>(
                            valueListenable: currentAvatarShapeNotifier,
                            builder: (context, shape, _) {
                              return ValueListenableBuilder<String>(
                                valueListenable: currentAvatarUrlNotifier,
                                builder: (context, url, _) {
                                  return ProfileAvatarWidget(
                                    shape: shape,
                                    size: 55,
                                    imageUrl: url,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // The Diamond Overlay
                        Positioned(
                          bottom: -8,
                          child: SizedBox(
                            // Adjust width and height here to scale the gem up or down
                            width: 26,
                            height: 26,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width:
                                    22, // The original path size from your painter
                                height: 22,
                                child: CustomPaint(painter: GemPainter()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Name
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: _buildStrokedText(
                              'KAREEM EHAB',
                              fontSize: 17,
                              textColor: const Color(0xFFFFFBF6),
                              strokeColor: const Color.fromARGB(
                                255,
                                104,
                                77,
                                30,
                              ),
                              shadowColor: const Color(0xFF513A13),
                            ),
                          ),
                          // LVL and Coins Pills
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                // LVL Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFFD09B,
                                    ), // Light wood/tan color
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 104, 77, 30),
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFF513A13),
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: _buildStrokedText(
                                    'LVL $highestLevel',
                                    fontSize: 12,
                                    textColor: const Color(0xFFFFFBF6),
                                    strokeColor: Color.fromARGB(
                                      255,
                                      104,
                                      77,
                                      30,
                                    ),
                                    shadowColor: const Color(0xFF513A13),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                // Coins Pill
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 4,
                                        bottom: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD09B),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Color.fromARGB(
                                            255,
                                            104,
                                            77,
                                            30,
                                          ),
                                          width: 2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFF513A13),
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: _buildStrokedText(
                                        coins >= 1000
                                            ? '${(coins / 1000).toStringAsFixed(1)}K'
                                            : coins.toString(),
                                        fontSize: 14,
                                        textColor: const Color(0xFFFFFBF6),
                                        strokeColor: Color.fromARGB(
                                          255,
                                          104,
                                          77,
                                          30,
                                        ),
                                        shadowColor: const Color(0xFF513A13),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: SvgPicture.asset(
                                        'assets/images/add-button.svg',
                                        width: 23,
                                        height: 23,
                                      ),
                                    ),
                                    Positioned(
                                      right: -6,
                                      top: 1,
                                      child: SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: CustomPaint(
                                              painter: CollectedStarPainter(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Right Side: Sparks
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 16,
                      top: 6,
                      bottom: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF77F9E1), Color(0xFF4AACC2)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color.fromARGB(255, 55, 100, 141),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF1A4647),
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        _buildStrokedSvg(
                          'assets/images/Spark-icon.svg',
                          width: 23,
                          height: 23,
                          strokeColor: const Color.fromARGB(255, 55, 100, 141),
                          shadowColor: const Color(0xFF1A4647),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            _buildStrokedText(
                              '$sparks',
                              fontSize: 22,
                              textColor: const Color(0xFFFFFBF6),
                              strokeColor: const Color.fromARGB(
                                255,
                                55,
                                100,
                                141,
                              ),
                              shadowColor: const Color(0xFF1A4647),
                            ),
                            _buildStrokedText(
                              '/$maxSparks',
                              fontSize: 13,
                              textColor: const Color(0xFFFFFBF6),
                              strokeColor: const Color.fromARGB(
                                255,
                                55,
                                100,
                                141,
                              ),
                              shadowColor: const Color(0xFF1A4647),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: SvgPicture.asset(
                      'assets/images/add-button.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
