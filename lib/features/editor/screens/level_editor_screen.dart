import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart' hide PositionComponent;
import 'package:google_fonts/google_fonts.dart';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/features/game/game_area.dart';

enum EditorItemType {
  hole,
  suckingHole,
  movingHole,
  bumper,
  teleporter,
  star,
  heart,
  magnet,
  multiBall,
}

class EditorItem {
  final String id = UniqueKey().toString();
  EditorItemType type;
  double x; // 0.0 to 1.0
  double y; // 0.0 to 1.0
  double size; // Actual pixel size, or logical size

  // Hole specific
  double suckRadius;
  double moveRange;
  double moveSpeed;

  // Teleporter
  int pairId;

  EditorItem({
    required this.type,
    required this.x,
    required this.y,
    this.size = 50.0,
    this.suckRadius = 0.0,
    this.moveRange = 0.0,
    this.moveSpeed = 0.0,
    this.pairId = 0,
  });

  EditorItem clone() {
    return EditorItem(
      type: type,
      x: x,
      y: y,
      size: size,
      suckRadius: suckRadius,
      moveRange: moveRange,
      moveSpeed: moveSpeed,
      pairId: pairId,
    );
  }
}

class LevelEditorScreen extends StatefulWidget {
  const LevelEditorScreen({super.key});

  @override
  State<LevelEditorScreen> createState() => _LevelEditorScreenState();
}

