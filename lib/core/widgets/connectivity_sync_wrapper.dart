import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:balanco_game/core/config/supabase_config.dart';
import 'package:balanco_game/core/data/database_helper.dart';
import 'package:balanco_game/features/player/application/player_session.dart';
import 'package:balanco_game/core/navigation/global_navigator.dart';

class ConnectivitySyncWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivitySyncWrapper({super.key, required this.child});

  @override
  State<ConnectivitySyncWrapper> createState() =>
      _ConnectivitySyncWrapperState();
}

class _ConnectivitySyncWrapperState extends State<ConnectivitySyncWrapper> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    // connectivity_plus has a known bug on some Windows builds where it throws an unhandled
    // PlatformException when activating the network manager stream.
    if (!kIsWeb && Platform.isWindows) {
      debugPrint(
        'Skipping onConnectivityChanged listener on Windows to prevent crashes.',
      );
      return;
    }

    try {
      _subscription = Connectivity().onConnectivityChanged.listen(
        _handleConnectivityChange,
        onError: (e) {
          debugPrint('Connectivity stream error: $e');
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint('Failed to start connectivity listener: $e');
    }
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _wasOffline = _isOffline(result);
  }

  bool _isOffline(List<ConnectivityResult> results) {
    // If the list is empty or only contains 'none', it's offline.
    return results.isEmpty ||
        (results.length == 1 && results.first == ConnectivityResult.none);
  }

  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> results,
  ) async {
    final isCurrentlyOffline = _isOffline(results);

    if (_wasOffline && !isCurrentlyOffline) {
      // Transitioned from offline to online
      await _checkAndPromptSync();
    }

    _wasOffline = isCurrentlyOffline;
  }

  Future<void> _checkAndPromptSync() async {
    if (!SupabaseConfig.isConfigured) return;

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null || session.isExpired) return;

    final userId = session.user.id;
    final pendingGames = await DatabaseHelper.instance.getPendingGameResults(
      userId,
    );
    final pendingRuns = await DatabaseHelper.instance.getPendingInfinityRuns(
      userId,
    );

    if (pendingGames.isNotEmpty || pendingRuns.isNotEmpty) {
      final context = GlobalNavigator.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        _showSyncDialog(context);
      }
    }
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Back Online!'),
          content: const Text(
            'You are connected to the internet again. Do you want to sync your offline progress to the cloud?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Not Now'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _performSync();
              },
              child: const Text('Sync'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performSync() async {
    try {
      await PlayerSession.instance.refresh();
      _showSnackbar('Offline progress synced successfully!');
    } catch (e) {
      _showSnackbar('Failed to sync progress: $e');
    }
  }

  void _showSnackbar(String message) {
    final messenger = GlobalNavigator.scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
