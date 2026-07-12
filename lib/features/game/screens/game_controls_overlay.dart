import 'dart:async';
import 'dart:ui';

import 'package:balanco_game/features/map/theme/biome_config.dart';
import 'package:flutter/material.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/game/components/game_area/shield_icon_painter.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/map/models/biome_model.dart';
import 'package:balanco_game/features/coop/application/coop_game_coordinator.dart';

class GameControlsOverlay extends StatelessWidget {
  final BalancoGame game;
  final CoopGameCoordinator? coopCoordinator;

  const GameControlsOverlay({
    super.key,
    required this.game,
    this.coopCoordinator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.currentLevel,
      builder: (context, level, child) {
        final currentBiome = game.isInfinityMode
            ? game.currentBiome
            : BiomeConfig.getBiomeForLevel(level);
        final powerUpColors = game.isInfinityMode
            ? [
                GameColors.white.withValues(alpha: 0.2),
                GameColors.white.withValues(alpha: 0.2),
              ]
            : [
                currentBiome.nodeUnlockedColor,
                currentBiome.secondaryColor,
                currentBiome.nodeUnlockedBorderColor,
              ];
        return SizedBox(
          height: 200,
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
                    biome: currentBiome,
                    isInfinityMode: game.isInfinityMode,
                    onChanged: (val) => _setJoystick(val, isLeft: true),
                  ),
                ),

              // Right Joystick
              if (game.playerRole == 'BOTH' || game.playerRole == 'RIGHT')
                Positioned(
                  right: 15,
                  bottom: 0,
                  child: VerticalJoystick(
                    isLeft: false,
                    biome: currentBiome,
                    isInfinityMode: game.isInfinityMode,
                    onChanged: (val) => _setJoystick(val, isLeft: false),
                  ),
                ),

              // Central Action / Power-Up Buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 55),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Light Charges Button
                          ValueListenableBuilder<bool>(
                            valueListenable: game.isDarknessLevelNotifier,
                            builder: (context, isDark, child) {
                              if (!isDark) return const SizedBox.shrink();
                              return ValueListenableBuilder<int>(
                                valueListenable: game.lightChargesNotifier,
                                builder: (context, charges, child) {
                                  return ValueListenableBuilder<double>(
                                    valueListenable:
                                        game.lightChargeTimerNotifier,
                                    builder: (context, lightTime, child) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: SquarePowerUpButton(
                                          charges: charges,
                                          activeTime: lightTime,
                                          maxTime: 5.0,
                                          onTap: () {
                                            game.useLightCharge();
                                          },
                                          colors: powerUpColors,
                                          isInfinityMode: game.isInfinityMode,
                                          child: const Icon(
                                            Icons.lightbulb,
                                            color: Color(0xFF46356D),
                                            size: 36,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          // Shield Button
                          ValueListenableBuilder<int>(
                            valueListenable: game.remainingShields,
                            builder: (context, shields, child) {
                              return ValueListenableBuilder<double>(
                                valueListenable: game.shieldTimerNotifier,
                                builder: (context, shieldTime, child) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: SquarePowerUpButton(
                                      charges: shields,
                                      activeTime: shieldTime,
                                      maxTime: 5.0,
                                      onTap: () {
                                        final coordinator = coopCoordinator;
                                        if (coordinator != null) {
                                          unawaited(
                                            coordinator.activateSharedShield(),
                                          );
                                        } else {
                                          game.activateShield();
                                        }
                                      },
                                      colors: powerUpColors,
                                      isInfinityMode: game.isInfinityMode,
                                      child: SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: CustomPaint(
                                          painter: ShieldIconPainter(
                                            color:
                                                GameColors.beachMapThemeColor1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setJoystick(double value, {required bool isLeft}) {
    final coordinator = coopCoordinator;
    if (coordinator != null) {
      unawaited(coordinator.setLocalInput(value));
      return;
    }
    if (isLeft) {
      game.leftJoystickValue = value;
    } else {
      game.rightJoystickValue = value;
    }
  }
}

class SquarePowerUpButton extends StatefulWidget {
  final int charges;
  final double activeTime;
  final double maxTime;
  final VoidCallback onTap;
  final List<Color> colors;
  final Widget child;
  final bool isInfinityMode;

  const SquarePowerUpButton({
    super.key,
    required this.charges,
    required this.activeTime,
    required this.maxTime,
    required this.onTap,
    required this.colors,
    required this.child,
    this.isInfinityMode = false,
  });

  @override
  State<SquarePowerUpButton> createState() => _SquarePowerUpButtonState();
}

class _SquarePowerUpButtonState extends State<SquarePowerUpButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.activeTime > 0;
    bool hasCharges = widget.charges > 0;
    bool canClick = hasCharges && !isActive;

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
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
        child: Opacity(
          opacity: canClick || isActive ? 1.0 : 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: widget.isInfinityMode
                  ? ImageFilter.blur(sigmaX: 8, sigmaY: 8)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                width: 64, // Square button
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isInfinityMode
                      ? Border.all(
                          color: GameColors.white.withValues(alpha: 0.5),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: widget.isInfinityMode
                      ? null
                      : [
                          BoxShadow(
                            color: GameColors.black.withValues(alpha: 0.4),
                            blurRadius: 4.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.colors,
                  ),
                ),
                child: Stack(
                  clipBehavior: canClick ? Clip.none : Clip.hardEdge,
                  alignment: Alignment.center,
                  children: [
                    if (!widget.isInfinityMode)
                      // Inner Gloss / Specular Layer
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  GameColors.magnetPainterColor1,
                                  GameColors.whiteTransparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isActive)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CustomPaint(
                            painter: ActiveTimePainter(
                              progress: (widget.activeTime / widget.maxTime)
                                  .clamp(0.0, 1.0),
                            ),
                          ),
                        ),
                      ),
                    // Main Icon
                    Center(child: widget.child),

                    if (canClick)
                      // Charges Badge
                      Positioned(
                        bottom: 17,
                        child: Text(
                          '${widget.charges}',
                          style: GoogleFonts.luckiestGuy(
                            color: GameColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(
                                blurRadius: 6.0,
                                color: GameColors.black,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
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
  final BiomeModel biome;
  final bool isInfinityMode;
  final double? externalValue;

  const VerticalJoystick({
    super.key,
    required this.onChanged,
    required this.isLeft,
    required this.biome,
    this.isInfinityMode = false,
    this.externalValue,
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
      // Multiply the physical finger delta by the sensitivity so the virtual joystick
      // reacts faster (or slower) to touch distance.
      double scaledDelta =
          event.delta.dy * AppSettings.joystickSensitivity.value;
      _dy = (_dy + scaledDelta).clamp(-_maxDrag, _maxDrag);
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
    final baseTop = widget.isInfinityMode
        ? const Color(0xFFFFF8E6)
        : widget.biome.primaryColor;
    final baseMid = widget.isInfinityMode
        ? const Color(0xFFD5C28D)
        : GameColors.blueGray900;
    final knobLight = widget.isInfinityMode
        ? const Color(0xFFFFFBF0)
        : widget.biome.nodeUnlockedColor;
    final knobMid = widget.isInfinityMode
        ? const Color(0xFFEEDCA8)
        : widget.biome.secondaryColor;
    final knobEdge = widget.isInfinityMode
        ? const Color(0xFFC7AE73)
        : widget.biome.primaryColor;
    final shadowColor = widget.isInfinityMode
        ? const Color(0xFF4D3C75)
        : widget.biome.nodeUnlockedBorderColor;
    final trackColors = widget.isInfinityMode
        ? const [Color(0xFF211A32), Color(0xFF665989)]
        : const [GameColors.blackSolid, GameColors.blueGray900];

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
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: widget.isInfinityMode
                    ? ImageFilter.blur(sigmaX: 8, sigmaY: 8)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  width: 60,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: widget.isInfinityMode
                        ? Border.all(
                            color: GameColors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          )
                        : null,
                    gradient: LinearGradient(
                      colors: widget.isInfinityMode
                          ? [
                              GameColors.white.withValues(alpha: 0.3),
                              GameColors.white.withValues(alpha: 0.1),
                            ]
                          : [baseTop, baseMid, baseMid, baseTop],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: widget.isInfinityMode
                        ? null
                        : [
                            BoxShadow(
                              color: GameColors.blackSolid, // 3D thickness
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: GameColors.black38,
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
                        border: widget.isInfinityMode
                            ? Border.all(
                                color: GameColors.white.withValues(alpha: 0.2),
                                width: 1,
                              )
                            : null,
                        gradient: LinearGradient(
                          colors: widget.isInfinityMode
                              ? [
                                  GameColors.white.withValues(alpha: 0.1),
                                  GameColors.white.withValues(alpha: 0.0),
                                ]
                              : trackColors,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: widget.isInfinityMode
                            ? null
                            : const [
                                BoxShadow(
                                  color: GameColors
                                      .black54, // Inner shadow simulation
                                  offset: Offset(0, 2),
                                  blurRadius: 2,
                                ),
                              ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2.5D Glossy Orange Knob
            Align(
              alignment: Alignment(
                0,
                widget.externalValue != null
                    ? widget.externalValue! / _maxDrag
                    : _dy / _maxDrag,
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: widget.isInfinityMode
                      ? ImageFilter.blur(sigmaX: 8, sigmaY: 8)
                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: widget.isInfinityMode
                          ? Border.all(
                              color: GameColors.white.withValues(alpha: 0.6),
                              width: 1.5,
                            )
                          : null,
                      gradient: widget.isInfinityMode
                          ? LinearGradient(
                              colors: [
                                GameColors.white.withValues(alpha: 0.4),
                                GameColors.white.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : RadialGradient(
                              colors: [knobLight, knobMid, knobEdge],
                              center: const Alignment(
                                -0.3,
                                -0.3,
                              ), // Top-left specular highlight
                              radius: 0.8,
                            ),
                      boxShadow: widget.isInfinityMode
                          ? null
                          : [
                              BoxShadow(
                                color: shadowColor,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: GameColors.black45,
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
                              color: GameColors.gameControlsOverlayColor1,
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
                              color: GameColors.gameControlsOverlayColor1,
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
                              color: GameColors
                                  .gameControlsOverlayColor2, // 85% opacity white
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
          ],
        ),
      ),
    );
  }
}

class ActiveTimePainter extends CustomPainter {
  final double progress;

  ActiveTimePainter({required this.progress});

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
      Paint()..color = GameColors.black.withValues(alpha: 0.55),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ActiveTimePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
