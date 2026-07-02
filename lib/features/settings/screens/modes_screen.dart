import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';
class ModesScreen extends StatelessWidget {
  const ModesScreen({super.key});

  Widget _buildGlassCard({
    required Widget child,
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
                ? Colors.black.withValues(alpha: 0.02)
                : Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: disabled
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              if (!disabled)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent.withValues(alpha: 0.5),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Active Modes Selector
            BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                final isMultiplayer = state.isMultiplayer;
                final role = state.playerRole;
                return _buildGlassCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.read<AppBloc>().add(const ToggleMultiplayer(false));
                                context.read<AppBloc>().add(const ChangePlayerRole('BOTH'));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: !isMultiplayer
                                      ? Colors.blue.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: !isMultiplayer
                                        ? Colors.blueAccent
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
                                          ? Colors.blueAccent
                                          : Colors.black54,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'SOLO',
                                      style: TextStyle(
                                        color: !isMultiplayer
                                            ? Colors.black87
                                            : Colors.black54,
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
                                context.read<AppBloc>().add(const ToggleMultiplayer(true));
                                context.read<AppBloc>().add(const ChangePlayerRole('LEFT'));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isMultiplayer
                                      ? Colors.orangeAccent.withValues(alpha: 0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isMultiplayer
                                        ? Colors.orangeAccent
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
                                          ? Colors.orangeAccent
                                          : Colors.black54,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'CO-OP',
                                      style: TextStyle(
                                        color: isMultiplayer
                                            ? Colors.black87
                                            : Colors.black54,
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: role == 'LEFT'
                                                  ? Colors.orangeAccent
                                                  : Colors.black12,
                                              foregroundColor: Colors.black87,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () => context.read<AppBloc>().add(const ChangePlayerRole('LEFT')),
                                            child: const Text('LEFT'),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: role == 'RIGHT'
                                                  ? Colors.orangeAccent
                                                  : Colors.black12,
                                              foregroundColor: Colors.black87,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () => context.read<AppBloc>().add(const ChangePlayerRole('RIGHT')),
                                            child: const Text('RIGHT'),
                                          ),
                                        ),
                                      ],
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
              disabled: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sports_esports, size: 32, color: Colors.deepPurple),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ONLINE MATCHMAKING',
                          style: TextStyle(
                            color: Colors.black87,
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
              disabled: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.timer, size: 32, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIME TRIALS',
                          style: TextStyle(
                            color: Colors.black87,
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
