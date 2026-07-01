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
import '../data/app_settings.dart';

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
  final double bottomPadding =
      140.0; // Match nodeSpacingY for equal spacing before level 1
  final double topPadding = 160.0;

  int highestLevel =
      0; // Initialize to 0 so first load doesn't trigger unlock animation
  int currentLevel = 1;
  int _displayedLevel = 1;
  int? _justUnlockedLevel;

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

    debugPrint(
      'HOME_SCREEN: _loadData called. Current highestLevel: $highestLevel, DB profile.highestLevel: ${profile.highestLevel}',
    );

    // Check if we just unlocked a new level (meaning we returned from gameplay having beaten a level)
    if (highestLevel > 0 && profile.highestLevel > highestLevel) {
      _justUnlockedLevel = profile.highestLevel;
      debugPrint(
        'HOME_SCREEN: Detected new level unlocked! _justUnlockedLevel set to $_justUnlockedLevel',
      );
    }

    setState(() {
      highestLevel = profile.highestLevel;
      currentLevel = profile.lastPlayedLevel;
      _displayedLevel = currentLevel;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  void _scrollToCurrentLevel({bool animate = false}) {
    if (widget.scrollController.hasClients && _nodePositions.isNotEmpty) {
      int index = currentLevel - 1;
      if (index >= 0 && index < _nodePositions.length) {
        double yPos = _nodePositions[index].dy;
        // Scroll so the node is roughly in the middle/lower third of the screen
        double screenHeight = MediaQuery.of(context).size.height;
        double targetScroll = yPos - (screenHeight * 0.6);
        targetScroll = targetScroll.clamp(
          0.0,
          widget.scrollController.position.maxScrollExtent,
        );

        if (animate) {
          widget.scrollController.animateTo(
            targetScroll,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutBack,
          );
        } else {
          widget.scrollController.jumpTo(targetScroll);
        }
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
                      child: GestureDetector(
                        onLongPress: () async {
                          // SECRET DEBUG RESET BUTTON!
                          // Long press the wooden bridge to reset progress to level 1 for testing.
                          final profile = await DatabaseHelper.instance
                              .getPlayerProfile();
                          await DatabaseHelper.instance.updatePlayerProfile(
                            profile.copyWith(
                              highestLevel: 1,
                              lastPlayedLevel: 1,
                            ),
                          );
                          setState(() {
                            highestLevel = 1;
                            currentLevel = 1;
                            _justUnlockedLevel = null;
                          });
                          HapticFeedback.heavyImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'DEBUG: Progress reset to Level 1!',
                              ),
                            ),
                          );
                        },
                        child: CustomPaint(painter: WoodenRoutePainter()),
                      ),
                    ),
                    // Level Holes
                    ...List.generate(totalLevels, (index) {
                      final int level = index + 1;
                      final bool isUnlocked = level <= highestLevel;
                      final Offset pos = _nodePositions[index];

                      // Control the size of the levels here!
                      final double unlockedHoleSize = 100.0;
                      final double lockedHoleSize =
                          90.0; // Decrease this to make locked levels smaller

                      return AnimatedLevelNode(
                        level: level,
                        isUnlocked: isUnlocked,
                        isJustUnlocked: level == _justUnlockedLevel,
                        isCurrent: level == _displayedLevel,
                        lockedSize: lockedHoleSize,
                        unlockedSize: unlockedHoleSize,
                        pos: pos,
                        onTap: () {
                          if (isUnlocked) {
                            HapticFeedback.lightImpact();
                            _handleNodeTap(level);
                          } else {
                            HapticFeedback.vibrate();
                          }
                        },
                        onAnimationComplete: () {
                          debugPrint(
                            'HOME_SCREEN: Animation complete for level $level',
                          );
                          if (mounted && level == _justUnlockedLevel) {
                            setState(() {
                              _justUnlockedLevel = null;
                              currentLevel =
                                  level; // Automatically update current level
                            });
                            // Smoothly navigate to the new unlocked level!
                            _scrollToCurrentLevel(animate: true);
                          }
                        },
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

class AnimatedLevelNode extends StatefulWidget {
  final int level;
  final bool isUnlocked;
  final bool isJustUnlocked;
  final bool isCurrent;
  final double lockedSize;
  final double unlockedSize;
  final Offset pos;
  final VoidCallback onTap;
  final VoidCallback onAnimationComplete;

  const AnimatedLevelNode({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isJustUnlocked,
    this.isCurrent = false,
    required this.lockedSize,
    required this.unlockedSize,
    required this.pos,
    required this.onTap,
    required this.onAnimationComplete,
  });

  @override
  State<AnimatedLevelNode> createState() => _AnimatedLevelNodeState();
}

class _AnimatedLevelNodeState extends State<AnimatedLevelNode>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _splitTranslate;
  late Animation<double> _splitRotate;
  late Animation<double> _glowOpacity;
  late Animation<double> _scaleInUnlocked;
  late Animation<double> _spinUnlocked;

  late AnimationController _idleRotateController;

  bool _hasPlayedCrackSound = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _idleRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Slow spin
    );
    if (widget.isCurrent && widget.isUnlocked && !widget.isJustUnlocked) {
      _idleRotateController.repeat();
    }

    // 0.0 - 0.32: Shake build up
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.32, curve: Curves.easeIn),
      ),
    );

    // 0.32 - 0.6: Pieces fly apart
    _splitTranslate = Tween<double>(begin: 0.0, end: 60.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.6, curve: Curves.easeOutQuad),
      ),
    );

    _splitRotate = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.6, curve: Curves.easeOut),
      ),
    );

    // 0.3 - 1.0: Glow flashes in then fades out
    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0),
      ),
    );

    // 0.45 - 1.0: New hole scales in and spins
    _scaleInUnlocked = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.elasticOut),
      ),
    );

    _spinUnlocked = Tween<double>(begin: -pi, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _controller.addListener(() {
      if (_controller.value >= 0.32 && !_hasPlayedCrackSound) {
        _hasPlayedCrackSound = true;
        AppSettings.playSound('metal_crack.wav');
        HapticFeedback.heavyImpact(); // Add a nice physical crack feel
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        widget.onAnimationComplete();
      } else if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        _hasPlayedCrackSound = false;
      }
    });

    if (widget.isJustUnlocked) {
      debugPrint(
        'ANIM_NODE [Level ${widget.level}]: initState with isJustUnlocked=true! Delaying 2s...',
      );
      // Delay to let the camera scroll to the node so the player can watch it animate
      Future.delayed(const Duration(seconds: 2), () {
        debugPrint(
          'ANIM_NODE [Level ${widget.level}]: Delay finished, calling forward()',
        );
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedLevelNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isJustUnlocked && !oldWidget.isJustUnlocked) {
      debugPrint(
        'ANIM_NODE [Level ${widget.level}]: didUpdateWidget detected UNLOCK! Setting value=0.0 and delaying 2s...',
      );
      _controller.value = 0.0; // Snap to Locked state immediately
      Future.delayed(const Duration(seconds: 2), () {
        debugPrint(
          'ANIM_NODE [Level ${widget.level}]: didUpdateWidget delay finished, calling forward()',
        );
        if (mounted) _controller.forward();
      });
    }

    if (widget.isCurrent != oldWidget.isCurrent) {
      if (widget.isCurrent && widget.isUnlocked && !widget.isJustUnlocked) {
        _idleRotateController.repeat();
      } else {
        _idleRotateController.stop();
        // Option: _idleRotateController.animateTo(0.0) if you want it to reset, but leaving it where it stopped is fine.
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _idleRotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isJustUnlocked) {
      // Static render
      double currentSize = widget.isUnlocked
          ? widget.unlockedSize
          : widget.lockedSize;
      
      Widget childPainter = CustomPaint(
        painter: widget.isUnlocked
            ? MapHolePainter(isUnlocked: true)
            : LockedLevelPainter(),
      );

      // If unlocked and current, apply idle rotation
      if (widget.isUnlocked && widget.isCurrent) {
        childPainter = AnimatedBuilder(
          animation: _idleRotateController,
          child: childPainter,
          builder: (context, child) {
            return Transform.rotate(
              angle: _idleRotateController.value * 2 * pi,
              child: child,
            );
          },
        );
      }

      return Positioned(
        left: widget.pos.dx - (currentSize / 2),
        top: widget.pos.dy - (currentSize / 2),
        width: currentSize,
        height: currentSize,
        child: GestureDetector(
          onTap: widget.onTap,
          child: childPainter,
        ),
      );
    }

    // Animated render (max size needed to not clip the flying pieces and glow)
    double maxSize = max(widget.lockedSize, widget.unlockedSize) * 3.0;

    return Positioned(
      left: widget.pos.dx - (maxSize / 2),
      top: widget.pos.dy - (maxSize / 2),
      width: maxSize,
      height: maxSize,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double shakeOffset = _shakeAnimation.value > 0
                ? sin(_shakeAnimation.value * pi * 8) *
                    4.0 *
                    _shakeAnimation.value
                : 0.0;

            return Stack(
              alignment: Alignment.center,
              children: [
                // 1. Shattering Lock (visible until 0.6)
                if (_controller.value < 0.6)
                  Transform.translate(
                    offset: Offset(shakeOffset, 0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left Half
                        Transform.translate(
                          offset: Offset(
                            -_splitTranslate.value,
                            _splitTranslate.value * 0.5,
                          ),
                          child: Transform.rotate(
                            angle: -_splitRotate.value * (pi / 4),
                            child: ClipRect(
                              clipper: _HalfClipper(left: true),
                              child: SizedBox(
                                width: widget.lockedSize,
                                height: widget.lockedSize,
                                child: CustomPaint(
                                  painter: LockedLevelPainter(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Right Half
                        Transform.translate(
                          offset: Offset(
                            _splitTranslate.value,
                            _splitTranslate.value * 0.5,
                          ),
                          child: Transform.rotate(
                            angle: _splitRotate.value * (pi / 4),
                            child: ClipRect(
                              clipper: _HalfClipper(left: false),
                              child: SizedBox(
                                width: widget.lockedSize,
                                height: widget.lockedSize,
                                child: CustomPaint(
                                  painter: LockedLevelPainter(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // 2. The Unlocked Node spinning in
                if (_controller.value >= 0.45)
                  Transform.scale(
                    scale: _scaleInUnlocked.value,
                    child: Transform.rotate(
                      angle: _spinUnlocked.value,
                      child: SizedBox(
                        width: widget.unlockedSize,
                        height: widget.unlockedSize,
                        child: CustomPaint(
                          painter: MapHolePainter(isUnlocked: true),
                        ),
                      ),
                    ),
                  ),

                // 3. The Glow Flash
                if (_glowOpacity.value > 0)
                  Opacity(
                    opacity: _glowOpacity.value,
                    child: Container(
                      width: widget.unlockedSize * 1.5,
                      height: widget.unlockedSize * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 40.0,
                            spreadRadius: 20.0,
                          ),
                          BoxShadow(
                            color: const Color(0xFFFFD54F).withOpacity(0.5),
                            blurRadius: 60.0,
                            spreadRadius: 40.0,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  final bool left;
  _HalfClipper({required this.left});

  @override
  Rect getClip(Size size) {
    if (left) {
      return Rect.fromLTRB(0, 0, size.width / 2, size.height);
    } else {
      return Rect.fromLTRB(size.width / 2, 0, size.width, size.height);
    }
  }

  @override
  bool shouldReclip(covariant _HalfClipper oldClipper) {
    return oldClipper.left != left;
  }
}
