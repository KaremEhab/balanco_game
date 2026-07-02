import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';

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
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3A6073),
                  Color(0xFF16222A),
                ], // Elegant blue/dark gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFFFFD700),
                width: 4,
              ), // Gold rim
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.3), // Gold glow
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
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
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF5F6D),
                            Color(0xFFFFC371),
                          ], // Warm red/orange gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
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
                      textColor: Colors.white,
                      strokeColor: Colors.black87,
                    ),
                    const SizedBox(height: 10),

                    // Stats Row Container
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatBadge(
                            icon: Icons.star_rounded,
                            color: Colors.amber,
                            value: 'LVL $level',
                          ),
                          _StatBadge(
                            icon: Icons.monetization_on_rounded,
                            color: Colors.yellow,
                            value: '$coins',
                          ),
                          _StatBadge(
                            icon: Icons.bolt_rounded,
                            color: Colors.lightBlueAccent,
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
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildStrokedText(
                            'Choose Shape',
                            fontSize: 18,
                            textColor: Colors.white70,
                            strokeColor: Colors.black54,
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
                                                    ? Colors.white30
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(0xFFFFD700)
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
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildStrokedText(
                            'Choose Avatar',
                            fontSize: 18,
                            textColor: Colors.white70,
                            strokeColor: Colors.black54,
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
                                                    ? Colors.white30
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? const Color(0xFFFFD700)
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
  final IconData icon;
  final Color color;
  final String value;

  const _StatBadge({
    required this.icon,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.luckiestGuy(
            fontSize: 18,
            color: Colors.white,
            shadows: [
              const Shadow(color: Colors.black54, offset: Offset(0, 2)),
            ],
          ),
        ),
      ],
    );
  }
}
