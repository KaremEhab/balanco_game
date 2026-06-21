import 'package:flutter/material.dart';
import '../game/game_area.dart';
import '../game/components/game_area/magnate_painter.dart';
import '../game/components/game_area/magnate_btn_painter.dart';
import '../game/components/game_area/shield_btn_painter.dart';

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
                // Drop shadow underlay to compensate for removed outer decoration
                Positioned(
                  left: 2,
                  right: 2,
                  top: 2,
                  bottom: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isMagnet ? const Color(0xff8C1A1A) : const Color(0xff1A4B8C),
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: _isPressed ? 0.2 : 0.45),
                          offset: Offset(0, _isPressed ? 4 : 8),
                          blurRadius: _isPressed ? 4 : 6,
                        ),
                      ],
                    ),
                  ),
                ),

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
                        painter: isMagnet ? MagnateBtnPainter() : ShieldBtnPainter(),
                        foregroundPainter: isActive ? ActiveTimePainter(
                          isMagnet: isMagnet,
                          progress: (widget.activeTime / widget.maxTime).clamp(0.0, 1.0),
                        ) : null,
                      ),
                    ),
                  ),
                ),
                
                // Inner White Shadow overlay
                Positioned(
                  left: 2,
                  right: 2,
                  top: 2,
                  bottom: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.6),
                          Colors.white.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.2),
                        ],
                        stops: const [0.0, 0.25, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
                  
                // Charges Badge
                if (hasCharges)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xffFF3B30),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black45, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        '${widget.charges}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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

class ActiveTimePainter extends CustomPainter {
  final bool isMagnet;
  final double progress;

  ActiveTimePainter({
    required this.isMagnet,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    RRect bgRRect;
    if (isMagnet) {
      bgRRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.02173913,
          size.height * 0.02000000,
          size.width * 0.9565217,
          size.height * 0.8800000,
        ),
        bottomRight: Radius.circular(size.width * 0.3260870),
        bottomLeft: Radius.circular(size.width * 0.3260870),
        topLeft: Radius.circular(size.width * 0.3260870),
        topRight: Radius.circular(size.width * 0.3260870),
      );
    } else {
      bgRRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.08666000,
          size.height * 0.02000000,
          size.width * 0.8800000,
          size.height * 0.8800000,
        ),
        bottomRight: Radius.circular(size.width * 0.3000000),
        bottomLeft: Radius.circular(size.width * 0.3000000),
        topLeft: Radius.circular(size.width * 0.3000000),
        topRight: Radius.circular(size.width * 0.3000000),
      );
    }

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
