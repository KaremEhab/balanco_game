import 'package:flutter/material.dart';
import '../game/game_area.dart';
import '../game/components/game_area/magnate_painter.dart';

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

          // Central Action / Power-Up Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Left Shield
                  ValueListenableBuilder<int>(
                    valueListenable: game.remainingShields,
                    builder: (context, shields, child) {
                      return ValueListenableBuilder<double>(
                        valueListenable: game.shieldTimerNotifier,
                        builder: (context, shieldTime, child) {
                          return SquarePowerButton(
                            game: game,
                            charges: shields,
                            activeTime: shieldTime,
                            maxTime: 5.0,
                            iconType: 'SHIELD',
                            onTap: () {
                              game.remainingShields.value -= 1;
                              game.shieldTimer = 5.0;
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // Center Magnet
                  ValueListenableBuilder<int>(
                    valueListenable: game.remainingMagnets,
                    builder: (context, magnets, child) {
                      return ValueListenableBuilder<double>(
                        valueListenable: game.magnetTimerNotifier,
                        builder: (context, magnetTime, child) {
                          return SquarePowerButton(
                            game: game,
                            charges: magnets,
                            activeTime: magnetTime,
                            maxTime: 5.0,
                            iconType: 'MAGNET',
                            onTap: () {
                              game.remainingMagnets.value -= 1;
                              game.magnetTimer = 5.0;
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // Right Shield (same instance state)
                  ValueListenableBuilder<int>(
                    valueListenable: game.remainingShields,
                    builder: (context, shields, child) {
                      return ValueListenableBuilder<double>(
                        valueListenable: game.shieldTimerNotifier,
                        builder: (context, shieldTime, child) {
                          return SquarePowerButton(
                            game: game,
                            charges: shields,
                            activeTime: shieldTime,
                            maxTime: 5.0,
                            iconType: 'SHIELD',
                            onTap: () {
                              game.remainingShields.value -= 1;
                              game.shieldTimer = 5.0;
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SquarePowerButton extends StatefulWidget {
  final BalancoGame game;
  final int charges;
  final double activeTime;
  final double maxTime;
  final String iconType;
  final VoidCallback onTap;

  const SquarePowerButton({
    super.key,
    required this.game,
    required this.charges,
    required this.activeTime,
    required this.maxTime,
    required this.iconType,
    required this.onTap,
  });

  @override
  State<SquarePowerButton> createState() => _SquarePowerButtonState();
}

class _SquarePowerButtonState extends State<SquarePowerButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.activeTime > 0;
    bool hasCharges = widget.charges > 0;
    bool canClick = hasCharges && !isActive;

    bool isMagnet = widget.iconType == 'MAGNET';
    List<Color> gradientColors = isMagnet
        ? [const Color(0xffFF6B6B), const Color(0xffD32A2A)]
        : [const Color(0xff6BABFF), const Color(0xff2A75D3)];
    Color shadowColor = isMagnet ? const Color(0xff8C1A1A) : const Color(0xff1A4B8C);

    return GestureDetector(
      onTapDown: (_) {
        if (canClick) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (canClick) {
          setState(() => _isPressed = false);
          widget.onTap();
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
          opacity: canClick || isActive ? 1.0 : 0.4,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(color: shadowColor, offset: const Offset(0, 6)),
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isPressed ? 0.2 : 0.45),
                  offset: Offset(0, _isPressed ? 4 : 8),
                  blurRadius: _isPressed ? 4 : 6,
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isActive)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 64.0 * (widget.activeTime / widget.maxTime).clamp(0.0, 1.0),
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0x33000000),
                        width: 2,
                      ),
                    ),
                  ),
                  // Icon Rendering
                  if (isMagnet)
                    SizedBox(
                      width: 32,
                      height: 40,
                      child: CustomPaint(
                        painter: MagnatePainter(),
                        child: Transform.scale(
                          scale: 0.7, // shrink painter to fit in 32x40
                          child: const SizedBox(),
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  Positioned(
                    top: 6,
                    left: 12,
                    right: 12,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
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
  int? _pointerId; // Track the specific finger using this joystick

  void _onPointerDown(PointerDownEvent event) {
    if (_pointerId != null) return; // Ignore if already being dragged
    _pointerId = event.pointer;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _pointerId) return; // Only respond to the locked finger
    setState(() {
      _dy = (_dy + event.delta.dy).clamp(-_maxDrag, _maxDrag);
    });
    widget.onChanged(_dy / _maxDrag);
  }

  void _onPointerUp(PointerEvent event) {
    if (event.pointer != _pointerId) return; // Only respond to the locked finger
    _pointerId = null;
    _resetPosition();
  }

  void _resetPosition() {
    setState(() {
      _dy = 0.0;
    });
    widget.onChanged(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerUp,
      behavior: HitTestBehavior.opaque,
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
                          color: Colors.white.withValues(alpha: 0.7),
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