class _LevelEditorScreenState extends State<LevelEditorScreen> {
  int _currentLevel = 1;
  List<EditorItem> _items = [];
  EditorItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _loadLevel(_currentLevel);
  }

  Future<void> _loadLevel(int levelId) async {
    final jsonStr = await DatabaseHelper.instance.getCustomLevel(levelId);
    if (jsonStr != null) {
      final data = LevelData.fromJson(jsonDecode(jsonStr));
      _items.clear();

      for (var h in data.holes) {
        _items.add(
          EditorItem(
            type: h.isSuckingHole
                ? EditorItemType.suckingHole
                : (h.isMovingHole
                      ? EditorItemType.movingHole
                      : EditorItemType.hole),
            x: h.position.x,
            y: h.position.y,
            size: h.size,
            suckRadius: h.suckRadius,
            moveRange: h.moveRange,
            moveSpeed: h.moveSpeed,
          ),
        );
      }
      for (var b in data.bumpers) {
        _items.add(
          EditorItem(
            type: EditorItemType.bumper,
            x: b.position.x,
            y: b.position.y,
            size: b.size,
          ),
        );
      }
      for (var t in data.teleporters) {
        _items.add(
          EditorItem(
            type: EditorItemType.teleporter,
            x: t.position.x,
            y: t.position.y,
            size: t.size,
            pairId: t.pairId,
          ),
        );
      }
      for (var s in data.stars) {
        _items.add(
          EditorItem(type: EditorItemType.star, x: s.x, y: s.y, size: 30),
        );
      }
      for (var h in data.hearts) {
        _items.add(
          EditorItem(type: EditorItemType.heart, x: h.x, y: h.y, size: 30),
        );
      }
      for (var m in data.magnets) {
        _items.add(
          EditorItem(type: EditorItemType.magnet, x: m.x, y: m.y, size: 30),
        );
      }
      for (var mb in data.multiBalls) {
        _items.add(
          EditorItem(
            type: EditorItemType.multiBall,
            x: mb.x,
            y: mb.y,
            size: 30,
          ),
        );
      }
      setState(() {});
    } else {
      setState(() {
        _items.clear();
        _selectedItem = null;
      });
    }
  }

  LevelData _generateLevelData() {
    final holes = <HoleData>[];
    final bumpers = <BumperData>[];
    final teleporters = <TeleporterData>[];
    final stars = <Vector2>[];
    final hearts = <Vector2>[];
    final magnets = <Vector2>[];
    final multiBalls = <Vector2>[];

    for (var item in _items) {
      final pos = Vector2(item.x, item.y);
      switch (item.type) {
        case EditorItemType.hole:
          holes.add(HoleData(pos, item.size, 0.0, false, 0.0));
          break;
        case EditorItemType.suckingHole:
          holes.add(HoleData(pos, item.size, 0.0, true, item.suckRadius));
          break;
        case EditorItemType.movingHole:
          holes.add(
            HoleData(
              pos,
              item.size,
              0.0,
              false,
              0.0,
              isMovingHole: true,
              moveRange: item.moveRange,
              moveSpeed: item.moveSpeed,
            ),
          );
          break;
        case EditorItemType.bumper:
          bumpers.add(BumperData(pos, item.size));
          break;
        case EditorItemType.teleporter:
          teleporters.add(TeleporterData(pos, item.size, item.pairId));
          break;
        case EditorItemType.star:
          stars.add(pos);
          break;
        case EditorItemType.heart:
          hearts.add(pos);
          break;
        case EditorItemType.magnet:
          magnets.add(pos);
          break;
        case EditorItemType.multiBall:
          multiBalls.add(pos);
          break;
      }
    }

    return LevelData(
      holes: holes,
      stars: stars,
      hearts: hearts,
      bumpers: bumpers,
      teleporters: teleporters,
      magnets: magnets,
      multiBalls: multiBalls,
    );
  }

  Future<void> _saveLevel() async {
    final data = _generateLevelData();
    final jsonStr = jsonEncode(data.toJson());
    await DatabaseHelper.instance.saveCustomLevel(_currentLevel, jsonStr);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved locally!')));
  }

  void _copyToClipboard() {
    final data = _generateLevelData();
    final jsonStr = jsonEncode(data.toJson());
    Clipboard.setData(ClipboardData(text: '$_currentLevel: \'$jsonStr\','));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied JSON to clipboard!')));
  }

  void _testLevel() {
    // Save to DB first to ensure it's loaded
    _saveLevel().then((_) {
      final game = BalancoGame(
        isMultiplayer: false,
        isInfinityMode: false,
        playerRole: '',
        onLevelComplete: () {
          Navigator.pop(context);
        },
      );
      game.currentLevel.value = _currentLevel;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GamePlayOverlay(game: game)),
      );
    });
  }

  Widget _buildCanvas(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return DragTarget<EditorItemType>(
            onAcceptWithDetails: (details) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final Offset localOffset = renderBox.globalToLocal(
                details.offset,
              );

              setState(() {
                _items.add(
                  EditorItem(
                    type: details.data,
                    x: (localOffset.dx / width).clamp(0.0, 1.0),
                    y: (localOffset.dy / height).clamp(0.0, 1.0),
                    suckRadius: details.data == EditorItemType.suckingHole
                        ? 150.0
                        : 0.0,
                    moveRange: details.data == EditorItemType.movingHole
                        ? 0.2
                        : 0.0,
                    moveSpeed: details.data == EditorItemType.movingHole
                        ? 2.0
                        : 0.0,
                  ),
                );
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                color: GameColors.woodDark,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Grid lines (optional)
                    CustomPaint(
                      size: Size(width, height),
                      painter: GridPainter(),
                    ),

                    // Static Finish Gate
                    Positioned(
                      top: 0,
                      left: width / 2 - 60,
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(60),
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "FINISH GATE",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Static Start Bar and Ball
                    Positioned(
                      bottom: 0,
                      left: width / 2 - 80,
                      child: Opacity(
                        opacity: 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 160,
                              height: 20,
                              decoration: BoxDecoration(
                                color: GameColors.brownDarkUi,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "START BAR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    // Items
                    for (var item in _items)
                      Positioned(
                        left: (item.x * width) - (item.size / 2),
                        top: (item.y * height) - (item.size / 2),
                        width: item.size,
                        height: item.size,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedItem = item);
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              _selectedItem = item;
                              item.x =
                                  ((item.x * width) + details.delta.dx) / width;
                              item.y =
                                  ((item.y * height) + details.delta.dy) /
                                  height;
                              item.x = item.x.clamp(0.0, 1.0);
                              item.y = item.y.clamp(0.0, 1.0);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: _selectedItem == item
                                  ? Border.all(color: Colors.red, width: 2)
                                  : null,
                            ),
                            child: _buildItemVisual(item.type, item.size),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItemVisual(EditorItemType type, double size) {
    switch (type) {
      case EditorItemType.hole:
      case EditorItemType.suckingHole:
      case EditorItemType.movingHole:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: type == EditorItemType.suckingHole
              ? const Icon(Icons.cyclone, color: Colors.blue)
              : type == EditorItemType.movingHole
              ? const Icon(Icons.compare_arrows, color: Colors.white)
              : null,
        );
      case EditorItemType.bumper:
        return Container(
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.yellow, width: 3),
          ),
        );
      case EditorItemType.teleporter:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.flash_on, color: Colors.white),
        );
      case EditorItemType.star:
        return const Icon(Icons.star, color: Colors.yellow, size: 30);
      case EditorItemType.heart:
        return const Icon(Icons.favorite, color: Colors.red, size: 30);
      case EditorItemType.magnet:
        return const Icon(Icons.file_download, color: Colors.blue, size: 30);
      case EditorItemType.multiBall:
        return const Icon(
          Icons.control_point_duplicate,
          color: Colors.green,
          size: 30,
        );
    }
  }

  Widget _buildPalette() {
    return Container(
      height: 100,
      color: Colors.black87,
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: EditorItemType.values.map((type) {
          return Draggable<EditorItemType>(
            data: type,
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 50,
                height: 50,
                child: _buildItemVisual(type, 50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: _buildItemVisual(type, 40),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    type.name,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPropertiesPanel() {
    if (_selectedItem == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit ${_selectedItem!.type.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _items.remove(_selectedItem);
                    _selectedItem = null;
                  });
                },
              ),
            ],
          ),
          // Size Slider
          Row(
            children: [
              const Text('Size:'),
              Expanded(
                child: Slider(
                  value: _selectedItem!.size,
                  min: 10,
                  max: 150,
                  onChanged: (v) => setState(() => _selectedItem!.size = v),
                ),
              ),
            ],
          ),
          if (_selectedItem!.type == EditorItemType.suckingHole)
            Row(
              children: [
                const Text('Suck Rad:'),
                Expanded(
                  child: Slider(
                    value: _selectedItem!.suckRadius,
                    min: 0,
                    max: 300,
                    onChanged: (v) =>
                        setState(() => _selectedItem!.suckRadius = v),
                  ),
                ),
              ],
            ),
          if (_selectedItem!.type == EditorItemType.movingHole)
            Row(
              children: [
                const Text('Range:'),
                Expanded(
                  child: Slider(
                    value: _selectedItem!.moveRange,
                    min: 0,
                    max: 0.5,
                    onChanged: (v) =>
                        setState(() => _selectedItem!.moveRange = v),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Editor'),
        backgroundColor: Colors.blueGrey,
        actions: [
          DropdownButton<int>(
            value: _currentLevel,
            dropdownColor: Colors.blueGrey,
            style: const TextStyle(color: Colors.white),
            items: List.generate(50, (i) => i + 1).map((l) {
              return DropdownMenuItem(value: l, child: Text('Level $l'));
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _currentLevel = v);
                _loadLevel(v);
              }
            },
          ),
          IconButton(icon: const Icon(Icons.save), onPressed: _saveLevel),
          IconButton(icon: const Icon(Icons.copy), onPressed: _copyToClipboard),
          IconButton(icon: const Icon(Icons.play_arrow), onPressed: _testLevel),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() {
              _items.clear();
              _selectedItem = null;
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCanvas(context),
          _buildPropertiesPanel(),
          _buildPalette(),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += size.width / 10) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += size.height / 10) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
