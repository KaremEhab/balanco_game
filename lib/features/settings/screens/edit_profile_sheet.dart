import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/core/data/app_settings.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showEditProfileSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const EditProfileSheet(),
  );
}

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _ageController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final player = PlayerSession.instance.player.value;
    _nameController = TextEditingController(
      text: player?.displayName ?? AppSettings.playerName.value,
    );
    _emailController = TextEditingController(
      text: player?.email ?? 'Offline player',
    );
    _usernameController = TextEditingController(text: player?.username ?? '');
    _ageController = TextEditingController(text: player?.age.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.luckiestGuy(
            color: GameColors.brownDarkUi,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: GameColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GameColors.brownDarkUi, width: 2),
            boxShadow: const [
              BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 3)),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            readOnly: readOnly,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GameColors.black87,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add 15px margin to all sides
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        left: 15,
        right: 15,
        top: 15,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: GameColors.sandLightUi,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: GameColors.brownDarkUi, width: 3.5),
          boxShadow: const [
            BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 6)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EDIT PROFILE',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 24,
                      color: GameColors.orangeTextUi,
                      shadows: [
                        const Shadow(
                          color: GameColors.brownDarkUi,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            GameColors.profileDialogColor1, // Red close button
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: GameColors.brownDarkUi,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Avatar editing placeholder (tap to change avatar)
              Center(
                child: ValueListenableBuilder<AvatarShape>(
                  valueListenable: currentAvatarShapeNotifier,
                  builder: (context, shape, _) {
                    return ValueListenableBuilder<String>(
                      valueListenable: currentAvatarUrlNotifier,
                      builder: (context, url, _) {
                        return ProfileAvatarWidget(
                          shape: shape,
                          size: 80,
                          imageUrl: url,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Tap avatar to change',
                  style: GoogleFonts.luckiestGuy(
                    color: GameColors.brownDarkUi.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Profile Info
              _buildTextField('NICKNAME', _nameController),
              const SizedBox(height: 16),
              _buildTextField('USERNAME', _usernameController),
              const SizedBox(height: 16),
              _buildTextField(
                'AGE',
                _ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Account Settings
              _buildTextField(
                'EMAIL ADDRESS',
                _emailController,
                readOnly: true,
              ),
              const SizedBox(height: 32),

              // Save Button
              GestureDetector(
                onTap: _saving
                    ? null
                    : () async {
                        final name = _nameController.text.trim();
                        final username = _usernameController.text.trim();
                        final age = int.tryParse(_ageController.text.trim());
                        if (name.length < 2 ||
                            !RegExp(
                              r'^[A-Za-z0-9_]{3,20}$',
                            ).hasMatch(username) ||
                            age == null ||
                            age < 6 ||
                            age > 120) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Check your name, username and age.',
                              ),
                            ),
                          );
                          return;
                        }
                        setState(() => _saving = true);
                        try {
                          final repository = PlayerSession.instance.repository;
                          if (repository != null && repository.hasSession) {
                            await PlayerSession.instance.use(
                              await repository.updateProfile(
                                displayName: name,
                                username: username,
                                age: age,
                              ),
                            );
                          } else {
                            AppSettings.setPlayerName(name);
                          }
                          if (context.mounted) Navigator.of(context).pop();
                        } on PostgrestException catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.message)),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: GameColors.green700,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GameColors.brownDarkUi, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: GameColors.brownDarkUi,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            'SAVE CHANGES',
                            style: GoogleFonts.luckiestGuy(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 2,
                              shadows: [
                                const Shadow(
                                  color: GameColors.brownDarkUi,
                                  offset: Offset(0, 2),
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
      ),
    );
  }
}
