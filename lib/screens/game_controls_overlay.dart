import 'dart:ui';
import 'package:flutter/material.dart';
import '../game/game_area.dart';
import '../game/components/joystick_painter.dart';

class GameControlsOverlay extends StatelessWidget {
  final BalancoGame game;

  const GameControlsOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 100,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Left Joystick
          if (game.playerRole == 'BOTH' || game.playerRole == 'LEFT')
            Positioned(
              left: 0,
              bottom: 0,
              child: VerticalJoystick(
                isLeft: true,
                onChanged: (val) => game.leftJoystickValue = val,
              ),
            ),

          // Right Joystick
          if (game.playerRole == 'BOTH' || game.playerRole == 'RIGHT')
            Positioned(
              right: 0,
              bottom: 0,
              child: VerticalJoystick(
                isLeft: false,
                onChanged: (val) => game.rightJoystickValue = val,
              ),
            ),
        ],
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
  final double _maxDrag = 60.0;

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
      onVerticalDragStart:
          (_) {}, // Do nothing on initial tap to prevent jumping
      onVerticalDragUpdate: (details) =>
          _updatePositionFromDelta(details.delta.dy),
      onVerticalDragEnd: (_) => _resetPosition(),
      onVerticalDragCancel: () => _resetPosition(),
      child: Container(
        width: 100,
        height: 160,
        color: Colors.transparent, // Touch target
        child: Center(
          child: CustomPaint(
            size: const Size(100, 160),
            painter: JoystickPainter(dy: _dy, isLeft: widget.isLeft),
          ),
        ),
      ),
    );
  }
}
