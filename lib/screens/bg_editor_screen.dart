import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game/components/game_area/sky_painter.dart';
import '../game/components/game_area/mountains_painter.dart';
import '../game/components/game_area/sea_painter.dart';
import '../game/components/game_area/trees_painter.dart';

class BgLayerData {
  final String id;
  final String className;
  final CustomPainter painter;
  double dx;
  double dy;
  double scale;
  double depthMultiplier;

  BgLayerData({
    required this.id,
    required this.className,
    required this.painter,
    this.dx = 0,
    this.dy = 0,
    this.scale = 1.0,
    required this.depthMultiplier,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'dx': dx,
      'dy': dy,
      'scale': scale,
      'depthMultiplier': depthMultiplier,
    };
  }
}

class BgEditorScreen extends StatefulWidget {
  final VoidCallback? onExit;
  const BgEditorScreen({super.key, this.onExit});

  @override
  State<BgEditorScreen> createState() => _BgEditorScreenState();
}

class _BgEditorScreenState extends State<BgEditorScreen> {
  late List<BgLayerData> layers;
  String? _activeLayerId;
  bool _isPanelVisible = false;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    _initDefaultLayers();
    _loadFromPrefs();
  }

  void _initDefaultLayers() {
    layers = [
      BgLayerData(id: 'sky', className: 'SkyPainter()', painter: SkyPainter(), depthMultiplier: 0.05),
      BgLayerData(id: 'c1', className: 'FirstCloudPainter()', painter: FirstCloudPainter(), depthMultiplier: 0.1),
      BgLayerData(id: 'c2', className: 'SecondCloudPainter()', painter: SecondCloudPainter(), depthMultiplier: 0.12),
      BgLayerData(id: 'c3', className: 'ThirdCloudPainter()', painter: ThirdCloudPainter(), depthMultiplier: 0.14),
      BgLayerData(id: 'c4', className: 'ForthCloudPainter()', painter: ForthCloudPainter(), depthMultiplier: 0.16),
      BgLayerData(id: 'c5', className: 'FifthCloudPainter()', painter: FifthCloudPainter(), depthMultiplier: 0.18),
      BgLayerData(id: 'birds', className: 'BirdsPainter()', painter: BirdsPainter(), depthMultiplier: 0.2),
      BgLayerData(id: 'bmountain', className: 'BackMountainPainter()', painter: BackMountainPainter(), depthMultiplier: 0.3),
      BgLayerData(id: 'fsea', className: 'FurtherSeaPainter()', painter: FurtherSeaPainter(), depthMultiplier: 0.4),
      BgLayerData(id: 'mwaves', className: 'SeaMountainWaves()', painter: SeaMountainWaves(), depthMultiplier: 0.45),
      BgLayerData(id: 'shadows', className: 'MountainSeaShadowsPainter()', painter: MountainSeaShadowsPainter(), depthMultiplier: 0.5),
      BgLayerData(id: 'csea', className: 'CloserSeaPainter()', painter: CloserSeaPainter(), depthMultiplier: 0.6),
      BgLayerData(id: 'drops', className: 'SeaWaterDropsPainter()', painter: SeaWaterDropsPainter(), depthMultiplier: 0.7),
      BgLayerData(id: 'fmountain', className: 'FrontMountainPainter()', painter: FrontMountainPainter(), depthMultiplier: 0.8),
      BgLayerData(id: 'ltree', className: 'LeftTreePainter()', painter: LeftTreePainter(), depthMultiplier: 1.0),
      BgLayerData(id: 'rtree', className: 'RightTreePainter()', painter: RightTreePainter(), depthMultiplier: 1.0),
    ];
  }

  CustomPainter _getPainter(String className) {
    if (className.contains('SkyPainter')) return SkyPainter();
    if (className.contains('FirstCloud')) return FirstCloudPainter();
    if (className.contains('SecondCloud')) return SecondCloudPainter();
    if (className.contains('ThirdCloud')) return ThirdCloudPainter();
    if (className.contains('ForthCloud')) return ForthCloudPainter();
    if (className.contains('FifthCloud')) return FifthCloudPainter();
    if (className.contains('BirdsPainter')) return BirdsPainter();
    if (className.contains('BackMountain')) return BackMountainPainter();
    if (className.contains('FurtherSea')) return FurtherSeaPainter();
    if (className.contains('SeaMountainWaves')) return SeaMountainWaves();
    if (className.contains('MountainSeaShadows')) return MountainSeaShadowsPainter();
    if (className.contains('CloserSea')) return CloserSeaPainter();
    if (className.contains('SeaWaterDrops')) return SeaWaterDropsPainter();
    if (className.contains('FrontMountain')) return FrontMountainPainter();
    if (className.contains('LeftTreePainter')) return LeftTreePainter();
    if (className.contains('RightTreePainter')) return RightTreePainter();
    return SkyPainter();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('bg_editor_layers');
    if (savedData != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(savedData);
        final List<BgLayerData> loadedLayers = jsonList.map((item) {
          return BgLayerData(
            id: item['id'] ?? 'layer_${DateTime.now().microsecondsSinceEpoch}',
            className: item['className'],
            painter: _getPainter(item['className']),
            dx: item['dx']?.toDouble() ?? 0.0,
            dy: item['dy']?.toDouble() ?? 0.0,
            scale: item['scale']?.toDouble() ?? 1.0,
            depthMultiplier: item['depthMultiplier']?.toDouble() ?? 0.0,
          );
        }).toList();
        setState(() {
          layers = loadedLayers;
        });
      } catch (e) {
        debugPrint("Error loading saved layers: $e");
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(layers.map((l) => l.toJson()).toList());
    await prefs.setString('bg_editor_layers', jsonData);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layers saved locally!')),
      );
    }
  }

  void _copyToClipboard() {
    // Generate Dart code snippet
    StringBuffer buffer = StringBuffer();
    for (var layer in layers) {
      buffer.writeln("                _buildLayer(${layer.className}, ${layer.depthMultiplier}, dx: ${layer.dx.toStringAsFixed(1)}, dy: ${layer.dy.toStringAsFixed(1)}, scale: ${layer.scale.toStringAsFixed(2)}),");
    }
    
    Clipboard.setData(ClipboardData(text: buffer.toString())).then((_) {
      debugPrint("--- BACKGROUND DATA ---");
      debugPrint(buffer.toString());
      debugPrint("-----------------------");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Layer data copied to clipboard!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCCFFFB), // Base sky color
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.onExit != null)
            FloatingActionButton(
              heroTag: 'exit_btn',
              backgroundColor: Colors.redAccent,
              onPressed: widget.onExit,
              child: const Icon(Icons.close, color: Colors.white),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'toggle_panel_btn',
            backgroundColor: Colors.orangeAccent,
            onPressed: () {
              setState(() {
                _isPanelVisible = !_isPanelVisible;
              });
            },
            child: Icon(_isPanelVisible ? Icons.expand_more : Icons.list, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'save_btn',
            backgroundColor: Colors.green,
            onPressed: _saveToPrefs,
            child: const Icon(Icons.save, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'copy_btn',
            backgroundColor: Colors.blueAccent,
            onPressed: _copyToClipboard,
            child: const Icon(Icons.copy, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
        children: [
          // Visualizer
          Expanded(
            flex: _isPanelVisible ? 6 : 10,
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  if (layers.isEmpty) return;
                  if (_activeLayerId == null) {
                    _activeLayerId = layers.last.id;
                  } else {
                    int index = layers.indexWhere((l) => l.id == _activeLayerId);
                    if (index <= 0) {
                      _activeLayerId = null;
                    } else {
                      _activeLayerId = layers[index - 1].id;
                    }
                  }
                  
                  if (_activeLayerId != null) {
                    final activeLayer = layers.firstWhere((l) => l.id == _activeLayerId);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Selected: ${activeLayer.className.replaceAll("()", "")}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                });
              },
              onScaleStart: (details) {
                if (_activeLayerId == null) return;
                final activeLayer = layers.firstWhere((l) => l.id == _activeLayerId);
                _baseScale = activeLayer.scale;
              },
              onScaleUpdate: (details) {
                if (_activeLayerId == null) return;
                setState(() {
                  final activeLayer = layers.firstWhere((l) => l.id == _activeLayerId);
                  double scaleFactor = MediaQuery.of(context).size.height * 0.6 / 475.0; 
                  
                  activeLayer.dx += details.focalPointDelta.dx / scaleFactor;
                  activeLayer.dy += details.focalPointDelta.dy / scaleFactor;
                  
                  if (details.scale != 1.0) {
                    activeLayer.scale = _baseScale * details.scale;
                  }
                });
              },
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 1000,
                    height: 475,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: layers.map((layer) {
                        bool isActive = layer.id == _activeLayerId;
                        return Positioned.fill(
                          key: ValueKey(layer.id),
                          child: Transform.translate(
                            offset: Offset(layer.dx, layer.dy),
                            child: Opacity(
                              opacity: 1.0,
                              child: Transform.scale(
                                scale: layer.scale,
                                child: Container(
                                  foregroundDecoration: isActive
                                      ? BoxDecoration(
                                          border: Border.all(color: Colors.red, width: 4 / layer.scale),
                                        )
                                      : null,
                                  child: CustomPaint(
                                    size: const Size(1000, 475),
                                    painter: layer.painter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Control Panel
          if (_isPanelVisible)
            Expanded(
              flex: 4,
              child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue.shade50,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Drag list to reorder (Z-index). Tap to select and drag on screen.',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: layers.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = layers.removeAt(oldIndex);
                          layers.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (context, index) {
                        final layer = layers[index];
                        final isActive = layer.id == _activeLayerId;
                        return ListTile(
                          key: ValueKey(layer.id),
                          selected: isActive,
                          selectedTileColor: Colors.blue.shade100,
                          onTap: () {
                            setState(() {
                              _activeLayerId = isActive ? null : layer.id;
                            });
                          },
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          title: Text(
                            layer.className.replaceAll('()', ''),
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            'Offset: (\${layer.dx.toStringAsFixed(1)}, \${layer.dy.toStringAsFixed(1)}) | Scale: \${layer.scale.toStringAsFixed(2)} | Depth: \${layer.depthMultiplier}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, color: Colors.black54),
                                tooltip: 'Duplicate Layer',
                                onPressed: () {
                                  setState(() {
                                    final newLayer = BgLayerData(
                                      id: '\${layer.id}_copy_\${DateTime.now().millisecondsSinceEpoch}',
                                      className: layer.className,
                                      painter: layer.painter,
                                      dx: layer.dx + 20,
                                      dy: layer.dy + 20,
                                      scale: layer.scale,
                                      depthMultiplier: layer.depthMultiplier,
                                    );
                                    layers.insert(index + 1, newLayer);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                tooltip: 'Delete Layer',
                                onPressed: () {
                                  setState(() {
                                    if (_activeLayerId == layer.id) {
                                      _activeLayerId = null;
                                    }
                                    layers.removeAt(index);
                                  });
                                },
                              ),
                              if (isActive)
                                const Icon(Icons.check_circle, color: Colors.blue),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
