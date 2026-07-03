import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balanco_game/core/bloc/app_bloc.dart';

class ModesScreen extends StatelessWidget {
  final ScrollController scrollController;

  const ModesScreen({super.key, required this.scrollController});

  Widget _buildCartoonCard({required Widget child, bool disabled = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: disabled
            ? const Color(0xFFD6D6D6)
            : const Color(0xFFFFF8E7), // Light sand color
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3E2723), // Dark brown outline
          width: 3.5,
        ),
        boxShadow: [
          if (!disabled)
            const BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 6)),
        ],
      ),
      child: Opacity(opacity: disabled ? 0.6 : 1.0, child: child),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
      child: Stack(
        children: [
          Text(
            title,
            style: GoogleFonts.luckiestGuy(
              fontSize: 24,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = const Color(0xFF3E2723),
              letterSpacing: 2,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.luckiestGuy(
              color: const Color(0xFFFFB74D), // Vibrant orange/sand
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3E2723), width: 3.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3E2723),
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? Colors.white : const Color(0xFF3E2723),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.luckiestGuy(
                  color: isSelected ? Colors.white : const Color(0xFF3E2723),
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnchorButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFB74D)
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3E2723), width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3E2723),
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.luckiestGuy(
                color: isSelected ? Colors.white : const Color(0xFF3E2723),
                fontSize: 18,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedModeRow({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3E2723), width: 2.5),
            boxShadow: const [
              BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 3)),
            ],
          ),
          child: Icon(icon, size: 32, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.luckiestGuy(
                  color: const Color(0xFF3E2723),
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.lock, size: 32, color: Color(0xFF3E2723)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: MediaQuery.of(context).padding.top + 170.0,
        bottom: 120.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              final isMultiplayer = state.isMultiplayer;
              final role = state.playerRole;
              return _buildCartoonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _buildModeButton(
                          label: 'SOLO',
                          icon: Icons.person,
                          isSelected: !isMultiplayer,
                          activeColor: const Color(0xFF29B6F6), // Light Blue
                          onTap: () {
                            context.read<AppBloc>().add(
                              const ToggleMultiplayer(false),
                            );
                            context.read<AppBloc>().add(
                              const ChangePlayerRole('BOTH'),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        _buildModeButton(
                          label: 'CO-OP',
                          icon: Icons.people,
                          isSelected: isMultiplayer,
                          activeColor: const Color(0xFF66BB6A), // Green
                          onTap: () {
                            context.read<AppBloc>().add(
                              const ToggleMultiplayer(true),
                            );
                            context.read<AppBloc>().add(
                              const ChangePlayerRole('LEFT'),
                            );
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHOOSE ANCHOR:',
                                    style: GoogleFonts.luckiestGuy(
                                      color: const Color(0xFF3E2723),
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildAnchorButton(
                                        label: 'LEFT',
                                        isSelected: role == 'LEFT',
                                        onTap: () =>
                                            context.read<AppBloc>().add(
                                              const ChangePlayerRole('LEFT'),
                                            ),
                                      ),
                                      const SizedBox(width: 16),
                                      _buildAnchorButton(
                                        label: 'RIGHT',
                                        isSelected: role == 'RIGHT',
                                        onTap: () =>
                                            context.read<AppBloc>().add(
                                              const ChangePlayerRole('RIGHT'),
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

          _buildSectionHeader('UPCOMING MODES'),

          _buildCartoonCard(
            disabled: true,
            child: _buildLockedModeRow(
              icon: Icons.sports_esports,
              iconBgColor: Colors.deepPurple,
              title: 'ONLINE MATCH',
              subtitle: 'Unlocks in v2.0 update',
            ),
          ),

          const SizedBox(height: 16),

          _buildCartoonCard(
            disabled: true,
            child: _buildLockedModeRow(
              icon: Icons.timer,
              iconBgColor: Colors.redAccent,
              title: 'TIME TRIALS',
              subtitle: 'Beat the clock. Coming soon.',
            ),
          ),
        ],
      ),
    );
  }
}
