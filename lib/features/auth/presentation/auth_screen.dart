import 'dart:ui';

import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/auth/domain/auth_repository.dart';
import 'package:balanco_game/features/home/screens/main_screen.dart';
import 'package:balanco_game/features/home/screens/splash/components/splash_beach_background.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum _AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _displayName = TextEditingController();
  final _username = TextEditingController();
  final _age = TextEditingController();
  late final AnimationController _backgroundController;

  _AuthMode _mode = _AuthMode.login;
  bool _submitting = false;
  bool _obscurePassword = true;
  String? _message;
  bool _messageIsError = false;

  AuthRepository? get _repository => PlayerSession.instance.repository;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _displayName.dispose();
    _username.dispose();
    _age.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _validateEmail(String? value) {
    final required = _required(value, 'Email');
    if (required != null) return required;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final required = _required(value, 'Password');
    if (required != null) return required;
    if (value!.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include both a letter and a number';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final repository = _repository;
    if (repository == null) {
      setState(() {
        _message = 'Supabase is not configured for this build yet.';
        _messageIsError = true;
      });
      return;
    }

    setState(() {
      _submitting = true;
      _message = null;
    });
    try {
      if (_mode == _AuthMode.login) {
        final player = await repository.signIn(
          email: _email.text,
          password: _password.text,
        );
        await PlayerSession.instance.use(player);
        _openGame();
      } else {
        final hasSession = await repository.signUp(
          email: _email.text,
          password: _password.text,
          displayName: _displayName.text,
          username: _username.text,
          age: int.parse(_age.text),
        );
        if (hasSession) {
          final player = await repository.loadCurrentPlayer();
          if (player != null) await PlayerSession.instance.use(player);
          _openGame();
        } else if (mounted) {
          setState(() {
            _mode = _AuthMode.login;
            _message = 'Check your email to confirm your account, then log in.';
            _messageIsError = false;
          });
        }
      }
    } on AuthException catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Something went wrong. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _message = message;
      _messageIsError = true;
    });
  }

  void _openGame() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }

  Future<void> _forgotPassword() async {
    final controller = TextEditingController(text: _email.text);
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GameColors.sandLightUi,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: GameColors.brownDarkUi, width: 3),
        ),
        title: Text('RESET PASSWORD', style: GoogleFonts.luckiestGuy()),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email address'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('SEND LINK'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (email == null || email.isEmpty) return;
    try {
      await _repository?.sendPasswordReset(email);
      if (mounted) {
        setState(() {
          _message = 'Password reset link sent. Check your email.';
          _messageIsError = false;
        });
      }
    } on AuthException catch (error) {
      _showError(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (_, _) => SplashBeachBackground(
              animationValue: _backgroundController.value,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: GameColors.sandLightUi.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: GameColors.brownDarkUi,
                            width: 3.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: GameColors.brownDarkUi,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(
                                Icons.sports_esports_rounded,
                                size: 54,
                                color: GameColors.orangeTextUi,
                              ),
                              Text(
                                _mode == _AuthMode.login
                                    ? 'WELCOME BACK!'
                                    : 'CREATE YOUR HERO',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 28,
                                  color: GameColors.orangeTextUi,
                                  shadows: const [
                                    Shadow(
                                      color: GameColors.brownDarkUi,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _mode == _AuthMode.login
                                    ? 'Continue your Balanco adventure'
                                    : 'Start with 5,000 coins, \$5.00 and 5 daily sparks',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: GameColors.black87,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _ModeTabs(
                                mode: _mode,
                                onChanged: (mode) => setState(() {
                                  _mode = mode;
                                  _message = null;
                                }),
                              ),
                              const SizedBox(height: 18),
                              if (_mode == _AuthMode.signup) ...[
                                _CartoonField(
                                  controller: _displayName,
                                  label: 'DISPLAY NAME',
                                  icon: Icons.badge_rounded,
                                  textCapitalization: TextCapitalization.words,
                                  validator: (value) {
                                    final required = _required(
                                      value,
                                      'Display name',
                                    );
                                    if (required != null) return required;
                                    return value!.trim().length > 30
                                        ? 'Maximum 30 characters'
                                        : null;
                                  },
                                ),
                                const SizedBox(height: 13),
                                _CartoonField(
                                  controller: _username,
                                  label: 'USERNAME',
                                  icon: Icons.alternate_email_rounded,
                                  validator: (value) {
                                    final required = _required(
                                      value,
                                      'Username',
                                    );
                                    if (required != null) return required;
                                    return RegExp(
                                          r'^[A-Za-z0-9_]{3,20}$',
                                        ).hasMatch(value!.trim())
                                        ? null
                                        : '3–20 letters, numbers or underscores';
                                  },
                                ),
                                const SizedBox(height: 13),
                                _CartoonField(
                                  controller: _age,
                                  label: 'AGE',
                                  icon: Icons.cake_rounded,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    final age = int.tryParse(value ?? '');
                                    return age != null && age >= 6 && age <= 120
                                        ? null
                                        : 'Choose an age from 6 to 120';
                                  },
                                ),
                                const SizedBox(height: 13),
                              ],
                              _CartoonField(
                                controller: _email,
                                label: 'EMAIL',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 13),
                              _CartoonField(
                                controller: _password,
                                label: 'PASSWORD',
                                icon: Icons.lock_rounded,
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                                suffix: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                  ),
                                ),
                              ),
                              if (_mode == _AuthMode.signup) ...[
                                const SizedBox(height: 13),
                                _CartoonField(
                                  controller: _confirmPassword,
                                  label: 'CONFIRM PASSWORD',
                                  icon: Icons.verified_user_rounded,
                                  obscureText: true,
                                  validator: (value) => value == _password.text
                                      ? null
                                      : 'Passwords do not match',
                                ),
                              ],
                              if (_mode == _AuthMode.login)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _forgotPassword,
                                    child: const Text('Forgot password?'),
                                  ),
                                )
                              else
                                const SizedBox(height: 18),
                              if (!SupabaseConfig.isConfigured)
                                const _StatusMessage(
                                  message:
                                      'Backend keys are not configured in this build.',
                                  isError: true,
                                ),
                              if (_message != null)
                                _StatusMessage(
                                  message: _message!,
                                  isError: _messageIsError,
                                ),
                              const SizedBox(height: 8),
                              _CartoonSubmitButton(
                                busy: _submitting,
                                label: _mode == _AuthMode.login
                                    ? 'LOG IN'
                                    : 'CREATE ACCOUNT',
                                onTap: _submit,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _mode == _AuthMode.login
                                    ? 'Your progress is securely synced to your account.'
                                    : 'By creating an account, you agree to play fair and keep Balanco fun.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: GameColors.brownDarkUi.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.mode, required this.onChanged});
  final _AuthMode mode;
  final ValueChanged<_AuthMode> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: _AuthMode.values.map((item) {
      final selected = item == mode;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: selected ? GameColors.orangeTextUi : Colors.white54,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GameColors.brownDarkUi, width: 2),
              boxShadow: selected
                  ? const [
                      BoxShadow(
                        color: GameColors.brownDarkUi,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              item == _AuthMode.login ? 'LOG IN' : 'SIGN UP',
              textAlign: TextAlign.center,
              style: GoogleFonts.luckiestGuy(
                color: selected ? Colors.white : GameColors.brownDarkUi,
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}

class _CartoonField extends StatelessWidget {
  const _CartoonField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    obscureText: obscureText,
    autocorrect: false,
    enableSuggestions: !obscureText,
    style: const TextStyle(fontWeight: FontWeight.w700),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: GameColors.orangeTextUi),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GameColors.brownDarkUi, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: GameColors.orangeTextUi, width: 3),
      ),
    ),
  );
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.message, required this.isError});
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: (isError ? Colors.red : Colors.green).withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isError ? Colors.red.shade700 : Colors.green.shade700,
        width: 2,
      ),
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

class _CartoonSubmitButton extends StatelessWidget {
  const _CartoonSubmitButton({
    required this.busy,
    required this.label,
    required this.onTap,
  });
  final bool busy;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: busy ? null : onTap,
    child: Container(
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42D97A), Color(0xFF189B55)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GameColors.brownDarkUi, width: 3),
        boxShadow: const [
          BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 5)),
        ],
      ),
      alignment: Alignment.center,
      child: busy
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              label,
              style: GoogleFonts.luckiestGuy(
                color: Colors.white,
                fontSize: 21,
                letterSpacing: 1.5,
              ),
            ),
    ),
  );
}
