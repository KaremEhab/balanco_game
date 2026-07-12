import 'dart:math' as math;

import 'package:balanco_game/features/game/components/ball_component.dart';
import 'package:balanco_game/features/game/components/game_area/collected_star_painter.dart';
import 'package:balanco_game/features/game/components/game_area/collected_heart_painter.dart';
import 'package:balanco_game/features/game/screens/game_controls_overlay.dart';
import 'package:balanco_game/features/map/components/map_hole_painter.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:flutter/material.dart';

enum _PreviewType { tilt, hole, stars, joystick, finish }

class _TutorialData {
  const _TutorialData({
    required this.title,
    required this.description,
    required this.tip,
    required this.reward,
    required this.difficulty,
    required this.accent,
    required this.preview,
  });

  final String title;
  final String description;
  final String tip;
  final String reward;
  final String difficulty;
  final Color accent;
  final _PreviewType preview;
}

const _tutorials = [
  _TutorialData(
    title: 'TILT THE PLATFORM',
    description: 'Move the platform gently to guide the ball left or right.',
    tip: 'Small controlled movements give you the best control.',
    reward: 'CORE SKILL',
    difficulty: 'EASY',
    accent: Color(0xFF0B9DD0),
    preview: _PreviewType.tilt,
  ),

  _TutorialData(
    title: 'DODGE OBSTACLES',
    description: 'Watch out for different hole types!',
    tip: 'Keep centered, watch the route, then move around it.',
    reward: '+10 PTS',
    difficulty: 'NORMAL',
    accent: Color(0xFFF05252),
    preview: _PreviewType.hole,
  ),
  _TutorialData(
    title: 'USE THE JOYSTICK',
    description: 'When given a joystick, drag to shoot or move.',
    tip: 'Drag around to aim and release to fire.',
    reward: 'SURVIVAL',
    difficulty: 'HARD',
    accent: Color(0xFFF09A00),
    preview: _PreviewType.joystick,
  ),
  _TutorialData(
    title: 'COLLECT THE STARS',
    description: 'Pick up stars along the route to build your level score.',
    tip: 'Only chase a star when your platform is stable.',
    reward: '+100 PTS',
    difficulty: 'EASY',
    accent: Color(0xFFF2A900),
    preview: _PreviewType.stars,
  ),
  _TutorialData(
    title: 'REACH THE FINISH',
    description:
        'Guide the ball safely into the final goal to clear the level.',
    tip: 'Slow down before the goal and line up your approach.',
    reward: '+500 PTS',
    difficulty: 'GOAL',
    accent: Color(0xFF26B968),
    preview: _PreviewType.finish,
  ),
];

class TutorialCarousel extends StatefulWidget {
  const TutorialCarousel({super.key});

  @override
  State<TutorialCarousel> createState() => _TutorialCarouselState();
}

