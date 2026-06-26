import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/game_area.dart';



class AnimatedGameOverOverlay extends StatefulWidget {
  final BalancoGame game;
  const AnimatedGameOverOverlay({super.key, required this.game});

  @override
  State<AnimatedGameOverOverlay> createState() =>
      _AnimatedGameOverOverlayState();
}

class _AnimatedGameOverOverlayState extends State<AnimatedGameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _restartLevel() {
    _controller.reverse().then((_) {
      widget.game.showGameOverOverlay.value = false;
      widget.game.restartCurrentLevel();
    });
  }

  void _returnToLobby() {
    widget.game.showGameOverOverlay.value = false;
    Navigator.pop(context); // Close GamePlayOverlay
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 340,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE082),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF5D4037),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'GAME OVER!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.luckiestGuy(
                          color: Colors.white,
                          fontSize: 38,
                          letterSpacing: 2,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 4),
                              color: Color(0xFF5D4037),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You lost all your lives\nor time ran out!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.baloo2(
                          color: const Color(0xFF5D4037),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: _returnToLobby,
                            child: Text(
                              'LEAVE',
                              style: GoogleFonts.luckiestGuy(
                                color: const Color(0xFFF44336),
                                fontSize: 24,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    color: Color(0x66000000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _restartLevel,
                            child: Text(
                              'RESTART',
                              style: GoogleFonts.luckiestGuy(
                                color: const Color(0xFF4CAF50),
                                fontSize: 24,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    color: Color(0x66000000),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
