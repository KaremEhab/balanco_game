import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../data/database_helper.dart';
import '../map/map_screen.dart';
import 'modes_screen.dart';
import 'bg_editor_screen.dart';

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
      MapScreen(scrollController: _mapScrollController),
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
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        children: [
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

  Widget _buildTopAppBar() {
    Color textColor = Colors.white;
    Color strokeColor = const Color(0xFF0277BD);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF29B6F6), // Sea Blue
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF0288D1), width: 3.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 0,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x55FFFFFF),
            blurRadius: 0,
            offset: Offset(0, -3),
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
              border: Border.all(color: strokeColor, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                        color: strokeColor, // Deep Blue Background
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 1.5),
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
                        color: const Color(0xFF4CAF50), // Vibrant Green
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: strokeColor, width: 1.5),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: strokeColor, width: 1.5),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF29B6F6), // Sea Blue
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: const Color(0xFF0288D1), // Deep Sea Outline
          width: 3.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000), // Hard shadow
            blurRadius: 0,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x55FFFFFF), // White foam inner top highlight
            blurRadius: 0,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem(icon: Icons.map, label: 'Map', index: 0),
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
              ? const Color(0xFFFFD54F) // Sandy Beach yellow when selected
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF2C3E50),
                  width: 2.5,
                ) // Steel Ball Dark Outline
              : Border.all(color: Colors.transparent, width: 2.5),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 0,
                    offset: Offset(0, 3),
                  ),
                  BoxShadow(
                    color: Color(0x55FFFFFF), // Sun glare highlight
                    blurRadius: 0,
                    offset: Offset(0, -2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF2C3E50) // Steel ball metallic dark
                  : Colors.white.withValues(alpha: 0.9), // Sea foam white
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.luckiestGuy(
                  textStyle: const TextStyle(
                    color: Color(0xFF2C3E50), // Steel ball metallic dark
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
