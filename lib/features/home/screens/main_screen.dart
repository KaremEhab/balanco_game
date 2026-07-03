import 'dart:ui';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/features/map/screens/map_screen.dart';
import 'package:balanco_game/features/map/widgets/map_app_bar.dart';
import 'package:balanco_game/features/home/widgets/icons/home_icon_painter.dart';
import 'package:balanco_game/features/home/widgets/icons/modes_icon_painter.dart';
import 'package:balanco_game/features/home/widgets/icons/settings_icon_painter.dart';
import 'package:balanco_game/features/settings/screens/modes_screen.dart';
import 'package:balanco_game/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:balanco_game/features/settings/screens/settings_screen.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/features/game/components/game_background/sky_painter.dart';
import 'package:balanco_game/features/game/components/game_background/mountains_painter.dart';
import 'package:balanco_game/features/game/components/game_background/sea_painter.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
    _pageController = PageController(initialPage: _currentIndex);
    _screens = [
      HomeScreen(scrollController: _mapScrollController),
      ModesScreen(scrollController: _modesScrollController),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xffCCFFFB), // Base sky color
      body: Stack(
        children: [
          // Parallax Background
          Positioned.fill(child: _buildParallaxBackground()),

          // Global Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: ColoredBox(
                color: const Color(0xff44C1FF).withValues(alpha: 0.1),
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

          // Floating Top App Bar (Profile, Stats) - Always Fixed
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
            child: RepaintBoundary(child: _buildTopAppBar()),
          ),

          // Collapsible Center Navbar
          Positioned(
            bottom: 20,
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
        child: CustomPaint(size: const Size(1000, 475), painter: painter),
      ),
    );
  }

  Widget _buildParallaxBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _mapScrollController,
        _modesScrollController,
        _settingsScrollController,
        _pageController,
      ]),
      builder: (context, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: AppSettings.parallaxEnabled,
          builder: (context, isParallax, child) {
            return FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
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
                    // Trees are commented out in gameplay, but if we want them:
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopAppBar() {
    return ValueListenableBuilder<double>(
      valueListenable: _expandProgressNotifier,
      builder: (context, expandProgress, child) {
        return MapAppBar(
          highestLevel: _highestLevel,
          coins: _coins,
          sparks: 2, // Defaulting to 2 as per the previous mockup
          maxSparks: 5,
          expandProgress: expandProgress,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
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
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFA428), Color(0xFFF54812)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
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
                  color: Colors.white.withValues(alpha: 0.7),
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
                      color: const Color(0xffFFF8F3),
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
