import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/presentation/coop_waiting_room_screen.dart';
import 'package:balanco_game/features/notifications/application/notification_inbox_controller.dart';
import 'package:balanco_game/features/notifications/application/notification_service.dart';
import 'package:balanco_game/features/notifications/domain/game_notification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  final NotificationInboxController controller;
  final ScrollController scrollController;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final CoopRepository _repository = CoopRepository(Supabase.instance.client);
  final Set<String> _busy = <String>{};

  Future<void> _run(
    GameNotification notification,
    Future<void> Function() action,
  ) async {
    if (_busy.contains(notification.id)) return;
    setState(() => _busy.add(notification.id));
    try {
      await action();
      await widget.controller.markRead(notification.id);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not complete that action: $error')),
      );
    } finally {
      if (mounted) setState(() => _busy.remove(notification.id));
    }
  }

  Future<void> _respondToInvite(
    GameNotification notification,
    bool accept,
  ) async {
    await _run(notification, () async {
      final room = await _repository.respondCoopInvite(
        notification.data['invite_id'] as String,
        accept,
      );
      if (accept && room != null && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CoopWaitingRoomScreen(initialRoom: room),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            controller: widget.scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.paddingOf(context).top + 108,
                  16,
                  MediaQuery.paddingOf(context).bottom + 125,
                ),
                sliver: SliverList.list(
                  children: [
                    _Header(controller: controller),
                    const SizedBox(height: 12),
                    _PushStatusCard(controller: controller),
                    const SizedBox(height: 14),
                    if (!controller.signedIn)
                      const _EmptyState(
                        icon: Icons.person_off_rounded,
                        title: 'SIGN IN TO SYNC',
                        body:
                            'Friend requests and game invites will appear here on every device.',
                      )
                    else if (controller.loading &&
                        controller.notifications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (controller.error != null &&
                        controller.notifications.isEmpty)
                      _EmptyState(
                        icon: Icons.cloud_off_rounded,
                        title: 'SYNC PAUSED',
                        body: controller.error!,
                      )
                    else if (controller.notifications.isEmpty)
                      const _EmptyState(
                        icon: Icons.notifications_none_rounded,
                        title: 'ALL QUIET',
                        body:
                            'Your friend requests, game invites, and important Balanco updates will appear here.',
                      )
                    else
                      for (final notification in controller.notifications) ...[
                        _NotificationCard(
                          notification: notification,
                          busy: _busy.contains(notification.id),
                          onTap: () => controller.markRead(notification.id),
                          onDelete: () => controller.delete(notification.id),
                          onFriendResponse:
                              notification.canRespondToFriendRequest
                              ? (accept) => _run(notification, () {
                                  return _repository.respondFriendRequest(
                                    notification.data['request_id'] as String,
                                    accept,
                                  );
                                })
                              : null,
                          onInviteResponse: notification.canRespondToGameInvite
                              ? (accept) =>
                                    _respondToInvite(notification, accept)
                              : null,
                        ),
                        const SizedBox(height: 10),
                      ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final NotificationInboxController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOTIFICATIONS',
                style: GoogleFonts.luckiestGuy(
                  color: Colors.white,
                  fontSize: 28,
                  shadows: const [
                    Shadow(color: Colors.black38, offset: Offset(0, 3)),
                  ],
                ),
              ),
              Text(
                controller.unreadCount == 0
                    ? 'YOU ARE ALL CAUGHT UP'
                    : '${controller.unreadCount} NEW FOR YOU',
                style: GoogleFonts.fredoka(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (controller.unreadCount > 0)
          TextButton.icon(
            onPressed: controller.markAllRead,
            icon: const Icon(Icons.done_all_rounded),
            label: const Text('READ ALL'),
          ),
      ],
    );
  }
}

class _PushStatusCard extends StatefulWidget {
  const _PushStatusCard({required this.controller});

  final NotificationInboxController controller;

  @override
  State<_PushStatusCard> createState() => _PushStatusCardState();
}

class _PushStatusCardState extends State<_PushStatusCard> {
  bool _requesting = false;

  Future<void> _enable() async {
    if (_requesting) return;
    setState(() => _requesting = true);
    final granted = await NotificationService.instance.requestPermission();
    if (!mounted) return;
    setState(() => _requesting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? 'Push notifications are enabled.'
              : 'Permission was not enabled. You can allow it in device settings.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nativePush = NotificationService.instance.supportsNativePush;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF162E63).withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF42CAFF), width: 2),
      ),
      child: Row(
        children: [
          Icon(
            nativePush
                ? Icons.notifications_active_rounded
                : Icons.desktop_windows_rounded,
            color: const Color(0xFF42CAFF),
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nativePush ? 'ONESIGNAL PUSH' : 'LIVE PC INBOX',
                  style: GoogleFonts.luckiestGuy(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  nativePush
                      ? 'Never miss a friend request or game invite.'
                      : 'Updates sync instantly while Balanco is open on Windows.',
                  style: GoogleFonts.fredoka(color: Colors.white70),
                ),
              ],
            ),
          ),
          if (nativePush)
            FilledButton(
              onPressed: _requesting ? null : _enable,
              child: _requesting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('ENABLE'),
            ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.busy,
    required this.onTap,
    required this.onDelete,
    this.onFriendResponse,
    this.onInviteResponse,
  });

  final GameNotification notification;
  final bool busy;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool>? onFriendResponse;
  final ValueChanged<bool>? onInviteResponse;

  IconData get _icon => switch (notification.type) {
    'friend_request' || 'friend_accepted' => Icons.group_add_rounded,
    'game_invite' => Icons.sports_esports_rounded,
    'game_invite_accepted' => Icons.check_circle_rounded,
    'game_invite_declined' || 'game_invite_cancelled' => Icons.cancel_rounded,
    _ => Icons.campaign_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final action = onFriendResponse ?? onInviteResponse;
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Material(
        color: notification.isRead
            ? const Color(0xFF203A6B).withValues(alpha: 0.72)
            : const Color(0xFF274F91).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: notification.isRead
                    ? Colors.white24
                    : const Color(0xFF42CAFF),
                width: notification.isRead ? 1 : 2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF42CAFF),
                  foregroundColor: const Color(0xFF102757),
                  child: Icon(_icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title.toUpperCase(),
                              style: GoogleFonts.luckiestGuy(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            _relativeTime(notification.createdAt),
                            style: GoogleFonts.fredoka(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(height: 10),
                        if (busy)
                          const LinearProgressIndicator()
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => action(false),
                                  child: const Text('DECLINE'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => action(true),
                                  child: const Text('ACCEPT'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _relativeTime(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 1) return 'NOW';
    if (difference.inHours < 1) return '${difference.inMinutes}M';
    if (difference.inDays < 1) return '${difference.inHours}H';
    if (difference.inDays < 7) return '${difference.inDays}D';
    return '${date.day}/${date.month}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 52),
      decoration: BoxDecoration(
        color: const Color(0xFF203A6B).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 58, color: const Color(0xFF42CAFF)),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.luckiestGuy(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
