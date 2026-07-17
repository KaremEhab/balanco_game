import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/editor/screens/level_editor_screen.dart'; // For EditorItemType
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:balanco_game/features/game/data/premade_levels.dart';
import 'package:balanco_game/features/game/data/online_level_repository.dart';
import 'package:balanco_game/features/game/level_system/campaign_level_generator.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/features/game/components/hole_component.dart';

class EditorOverlay extends StatefulWidget {
  final BalancoGame game;
  const EditorOverlay({super.key, required this.game});

  @override
  State<EditorOverlay> createState() => _EditorOverlayState();
}

class _EditorOverlayState extends State<EditorOverlay> {
  final TextEditingController _levelIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _levelIdController.text = widget.game.currentLevel.value.toString();
  }

  @override
  void dispose() {
    _levelIdController.dispose();
    super.dispose();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Editor Settings',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target Level ID',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextField(
                      controller: _levelIdController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black54,
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null) {
                          widget.game.currentLevel.value = parsed;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Level Height Multiplier (Scrolling)',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.game.currentHeightMultiplier.toStringAsFixed(1)}x',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: widget.game.currentHeightMultiplier,
                            min: 1.0,
                            max: 5.0,
                            divisions: 8,
                            onChanged: (val) {
                              setStateDialog(() {});
                              widget.game.currentHeightMultiplier = val;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Level Timer (Seconds)',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.game.levelTimer.toInt()}s',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: widget.game.levelTimer,
                            min: 10.0,
                            max: 300.0,
                            divisions: 29,
                            onChanged: (val) {
                              setStateDialog(() {});
                              widget.game.levelTimer = val;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Random Bomb Drops',
                        style: TextStyle(color: Colors.white70),
                      ),
                      value: widget.game.levelHasBomb,
                      activeThumbColor: GameColors.redAccent,
                      onChanged: (val) {
                        setStateDialog(() {
                          widget.game.levelHasBomb = val;
                          if (val && widget.game.levelBombCount == 0) {
                            widget.game.levelBombCount = 1;
                          }
                          if (!val) widget.game.levelBombCount = 0;
                        });
                      },
                    ),
                    if (widget.game.levelHasBomb)
                      Row(
                        children: [
                          const Text(
                            'Bomb Count',
                            style: TextStyle(color: Colors.white70),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setStateDialog(() {
                                widget.game.levelBombCount =
                                    (widget.game.levelBombCount - 1).clamp(
                                      1,
                                      9,
                                    );
                              });
                            },
                          ),
                          Text(
                            '${widget.game.levelBombCount}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setStateDialog(() {
                                widget.game.levelBombCount =
                                    (widget.game.levelBombCount + 1).clamp(
                                      1,
                                      9,
                                    );
                              });
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Night / Dark Mode',
                        style: TextStyle(color: Colors.white70),
                      ),
                      value: widget.game.isDarknessLevel,
                      activeThumbColor: Colors.deepPurpleAccent,
                      onChanged: (val) {
                        setStateDialog(() {
                          widget.game.isDarknessLevel = val;
                          widget.game.isDarknessLevelNotifier.value = val;
                          widget.game.darknessOpacityNotifier.value = val
                              ? 0.94
                              : 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Load Campaign Template',
                      style: TextStyle(color: Colors.white70),
                    ),
                    DropdownButton<int>(
                      dropdownColor: GameColors.black,
                      value: null,
                      hint: const Text(
                        'Select a template to load...',
                        style: TextStyle(color: Colors.white54),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: -1,
                          child: Text(
                            'Blank Canvas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const DropdownMenuItem(
                          value: 0,
                          child: Text(
                            'Saved Infinity Template',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ...List.generate(
                          CampaignLevelGenerator.lastCampaignLevel,
                          (index) => index + 1,
                        ).map(
                          (id) => DropdownMenuItem(
                            value: id,
                            child: Text(
                              'Campaign Level $id',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        ...PremadeLevels.levelsJson.keys.map(
                          (id) => DropdownMenuItem(
                            value: id,
                            child: Text(
                              'Legacy Premade $id',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) async {
                        if (val != null) {
                          if (val == 0) {
                            widget.game.currentLevel.value = 0;
                            _levelIdController.text = '0';
                            AppSettings.setLastEditedLevel(0);
                            widget.game.restartCurrentLevel();
                            if (!context.mounted) return;
                            setStateDialog(() {});
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Infinity Template Loaded!'),
                              ),
                            );
                            return;
                          }
                          await widget.game.loadEditorTemplate(val);
                          widget.game.currentLevel.value = val;
                          _levelIdController.text = val.toString();
                          AppSettings.setLastEditedLevel(val);
                          if (!context.mounted) return;
                          setStateDialog(() {});
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Template Loaded!')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: GameColors.blueAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _loadOnlineLevel() async {
    final levelId = widget.game.currentLevel.value;
    if (levelId < 1) return;
    final online = await OnlineLevelRepository.instance.loadLevel(levelId);
    if (!mounted) return;
    if (online == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No published online level found.')),
      );
      return;
    }

    if (online.definitionFormat == 'level_data_v1') {
      await DatabaseHelper.instance.saveCustomLevel(
        levelId,
        jsonEncode(online.definition),
      );
      await widget.game.restartCurrentLevel();
    } else {
      await widget.game.loadEditorTemplate(levelId);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loaded online level v${online.version}.')),
    );
  }

  Future<void> _publishOnlineLevel() async {
    final levelId = widget.game.currentLevel.value;
    if (levelId < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Infinity templates are not published here.'),
        ),
      );
      return;
    }
    try {
      final repository = OnlineLevelRepository.instance;
      if (!await repository.canPublish()) {
        throw StateError('This account is not an authorized level editor.');
      }
      final current = await repository.loadLevel(levelId);
      final definition = Map<String, dynamic>.from(
        jsonDecode(widget.game.exportLevelData()) as Map,
      );
      final published = await repository.publishLevel(
        levelId: levelId,
        definition: definition,
        expectedVersion: current?.version ?? 0,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Level $levelId v${published.version} is live for every player.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Online publish failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 70,
          right: 0,
          left: 0,
          child: // Center: Level Navigation
          Container(
            decoration: BoxDecoration(
              color: GameColors.transparentBlack.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    if (widget.game.currentLevel.value > 0) {
                      setState(() {
                        widget.game.currentLevel.value--;
                        _levelIdController.text = widget.game.currentLevel.value
                            .toString();
                        AppSettings.setLastEditedLevel(
                          widget.game.currentLevel.value,
                        );
                      });
                      widget.game.restartCurrentLevel();
                    }
                  },
                ),
                Text(
                  widget.game.currentLevel.value == 0
                      ? 'INFINITY'
                      : 'LVL ${widget.game.currentLevel.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      widget.game.currentLevel.value++;
                      _levelIdController.text = widget.game.currentLevel.value
                          .toString();
                      AppSettings.setLastEditedLevel(
                        widget.game.currentLevel.value,
                      );
                    });
                    widget.game.restartCurrentLevel();
                  },
                ),
              ],
            ),
          ),
        ),
        // Top Bar
        Positioned(
          top: 130,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _showSettingsDialog,
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.red, size: 30),
                  ),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GameColors.green300,
                        ),
                        onPressed: () async {
                          final jsonString = widget.game.exportLevelData();
                          await DatabaseHelper.instance.saveCustomLevel(
                            widget.game.currentLevel.value,
                            jsonString,
                            isInfinity: widget.game.currentLevel.value == 0,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Saved locally for Testing!'),
                              ),
                            );
                          }
                        },
                        child: const Icon(Icons.save),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GameColors.blueAccent,
                        ),
                        onPressed: () async {
                          final jsonString = widget.game.exportLevelData();
                          await DatabaseHelper.instance.saveCustomLevel(
                            widget.game.currentLevel.value,
                            jsonString,
                            isInfinity: widget.game.currentLevel.value == 0,
                          );
                          if (context.mounted) {
                            final testGame = BalancoGame(
                              isMultiplayer: false,
                              playerRole: 'host',
                              isInfinityMode:
                                  widget.game.currentLevel.value == 0,
                              isEditMode: false,
                            );
                            if (widget.game.currentLevel.value > 0) {
                              testGame.currentLevel.value = widget
                                  .game
                                  .currentLevel
                                  .value; // Play the exact level assigned
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GamePlayOverlay(game: testGame),
                              ),
                            );
                          }
                        },
                        child: const Icon(Icons.play_arrow),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Icon(Icons.copy),
                        onPressed: () {
                          final jsonString = widget.game.exportLevelData();
                          Clipboard.setData(ClipboardData(text: jsonString));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Level Data Copied!')),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _loadOnlineLevel,
                        child: const Icon(Icons.cloud_download_rounded),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GameColors.purpleAccent,
                        ),
                        onPressed: _publishOnlineLevel,
                        child: const Icon(Icons.cloud_upload_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Palette
        Positioned(
          bottom: 20,
          left: 10,
          right: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Properties Panel
              ValueListenableBuilder<PositionComponent?>(
                valueListenable: widget.game.selectedEditComponent,
                builder: (context, selected, child) {
                  if (selected == null) {
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: GameColors.transparentBlack.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: StatefulBuilder(
                        builder: (context, setStatePanel) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Level Properties',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Night Mode',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Switch(
                                    value: widget.game.isDarknessLevel,
                                    activeThumbColor: Colors.deepPurpleAccent,
                                    onChanged: (val) {
                                      setStatePanel(() {
                                        widget.game.isDarknessLevel = val;
                                        widget
                                                .game
                                                .isDarknessLevelNotifier
                                                .value =
                                            val;
                                        widget
                                            .game
                                            .darknessOpacityNotifier
                                            .value = val
                                            ? 0.94
                                            : 0.0;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Bombs',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Switch(
                                    value: widget.game.levelHasBomb,
                                    activeThumbColor: GameColors.redAccent,
                                    onChanged: (val) {
                                      setStatePanel(() {
                                        widget.game.levelHasBomb = val;
                                        if (val &&
                                            widget.game.levelBombCount == 0) {
                                          widget.game.levelBombCount = 1;
                                        }
                                        if (!val) {
                                          widget.game.levelBombCount = 0;
                                        }
                                      });
                                    },
                                  ),
                                  if (widget.game.levelHasBomb) ...[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => setStatePanel(() {
                                        widget.game.levelBombCount =
                                            (widget.game.levelBombCount - 1)
                                                .clamp(1, 9);
                                      }),
                                    ),
                                    Text(
                                      '${widget.game.levelBombCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => setStatePanel(() {
                                        widget.game.levelBombCount =
                                            (widget.game.levelBombCount + 1)
                                                .clamp(1, 9);
                                      }),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: GameColors.transparentBlack.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Scale:',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 120,
                              child: Slider(
                                value: selected.scale.x.clamp(0.5, 3.0),
                                min: 0.5,
                                max: 3.0,
                                onChanged: (val) {
                                  setState(() {
                                    selected.scale.setAll(val);
                                  });
                                },
                              ),
                            ),
                            if (selected is HoleComponent &&
                                selected.isSuckingHole) ...[
                              const SizedBox(width: 10),
                              const Text(
                                'Wind:',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 120,
                                child: Slider(
                                  value: selected.suckRadius.clamp(50.0, 500.0),
                                  min: 50.0,
                                  max: 500.0,
                                  onChanged: (val) {
                                    setState(() {
                                      selected.updateSuckRadius(val);
                                    });
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                widget.game.deleteSelectedEditComponent();
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),

              // Palette
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: GameColors.transparentBlack.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPaletteButton(
                        Icons.circle,
                        Colors.black,
                        EditorItemType.hole,
                      ),
                      _buildPaletteButton(
                        Icons.cyclone,
                        Colors.blue,
                        EditorItemType.suckingHole,
                      ),
                      _buildPaletteButton(
                        Icons.open_with,
                        Colors.orange,
                        EditorItemType.movingHole,
                      ),
                      _buildPaletteButton(
                        Icons.push_pin_rounded,
                        Colors.redAccent,
                        EditorItemType.nailHole,
                      ),
                      _buildPaletteButton(
                        Icons.call_split_rounded,
                        Colors.purpleAccent,
                        EditorItemType.splittingHole,
                      ),
                      _buildPaletteButton(
                        Icons.track_changes_rounded,
                        Colors.tealAccent,
                        EditorItemType.orbitingHole,
                      ),
                      _buildPaletteButton(
                        Icons.star,
                        Colors.yellow,
                        EditorItemType.star,
                      ),
                      _buildPaletteButton(
                        Icons.favorite,
                        Colors.red,
                        EditorItemType.heart,
                      ),
                      _buildPaletteButton(
                        Icons.circle,
                        Colors.grey,
                        EditorItemType.bumper,
                      ),
                      _buildPaletteButton(
                        Icons.all_out,
                        Colors.cyan,
                        EditorItemType.teleporter,
                      ),
                      _buildPaletteButton(
                        Icons.file_download,
                        Colors.blue,
                        EditorItemType.magnet,
                      ),
                      _buildPaletteButton(
                        Icons.control_point_duplicate,
                        Colors.green,
                        EditorItemType.multiBall,
                      ),
                      _buildPaletteButton(
                        Icons.rocket_launch_rounded,
                        Colors.cyanAccent,
                        EditorItemType.shooterHelper,
                      ),
                      _buildPaletteButton(
                        Icons.adb_rounded,
                        Colors.deepOrange,
                        EditorItemType.villain,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaletteButton(IconData icon, Color color, EditorItemType type) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: () {
        widget.game.spawnEditComponent(type);
      },
    );
  }
}
