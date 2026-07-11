import 'dart:math';
import 'dart:ui';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/map/components/play_button_painter.dart';
import 'package:balanco_game/features/map/components/wooden_route_painter.dart';
import 'package:balanco_game/features/map/components/locked_level_painter.dart';
import 'package:balanco_game/features/map/components/map_hole_painter.dart';
import 'package:balanco_game/features/map/components/map_ball_layer.dart';
import 'package:balanco_game/features/map/components/ball_shatter_painter.dart';
import 'package:balanco_game/features/map/theme/map_theme.dart';
import 'package:balanco_game/features/map/theme/themes/beach_map_theme.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/core/widgets/cartoon_star.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  final ValueNotifier<double>? biomeTransitionProgress;
  final ValueNotifier<BiomeModel?>? currentBiomeNotifier;
  final ValueNotifier<BiomeModel?>? previousBiomeNotifier;
  final VoidCallback? onReturnFromGame;

  const HomeScreen({
    super.key,
    required this.scrollController,
    this.biomeTransitionProgress,
    this.currentBiomeNotifier,
    this.previousBiomeNotifier,
    this.onReturnFromGame,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final int totalLevels = 500;
  final double nodeSpacingY = 180.0; // Increased spacing between level holes
  double get bottomPadding =>
      310.0 +
      MediaQuery.of(context)
          .padding
          .bottom; // Ample padding at the bottom so lowest hole clears the UI
  final double topPadding = 140.0;

  int highestLevel =
      0; // Initialize to 0 so first load doesn't trigger unlock animation
  int currentLevel = 1;
  int _displayedLevel = 1; // Used by BouncingLevelButton
  int _justUnlockedLevel = -1;
  bool _isFirstLoad = true;

  Map<int, int> _levelStars = {};

  // For dragging
  bool _isDragging = false;

  late MapTheme theme;

  final List<Offset> _nodePositions = [];

  // Play Level Animation
  late AnimationController _playLevelController;
  late Animation<double> _teethClosureAnimation;
  int? _animatingLevel;

  // Idle Jump Animation
  late AnimationController _idleJumpController;
  late Animation<double> _idleJumpAnimation;
  late Animation<double> _idleSquashYAnimation;
  late Animation<double> _idleSquashXAnimation;
  late Animation<double> _idleScaleZAnimation;

  @override
  void initState() {
    super.initState();
    theme = BeachMapTheme(); // Use the new theme system!
    widget.scrollController.addListener(_onScroll);
    _loadData();

    _idleJumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..repeat(reverse: true);

    _idleJumpAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 15),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -45.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 85,
      ),
    ]).animate(_idleJumpController);

    _idleSquashYAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.6,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 85,
      ),
    ]).animate(_idleJumpController);

    _idleSquashXAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.4,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 85,
      ),
    ]).animate(_idleJumpController);

    _idleScaleZAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 15),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 85,
      ),
    ]).animate(_idleJumpController);

    _playLevelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _teethClosureAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _playLevelController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeInCubic),
      ),
    );

    _buzzerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _buzzerAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 12.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -12.0, end: 6.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _buzzerController, curve: Curves.easeInOut),
        );

    _biomeTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // 1.2s total duration
    );

    _biomeTransitionController.addListener(() {
      if (widget.biomeTransitionProgress != null) {
        widget.biomeTransitionProgress!.value =
            _biomeTransitionController.value;
      }
      setState(() {});
    });

    _explosionOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _biomeTransitionController,
        // 0→1 is the SHATTER PROGRESS used by BallShatterPainter
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _newBallDropAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _biomeTransitionController,
        curve: const Interval(0.3, 0.8, curve: Curves.bounceOut),
      ),
    );

    // Implode → elastic snap-back with a slight overshoot
    _playButtonBulgeAnimation =
        TweenSequence<double>([
          // Compress inward (feels "charged")
          TweenSequenceItem(
            tween: Tween(
              begin: 1.0,
              end: 0.82,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 20,
          ),
          // Elastic BOOM back (color changes here at peak compress — 0.2)
          TweenSequenceItem(
            tween: Tween(
              begin: 0.82,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.elasticOut)),
            weight: 50,
          ),
          // Settle
          TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
        ]).animate(
          CurvedAnimation(
            parent: _biomeTransitionController,
            curve: const Interval(0.0, 0.8),
          ),
        );

    // Wobble rotation: button tilts slightly then corrects
    _playButtonRotationAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 0.07,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 15,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 0.07,
              end: -0.05,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 20,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: -0.05,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 15,
          ),
          TweenSequenceItem(tween: ConstantTween(0.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _biomeTransitionController,
            curve: const Interval(0.0, 0.8),
          ),
        );

    // Platform lava crack: starts at ball impact (t=0.8) and completes by t=1.0
    _platformTransitionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _biomeTransitionController,
        curve: const Interval(0.78, 1.0, curve: Curves.easeOut),
      ),
    );

    // Haptic and Sound trigger at exactly 0.8
    _biomeTransitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isBiomeTransitioning = false;
        _previousBiome = null;
        if (widget.previousBiomeNotifier != null) {
          widget.previousBiomeNotifier!.value = null;
        }
        setState(() {}); // One last build to clean up
      }
    });

    bool hasTriggeredImpact = false;
    _biomeTransitionController.addListener(() {
      if (_biomeTransitionController.value >= 0.8 && !hasTriggeredImpact) {
        hasTriggeredImpact = true;
        HapticFeedback.heavyImpact();
        try {
          AppSettings.playSound(
            'heavy_thud.wav',
          ); // Assuming a sound exists or it will just fail gracefully
        } catch (_) {}
      } else if (_biomeTransitionController.value < 0.8) {
        hasTriggeredImpact = false;
      }
    });
  }

  late AnimationController _buzzerController;
  late Animation<double> _buzzerAnimation;

  // Biome Transition Animations
  late AnimationController _biomeTransitionController;
  late Animation<double> _explosionOpacityAnimation;
  late Animation<double> _newBallDropAnimation;
  late Animation<double> _playButtonBulgeAnimation;
  late Animation<double> _playButtonRotationAnimation;
  late Animation<double> _platformTransitionAnimation;

  BiomeModel? _previousBiome;
  BiomeModel? _targetBiome;
  bool _isBiomeTransitioning = false;

  @override
  void dispose() {
    _buzzerController.dispose();
    _playLevelController.dispose();
    _idleJumpController.dispose();
    _biomeTransitionController.dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  double _getPlayButtonBottom(BuildContext context) {
    return 110.0 + MediaQuery.of(context).padding.bottom;
  }

  double _getPlatformBottom(BuildContext context) {
    return 190.0 + MediaQuery.of(context).padding.bottom;
  }

  double _getFocalOffsetFromTop(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight - (_getPlatformBottom(context) + 30.0);
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;

    double scrollOffset = widget.scrollController.offset;
    double screenHeight = MediaQuery.of(context).size.height;
    double totalHeight = _getVirtualHeight();

    double focalOffsetFromTop = _getFocalOffsetFromTop(context);

    double rawLevel =
        1 +
        (totalHeight - bottomPadding - scrollOffset - focalOffsetFromTop) /
            nodeSpacingY;
    int calculatedLevel = rawLevel.round().clamp(1, totalLevels);

    if (calculatedLevel != _displayedLevel) {
      final oldBiome = BiomeConfig.getBiomeForLevel(_displayedLevel);
      final newBiome = BiomeConfig.getBiomeForLevel(calculatedLevel);

      if (widget.currentBiomeNotifier != null) {
        widget.currentBiomeNotifier!.value = newBiome;
      }

      if (oldBiome != newBiome && !_isFirstLoad) {
        // Biome change! Trigger the cinematic!
        _previousBiome = oldBiome;
        _targetBiome = newBiome;

        if (widget.previousBiomeNotifier != null) {
          widget.previousBiomeNotifier!.value = oldBiome;
        }

        _isBiomeTransitioning = true;
        _biomeTransitionController.forward(from: 0.0);
      }

      setState(() {
        _displayedLevel = calculatedLevel;
      });
      HapticFeedback.selectionClick();
    }

    // Calculate Biome Transition Progress (Between Level 10 and Level 11)
    if (widget.biomeTransitionProgress != null) {
      // Level 10 is at i=9, Level 11 is at i=10
      double level10Y = totalHeight - bottomPadding - (9 * nodeSpacingY);
      double level11Y = totalHeight - bottomPadding - (10 * nodeSpacingY);

      // Gap Y is directly in the middle
      double gapY = (level10Y + level11Y) / 2;

      // We want to transition fully over the space of one nodeSpacingY
      // So transition starts at gapY + nodeSpacingY/2 and ends at gapY - nodeSpacingY/2
      // The visual focal point on screen is at focalOffsetFromTop.
      double transitionStartOffset =
          gapY + (nodeSpacingY / 2) - focalOffsetFromTop;
      double transitionEndOffset =
          gapY - (nodeSpacingY / 2) - focalOffsetFromTop;

      double progress = 0.0;
      if (scrollOffset >= transitionStartOffset) {
        progress = 0.0;
      } else if (scrollOffset <= transitionEndOffset) {
        progress = 1.0;
      } else {
        progress =
            1.0 -
            ((scrollOffset - transitionEndOffset) /
                (transitionStartOffset - transitionEndOffset));
      }
      widget.biomeTransitionProgress!.value = progress;
    }
  }

  Future<void> _loadData() async {
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    final progresses = await DatabaseHelper.instance.getAllLevelProgress();
    if (!mounted) return;

    debugPrint(
      'HOME_SCREEN: _loadData called. Current highestLevel: $highestLevel, DB profile.highestLevel: ${profile.highestLevel}',
    );

    // Check if we just unlocked a new level (meaning we returned from gameplay having beaten a level)
    if (!_isFirstLoad &&
        highestLevel > 0 &&
        profile.highestLevel > highestLevel) {
      _justUnlockedLevel = profile.highestLevel;
      debugPrint(
        'HOME_SCREEN: Detected new level unlocked! _justUnlockedLevel set to $_justUnlockedLevel',
      );
    }
    _isFirstLoad = false;

    setState(() {
      highestLevel = profile.highestLevel;
      currentLevel =
          profile.highestLevel; // Always default to the highest unlocked level
      _displayedLevel = currentLevel;
      _levelStars = {for (var p in progresses) p.levelId: p.stars};
    });

    if (widget.currentBiomeNotifier != null) {
      widget.currentBiomeNotifier!.value = BiomeConfig.getBiomeForLevel(
        currentLevel,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  Future<void> _scrollToLevel(int level, {bool animate = false}) async {
    if (widget.scrollController.hasClients && _nodePositions.isNotEmpty) {
      int index = level - 1;
      if (index >= 0 && index < _nodePositions.length) {
        double yPos = _nodePositions[index].dy;
        // Scroll so the node is roughly in the middle/lower third of the screen
        double focalOffsetFromTop = _getFocalOffsetFromTop(context);

        double targetScroll = yPos - focalOffsetFromTop;
        targetScroll = targetScroll.clamp(
          0.0,
          widget.scrollController.position.maxScrollExtent,
        );

        if (animate) {
          await widget.scrollController.animateTo(
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

  Future<void> _scrollToCurrentLevel({bool animate = false}) {
    return _scrollToLevel(currentLevel, animate: animate);
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

  void _handleNodeTap(int level) async {
    if (_animatingLevel != null) return; // Prevent multiple taps

    if (level <= highestLevel) {
      // If the tapped level is not the currently centered level, scroll to it first.
      if (level != currentLevel && level != _displayedLevel) {
        await _scrollToLevel(level, animate: true);
        // Wait a tiny bit for scroll to settle before flying
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
      }

      setState(() {
        _animatingLevel = level;
      });
      _startGameplay(level);
    } else {
      HapticFeedback.vibrate();
      _triggerLockedFeedback();
    }
  }

  void _triggerLockedFeedback() {
    if (_buzzerController.isAnimating) return;
    _buzzerController.forward(from: 0.0);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: GameColors.mapScreenColor1,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: GameColors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: GameColors.black54,
                offset: Offset(0, 4),
                blurRadius: 0, // Cartoonish hard shadow
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_rounded, color: GameColors.amber, size: 28),
              const SizedBox(width: 12),
              Text(
                "Level Locked!",
                style: GoogleFonts.luckiestGuy(
                  fontSize: 20,
                  color: GameColors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _runFlyToHoleAnimation(int level) {
    // 1. Get RenderBox of the overlay to convert coordinates properly
    final overlayState = Overlay.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Start position: the idle ball position which is anchored to the bottom
    final double focalOffsetFromTop = _getFocalOffsetFromTop(context);

    final double startX = (screenWidth - 60) / 2;
    final double startY = focalOffsetFromTop - 30;

    // End position: the target hole
    final Offset nodePos = _nodePositions[level - 1];
    final double scrollOffset = widget.scrollController.offset;
    final double targetX = nodePos.dx - 30; // Center the 60x60 ball on the node
    final double targetY = nodePos.dy - scrollOffset - 30;

    // Stop idle jump
    _idleJumpController.stop();

    late OverlayEntry overlayEntry;

    // We create an animation that arcs the ball.
    // X moves linearly.
    Animation<double> xAnim = Tween<double>(begin: startX, end: targetX)
        .animate(
          CurvedAnimation(
            parent: _playLevelController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
          ),
        );

    // Y arcs up then down. We'll use a TweenSequence.
    Animation<double> yAnim =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: startY,
              end: min(startY, targetY) - 100,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: min(startY, targetY) - 100,
              end: targetY,
            ).chain(CurveTween(curve: Curves.easeInCubic)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _playLevelController,
            curve: const Interval(0.0, 0.8),
          ),
        );

    // Determine current scale
    final double currentZScale = _idleScaleZAnimation.value;

    // Flight scale animation: Ball gets bigger (jumps towards camera) then shrinks into the hole
    Animation<double> flightScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: currentZScale,
          end: 2.2, // Pops out significantly
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 2.2,
          end: 1.0, // Back to normal size before falling in
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0, // Sucked into hole
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30, // The last 30% of the flight
      ),
    ]).animate(_playLevelController);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _playLevelController,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                children: [
                  // Sucking Effect Layer
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SuckingEffectPainter(
                        ballCenter: Offset(xAnim.value + 30, yAnim.value + 30),
                        holeCenter: Offset(targetX + 30, targetY + 30),
                        progress: _playLevelController.value,
                      ),
                    ),
                  ),
                  // Ball Layer
                  Positioned(
                    left: xAnim.value,
                    top: yAnim.value,
                    child: Opacity(
                      opacity: _animatingLevel == level ? 1.0 : 0.0,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CustomPaint(
                          painter: MapBallLayer(
                            position: const Offset(30, 30),
                            scale: flightScaleAnimation.value,
                            squashScaleX: 1.0,
                            squashScaleY: 1.0,
                            rotation: 0.0,
                            radius: 16.0,
                            ballOffsetY:
                                0.0, // We are animating the whole widget now
                            drawPlatform:
                                false, // Don't draw the platform while flying
                            drawBall: true,
                            isLocked: level > highestLevel,
                            biome: BiomeConfig.getBiomeForLevel(level),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    overlayState.insert(overlayEntry);

    _playLevelController.forward(from: 0.0).then((_) async {
      overlayEntry.remove();

      // Wait a bit to let the player see the suction and teeth closing effect
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        _startGameplay(level);
      }
    });
  }

  Future<void> _startGameplay(int level) async {
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    await DatabaseHelper.instance.updatePlayerProfile(
      profile.copyWith(lastPlayedLevel: level),
    );

    if (!mounted) return;

    final game = BalancoGame(
      isMultiplayer: context.read<AppBloc>().state.isMultiplayer,
      isInfinityMode: false,
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

    // Reset animation state and show ball on platform AFTER returning to lobby
    _playLevelController.reset();
    if (mounted) {
      setState(() {
        _animatingLevel = null;
      });
    }

    _loadData();
    widget.onReturnFromGame?.call();
    if (mounted) {
      _idleJumpController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _calculateNodes(screenWidth);
    final double totalHeight = _getVirtualHeight();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Scrollable Map Content clipped above the navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0, // Fill the screen
            child: SingleChildScrollView(
              controller: widget.scrollController,
              // Apply our custom SnapScrollPhysics on top of BouncingScrollPhysics
              physics: SnapScrollPhysics(
                itemSize: nodeSpacingY,
              ).applyTo(const BouncingScrollPhysics()),
              child: SizedBox(
                width: screenWidth,
                height: totalHeight,
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
                            _justUnlockedLevel = -1;
                          });
                          HapticFeedback.heavyImpact();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'DEBUG: Progress reset to Level 1!',
                              ),
                            ),
                          );
                        },
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: WoodenRoutePainter(
                              transitionY:
                                  totalHeight -
                                  bottomPadding -
                                  (9.5 * nodeSpacingY),
                              totalLevels: totalLevels,
                            ),
                          ),
                        ),
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

                      return AnimatedBuilder(
                        animation: _playLevelController,
                        builder: (context, child) {
                          return AnimatedLevelNode(
                            level: level,
                            isUnlocked: isUnlocked,
                            isJustUnlocked: level == _justUnlockedLevel,
                            stars: _levelStars[level] ?? 0,
                            isCurrent: level == _displayedLevel,
                            lockedSize: lockedHoleSize,
                            unlockedSize: unlockedHoleSize,
                            pos: pos,
                            biome: BiomeConfig.getBiomeForLevel(level),
                            teethClosure: _animatingLevel == level
                                ? _teethClosureAnimation.value
                                : 0.0,
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              if (!isUnlocked) {
                                _triggerLockedFeedback();
                              } else {
                                if (_displayedLevel == level) {
                                  _handleNodeTap(level);
                                } else {
                                  await _scrollToLevel(level, animate: true);
                                  if (mounted) {
                                    _handleNodeTap(level);
                                  }
                                }
                              }
                            },
                            onAnimationComplete: () {
                              debugPrint(
                                'HOME_SCREEN: Animation complete for level $level',
                              );
                              if (mounted && level == _justUnlockedLevel) {
                                setState(() {
                                  _justUnlockedLevel = -1;
                                  currentLevel =
                                      level; // Automatically update current level
                                });
                                // Smoothly navigate to the new unlocked level!
                                _scrollToCurrentLevel(animate: true);
                              }
                            },
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: AnimatedBuilder(
              animation: _biomeTransitionController,
              builder: (context, child) {
                final screenHeight = MediaQuery.of(context).size.height;
                final currentBiome = BiomeConfig.getBiomeForLevel(
                  _displayedLevel,
                );
                final bool isTransitioning =
                    _isBiomeTransitioning &&
                    _previousBiome != null &&
                    _targetBiome != null;

                double playButtonBottom = _getPlayButtonBottom(context);
                double platformBottom = _getPlatformBottom(context);

                // The visual focal point from top is:
                double focalOffsetFromTop = _getFocalOffsetFromTop(context);

                final double ballLandingTopFromTop = focalOffsetFromTop - 30;
                final double ballStartTopFromTop =
                    -60.0; // above the status bar
                // _newBallDropAnimation goes 0.0 (start, top) → 1.0 (landed)
                final double fallingBallTop =
                    ballStartTopFromTop +
                    _newBallDropAnimation.value *
                        (ballLandingTopFromTop - ballStartTopFromTop);

                return AnimatedBuilder(
                  animation: _buzzerAnimation,
                  builder: (context, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ─── Play Button ───────────────────────────────────────────
                        Positioned(
                          bottom: playButtonBottom,
                          left:
                              (screenWidth - 200) / 2 + _buzzerAnimation.value,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              // Shockwave rings overlay (bigger canvas so rings can escape)
                              if (isTransitioning)
                                Positioned(
                                  left: -60,
                                  right: -60,
                                  top: -40,
                                  bottom: -40,
                                  child: CustomPaint(
                                    painter: PlayButtonRipplePainter(
                                      progress:
                                          _biomeTransitionController.value,
                                      newBiome: currentBiome,
                                      buttonWidth: 200,
                                      buttonHeight: 70,
                                    ),
                                  ),
                                ),
                              // The actual button: implode → elastic snap + wobble
                              Transform.rotate(
                                angle: isTransitioning
                                    ? _playButtonRotationAnimation.value
                                    : 0.0,
                                child: Transform.scale(
                                  scale: isTransitioning
                                      ? _playButtonBulgeAnimation.value
                                      : 1.0,
                                  alignment: Alignment.center,
                                  child: BouncingLevelButton(
                                    currentLevel: _displayedLevel,
                                    // Color switches at the bottom of the implosion (t=0.2)
                                    biome:
                                        isTransitioning &&
                                            _biomeTransitionController.value <
                                                0.2
                                        ? _previousBiome!
                                        : currentBiome,
                                    isLocked: _displayedLevel > highestLevel,
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      _handleNodeTap(_displayedLevel);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ─── Platform + Normal (idle) ball ────────────────────────
                        Positioned(
                          bottom: platformBottom,
                          left: (screenWidth - 60) / 2 + _buzzerAnimation.value,
                          child: AnimatedBuilder(
                            animation: _idleJumpController,
                            builder: (context, child) {
                              return SizedBox(
                                width: 60,
                                height: 60,
                                child: CustomPaint(
                                  painter: MapBallLayer(
                                    position: const Offset(30, 30),
                                    scale: isTransitioning
                                        ? 0.0
                                        : _idleScaleZAnimation.value,
                                    squashScaleX: _idleSquashXAnimation.value,
                                    squashScaleY: _idleSquashYAnimation.value,
                                    rotation: 0.0,
                                    radius: 16.0,
                                    ballOffsetY: _idleJumpAnimation.value,
                                    drawPlatform: true,
                                    drawBall:
                                        !isTransitioning &&
                                        _animatingLevel == null,
                                    isLocked: _displayedLevel > highestLevel,
                                    biome: currentBiome,
                                    platformBiome: isTransitioning
                                        ? _previousBiome
                                        : null,
                                    platformTransitionProgress: isTransitioning
                                        ? _platformTransitionAnimation.value
                                        : 0.0,
                                    platformNewBiome: isTransitioning
                                        ? currentBiome
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // ─── OLD Ball Shatter (top-level so it's never clipped) ──
                        if (isTransitioning)
                          Positioned(
                            // Centre the 120x120 shatter canvas over where the ball was
                            bottom:
                                platformBottom -
                                30, // -30 to vertically center the 120px canvas over the 60px platform
                            left:
                                (screenWidth - 120) / 2 +
                                _buzzerAnimation.value,
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CustomPaint(
                                // _explosionOpacityAnimation is now the shatter PROGRESS (0→1)
                                painter: BallShatterPainter(
                                  progress: _explosionOpacityAnimation.value
                                      .clamp(0.0, 1.0),
                                  biome: _previousBiome!,
                                  radius: 16.0,
                                ),
                              ),
                            ),
                          ),

                        // ─── NEW Ball Falling (top-level, starts above status bar) ─
                        if (isTransitioning)
                          Positioned(
                            top: fallingBallTop,
                            left:
                                (screenWidth - 60) / 2 + _buzzerAnimation.value,
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CustomPaint(
                                painter: MapBallLayer(
                                  position: const Offset(30, 30),
                                  scale: 1.0,
                                  rotation: 0.0,
                                  radius: 16.0,
                                  ballOffsetY: 0.0,
                                  drawPlatform: false,
                                  drawBall: true,
                                  isLocked: false,
                                  biome: _targetBiome!,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws expanding shockwave rings around the play button during a biome transition.
/// [progress] is the raw biome controller value (0.0 to 1.0).
class PlayButtonRipplePainter extends CustomPainter {
  final double progress;
  final BiomeModel newBiome;
  final double buttonWidth;
  final double buttonHeight;

  static const int _ringCount = 3;
  static const double _ringDelay = 0.07;

  const PlayButtonRipplePainter({
    required this.progress,
    required this.newBiome,
    this.buttonWidth = 200,
    this.buttonHeight = 70,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxRadius = sqrt(cx * cx + cy * cy) * 1.6;

    for (int i = 0; i < _ringCount; i++) {
      final startT = 0.2 + i * _ringDelay;
      final endT = startT + 0.45;
      if (progress < startT || progress > endT) continue;

      final t = (progress - startT) / (endT - startT);
      final radius = maxRadius * t;
      final strokeWidth = 4.0 * (1.0 - t * 0.7);
      final opacity = (1.0 - t) * (0.75 - i * 0.15);

      // Outer glow ring
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color = newBiome.primaryColor.withValues(alpha: opacity * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Sharp colored ring
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color = newBiome.secondaryColor.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }

    // White burst flash at t=0.2
    if (progress >= 0.18 && progress <= 0.38) {
      final flashT = (progress - 0.18) / 0.2;
      final flashOpacity = (1.0 - flashT) * 0.85;
      final flashRadius = maxRadius * 0.6 * flashT;
      canvas.drawCircle(
        Offset(cx, cy),
        flashRadius,
        Paint()
          ..color = Colors.white.withValues(alpha: flashOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  @override
  bool shouldRepaint(PlayButtonRipplePainter old) => old.progress != progress;
}

/// A custom ScrollPhysics that snaps exactly to intervals (e.g. 130px)
class SnapScrollPhysics extends ScrollPhysics {
  final double itemSize;

  const SnapScrollPhysics({required this.itemSize, super.parent});

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
      tolerance: toleranceFor(position),
    );
  }
}

class BouncingLevelButton extends StatefulWidget {
  final int currentLevel;
  final bool isLocked;
  final VoidCallback onTap;
  final BiomeModel biome;

  const BouncingLevelButton({
    super.key,
    required this.currentLevel,
    required this.onTap,
    required this.biome,
    this.isLocked = false,
  });

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
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: PlayButtonPainter(
                    isLocked: widget.isLocked,
                    biome: widget.biome,
                  ),
                ),
              ),
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
                          ..color = widget.isLocked
                              ? GameColors.mapScreenColor2
                              : const Color.fromARGB(255, 126, 40, 17),
                        shadows: [
                          Shadow(
                            color: widget.isLocked
                                ? GameColors.mapScreenColor1
                                : const Color.fromARGB(255, 104, 28, 4),
                            blurRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    // Text Fill
                    Text(
                      'LEVEL ${widget.currentLevel}',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 30,
                        color: widget.isLocked
                            ? GameColors.mapScreenColor3
                            : GameColors.mapScreenColor4,
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
  final int stars;
  final bool isCurrent;
  final double lockedSize;
  final double unlockedSize;
  final Offset pos;
  final VoidCallback onTap;
  final VoidCallback onAnimationComplete;
  final double teethClosure; // Support teeth closing animation
  final BiomeModel biome;

  const AnimatedLevelNode({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.isJustUnlocked,
    this.stars = 0,
    this.isCurrent = false,
    required this.lockedSize,
    required this.unlockedSize,
    required this.pos,
    required this.onTap,
    required this.onAnimationComplete,
    required this.biome,
    this.teethClosure = 0.0,
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
    _glowOpacity =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 15,
          ),
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 15),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 70,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)),
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _idleRotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCurrent && widget.isUnlocked && !widget.isJustUnlocked) {
      if (!_idleRotateController.isAnimating) {
        _idleRotateController.repeat();
      }
    } else {
      if (_idleRotateController.isAnimating) {
        _idleRotateController.stop();
      }
    }

    if (!widget.isJustUnlocked) {
      // Static render
      double currentSize = widget.isUnlocked
          ? (widget.isCurrent ? widget.unlockedSize * 1.1 : widget.unlockedSize)
          : widget.lockedSize;

      Widget childPainter = RepaintBoundary(
        child: CustomPaint(
          size: Size(currentSize, currentSize),
          painter: widget.isUnlocked
              ? MapHolePainter(
                  isUnlocked: true,
                  biome: widget.biome,
                  teethClosure: widget.teethClosure,
                )
              : LockedLevelPainter(),
        ),
      );

      // If we are locked and using crystal cave biome, tint the lock
      if (!widget.isUnlocked && widget.biome.startLevel >= 11) {
        childPainter = ColorFiltered(
          colorFilter: ColorFilter.mode(
            widget.biome.nodeLockedColor.withValues(alpha: 0.25),
            BlendMode.srcATop,
          ),
          child: childPainter,
        );
      }

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
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              childPainter,
              if (widget.isUnlocked)
                Positioned.fill(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: List.generate(3, (index) {
                      bool collected = index < widget.stars;
                      double angle = (index - 1) * (pi / 5.5);
                      double radius = (currentSize / 2) + 25;
                      double dx = sin(angle) * radius;
                      double dy = -cos(angle) * radius;
                      return Transform.translate(
                        offset: Offset(dx, dy),
                        child: Transform.rotate(
                          angle: angle,
                          child: CartoonStar(isCollected: collected, size: 35),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
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
                                child: RepaintBoundary(
                                  child: widget.biome.startLevel >= 11
                                      ? ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            widget.biome.nodeLockedColor
                                                .withValues(alpha: 0.25),
                                            BlendMode.srcATop,
                                          ),
                                          child: CustomPaint(
                                            painter: LockedLevelPainter(),
                                          ),
                                        )
                                      : CustomPaint(
                                          painter: LockedLevelPainter(),
                                        ),
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
                                child: RepaintBoundary(
                                  child: widget.biome.startLevel >= 11
                                      ? ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            widget.biome.nodeLockedColor
                                                .withValues(alpha: 0.25),
                                            BlendMode.srcATop,
                                          ),
                                          child: CustomPaint(
                                            painter: LockedLevelPainter(),
                                          ),
                                        )
                                      : CustomPaint(
                                          painter: LockedLevelPainter(),
                                        ),
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: _spinUnlocked.value,
                          child: SizedBox(
                            width: widget.unlockedSize,
                            height: widget.unlockedSize,
                            child: CustomPaint(
                              painter: MapHolePainter(
                                isUnlocked: true,
                                biome: widget.biome,
                              ),
                            ),
                          ),
                        ),
                        if (widget.isUnlocked)
                          Positioned.fill(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: List.generate(3, (index) {
                                bool collected = index < widget.stars;
                                double angle = (index - 1) * (pi / 5.5);
                                double radius = (widget.unlockedSize / 2) + 16;
                                double dx = sin(angle) * radius;
                                double dy = -cos(angle) * radius;
                                return Transform.translate(
                                  offset: Offset(dx, dy),
                                  child: Transform.rotate(
                                    angle: angle,
                                    child: CartoonStar(
                                      isCollected: collected,
                                      size: 28,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
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
                        color: GameColors.white.withValues(alpha: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: GameColors.white.withValues(alpha: 0.8),
                            blurRadius: 40.0,
                            spreadRadius: 20.0,
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFFFFD54F,
                            ).withValues(alpha: 0.5),
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

class SuckingEffectPainter extends CustomPainter {
  final Offset ballCenter;
  final Offset holeCenter;
  final double progress;

  SuckingEffectPainter({
    required this.ballCenter,
    required this.holeCenter,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Only show effect during the second half of the flight when it gets closer to the hole
    if (progress < 0.3 || progress >= 1.0) return;

    // Fade in and out
    double opacity = 1.0;
    if (progress < 0.5) opacity = (progress - 0.3) / 0.2;
    if (progress > 0.8) opacity = (1.0 - progress) / 0.2;

    final Paint paint = Paint()
      ..color = GameColors.white.withValues(alpha: 0.6 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final double distance = (ballCenter - holeCenter).distance;
    if (distance < 5.0) return; // Too close

    final Offset direction =
        (ballCenter - holeCenter) / distance; // Vector from hole to ball

    // Draw multiple wind streaks rushing from the ball towards the hole
    for (int i = 0; i < 8; i++) {
      // Create a bit of spread
      final double angleOffset = (i - 3.5) * 0.25; // spread angle

      // Rotate the direction vector to spread them out into a cone
      final double dx =
          direction.dx * cos(angleOffset) - direction.dy * sin(angleOffset);
      final double dy =
          direction.dx * sin(angleOffset) + direction.dy * cos(angleOffset);
      final Offset spreadDir = Offset(dx, dy);

      // Streaks move from ball to hole.
      // Progress determines their position along the line.
      // To make them look like they are constantly flowing rapidly, we multiply progress by a speed factor.
      final double p = (progress * 5.0 + i * 0.15) % 1.0;

      // Start point of the streak (p=0 is at ball, p=1 is at hole)
      final Offset start = Offset.lerp(ballCenter, holeCenter, p)!;
      // End point of the streak (slightly behind start)
      final Offset end = Offset.lerp(
        ballCenter,
        holeCenter,
        (p - 0.2).clamp(0.0, 1.0),
      )!;

      // Add some outward curve using the perpendicular vector
      final Offset perp = Offset(spreadDir.dy, -spreadDir.dx);
      // The curve is wider at the ball (p=0) and pinches into the hole (p=1)
      final double curveMagnitude = (1 - p) * 50.0 * (i % 2 == 0 ? 1 : -1);
      final Offset curvedStart = start + perp * curveMagnitude;

      final double endCurveMagnitude =
          (1 - (p - 0.2).clamp(0.0, 1.0)) * 50.0 * (i % 2 == 0 ? 1 : -1);
      final Offset curvedEnd = end + perp * endCurveMagnitude;

      canvas.drawLine(curvedStart, curvedEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SuckingEffectPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ballCenter != ballCenter ||
        oldDelegate.holeCenter != holeCenter;
  }
}
