import 'dart:async';

import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/application/coop_realtime_session.dart';
import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:balanco_game/features/coop/data/coop_repository.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/components/game_area/shield_icon_painter.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/race/application/race_game_coordinator.dart';
import 'package:flame/game.dart';
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
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
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
      raceBallTint: const Color(0xFFFF963F),
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
  }

  void _handleRoomChange() {
    if (!_coordinator.room.value.endedByAgreement || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _coordinator.room.removeListener(_handleRoomChange);
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('LEAVE TOGETHER?', style: GoogleFonts.luckiestGuy()),
        content: const Text(
          'Your partner must agree before this race closes for both players.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('KEEP RACING'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ASK TO LEAVE'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _coordinator.requestLeave();
  }

  void _openMatchMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF16275D),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: widget.voice.muted,
                builder: (_, muted, _) => _MenuButton(
                  icon: muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  label: muted ? 'UNMUTE' : 'MUTE',
                  onTap: widget.voice.toggleMute,
                ),
              ),
              const SizedBox(width: 14),
              _MenuButton(
                icon: Icons.pause_rounded,
                label: 'PAUSE BOTH',
                onTap: () {
                  Navigator.pop(context);
                  _coordinator.setPaused(true);
                },
              ),
              const SizedBox(width: 14),
              _MenuButton(
                icon: Icons.exit_to_app_rounded,
                label: 'LEAVE',
                color: const Color(0xFFE84D4D),
                onTap: () {
                  Navigator.pop(context);
                  _confirmLeave();
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(62, 4, 62, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _coordinator.showBoardLabels,
                          builder: (_, visible, _) => _RaceBoard(
                            game: _localGame,
                            label: 'YOU',
                            showLabel: visible,
                            accent: const Color(0xFF34C9FF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _coordinator.showBoardLabels,
                          builder: (_, visible, _) => _RaceBoard(
                            game: _remoteGame,
                            label: 'OPPONENT',
                            showLabel: visible,
                            accent: const Color(0xFFFF963F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 7,
                bottom: 24,
                child: _VerticalRaceControl(
                  accent: const Color(0xFF34C9FF),
                  onChanged: (value) => _localGame.leftJoystickValue = value,
                ),
              ),
              Positioned(
                right: 7,
                bottom: 24,
                child: _VerticalRaceControl(
                  accent: const Color(0xFF34C9FF),
                  onChanged: (value) => _localGame.rightJoystickValue = value,
                ),
              ),
              Positioned(
                left: 72,
                right: 72,
                bottom: 8,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: SizedBox(
                      width: double.infinity,
                      child: _RaceBottomNav(
                        localGame: _localGame,
                        coordinator: _coordinator,
                        voice: widget.voice,
                        level: room.raceLevel,
                        onBack: _confirmLeave,
                        onPause: () => _coordinator.setPaused(true),
                        onSettings: _openMatchMenu,
                      ),
                    ),
                  ),
                ),
              ),
              if (room.isEnded)
                _RaceResultOverlay(
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
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _RaceBottomNav extends StatefulWidget {
  const _RaceBottomNav({
    required this.localGame,
    required this.coordinator,
    required this.voice,
    required this.level,
    required this.onBack,
    required this.onPause,
    required this.onSettings,
  });

  final BalancoGame localGame;
  final RaceGameCoordinator coordinator;
  final VoiceChatController voice;
  final int level;
  final VoidCallback onBack;
  final VoidCallback onPause;
  final VoidCallback onSettings;

  @override
  State<_RaceBottomNav> createState() => _RaceBottomNavState();
}

class _RaceBottomNavState extends State<_RaceBottomNav> {
  Timer? _idleTimer;
  bool _revealed = false;

  BalancoGame get localGame => widget.localGame;
  RaceGameCoordinator get coordinator => widget.coordinator;
  VoiceChatController get voice => widget.voice;
  int get level => widget.level;
  VoidCallback get onBack => widget.onBack;
  VoidCallback get onPause => widget.onPause;
  VoidCallback get onSettings => widget.onSettings;

  void _reveal() {
    if (!_revealed) setState(() => _revealed = true);
    _scheduleCollapse();
  }

  void _scheduleCollapse() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _revealed = false);
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) {
      if (_revealed) _scheduleCollapse();
    },
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _revealed ? null : _reveal,
      child: AnimatedScale(
        scale: _revealed ? 1.0 : 0.90,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _revealed ? 1.0 : 0.40,
          duration: const Duration(milliseconds: 220),
          child: AbsorbPointer(absorbing: !_revealed, child: _buildNavbar()),
        ),
      ),
    ),
  );

  Widget _buildNavbar() => Container(
    height: 54,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xE815285E),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white70, width: 1.5),
      boxShadow: const [
        BoxShadow(color: Colors.black54, blurRadius: 14, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HudButton(icon: Icons.exit_to_app_rounded, onTap: onBack),
            const SizedBox(width: 5),
            ValueListenableBuilder<double>(
              valueListenable: localGame.shieldTimerNotifier,
              builder: (_, _, _) => ValueListenableBuilder<int>(
                valueListenable: localGame.remainingShields,
                builder: (_, count, _) => _PowerButton(
                  count: count,
                  active: localGame.isShieldActive,
                  enabled: count > 0 && !localGame.isShieldActive,
                  onTap: localGame.activateShield,
                  child: CustomPaint(
                    size: const Size.square(23),
                    painter: ShieldIconPainter(color: const Color(0xFF2BD0FF)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            ValueListenableBuilder<int>(
              valueListenable: localGame.currentLives,
              builder: (_, lives, _) => _LivesButton(lives: lives),
            ),
          ],
        ),
        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LevelBadge(level: level),
                const SizedBox(width: 6),
                ValueListenableBuilder<Duration>(
                  valueListenable: coordinator.elapsed,
                  builder: (_, elapsed, _) => _TimerPill(elapsed: elapsed),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: voice.muted,
              builder: (_, muted, _) => _HudButton(
                icon: muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                onTap: voice.toggleMute,
                active: !muted,
              ),
            ),
            const SizedBox(width: 5),
            _HudButton(icon: Icons.pause_rounded, onTap: onPause),
            const SizedBox(width: 5),
            _HudButton(icon: Icons.settings_rounded, onTap: onSettings),
          ],
        ),
      ],
    ),
  );
}

