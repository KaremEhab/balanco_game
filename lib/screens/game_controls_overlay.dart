import 'dart:ui';
import 'package:flutter/material.dart';

import '../game/game_area.dart';

class GameControlsOverlay extends StatelessWidget {
  final BalancoGame game;
  final VoidCallback onPausePressed;

  const GameControlsOverlay({
    super.key,
    required this.game,
    required this.onPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.brown.shade900.withValues(alpha: 0.3) : const Color(0xFFFFF3E0).withValues(alpha: 0.4), // Sandy/Woody glass
              border: Border.all(color: isDark ? Colors.brown.shade300.withValues(alpha: 0.2) : Colors.orangeAccent.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left Joystick
                if (game.playerRole == 'BOTH' || game.playerRole == 'LEFT')
                  VerticalJoystick(
                    onChanged: (val) => game.leftJoystickValue = val,
                    color: Colors.greenAccent,
                  )
                else
                  const SizedBox(width: 80),

                // Stop Game Button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.brown.shade800 : Colors.orange.shade100, // Beachy pause button
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.orangeAccent.withValues(alpha: 0.2) : Colors.orangeAccent.withValues(alpha: 0.4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: onPausePressed,
                    icon: const Icon(Icons.pause_rounded),
                    color: isDark ? Colors.orangeAccent : Colors.deepOrange,
                    iconSize: 48,
                  ),
                ),

                // Right Joystick
                if (game.playerRole == 'BOTH' || game.playerRole == 'RIGHT')
                  VerticalJoystick(
                    onChanged: (val) => game.rightJoystickValue = val,
                    color: Colors.orangeAccent,
                  )
                else
                  const SizedBox(width: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalJoystick extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final Color color;

  const VerticalJoystick({
    super.key,
    required this.onChanged,
    required this.color,
  });

  @override
  State<VerticalJoystick> createState() => _VerticalJoystickState();
}

class _VerticalJoystickState extends State<VerticalJoystick> {
  double _dy = 0.0;
  final double _maxDrag = 50.0;

  void _updatePositionFromDelta(double deltaDy) {
    setState(() {
      _dy = (_dy + deltaDy).clamp(-_maxDrag, _maxDrag);
    });
    widget.onChanged(_dy / _maxDrag);
  }

  void _resetPosition() {
    setState(() {
      _dy = 0.0;
    });
    widget.onChanged(0.0);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onVerticalDragStart:
          (_) {}, // Do nothing on initial tap to prevent jumping
      onVerticalDragUpdate: (details) =>
          _updatePositionFromDelta(details.delta.dy),
      onVerticalDragEnd: (_) => _resetPosition(),
      onVerticalDragCancel: () => _resetPosition(),
      child: Container(
        width: 80,
        height: 120,
        color: Colors.transparent, // Touch target
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Track Groove (Inset effect)
            Container(
              width: 16,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3E2723) : const Color(0xFF6D4C41), // Dark wood groove
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? const Color(0xFF1B0000) : const Color(0xFF4E342E),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            // Track indicators
            Positioned(
              top: 10,
              child: Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.white54),
            ),
            Positioned(
              bottom: 10,
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.white54,
              ),
            ),

            // 2.5D Knob
            AnimatedPositioned(
              duration: _dy == 0
                  ? const Duration(milliseconds: 200)
                  : Duration.zero,
              curve: Curves.elasticOut,
              top: 60 + _dy - 25, // 60 is center, 25 is half knob height
              child: SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Bottom shadow / base (creates the 3D thickness)
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    // Top Face of the 3D block
                    Container(
                      height: 42,
                      margin: const EdgeInsets.only(
                        bottom: 6,
                      ), // Shifted up to expose the dark "thickness"
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark 
                             ? [const Color(0xFF8D6E63), const Color(0xFF5D4037)] // Wood texture colors
                             : [const Color(0xFFD7CCC8), const Color(0xFFA1887F)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? const Color(0xFF4E342E) : const Color(0xFF8D6E63), width: 1.5),
                      ),
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withValues(alpha: 0.8),
                                blurRadius: 4,
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
          ],
        ),
      ),
    );
  }
}
