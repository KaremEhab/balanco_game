import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/data/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildCartoonCard({
    required Widget child,
    bool disabled = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFD6D6D6) : const Color(0xFFFFF8E7), // Light sand color
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3E2723), // Dark brown outline
          width: 3.5,
        ),
        boxShadow: [
          if (!disabled)
            const BoxShadow(
              color: Color(0xFF3E2723),
              offset: Offset(0, 6),
            ),
        ],
      ),
      child: Opacity(
        opacity: disabled ? 0.6 : 1.0,
        child: child,
      ),
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
              fontSize: 22,
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
              fontSize: 22,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required ValueNotifier<bool> notifier,
    required Function(bool) onChanged,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3E2723), width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 3)),
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.white),
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
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.1,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF4CAF50),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFE0E0E0),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return const Color(0xFF3E2723);
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLinkRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3E2723), width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 2)),
                ],
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF3E2723)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.luckiestGuy(
                  color: const Color(0xFF3E2723),
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Color(0xFF3E2723)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          left: 24.0, right: 24.0, top: MediaQuery.of(context).padding.top + 80.0, bottom: 120.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader('AUDIO & FEEDBACK'),
          _buildCartoonCard(
            child: Column(
              children: [
                _buildToggleRow(
                  icon: Icons.volume_up_rounded,
                  iconColor: Colors.blueAccent,
                  title: 'Sound Effects',
                  subtitle: 'Game sounds & menu clicks',
                  notifier: AppSettings.soundEnabled,
                  onChanged: AppSettings.setSoundEnabled,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(height: 2, color: Color(0xFF3E2723), thickness: 2),
                ),
                _buildToggleRow(
                  icon: Icons.vibration,
                  iconColor: Colors.orangeAccent,
                  title: 'Haptics',
                  subtitle: 'Vibrations for impacts',
                  notifier: AppSettings.hapticsEnabled,
                  onChanged: AppSettings.setHapticsEnabled,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader('CONTROLS'),
          _buildCartoonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF3E2723), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF3E2723), offset: Offset(0, 3)),
                        ],
                      ),
                      child: const Icon(Icons.gamepad,
                          size: 28, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Joystick Sensitivity',
                            style: GoogleFonts.luckiestGuy(
                              color: const Color(0xFF3E2723),
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Adjust balance responsiveness',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<double>(
                  valueListenable: AppSettings.joystickSensitivity,
                  builder: (context, value, child) {
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 12,
                        activeTrackColor: const Color(0xFF4CAF50),
                        inactiveTrackColor: const Color(0xFFA5D6A7),
                        thumbColor: const Color(0xFFFFF8E7),
                        overlayColor: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                        valueIndicatorColor: const Color(0xFF4CAF50),
                      ),
                      child: Slider(
                        value: value,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        onChanged: AppSettings.setJoystickSensitivity,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader('DISPLAY'),
          _buildCartoonCard(
            child: _buildToggleRow(
              icon: Icons.layers,
              iconColor: Colors.purpleAccent,
              title: 'High Graphics',
              subtitle: 'Full parallax background layers',
              notifier: AppSettings.highGraphicsEnabled,
              onChanged: AppSettings.setHighGraphicsEnabled,
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader('GENERAL'),
          _buildCartoonCard(
            child: Column(
              children: [
                _buildLinkRow(
                  icon: Icons.language,
                  title: 'Language (English)',
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 2, color: Color(0xFF3E2723), thickness: 2),
                ),
                _buildLinkRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 2, color: Color(0xFF3E2723), thickness: 2),
                ),
                _buildLinkRow(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              'v1.0.0 (Build 1)',
              style: GoogleFonts.luckiestGuy(
                color: const Color(0xFF3E2723).withValues(alpha: 0.5),
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
