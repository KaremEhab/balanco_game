import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/game_area.dart';

class AnimatedLevelCompleteOverlay extends StatefulWidget {
  final BalancoGame game;
  const AnimatedLevelCompleteOverlay({super.key, required this.game});

  @override
  State<AnimatedLevelCompleteOverlay> createState() =>
      _AnimatedLevelCompleteOverlayState();
}

class _AnimatedLevelCompleteOverlayState
    extends State<AnimatedLevelCompleteOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isVictory = false;

  @override
  void initState() {
    super.initState();
    _isVictory = widget.game.currentLevel.value >= 9;
    _saveProgress();

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

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int currentHighest = prefs.getInt('highestLevel') ?? 1;
      int nextLevel = widget.game.currentLevel.value + 1;
      if (nextLevel > currentHighest) {
        await prefs.setInt('highestLevel', nextLevel > 9 ? 9 : nextLevel);
      }
    } catch (e) {
      debugPrint('Failed to save progress: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextLevel() {
    _controller.reverse().then((_) {
      widget.game.overlays.remove('LevelComplete');
      widget.game.resumeEngine();
      widget.game.retractCurtainAndStartNextLevel();
    });
  }

  void _restartLevel() {
    _controller.reverse().then((_) {
      widget.game.overlays.remove('LevelComplete');
      widget.game.resumeEngine();
      widget.game.retractCurtainAndRestartLevel();
    });
  }

  void _returnToLobby() {
    widget.game.overlays.remove('LevelComplete');
    Navigator.pop(context); // Close GamePlayOverlay
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isVictory ? 'VICTORY!' : 'LEVEL COMPLETE!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Stars Collected:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Icon(
                        index < widget.game.currentPoints.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 36,
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  if (_isVictory)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.home),
                      label: const Text(
                        'Return to Lobby',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _returnToLobby,
                    )
                  else ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'Next Level',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _nextLevel,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'Restart Level',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _restartLevel,
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (!_isVictory)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: isDark ? Colors.white54 : Colors.black54,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      icon: const Icon(Icons.home),
                      label: const Text('Leave to Lobby'),
                      onPressed: _returnToLobby,
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
      widget.game.overlays.remove('GameOver');
      widget.game.restartCurrentLevel();
      widget.game.resumeEngine();
    });
  }

  void _returnToLobby() {
    widget.game.overlays.remove('GameOver');
    Navigator.pop(context); // Close GamePlayOverlay
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: isDark ? Colors.black.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.6),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.2),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'GAME OVER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You lost all your hearts!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'Restart Level',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _restartLevel,
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? Colors.white54 : Colors.black54,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        icon: const Icon(Icons.home),
                        label: const Text('Leave to Lobby'),
                        onPressed: _returnToLobby,
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