class _RaceBoard extends StatelessWidget {
  const _RaceBoard({
    required this.game,
    required this.label,
    required this.accent,
    required this.showLabel,
  });

  final BalancoGame game;
  final String label;
  final Color accent;
  final bool showLabel;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: accent.withValues(alpha: 0.9), width: 3),
      boxShadow: [
        BoxShadow(
          color: accent.withValues(alpha: 0.35),
          blurRadius: 16,
          spreadRadius: 1,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accent.withValues(alpha: 0.34),
                    const Color(0xFF173F86),
                  ],
                ),
              ),
              child: GameWidget(game: game),
            ),
          ),
          if (showLabel)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: showLabel ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xDD14204B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: accent, width: 2),
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.luckiestGuy(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          _CountdownLabel(game: game),
        ],
      ),
    ),
  );
}

class _CountdownLabel extends StatelessWidget {
  const _CountdownLabel({required this.game});
  final BalancoGame game;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: game.countdownNotifier,
          builder: (_, value, _) {
            if (value <= 0) return const SizedBox.shrink();
            final text = switch (value) {
              >= 4 => '3',
              3 => '2',
              2 => '1',
              _ => 'GO!',
            };
            return Text(
              text,
              style: GoogleFonts.luckiestGuy(
                color: Colors.white,
                fontSize: 48,
                shadows: const [
                  Shadow(color: Color(0xFF6544CF), blurRadius: 14),
                  Shadow(color: Colors.black, offset: Offset(2, 3)),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _VerticalRaceControl extends StatefulWidget {
  const _VerticalRaceControl({required this.accent, required this.onChanged});
  final Color accent;
  final ValueChanged<double> onChanged;

  @override
  State<_VerticalRaceControl> createState() => _VerticalRaceControlState();
}

class _VerticalRaceControlState extends State<_VerticalRaceControl> {
  double _value = 0;

  void _update(Offset local, double height) {
    final value = ((local.dy / height) * 2 - 1).clamp(-1.0, 1.0);
    setState(() => _value = value);
    widget.onChanged(value);
  }

  void _release() {
    setState(() => _value = 0);
    widget.onChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    const height = 132.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => _update(details.localPosition, height),
      onPanUpdate: (details) => _update(details.localPosition, height),
      onPanEnd: (_) => _release(),
      onPanCancel: _release,
      child: Container(
        width: 50,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0x66304F8F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white70, width: 2),
        ),
        child: Align(
          alignment: Alignment(0, _value),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.accent.withValues(alpha: 0.85),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: widget.accent, blurRadius: 9)],
            ),
            child: const Icon(
              Icons.unfold_more_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

class _PowerButton extends StatelessWidget {
  const _PowerButton({
    required this.count,
    required this.onTap,
    required this.child,
    this.active = false,
    this.enabled = true,
  });
  final int count;
  final bool active;
  final bool enabled;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6244B5) : const Color(0xFF273A76),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white70, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          if (count > 0)
            Positioned(
              right: 2,
              bottom: 1,
              child: Container(
                width: 14,
                height: 14,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE74C4C),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _LivesButton extends StatelessWidget {
  const _LivesButton({required this.lives});
  final int lives;

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: const Color(0xFF273A76),
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: Colors.white70, width: 1.5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.favorite_rounded, color: Color(0xFFFF5364), size: 16),
        const SizedBox(width: 2),
        Text(
          '$lives',
          style: GoogleFonts.luckiestGuy(color: Colors.white, fontSize: 11),
        ),
      ],
    ),
  );
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.elapsed});
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF2A235F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8D70E8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white, size: 11),
          const SizedBox(width: 2),
          Text(
            '$minutes:$seconds',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFC83D), Color(0xFFFF7A32)],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white, width: 1.5),
      boxShadow: const [BoxShadow(color: Colors.black38, offset: Offset(0, 2))],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.map_rounded, color: Colors.white, size: 11),
        const SizedBox(width: 2),
        Text(
          'LVL $level',
          style: GoogleFonts.luckiestGuy(color: Colors.white, fontSize: 9),
        ),
      ],
    ),
  );
}

