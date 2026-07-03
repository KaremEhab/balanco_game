import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';
import 'package:balanco_game/features/game/components/game_area/star_filled_painter.dart';

void showProfileDialog(
  BuildContext context, {
  required String name,
  required int level,
  required int coins,
  required int sparks,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ProfileDialog(
        name: name,
        level: level,
        coins: coins,
        sparks: sparks,
      );
    },
  );
}

class ProfileDialog extends StatelessWidget {
  final String name;
  final int level;
  final int coins;
  final int sparks;

  const ProfileDialog({
    super.key,
    required this.name,
    required this.level,
    required this.coins,
    required this.sparks,
  });

  Widget _buildStrokedText(
    String text, {
    required double fontSize,
    required Color textColor,
    required Color strokeColor,
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
          ),
        ),
        Text(
          text,
          style: GoogleFonts.luckiestGuy(fontSize: fontSize, color: textColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7), // Light sand color
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF3E2723), // Dark brown outline
                width: 3.5,
              ),
              boxShadow: const [
                BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 6)),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Top Right Close Button
                Positioned(
                  top: -10,
                  right: -10,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF44336), // Solid red
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF3E2723), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF3E2723),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),

                    // Big Avatar
                    ValueListenableBuilder<AvatarShape>(
                      valueListenable: currentAvatarShapeNotifier,
                      builder: (context, shape, _) {
                        return ValueListenableBuilder<String>(
                          valueListenable: currentAvatarUrlNotifier,
                          builder: (context, url, _) {
                            return ProfileAvatarWidget(
                              shape: shape,
                              size: 100,
                              imageUrl: url,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Player Name
                    _buildStrokedText(
                      name,
                      fontSize: 28,
                      textColor: const Color(0xFFFFB74D),
                      strokeColor: const Color(0xFF3E2723),
                    ),
                    const SizedBox(height: 10),

                    // Stats Row Container
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E2723).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF3E2723).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatBadge(
                            iconWidget: const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 30,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF3E2723),
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            value: 'LVL $level',
                          ),
                          _StatBadge(
                            iconWidget: SizedBox(
                              width: 30,
                              height: 30,
                              child: CustomPaint(painter: StarFilledPainter()),
                            ),
                            value: '$coins',
                          ),
                          _StatBadge(
                            iconWidget: const Icon(
                              Icons.bolt_rounded,
                              color: Colors.lightBlueAccent,
                              size: 30,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF3E2723),
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            value: '$sparks',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Shape Selector Container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E2723).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF3E2723).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildStrokedText(
                            'Choose Shape',
                            fontSize: 18,
                            textColor: const Color(0xFFFFB74D),
                            strokeColor: const Color(0xFF3E2723),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: AvatarShape.values.map((shape) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      currentAvatarShapeNotifier.value = shape;
                                    },
                                    child: ValueListenableBuilder<AvatarShape>(
                                      valueListenable:
                                          currentAvatarShapeNotifier,
                                      builder: (context, currentShape, _) {
                                        final isSelected =
                                            currentShape == shape;
                                        return ValueListenableBuilder<String>(
                                          valueListenable:
                                              currentAvatarUrlNotifier,
                                          builder: (context, currentUrl, _) {
                                            return Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? const Color(0xFF3E2723).withValues(alpha: 0.15)
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(0xFF3E2723)
                                                      : Colors.transparent,
                                                  width: 3,
                                                ),
                                              ),
                                              child: ProfileAvatarWidget(
                                                shape: shape,
                                                size: 45,
                                                imageUrl: currentUrl,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Avatar Selector Container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E2723).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF3E2723).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildStrokedText(
                            'Choose Avatar',
                            fontSize: 18,
                            textColor: const Color(0xFFFFB74D),
                            strokeColor: const Color(0xFF3E2723),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  [
                                    'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=BalancoHero&skinColor=f2d3b1&backgroundColor=transparent',
                                    'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=Felix&skinColor=ecbcb4&backgroundColor=transparent',
                                    'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=Aneka&skinColor=e5a07e&backgroundColor=transparent',
                                    'https://api.dicebear.com/9.x/adventurer-neutral/png?seed=Oliver&skinColor=ae5d29&backgroundColor=transparent',
                                  ].map((url) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          currentAvatarUrlNotifier.value = url;
                                        },
                                        child: ValueListenableBuilder<String>(
                                          valueListenable:
                                              currentAvatarUrlNotifier,
                                          builder: (context, currentUrl, _) {
                                            final isSelected =
                                                currentUrl == url;
                                            return Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? const Color(0xFF3E2723).withValues(alpha: 0.15)
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(0xFF3E2723)
                                                      : Colors.transparent,
                                                  width: 3,
                                                ),
                                              ),
                                              // Display simple circle avatars for the selector
                                              child: ProfileAvatarWidget(
                                                shape: AvatarShape.circle,
                                                size: 45,
                                                imageUrl: url,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final Widget iconWidget;
  final String value;

  const _StatBadge({
    required this.iconWidget,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        iconWidget,
        const SizedBox(height: 4),
        Stack(
          children: [
            Text(
              value,
              style: GoogleFonts.luckiestGuy(
                fontSize: 18,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = const Color(0xFF3E2723),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.luckiestGuy(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