class _TutorialCarouselState extends State<TutorialCarousel>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _previewController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.96);
    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    if (page < 0 || page >= _tutorials.length) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _tutorials.length,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
              _previewController.forward(from: 0);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 7,
                  ),
                  child: _TutorialCard(
                    data: _tutorials[index],
                    animation: _previewController,
                    page: index,
                    pageCount: _tutorials.length,
                    onPrevious: index == 0 ? null : () => _goTo(index - 1),
                    onNext: index == _tutorials.length - 1
                        ? null
                        : () => _goTo(index + 1),
                  ),
                ),
                builder: (context, child) {
                  var distance = 0.0;
                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    distance =
                        (_pageController.page ?? _currentPage.toDouble()) -
                        index;
                  }
                  final scale = (1 - distance.abs() * 0.055).clamp(0.92, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: (1 - distance.abs() * 0.25).clamp(0.65, 1.0),
                      child: child,
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _tutorials.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 7,
              width: index == _currentPage ? 22 : 7,
              decoration: BoxDecoration(
                color: index == _currentPage
                    ? _tutorials[_currentPage].accent
                    : Colors.white.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: const [
                  BoxShadow(color: Color(0x33004876), blurRadius: 4),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.data,
    required this.animation,
    required this.page,
    required this.pageCount,
    required this.onPrevious,
    required this.onNext,
  });

  final _TutorialData data;
  final Animation<double> animation;
  final int page;
  final int pageCount;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6F3FF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF1B64AC), width: 5.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF1B64AC),
            offset: Offset(0, 8),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0x33FFFFFF),
            offset: Offset(0, -5),
            blurRadius: 0,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Color(0x44000000),
            offset: Offset(0, 15),
            blurRadius: 15,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 320;
          return Padding(
            padding: EdgeInsets.fromLTRB(12, compact ? 9 : 12, 12, 9),
            child: Column(
              children: [
                Row(
                  children: [
                    _Badge(label: 'BASICS', color: data.accent),
                    const Spacer(),
                    Text(
                      '${page + 1} / $pageCount',
                      style: const TextStyle(
                        color: Color(0xFF648194),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: compact ? 5 : 7),
                Expanded(
                  flex: compact ? 4 : 5,
                  child: _TutorialPreview(
                    type: data.preview,
                    accent: data.accent,
                    animation: animation,
                  ),
                ),
                SizedBox(height: compact ? 5 : 7),
                Text(
                  data.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1267C8),
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.description,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF35576B),
                    fontSize: compact ? 9.5 : 10.5,
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF1B64AC),
                      width: 2.5,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF1B64AC), offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        size: 20,
                        color: data.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data.tip,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF1B64AC),
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 6 : 10),
                Row(
                  children: [
                    _ChunkyChip(
                      icon: Icons.star_rounded,
                      label: data.reward,
                      color: const Color(0xFFF2A900),
                    ),
                    const SizedBox(width: 6),
                    _ChunkyChip(
                      icon: Icons.speed_rounded,
                      label: data.difficulty,
                      color: data.accent,
                    ),
                    const Spacer(),
                    _ArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: onPrevious,
                    ),
                    const SizedBox(width: 6),
                    _ArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: onNext,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TutorialPreview extends StatelessWidget {
  const _TutorialPreview({
    required this.type,
    required this.accent,
    required this.animation,
  });

  final _PreviewType type;
  final Color accent;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFBCEFFF),
            accent.withValues(alpha: 0.12),
            const Color(0xFFFFE7A4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = animation.value;
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: _PreviewBackgroundPainter(progress: t)),
                  _buildMechanic(constraints.biggest, t),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMechanic(Size size, double t) {
    final wave = math.sin(t * math.pi * 2);
    final ball = SizedBox(
      width: 42,
      height: 43,
      child: CustomPaint(
        painter: BallPainter(biome: BiomeConfig.tropicalBeach),
      ),
    );

    switch (type) {
      case _PreviewType.tilt:
        final angle = wave * 0.12;
        return Stack(
          children: [
            Positioned(
              left: size.width / 2 - 72,
              bottom: size.height * 0.22,
              child: Transform.rotate(
                angle: angle,
                child: const _PreviewPlatform(width: 144),
              ),
            ),
            Positioned(
              left: size.width / 2 - 21 + wave * 32,
              bottom: size.height * 0.22 + 15 - wave.abs() * 3,
              child: ball,
            ),
          ],
        );

      case _PreviewType.hole:
        final holePainter = MapHolePainter(
          isUnlocked: true,
          biome: BiomeConfig.tropicalBeach,
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Static Hole
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CustomPaint(
                      painter: MapHolePainter(
                        isUnlocked: true,
                        biome: BiomeConfig.tropicalBeach,
                        teethClosure:
                            (math.sin(t * math.pi * 2) + 1) / 2 * 0.25,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Moving Hole
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(math.sin(t * math.pi * 2) * 12, 0),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CustomPaint(painter: holePainter),
                    ),
                  ),
                ),
              ),
            ),
            // Orbiting Hole
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(
                            math.cos(t * math.pi * 2) * 14,
                            math.sin(t * math.pi * 2) * 14,
                          ),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CustomPaint(painter: holePainter),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                            math.cos(t * math.pi * 2 + math.pi) * 14,
                            math.sin(t * math.pi * 2 + math.pi) * 14,
                          ),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CustomPaint(painter: holePainter),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Splitting Hole
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(
                            math.max(0.0, math.sin(t * math.pi * 2)) * 14,
                            0,
                          ),
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CustomPaint(painter: holePainter),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(
                            math.max(0.0, math.sin(t * math.pi * 2)) * -14,
                            0,
                          ),
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CustomPaint(painter: holePainter),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Vortex Hole
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        Builder(
                          builder: (context) {
                            final fract = ((t * 3 - i) % 3) / 3;
                            return Transform.scale(
                              scale: 1.0 + (1.0 - fract) * 1.5,
                              child: Opacity(
                                opacity: math.max(
                                  0.0,
                                  math.sin(fract * math.pi),
                                ),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: GameColors.cyanAccent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CustomPaint(painter: holePainter),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      case _PreviewType.stars:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CustomPaint(painter: CollectedStarPainter()),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Transform.scale(
                  scale: 0.9,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CustomPaint(painter: CollectedHeartPainter()),
                  ),
                ),
              ),
            ),
          ],
        );
      case _PreviewType.joystick:
        return Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'LEFT HAND',
                    style: TextStyle(
                      color: Color(0xFF1B64AC),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: VerticalJoystick(
                      isLeft: true,
                      biome: BiomeConfig.tropicalBeach,
                      onChanged: (_) {},
                      externalValue: math.sin(t * math.pi * 2) * 32.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(width: 3, color: Colors.white),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'RIGHT HAND',
                    style: TextStyle(
                      color: Color(0xFF1B64AC),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: VerticalJoystick(
                      isLeft: false,
                      biome: BiomeConfig.tropicalBeach,
                      onChanged: (_) {},
                      externalValue: math.sin(t * math.pi * 2 + math.pi) * 32.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case _PreviewType.finish:
        final approach = Curves.easeInOut.transform(t);
        return Stack(
          children: [
            Positioned(
              right: size.width * 0.15,
              bottom: size.height * 0.12,
              width: 65,
              height: 65,
              child: CustomPaint(
                painter: _FinishGatePreviewPainter(time: t * 10),
              ),
            ),
            Positioned(
              left: size.width * (0.08 + approach * 0.58),
              bottom: size.height * (0.45 - approach * 0.2),
              child: Transform.scale(
                scale: 1 - approach * 0.28,
                child: Opacity(opacity: 1 - approach * 0.65, child: ball),
              ),
            ),
            if (t > 0.76)
              Positioned(
                top: 7,
                left: size.width / 2 - 28,
                child: const _SuccessLabel(label: 'LEVEL CLEAR!'),
              ),
          ],
        );
    }
  }
}

class _PreviewPlatform extends StatelessWidget {
  const _PreviewPlatform({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD87B), Color(0xFFE99B3D), Color(0xFF9C511F)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55004A71),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _SuccessLabel extends StatelessWidget {
  const _SuccessLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xE52AC970),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _PreviewBackgroundPainter extends CustomPainter {
  const _PreviewBackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final wave = Path()..moveTo(0, size.height * 0.76);
    for (var x = 0.0; x <= size.width; x += 8) {
      final y =
          size.height * 0.76 +
          math.sin((x / size.width * math.pi * 3) + progress * math.pi * 2) * 3;
      wave.lineTo(x, y);
    }
    wave
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(wave, Paint()..color = const Color(0x55FFFFFF));
  }

  @override
  bool shouldRepaint(_PreviewBackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.8),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        'BASICS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ChunkyChip extends StatelessWidget {
  const _ChunkyChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: onTap == null
            ? const Color(0xFFE0EBF0)
            : const Color(0xFF177FC2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: onTap == null
              ? const Color(0xFFB1C4CE)
              : const Color(0xFF1B64AC),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: onTap == null
                ? const Color(0xFFB1C4CE)
                : const Color(0xFF1B64AC),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 27,
            height: 25,
            child: Icon(
              icon,
              size: 19,
              color: onTap == null ? const Color(0xFF9DB0BA) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _FinishGatePreviewPainter extends CustomPainter {
  const _FinishGatePreviewPainter({required this.time});
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(0.9); // Scale down slightly to fit the container comfortably

    // Draw glowing shadow around the gate
    for (int i = 6; i >= 0; i--) {
      final Paint glowPaint = Paint()
        ..color = GameColors.teleporterLightPurple.withValues(
          alpha: 0.02 + (6 - i) * 0.05,
        )
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 36 + i * 2.5, glowPaint);
    }

    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 36)),
    );

    final Paint basePaint = Paint()
      ..color = GameColors.teleporterVeryLightPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 36, basePaint);

    int numCircles = 14;
    List<double> phases = List.generate(
      numCircles,
      (i) => ((i / numCircles) - (time * 0.4)) % 1.0,
    );
    phases.sort((a, b) => b.compareTo(a));

    for (double phase in phases) {
      if (phase < 0) continue;
      double r = phase * 36.0;

      Color c;
      if (phase > 0.5) {
        c = Color.lerp(
          GameColors.teleporterDeepPurple,
          GameColors.teleporterVeryLightPurple,
          (phase - 0.5) * 2,
        )!;
      } else {
        c = Color.lerp(
          GameColors.teleporterDarkBg,
          GameColors.teleporterDeepPurple,
          phase * 2,
        )!;
      }

      final Paint circlePaint = Paint()
        ..color = c
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset.zero, r, circlePaint);

      final Paint strokePaint = Paint()
        ..color = GameColors.black.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(Offset.zero, r, strokePaint);

      final Paint highlightPaint = Paint()
        ..color = GameColors.white.withValues(alpha: 0.1 * phase)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(const Offset(0, -1), r, highlightPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_FinishGatePreviewPainter oldDelegate) =>
      oldDelegate.time != time;
}
