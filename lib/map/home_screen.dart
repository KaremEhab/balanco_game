import 'dart:math';
import 'dart:ui';
import 'package:balanco_game/screens/gameplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/database_helper.dart';
import '../bloc/app_bloc.dart';
import '../game/game_area.dart';
import '../screens/home/level_button_painter.dart';
import '../screens/home/wooden_route_painter.dart';
import '../screens/home/locked_level_painter.dart';
import '../screens/home/map_hole_painter.dart';
import 'theme/map_theme.dart';
import 'theme/themes/beach_map_theme.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({super.key, required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int totalLevels = 50;
  final double nodeSpacingY =
      140.0; // Ensures integer division perfectly spaces them (multiple of 20)
  final double bottomPadding = 120.0;
  final double topPadding = 160.0;

  int highestLevel = 1;
  int currentLevel = 1;
  int _displayedLevel = 1;

  late MapTheme theme;
  final List<Offset> _nodePositions = [];

  @override
  void initState() {
    super.initState();
    theme = BeachMapTheme(); // Use the new theme system!
    widget.scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    double scrollOffset = widget.scrollController.offset;
    double screenHeight = MediaQuery.of(context).size.height;
    double totalHeight = _getVirtualHeight();

    double rawLevel =
        1 +
        (totalHeight - bottomPadding - scrollOffset - (screenHeight * 0.6)) /
            nodeSpacingY;
    int calculatedLevel = rawLevel.round().clamp(1, totalLevels);

    if (calculatedLevel != _displayedLevel) {
      setState(() {
        _displayedLevel = calculatedLevel;
      });
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _loadData() async {
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    if (!mounted) return;
    setState(() {
      highestLevel = profile.highestLevel;
      currentLevel = profile.lastPlayedLevel;
      _displayedLevel = currentLevel;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  void _scrollToCurrentLevel() {
    if (widget.scrollController.hasClients && _nodePositions.isNotEmpty) {
      // Find the Y position of the current level
      int index = currentLevel - 1;
      if (index >= 0 && index < _nodePositions.length) {
        double yPos = _nodePositions[index].dy;
        // Scroll so the node is roughly in the middle/lower third of the screen
        double screenHeight = MediaQuery.of(context).size.height;
        double targetScroll = yPos - (screenHeight * 0.6);
        widget.scrollController.jumpTo(
          targetScroll.clamp(
            0.0,
            widget.scrollController.position.maxScrollExtent,
          ),
        );
      }
    }
  }

  void _calculateNodes(double screenWidth) {
    _nodePositions.clear();
    double totalHeight = _getVirtualHeight();

    double centerX = screenWidth / 2;

    for (int i = 0; i < totalLevels; i++) {
      // Y goes from bottom to top
      double rawY = totalHeight - bottomPadding - (i * nodeSpacingY);

      // Align perfectly to the center of the wooden plank (plank height 16, gap 4 -> step 20)
      double y = (rawY ~/ 20) * 20 + 8.0;

      // Purely vertical path (x is locked to the center)
      double x = centerX;

      _nodePositions.add(Offset(x, y));
    }
  }

  double _getVirtualHeight() {
    return bottomPadding + topPadding + (totalLevels * nodeSpacingY);
  }

  void _handleNodeTap(int level) {
    if (level <= highestLevel) {
      _startGameplay(level);
    } else {
      HapticFeedback.vibrate();
    }
  }

  Future<void> _startGameplay(int level) async {
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    await DatabaseHelper.instance.updatePlayerProfile(
      profile.copyWith(lastPlayedLevel: level),
    );

    if (!mounted) return;

    final game = BalancoGame(
      isMultiplayer: context.read<AppBloc>().state.isMultiplayer,
      playerRole: context.read<AppBloc>().state.playerRole,
      onLevelComplete: () {
        Navigator.pop(context); // Return to map
        _loadData(); // Refresh highest level
      },
    );
    game.currentLevel.value = level;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePlayOverlay(game: game)),
    );

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _calculateNodes(screenWidth);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Material(
                color: const Color(0xff44C1FF).withValues(alpha: 0.1),
              ),
            ),
          ),
          // Scrollable Map Content clipped above the navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 200, // Approx 50px above the floating navbar
            child: SingleChildScrollView(
              controller: widget.scrollController,
              // Apply our custom SnapScrollPhysics on top of BouncingScrollPhysics
              physics: SnapScrollPhysics(
                itemSize: nodeSpacingY,
              ).applyTo(const BouncingScrollPhysics()),
              child: SizedBox(
                width: screenWidth,
                height: _getVirtualHeight(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Center Route Painter (Vertical Wooden Bridge)
                    Positioned(
                      left: screenWidth / 2 - 25, // Centered horizontally
                      top: 0,
                      bottom: 0,
                      width: 50,
                      child: CustomPaint(painter: WoodenRoutePainter()),
                    ),
                    // Level Holes
                    ...List.generate(totalLevels, (index) {
                      final int level = index + 1;
                      final bool isUnlocked = level <= highestLevel;
                      final Offset pos = _nodePositions[index];

                      // Control the size of the levels here!
                      final double unlockedHoleSize = 115.0;
                      final double lockedHoleSize =
                          90.0; // Decrease this to make locked levels smaller

                      final double currentHoleSize = isUnlocked
                          ? unlockedHoleSize
                          : lockedHoleSize;

                      return Positioned(
                        left: pos.dx - (currentHoleSize / 2),
                        top: pos.dy - (currentHoleSize / 2),
                        width: currentHoleSize,
                        height: currentHoleSize,
                        child: GestureDetector(
                          onTap: () {
                            if (isUnlocked) {
                              HapticFeedback.lightImpact();
                              _handleNodeTap(level);
                            } else {
                              HapticFeedback.vibrate();
                            }
                          },
                          child: CustomPaint(
                            painter: isUnlocked
                                ? MapHolePainter(isUnlocked: true)
                                : LockedLevelPainter(),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Fixed Level Button
          Positioned(
            bottom: 130, // Positioned above the navbar
            left: (screenWidth - 200) / 2, // Centered
            child: BouncingLevelButton(
              currentLevel: _displayedLevel,
              onTap: () {
                HapticFeedback.lightImpact();
                _handleNodeTap(_displayedLevel);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom ScrollPhysics that snaps exactly to intervals (e.g. 130px)
class SnapScrollPhysics extends ScrollPhysics {
  final double itemSize;

  const SnapScrollPhysics({required this.itemSize, ScrollPhysics? parent})
    : super(parent: parent);

  @override
  SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(itemSize: itemSize, parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Fall back to default if out of bounds and not moving back
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Simulation? testSimulation = super.createBallisticSimulation(
      position,
      velocity,
    );

    double targetPixels = position.pixels;
    if (testSimulation != null) {
      targetPixels = testSimulation.x(double.infinity);
    }

    // Snap to the nearest interval of the item size
    final double snappedTarget =
        (targetPixels / itemSize).roundToDouble() * itemSize;

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      snappedTarget.clamp(position.minScrollExtent, position.maxScrollExtent),
      velocity,
      tolerance: tolerance,
    );
  }
}

class BouncingLevelButton extends StatefulWidget {
  final int currentLevel;
  final VoidCallback onTap;

  const BouncingLevelButton({
    Key? key,
    required this.currentLevel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BouncingLevelButton> createState() => _BouncingLevelButtonState();
}

class _BouncingLevelButtonState extends State<BouncingLevelButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 80,
              child: CustomPaint(painter: LevelButtonPainter()),
            ),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.4),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Stack(
                  key: ValueKey<int>(widget.currentLevel),
                  alignment: Alignment.center,
                  children: [
                    // Text Border/Stroke and Shadow
                    Text(
                      'LEVEL ${widget.currentLevel}',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 30,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = const Color.fromARGB(255, 126, 40, 17),
                        shadows: [
                          const Shadow(
                            color: Color.fromARGB(255, 104, 28, 4),
                            blurRadius: 0,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    // Text Fill
                    Text(
                      'LEVEL ${widget.currentLevel}',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 30,
                        color: const Color(0xffFFF8F3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
