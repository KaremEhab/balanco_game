import 'package:balanco_game/features/game/components/game_background/bg_config_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/core/theme/game_colors.dart';

import 'package:balanco_game/features/game/screens/gameplay.dart';
import 'package:balanco_game/features/game/game_area.dart';

class SettingsScreen extends StatelessWidget {
  final ScrollController scrollController;

  const SettingsScreen({super.key, required this.scrollController});

  Widget _buildCartoonCard({required Widget child, bool disabled = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: disabled
            ? GameColors.modesScreenColor3
            : GameColors.sandLightUi, // Light sand color
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: GameColors.brownDarkUi, // Dark brown outline
          width: 3.5,
        ),
        boxShadow: [
          if (!disabled)
            const BoxShadow(
              color: GameColors.brownDarkUi,
              offset: Offset(0, 6),
            ),
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
              fontSize: 22,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = GameColors.brownDarkUi,
              letterSpacing: 2,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.luckiestGuy(
              color: GameColors.orangeTextUi, // Vibrant orange/sand
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
                border: Border.all(color: GameColors.brownDarkUi, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: GameColors.brownDarkUi,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: GameColors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.luckiestGuy(
                      color: GameColors.brownDarkUi,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: GameColors.black87,
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
                activeThumbColor: GameColors.white,
                activeTrackColor: GameColors.settingsScreenColor1,
                inactiveThumbColor: GameColors.white,
                inactiveTrackColor: GameColors.gray300,
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                  Set<WidgetState> states,
                ) {
                  return GameColors.brownDarkUi;
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
                color: GameColors.gray300,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GameColors.brownDarkUi, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: GameColors.brownDarkUi,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: GameColors.brownDarkUi),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.luckiestGuy(
                  color: GameColors.brownDarkUi,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: GameColors.brownDarkUi,
            ),
          ],
        ),
      ),
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
        top: MediaQuery.of(context).padding.top + 280.0,
        bottom: 120.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader('AUDIO & FEEDBACK'),
          _buildCartoonCard(
            child: Column(
              children: [
                _buildToggleRow(
                  icon: Icons.volume_up_rounded,
                  iconColor: GameColors.blueAccent,
                  title: 'Sound Effects',
                  subtitle: 'Game sounds & menu clicks',
                  notifier: AppSettings.soundEnabled,
                  onChanged: AppSettings.setSoundEnabled,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    height: 2,
                    color: GameColors.brownDarkUi,
                    thickness: 2,
                  ),
                ),
                _buildToggleRow(
                  icon: Icons.vibration,
                  iconColor: GameColors.orangeAccent,
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
                        color: GameColors.settingsScreenColor1,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: GameColors.brownDarkUi,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: GameColors.brownDarkUi,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.gamepad,
                        size: 28,
                        color: GameColors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Joystick Sensitivity',
                            style: GoogleFonts.luckiestGuy(
                              color: GameColors.brownDarkUi,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Adjust balance responsiveness',
                            style: TextStyle(
                              color: GameColors.black87,
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
                        activeTrackColor: GameColors.settingsScreenColor1,
                        inactiveTrackColor: GameColors.settingsScreenColor2,
                        thumbColor: GameColors.sandLightUi,
                        overlayColor: const Color(
                          0xFF4CAF50,
                        ).withValues(alpha: 0.2),
                        valueIndicatorColor: GameColors.settingsScreenColor1,
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
              iconColor: GameColors.purpleAccent,
              title: 'Parallax Effect',
              subtitle: 'Smooth background animations',
              notifier: AppSettings.parallaxEnabled,
              onChanged: AppSettings.setParallaxEnabled,
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
                  child: Divider(
                    height: 2,
                    color: GameColors.brownDarkUi,
                    thickness: 2,
                  ),
                ),
                _buildLinkRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(
                    height: 2,
                    color: GameColors.brownDarkUi,
                    thickness: 2,
                  ),
                ),
                _buildLinkRow(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader('DEVELOPER TOOLS'),
          _buildCartoonCard(
            child: Column(
              children: [
                _buildLinkRow(
                  icon: Icons.code,
                  title: 'Level Editor',
                  onTap: () {
                    AppSettings.stopBgm();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          final game = BalancoGame(
                            isMultiplayer: false,
                            playerRole: 'host',
                            isEditMode: true,
                          );
                          game.currentLevel.value =
                              AppSettings.lastEditedLevel.value;
                          return GamePlayOverlay(game: game);
                        },
                      ),
                    ).then((_) {
                      AppSettings.playMenuBgm();
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(
                    height: 2,
                    color: GameColors.brownDarkUi,
                    thickness: 2,
                  ),
                ),
                _buildLinkRow(
                  icon: Icons.code,
                  title: 'Background Editor',
                  onTap: () {
                    AppSettings.stopBgm();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BgConfigScreen()),
                    ).then((_) {
                      AppSettings.playMenuBgm();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              'v1.0.0 (Build 1)',
              style: GoogleFonts.luckiestGuy(
                color: GameColors.brownDarkUi.withValues(alpha: 0.5),
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
