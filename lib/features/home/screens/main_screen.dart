import 'dart:async';
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
import 'package:balanco_game/core/widgets/level_gradient_background.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/notifications/application/notification_inbox_controller.dart';
import 'package:balanco_game/features/notifications/application/notification_service.dart';
import 'package:balanco_game/features/notifications/presentation/notifications_screen.dart';
import 'package:balanco_game/features/coop/application/active_room_controller.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/presentation/active_room_resume_card.dart';
import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final ScrollController _mapScrollController = ScrollController();
  final ScrollController _modesScrollController = ScrollController();
  final ScrollController _notificationsScrollController = ScrollController();
  final ScrollController _leaderboardScrollController = ScrollController();
  final ScrollController _settingsScrollController = ScrollController();
  late PageController _pageController;
  late final NotificationInboxController _notificationInboxController;
  late final ActiveRoomController _activeRoomController;
  final ValueNotifier<double> _expandProgressNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> biomeTransitionProgress = ValueNotifier(0.0);
  final ValueNotifier<BiomeModel?> currentBiomeNotifier = ValueNotifier(null);
  final ValueNotifier<BiomeModel?> previousBiomeNotifier = ValueNotifier(null);
  double _lastOffset = 0;

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
    GlobalKey(),
  ];
  double _indicatorLeft = 0;
  double _indicatorWidth = 0;

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _activeRoomController = ActiveRoomController(
      CoopRepository(Supabase.instance.client),
    );
    unawaited(_activeRoomController.refresh());
    unawaited(_loadData());
    _pageController = PageController(initialPage: _currentIndex);
    _notificationInboxController = NotificationInboxController(
      Supabase.instance.client,
    );
    unawaited(_notificationInboxController.start());
    NotificationService.instance.requestedRoute.addListener(
      _handleNotificationRoute,
    );
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
      NotificationsScreen(
        controller: _notificationInboxController,
        scrollController: _notificationsScrollController,
      ),
      LeaderboardScreen(scrollController: _leaderboardScrollController),
      SettingsScreen(scrollController: _settingsScrollController),
    ];

    _mapScrollController.addListener(_scrollListener);
    _modesScrollController.addListener(_scrollListener);
    _notificationsScrollController.addListener(_scrollListener);
    _leaderboardScrollController.addListener(_scrollListener);
    _settingsScrollController.addListener(_scrollListener);
    _pageController.addListener(_onPageOrScrollChanged);
    _modesScrollController.addListener(_onPageOrScrollChanged);
    _notificationsScrollController.addListener(_onPageOrScrollChanged);
    _leaderboardScrollController.addListener(_onPageOrScrollChanged);
    _settingsScrollController.addListener(_onPageOrScrollChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndicator();
      // A notification can launch Balanco before MainScreen attaches its
      // listener. Consume the retained route after the first frame as well.
      _handleNotificationRoute();
    });
  }

  void _onPageOrScrollChanged() {
    if (!mounted) return;

    double page = _pageController.hasClients
        ? (_pageController.page ?? _currentIndex.toDouble())
        : _currentIndex.toDouble();
    // 0.0 at Leaderboard, 1.0 at Settings.
    double horizontalProgress = (page - 3.0).clamp(0.0, 1.0);

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

  void _handleNotificationRoute() {
    final route = NotificationService.instance.requestedRoute.value;
    if (route == null || !mounted) return;
    if (!_pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _handleNotificationRoute(),
      );
      return;
    }
    NotificationService.instance.requestedRoute.value = null;
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_activeRoomController.refresh());
    }
  }

  Future<void> _resumeActiveRoom() async {
    final room = await _activeRoomController.prepareResume();
    if (!mounted) return;
    if (room == null) {
      final message =
          _activeRoomController.error ?? 'That room is no longer active.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
      ),
    );
    if (mounted) unawaited(_activeRoomController.refresh());
  }

  Future<void> _discardActiveRoom() async {
    final room = _activeRoomController.room;
    if (room == null) return;
    final mode = room.isRace ? 'Race' : 'CO-OP';
    final names = room.members
        .map((member) => member.displayName)
        .where((name) => name.trim().isNotEmpty)
        .join(', ');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: GameColors.sandLightUi,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
        ),
        title: Text('LEAVE $mode ROOM?', style: GoogleFonts.luckiestGuy()),
        content: Text(
          'Room ${room.code} • ${room.members.length} players\n$names\n\n'
          'This removes the resume card. A CO-OP room closes for both players; '
          'in Race, only you leave.',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('KEEP IT'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('LEAVE ROOM'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final discarded = await _activeRoomController.discard();
    if (!mounted) return;
    final message = discarded
        ? '$mode room closed.'
        : (_activeRoomController.error ?? 'Could not close that room.');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
    unawaited(_activeRoomController.refresh());
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
      activeController = _notificationsScrollController;
    } else if (_currentIndex == 3) {
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
    WidgetsBinding.instance.removeObserver(this);
    _mapScrollController.removeListener(_scrollListener);
    _mapScrollController.dispose();
    _modesScrollController.removeListener(_scrollListener);
    _modesScrollController.removeListener(_onPageOrScrollChanged);
    _modesScrollController.dispose();
    _notificationsScrollController.removeListener(_scrollListener);
    _notificationsScrollController.removeListener(_onPageOrScrollChanged);
    _notificationsScrollController.dispose();
    _leaderboardScrollController.removeListener(_scrollListener);
    _leaderboardScrollController.removeListener(_onPageOrScrollChanged);
    _leaderboardScrollController.dispose();
    _pageController.removeListener(_onPageOrScrollChanged);
    _pageController.dispose();
    _settingsScrollController.removeListener(_onPageOrScrollChanged);
    _settingsScrollController.removeListener(_scrollListener);
    _settingsScrollController.dispose();
    NotificationService.instance.requestedRoute.removeListener(
      _handleNotificationRoute,
    );
    _notificationInboxController.dispose();
    _activeRoomController.dispose();
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

              if (index != 1 &&
                  _modesScrollController.hasClients &&
                  _modesScrollController.position.hasContentDimensions) {
                _modesScrollController.jumpTo(0);
              }
              if (index != 2 &&
                  _notificationsScrollController.hasClients &&
                  _notificationsScrollController
                      .position
                      .hasContentDimensions) {
                _notificationsScrollController.jumpTo(0);
              }
              if (index != 3 &&
                  _leaderboardScrollController.hasClients &&
                  _leaderboardScrollController.position.hasContentDimensions) {
                _leaderboardScrollController.jumpTo(0);
              }
              if (index != 4 &&
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

          if (_currentIndex == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 92,
              left: 14,
              right: 14,
              child: AnimatedBuilder(
                animation: _activeRoomController,
                builder: (context, _) {
                  final room = _activeRoomController.room;
                  if (room == null) return const SizedBox.shrink();
                  return ActiveRoomResumeCard(
                    room: room,
                    busy:
                        _activeRoomController.resuming ||
                        _activeRoomController.discarding,
                    onResume: _resumeActiveRoom,
                    onDismiss: _discardActiveRoom,
                  );
                },
              ),
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

  Widget _buildParallaxBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_mapScrollController]),
      builder: (context, child) {
        double scrollProgress = 1.0;
        if (_mapScrollController.hasClients &&
            _mapScrollController.position.hasContentDimensions) {
          double scrollOffset = _mapScrollController.offset;
          double maxScroll = _mapScrollController.position.maxScrollExtent;
          if (maxScroll <= 0) maxScroll = 1.0;
          scrollProgress = (scrollOffset / maxScroll).clamp(0.0, 1.0);
        }

        // When scrollProgress is 1.0 (bottom), it's Level 1.
        // When scrollProgress is 0.0 (top), it's Level 500.
        int level = ((1.0 - scrollProgress) * 499 + 1).round().clamp(1, 500);

        return LevelGradientBackground(level: level);
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
                      totalPoints: profile?.totalPoints ?? 0,
                      moneyCents: profile?.moneyCents ?? 0,
                      sparks: profile?.sparks ?? 5,
                      maxSparks: profile?.maxSparks ?? 5,
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
                          horizontal: 8,
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
                              spacing: 2,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildNavItem(
                                  icon: Icons.home_rounded,
                                  label: 'Home',
                                  index: 0,
                                ),
                                const SizedBox(width: 4),
                                _buildNavItem(
                                  icon: Icons.category,
                                  label: 'Modes',
                                  index: 1,
                                ),
                                const SizedBox(width: 4),
                                _buildNavItem(
                                  icon: Icons.notifications_rounded,
                                  label: 'Inbox',
                                  index: 2,
                                ),
                                const SizedBox(width: 4),
                                _buildNavItem(
                                  icon: Icons.leaderboard_rounded,
                                  label: 'Rank',
                                  index: 3,
                                ),
                                const SizedBox(width: 4),
                                _buildNavItem(
                                  icon: Icons.settings,
                                  label: 'Settings',
                                  index: 4,
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
          left: 11,
          right: 10,
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
              else if (icon == Icons.notifications_rounded)
                AnimatedBuilder(
                  animation: _notificationInboxController,
                  builder: (context, child) {
                    final unread = _notificationInboxController.unreadCount;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          icon,
                          color: GameColors.white.withValues(alpha: 0.85),
                          size: iconSize,
                        ),
                        if (unread > 0)
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 17),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(
                                unread > 99 ? '99+' : '$unread',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
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
