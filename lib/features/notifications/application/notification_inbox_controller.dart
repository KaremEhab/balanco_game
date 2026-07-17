import 'dart:async';

import 'package:balanco_game/features/notifications/application/notification_service.dart';
import 'package:balanco_game/features/notifications/domain/game_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationInboxController extends ChangeNotifier {
  NotificationInboxController(this._client)
    : _userId = _client.auth.currentUser?.id;

  final SupabaseClient _client;
  final String? _userId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  Set<String> _knownIds = const {};
  bool _receivedInitialSnapshot = false;

  List<GameNotification> notifications = const [];
  bool loading = true;
  String? error;

  bool get signedIn => _userId != null;
  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  Future<void> start() async {
    if (_userId == null) {
      loading = false;
      notifyListeners();
      return;
    }

    await _subscription?.cancel();
    loading = true;
    error = null;
    notifyListeners();

    _subscription = _client
        .from('player_notifications')
        .stream(primaryKey: const ['id'])
        .eq('recipient_id', _userId)
        .order('created_at', ascending: false)
        .limit(100)
        .listen(_applyRows, onError: _handleStreamError);
  }

  void _applyRows(List<Map<String, dynamic>> rows) {
    final updated = rows.map(GameNotification.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final newUnread = _receivedInitialSnapshot
        ? updated
              .where(
                (notification) =>
                    !notification.isRead &&
                    !_knownIds.contains(notification.id),
              )
              .toList()
        : const <GameNotification>[];

    notifications = updated;
    _knownIds = updated.map((notification) => notification.id).toSet();
    _receivedInitialSnapshot = true;
    loading = false;
    error = null;
    notifyListeners();

    if (newUnread.isNotEmpty) _showForegroundNotice(newUnread.first);
  }

  void _handleStreamError(Object streamError) {
    loading = false;
    error = 'Notifications could not sync. Pull down to retry.';
    notifyListeners();
  }

  void _showForegroundNotice(GameNotification notification) {
    NotificationService.instance.presentInAppNotification(
      id: notification.id,
      title: notification.title,
      body: notification.body,
    );
  }

  Future<void> refresh() async {
    if (_userId == null) return;
    try {
      final rows = await _client
          .from('player_notifications')
          .select()
          .eq('recipient_id', _userId)
          .order('created_at', ascending: false)
          .limit(100);
      _applyRows(List<Map<String, dynamic>>.from(rows));
    } catch (_) {
      error = 'Notifications could not sync. Check your connection.';
      loading = false;
      notifyListeners();
    }
  }

  Future<void> markRead(String notificationId) async {
    if (_userId == null) return;
    await _client
        .from('player_notifications')
        .update({'read_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', notificationId)
        .eq('recipient_id', _userId);
  }

  Future<void> markAllRead() async {
    if (_userId == null || unreadCount == 0) return;
    await _client
        .from('player_notifications')
        .update({'read_at': DateTime.now().toUtc().toIso8601String()})
        .eq('recipient_id', _userId)
        .isFilter('read_at', null);
  }

  Future<void> delete(String notificationId) async {
    if (_userId == null) return;
    final previous = notifications;
    notifications = notifications
        .where((notification) => notification.id != notificationId)
        .toList(growable: false);
    _knownIds = notifications.map((notification) => notification.id).toSet();
    notifyListeners();
    try {
      await _client
          .from('player_notifications')
          .delete()
          .eq('id', notificationId)
          .eq('recipient_id', _userId);
    } catch (_) {
      notifications = previous;
      _knownIds = previous.map((notification) => notification.id).toSet();
      error = 'That notification could not be deleted.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
