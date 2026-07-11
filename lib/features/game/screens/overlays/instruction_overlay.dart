import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/map/components/map_hole_painter.dart';

class InstructionOverlay extends StatefulWidget {
  final BalancoGame game;
  final String tutorialId;
  const InstructionOverlay({
    super.key,
    required this.game,
    required this.tutorialId,
  });

  @override
  State<InstructionOverlay> createState() => _InstructionOverlayState();
}

class _InstructionOverlayState extends State<InstructionOverlay>
    with TickerProviderStateMixin {
  late AnimationController _appearController;
  late Animation<double> _scaleAnim;

  late AnimationController _loopController;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _appearController,
      curve: Curves.elasticOut,
    );
    _appearController.forward();

    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _appearController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getTutorialContent() {
    switch (widget.tutorialId) {
      case 'bomb':
        return {
          'title': 'WATCH OUT!',
          'desc':
              'Bombs will drop from above! Evade them or they will destroy your ball and cost you a life!',
          'points': '+0 pts',
          'color': GameColors.redAccent,
        };
      case 'hole':
        return {
          'title': 'THE HOLE',
          'desc':
              'A standard wooden hole. Do not fall into it or you will lose a life!',
          'points': '+3 pts if avoided',
          'color': GameColors.brownDarkUi,
        };
      case 'sucking_hole':
        return {
          'title': 'WIND HOLE',
          'desc':
              'It generates a strong wind that pulls you in. Keep your distance!',
          'points': '+10 pts if avoided',
          'color': GameColors.cyanAccent,
        };
      case 'moving_hole':
        return {
          'title': 'MOVING HOLE',
          'desc': 'This tricky hole moves side to side. Timing is key!',
          'points': '+20 pts if avoided',
          'color': GameColors.purpleAccent,
        };
      case 'bumper':
        return {
          'title': 'BUMPER',
          'desc':
              'Bounce off these to gain points, but beware of the unpredictable trajectory!',
          'points': '+5 pts',
          'color': GameColors.blueGrey,
        };
      case 'teleporter':
        return {
          'title': 'TELEPORTER',
          'desc':
              'Go in one side and come out the other! Great for quick escapes.',
          'points': '+0 pts',
          'color': GameColors.indigo,
        };
      case 'magnet':
        return {
          'title': 'MAGNET POWER',
          'desc':
              'Attracts nearby coins and stars automatically for a limited time!',
          'points': '+0 pts',
          'color': GameColors.amber,
        };
      case 'heart':
        return {
          'title': 'EXTRA LIFE',
          'desc': 'Collect this to gain an extra life. Essential for survival!',
          'points': '+0 pts',
          'color': GameColors.redAccent,
        };
      case 'multi_ball':
        return {
          'title': 'MULTI-BALL',
          'desc':
              'Splits your ball into two! Double the fun, double the danger!',
          'points': '+0 pts',
          'color': GameColors.purpleAccent,
        };
      case 'infinity_mode':
        return {
          'title': 'INFINITY MODE',
          'desc':
              'Survive as long as possible! Collect stars to boost your score multiplier and use power-ups wisely.',
          'points': 'ENDLESS FUN',
          'color': GameColors.goldenYellow,
        };
      case 'joysticks':
        return {
          'title': 'HOW TO MOVE',
          'desc':
              'Use the Left and Right joysticks to tilt the wooden bar up and down. Balance the ball!',
          'points': 'TILT TO SURVIVE',
          'color': GameColors.orange,
        };
      case 'shield':
        return {
          'title': 'SHIELD POWER',
          'desc':
              'Press the shield button at the bottom to become invincible for 5 seconds!',
          'points': 'BLOCKS 1 HIT',
          'color': GameColors.mapAppBarCyanLight,
        };
      case 'scrolling_level':
        return {
          'title': 'LONG LEVEL',
          'desc':
              'This level is super long! The camera will follow your ball. Maintain your balance and plan your path carefully.',
          'points': 'STAY ON TRACK',
          'color': GameColors.amber,
        };
      default:
        return {
          'title': 'NEW OBSTACLE',
          'desc': 'Watch out for this new mechanic!',
          'points': '+? pts',
          'color': GameColors.orange,
        };
    }
  }

  Widget _buildAnimatedGraphic(Map<String, dynamic> content) {
    return AnimatedBuilder(
      animation: _loopController,
      builder: (context, child) {
        double t = _loopController.value; // 0.0 to 1.0 over 2.5 seconds

        Widget graphic;
        switch (widget.tutorialId) {
          case 'bomb':
            double dy = (t * 2.0 % 1.0) * 80 - 40;
            graphic = Transform.translate(
              offset: Offset(0, dy),
              child: const Icon(
                Icons.whatshot_rounded,
                size: 64,
                color: GameColors.redAccent,
              ),
            );
            break;
          case 'hole':
            graphic = CustomPaint(
              size: const Size(70, 70),
              painter: MapHolePainter(
                isUnlocked: true,
                biome: widget.game.currentBiome,
              ),
            );
            break;
          case 'sucking_hole':
            graphic = Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(70, 70),
                  painter: MapHolePainter(
                    isUnlocked: true,
                    biome: widget.game.currentBiome,
                  ),
                ),
                Transform.rotate(
                  angle: t * 4 * math.pi,
                  child: const Icon(
                    Icons.air,
                    size: 40,
                    color: GameColors.cyanAccent,
                  ),
                ),
              ],
            );
            break;
          case 'scrolling_level':
            graphic = Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.map, size: 60, color: GameColors.brown),
                Transform.translate(
                  offset: Offset(0, (t * 2.0 % 1.0) * 20 - 10),
                  child: const Icon(
                    Icons.circle,
                    size: 20,
                    color: GameColors.blueAccent,
                  ),
                ),
              ],
            );
            break;
          case 'moving_hole':
            double dx = math.sin(t * 2 * math.pi) * 30;
            graphic = Transform.translate(
              offset: Offset(dx, 0),
              child: CustomPaint(
                size: const Size(70, 70),
                painter: MapHolePainter(
                  isUnlocked: true,
                  biome: widget.game.currentBiome,
                ),
              ),
            );
            break;
          case 'bumper':
            double scale = 1.0 + math.sin(t * 4 * math.pi) * 0.15;
            graphic = Transform.scale(
              scale: scale,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [GameColors.orange, GameColors.redAccent],
                  ),
                  border: Border.all(color: GameColors.white, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: GameColors.black54,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            );
            break;
          case 'teleporter':
            graphic = Transform.rotate(
              angle: t * 2 * math.pi,
              child: const Icon(Icons.sync, size: 70, color: GameColors.indigo),
            );
            break;
          case 'magnet':
            graphic = Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.flash_on_rounded,
                  size: 64,
                  color: GameColors.amber,
                ),
                ...List.generate(3, (index) {
                  double progress = (t + index / 3.0) % 1.0;
                  double dist = 50 * (1.0 - progress);
                  double angle = index * (2 * math.pi / 3) + t * math.pi;
                  return Transform.translate(
                    offset: Offset(
                      math.cos(angle) * dist,
                      math.sin(angle) * dist,
                    ),
                    child: Opacity(
                      opacity: progress < 0.2 ? progress * 5 : (1.0 - progress),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: GameColors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
            break;
          case 'heart':
            double hScale = 1.0 + math.sin(t * math.pi * 6).abs() * 0.2;
            graphic = Transform.scale(
              scale: hScale,
              child: const Icon(
                Icons.favorite_rounded,
                size: 64,
                color: GameColors.redAccent,
              ),
            );
            break;
          case 'multi_ball':
            double splitDist = (1.0 - math.cos(t * 2 * math.pi)) * 20;
            graphic = Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-splitDist, 0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: GameColors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: GameColors.black, width: 2),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(splitDist, 0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: GameColors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: GameColors.black, width: 2),
                    ),
                  ),
                ),
              ],
            );
            break;
          case 'infinity_mode':
            double infScale = 1.0 + math.sin(t * 2 * math.pi) * 0.2;
            graphic = Transform.scale(
              scale: infScale,
              child: const Icon(
                Icons.all_inclusive_rounded,
                size: 70,
                color: GameColors.goldenYellow,
              ),
            );
            break;
          case 'joysticks':
            double tilt = math.sin(t * 2 * math.pi) * 0.4;
            graphic = Transform.rotate(
              angle: tilt,
              child: Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: GameColors.brownDarkUi,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: GameColors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
            break;
          case 'shield':
            double shieldScale = 1.0 + math.sin(t * 4 * math.pi).abs() * 0.15;
            graphic = Transform.scale(
              scale: shieldScale,
              child: const Icon(
                Icons.security_rounded,
                size: 64,
                color: GameColors.mapAppBarCyanLight,
              ),
            );
            break;
          default:
            graphic = const Icon(
              Icons.help_outline_rounded,
              size: 64,
              color: GameColors.orange,
            );
        }

        return Container(
          width: 130,
          height: 130,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: content['color'].withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: content['color'].withValues(alpha: 0.8),
              width: 3,
            ),
          ),
          child: graphic,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _getTutorialContent();

    return Material(
      color: Colors.transparent,
      child: Container(
        color: GameColors.blackSolid.withValues(alpha: 0.8),
        alignment: Alignment.center,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: GameColors.sandLightUi,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: GameColors.brownDarkUi, width: 4),
              boxShadow: [
                BoxShadow(
                  color: GameColors.blackSolid.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedGraphic(content),
                const SizedBox(height: 24),
                Text(
                  content['title'],
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 34,
                    color: GameColors.brownDarkUi,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  content['desc'],
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GameColors.brownDarkUi.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: GameColors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GameColors.green, width: 2),
                  ),
                  child: Text(
                    content['points'],
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 18,
                      color: GameColors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () {
                    _appearController.reverse().then((_) {
                      widget.game.closeTutorial();
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: GameColors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: GameColors.mapAppBarGreenAccent,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'GOT IT!',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 24,
                        color: GameColors.whiteSolid,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
