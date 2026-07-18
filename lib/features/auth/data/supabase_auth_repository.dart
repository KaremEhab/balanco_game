import 'dart:convert';

import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:balanco_game/features/auth/domain/auth_repository.dart';
import 'package:balanco_game/features/auth/domain/player_account.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get hasSession => _client.auth.currentSession != null;

  @override
  Stream<PlayerAccount> get authCompletions => _client.auth.onAuthStateChange
      .where((state) => state.event == AuthChangeEvent.signedIn)
      .asyncMap((_) => loadCurrentPlayer())
      .where((player) => player != null)
      .cast<PlayerAccount>();

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required String username,
    required int age,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim().toLowerCase(),
      password: password,
      data: {
        'display_name': displayName.trim(),
        'username': username.trim(),
        'age': age,
      },
    );
    return response.session != null;
  }

  @override
  Future<PlayerAccount> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
    return (await loadCurrentPlayer())!;
  }

  @override
  Future<PlayerAccount?> signInWithSocial(SocialAuthProvider provider) async {
    return switch (provider) {
      SocialAuthProvider.google => _signInWithGoogle(),
      SocialAuthProvider.apple => _signInWithApple(),
    };
  }

  Future<PlayerAccount?> _signInWithGoogle() async {
    final nativeMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    final hasNativeConfiguration =
        SupabaseConfig.googleWebClientId.isNotEmpty &&
        (defaultTargetPlatform != TargetPlatform.iOS ||
            SupabaseConfig.googleIosClientId.isNotEmpty);

    if (!nativeMobile || !hasNativeConfiguration) {
      await _launchOAuth(OAuthProvider.google);
      return null;
    }

    final googleAccount = await GoogleSignIn(
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? SupabaseConfig.googleIosClientId
          : null,
      serverClientId: SupabaseConfig.googleWebClientId,
    ).signIn();
    if (googleAccount == null) {
      throw const AuthException('Google sign-in was cancelled.');
    }

    final googleAuth = await googleAccount.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;
    if (idToken == null || accessToken == null) {
      throw const AuthException(
        'Google did not return the credentials needed to sign in.',
      );
    }

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    return (await loadCurrentPlayer())!;
  }

  Future<PlayerAccount?> _signInWithApple() async {
    final nativeApple =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);
    if (!nativeApple) {
      await _launchOAuth(OAuthProvider.apple);
      return null;
    }

    try {
      final rawNonce = _client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException('Apple did not return an identity token.');
      }

      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      final fullName = [credential.givenName, credential.familyName]
          .whereType<String>()
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .join(' ');
      if (fullName.isNotEmpty) {
        await _client.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': fullName,
              'given_name': credential.givenName,
              'family_name': credential.familyName,
            },
          ),
        );
      }
      return (await loadCurrentPlayer())!;
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const AuthException('Apple sign-in was cancelled.');
      }
      throw AuthException(error.message);
    }
  }

  Future<void> _launchOAuth(OAuthProvider provider) async {
    final launched = await _client.auth.signInWithOAuth(
      provider,
      redirectTo: kIsWeb ? null : SupabaseConfig.authRedirectUrl,
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
    if (!launched) {
      throw const AuthException(
        'Could not open the secure sign-in page. Please try again.',
      );
    }
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _client.auth.resetPasswordForEmail(email.trim().toLowerCase());

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<PlayerAccount?> loadCurrentPlayer() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final response = await _client.rpc('get_my_player_state');
    final state = Map<String, dynamic>.from(response as Map);
    final profile = Map<String, dynamic>.from(state['profile'] as Map);
    final username = profile['username'] as String? ?? '';
    final displayName = profile['display_name'] as String? ?? '';
    final suggestedName = _socialDisplayName(user.userMetadata);
    if ((profile['profile_completed'] as bool? ?? true) == false &&
        (displayName.isEmpty || displayName == username) &&
        suggestedName != null) {
      await _client
          .from('profiles')
          .update({
            'display_name': suggestedName,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', user.id);
      profile['display_name'] = suggestedName;
      state['profile'] = profile;
    }
    return PlayerAccount.fromState(state, email: user.email ?? '');
  }

  String? _socialDisplayName(Map<String, dynamic>? metadata) {
    if (metadata == null) return null;
    for (final key in const ['display_name', 'full_name', 'name']) {
      final value = metadata[key]?.toString().trim() ?? '';
      if (value.length >= 2 && value.length <= 30) return value;
    }
    return null;
  }

  @override
  Future<PlayerAccount> updateProfile({
    required String displayName,
    required String username,
    required int age,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw const AuthException('Authentication required');
    await _client
        .from('profiles')
        .update({
          'display_name': displayName.trim(),
          'username': username.trim(),
          'age': age,
          'profile_completed': true,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', user.id);
    return (await loadCurrentPlayer())!;
  }

  @override
  Future<PlayerAccount> recordGameResult({
    required String attemptId,
    required int levelId,
    required bool won,
    int points = 0,
    int stars = 0,
  }) async {
    final response = await _client.rpc(
      'record_game_result',
      params: {
        'p_client_attempt_id': attemptId,
        'p_level_id': levelId,
        'p_result': won ? 'victory' : 'game_over',
        'p_points': points,
        'p_stars': stars,
      },
    );
    return PlayerAccount.fromState(
      Map<String, dynamic>.from(response as Map),
      email: _client.auth.currentUser?.email ?? '',
    );
  }

  @override
  Future<PlayerAccount> recordInfinityRun({
    required String runId,
    required int score,
    required int coins,
  }) async {
    final response = await _client.rpc(
      'record_infinity_run',
      params: {'p_client_run_id': runId, 'p_score': score, 'p_coins': coins},
    );
    return PlayerAccount.fromState(
      Map<String, dynamic>.from(response as Map),
      email: _client.auth.currentUser?.email ?? '',
    );
  }
}
