import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../data/database_helper.dart';
import '../map/home_screen.dart';
import 'modes_screen.dart';
import 'bg_editor_screen.dart';
import '../game/components/game_background/sky_painter.dart';
import '../game/components/game_background/mountains_painter.dart';
import '../game/components/game_background/sea_painter.dart';
import '../game/components/game_background/trees_painter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final ScrollController _mapScrollController = ScrollController();
  double _lastOffset = 0;

  late List<Widget> _screens;

  bool _isNavbarVisible = true;
  int _currentLevel = 1;
  int _coins = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _screens = [
      HomeScreen(scrollController: _mapScrollController),
      const ModesScreen(),
      BgEditorScreen(
        onExit: () {
          setState(() {
            _currentIndex = 0;
            _isNavbarVisible = true;
          });
        },
      ),
      // const MapEditorScreen(),
    ];

    _mapScrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {
    final profile = await DatabaseHelper.instance.getPlayerProfile();
    if (!mounted) return;
    setState(() {
      _currentLevel = profile.lastPlayedLevel;
      _coins = profile.coins;
      _streak = profile.streak;
    });
  }

  void _scrollListener() {
    if (_mapScrollController.offset > _lastOffset + 10 && _isNavbarVisible) {
      // Scrolling up to higher levels
      setState(() => _isNavbarVisible = false);
      _lastOffset = _mapScrollController.offset;
    } else if (_mapScrollController.offset < _lastOffset - 10 &&
        !_isNavbarVisible) {
      // Scrolling down to lower levels
      setState(() => _isNavbarVisible = true);
      _lastOffset = _mapScrollController.offset;
    } else if ((_mapScrollController.offset - _lastOffset).abs() > 10) {
      _lastOffset = _mapScrollController.offset;
    }
  }

  @override
  void dispose() {
    _mapScrollController.removeListener(_scrollListener);
    _mapScrollController.dispose();
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

          // Main Content
          IndexedStack(index: _currentIndex, children: _screens),

          // Floating Top App Bar (Profile, Stats) - Always Fixed
          if (_currentIndex != 2)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              child: RepaintBoundary(child: _buildTopAppBar()),
            ),

          // Collapsible Center Navbar
          if (_currentIndex != 2)
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
  }) {
    double scrollOffset = 0;
    double maxScroll = 1.0;

    if (_mapScrollController.hasClients &&
        _mapScrollController.position.hasContentDimensions) {
      scrollOffset = _mapScrollController.offset;
      maxScroll = _mapScrollController.position.maxScrollExtent;
      if (maxScroll <= 0) maxScroll = 1.0;
    }

    // Normalize scroll to prevent background flying off screen
    // The map is very tall (thousands of pixels), so we map the full scroll
    // to a maximum of 250 pixels of parallax movement.
    double scrollProgress = (scrollOffset / maxScroll).clamp(0.0, 1.0);

    // When scrollProgress is 1.0 (bottom, Level 1), the camera is at the bottom.
    // When scrollProgress is 0.0 (top, max Level), the camera is at the top.
    // So as the camera goes up (progress 1 -> 0), the background should move DOWN (positive dy).
    double verticalParallax = (1.0 - scrollProgress) * 250.0 * depthMultiplier;

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
      animation: _mapScrollController,
      builder: (context, child) {
        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 1000,
            height: 475,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildLayer(SkyPainter(), depthMultiplier: 0.05),
                _buildLayer(
                  FirstCloudPainter(),
                  dx: 193.1,
                  dy: 46.5,
                  scale: 0.39,
                  depthMultiplier: 0.1,
                ),
                _buildLayer(
                  SecondCloudPainter(),
                  dx: -6.1,
                  dy: 7.1,
                  scale: 0.26,
                  depthMultiplier: 0.12,
                ),
                _buildLayer(
                  ThirdCloudPainter(),
                  dx: 59.7,
                  dy: 15.7,
                  scale: 0.46,
                  depthMultiplier: 0.14,
                ),
                _buildLayer(
                  ForthCloudPainter(),
                  dx: 305.0,
                  dy: 27.0,
                  scale: 0.63,
                  depthMultiplier: 0.16,
                ),
                _buildLayer(
                  FifthCloudPainter(),
                  dx: 127.3,
                  dy: -85.9,
                  scale: 0.48,
                  depthMultiplier: 0.18,
                ),
                _buildLayer(
                  BirdsPainter(),
                  dx: 230.1,
                  dy: -11.4,
                  scale: 0.57,
                  depthMultiplier: 0.2,
                ),
                _buildLayer(
                  FurtherSeaPainter(),
                  dx: 0.0,
                  dy: 214.0,
                  scale: 1.05,
                  depthMultiplier: 0.4,
                ),
                _buildLayer(
                  MountainSeaShadowsPainter(),
                  dx: 52.8,
                  dy: 166.4,
                  scale: 0.47,
                  depthMultiplier: 0.5,
                ),
                _buildLayer(
                  BackMountainPainter(),
                  dx: 122.0,
                  dy: 42.6,
                  scale: 0.50,
                  depthMultiplier: 0.3,
                ),
                _buildLayer(
                  CloserSeaPainter(),
                  dx: 166.9,
                  dy: 401.3,
                  scale: 1.42,
                  depthMultiplier: 0.6,
                ),
                _buildLayer(
                  SeaWaterDropsPainter(),
                  dx: 112.6,
                  dy: 246.1,
                  scale: 0.51,
                  depthMultiplier: 0.7,
                ),
                _buildLayer(
                  FrontMountainPainter(),
                  dx: 73.2,
                  dy: 35.3,
                  scale: 0.32,
                  depthMultiplier: 0.8,
                ),
                _buildLayer(
                  SeaMountainWaves(),
                  dx: 7.1,
                  dy: 9.6,
                  scale: 0.27,
                  depthMultiplier: 0.45,
                ),
                // Trees are commented out in gameplay, but if we want them:
                // _buildLayer(LeftTreePainter(), depthMultiplier: 1.0),
                // _buildLayer(RightTreePainter(), depthMultiplier: 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopAppBar() {
    Color textColor = Colors.white;
    Color strokeColor = const Color(0xFF0277BD);

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF36D4C7).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
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
          child: Row(
            children: [
              // 1. Profile Picture
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F), // Sandy Yellow
                  shape: BoxShape.circle,
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
                child: Icon(Icons.person_rounded, color: strokeColor, size: 28),
              ),
              const SizedBox(width: 10),

              // 2. Name, Level, Money
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Player 1',
                      style: GoogleFonts.luckiestGuy(
                        color: textColor,
                        fontSize: 16,
                        height: 1.0,
                        shadows: [
                          Shadow(
                            color: strokeColor,
                            offset: const Offset(0, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // LVL
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.2,
                            ), // Glassy
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            'LVL $_currentLevel',
                            style: GoogleFonts.luckiestGuy(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  offset: const Offset(0, 1.5),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CircleAvatar(
                            backgroundColor: strokeColor,
                            radius: 2.5,
                          ),
                        ),
                        // Money
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.2,
                            ), // Glassy
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1.0,
                            ),
                          ),
                          child: _buildBeachStatBadge(
                            icon: Icons.monetization_on,
                            iconColor: const Color(0xFFFFD54F), // Gold Icon
                            value: '$_coins',
                            strokeColor: strokeColor,
                            textColor: Colors.white,
                            iconSize: 16,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Streak (centered vertically)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2), // Glassy
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'STREAK',
                      style: GoogleFonts.luckiestGuy(
                        color: Colors.white,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            color: strokeColor,
                            offset: const Offset(0, 1),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    _buildBeachStatBadge(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: Colors.white,
                      value: '$_streak',
                      strokeColor: strokeColor,
                      textColor: textColor,
                      iconSize: 16,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeachStatBadge({
    required IconData icon,
    required Color iconColor,
    required String value,
    required Color strokeColor,
    required Color textColor,
    double iconSize = 18,
    double fontSize = 16,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
            shadows: [
              Shadow(
                color: strokeColor,
                offset: const Offset(0, 1.5),
                blurRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          value,
          style: GoogleFonts.luckiestGuy(
            color: textColor,
            fontSize: fontSize,
            shadows: [
              Shadow(
                color: strokeColor,
                offset: const Offset(0, 2),
                blurRadius: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingNavbar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF36D4C7).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
              const SizedBox(width: 10),
              _buildNavItem(icon: Icons.category, label: 'Modes', index: 1),
              const SizedBox(width: 10),
              _buildNavItem(icon: Icons.layers, label: 'Bg Edit', index: 2),
              // const SizedBox(width: 10),
              // _buildNavItem(
              //   icon: Icons.settings,
              //   label: 'Edit',
              //   index: 3,
              // ),
            ],
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _isNavbarVisible = true;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1.5,
                )
              : Border.all(color: Colors.transparent, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
