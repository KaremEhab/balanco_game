import 'dart:ui';
import 'package:flutter/material.dart';
import '../game/game_area.dart';

class GameControlsOverlay extends StatelessWidget {
  final BalancoGame game;

  const GameControlsOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // Reduced height as requested
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Left Joystick
          if (game.playerRole == 'BOTH' || game.playerRole == 'LEFT')
            Positioned(
              left: 20,
              bottom: 0,
              child: VerticalJoystick(
                isLeft: true,
                onChanged: (val) => game.leftJoystickValue = val,
              ),
            ),

          // Right Joystick
          if (game.playerRole == 'BOTH' || game.playerRole == 'RIGHT')
            Positioned(
              right: 20,
              bottom: 0,
              child: VerticalJoystick(
                isLeft: false,
                onChanged: (val) => game.rightJoystickValue = val,
              ),
            ),

          // Central Action / Power-Up Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ValueListenableBuilder<int>(
                valueListenable: game.remainingShields,
                builder: (context, shields, child) {
                  return ValueListenableBuilder<double>(
                    valueListenable: game.shieldTimerNotifier,
                    builder: (context, shieldTime, child) {
                      return ShieldButton(
                        game: game,
                        shields: shields,
                        shieldTime: shieldTime,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShieldButton extends StatefulWidget {
  final BalancoGame game;
  final int shields;
  final double shieldTime;

  const ShieldButton({
    super.key,
    required this.game,
    required this.shields,
    required this.shieldTime,
  });

  @override
  State<ShieldButton> createState() => _ShieldButtonState();
}

class _ShieldButtonState extends State<ShieldButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    bool isShieldActive = widget.shieldTime > 0;
    bool hasShields = widget.shields > 0;
    bool canClick = hasShields && !isShieldActive;

    return GestureDetector(
      onTapDown: (_) {
        if (canClick) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (canClick) {
          setState(() => _isPressed = false);
          widget.game.remainingShields.value -= 1;
          widget.game.shieldTimer = 5.0; // 5 seconds of protection
        }
      },
      onTapCancel: () {
        if (canClick) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
        child: Opacity(
          opacity: canClick || isShieldActive ? 1.0 : 0.4,
          child: Container(
            width: 160,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                colors: [Color(0xff6BABFF), Color(0xff2A75D3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                const BoxShadow(color: Color(0xff1A4B8C), offset: Offset(0, 6)),
                BoxShadow(
                  color: Colors.black.withOpacity(_isPressed ? 0.2 : 0.45),
                  offset: Offset(0, _isPressed ? 4 : 8),
                  blurRadius: _isPressed ? 4 : 6,
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isShieldActive)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width:
                            160.0 * (widget.shieldTime / 5.0).clamp(0.0, 1.0),
                        color: Colors.white.withOpacity(0.35),
                      ),
                    ),
                  Container(
                    width: 144,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0x33000000),
                        width: 2,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isShieldActive) ...[
                        const Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        isShieldActive
                            ? "${widget.shieldTime.toStringAsFixed(1)}s"
                            : "SHIELD",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 6,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalJoystick extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final bool isLeft;

  const VerticalJoystick({
    super.key,
    required this.onChanged,
    required this.isLeft,
  });

  @override
  State<VerticalJoystick> createState() => _VerticalJoystickState();
}

class _VerticalJoystickState extends State<VerticalJoystick> {
  double _dy = 0.0;
  final double _maxDrag =
      32.0; // Reduced travel distance to match shorter height

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
    return GestureDetector(
      onVerticalDragStart: (_) {},
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
            // 2.5D Wooden Base
            Container(
              width: 44,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD59E60), Color(0xFFB57E40)], // Wooden base
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF8A5A2B), // 3D thickness (dark wood)
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 6),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                // Recessed track indent
                child: Container(
                  width: 16,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF5E3A18), // Deep shadow inside track
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54, // Inner shadow simulation
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2.5D Joystick Knob
            Align(
              alignment: Alignment(0, _dy / _maxDrag),
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xffFFDA73),
                      Color(0xffF8AE00),
                    ], // Vibrant highlight
                    center: Alignment(
                      -0.3,
                      -0.3,
                    ), // Top-left specular highlight
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffB36A00), // Knob 3D thickness
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 8),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Concentric circle detailing
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x33000000),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x33000000),
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Specular reflection dot
                    Positioned(
                      top: 10,
                      left: 14,
                      child: Container(
                        width: 8,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
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
