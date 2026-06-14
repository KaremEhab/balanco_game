import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/game_area.dart';
import '../screens/gameplay.dart';
import '../screens/main_screen.dart';
import '../screens/map_layers/sea_waves_layer.dart';
import '../screens/map_layers/static_shores_layer.dart';
import '../screens/map_layers/dynamic_islands_layer.dart';
import '../screens/map_layers/static_trees_layer.dart';
import 'components/map_ball_layer.dart';
import 'map_layout_config.dart';

class MapScreen extends StatefulWidget {
  final ScrollController scrollController;

  const MapScreen({super.key, required this.scrollController});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final int totalLevels = 50;
  final double bottomPadding = 180.0;

  int highestLevel = 1;
  int currentBallLevel = 1;
  int _targetBallLevel = 1;

  Map<int, int> levelStars = {};

  late AnimationController _ballController;
  double _ballScale = 1.0;
  double _ballRotation = 0.0;
  bool _isAnimatingBall = false;
  final List<Offset> _islandNodes = [];
  final List<Offset> _buttonNodes = [];
  Path _mapRoadPath = Path();

  // Physics Jump State
  List<double> _hopDistances = [];

  // Data loaded flag
  late Animation<double> rollCurve;
  late Animation<double> sinkCurve;

  int? _pressedLevel;
  late AnimationController _buttonBounceController;

  late AnimationController _waveController;
  late AnimationController _islandBounceController;

  double _virtualHeight = 0;

  @override
  void initState() {
    super.initState();
    MapLayoutConfig.instance.load();
    _ballController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // Slower to see the bouncy stone physics!
    );

