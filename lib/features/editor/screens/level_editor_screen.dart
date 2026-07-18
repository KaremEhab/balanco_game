import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart' hide PositionComponent;

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/game/level_system/campaign_level_repository.dart';
import 'package:balanco_game/features/game/level_system/level_definition_adapter.dart';
import 'package:balanco_game/features/game/models/level_data.dart';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:balanco_game/features/game/game_area.dart';

enum EditorItemType {
  hole,
  suckingHole,
  movingHole,
  nailHole,
  splittingHole,
  orbitingHole,
  bumper,
  teleporter,
  star,
  heart,
  shield,
  magnet,
  multiBall,
  shooterHelper,
  villain,
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
  String moveAxis; // 'horizontal' or 'vertical'

  // Teleporter
  int pairId;
  int variant;
  int health;

  EditorItem({
    required this.type,
    required this.x,
    required this.y,
    this.size = 50.0,
    this.suckRadius = 0.0,
    this.moveRange = 0.0,
    this.moveSpeed = 0.0,
    this.moveAxis = 'horizontal',
    this.pairId = 0,
    this.variant = 0,
    this.health = 8,
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
      moveAxis: moveAxis,
      pairId: pairId,
      variant: variant,
      health: health,
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
  int _timeLimitSeconds = 60;
  double _timerSeconds = 120.0;
  double _heightMultiplier = 1.0;
  bool _hasBomb = false;
  int _bombCount = 0;
  bool _isDarkLevel = false;
  final List<EditorItem> _items = [];
  EditorItem? _selectedItem;

  bool get _isInfinityTemplate => _currentLevel == 0;

  @override
  void initState() {
    super.initState();
    _initEditor();
  }

  Future<void> _initEditor() async {
    final lastLevelStr = await DatabaseHelper.instance.getConfig(
      'last_edited_level',
    );
    final lastLevel = lastLevelStr != null
        ? int.tryParse(lastLevelStr) ?? 1
        : 1;
    setState(() => _currentLevel = lastLevel);
    await _loadLevel(lastLevel);
  }

  Future<void> _loadLevel(int levelId) async {
    final jsonStr = await DatabaseHelper.instance.getCustomLevel(levelId);
    LevelData? data;
    if (jsonStr != null) {
      data = LevelData.fromJson(jsonDecode(jsonStr));
    } else if (levelId > 0) {
      final bakedLevel = await CampaignLevelRepository.instance.loadLevel(
        levelId,
      );
      data = bakedLevel?.toLevelData();
    }

    if (data != null) {
      _items.clear();

      _timeLimitSeconds = data.timeLimitSeconds;
      _timerSeconds = data.timerSeconds;
      _heightMultiplier = data.heightMultiplier;
      _hasBomb = data.hasBomb;
      _bombCount = data.bombCount;
      _isDarkLevel = data.isDarkLevel;

      for (var h in data.holes) {
        _items.add(
          EditorItem(
            type: h.behavior == HoleBehavior.nailLauncher
                ? EditorItemType.nailHole
                : h.behavior == HoleBehavior.split
                ? EditorItemType.splittingHole
                : h.behavior == HoleBehavior.orbit
                ? EditorItemType.orbitingHole
                : h.isSuckingHole
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
            moveAxis: h.moveAxis,
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
      for (var shield in data.shields) {
        _items.add(
          EditorItem(
            type: EditorItemType.shield,
            x: shield.x,
            y: shield.y,
            size: 34,
          ),
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
      for (var helper in data.shooterHelpers) {
        _items.add(
          EditorItem(
            type: EditorItemType.shooterHelper,
            x: helper.x,
            y: helper.y,
            size: 38,
          ),
        );
      }
      for (var villain in data.villains) {
        _items.add(
          EditorItem(
            type: EditorItemType.villain,
            x: villain.position.x,
            y: villain.position.y,
            size: villain.size,
            variant: villain.variant,
            health: villain.health,
          ),
        );
      }
      setState(() {});
    } else {
      setState(() {
        _items.clear();
        _selectedItem = null;
        _timeLimitSeconds = 60;
        _timerSeconds = 120.0;
        _heightMultiplier = 1.0;
        _hasBomb = false;
        _bombCount = 0;
        _isDarkLevel = false;
      });
    }
  }

  LevelData _generateLevelData() {
    final holes = <HoleData>[];
    final bumpers = <BumperData>[];
    final teleporters = <TeleporterData>[];
    final stars = <Vector2>[];
    final hearts = <Vector2>[];
    final shields = <Vector2>[];
    final magnets = <Vector2>[];
    final multiBalls = <Vector2>[];
    final shooterHelpers = <Vector2>[];
    final villains = <VillainData>[];

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
              moveAxis: item.moveAxis,
            ),
          );
          break;
        case EditorItemType.nailHole:
          holes.add(
            HoleData(
              pos,
              item.size,
              0,
              false,
              0,
              behavior: HoleBehavior.nailLauncher,
              warningDuration: 0.8,
              activeDuration: 2.2,
            ),
          );
          break;
        case EditorItemType.splittingHole:
          holes.add(
            HoleData(
              pos,
              item.size,
              0,
              false,
              0,
              behavior: HoleBehavior.split,
              activeDuration: 1.5,
              recoveryDuration: 1.0,
            ),
          );
          break;
        case EditorItemType.orbitingHole:
          holes.add(
            HoleData(
              pos,
              item.size,
              0,
              false,
              0,
              behavior: HoleBehavior.orbit,
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
        case EditorItemType.shield:
          shields.add(pos);
          break;
        case EditorItemType.magnet:
          magnets.add(pos);
          break;
        case EditorItemType.multiBall:
          multiBalls.add(pos);
          break;
        case EditorItemType.shooterHelper:
          shooterHelpers.add(pos);
          break;
        case EditorItemType.villain:
          villains.add(
            VillainData(
              position: pos,
              size: item.size,
              variant: item.variant,
              health: item.health,
            ),
          );
          break;
      }
    }

    return LevelData(
      holes: holes,
      stars: stars,
      hearts: hearts,
      shields: shields,
      bumpers: bumpers,
      teleporters: teleporters,
      magnets: magnets,
      multiBalls: multiBalls,
      shooterHelpers: shooterHelpers,
      villains: villains,
      timeLimitSeconds: _timeLimitSeconds,
      timerSeconds: _timerSeconds,
      heightMultiplier: _heightMultiplier,
      hasBomb: _hasBomb,
      bombCount: _hasBomb ? _bombCount : 0,
      isDarkLevel: _isDarkLevel,
    );
  }

  Future<void> _saveLevel() async {
    final data = _generateLevelData();
    final jsonStr = jsonEncode(data.toJson());
    await DatabaseHelper.instance.saveCustomLevel(
      _currentLevel,
      jsonStr,
      isInfinity: _isInfinityTemplate,
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved locally!')));
    }
  }

  void _copyToClipboard() {
    final data = _generateLevelData();
    final jsonStr = jsonEncode(data.toJson());
    Clipboard.setData(ClipboardData(text: '$_currentLevel: \'$jsonStr\','));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied JSON to clipboard!')));
  }

  Future<void> _testLevel() async {
    await _saveLevel();
    if (!mounted) return;
    final game = BalancoGame(
      isMultiplayer: false,
      isInfinityMode: _isInfinityTemplate,
      playerRole: '',
      onLevelComplete: () {
        Navigator.pop(context);
      },
    );
    if (!_isInfinityTemplate) {
      game.currentLevel.value = _currentLevel;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePlayOverlay(game: game)),
    );
  }

  void _showTimerDialog() {
    double tempTimer = _timerSeconds;
    double tempHeight = _heightMultiplier;
    bool tempDark = _isDarkLevel;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Level Settings"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${tempTimer.toInt()} Seconds",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: tempTimer,
                  min: 10,
                  max: 300,
                  divisions: 29,
                  label: "${tempTimer.toInt()}",
                  onChanged: (val) {
                    setDialogState(() => tempTimer = val);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  "Height ${tempHeight.toStringAsFixed(1)}x",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: tempHeight,
                  min: 1.0,
                  max: 6.0,
                  divisions: 20,
                  label: tempHeight.toStringAsFixed(1),
                  onChanged: (val) {
                    setDialogState(() => tempHeight = val);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text("Night Mode"),
                  value: tempDark,
                  onChanged: (val) {
                    setDialogState(() => tempDark = val);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _timerSeconds = tempTimer;
                    _timeLimitSeconds = tempTimer.toInt();
                    _heightMultiplier = tempHeight;
                    _isDarkLevel = tempDark;
                  });
                  _saveLevel();
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
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
                    moveAxis: 'horizontal',
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
                    // Grid lines
                    CustomPaint(
                      size: Size(width, height),
                      painter: GridPainter(),
                    ),

                    // Visualizer for moving holes paths
                    CustomPaint(
                      size: Size(width, height),
                      painter: PathVisualizerPainter(_items),
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

                    // Preview the exact saved suction radius independently
                    // for every vortex instead of showing only the hole body.
                    for (final item in _items)
                      if (item.type == EditorItemType.suckingHole &&
                          item.suckRadius > 0)
                        Positioned(
                          left: item.x * width - item.suckRadius,
                          top: item.y * height - item.suckRadius,
                          width: item.suckRadius * 2,
                          height: item.suckRadius * 2,
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.lightBlueAccent.withValues(
                                      alpha: 0.22,
                                    ),
                                    Colors.blueAccent.withValues(alpha: 0.05),
                                    Colors.transparent,
                                  ],
                                  stops: const [0, 0.72, 1],
                                ),
                                border: Border.all(
                                  color: Colors.lightBlueAccent.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                              ),
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
      case EditorItemType.nailHole:
      case EditorItemType.splittingHole:
      case EditorItemType.orbitingHole:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: type == EditorItemType.suckingHole
              ? const Icon(Icons.cyclone, color: Colors.blue)
              : type == EditorItemType.nailHole
              ? const Icon(Icons.push_pin, color: Colors.red)
              : type == EditorItemType.movingHole
              ? const Icon(Icons.compare_arrows, color: Colors.white)
              : type == EditorItemType.splittingHole
              ? const Icon(Icons.call_split, color: Colors.purpleAccent)
              : type == EditorItemType.orbitingHole
              ? const Icon(Icons.track_changes, color: Colors.tealAccent)
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
      case EditorItemType.shield:
        return const Icon(
          Icons.shield_rounded,
          color: Colors.lightBlueAccent,
          size: 30,
        );
      case EditorItemType.magnet:
        return const Icon(Icons.file_download, color: Colors.blue, size: 30);
      case EditorItemType.multiBall:
        return const Icon(
          Icons.control_point_duplicate,
          color: Colors.green,
          size: 30,
        );
      case EditorItemType.shooterHelper:
        return const Icon(
          Icons.rocket_launch_rounded,
          color: Colors.cyanAccent,
          size: 30,
        );
      case EditorItemType.villain:
        return const Icon(Icons.adb_rounded, color: Colors.redAccent, size: 34);
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
          if (_selectedItem!.type == EditorItemType.movingHole) ...[
            Row(
              children: [
                const Text('Axis:'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedItem!.moveAxis,
                  items: const [
                    DropdownMenuItem(
                      value: 'horizontal',
                      child: Text('Horizontal'),
                    ),
                    DropdownMenuItem(
                      value: 'vertical',
                      child: Text('Vertical'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedItem!.moveAxis = v!),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Range:'),
                Expanded(
                  child: Slider(
                    value: _selectedItem!.moveRange,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) =>
                        setState(() => _selectedItem!.moveRange = v),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Speed:'),
                Expanded(
                  child: Slider(
                    value: _selectedItem!.moveSpeed,
                    min: 0.0,
                    max: 10.0,
                    onChanged: (v) =>
                        setState(() => _selectedItem!.moveSpeed = v),
                  ),
                ),
              ],
            ),
          ],
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
          IconButton(
            icon: Icon(
              Icons.warning_amber_rounded,
              color: _hasBomb ? Colors.red : Colors.white70,
            ),
            tooltip: "Toggle Random Bomb Drops",
            onPressed: () {
              setState(() {
                _hasBomb = !_hasBomb;
                if (_hasBomb && _bombCount == 0) _bombCount = 1;
              });
            },
          ),
          if (_hasBomb)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: "Fewer Bombs",
                  onPressed: () {
                    setState(() {
                      _bombCount = (_bombCount - 1).clamp(1, 9);
                    });
                  },
                ),
                Text(
                  '$_bombCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: "More Bombs",
                  onPressed: () {
                    setState(() {
                      _bombCount = (_bombCount + 1).clamp(1, 9);
                    });
                  },
                ),
              ],
            ),
          IconButton(
            icon: Icon(
              Icons.dark_mode,
              color: _isDarkLevel ? Colors.indigoAccent : Colors.white70,
            ),
            tooltip: "Toggle Dark Level",
            onPressed: () {
              setState(() {
                _isDarkLevel = !_isDarkLevel;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.timer),
            tooltip: "Set Global Timer",
            onPressed: _showTimerDialog,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "${_timeLimitSeconds}s",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          DropdownButton<int>(
            value: _currentLevel,
            dropdownColor: Colors.blueGrey,
            style: const TextStyle(color: Colors.white),
            items: [
              const DropdownMenuItem(
                value: 0,
                child: Text('Infinity Template'),
              ),
              ...List.generate(500, (i) => i + 1).map((l) {
                return DropdownMenuItem(value: l, child: Text('Level $l'));
              }),
            ],
            onChanged: (v) async {
              if (v != null) {
                await DatabaseHelper.instance.saveConfig(
                  'last_edited_level',
                  v.toString(),
                );
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

class PathVisualizerPainter extends CustomPainter {
  final List<EditorItem> items;

  PathVisualizerPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var item in items) {
      if (item.type == EditorItemType.movingHole) {
        double cx = item.x * size.width;
        double cy = item.y * size.height;

        Path path = Path();
        if (item.moveAxis == 'horizontal') {
          double halfRange = (item.moveRange * size.width) / 2;
          path.moveTo(cx - halfRange, cy);
          path.lineTo(cx + halfRange, cy);
        } else {
          double halfRange = (item.moveRange * size.height) / 2;
          path.moveTo(cx, cy - halfRange);
          path.lineTo(cx, cy + halfRange);
        }

        // Draw dashed path
        const double dashWidth = 8;
        const double dashSpace = 6;
        double distance = 0;

        for (ui.PathMetric measurePath in path.computeMetrics()) {
          while (distance < measurePath.length) {
            canvas.drawPath(
              measurePath.extractPath(distance, distance + dashWidth),
              paint,
            );
            distance += dashWidth + dashSpace;
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PathVisualizerPainter oldDelegate) => true;
}
