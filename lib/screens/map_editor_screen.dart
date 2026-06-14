import 'package:flutter/material.dart';
import '../map/map_layout_config.dart';
import '../map/components/island_painter.dart';
import 'package:balanco_game/map/components/stone_painter.dart';
import 'package:balanco_game/map/components/level_button_painter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class MapEditorScreen extends StatefulWidget {
  const MapEditorScreen({super.key});

  @override
  State<MapEditorScreen> createState() => _MapEditorScreenState();
}

class _MapEditorScreenState extends State<MapEditorScreen> {
  // Track dragging locally before saving
  late List<IslandData> _localIslands;
  late List<StoneData> _localStones;

  final ScrollController _scrollController = ScrollController();

  // Isolation mode: If an item is double-clicked, only that item can be moved
  String? _isolatedItemId;

  // Toolbox State
  bool _isToolboxOpen = false;
  String _toolboxTab = 'Islands'; // 'Islands' or 'Stones'

  // Key for coordinate transformation
  final GlobalKey _canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadLocalData();

    // Start at the saved camera position or bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (MapLayoutConfig.instance.editorCamera.value != null) {
          // The old matrix had a large negative Y translation for scroll position
          double yTranslation =
              MapLayoutConfig.instance.editorCamera.value![13];
          _scrollController.jumpTo(-yTranslation);
        } else {
          // Default start at bottom
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _loadLocalData() {
    // Deep copy islands
    _localIslands = MapLayoutConfig.instance.islands.value
        .map((e) => IslandData(x: e.x, y: e.y, level: e.level, type: e.type))
        .toList();
    // Deep copy stones
    _localStones = MapLayoutConfig.instance.stones.value
        .map(
          (e) => StoneData(
            id: e.id,
            x: e.x,
            y: e.y,
            scale: e.scale,
            rotation: e.rotation,
            type: e.type,
          ),
        )
        .toList();
  }

  void _saveLayout() {
    MapLayoutConfig.instance.islands.value = _localIslands;
    MapLayoutConfig.instance.stones.value = _localStones;

    // Save scroll offset in the matrix format (Y translation is -offset)
    List<double> camera =
        (Matrix4.identity()..translate(0.0, -_scrollController.offset)).storage
            .toList();
    MapLayoutConfig.instance.editorCamera.value = camera;

    MapLayoutConfig.instance.save();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Absolute Layout Saved!')));
  }

  Widget _getIslandPainter(int type) {
    switch (type) {
      case 1:
        return CustomPaint(
          painter: FirstIslandPainter(),
          size: const Size(120, 120),
        );
      case 2:
        return CustomPaint(
          painter: SecondIslandPainter(),
          size: const Size(120, 120),
        );
      case 3:
        return CustomPaint(
          painter: ThirdIslandPainter(),
          size: const Size(120, 120),
        );
      case 4:
        return CustomPaint(
          painter: ForthIslandPainter(),
          size: const Size(120, 120),
        );
      case 5:
        return CustomPaint(
          painter: FifthIslandPainter(),
          size: const Size(120, 120),
        );
      case 6:
        return CustomPaint(
          painter: SixthIslandPainter(),
          size: const Size(120, 120),
        );
      case 7:
        return CustomPaint(
          painter: SeventhIslandPainter(),
          size: const Size(120, 120),
        );
      case 8:
        return CustomPaint(
          painter: EighthIslandPainter(),
          size: const Size(120, 120),
        );
      case 9:
        return CustomPaint(
          painter: NinthIslandPainter(),
          size: const Size(120, 120),
        );
      case 10:
        return CustomPaint(
          painter: TenthIslandPainter(),
          size: const Size(120, 120),
        );
      default:
        return CustomPaint(
          painter: FirstIslandPainter(),
          size: const Size(120, 120),
        );
    }
  }

  Widget _getStonePainter(int type) {
    switch (type) {
      case 1:
        return CustomPaint(
          painter: FirstStonePainter(),
          size: const Size(60, 60),
        );
      case 2:
        return CustomPaint(
          painter: SecondStonePainter(),
          size: const Size(60, 60),
        );
      case 3:
        return CustomPaint(
          painter: ThirdStonePainter(),
          size: const Size(60, 60),
        );
      case 4:
        return CustomPaint(
          painter: FourthStonePainter(),
          size: const Size(60, 60),
        );
      case 5:
        return CustomPaint(
          painter: FifthStonePainter(),
          size: const Size(60, 60),
        );
      case 6:
        return CustomPaint(
          painter: SixthStonePainter(),
          size: const Size(60, 60),
        );
      default:
        return CustomPaint(
          painter: FirstStonePainter(),
          size: const Size(60, 60),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleX = screenWidth / 400.0;
    double virtualHeight = MapLayoutConfig.instance.virtualHeight;

    return Scaffold(
      backgroundColor: const Color(0xFF005973),
      appBar: AppBar(
        title: const Text('Absolute Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () => setState(() => _loadLocalData()),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveLayout,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background ocean gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF005973), Color(0xFF33E6CC)],
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            reverse: true, // Start at bottom
            child: DragTarget<Map<String, dynamic>>(
              onAcceptWithDetails: (details) {
                final RenderBox renderBox =
                    _canvasKey.currentContext!.findRenderObject() as RenderBox;
                final localOffset = renderBox.globalToLocal(details.offset);

                final payload = details.data;
                if (payload['category'] == 'island') {
                  int type = payload['type'];
                  int maxLevel = 0;
                  for (var island in _localIslands) {
                    if (island.level > maxLevel) maxLevel = island.level;
                  }
                  double scaleX = MediaQuery.of(context).size.width / 400.0;
                  setState(() {
                    _localIslands.add(
                      IslandData(
                        x: localOffset.dx / scaleX,
                        y: localOffset.dy,
                        level: maxLevel + 1,
                        type: type,
                        buttonDx: 0.0,
                        buttonDy: 0.0,
                      ),
                    );
                  });
                } else if (payload['category'] == 'stone') {
                  int type = payload['type'];
                  double scaleX = MediaQuery.of(context).size.width / 400.0;
                  setState(() {
                    _localStones.add(
                      StoneData(
                        id: 'stone_${DateTime.now().millisecondsSinceEpoch}',
                        x: localOffset.dx / scaleX,
                        y: localOffset.dy,
                        scale: 1.0,
                        rotation: 0.0,
                        type: type,
                      ),
                    );
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return SizedBox(
                  key: _canvasKey,
                  width: screenWidth,
                  height: virtualHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Tap background to clear isolation
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            if (_isolatedItemId != null) {
                              setState(() => _isolatedItemId = null);
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(),
                        ),
                      ),

                      // Draw an invisible line connecting the islands so user can see the general path
                      CustomPaint(
                        size: Size(screenWidth, virtualHeight),
                        painter: _PathPreviewPainter(
                          islands: _localIslands,
                          scaleX: scaleX,
                        ),
                      ),

                      // 1. Draw Stones
                      ..._localStones.map((stone) {
                        String id = 'stone_${stone.id}';
                        bool isIsolated = _isolatedItemId == id;
                        bool isSomethingIsolated = _isolatedItemId != null;

                        return Positioned(
                          left: stone.x * scaleX - 30.0,
                          top: stone.y - 30.0,
                          child: Opacity(
                            opacity: (isSomethingIsolated && !isIsolated)
                                ? 0.4
                                : 1.0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTap: () {
                                setState(
                                  () =>
                                      _isolatedItemId = isIsolated ? null : id,
                                );
                              },
                              onPanUpdate: (details) {
                                if (!isIsolated)
                                  return; // Must double tap to unlock dragging
                                setState(() {
                                  stone.x += details.delta.dx / scaleX;
                                  stone.y += details.delta.dy;
                                });
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Transform.scale(
                                    scale: stone.scale * scaleX,
                                    child: Transform.rotate(
                                      angle: stone.rotation,
                                      child: _getStonePainter(stone.type),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      // 2. Draw Islands
                      ..._localIslands.map((island) {
                        String id = 'island_${island.level}';
                        bool isIsolated = _isolatedItemId == id;
                        bool isSomethingIsolated = _isolatedItemId != null;

                        return Positioned(
                          left: island.x * scaleX - 60.0,
                          top: island.y - 60.0,
                          child: Opacity(
                            opacity: (isSomethingIsolated && !isIsolated)
                                ? 0.4
                                : 1.0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTap: () {
                                setState(
                                  () =>
                                      _isolatedItemId = isIsolated ? null : id,
                                );
                              },
                              onPanUpdate: (details) {
                                if (!isIsolated)
                                  return; // Must double tap to unlock dragging
                                setState(() {
                                  island.x += details.delta.dx / scaleX;
                                  island.y += details.delta.dy;
                                });
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Transform.scale(
                                    scale: scaleX * 1.2,
                                    child: Transform.rotate(
                                      angle: island.rotation,
                                      child: _getIslandPainter(island.type),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      // 3. Draw Level Buttons
                      ..._localIslands.map((island) {
                        String id = 'button_${island.level}';
                        bool isIsolated = _isolatedItemId == id;
                        bool isSomethingIsolated = _isolatedItemId != null;

                        double badgeX =
                            island.x * scaleX + (island.buttonDx * scaleX);
                        double badgeY =
                            island.y - 10.0 + (island.buttonDy * scaleX);
                        double buttonDrawSize = 60.0;
                        double drawScale = scaleX * 1.2;

                        return Positioned(
                          left: badgeX - (buttonDrawSize / 2),
                          top: badgeY - (buttonDrawSize / 2),
                          child: Opacity(
                            opacity: (isSomethingIsolated && !isIsolated)
                                ? 0.4
                                : 1.0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTap: () {
                                setState(
                                  () =>
                                      _isolatedItemId = isIsolated ? null : id,
                                );
                              },
                              onPanUpdate: (details) {
                                if (!isIsolated)
                                  return; // Must double tap to unlock dragging
                                setState(() {
                                  island.buttonDx += details.delta.dx / scaleX;
                                  island.buttonDy += details.delta.dy / scaleX;
                                });
                              },
                              child: Transform.scale(
                                scale: drawScale,
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    CustomPaint(
                                      painter: LevelButtonPainter(),
                                      size: Size(
                                        buttonDrawSize,
                                        buttonDrawSize,
                                      ),
                                    ),
                                    // Data Label overlay (unlocked style)
                                    Positioned(
                                      top: 12,
                                      child: Text(
                                        '${island.level}',
                                        style: GoogleFonts.luckiestGuy(
                                          textStyle: const TextStyle(
                                            color: Color(0xFFD32F2F),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w900,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white,
                                                offset: Offset(0, 0),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      // Draw Toolbar overlay on top of everything
                      if (_isolatedItemId != null) _buildToolbarOverlay(scaleX),
                    ],
                  ),
                );
              },
            ),
          ),

          // Toolbox Panel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isToolboxOpen
                ? 80.0
                : -250.0, // Height of toolbox + navbar space
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tab Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () =>
                            setState(() => _toolboxTab = 'Islands'),
                        child: Text(
                          'Islands',
                          style: TextStyle(
                            fontWeight: _toolboxTab == 'Islands'
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _toolboxTab = 'Stones'),
                        child: Text(
                          'Stones',
                          style: TextStyle(
                            fontWeight: _toolboxTab == 'Stones'
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  // Scrollable Items
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: _toolboxTab == 'Islands'
                            ? List.generate(
                                10,
                                (i) => _buildDraggableToolboxItem(
                                  'island',
                                  i + 1,
                                  _getIslandPainter(i + 1),
                                ),
                              )
                            : List.generate(
                                6,
                                (i) => _buildDraggableToolboxItem(
                                  'stone',
                                  i + 1,
                                  _getStonePainter(i + 1),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FAB
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: 20,
            bottom: _isToolboxOpen ? 350.0 : 100.0,
            child: FloatingActionButton(
              onPressed: () => setState(() => _isToolboxOpen = !_isToolboxOpen),
              child: Icon(_isToolboxOpen ? Icons.close : Icons.add_box),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarWidget({
    required VoidCallback onRotate,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRotate,
            child: const Icon(Icons.rotate_right, color: Colors.blue, size: 36),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete, color: Colors.red, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarOverlay(double scaleX) {
    if (_isolatedItemId == null) return const SizedBox.shrink();

    double x = 0;
    double y = 0;
    Widget? toolbar;

    if (_isolatedItemId!.startsWith('island_')) {
      int level = int.parse(_isolatedItemId!.split('_')[1]);
      try {
        IslandData island = _localIslands.firstWhere((i) => i.level == level);
        x = island.x * scaleX;
        y = island.y - 120.0; // Above the island
        toolbar = _buildToolbarWidget(
          onRotate: () => setState(() => island.rotation += pi / 4),
          onDelete: () {
            setState(() {
              _localIslands.removeWhere((i) => i.level == island.level);
              for (int i = 0; i < _localIslands.length; i++) {
                _localIslands[i].level = i + 1;
              }
              _isolatedItemId = null;
            });
          },
        );
      } catch (e) {
        return const SizedBox.shrink();
      }
    } else if (_isolatedItemId!.startsWith('stone_')) {
      String idStr = _isolatedItemId!.substring(6);
      try {
        StoneData stone = _localStones.firstWhere((s) => s.id == idStr);
        x = stone.x * scaleX;
        y = stone.y - 80.0; // Above the stone
        toolbar = _buildToolbarWidget(
          onRotate: () => setState(() => stone.rotation += pi / 4),
          onDelete: () {
            setState(() {
              _localStones.removeWhere((s) => s.id == stone.id);
              _isolatedItemId = null;
            });
          },
        );
      } catch (e) {
        return const SizedBox.shrink();
      }
    }

    if (toolbar == null) return const SizedBox.shrink();

    return Positioned(
      left: x - 100, // Center it horizontally assuming width ~200
      width: 200,
      top: y,
      child: Center(child: toolbar),
    );
  }

  Widget _buildDraggableToolboxItem(String category, int type, Widget painter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Draggable<Map<String, dynamic>>(
        data: {'category': category, 'type': type},
        feedback: Material(
          color: Colors.transparent,
          child: Transform.scale(scale: 0.8, child: painter),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: Transform.scale(scale: 0.6, child: painter),
        ),
        child: Transform.scale(scale: 0.6, child: painter),
      ),
    );
  }
}

class _PathPreviewPainter extends CustomPainter {
  final List<IslandData> islands;
  final double scaleX;

  _PathPreviewPainter({required this.islands, required this.scaleX});

  @override
  void paint(Canvas canvas, Size size) {
    if (islands.length < 2) return;

    Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(
      islands[0].x * scaleX + islands[0].buttonDx * scaleX,
      islands[0].y - 10.0 + islands[0].buttonDy * scaleX,
    );

    for (int i = 0; i < islands.length - 1; i++) {
      Offset p1 = Offset(
        islands[i].x * scaleX + islands[i].buttonDx * scaleX,
        islands[i].y - 10.0 + islands[i].buttonDy * scaleX,
      );
      Offset p2 = Offset(
        islands[i + 1].x * scaleX + islands[i + 1].buttonDx * scaleX,
        islands[i + 1].y - 10.0 + islands[i + 1].buttonDy * scaleX,
      );
      double controlOffset = 80.0 * scaleX;
      double sign1 = sin((i + 1) * (pi / 2.5)) >= 0 ? 1.0 : -1.0;
      double sign2 = sin((i + 2) * (pi / 2.5)) >= 0 ? 1.0 : -1.0;
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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
