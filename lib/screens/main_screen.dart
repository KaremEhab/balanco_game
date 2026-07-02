import 'dart:ui';
import 'package:balanco_game/data/database_helper.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../map/home_screen.dart';
import '../screens/home/map_app_bar.dart';
import '../screens/home/home_icon_painter.dart';
import '../screens/home/modes_icon_painter.dart';
import '../screens/home/settings_icon_painter.dart';
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
  int _highestLevel = 1;
  int _coins = 0;

  final GlobalKey _rowKey = GlobalKey();
  final List<GlobalKey> _navKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  double _indicatorLeft = 0;
  double _indicatorWidth = 0;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  void _updateIndicator() {
    if (!mounted) return;
    final key = _navKeys[_currentIndex];
    if (key.currentContext != null && _rowKey.currentContext != null) {
      final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final RenderBox parentBox = _rowKey.currentContext!.findRenderObject() as RenderBox;
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
              left: 15,
              right: 15,
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
    return MapAppBar(
      highestLevel: _highestLevel,
      coins: _coins,
      sparks: 2, // Defaulting to 2 as per the previous mockup
      maxSparks: 5,
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
                    _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
                    const SizedBox(width: 10),
                    _buildNavItem(icon: Icons.category, label: 'Modes', index: 1),
                    const SizedBox(width: 10),
                    _buildNavItem(icon: Icons.settings, label: 'Settings', index: 2),
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
        setState(() {
          _currentIndex = index;
          _isNavbarVisible = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _updateIndicator());
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
