import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balanco_game/features/game/components/game_area/heart_filled_painter.dart';
import 'package:balanco_game/features/game/components/game_area/broken_heart_painter.dart';
import 'package:balanco_game/features/game/components/game_area/star_filled_painter.dart';
import 'package:balanco_game/features/game/components/game_area/empty_star_painter.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/screens/victory/victory_painters.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

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
          height: 115, // Increased height slightly for the top space
          child: Stack(
            children: [
              // Hearts (Left)
              Positioned(
                left: 20,
                top: 65, // Lowered position
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
                top: 35, // Adjusted for the font size increase
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
                              color: GameColors.white,
                              fontSize: 28, // Increased font size
                              height: 1.0,
                              shadows: const [
                                Shadow(
                                  color: GameColors.headerDarkBrown,
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
                              color: GameColors.white,
                              fontSize: 48, // Increased font size
                              height: 1.0,
                              shadows: const [
                                Shadow(
                                  color: GameColors.headerDarkBrown,
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
                top: 65, // Lowered position
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

              // LEAVE (Top Left)
              Positioned(
                left: 20,
                top: -5,
                child: GestureDetector(
                  onTap: () {
                    game.pauseEngine();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => PopScope(
                        canPop: false,
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: CustomPaint(
                              painter: VictoryCardPainter(),
                              child: Container(
                                width: 320,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 36,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'LEAVE GAME?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.luckiestGuy(
                                        color: GameColors.headerBrown,
                                        fontSize: 32,
                                        letterSpacing: 2.0,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0, 3),
                                            color: GameColors.black26,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Are you sure you want to return to the lobby? Your progress will be lost!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.baloo2(
                                        color: const Color(
                                          0xFF5A3117,
                                        ), // Dark brown
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 36),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            game.resumeEngine();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: GameColors
                                                  .green300, // Green
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: GameColors.brownDarkUi,
                                                width: 3,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: GameColors.brownDarkUi,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'STAY',
                                              style: GoogleFonts.luckiestGuy(
                                                color: GameColors.white,
                                                fontSize: 22,
                                                shadows: const [
                                                  Shadow(
                                                    offset: Offset(0, 2),
                                                    color:
                                                        GameColors.brownDarkUi,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/',
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: GameColors.red300, // Red
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: GameColors.brownDarkUi,
                                                width: 3,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: GameColors.brownDarkUi,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'LEAVE',
                                              style: GoogleFonts.luckiestGuy(
                                                color: GameColors.white,
                                                fontSize: 22,
                                                shadows: const [
                                                  Shadow(
                                                    offset: Offset(0, 2),
                                                    color:
                                                        GameColors.brownDarkUi,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'LEAVE',
                      style: GoogleFonts.luckiestGuy(
                        color: const Color.fromARGB(255, 255, 92, 81),
                        fontSize: 28,
                        shadows: const [
                          Shadow(
                            color: Color.fromARGB(255, 52, 18, 18),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // TIMER (Top Right)
              Positioned(
                right: 20,
                top: -5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder<double>(
                    valueListenable: game.levelTimerNotifier,
                    builder: (context, time, child) {
                      int minutes = time.floor() ~/ 60;
                      int seconds = (time.floor() % 60);
                      String timeString =
                          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                      bool isCritical = time <= 10.0 && game.isLevelTimerActive;

                      return Text(
                        timeString,
                        style: GoogleFonts.luckiestGuy(
                          color: isCritical ? GameColors.red : GameColors.green,
                          fontSize: 28,
                          shadows: [
                            Shadow(
                              color: isCritical
                                  ? const Color.fromARGB(255, 64, 17, 14)
                                  : const Color.fromARGB(255, 25, 57, 26),
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
      width: 40,
      height: 40,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 45,
                height: 45,
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
                            GameColors.headerDarkBrown,
                            BlendMode.srcIn,
                          ),
                          child: CustomPaint(
                            size: const Size(45, 45),
                            painter: widget.isActive
                                ? widget.filledPainter
                                : widget.emptyPainter,
                          ),
                        ),
                      ),
                      // Actual painter
                      CustomPaint(
                        size: const Size(45, 45),
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
