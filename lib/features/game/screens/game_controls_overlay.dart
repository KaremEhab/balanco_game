import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/components/game_area/magnate_btn_painter.dart';
import 'package:balanco_game/features/game/components/game_area/shield_btn_painter.dart';

class GameControlsOverlay extends StatelessWidget {
  final BalancoGame game;

  const GameControlsOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Left Joystick
          if (game.playerRole == 'BOTH' || game.playerRole == 'LEFT')
            Positioned(
              left: 15,
              bottom: 0,
              child: VerticalJoystick(
                isLeft: true,
                onChanged: (val) => game.leftJoystickValue = val,
              ),
            ),

          // Right Joystick
          if (game.playerRole == 'BOTH' || game.playerRole == 'RIGHT')
            Positioned(
              right: 15,
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
              padding: const EdgeInsets.only(bottom: 50),
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
                  // Right Shield removed as per user request
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
          opacity: canClick || isActive ? 1.0 : 0.5,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The new custom painted buttons
                SizedBox(
                  width: 64,
                  height: 64,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CustomPaint(
                        painter: isMagnet
                            ? MagnateBtnPainter()
                            : ShieldBtnPainter(),
                        foregroundPainter: isActive
                            ? ActiveTimePainter(
                                isMagnet: isMagnet,
                                progress: (widget.activeTime / widget.maxTime)
                                    .clamp(0.0, 1.0),
                              )
                            : null,
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
    if (event.pointer != _pointerId) {
      return; // Only respond to the locked finger
    }
    setState(() {
      _dy = (_dy + event.delta.dy).clamp(-_maxDrag, _maxDrag);
    });
    widget.onChanged(_dy / _maxDrag);
  }

  void _onPointerUp(PointerEvent event) {
    if (event.pointer != _pointerId) {
      return; // Only respond to the locked finger
    }
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
        width: 120,
        height: 150,
        color: Colors.transparent, // Touch target
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 2.5D Glossy Surfboard Base (Beach Yellow)
            Container(
              width: 60,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFE082), // Top highlight
                    Color(0xFFFFCA28), // Base
                    Color(0xFFFFB300), // Mid shadow
                    Color(0xFFFF8F00), // Bottom shadow
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF5D4037), // 3D thickness (dark brown)
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
                // Recessed track indent (Crimson red matching surfboard groove)
                child: Container(
                  width: 30,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4E342E), Color(0xFF6D4C41)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
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

            // 2.5D Glossy Orange Knob
            Align(
              alignment: Alignment(0, _dy / _maxDrag),
              child: Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFFF3E0), // Bright highlight
                      Color(0xFFFFB74D), // Main orange
                      Color(0xFFF57C00), // Shadow edge
                    ],
                    center: Alignment(
                      -0.3,
                      -0.3,
                    ), // Top-left specular highlight
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE65100), // Knob 3D thickness
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
                          color: Color(0x33000000),
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
                          color: Color(0x33000000),
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Specular reflection dot (stronger white for glossy feel)
                    Positioned(
                      top: 10,
                      left: 14,
                      child: Container(
                        width: 12,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color(0xD9FFFFFF), // 85% opacity white
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

class ActiveTimePainter extends CustomPainter {
  final bool isMagnet;
  final double progress;

  ActiveTimePainter({required this.isMagnet, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    RRect bgRRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );

    canvas.save();
    canvas.clipRRect(bgRRect);

    // Calculate height based on progress (bottom up)
    final fillHeight = bgRRect.height * progress;
    final topY = bgRRect.bottom - fillHeight;

    canvas.drawRect(
      Rect.fromLTRB(bgRRect.left, topY, bgRRect.right, bgRRect.bottom),
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ActiveTimePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isMagnet != isMagnet;
  }
}