class _HudButton extends StatelessWidget {
  const _HudButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) => IconButton.filled(
    onPressed: onTap,
    style: IconButton.styleFrom(
      minimumSize: const Size.square(36),
      maximumSize: const Size.square(36),
      padding: const EdgeInsets.all(6),
      backgroundColor: active
          ? const Color(0xFF1CA96D)
          : const Color(0xFF294A9B),
      side: const BorderSide(color: Color(0xFF65D8FF), width: 1.5),
    ),
    icon: Icon(icon, color: Colors.white, size: 19),
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
  Widget build(BuildContext context) => ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon),
    label: Text(label, style: GoogleFonts.luckiestGuy()),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
    ),
  );
}

class _RaceResultOverlay extends StatelessWidget {
  const _RaceResultOverlay({
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
    final duration = Duration(milliseconds: room.winnerElapsedMs ?? 0);
    final time =
        '${duration.inMinutes.toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD9081238),
        child: Center(
          child: Container(
            width: 330,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF5DF),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: GameColors.brownDarkUi, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 24),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  won ? Icons.emoji_events_rounded : Icons.sports_score_rounded,
                  color: won ? const Color(0xFFFFB300) : Colors.deepPurple,
                  size: 42,
                ),
                Text(
                  won ? 'YOU WIN!' : 'YOU LOSE',
                  style: GoogleFonts.luckiestGuy(
                    color: won ? Colors.green : Colors.redAccent,
                    fontSize: 28,
                  ),
                ),
                Text(
                  room.raceEndKind == 'surrender'
                      ? 'MATCH ENDED BY SURRENDER'
                      : 'FINISH TIME  $time',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your stars: ${localGame.currentPoints.value}   •   '
                  'Opponent stars: $remoteStars',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                if (rematchOffered)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.handshake_rounded),
                      label: Text(
                        restartKind == 'retry'
                            ? 'ACCEPT RETRY LEVEL ${room.raceLevel}'
                            : 'ACCEPT LEVEL ${room.raceLevel + 1}',
                        style: GoogleFonts.luckiestGuy(),
                      ),
                    ),
                  )
                else if (rematchWaiting)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.hourglass_bottom_rounded),
                      label: Text(
                        restartKind == 'retry'
                            ? 'RETRY REQUEST SENT'
                            : 'CONTINUE REQUEST SENT',
                        style: GoogleFonts.luckiestGuy(),
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(Icons.replay_rounded),
                          label: Text(
                            'RETRY',
                            style: GoogleFonts.luckiestGuy(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onContinue,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            'LEVEL ${room.raceLevel + 1}',
                            style: GoogleFonts.luckiestGuy(),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onExit,
                    icon: const Icon(Icons.home_rounded),
                    label: Text(
                      'RETURN TO MODES',
                      style: GoogleFonts.luckiestGuy(),
                    ),
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

class _RaceAgreementOverlay extends StatelessWidget {
  const _RaceAgreementOverlay({
    required this.room,
    required this.userId,
    required this.coordinator,
  });

  final CoopRoom room;
  final String userId;
  final RaceGameCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    final requestedByMe = room.leaveRequestedBy == userId;
    final postgame = room.hasPostgameExitVote;
    final title = postgame
        ? 'RETURN TO MODES?'
        : room.hasLeaveVote
        ? 'LEAVE TOGETHER?'
        : 'RACE PAUSED';
    final message = postgame
        ? requestedByMe
              ? 'Waiting for your opponent to agree.'
              : 'Your opponent wants both players to return to Modes.'
        : room.hasLeaveVote
        ? requestedByMe
              ? 'Waiting for your opponent to agree.'
              : 'Your opponent wants to leave this race together.'
        : 'The race is paused for both players.';

    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xB8081238),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: GameColors.sandLightUi,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: GameColors.brownDarkUi, width: 4),
              boxShadow: const [
                BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 7)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    color: GameColors.orangeTextUi,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                if (room.isPaused)
                  FilledButton.icon(
                    onPressed: () => coordinator.setPaused(false),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      'RESUME FOR BOTH',
                      style: GoogleFonts.luckiestGuy(),
                    ),
                  )
                else if (!requestedByMe)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => postgame
                            ? coordinator.respondToPostgameExit(false)
                            : coordinator.respondToLeave(false),
                        child: const Text('STAY'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () => postgame
                            ? coordinator.respondToPostgameExit(true)
                            : coordinator.respondToLeave(true),
                        child: Text(postgame ? 'RETURN BOTH' : 'LEAVE BOTH'),
                      ),
                    ],
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