    rollCurve = CurvedAnimation(
      parent: _ballController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
    );
    sinkCurve = CurvedAnimation(
      parent: _ballController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeInBack),
    );

    _ballController.addListener(() {
      setState(() {
        if (sinkCurve.value > 0) {
          _ballScale = 1.0 - sinkCurve.value; // Shrink to 0
          _ballRotation += sinkCurve.value * pi * 2;
        }
      });
    });

    _buttonBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
    _buttonBounceController.addListener(() {
      // Rebuild the map when the bounce animation changes
      setState(() {});
    });

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 600),
    )..repeat();

    _islandBounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      highestLevel = prefs.getInt('highestLevel') ?? 1;
      currentBallLevel = highestLevel;
      // Load stars for each level
      for (int i = 1; i <= highestLevel; i++) {
        levelStars[i] = prefs.getInt('level_${i}_stars') ?? 0;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients) {
        if (MapLayoutConfig.instance.editorCamera.value != null) {
          double yTranslation =
              MapLayoutConfig.instance.editorCamera.value![13];
          widget.scrollController.jumpTo(-yTranslation);
        } else {
          double offset = _virtualHeight - _getNodeY(highestLevel) - 300.0;
          widget.scrollController.jumpTo(
            offset.clamp(0.0, widget.scrollController.position.maxScrollExtent),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _ballController.dispose();
    _buttonBounceController.dispose();
    _waveController.dispose();
    _islandBounceController.dispose();
    super.dispose();
  }

  void _calculateMapLayout(List<IslandData> layouts, double scaleX) {
    _islandNodes.clear();
    _buttonNodes.clear();

    _virtualHeight = MapLayoutConfig.instance.virtualHeight;

    // Use the absolute coordinates directly (no scaling yet, scaling happens in build)
    for (int i = 0; i < layouts.length; i++) {
      _islandNodes.add(Offset(layouts[i].x, layouts[i].y));
      _buttonNodes.add(
        Offset(
          layouts[i].x + layouts[i].buttonDx,
          layouts[i].y - 10.0 + layouts[i].buttonDy * scaleX,
        ),
      );
    }

    _mapRoadPath = Path();
    if (_buttonNodes.isNotEmpty) {
      _mapRoadPath.moveTo(_buttonNodes[0].dx, _buttonNodes[0].dy);
      for (int i = 0; i < _buttonNodes.length - 1; i++) {
        Offset p1 = _buttonNodes[i];
        Offset p2 = _buttonNodes[i + 1];

        // Control points: bend outwards based on the sine wave to make it curvy
        double controlOffset = 80.0;
        double sign1 = sin((i + 1) * (pi / 2.5)) >= 0 ? 1 : -1;
        double sign2 = sin((i + 2) * (pi / 2.5)) >= 0 ? 1 : -1;

        Offset cp1 = Offset(
          p1.dx + sign1 * controlOffset,
          p1.dy - (p1.dy - p2.dy) * 0.3,
        );
        Offset cp2 = Offset(
          p2.dx + sign2 * controlOffset,
          p2.dy + (p1.dy - p2.dy) * 0.3,
        );

        _mapRoadPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
      }
    }
  }

  double _getNodeY(int level) {
    if (level < 1 || level > _buttonNodes.length) return 0;
    return _buttonNodes[level - 1].dy;
  }

  double _getNodeX(int level, double scaleX) {
    if (level < 1 || level > _buttonNodes.length) return 0;
    return _buttonNodes[level - 1].dx * scaleX;
  }

  void _handleTapDown(Offset tapPosition, double scaleX) {
    if (_isAnimatingBall) return;

    for (int i = 1; i <= totalLevels; i++) {
      double nodeX = _getNodeX(i, scaleX);
      double nodeY = _getNodeY(i);

      double distance = sqrt(
        pow(tapPosition.dx - nodeX, 2) + pow(tapPosition.dy - nodeY, 2),
      );

      if (distance < 45.0 * scaleX) {
        setState(() {
          _pressedLevel = i;
        });
        _buttonBounceController.reverse(); // Animate down to 0.85
        break; // Node found
      }
    }
  }

  Future<void> _handleTapUp(Offset tapPosition, double scaleX) async {
    int? tapped = _pressedLevel;

    if (tapped != null && !_isAnimatingBall) {
      // Guarantee the squish animation finishes first if the tap was lightning fast!
      await _buttonBounceController.reverse();
      // Animate back to 1.0 smoothly before transitioning
      await _buttonBounceController.forward();

      if (!mounted) return;
      setState(() {
        _pressedLevel = null;
      });

      if (tapped <= highestLevel) {
        _launchLevelTransition(tapped);
      } else {
        // Locked
        HapticFeedback.vibrate();
      }
    } else {
      setState(() {
        _pressedLevel = null;
      });
      _buttonBounceController.forward();
    }
  }

  void _handleTapCancel() {
    setState(() {
      _pressedLevel = null;
    });
    _buttonBounceController.forward();
  }

  void _launchLevelTransition(int index) {
    if (index > highestLevel || _isAnimatingBall) return;

    if (index == currentBallLevel) {
      _startGameplay(index);
      return;
    }

    setState(() {
      _targetBallLevel = index;
      _isAnimatingBall = true;
      _ballScale = 1.0;
      _ballRotation = 0.0;
    });

    // Compute hop distances for perfect physics
    _hopDistances.clear();
    bool isReverse = currentBallLevel > index;
    int s = isReverse ? index : currentBallLevel;
    int e = isReverse ? currentBallLevel : index;
    Path segment = _getSegmentPath(s, e);
    var metrics = segment.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      PathMetric metric = metrics.first;
      double scaleX = MediaQuery.of(context).size.width / 400.0;
      
      List<double> stoneDistances = [];
      for (var stone in MapLayoutConfig.instance.stones.value) {
        double bestDist = -1;
        double minD = double.infinity;
        for (double d = 0; d <= metric.length; d += 5) {
          Tangent? t = metric.getTangentForOffset(d);
          if (t != null) {
            double distToStone = (Offset(stone.x * scaleX, stone.y) - t.position).distance;
            if (distToStone < minD) {
              minD = distToStone;
              bestDist = d;
            }
          }
        }
        if (minD < 60.0 * scaleX && bestDist != -1) {
          stoneDistances.add(bestDist);
        }
      }
      stoneDistances.sort();
      _hopDistances = [0.0, ...stoneDistances, metric.length];
    }

    _ballController.reset();
    _ballController.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _isAnimatingBall = false;
        currentBallLevel = index;
      });
      _startGameplay(index);
    });
  }

  Future<void> _startGameplay(int index) async {
    // Launch the active game overlay cleanly
    final game = BalancoGame(
      isMultiplayer: isMultiplayerNotifier.value,
      playerRole: playerRoleNotifier.value,
      onLevelComplete: () {
        Navigator.pop(context); // Return to lobby
      },
    );
    game.currentLevel.value = index;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePlayOverlay(game: game)),
    );

    if (mounted) {
      setState(() {
        _ballScale = 1.0;
        _ballRotation = 0.0;
      });
    }
    _loadData();
  }

  Path _getSegmentPath(int s, int e) {
    Path path = Path();
    if (s >= e || s < 1 || e > _buttonNodes.length) return path;

    path.moveTo(_buttonNodes[s - 1].dx, _buttonNodes[s - 1].dy);
    for (int i = s - 1; i < e - 1; i++) {
      Offset p1 = _buttonNodes[i];
      Offset p2 = _buttonNodes[i + 1];
      double controlOffset = 80.0;
      double sign1 = sin((i + 1) * (pi / 2.5)) >= 0 ? 1 : -1;
      double sign2 = sin((i + 2) * (pi / 2.5)) >= 0 ? 1 : -1;
      Offset cp1 = Offset(
        p1.dx + sign1 * controlOffset,
        p1.dy - (p1.dy - p2.dy) * 0.3,
      );
      Offset cp2 = Offset(
        p2.dx + sign2 * controlOffset,
        p2.dy + (p1.dy - p2.dy) * 0.3,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 400.0;

    return ValueListenableBuilder<List<IslandData>>(
      valueListenable: MapLayoutConfig.instance.islands,
      builder: (context, layouts, child) {
        _calculateMapLayout(layouts, scaleX);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF10A8E0), // Deep Teal at top
                Color(0xFF52FEDA), // Aquamarine at bottom
              ],
            ),
          ),
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(),
            reverse: true, // Start at the bottom (Level 1)
            child: GestureDetector(
              onTapDown: (details) =>
                  _handleTapDown(details.localPosition, scaleX),
              onTapUp: (details) => _handleTapUp(details.localPosition, scaleX),
              onTapCancel: _handleTapCancel,
              child: SizedBox(
                width: screenWidth,
                height: _virtualHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. The Rendering Engine - Split into highly optimized layers
                    // We DO NOT wrap this in a scroll listener!
                    // Flutter will render this massive canvas ONCE, cache it via RepaintBoundary,
                    // and simply slide the cached texture up and down natively. Zero dropped frames!
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Layer 1: Sea Waves (Animates via wave controller)
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _waveController,
                            builder: (context, child) {
                              return CustomPaint(
                                size: Size(screenWidth, _virtualHeight),
                                painter: SeaWavesLayerPainter(
                                  waveProgress: _waveController.value,
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Layer 2: Static Shores & Trees (Animates NEVER. Painted ONCE)
                        RepaintBoundary(
                          child: CustomPaint(
                            size: Size(screenWidth, _virtualHeight),
                            painter: StaticShoresLayerPainter(),
                          ),
                        ),

                        // Layer 3: Dynamic Islands & Badges (Animates via bounce controllers)
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: Listenable.merge([_islandBounceController, _buttonBounceController, _ballController]),
                            builder: (context, child) {
                              Offset? ballGround;
                              if (_isAnimatingBall && currentBallLevel != _targetBallLevel) {
                                bool isReverse = currentBallLevel > _targetBallLevel;
                                int s = isReverse ? _targetBallLevel : currentBallLevel;
                                int e = isReverse ? currentBallLevel : _targetBallLevel;
                                Path segment = _getSegmentPath(s, e);
                                var metrics = segment.computeMetrics().toList();
                                if (metrics.isNotEmpty) {
                                  PathMetric metric = metrics.first;
                                  double progress = isReverse ? (1.0 - rollCurve.value) : rollCurve.value;
                                  double distance = metric.length * progress;
                                  Tangent? tangent = metric.getTangentForOffset(distance);
                                  if (tangent != null) {
                                    ballGround = Offset(tangent.position.dx * scaleX, tangent.position.dy);
                                  }
                                }
                              }

                              return CustomPaint(
                                size: Size(screenWidth, _virtualHeight),
                                painter: DynamicIslandsLayerPainter(
                                  totalLevels: totalLevels,
                                  highestLevel: highestLevel,
                                  levelStars: levelStars,
                                  pressedLevel: _pressedLevel,
                                  pressedScale: _buttonBounceController.value,
                                  islandBounceProgress: _islandBounceController.value,
                                  islandNodes: _islandNodes,
                                  stones: MapLayoutConfig.instance.stones.value,
                                  islands: layouts,
                                  ballGroundPosition: ballGround,
                                ),
                              );
                            },
                          ),
                        ),

                        // Layer 4: Static Trees (Animates NEVER. Painted ONCE. Above islands)
                        RepaintBoundary(
                          child: CustomPaint(
                            size: Size(screenWidth, _virtualHeight),
                            painter: StaticTreesLayerPainter(),
                          ),
                        ),
                      ],
                    ),

                    // 2. The Animated Steel Ball Player Overlay
                    if (_isAnimatingBall || currentBallLevel > 0)
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _ballController,
                          _islandBounceController,
                        ]),
                        builder: (context, child) {
                          double currentX = _getNodeX(currentBallLevel, scaleX);
                          double currentY = _getNodeY(currentBallLevel);
                          // Make the ball bob perfectly in sync with the island it rests on!
                          currentY +=
                              sin(
                                (_islandBounceController.value * pi * 2) +
                                    (currentBallLevel * 1.3),
                              ) *
                              8.0;
                          double rotation = 0;

                          if (_isAnimatingBall &&
                              currentBallLevel != _targetBallLevel) {
                            bool isReverse =
                                currentBallLevel > _targetBallLevel;
                            int s = isReverse
                                ? _targetBallLevel
                                : currentBallLevel;
                            int e = isReverse
                                ? currentBallLevel
                                : _targetBallLevel;

                            Path segment = _getSegmentPath(s, e);
                            var metrics = segment.computeMetrics().toList();
                            if (metrics.isNotEmpty) {
                              PathMetric metric = metrics.first;
                              double progress = isReverse
                                  ? (1.0 - rollCurve.value)
                                  : rollCurve.value;
                              double distance = metric.length * progress;

                              Tangent? tangent = metric.getTangentForOffset(
                                distance,
                              );
                              if (tangent != null) {
                                currentX = tangent.position.dx * scaleX;
                                currentY = tangent.position.dy;
                                
                                // Physics Jump calculation
                                double currentDist = distance;
                                double d1 = 0;
                                double d2 = metric.length;
                                for (int i = 0; i < _hopDistances.length - 1; i++) {
                                  if (currentDist >= _hopDistances[i] && currentDist <= _hopDistances[i+1]) {
                                    d1 = _hopDistances[i];
                                    d2 = _hopDistances[i+1];
                                    break;
                                  }
                                }
                                if (d2 > d1) {
                                  double t = (currentDist - d1) / (d2 - d1);
                                  double jumpY = sin(t * pi) * 45.0; // parabolic jump height
                                  currentY -= jumpY;
                                }

                                // Physical rolling calculation
                                rotation =
                                    (metric.length * rollCurve.value) / 16.0;
                                if (isReverse) rotation = -rotation;
                              }
                            }
                          }

                          return Positioned.fill(
                            child: CustomPaint(
                              painter: MapBallLayer(
                                position: Offset(currentX, currentY),
                                scale: _ballScale,
                                rotation: rotation,
                                radius: 16.0 * scaleX,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
