import 'dart:ui';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/core/data/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/features/map/screens/map_screen.dart';
import 'package:balanco_game/features/map/widgets/map_app_bar.dart';
import 'package:balanco_game/features/home/widgets/icons/home_icon_painter.dart';
import 'package:balanco_game/features/home/widgets/icons/modes_icon_painter.dart';
import 'package:balanco_game/features/home/widgets/icons/settings_icon_painter.dart';
import 'package:balanco_game/features/settings/screens/modes_screen.dart';
import 'package:balanco_game/features/settings/screens/settings_screen.dart';
import 'package:balanco_game/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sky_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/mountains_painter.dart';
import 'package:balanco_game/features/map/backgrounds/beach/sea_painter.dart';
import 'package:balanco_game/features/game/components/game_background/biome_background_transition.dart';
import 'package:balanco_game/features/game/components/game_background/pyramids_painter.dart';
import 'package:balanco_game/features/game/components/game_background/level_group_painters.dart';

import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final ScrollController _mapScrollController = ScrollController();
  final ScrollController _modesScrollController = ScrollController();
  final ScrollController _leaderboardScrollController = ScrollController();
  final ScrollController _settingsScrollController = ScrollController();
  late PageController _pageController;
  final ValueNotifier<double> _expandProgressNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> biomeTransitionProgress = ValueNotifier(0.0);
  final ValueNotifier<BiomeModel?> currentBiomeNotifier = ValueNotifier(null);
  final ValueNotifier<BiomeModel?> previousBiomeNotifier = ValueNotifier(null);
  double _lastOffset = 0;
  double _lastScrollProgress = 1.0; // Default to bottom (Level 1)

  late List<Widget> _screens;

  bool _isNavbarVisible = true;
  int _highestLevel = 1;
  int _coins = 0;

  final GlobalKey _rowKey = GlobalKey();
  final List<GlobalKey> _navKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  double _indicatorLeft = 0;
  double _indicatorWidth = 0;

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  @override
  void initState() {
    super.initState();
    _loadData();
    _pageController = PageController(initialPage: _currentIndex);
    _screens = [
      HomeScreen(
        key: _homeKey,
        scrollController: _mapScrollController,
        biomeTransitionProgress: biomeTransitionProgress,
        currentBiomeNotifier: currentBiomeNotifier,
        previousBiomeNotifier: previousBiomeNotifier,
        onReturnFromGame: _loadData,
      ),
      ModesScreen(
        scrollController: _modesScrollController,
        onReturnFromGame: _loadData,
      ),
      LeaderboardScreen(scrollController: _leaderboardScrollController),
      SettingsScreen(scrollController: _settingsScrollController),
    ];

    _mapScrollController.addListener(_scrollListener);
    _modesScrollController.addListener(_scrollListener);
    _leaderboardScrollController.addListener(_scrollListener);
    _settingsScrollController.addListener(_scrollListener);
    _pageController.addListener(_onPageOrScrollChanged);
    _modesScrollController.addListener(_onPageOrScrollChanged);
    _leaderboardScrollController.addListener(_onPageOrScrollChanged);
    _settingsScrollController.addListener(_onPageOrScrollChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  void _onPageOrScrollChanged() {
    if (!mounted) return;

    double page = _pageController.hasClients
        ? (_pageController.page ?? _currentIndex.toDouble())
        : _currentIndex.toDouble();
    // 0.0 at Leaderboard, 1.0 at Settings
    double horizontalProgress = (page - 2.0).clamp(0.0, 1.0);

    double verticalProgress = 0.0;
    if (_settingsScrollController.hasClients) {
      // Allow scrolling 150px to collapse fully
      verticalProgress = (_settingsScrollController.offset / 150.0).clamp(
        0.0,
        1.0,
      );
    }

    _expandProgressNotifier.value =
        horizontalProgress * (1.0 - verticalProgress);
  }

  void _updateIndicator() {
    if (!mounted) return;
    final key = _navKeys[_currentIndex];
    if (key.currentContext != null && _rowKey.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final RenderBox parentBox =
          _rowKey.currentContext!.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero, ancestor: parentBox);
      setState(() {
        _indicatorLeft = offset.dx;
        _indicatorWidth = renderBox.size.width;
      });
    }
  }

  Future<void> _loadData() async {
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    if (!mounted) return;
    setState(() {
      _highestLevel = profile.highestLevel;
      _coins = profile.coins;
    });
    AppSettings.playMenuBgm();
  }

  void _scrollListener() {
    ScrollController activeController;
    if (_currentIndex == 0) {
      activeController = _mapScrollController;
    } else if (_currentIndex == 1) {
      activeController = _modesScrollController;
    } else if (_currentIndex == 2) {
      activeController = _leaderboardScrollController;
    } else {
      activeController = _settingsScrollController;
    }

    if (!activeController.hasClients) return;

    if (activeController.offset > _lastOffset + 10 && _isNavbarVisible) {
      // Scrolling down page
      setState(() => _isNavbarVisible = false);
      _lastOffset = activeController.offset;
    } else if (activeController.offset < _lastOffset - 10 &&
        !_isNavbarVisible) {
      // Scrolling up page
      setState(() => _isNavbarVisible = true);
      _lastOffset = activeController.offset;
    } else if ((activeController.offset - _lastOffset).abs() > 10) {
      _lastOffset = activeController.offset;
    }
  }

  @override
  void dispose() {
    _mapScrollController.removeListener(_scrollListener);
    _mapScrollController.dispose();
    _modesScrollController.removeListener(_scrollListener);
    _modesScrollController.removeListener(_onPageOrScrollChanged);
    _modesScrollController.dispose();
    _leaderboardScrollController.removeListener(_scrollListener);
    _leaderboardScrollController.removeListener(_onPageOrScrollChanged);
    _leaderboardScrollController.dispose();
    _pageController.removeListener(_onPageOrScrollChanged);
    _pageController.dispose();
    _settingsScrollController.removeListener(_onPageOrScrollChanged);
    _settingsScrollController.removeListener(_scrollListener);
    _settingsScrollController.dispose();
    _expandProgressNotifier.dispose();
    biomeTransitionProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Parallax Background
          Positioned.fill(child: _buildParallaxBackground()),

          // Global Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: ColoredBox(
                color: GameColors.mainScreenColor1.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main Content
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _isNavbarVisible = true;
              });

              if (index != 0 &&
                  _mapScrollController.hasClients &&
                  _mapScrollController.position.hasContentDimensions) {
                _mapScrollController.jumpTo(
                  _mapScrollController.position.maxScrollExtent,
                );
              }
              if (index != 1 &&
                  _modesScrollController.hasClients &&
                  _modesScrollController.position.hasContentDimensions) {
                _modesScrollController.jumpTo(0);
              }
              if (index != 2 &&
                  _leaderboardScrollController.hasClients &&
                  _leaderboardScrollController.position.hasContentDimensions) {
                _leaderboardScrollController.jumpTo(0);
              }
              if (index != 3 &&
                  _settingsScrollController.hasClients &&
                  _settingsScrollController.position.hasContentDimensions) {
                _settingsScrollController.jumpTo(0);
              }

              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _updateIndicator(),
              );
            },
            children: _screens,
          ),

          // ─── Top & Bottom Blur & Gradient Overlays (Global) ───────────────
          AnimatedBuilder(
            animation: Listenable.merge([
              currentBiomeNotifier,
              previousBiomeNotifier,
              biomeTransitionProgress,
            ]),
            builder: (context, child) {
              final currentBiome = currentBiomeNotifier.value;
              final previousBiome = previousBiomeNotifier.value ?? currentBiome;
              final progress = biomeTransitionProgress.value;

              final Color interpolatedColor = currentBiome == null
                  ? GameColors.mainScreenColor1
                  : Color.lerp(
                          previousBiome?.primaryColor ??
                              currentBiome.primaryColor,
                          currentBiome.primaryColor,
                          progress,
                        ) ??
                        currentBiome.primaryColor;

              final double topHeight = MediaQuery.of(context).padding.top + 80;
              final double bottomHeight =
                  MediaQuery.of(context).padding.bottom + 60;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Top Color Gradient
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: topHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            interpolatedColor.withValues(alpha: 0.4),
                            interpolatedColor.withValues(alpha: 0.0),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Color Gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: bottomHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            interpolatedColor.withValues(alpha: 0.4),
                            interpolatedColor.withValues(alpha: 0.0),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Floating Top App Bar (Profile, Stats) - Always Fixed
          Positioned(
            top:
                (defaultTargetPlatform == TargetPlatform.iOS ? 5 : 10) +
                MediaQuery.of(context).padding.top,
            left: 15,
            right: 15,
            child: RepaintBoundary(child: _buildTopAppBar()),
          ),

          // Collapsible Center Navbar
          Positioned(
            bottom:
                (defaultTargetPlatform == TargetPlatform.iOS ? 8 : 20) +
                MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (!_isNavbarVisible) {
                  setState(() => _isNavbarVisible = true);
                }
              },
              onVerticalDragUpdate: (details) {
                // Dragging downwards
                if (details.primaryDelta! > 0 && !_isNavbarVisible) {
                  setState(() => _isNavbarVisible = true);
                }
              },
              child: AnimatedScale(
                scale: _isNavbarVisible ? 1.0 : 0.75,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  opacity: _isNavbarVisible ? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    // Use a RepaintBoundary for the complex cartoon shadows and borders
                    child: RepaintBoundary(child: _buildFloatingNavbar()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayer(
    CustomPainter painter, {
    double dx = 0,
    double dy = 0,
    double scale = 1.0,
    double depthMultiplier = 0.0,
    bool parallaxEnabled = true,
  }) {
    double scrollProgress = 1.0;

    ScrollController activeController;
    if (_currentIndex == 0) {
      activeController = _mapScrollController;
    } else if (_currentIndex == 1) {
      activeController = _modesScrollController;
    } else if (_currentIndex == 2) {
      activeController = _leaderboardScrollController;
    } else {
      activeController = _settingsScrollController;
    }

    if (activeController.hasClients &&
        activeController.position.hasContentDimensions) {
      double scrollOffset = activeController.offset;
      double maxScroll = activeController.position.maxScrollExtent;
      if (maxScroll <= 0) maxScroll = 1.0;

      if (_currentIndex == 0) {
        scrollProgress = (scrollOffset / maxScroll).clamp(0.0, 1.0);
      } else {
        // Slow down parallax on Settings and Modes pages
        // by dividing the offset by a larger fixed number instead of the small maxScroll
        double simulatedMaxScroll = 2500.0;
        scrollProgress =
            1.0 + (scrollOffset / simulatedMaxScroll).clamp(0.0, 1.0);
      }
      _lastScrollProgress = scrollProgress;
    } else {
      scrollProgress = _lastScrollProgress;
    }

    // When scrollProgress is 1.0 (bottom, Level 1), the camera is at the bottom.
    // When scrollProgress is 0.0 (top, max Level), the camera is at the top.
    // So as the camera goes up (progress 1 -> 0), the background should move DOWN (positive dy).
    double verticalParallax = parallaxEnabled
        ? (1.0 - scrollProgress) * 250.0 * depthMultiplier
        : 0.0;

    return Transform.translate(
      offset: Offset(dx, dy + verticalParallax),
      child: Transform.scale(
        scale: scale,
        child: RepaintBoundary(
          child: CustomPaint(size: const Size(1000, 475), painter: painter),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_mapScrollController]),
      builder: (context, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: AppSettings.parallaxEnabled,
          builder: (context, isParallax, child) {
            Widget beachParallax = SizedBox(
              width: 1000,
              height: 475,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildLayer(
                    SkyPainter(),
                    depthMultiplier: 0.05,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    FirstCloudPainter(),
                    dx: 193.1,
                    dy: 46.5,
                    scale: 0.39,
                    depthMultiplier: 0.1,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    SecondCloudPainter(),
                    dx: -6.1,
                    dy: 7.1,
                    scale: 0.26,
                    depthMultiplier: 0.12,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    ThirdCloudPainter(),
                    dx: 59.7,
                    dy: 15.7,
                    scale: 0.46,
                    depthMultiplier: 0.14,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    ForthCloudPainter(),
                    dx: 305.0,
                    dy: 27.0,
                    scale: 0.63,
                    depthMultiplier: 0.16,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    FifthCloudPainter(),
                    dx: 127.3,
                    dy: -85.9,
                    scale: 0.48,
                    depthMultiplier: 0.18,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    BirdsPainter(),
                    dx: 230.1,
                    dy: -11.4,
                    scale: 0.57,
                    depthMultiplier: 0.2,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    FurtherSeaPainter(),
                    dx: 0.0,
                    dy: 214.0,
                    scale: 1.05,
                    depthMultiplier: 0.4,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    MountainSeaShadowsPainter(),
                    dx: 52.8,
                    dy: 166.4,
                    scale: 0.47,
                    depthMultiplier: 0.5,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    BackMountainPainter(),
                    dx: 122.0,
                    dy: 42.6,
                    scale: 0.50,
                    depthMultiplier: 0.3,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    CloserSeaPainter(),
                    dx: 166.9,
                    dy: 401.3,
                    scale: 1.42,
                    depthMultiplier: 0.6,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    SeaWaterDropsPainter(),
                    dx: 112.6,
                    dy: 246.1,
                    scale: 0.51,
                    depthMultiplier: 0.7,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    FrontMountainPainter(),
                    dx: 73.2,
                    dy: 35.3,
                    scale: 0.32,
                    depthMultiplier: 0.8,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    SeaMountainWaves(),
                    dx: 7.1,
                    dy: 9.6,
                    scale: 0.27,
                    depthMultiplier: 0.45,
                    parallaxEnabled: isParallax,
                  ),
                ],
              ),
            );

            Widget pyramidParallax = SizedBox(
              width: 1000,
              height: 475,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildLayer(
                    PyramidSkyPainter(),
                    depthMultiplier: 0.0,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    WispyCloudPainter(),
                    depthMultiplier: 0.1,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    DistantMountainsPainter(),
                    depthMultiplier: 0.2,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    MainPyramidsPainter(),
                    depthMultiplier: 0.4,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    MidgroundDunesPainter(),
                    depthMultiplier: 0.7,
                    parallaxEnabled: isParallax,
                  ),
                  _buildLayer(
                    ForegroundDunesPainter(),
                    depthMultiplier: 1.0,
                    parallaxEnabled: isParallax,
                  ),
                ],
              ),
            );

            return ValueListenableBuilder<BiomeModel?>(
              valueListenable: currentBiomeNotifier,
              builder: (context, currentBiome, child) {
                return ValueListenableBuilder<BiomeModel?>(
                  valueListenable: previousBiomeNotifier,
                  builder: (context, previousBiome, child) {
                    return ValueListenableBuilder<double>(
                      valueListenable: biomeTransitionProgress,
                      builder: (context, progress, child) {
                        final activeBiome =
                            currentBiome ?? BiomeConfig.tropicalBeach;
                        final outgoingBiome = previousBiome ?? activeBiome;

                        Widget sceneFor(BiomeModel biome) {
                          final index = BiomeConfig.getBiomeIndex(biome);
                          if (index == 0) return beachParallax;
                          if (index == 1) return pyramidParallax;
                          return SizedBox(
                            width: 1000,
                            height: 475,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                for (final layer in levelGroupLayers(biome))
                                  _buildLayer(
                                    layer.painter,
                                    dx: layer.dx,
                                    dy: layer.dy,
                                    scale: layer.scale,
                                    depthMultiplier: layer.depth,
                                    parallaxEnabled: isParallax,
                                  ),
                              ],
                            ),
                          );
                        }

                        final transitionProgress = previousBiome == null
                            ? 1.0
                            : progress;

                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: GameColors
                              .mapAppBarCyanLightest, // fallback color
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: BiomeBackgroundTransition(
                              tropical: sceneFor(outgoingBiome),
                              pyramids: sceneFor(activeBiome),
                              progress: transitionProgress,
                              tropicalTint: outgoingBiome.primaryColor
                                  .withValues(alpha: 0.08),
                              pyramidTint: activeBiome.primaryColor.withValues(
                                alpha: 0.10,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTopAppBar() {
    return ValueListenableBuilder<BiomeModel?>(
      valueListenable: currentBiomeNotifier,
      builder: (context, currentBiome, child) {
        return ValueListenableBuilder<BiomeModel?>(
          valueListenable: previousBiomeNotifier,
          builder: (context, previousBiome, child) {
            return ValueListenableBuilder<double>(
              valueListenable: _expandProgressNotifier,
              builder: (context, expandProgress, child) {
                return ValueListenableBuilder<PlayerProfile?>(
                  valueListenable: DatabaseHelper.instance.profileNotifier,
                  builder: (context, profile, _) {
                    return MapAppBar(
                      highestLevel: profile?.highestLevel ?? _highestLevel,
                      coins: profile?.coins ?? _coins,
                      sparks: 2, // Defaulting to 2 as per the previous mockup
                      maxSparks: 5,
                      expandProgress: expandProgress,
                      biomeTransitionProgress: biomeTransitionProgress,
                      currentBiome: currentBiome,
                      previousBiome: previousBiome,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingNavbar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: ValueListenableBuilder<BiomeModel?>(
            valueListenable: currentBiomeNotifier,
            builder: (context, currentBiome, child) {
              return ValueListenableBuilder<BiomeModel?>(
                valueListenable: previousBiomeNotifier,
                builder: (context, previousBiome, child) {
                  return ValueListenableBuilder<double>(
                    valueListenable: biomeTransitionProgress,
                    builder: (context, progress, child) {
                      // Previous Biome colors
                      final Color prevPrimary =
                          previousBiome?.primaryColor ??
                          GameColors.mapAppBarTealDark;
                      final Color prevSecondary =
                          previousBiome?.secondaryColor ??
                          GameColors.mapAppBarCyanLight;
                      final Color prevContainerColor = prevSecondary.withValues(
                        alpha: 0.3,
                      );

                      // Current Biome colors
                      final Color currPrimary =
                          currentBiome?.primaryColor ??
                          GameColors.mapAppBarTealDark;
                      final Color currSecondary =
                          currentBiome?.secondaryColor ??
                          GameColors.mapAppBarCyanLight;
                      final Color currContainerColor = currSecondary.withValues(
                        alpha: 0.3,
                      );

                      // Blended Colors
                      final Color containerColor = Color.lerp(
                        prevContainerColor,
                        currContainerColor,
                        progress,
                      )!;
                      final Color borderColor = Color.lerp(
                        prevPrimary,
                        currPrimary,
                        progress,
                      )!;

                      // Indicator colors
                      final Color prevIndicatorColor =
                          previousBiome?.primaryColor ??
                          GameColors.playButtonPainterColor10;
                      final Color currIndicatorColor =
                          currentBiome?.primaryColor ??
                          GameColors.playButtonPainterColor10;
                      final Color blendedIndicatorColor = Color.lerp(
                        prevIndicatorColor,
                        currIndicatorColor,
                        progress,
                      )!;

                      final Color prevIndicatorLight =
                          previousBiome?.secondaryColor ??
                          GameColors.playButtonPainterColor9;
                      final Color currIndicatorLight =
                          currentBiome?.secondaryColor ??
                          GameColors.playButtonPainterColor9;
                      final Color blendedIndicatorLight = Color.lerp(
                        prevIndicatorLight,
                        currIndicatorLight,
                        progress,
                      )!;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: borderColor, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: GameColors.white.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Stack(
                          key: _rowKey,
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              left: _indicatorLeft,
                              width: _indicatorWidth,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      blendedIndicatorColor,
                                      blendedIndicatorLight,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: GameColors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: GameColors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildNavItem(
                                  icon: Icons.home_rounded,
                                  label: 'Home',
                                  index: 0,
                                ),
                                const SizedBox(width: 10),
                                _buildNavItem(
                                  icon: Icons.category,
                                  label: 'Modes',
                                  index: 1,
                                ),
                                const SizedBox(width: 10),
                                _buildNavItem(
                                  icon: Icons.leaderboard_rounded,
                                  label: 'Rank',
                                  index: 2,
                                ),
                                const SizedBox(width: 10),
                                _buildNavItem(
                                  icon: Icons.settings,
                                  label: 'Settings',
                                  index: 3,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = _currentIndex == index;
    double iconSize = isSelected ? 28.0 : 22.0;

    return GestureDetector(
      key: _navKeys[index],
      onTap: () {
        if (index == 0) {
          _homeKey.currentState?.scrollToCurrentLevel(animate: true);
        }
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 18,
          right: 16,
          top: 10,
          bottom: isSelected ? 6 : 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isSelected) ...[
              if (icon == Icons.home_rounded)
                CustomPaint(
                  size: Size(iconSize, iconSize),
                  painter: HomeIconPainter(),
                )
              else if (icon == Icons.category)
                CustomPaint(
                  size: Size(iconSize, iconSize),
                  painter: ModesIconPainter(),
                )
              else if (icon == Icons.settings)
                CustomPaint(
                  size: Size(iconSize, iconSize),
                  painter: SettingsIconPainter(),
                )
              else
                Icon(
                  icon,
                  color: GameColors.white.withValues(alpha: 0.7),
                  size: iconSize,
                ),
            ],
            if (isSelected)
              Stack(
                children: [
                  Text(
                    label,
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 20,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = const Color.fromARGB(255, 126, 40, 17),
                      shadows: [
                        const Shadow(
                          color: Color.fromARGB(255, 104, 28, 4),
                          blurRadius: 0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 20,
                      color: GameColors.mapScreenColor4,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
