import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
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

  Future<bool> _run(
    GameNotification notification,
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    if (_busy.contains(notification.id)) return false;
    setState(() => _busy.add(notification.id));
    try {
      await action();
      await widget.controller.markRead(notification.id);
      if (mounted && successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF173C6D),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFFFD95A),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(successMessage)),
              ],
            ),
          ),
        );
      }
      return true;
    } catch (error) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Could not complete that action: $error'),
        ),
      );
      return false;
    } finally {
      if (mounted) setState(() => _busy.remove(notification.id));
    }
  }

  Future<void> _respondToFriend(
    GameNotification notification,
    bool approve,
  ) async {
    await _run(
      notification,
      () => _repository.respondFriendRequest(
        notification.data['request_id'] as String,
        approve,
      ),
      successMessage: approve
          ? 'Friend unlocked! You can invite them to a game now.'
          : 'Friend request declined.',
    );
  }

  Future<void> _respondToInvite(
    GameNotification notification,
    bool approve,
  ) async {
    CoopRoom? joinedRoom;
    final completed = await _run(
      notification,
      () async {
        joinedRoom = await _repository.respondCoopInvite(
          notification.data['invite_id'] as String,
          approve,
        );
      },
      successMessage: approve
          ? 'Game approved! Loading the waiting room.'
          : 'Game invitation declined.',
    );
    if (completed && approve && joinedRoom != null && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CoopWaitingRoomScreen(initialRoom: joinedRoom!),
        ),
      );
    }
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
                    if (!NotificationService.instance.hasPermission) ...[
                      _PushStatusCard(controller: controller),
                      const SizedBox(height: 14),
                    ],
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
                          onTap: notification.hasResponseAction
                              ? null
                              : () => controller.markRead(notification.id),
                          onDelete: () => controller.delete(notification.id),
                          onFriendResponse:
                              notification.canRespondToFriendRequest
                              ? (approve) =>
                                    _respondToFriend(notification, approve)
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
              const SizedBox(height: 60),
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
    if (NotificationService.instance.hasPermission) {
      return const SizedBox.shrink();
    }

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
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool>? onFriendResponse;
  final ValueChanged<bool>? onInviteResponse;

  @override
  Widget build(BuildContext context) {
    final visuals = _NotificationVisuals.forKind(notification.kind);
    final action = onFriendResponse ?? onInviteResponse;
    return Dismissible(
      key: ValueKey(notification.id),
      direction: busy ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4475F), Color(0xFF8F274A)],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_forever_rounded, color: Colors.white, size: 30),
            Text(
              'CLEAR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: notification.isRead ? 0.78 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: visuals.shadow.withValues(
                  alpha: notification.isRead ? 0.18 : 0.42,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: visuals.gradient,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: visuals.border, width: 2.5),
              ),
              child: InkWell(
                onTap: onTap,
                child: Stack(
                  children: [
                    Positioned(
                      right: -22,
                      top: -26,
                      child: _Bubble(color: visuals.accent, size: 92),
                    ),
                    Positioned(
                      right: 52,
                      bottom: -34,
                      child: _Bubble(color: visuals.accent, size: 64),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _NotificationSticker(visuals: visuals),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _TypePill(visuals: visuals),
                                    const Spacer(),
                                    if (!notification.isRead) ...[
                                      Container(
                                        width: 9,
                                        height: 9,
                                        decoration: BoxDecoration(
                                          color: visuals.accent,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: visuals.accent,
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                    ],
                                    Text(
                                      _relativeTime(notification.createdAt),
                                      style: GoogleFonts.fredoka(
                                        color: Colors.white.withValues(
                                          alpha: 0.76,
                                        ),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  notification.title.toUpperCase(),
                                  style: GoogleFonts.luckiestGuy(
                                    color: Colors.white,
                                    fontSize: 19,
                                    height: 1.05,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  notification.body,
                                  style: GoogleFonts.fredoka(
                                    color: Colors.white,
                                    height: 1.3,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (notification.gameMode != null) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 7,
                                    runSpacing: 7,
                                    children: [
                                      _MetaChip(
                                        icon: Icons.stadium_rounded,
                                        text: notification.gameMode!,
                                      ),
                                      if (notification.maxPlayers != null)
                                        _MetaChip(
                                          icon: Icons.groups_rounded,
                                          text:
                                              '${notification.maxPlayers} PLAYERS',
                                        ),
                                    ],
                                  ),
                                ],
                                if (action != null) ...[
                                  const SizedBox(height: 14),
                                  if (busy)
                                    _WorkingPill(accent: visuals.accent)
                                  else
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _CartoonActionButton(
                                            label: 'DECLINE',
                                            icon: Icons.close_rounded,
                                            background: const Color(0xFFFFE8EC),
                                            foreground: const Color(0xFFA52F4C),
                                            onPressed: () => action(false),
                                          ),
                                        ),
                                        const SizedBox(width: 9),
                                        Expanded(
                                          child: _CartoonActionButton(
                                            label: 'APPROVE',
                                            icon: Icons.check_rounded,
                                            background: const Color(0xFF8CE99A),
                                            foreground: const Color(0xFF123E2C),
                                            onPressed: () => action(true),
                                          ),
                                        ),
                                      ],
                                    ),
                                ] else ...[
                                  const SizedBox(height: 11),
                                  Row(
                                    children: [
                                      Icon(
                                        visuals.footerIcon,
                                        color: visuals.accent,
                                        size: 17,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          visuals.footer,
                                          style: GoogleFonts.fredoka(
                                            color: Colors.white.withValues(
                                              alpha: 0.82,
                                            ),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
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
                  ],
                ),
              ),
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

class _NotificationVisuals {
  const _NotificationVisuals({
    required this.gradient,
    required this.border,
    required this.accent,
    required this.shadow,
    required this.icon,
    required this.label,
    required this.footer,
    required this.footerIcon,
  });

  final List<Color> gradient;
  final Color border;
  final Color accent;
  final Color shadow;
  final IconData icon;
  final String label;
  final String footer;
  final IconData footerIcon;

  factory _NotificationVisuals.forKind(GameNotificationKind kind) {
    return switch (kind) {
      GameNotificationKind.friendRequest => const _NotificationVisuals(
        gradient: [Color(0xFF6246C7), Color(0xFF3D70C9)],
        border: Color(0xFFB8B1FF),
        accent: Color(0xFFFFD95A),
        shadow: Color(0xFF6C57E0),
        icon: Icons.person_add_alt_1_rounded,
        label: 'FRIEND REQUEST',
        footer: 'A NEW TEAMMATE IS WAITING!',
        footerIcon: Icons.waving_hand_rounded,
      ),
      GameNotificationKind.friendAccepted => const _NotificationVisuals(
        gradient: [Color(0xFF15967C), Color(0xFF2773A4)],
        border: Color(0xFF8FF5C5),
        accent: Color(0xFFFFE46B),
        shadow: Color(0xFF20B58E),
        icon: Icons.celebration_rounded,
        label: 'FRIEND UNLOCKED',
        footer: 'YOU CAN INVITE THEM TO PLAY NOW!',
        footerIcon: Icons.auto_awesome_rounded,
      ),
      GameNotificationKind.friendDeclined => const _NotificationVisuals(
        gradient: [Color(0xFF58617D), Color(0xFF343A55)],
        border: Color(0xFF9FAAC9),
        accent: Color(0xFFD7DDF0),
        shadow: Color(0xFF30374F),
        icon: Icons.person_remove_alt_1_rounded,
        label: 'FRIEND UPDATE',
        footer: 'NO WORRIES — MORE PLAYERS AWAIT!',
        footerIcon: Icons.explore_rounded,
      ),
      GameNotificationKind.gameInvite => const _NotificationVisuals(
        gradient: [Color(0xFFE8663C), Color(0xFF9F3FAB)],
        border: Color(0xFFFFC56B),
        accent: Color(0xFFFFE56B),
        shadow: Color(0xFFE8663C),
        icon: Icons.sports_esports_rounded,
        label: 'GAME INVITE',
        footer: 'YOUR NEXT CHALLENGE IS READY!',
        footerIcon: Icons.bolt_rounded,
      ),
      GameNotificationKind.gameInviteAccepted => const _NotificationVisuals(
        gradient: [Color(0xFF238D5C), Color(0xFF176B82)],
        border: Color(0xFF88EEAB),
        accent: Color(0xFFA8FFBD),
        shadow: Color(0xFF22A66B),
        icon: Icons.rocket_launch_rounded,
        label: 'PLAYER JOINED',
        footer: 'THE TEAM IS GETTING READY!',
        footerIcon: Icons.groups_rounded,
      ),
      GameNotificationKind.gameInviteDeclined => const _NotificationVisuals(
        gradient: [Color(0xFFA54255), Color(0xFF613C63)],
        border: Color(0xFFFFA9B7),
        accent: Color(0xFFFFC1CB),
        shadow: Color(0xFF9D3B50),
        icon: Icons.sports_esports_outlined,
        label: 'INVITE DECLINED',
        footer: 'TRY ANOTHER FRIEND OR MODE!',
        footerIcon: Icons.refresh_rounded,
      ),
      GameNotificationKind.gameInviteCancelled => const _NotificationVisuals(
        gradient: [Color(0xFF596276), Color(0xFF38445C)],
        border: Color(0xFFA6B0C7),
        accent: Color(0xFFE0E5EF),
        shadow: Color(0xFF354157),
        icon: Icons.event_busy_rounded,
        label: 'INVITE CLOSED',
        footer: 'THIS ROOM IS NO LONGER ACTIVE.',
        footerIcon: Icons.schedule_rounded,
      ),
      GameNotificationKind.system => const _NotificationVisuals(
        gradient: [Color(0xFF2866A8), Color(0xFF173C74)],
        border: Color(0xFF74D9FF),
        accent: Color(0xFFFFD95A),
        shadow: Color(0xFF2262A3),
        icon: Icons.campaign_rounded,
        label: 'BALANCO NEWS',
        footer: 'KEEP BALANCING!',
        footerIcon: Icons.stars_rounded,
      ),
    };
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.16), width: 2),
      ),
    );
  }
}

class _NotificationSticker extends StatelessWidget {
  const _NotificationSticker({required this.visuals});

  final _NotificationVisuals visuals;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.07,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: visuals.accent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF172443), width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x660A1731),
              blurRadius: 0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Icon(visuals.icon, color: const Color(0xFF172443), size: 30),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.visuals});

  final _NotificationVisuals visuals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF10264C).withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: visuals.accent.withValues(alpha: 0.72)),
      ),
      child: Text(
        visuals.label,
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.45,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.fredoka(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartoonActionButton extends StatelessWidget {
  const _CartoonActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          textStyle: GoogleFonts.fredoka(fontWeight: FontWeight.w900),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: foreground, width: 2),
          ),
          elevation: 5,
          shadowColor: const Color(0xAA0A1731),
        ),
      ),
    );
  }
}

class _WorkingPill extends StatelessWidget {
  const _WorkingPill({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 19,
            child: CircularProgressIndicator(color: accent, strokeWidth: 2.5),
          ),
          const SizedBox(width: 9),
          Text(
            'MAKING IT HAPPEN...',
            style: GoogleFonts.fredoka(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
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
