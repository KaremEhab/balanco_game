import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../game/components/game_area/empty_card_painter.dart';
import '../../game/components/game_area/heart_filled_painter.dart';
import '../../game/components/game_area/broken_heart_painter.dart';
import '../../game/components/game_area/star_filled_painter.dart';
import '../../game/components/game_area/empty_star_painter.dart';
import '../../game/components/game_area/coin_painter.dart';
import '../../game/game_area.dart';

class GameplayHeader extends StatelessWidget {
  final BalancoGame game;
  final List<Color> cardBaseGradient;
  final List<Color> cardHighlightGradient;

  const GameplayHeader({
    super.key,
    required this.game,
    required this.cardBaseGradient,
    required this.cardHighlightGradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: SizedBox(
          width: 411,
          height: 105, // Increased height slightly for the top space
          child: Stack(
            children: [
              // Hearts (Left)
              Positioned(
                left: 20,
                top: 63, // Lowered position
                child: ValueListenableBuilder<int>(
                  valueListenable: game.currentLives,
                  builder: (context, lives, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: AnimatedGameStatSlot(
                            isActive: index < lives,
                            filledPainter: HeartFilledPainter(),
                            emptyPainter: BrokenHeartPainter(),
                            shadowOffset: const Offset(
                              -3,
                              3,
                            ), // Heart shadow offset
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              // Center Text
              Positioned(
                top: 30, // Adjusted for the font size increase
                left: 0,
                right: 0,
                child: Center(
                  child: ValueListenableBuilder<int>(
                    valueListenable: game.currentLevel,
                    builder: (context, level, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LEVEL',
                            style: GoogleFonts.luckiestGuy(
                              color: Colors.white,
                              fontSize: 28, // Increased font size
                              height: 1.0,
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF8D5800),
                                  offset: Offset(0, 3),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$level',
                            style: GoogleFonts.luckiestGuy(
                              color: Colors.white,
                              fontSize: 42, // Increased font size
                              height: 1.0,
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF8D5800),
                                  offset: Offset(0, 4),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Stars (Right)
              Positioned(
                right: 20,
                top: 63, // Lowered position
                child: ValueListenableBuilder<int>(
                  valueListenable: game.currentPoints,
                  builder: (context, stars, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: AnimatedGameStatSlot(
                            isActive: (2 - index) < stars,
                            filledPainter: StarFilledPainter(),
                            emptyPainter: EmptyStarPainter(),
                            shadowOffset: const Offset(
                              3,
                              3,
                            ), // Star shadow offset
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              // Score (Top Right)
              Positioned(
                right: 35,
                top: 15,
                child: ValueListenableBuilder<int>(
                  valueListenable: game.currentScore,
                  builder: (context, score, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Coin Icon
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CustomPaint(painter: CoinPainter()),
                        ),
                        const SizedBox(width: 8),
                        // Score Text
                        Text(
                          '$score',
                          style: GoogleFonts.luckiestGuy(
                            color: Colors.white,
                            fontSize: 24,
                            height: 1.0,
                            shadows: const [
                              Shadow(
                                color: Color(0xFF8D5800),
                                offset: Offset(0, 3),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedGameStatSlot extends StatefulWidget {
  final bool isActive;
  final CustomPainter filledPainter;
  final CustomPainter emptyPainter;
  final Offset shadowOffset;

  const AnimatedGameStatSlot({
    super.key,
    required this.isActive,
    required this.filledPainter,
    required this.emptyPainter,
    required this.shadowOffset,
  });

  @override
  State<AnimatedGameStatSlot> createState() => _AnimatedGameStatSlotState();
}

class _AnimatedGameStatSlotState extends State<AnimatedGameStatSlot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _previousIsActive;

  @override
  void initState() {
    super.initState();
    _previousIsActive = widget.isActive;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedGameStatSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != _previousIsActive) {
      if (widget.isActive) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse(
          from: 1.0,
        ); // reverse animation for losing life/star
      }
      _previousIsActive = widget.isActive;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 35,
                height: 35,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: Stack(
                    key: ValueKey<bool>(widget.isActive),
                    children: [
                      // Hard shadow using silhouette of the exact painter shape
                      Transform.translate(
                        offset: widget.shadowOffset,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF8D5800),
                            BlendMode.srcIn,
                          ),
                          child: CustomPaint(
                            size: const Size(35, 35),
                            painter: widget.isActive
                                ? widget.filledPainter
                                : widget.emptyPainter,
                          ),
                        ),
                      ),
                      // Actual painter
                      CustomPaint(
                        size: const Size(35, 35),
                        painter: widget.isActive
                            ? widget.filledPainter
                            : widget.emptyPainter,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
