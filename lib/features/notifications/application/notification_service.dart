import 'package:balanco_game/core/config/notification_config.dart';
import 'package:balanco_game/core/navigation/global_navigator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final ValueNotifier<String?> requestedRoute = ValueNotifier(null);
  final Map<String, DateTime> _recentlyPresented = {};
  bool _initialized = false;

  static const _presentationDeduplicationWindow = Duration(seconds: 30);

  bool get supportsNativePush =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get isConfigured =>
      supportsNativePush && NotificationConfig.hasOneSignalApp;

  bool get hasPermission =>
      isConfigured && OneSignal.Notifications.permission;

  Future<void> initialize() async {
    if (_initialized || !isConfigured) return;
    OneSignal.initialize(NotificationConfig.oneSignalAppId);
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      requestedRoute.value = data?['route'] as String? ?? 'notifications';
    });
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // A foreground push is rendered inside the game instead of creating a
      // second native banner. The matching Supabase Realtime row can arrive at
      // nearly the same time, so presentInAppNotification deduplicates both.
      event.preventDefault();
      final notification = event.notification;
      final data = notification.additionalData;
      presentInAppNotification(
        id: data?['notification_id'] as String? ?? notification.notificationId,
        title: notification.title ?? 'Balanco',
        body: notification.body ?? 'You have a new notification.',
        route: data?['route'] as String? ?? 'notifications',
      );
    });
    _initialized = true;
  }

  Future<void> identify({
    required String userId,
    required int level,
    required String playerCode,
  }) async {
    if (!isConfigured) return;
    await initialize();
    OneSignal.login(userId);
    OneSignal.User.addTags({
      'player_code': playerCode,
      'highest_level': level.toString(),
      'game': 'balanco',
    });

    // Ask once when the operating system can still display its native prompt.
    // A denied user can retry later from Balanco's Notifications screen.
    if (!OneSignal.Notifications.permission &&
        await OneSignal.Notifications.canRequest()) {
      await OneSignal.Notifications.requestPermission(false);
    }
    if (OneSignal.Notifications.permission) {
      await OneSignal.User.pushSubscription.optIn();
    }
  }

  Future<bool> requestPermission() async {
    if (!isConfigured) return false;
    await initialize();
    final granted = await OneSignal.Notifications.requestPermission(true);
    if (granted) await OneSignal.User.pushSubscription.optIn();
    return granted;
  }

  void presentInAppNotification({
    required String id,
    required String title,
    required String body,
    String route = 'notifications',
  }) {
    final now = DateTime.now();
    _recentlyPresented.removeWhere(
      (_, presentedAt) =>
          now.difference(presentedAt) > _presentationDeduplicationWindow,
    );
    if (_recentlyPresented.containsKey(id)) return;
    _recentlyPresented[id] = now;

    void display() {
      final messenger = GlobalNavigator.scaffoldMessengerKey.currentState;
      if (messenger == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => display());
        return;
      }

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            elevation: 12,
            backgroundColor: const Color(0xFF142B66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF35C8FF), width: 1.5),
            ),
            content: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF35C8FF),
                  foregroundColor: Color(0xFF071A46),
                  child: Icon(Icons.notifications_active_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFDDEBFF),
                          fontSize: 12,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: 'VIEW',
              textColor: const Color(0xFF72E3FF),
              onPressed: () => requestedRoute.value = route,
            ),
          ),
        );
    }

    display();
  }

  void consumeRoute() => requestedRoute.value = null;

  void clearIdentity() {
    if (!_initialized) return;
    OneSignal.logout();
  }
}
