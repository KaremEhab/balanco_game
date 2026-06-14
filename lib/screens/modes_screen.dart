import 'dart:ui';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class ModesScreen extends StatelessWidget {
  const ModesScreen({super.key});

  Widget _buildGlassCard({
    required Widget child,
    required bool isDark,
    bool disabled = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: disabled ? 2 : 10, sigmaY: disabled ? 2 : 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: disabled
                ? (isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02))
                : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: disabled
                  ? (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05))
                  : (isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.1)),
              width: 1.5,
            ),
            boxShadow: [
              if (!disabled)
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Opacity(
            opacity: disabled ? 0.4 : 1.0,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 80.0, bottom: 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'GAME MODES',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.cyanAccent : Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: isDark ? Colors.cyanAccent.withValues(alpha: 0.5) : Colors.blueAccent.withValues(alpha: 0.5),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Active Modes Selector
            ValueListenableBuilder<bool>(
              valueListenable: isMultiplayerNotifier,
              builder: (context, isMultiplayer, _) {
                return _buildGlassCard(
                  isDark: isDark,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isMultiplayerNotifier.value = false;
                                playerRoleNotifier.value = 'BOTH';
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: !isMultiplayer
                                      ? (isDark ? Colors.cyan.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.1))
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: !isMultiplayer
                                        ? (isDark ? Colors.cyanAccent : Colors.blueAccent)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 40,
                                      color: !isMultiplayer
                                          ? (isDark ? Colors.cyanAccent : Colors.blueAccent)
                                          : (isDark ? Colors.white54 : Colors.black54),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'SOLO',
                                      style: TextStyle(
                                        color: !isMultiplayer
                                            ? (isDark ? Colors.white : Colors.black87)
                                            : (isDark ? Colors.white54 : Colors.black54),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                isMultiplayerNotifier.value = true;
                                playerRoleNotifier.value = 'LEFT';
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isMultiplayer
                                      ? (isDark ? Colors.pinkAccent.withValues(alpha: 0.2) : Colors.orangeAccent.withValues(alpha: 0.2))
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isMultiplayer
                                        ? (isDark ? Colors.pinkAccent : Colors.orangeAccent)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 40,
                                      color: isMultiplayer
                                          ? (isDark ? Colors.pinkAccent : Colors.orangeAccent)
                                          : (isDark ? Colors.white54 : Colors.black54),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'CO-OP',
                                      style: TextStyle(
                                        color: isMultiplayer
                                            ? (isDark ? Colors.white : Colors.black87)
                                            : (isDark ? Colors.white54 : Colors.black54),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Role Selection (Animated Size)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: isMultiplayer
                            ? Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'CHOOSE ANCHOR',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ValueListenableBuilder<String>(
                                      valueListenable: playerRoleNotifier,
                                      builder: (context, role, _) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: role == 'LEFT'
                                                      ? (isDark ? Colors.pinkAccent : Colors.orangeAccent)
                                                      : (isDark ? Colors.white12 : Colors.black12),
                                                  foregroundColor: isDark ? Colors.white : Colors.black87,
                                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () => playerRoleNotifier.value = 'LEFT',
                                                child: const Text('LEFT'),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: role == 'RIGHT'
                                                      ? (isDark ? Colors.pinkAccent : Colors.orangeAccent)
                                                      : (isDark ? Colors.white12 : Colors.black12),
                                                  foregroundColor: isDark ? Colors.white : Colors.black87,
                                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                onPressed: () => playerRoleNotifier.value = 'RIGHT',
                                                child: const Text('RIGHT'),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Online Matchmaking (Locked)
            _buildGlassCard(
              isDark: isDark,
              disabled: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.purpleAccent.withValues(alpha: 0.2) : Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.sports_esports, size: 32, color: isDark ? Colors.purpleAccent : Colors.deepPurple),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ONLINE MATCHMAKING',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Unlocks in v2.0 update',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.lock_outline, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Time Trials (Locked)
            _buildGlassCard(
              isDark: isDark,
              disabled: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.greenAccent.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.timer, size: 32, color: isDark ? Colors.greenAccent : Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIME TRIALS',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Beat the clock. Coming soon.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.lock_outline, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
