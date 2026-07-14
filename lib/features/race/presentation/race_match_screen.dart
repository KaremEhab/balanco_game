import 'dart:async';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/race/application/race_game_coordinator.dart';
import 'package:balanco_game/features/race/presentation/race_portrait_match_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RaceMatchScreen extends StatefulWidget {
  const RaceMatchScreen({
    super.key,
    required this.room,
    required this.realtime,
    required this.voice,
  });

  final CoopRoom room;
  final CoopRealtimeSession realtime;
  final VoiceChatController voice;

  @override
  State<RaceMatchScreen> createState() => _RaceMatchScreenState();
}

class _RaceMatchScreenState extends State<RaceMatchScreen> {
  late final String _userId;
  late final BalancoGame _localGame;
  late final BalancoGame _remoteGame;
  late final RaceGameCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );
    _userId = Supabase.instance.client.auth.currentUser!.id;
    _localGame = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: widget.room.seed,
      raceBallTint: const Color(0xFF34C9FF),
      enableTutorials: false,
      isRaceMode: true,
    )..currentLevel.value = widget.room.raceLevel;
    _remoteGame = BalancoGame(
      isMultiplayer: true,
      playerRole: 'BOTH',
      randomSeed: widget.room.seed,
      raceBallTint: const Color(0xFFAEB4C1),
      enableTutorials: false,
      isRaceMode: true,
    )..currentLevel.value = widget.room.raceLevel;
    _coordinator = RaceGameCoordinator(
      initialRoom: widget.room,
      userId: _userId,
      localGame: _localGame,
      remoteGame: _remoteGame,
      repository: CoopRepository(Supabase.instance.client),
      realtime: widget.realtime,
    )..attach();
    _coordinator.room.addListener(_handleRoomChange);
    _coordinator.actionError.addListener(_handleActionError);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Race mounts two Flame games. Restore iOS's voice-chat audio session
      // after both games and their audio caches have initialized.
      widget.voice.scheduleGameplayRecovery();
    });
  }

  void _handleRoomChange() {
    if (!_coordinator.room.value.endedByAgreement || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  void _handleActionError() {
    final message = _coordinator.actionError.value;
    if (message == null || !mounted) return;
    _coordinator.actionError.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  void dispose() {
    _coordinator.room.removeListener(_handleRoomChange);
    _coordinator.actionError.removeListener(_handleActionError);
    _coordinator.dispose();
    widget.voice.dispose();
    widget.realtime.dispose();
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );
    super.dispose();
  }

  Future<void> _confirmLeave() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close leave dialog',
      barrierColor: const Color(0xB3081238),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (_, animation, _, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
      pageBuilder: (dialogContext, _, _) => Center(
        child: _RaceDialogShell(
          icon: Icons.exit_to_app_rounded,
          title: 'LEAVE TOGETHER?',
          subtitle:
              'Your opponent must agree before this race closes for both players.',
          accent: GameColors.red300,
          child: Row(
            children: [
              Expanded(
                child: _RaceDialogButton(
                  icon: Icons.sports_esports_rounded,
                  label: 'KEEP RACING',
                  color: GameColors.green300,
                  onTap: () => Navigator.pop(dialogContext, false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RaceDialogButton(
                  icon: Icons.handshake_rounded,
                  label: 'ASK TO LEAVE',
                  color: GameColors.red300,
                  onTap: () => Navigator.pop(dialogContext, true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) await _coordinator.requestLeave();
  }

  Future<void> _openMatchMenu() async {
    if (!mounted) return;
    await showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'Close race menu',
      barrierColor: const Color(0xB3081238),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (_, animation, _, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
      pageBuilder: (dialogContext, _, _) => Center(
        child: _RaceDialogShell(
          icon: Icons.tune_rounded,
          title: 'RACE CONTROLS',
          subtitle: 'Audio and shared match actions',
          accent: GameColors.purpleAccent,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 12,
            children: [
              ListenableBuilder(
                listenable: Listenable.merge([
                  widget.voice.muted,
                  widget.voice.connected,
                  widget.voice.error,
                ]),
                builder: (_, _) {
                  final muted = widget.voice.muted.value;
                  final failed = widget.voice.error.value != null;
                  return _MenuButton(
                    icon: failed
                        ? Icons.sync_rounded
                        : muted
                        ? Icons.mic_off_rounded
                        : Icons.mic_rounded,
                    label: failed
                        ? 'RECONNECT MIC'
                        : muted
                        ? 'UNMUTE'
                        : 'MUTE',
                    onTap: failed
                        ? widget.voice.scheduleGameplayRecovery
                        : widget.voice.toggleMute,
                  );
                },
              ),
              _MenuButton(
                icon: Icons.pause_rounded,
                label: 'PAUSE BOTH',
                onTap: () {
                  Navigator.pop(dialogContext);
                  unawaited(_coordinator.setPaused(true));
                },
              ),
              _MenuButton(
                icon: Icons.exit_to_app_rounded,
                label: 'LEAVE',
                color: const Color(0xFFE84D4D),
                onTap: () {
                  Navigator.pop(dialogContext);
                  unawaited(_confirmLeave());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _confirmLeave();
    },
    child: Scaffold(
      backgroundColor: const Color(0xFF08194E),
      body: SafeArea(
        child: ValueListenableBuilder<CoopRoom>(
          valueListenable: _coordinator.room,
          builder: (context, room, _) => Stack(
            children: [
              Positioned.fill(
                child: RacePortraitMatchView(
                  room: room,
                  userId: _userId,
                  localGame: _localGame,
                  remoteGame: _remoteGame,
                  coordinator: _coordinator,
                  voice: widget.voice,
                  onLeave: _confirmLeave,
                  onPause: () => _coordinator.setPaused(true),
                  onSettings: _openMatchMenu,
                ),
              ),
              if (room.isEnded)
                _RaceResultOverlay(
                  userId: _userId,
                  won: room.winnerId == _userId,
                  room: room,
                  localGame: _localGame,
                  remoteStars: _coordinator.remoteStars.value,
                  rematchWaiting: room.rematchRequestedBy == _userId,
                  rematchOffered:
                      room.rematchRequestedBy != null &&
                      room.rematchRequestedBy != _userId,
                  restartKind: room.raceRestartKind,
                  onRetry: _coordinator.requestRetry,
                  onContinue: _coordinator.requestContinue,
                  onAccept: _coordinator.acceptRestartOffer,
                  onExit: _coordinator.requestPostgameExit,
                ),
              if (room.isPaused ||
                  room.hasLeaveVote ||
                  room.hasPostgameExitVote)
                _RaceAgreementOverlay(
                  room: room,
                  userId: _userId,
                  coordinator: _coordinator,
                  onSettings: _openMatchMenu,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _RaceDialogShell extends StatelessWidget {
  const _RaceDialogShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Container(
      width: 356,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: GameColors.sandLightUi,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: GameColors.brownDarkUi, width: 4),
        boxShadow: const [
          BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 7)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              border: Border.all(color: GameColors.brownDarkUi, width: 3),
              boxShadow: const [
                BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 3)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 29),
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  fontSize: 27,
                  letterSpacing: 1,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = GameColors.brownDarkUi,
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  color: accent,
                  fontSize: 27,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              color: GameColors.brownDarkUi,
              fontSize: 15,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 17),
          child,
        ],
      ),
    ),
  );
}

class _RaceDialogButton extends StatelessWidget {
  const _RaceDialogButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1 : 0.5,
    child: GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: GameColors.brownDarkUi, width: 3),
          boxShadow: const [
            BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  color: Colors.white,
                  fontSize: 13,
                  shadows: const [
                    Shadow(color: GameColors.brownDarkUi, offset: Offset(0, 2)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF6544CF),
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 142,
    child: _RaceDialogButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
    ),
  );
}

class _RaceResultOverlay extends StatelessWidget {
  const _RaceResultOverlay({
    required this.userId,
    required this.won,
    required this.room,
    required this.localGame,
    required this.remoteStars,
    required this.rematchWaiting,
    required this.rematchOffered,
    required this.restartKind,
    required this.onRetry,
    required this.onContinue,
    required this.onAccept,
    required this.onExit,
  });

  final String userId;
  final bool won;
  final CoopRoom room;
  final BalancoGame localGame;
  final int remoteStars;
  final bool rematchWaiting;
  final bool rematchOffered;
  final String? restartKind;
  final VoidCallback onRetry;
  final VoidCallback onContinue;
  final VoidCallback onAccept;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final local = room.memberFor(userId);
    final opponent = room.members.firstWhere(
      (member) => member.userId != userId,
      orElse: () => local,
    );
    final winner = room.winnerId == local.userId ? local : opponent;
    final duration = Duration(milliseconds: room.winnerElapsedMs ?? 0);
    final time =
        '${duration.inMinutes.toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    final accent = won ? GameColors.green300 : GameColors.orangeTextUi;
    final endedBySurrender = room.raceEndKind == 'surrender';

    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD9081238),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: _RaceDialogShell(
                icon: won
                    ? Icons.emoji_events_rounded
                    : Icons.sports_score_rounded,
                title: won ? 'VICTORY!' : 'RACE COMPLETE',
                subtitle: endedBySurrender
                    ? '${winner.displayName} wins by surrender'
                    : '${winner.displayName} reached the finish gate first',
                accent: accent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RaceWinScoreboard(
                      localWins: local.raceWins,
                      level: room.raceLevel,
                      opponentWins: opponent.raceWins,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _RaceResultStat(
                          icon: Icons.timer_outlined,
                          label: endedBySurrender ? '--:--' : time,
                          caption: 'FINISH TIME',
                        ),
                        _RaceResultStat(
                          icon: Icons.favorite_rounded,
                          label: '${room.winnerHearts ?? 0}',
                          caption: 'WINNER HEARTS',
                        ),
                        _RaceResultStat(
                          icon: Icons.star_rounded,
                          label: '${room.winnerStars ?? 0}',
                          caption: 'WINNER STARS',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'YOU ${localGame.currentPoints.value} STARS   •   '
                      'OPPONENT $remoteStars STARS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        color: GameColors.brownDarkUi,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (rematchOffered)
                      SizedBox(
                        width: double.infinity,
                        child: _RaceDialogButton(
                          icon: Icons.handshake_rounded,
                          label: restartKind == 'retry'
                              ? 'ACCEPT RETRY'
                              : 'ACCEPT LEVEL ${room.raceLevel + 1}',
                          color: GameColors.green300,
                          onTap: onAccept,
                        ),
                      )
                    else if (rematchWaiting)
                      SizedBox(
                        width: double.infinity,
                        child: _RaceDialogButton(
                          icon: Icons.hourglass_bottom_rounded,
                          label: restartKind == 'retry'
                              ? 'RETRY REQUEST SENT'
                              : 'CONTINUE REQUEST SENT',
                          color: GameColors.blueGray600,
                          enabled: false,
                          onTap: () {},
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _RaceDialogButton(
                              icon: Icons.replay_rounded,
                              label: 'RETRY',
                              color: GameColors.purpleAccent,
                              onTap: onRetry,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _RaceDialogButton(
                              icon: Icons.arrow_forward_rounded,
                              label: 'LEVEL ${room.raceLevel + 1}',
                              color: GameColors.green300,
                              onTap: onContinue,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: _RaceDialogButton(
                        icon: Icons.home_rounded,
                        label: 'RETURN TO MODES',
                        color: GameColors.red300,
                        onTap: onExit,
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
}

class _RaceWinScoreboard extends StatelessWidget {
  const _RaceWinScoreboard({
    required this.localWins,
    required this.level,
    required this.opponentWins,
  });

  final int localWins;
  final int level;
  final int opponentWins;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFF203B80),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: GameColors.brownDarkUi, width: 3),
    ),
    child: Text(
      '$localWins  -  LVL $level  -  $opponentWins',
      textAlign: TextAlign.center,
      style: GoogleFonts.luckiestGuy(
        color: Colors.white,
        fontSize: 22,
        letterSpacing: 1,
      ),
    ),
  );
}

class _RaceResultStat extends StatelessWidget {
  const _RaceResultStat({
    required this.icon,
    required this.label,
    required this.caption,
  });

  final IconData icon;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) => Container(
    width: 92,
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
    decoration: BoxDecoration(
      color: GameColors.brownDarkUi.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(
        color: GameColors.brownDarkUi.withValues(alpha: 0.25),
        width: 1.5,
      ),
    ),
    child: Column(
      children: [
        Icon(icon, color: GameColors.orangeTextUi, size: 20),
        Text(
          label,
          style: GoogleFonts.luckiestGuy(
            color: GameColors.brownDarkUi,
            fontSize: 16,
          ),
        ),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: GameColors.brownDarkUi,
            fontSize: 8,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

class _RaceAgreementOverlay extends StatelessWidget {
  const _RaceAgreementOverlay({
    required this.room,
    required this.userId,
    required this.coordinator,
    required this.onSettings,
  });

  final CoopRoom room;
  final String userId;
  final RaceGameCoordinator coordinator;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final requestedByMe = room.leaveRequestedBy == userId;
    final postgame = room.hasPostgameExitVote;
    final paused = room.isPaused;
    final title = postgame
        ? 'RETURN TO MODES?'
        : room.hasLeaveVote
        ? 'LEAVE TOGETHER?'
        : 'RACE PAUSED';
    final subtitle = postgame
        ? requestedByMe
              ? 'Waiting for your opponent to agree.'
              : 'Your opponent wants both players to return to Modes.'
        : room.hasLeaveVote
        ? requestedByMe
              ? 'Waiting for your opponent to agree.'
              : 'Your opponent wants to leave this race together.'
        : 'The timer and both boards are frozen for both players.';

    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xC2081238),
        child: Center(
          child: _RaceDialogShell(
            icon: paused
                ? Icons.pause_rounded
                : postgame
                ? Icons.home_rounded
                : Icons.handshake_rounded,
            title: title,
            subtitle: subtitle,
            accent: paused ? GameColors.purpleAccent : GameColors.orangeTextUi,
            child: paused
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (room.rematchRequestedBy == null)
                        Row(
                          children: [
                            Expanded(
                              child: _RaceDialogButton(
                                icon: Icons.settings_rounded,
                                label: 'SETTINGS',
                                color: GameColors.blueGray600,
                                onTap: onSettings,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: _RaceDialogButton(
                                icon: Icons.replay_rounded,
                                label: 'RETRY',
                                color: GameColors.purpleAccent,
                                onTap: coordinator.requestRetry,
                              ),
                            ),
                          ],
                        )
                      else if (room.rematchRequestedBy == userId)
                        const _RaceWaitingMessage(
                          text: 'WAITING FOR OPPONENT TO ACCEPT RETRY...',
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: _RaceDialogButton(
                            icon: Icons.check_rounded,
                            label: 'ACCEPT RETRY',
                            color: GameColors.green300,
                            onTap: coordinator.acceptRestartOffer,
                          ),
                        ),
                      if (room.rematchRequestedBy == null) ...[
                        const SizedBox(height: 11),
                        SizedBox(
                          width: double.infinity,
                          child: _RaceDialogButton(
                            icon: Icons.play_arrow_rounded,
                            label: 'RESUME FOR BOTH',
                            color: GameColors.green300,
                            onTap: () => coordinator.setPaused(false),
                          ),
                        ),
                      ],
                    ],
                  )
                : requestedByMe
                ? const _RaceWaitingMessage(
                    text: 'WAITING FOR YOUR OPPONENT...',
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _RaceDialogButton(
                          icon: Icons.close_rounded,
                          label: 'STAY',
                          color: GameColors.blueGray600,
                          onTap: () => postgame
                              ? coordinator.respondToPostgameExit(false)
                              : coordinator.respondToLeave(false),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _RaceDialogButton(
                          icon: Icons.check_rounded,
                          label: postgame ? 'RETURN BOTH' : 'LEAVE BOTH',
                          color: GameColors.red300,
                          onTap: () => postgame
                              ? coordinator.respondToPostgameExit(true)
                              : coordinator.respondToLeave(true),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _RaceWaitingMessage extends StatelessWidget {
  const _RaceWaitingMessage({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: GameColors.brownDarkUi.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: GameColors.brownDarkUi.withValues(alpha: 0.2)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.luckiestGuy(
              color: GameColors.brownDarkUi,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}
