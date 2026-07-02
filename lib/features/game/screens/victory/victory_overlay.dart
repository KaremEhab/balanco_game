import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/data/database_helper.dart';

import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/features/game/screens/victory/victory_painters.dart';
import 'package:balanco_game/features/game/components/game_area/star_filled_painter.dart';
import 'package:balanco_game/features/game/components/game_area/empty_card_painter.dart';

class AnimatedLevelCompleteOverlay extends StatefulWidget {
  final BalancoGame game;
  const AnimatedLevelCompleteOverlay({super.key, required this.game});

  @override
  State<AnimatedLevelCompleteOverlay> createState() =>
      _AnimatedLevelCompleteOverlayState();
}

class _AnimatedLevelCompleteOverlayState
    extends State<AnimatedLevelCompleteOverlay>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  late AnimationController _coinsController;
  late Animation<int> _coinsAnimation;

  bool _isVictory = false;
  
  int _earnedStars = 0;
  int _remainingHearts = 0;
  int _targetCoins = 0;

  final List<bool> _showStars = [false, false, false];

  @override
  void initState() {
    super.initState();
    _isVictory = widget.game.currentLevel.value >= 10;
    
    _earnedStars = widget.game.currentPoints.value;
    _remainingHearts = widget.game.currentLives.value;
    _targetCoins = (_earnedStars * 100) + (_remainingHearts * 50);

    _saveProgress();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _coinsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _coinsAnimation = IntTween(begin: 0, end: _targetCoins)
      .animate(CurvedAnimation(parent: _coinsController, curve: Curves.easeOut));

    _startSequence();
  }

  void _startSequence() async {
    // 1. Enter main modal
    _mainController.forward();
    AppSettings.playSound('win.wav', volume: 0.5);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 2. Pop stars sequentially
    for (int i = 0; i < 3; i++) {
      if (i < _earnedStars) {
        setState(() => _showStars[i] = true);
        AppSettings.playSound('star.wav', volume: 0.5);
        await Future.delayed(const Duration(milliseconds: 400));
      } else {
        setState(() => _showStars[i] = true);
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }

    // 3. Roll coins
    _coinsController.forward();
  }

  Future<void> _saveProgress() async {
    try {
      final profile = await DatabaseHelper.instance.getPlayerProfile();
      int currentHighest = profile.highestLevel;
      int nextLevel = widget.game.currentLevel.value + 1;
      
      int newHighest = currentHighest;
      if (nextLevel > currentHighest) {
        newHighest = nextLevel > 10 ? 10 : nextLevel;
      }
      
      // Update highest level and add coins
      await DatabaseHelper.instance.updatePlayerProfile(
        profile.copyWith(
          highestLevel: newHighest,
          coins: profile.coins + _targetCoins,
        )
      );
    } catch (e) {
      debugPrint('Failed to save progress: $e');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _coinsController.dispose();
    super.dispose();
  }

  void _nextLevel() {
    _mainController.reverse().then((_) {
      widget.game.resumeEngine();
      widget.game.advanceToNextLevel();
    });
  }

  void _restartLevel() {
    _mainController.reverse().then((_) {
      widget.game.resumeEngine();
      widget.game.restartLevelAfterWin();
    });
  }

  void _returnToLobby() {
    Navigator.pop(context); // Close GamePlayOverlay
  }

  Widget _buildStar(int index, double size) {
    bool isEarned = index < _earnedStars;
    bool isVisible = _showStars[index];
    
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        child: CustomPaint(
          painter: isEarned ? StarFilledPainter() : CircleCardPainter(),
        ),
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, String label, VoidCallback onTap, Color c1, Color c2) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(
              painter: GamifiedButtonPainter(innerColor1: c1, innerColor2: c2),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 36, shadows: const [
                  Shadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 2)
                ]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.luckiestGuy(
              color: Colors.white,
              fontSize: 16,
              shadows: const [Shadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 2)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(Widget icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF7A0), Color(0xFFFFD13B)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 3), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.luckiestGuy(
              fontSize: 24,
              color: const Color(0xFF9E5C1B),
            ),
          ),
        ],
      ),
    );
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
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Main Card Background
                    SizedBox(
                      width: 320,
                      height: 440,
                      child: CustomPaint(
                        painter: VictoryCardPainter(),
                      ),
                    ),
                    
                    // Top Ribbon
                    Positioned(
                      top: -30,
                      child: SizedBox(
                        width: 380,
                        height: 90,
                        child: CustomPaint(
                          painter: VictoryRibbonPainter(),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                _isVictory ? 'VICTORY' : 'LEVEL CLEARED',
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 42,
                                  color: Colors.white,
                                  shadows: [
                                    const Shadow(color: Color(0xFF1E6310), offset: Offset(0, 4), blurRadius: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Positioned(
                      top: 70,
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Column(
                        children: [
                          // Stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Transform.rotate(
                                angle: -0.2,
                                child: _buildStar(0, 70),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
                                child: _buildStar(1, 90),
                              ),
                              Transform.rotate(
                                angle: 0.2,
                                child: _buildStar(2, 70),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 15),
                          
                          // Divider line
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 40, height: 3, color: const Color(0xFFD68F2C)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'REWARDS',
                                  style: GoogleFonts.luckiestGuy(
                                    fontSize: 20,
                                    color: const Color(0xFFB5701B),
                                  ),
                                ),
                              ),
                              Container(width: 40, height: 3, color: const Color(0xFFD68F2C)),
                            ],
                          ),
                          
                          const SizedBox(height: 15),
                          
                          // Coins Pill
                          AnimatedBuilder(
                            animation: _coinsAnimation,
                            builder: (context, child) {
                              return _buildPill(
                                const Icon(Icons.monetization_on, color: Color(0xFFF9C650), size: 30, shadows: [
                                  Shadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 2)
                                ]),
                                _coinsAnimation.value.toString(),
                              );
                            }
                          ),
                          
                          const Spacer(),
                          
                          // Bottom Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildRoundButton(
                                Icons.refresh, 
                                'RETRY', 
                                _restartLevel,
                                const Color(0xFF5AB6E5), const Color(0xFF2C74A2)
                              ),
                              _buildRoundButton(
                                Icons.list, 
                                'LOBBY', 
                                _returnToLobby,
                                const Color(0xFFF07258), const Color(0xFFA6341D)
                              ),
                              if (!_isVictory)
                                _buildRoundButton(
                                  Icons.play_arrow, 
                                  'NEXT', 
                                  _nextLevel,
                                  const Color(0xFF82D955), const Color(0xFF45941E)
                                ),
                            ],
                          ),
                          const Spacer(),
                        ],
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
