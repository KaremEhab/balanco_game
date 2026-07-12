import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/features/home/screens/main_screen.dart';
import 'package:balanco_game/features/home/screens/splash/components/splash_beach_background.dart';
import 'package:balanco_game/features/home/screens/splash/components/splash_logo_painter.dart';
import 'package:balanco_game/features/home/screens/splash/components/tutorial_carousel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/auth/presentation/auth_screen.dart';
import 'package:balanco_game/features/player/application/player_session.dart';

enum SplashState { loading, checking, ready }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _loadingController;
  late final AnimationController _idleController;
  late final AnimationController _pressController;

  SplashState _state = SplashState.loading;
  bool _isOnline = false;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..forward().then((_) => _checkConnection());
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    AppSettings.playMenuBgm();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _loadingController.dispose();
    _idleController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    if (!mounted) return;
    setState(() => _state = SplashState.checking);
    try {
      final result = await Connectivity().checkConnectivity();
      final connected = result.any(
        (item) =>
            item == ConnectivityResult.mobile ||
            item == ConnectivityResult.wifi ||
            item == ConnectivityResult.ethernet ||
            item == ConnectivityResult.vpn,
      );
      if (mounted) {
        setState(() {
          _isOnline = connected;
          _state = SplashState.ready;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _state = SplashState.ready);
    }
  }

  Future<void> _openGame({required bool online}) async {
    if (_leaving || (online && !_isOnline)) return;
    _leaving = true;
    await _pressController.forward();
    await _pressController.reverse();
    if (!mounted) return;
    Widget destination = const MainScreen();
    if (online) {
      if (PlayerSession.instance.isAuthenticated) {
        try {
          await PlayerSession.instance.refresh();
        } catch (_) {
          destination = const AuthScreen();
        }
      } else {
        destination = const AuthScreen();
      }
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, secondaryAnimation) => destination,
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  String get _statusText => switch (_state) {
    SplashState.loading => 'CONNECTING...',
    SplashState.checking => 'CHECKING THE HORIZON...',
    SplashState.ready =>
      _isOnline ? 'CHOOSE HOW TO PLAY' : 'OFFLINE ADVENTURE READY',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final compact = height < 680;
          final ready = _state == SplashState.ready;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background (only driven by idle controller)
              AnimatedBuilder(
                animation: _idleController,
                builder: (context, _) => SplashBeachBackground(
                  animationValue: _idleController.value,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: compact ? 4 : 12),

                    // 2. Logo (entrance + idle shine)
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _entranceController,
                        _idleController,
                      ]),
                      builder: (context, _) {
                        final entrance = Curves.easeOutBack.transform(
                          _entranceController.value,
                        );
                        return Transform.translate(
                          offset: Offset(0, (1 - entrance) * -55),
                          child: Transform.scale(
                            scale: 0.72 + entrance * 0.28,
                            child: SizedBox(
                              width: width * 0.94,
                              height: compact ? height * 0.2 : height * 0.23,
                              child: CustomPaint(
                                painter: SplashLogoPainter(
                                  shine: _idleController.value,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // 3. Tutorial Carousel (entrance only, child parameter prevents rebuilds)
                    Expanded(
                      flex: 2,
                      child: AnimatedBuilder(
                        animation: _entranceController,
                        builder: (context, child) {
                          final entrance = Curves.easeOutCubic.transform(
                            _entranceController.value,
                          );
                          return Transform.translate(
                            offset: Offset(0, (0.8 - entrance) * 30),
                            child: Opacity(
                              opacity: entrance.clamp(0.0, 1.0),
                              child: child,
                            ),
                          );
                        },
                        child: const TutorialCarousel(),
                      ),
                    ),

                    // 4. Buttons (entrance + loading + press scale)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _entranceController,
                          _loadingController,
                          _pressController,
                        ]),
                        builder: (context, _) {
                          final entrance = Curves.easeOutCubic.transform(
                            _entranceController.value,
                          );
                          final loading = Curves.easeInOutCubic.transform(
                            _loadingController.value,
                          );
                          final press = Curves.easeInOut.transform(
                            _pressController.value,
                          );

                          return Transform.scale(
                            scale:
                                1.0 - (press * 0.05), // Shrink effect on press
                            child: Transform.translate(
                              offset: Offset(0, (1.5 - entrance) * 40),
                              child: Opacity(
                                opacity: entrance.clamp(0.0, 1.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _GameModeButton(
                                      icon: !ready
                                          ? Icons.hourglass_top_rounded
                                          : Icons.public_rounded,
                                      title: !ready
                                          ? _statusText.toUpperCase()
                                          : 'PLAY ONLINE',
                                      subtitle: !ready
                                          ? 'PLEASE WAIT...'
                                          : (_isOnline
                                                ? 'CHALLENGES & MULTIPLAYER MATCHES'
                                                : 'NO CONNECTION'),
                                      colors: const [
                                        Color(0xFF27D7E9),
                                        Color(0xFF087DBD),
                                      ],
                                      shadowColor: const Color(0xFF0A689B),
                                      enabled: _isOnline,
                                      isLoading: !ready,
                                      progress: !ready ? loading : null,
                                      onTap: () => _openGame(online: true),
                                    ),
                                    const SizedBox(height: 15),
                                    _GameModeButton(
                                      icon: Icons.sports_esports_rounded,
                                      title: 'PLAY OFFLINE',
                                      subtitle: 'SOLO MAP ADVENTURE',
                                      colors: const [
                                        Color(0xFFFFC94B),
                                        Color(0xFFE77B2D),
                                      ],
                                      shadowColor: const Color(0xFFB95A19),
                                      enabled: true,
                                      isLoading: false,
                                      onTap: () => _openGame(online: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: compact ? 14 : 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GameModeButton extends StatelessWidget {
  const _GameModeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.shadowColor,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
    this.progress,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final Color shadowColor;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLoading;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final active = enabled || isLoading;
    return Semantics(
      button: true,
      enabled: enabled && !isLoading,
      label: '$title game, $subtitle',
      child: Opacity(
        opacity: active ? 1 : 0.6,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: active ? shadowColor : const Color(0x664B626E),
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (enabled && !isLoading) ? onTap : null,
              borderRadius: BorderRadius.circular(30),
              splashColor: Colors.white24,
              highlightColor: Colors.white10,
              child: Ink(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  gradient: progress != null
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colors[0],
                            colors[1],
                            const Color(0xFF879FA8),
                            const Color(0xFF6B808A),
                          ],
                          stops: [0.0, progress!, progress!, 1.0],
                        )
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: active
                              ? colors
                              : const [Color(0xFF9CB4BF), Color(0xFF718A98)],
                        ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Color(0x33FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xE6FFFFFF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
