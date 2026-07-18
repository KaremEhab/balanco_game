import 'dart:collection';
import 'dart:math' as math;

import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:balanco_game/features/game/components/game_area/shield_icon_painter.dart';
import 'package:balanco_game/features/game/game_area.dart';
import 'package:balanco_game/features/race/application/race_game_coordinator.dart';
import 'package:balanco_game/features/race/application/race_remote_snapshot_interpolator.dart';
import 'package:balanco_game/features/settings/widgets/avatar_shapes.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/core/widgets/level_gradient_background.dart';

class RacePortraitMatchView extends StatelessWidget {
  const RacePortraitMatchView({
    super.key,
    required this.room,
    required this.userId,
    required this.localGame,
    required this.remoteGame,
    required this.coordinator,
    required this.voice,
    required this.onLeave,
    required this.onPause,
    required this.onSettings,
    required this.onLocalProfile,
    required this.onPlayerProfile,
  });

  final CoopRoom room;
  final String userId;
  final BalancoGame localGame;
  final BalancoGame remoteGame;
  final RaceGameCoordinator coordinator;
  final VoiceChatController voice;
  final VoidCallback onLeave;
  final VoidCallback onPause;
  final VoidCallback onSettings;
  final VoidCallback onLocalProfile;
  final ValueChanged<CoopMember> onPlayerProfile;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      final scale = math.min(width / 430, height / 932).clamp(0.78, 1.18);
      final horizontal = math.max(14.0, width * 0.048);
      final boardTop = (height * 0.13).clamp(108.0, 124.0);
      const boardBottom = 5.0;
      const joystickBottom = 5.0;
      final joystickHeight = 148.0 * scale;
      final raceBarInset =
          joystickBottom + joystickHeight + 5 + 12 * scale - boardBottom;
      localGame.configureRaceBarBottomInset(raceBarInset);
      remoteGame.configureRaceBarBottomInset(raceBarInset);
      final localMember = room.memberFor(userId);

      return Stack(
        children: [
          LevelGradientBackground(level: room.raceLevel),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: horizontal,
                  right: horizontal,
                  top: boardTop,
                  bottom: boardBottom,
                  child: _SharedRaceBoard(
                    localGame: localGame,
                    remoteGame: remoteGame,
                    room: room,
                    userId: userId,
                    coordinator: coordinator,
                    showLabels: coordinator.showBoardLabels,
                    level: room.raceLevel,
                  ),
                ),
                Positioned(
                  left: horizontal,
                  right: horizontal,
                  top: 0,
                  height: boardTop - 4,
                  child: _RaceHeader(
                    room: room,
                    localMember: localMember,
                    localGame: localGame,
                    coordinator: coordinator,
                    voice: voice,
                    scale: scale,
                    onLeave: onLeave,
                    onSettings: onSettings,
                    onLocalProfile: onLocalProfile,
                    onPlayerProfile: onPlayerProfile,
                  ),
                ),
                Positioned(
                  left: math.max(8, horizontal + 40),
                  bottom: joystickBottom,
                  child: _VerticalRaceControl(
                    scale: scale,
                    onChanged: (value) => localGame.leftJoystickValue = value,
                  ),
                ),
                Positioned(
                  right: math.max(8, horizontal + 40),
                  bottom: joystickBottom,
                  child: _VerticalRaceControl(
                    scale: scale,
                    onChanged: (value) => localGame.rightJoystickValue = value,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: math.max(8, height * 0.012),
                  child: _HelperDock(game: localGame, scale: scale, onPause: onPause),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}



class _RaceHeader extends StatelessWidget {
  const _RaceHeader({
    required this.room,
    required this.localMember,
    required this.localGame,
    required this.coordinator,
    required this.voice,
    required this.scale,
    required this.onLeave,
    required this.onSettings,
    required this.onLocalProfile,
    required this.onPlayerProfile,
  });

  final CoopRoom room;
  final CoopMember localMember;
  final BalancoGame localGame;
  final RaceGameCoordinator coordinator;
  final VoiceChatController voice;
  final double scale;
  final VoidCallback onLeave;
  final VoidCallback onSettings;
  final VoidCallback onLocalProfile;
  final ValueChanged<CoopMember> onPlayerProfile;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 62 * scale,
        child: Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: localGame.currentLives,
                builder: (_, hearts, _) => ValueListenableBuilder<String?>(
                  valueListenable: voice.activeSpeakerId,
                  builder: (_, speakerId, _) {
                    final isLocalSpeaking =
                        speakerId == voice.userId ||
                        speakerId == localMember.userId;
                    return _PlayerIdentity(
                      member: localMember,
                      hearts: hearts,
                      accent: isLocalSpeaking
                          ? const Color(0xFF69F5A9)
                          : const Color(0xFF35DFFF),
                      avatarFirst: true,
                      onProfileTap: onLocalProfile,
                      eyebrow: isLocalSpeaking ? 'YOU · TALKING' : 'YOU',
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6 * scale),
              child: ValueListenableBuilder<Duration>(
                valueListenable: coordinator.elapsed,
                builder: (_, elapsed, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TimerPill(
                      elapsed: elapsed,
                      maxTimerSeconds: localGame.maxLevelTimer.toInt(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _SpeakingPlayerIdentity(
                room: room,
                localMember: localMember,
                coordinator: coordinator,
                voice: voice,
                onPlayerProfile: onPlayerProfile,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: [
            _CircleAction(
              icon: Icons.logout_rounded,
              tooltip: 'Leave together',
              onTap: onLeave,
              compact: true,
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 13 * scale,
                vertical: 5 * scale,
              ),
              decoration: BoxDecoration(
                color: const Color(0xD61A2D69),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF69DEFF), width: 1.5),
              ),
              child: Text(
                '${room.members.map((member) => member.sessionWins).join('  ·  ')}'
                '   LVL ${room.raceLevel}',
                style: GoogleFonts.luckiestGuy(
                  color: Colors.white,
                  fontSize: 15 * scale,
                  letterSpacing: 0.5,
                  shadows: const [
                    Shadow(color: Colors.black87, offset: Offset(1.5, 2.5)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: Listenable.merge([
                voice.muted,
                voice.connected,
                voice.error,
              ]),
              builder: (_, _) => _CircleAction(
                icon: voice.muted.value
                    ? Icons.mic_off_rounded
                    : Icons.mic_rounded,
                tooltip: voice.muted.value
                    ? 'Unmute microphone'
                    : 'Mute microphone',
                onTap: () => voice.toggleMute(),
                active: !voice.muted.value,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _PlayerIdentity extends StatelessWidget {
  const _PlayerIdentity({
    required this.member,
    required this.hearts,
    required this.accent,
    required this.avatarFirst,
    required this.onProfileTap,
    this.eyebrow,
  });

  final CoopMember member;
  final int hearts;
  final Color accent;
  final bool avatarFirst;
  final VoidCallback onProfileTap;
  final String? eyebrow;

  AvatarShape get _shape => AvatarShape.values.firstWhere(
    (value) => value.name == member.avatarShape,
    orElse: () => AvatarShape.circle,
  );

  @override
  Widget build(BuildContext context) {
    final avatar = Tooltip(
      message: 'View ${member.displayName} profile',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onProfileTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 2),
          ),
          child: ProfileAvatarWidget(
            shape: _shape,
            size: 42,
            imageUrl: member.resolvedAvatarUrl,
          ),
        ),
      ),
    );
    final details = Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: avatarFirst
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            eyebrow ?? (avatarFirst ? 'YOU' : 'OPPONENT'),
            maxLines: 1,
            style: TextStyle(
              color: accent,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            member.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          RaceMemberVitals(member: member, hearts: hearts),
        ],
      ),
    );
    return Row(
      mainAxisAlignment: avatarFirst
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: avatarFirst
          ? [avatar, const SizedBox(width: 5), details]
          : [details, const SizedBox(width: 5), avatar],
    );
  }
}

class _SpeakingPlayerIdentity extends StatelessWidget {
  const _SpeakingPlayerIdentity({
    required this.room,
    required this.localMember,
    required this.coordinator,
    required this.voice,
    required this.onPlayerProfile,
  });

  final CoopRoom room;
  final CoopMember localMember;
  final RaceGameCoordinator coordinator;
  final VoiceChatController voice;
  final ValueChanged<CoopMember> onPlayerProfile;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
    valueListenable: voice.activeSpeakerId,
    builder: (_, speakerId, _) {
      final speaker = selectRaceHeaderOpponent(
        members: room.members,
        localMember: localMember,
        voiceUserId: voice.userId,
        activeSpeakerId: speakerId,
      );
      if (speaker == null) return const SizedBox.shrink();
      final isSpeaking = !speaker.hasLeft && speakerId == speaker.userId;
      return ValueListenableBuilder<Map<String, int>>(
        valueListenable: coordinator.remoteHeartsByUser,
        builder: (_, hearts, _) => _PlayerIdentity(
          member: speaker,
          hearts: speaker.userId == localMember.userId
              ? 3
              : hearts[speaker.userId] ?? 3,
          accent: speaker.hasLeft
              ? const Color(0xFFFF7A7A)
              : isSpeaking
              ? const Color(0xFF69F5A9)
              : const Color(0xFFAEB4C1),
          avatarFirst: false,
          onProfileTap: () => onPlayerProfile(speaker),
          eyebrow: speaker.hasLeft
              ? 'LEFT RACE'
              : isSpeaking
              ? 'TALKING NOW'
              : 'RACER',
        ),
      );
    },
  );
}

/// Selects only a remote racer for the right-hand header slot.
///
/// WebRTC reports the local user's id while sampling outbound audio. Keeping
/// the local auth id and player code out of this candidate list prevents the
/// local profile from ever being duplicated on the opponent side, including
/// while a room update briefly contains a stale duplicate member row.
@visibleForTesting
CoopMember? selectRaceHeaderOpponent({
  required Iterable<CoopMember> members,
  required CoopMember localMember,
  required String voiceUserId,
  required String? activeSpeakerId,
}) {
  final opponents = members
      .where(
        (member) =>
            member.userId != localMember.userId &&
            member.userId != voiceUserId &&
            member.playerCode != localMember.playerCode,
      )
      .toList(growable: false);
  if (opponents.isEmpty) return null;

  final activeSpeaker = opponents
      .where((member) => member.userId == activeSpeakerId && !member.hasLeft)
      .firstOrNull;
  final departed = opponents.where((member) => member.hasLeft).firstOrNull;
  final activeOpponent = opponents
      .where((member) => !member.hasLeft)
      .firstOrNull;
  return activeSpeaker ?? departed ?? activeOpponent;
}

class RaceMemberVitals extends StatelessWidget {
  const RaceMemberVitals({
    super.key,
    required this.member,
    required this.hearts,
  });

  final CoopMember member;
  final int hearts;

  @override
  Widget build(BuildContext context) {
    if (!member.hasLeft) return _HeartsRow(count: hearts);
    return Container(
      key: ValueKey('race-player-left-${member.userId}'),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x66FF5368),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF7A8A), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.logout_rounded, color: Colors.white, size: 10),
          SizedBox(width: 3),
          Text(
            'LEFT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartsRow extends StatelessWidget {
  const _HeartsRow({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      3,
      (index) => Icon(
        index < count.clamp(0, 3)
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded,
        color: const Color(0xFFFF5368),
        size: 12,
      ),
    ),
  );
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.elapsed, required this.maxTimerSeconds});
  final Duration elapsed;
  final int maxTimerSeconds;

  @override
  Widget build(BuildContext context) {
    final remainingSeconds = (maxTimerSeconds - elapsed.inSeconds).clamp(
      0,
      9999,
    );
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    final isCritical = remainingSeconds <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: isCritical ? const Color(0xE6622323) : const Color(0xE62B2362),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCritical ? const Color(0xFFF48181) : const Color(0xFF9B81F4),
          width: 1.4,
        ),
      ),
      child: Text(
        '$minutes:$seconds',
        style: GoogleFonts.luckiestGuy(
          color: isCritical ? const Color(0xFFFF5353) : Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SharedRaceBoard extends StatefulWidget {
  const _SharedRaceBoard({
    required this.localGame,
    required this.remoteGame,
    required this.room,
    required this.userId,
    required this.coordinator,
    required this.showLabels,
    required this.level,
  });

  final BalancoGame localGame;
  final BalancoGame remoteGame;
  final CoopRoom room;
  final String userId;
  final RaceGameCoordinator coordinator;
  final ValueListenable<bool> showLabels;
  final int level;

  @override
  State<_SharedRaceBoard> createState() => _SharedRaceBoardState();
}

class _SharedRaceBoardState extends State<_SharedRaceBoard> {
  late _RemoteGhostsComponent _ghostComponent;

  @override
  void initState() {
    super.initState();
    _ghostComponent = _createComponent();
    _attachComponent();
  }

  void _attachComponent() =>
      widget.localGame.levelContainer.add(_ghostComponent);

  _RemoteGhostsComponent _createComponent() => _RemoteGhostsComponent(
    remoteGame: widget.remoteGame,
    room: widget.room,
    userId: widget.userId,
    coordinator: widget.coordinator,
    showLabels: widget.showLabels,
  );

  @override
  void didUpdateWidget(covariant _SharedRaceBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room != widget.room ||
        oldWidget.localGame != widget.localGame) {
      _ghostComponent.removeFromParent();
      _ghostComponent = _createComponent();
      _attachComponent();
    }
  }

  @override
  void dispose() {
    _ghostComponent.removeFromParent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = LevelPalette.forLevel(widget.level);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: palette.border),
        borderRadius: BorderRadius.circular(33),
        boxShadow: const [
          BoxShadow(color: Color(0x99188EFF), blurRadius: 22, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: palette.board,
                      stops: const [0, 0.52, 1],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0,
                    child: GameWidget(game: widget.remoteGame),
                  ),
                ),
              ),
              Positioned.fill(child: GameWidget(game: widget.localGame)),
              _CountdownLabel(game: widget.localGame),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoteGhostsComponent extends PositionComponent
    with HasGameReference<BalancoGame> {
  _RemoteGhostsComponent({
    required this.remoteGame,
    required this.room,
    required this.userId,
    required this.coordinator,
    required this.showLabels,
  }) : super(priority: 8);

  final BalancoGame remoteGame;
  final CoopRoom room;
  final String userId;
  final RaceGameCoordinator coordinator;
  final ValueListenable<bool> showLabels;
  final Map<String, Queue<Offset>> _trails = {};

  @override
  void render(Canvas canvas) {
    if (!game.isLayoutReady) return;
    if (game.size.x <= 0 || game.size.y <= 0) return;
    final startingState = RaceRemoteRenderState(
      worldWidth: game.size.x,
      worldHeight: game.size.y,
      levelHeight: game.levelHeight,
      barBottomY: game.raceBarBottomY,
      leftY: game.leftY,
      rightY: game.rightY,
      shieldTime: 0,
      balls: game.activeBalls
          .map(
            (ball) => RaceRemoteBallRenderState(
              x: ball.pos2D.x,
              y: ball.pos2D.y,
              scale: ball.scale,
              dead: ball.isDead,
            ),
          )
          .toList(growable: false),
    );
    Offset worldPoint(double x, double y) => Offset(x, y);
    const remoteColors = [
      Color(0xFFFFA43A),
      Color(0xFFB879FF),
      Color(0xFF67E28B),
    ];
    final opponents = room.opponentsOf(userId);
    for (var index = 0; index < opponents.length; index++) {
      final member = opponents[index];
      final color = member.hasLeft
          ? const Color(0xFF9098AA)
          : remoteColors[index % remoteColors.length];
      final interpolator = coordinator.remoteInterpolators[member.userId];
      final RaceRemoteRenderState? remote = game.countdownTimer > 0
          ? startingState
          : interpolator?.sample() ?? (member.hasLeft ? startingState : null);
      if (remote == null) {
        _trails[member.userId]?.clear();
        continue;
      }
      Offset remoteWorldPoint(double x, double y) => worldPoint(
        remote.localX(x, game.size.x),
        remote.localY(y, game.size.y, localBarBottomY: game.raceBarBottomY),
      );
      final left = remoteWorldPoint(remoteGame.barPadding, remote.leftY);
      final right = remoteWorldPoint(
        remote.worldWidth - remoteGame.barPadding,
        remote.rightY,
      );
      _paintGhostBar(canvas, left, right, 1.0, color);

      Offset? ballCenter;
      for (final ball in remote.balls) {
        if (ball.dead || (ball.x == 0 && ball.y == 0)) continue;
        final center = remoteWorldPoint(ball.x, ball.y);
        // Ghosts share levelContainer with the local board, so use the same
        // manual scrolling offset that moves the authored level.
        final cameraY = game.cameraOffsetY;
        if (center.dy < cameraY - 100 ||
            center.dy > cameraY + game.size.y + 100) {
          continue;
        }
        ballCenter ??= center;
        _paintGhostBall(canvas, center, ball.scale, color);
      }
      final trail = _trails.putIfAbsent(member.userId, Queue<Offset>.new);
      if (ballCenter == null) {
        trail.clear();
        continue;
      }
      if (trail.isEmpty || (trail.last - ballCenter).distance > 1.6) {
        trail.add(ballCenter);
        while (trail.length > 10) {
          trail.removeFirst();
        }
      }
      _paintTrail(canvas, trail, color);
      if (remote.shieldTime > 0) {
        canvas.drawCircle(
          ballCenter,
          game.ballRadius + 8,
          Paint()
            ..color = color.withValues(alpha: 0.55)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
      _paintLabel(
        canvas,
        member.hasLeft ? '${member.displayName} · LEFT' : member.displayName,
        ballCenter,
        color,
      );
      if (member.hasLeft) {
        _paintDepartedBadge(canvas, ballCenter, member.displayName);
      }
    }

    if (game.activeBalls.isNotEmpty) {
      final ball = game.activeBalls.first;
      _paintLabel(
        canvas,
        'YOU',
        worldPoint(ball.pos2D.x, ball.pos2D.y),
        const Color(0xFF53E8FF),
      );
    }
  }

  void _paintGhostBar(
    Canvas canvas,
    Offset left,
    Offset right,
    double scaleY,
    Color accent,
  ) {
    final double barLength = (right - left).distance;
    final double angle = math.atan2(right.dy - left.dy, right.dx - left.dx);
    final double barHeight = 20.0;

    canvas.save();
    canvas.translate(left.dx, left.dy);
    canvas.rotate(angle);

    final bool isGlass = game.isInfinityMode;
    Rect fullRect = Rect.fromLTRB(0, -barHeight / 2, barLength, barHeight / 2);

    // Opponent Opacity
    const double opMultiplier = 0.55;

    // Drop shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4 * opMultiplier)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    canvas.save();
    canvas.rotate(-angle);
    canvas.translate(0, 12);
    canvas.rotate(angle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fullRect, const Radius.circular(10)),
      shadowPaint,
    );
    canvas.restore();

    canvas.drawRRect(
      RRect.fromRectAndRadius(fullRect, const Radius.circular(10)),
      Paint()
        ..color = accent.withValues(alpha: 0.62)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );

    if (isGlass) {
      RRect bodyRRect = RRect.fromRectAndRadius(
        fullRect,
        const Radius.circular(10),
      );
      final Paint glassPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.5 * opMultiplier),
            Colors.white.withValues(alpha: 0.1 * opMultiplier),
            Colors.white.withValues(alpha: 0.2 * opMultiplier),
          ],
        ).createShader(fullRect);
      canvas.drawRRect(bodyRRect, glassPaint);

      final Paint glassBorder = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.6 * opMultiplier);
      canvas.drawRRect(bodyRRect, glassBorder);

      Rect specRect = Rect.fromLTRB(
        5,
        -barHeight / 2 + 1,
        barLength - 5,
        -barHeight / 4,
      );
      final Paint specPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.46 * opMultiplier),
            Colors.transparent,
          ],
        ).createShader(specRect);
      canvas.drawRect(specRect, specPaint);

      Rect grooveRect = Rect.fromLTRB(15, -1.5, barLength - 15, 1.5);
      final Paint groovePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: opMultiplier),
            Colors.transparent,
          ],
        ).createShader(grooveRect)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawRRect(
        RRect.fromRectAndRadius(grooveRect, const Radius.circular(1.5)),
        groovePaint,
      );
    } else {
      RRect bodyRRect = RRect.fromRectAndRadius(
        fullRect,
        const Radius.circular(10),
      );
      final Paint metalPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(
              0xFF90A4AE,
            ).withValues(alpha: opMultiplier), // GameColors.blueGray300
            const Color(
              0xFF546E7A,
            ).withValues(alpha: opMultiplier), // GameColors.blueGray600
            const Color(0xFF546E7A).withValues(alpha: opMultiplier),
            const Color(
              0xFF263238,
            ).withValues(alpha: opMultiplier), // GameColors.blueGray900
          ],
        ).createShader(fullRect);
      canvas.drawRRect(bodyRRect, metalPaint);

      double capWidth = 20.0 * scaleY;
      Rect leftCap = Rect.fromLTRB(0, -barHeight / 2, capWidth, barHeight / 2);
      Rect rightCap = Rect.fromLTRB(
        barLength - capWidth,
        -barHeight / 2,
        barLength,
        barHeight / 2,
      );

      RRect leftCapRRect = RRect.fromRectAndCorners(
        leftCap,
        topLeft: const Radius.circular(10),
        bottomLeft: const Radius.circular(10),
        topRight: const Radius.circular(4),
        bottomRight: const Radius.circular(4),
      );
      RRect rightCapRRect = RRect.fromRectAndCorners(
        rightCap,
        topRight: const Radius.circular(10),
        bottomRight: const Radius.circular(10),
        topLeft: const Radius.circular(4),
        bottomLeft: const Radius.circular(4),
      );

      final Paint gunmetalPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF90A4AE).withValues(alpha: opMultiplier),
            const Color(0xFF546E7A).withValues(alpha: opMultiplier),
            const Color(0xFF263238).withValues(alpha: opMultiplier),
            Colors.black.withValues(alpha: opMultiplier),
          ],
        ).createShader(leftCap);
      canvas.drawRRect(leftCapRRect, gunmetalPaint);

      final Paint gunmetalPaintRight = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF90A4AE).withValues(alpha: opMultiplier),
            const Color(0xFF546E7A).withValues(alpha: opMultiplier),
            const Color(0xFF263238).withValues(alpha: opMultiplier),
            Colors.black.withValues(alpha: opMultiplier),
          ],
        ).createShader(rightCap);
      canvas.drawRRect(rightCapRRect, gunmetalPaintRight);

      final Paint separatorPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.6 * opMultiplier)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawLine(
        Offset(capWidth, -barHeight / 2),
        Offset(capWidth, barHeight / 2),
        separatorPaint,
      );
      canvas.drawLine(
        Offset(barLength - capWidth, -barHeight / 2),
        Offset(barLength - capWidth, barHeight / 2),
        separatorPaint,
      );

      // Grey groove
      Rect grooveRect = Rect.fromLTRB(
        capWidth + 12,
        -3.0,
        barLength - capWidth - 12,
        3.0,
      );
      final Paint groovePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF78909C).withValues(alpha: 0.6 * opMultiplier),
            const Color(0xFF78909C).withValues(alpha: opMultiplier),
            Colors.white.withValues(alpha: 0.7 * opMultiplier),
          ],
        ).createShader(grooveRect);
      canvas.drawRRect(
        RRect.fromRectAndRadius(grooveRect, const Radius.circular(3.0)),
        groovePaint,
      );

      Rect specRect = Rect.fromLTRB(
        capWidth,
        -barHeight / 2 + 1,
        barLength - capWidth,
        -barHeight / 4,
      );
      final Paint specPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.46 * opMultiplier),
            Colors.transparent,
          ],
        ).createShader(specRect);
      canvas.drawRect(specRect, specPaint);
    }

    canvas.restore();
  }

  void _paintGhostBall(
    Canvas canvas,
    Offset center,
    double ballScale,
    Color accent,
  ) {
    final radius = game.ballRadius * ballScale;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius + 5,
      Paint()
        ..color = const Color(0x28C7CBD4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    canvas.drawCircle(
      center,
      radius + 1,
      Paint()
        ..color = accent.withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.35),
          colors: [
            Color(0xB3FFFFFF),
            Color(0x8FD6DAE1),
            Color(0x7A949AA7),
            Color(0x66515866),
          ],
          stops: [0, 0.3, 0.7, 1],
        ).createShader(rect),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0x80ECEEF2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _paintTrail(Canvas canvas, Queue<Offset> trail, Color accent) {
    if (trail.length < 2) return;
    var index = 0;
    for (final point in trail) {
      final t = index / trail.length;
      canvas.drawCircle(
        point,
        1 + 3 * t,
        Paint()
          ..color = Color.lerp(
            Colors.transparent,
            accent,
            t,
          )!.withValues(alpha: 0.3),
      );
      index++;
    }
  }

  void _paintLabel(Canvas canvas, String text, Offset target, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final offset = Offset(target.dx - painter.width / 2, target.dy - 39);
    painter.paint(canvas, offset);
    final marker = Path()
      ..moveTo(target.dx - 4, target.dy - 20)
      ..lineTo(target.dx + 4, target.dy - 20)
      ..lineTo(target.dx, target.dy - 14)
      ..close();
    canvas.drawPath(marker, Paint()..color = color);
  }

  void _paintDepartedBadge(Canvas canvas, Offset target, String name) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(target.dx, target.dy + 38),
        width: 112,
        height: 28,
      ),
      const Radius.circular(14),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xE6273046));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFFAAB1C0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final painter = TextPainter(
      text: TextSpan(
        text: '↪  LEFT THE RACE',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(target.dx - painter.width / 2, target.dy + 31),
    );
  }
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
                fontSize: 58,
                shadows: const [
                  Shadow(color: Color(0xFF6544CF), blurRadius: 18),
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
  const _VerticalRaceControl({required this.scale, required this.onChanged});
  final double scale;
  final ValueChanged<double> onChanged;

  @override
  State<_VerticalRaceControl> createState() => _VerticalRaceControlState();
}

class _VerticalRaceControlState extends State<_VerticalRaceControl> {
  double _value = 0;
  double _dragStartY = 0;
  double _dragStartValue = 0;

  void _beginDrag(Offset local) {
    _dragStartY = local.dy;
    _dragStartValue = _value;
  }

  void _updateDrag(Offset local, double height, double knob) {
    final travel = math.max(1.0, (height - knob) / 2);
    final value = (_dragStartValue + (local.dy - _dragStartY) / travel).clamp(
      -1.0,
      1.0,
    );
    setState(() => _value = value);
    widget.onChanged(value);
  }

  void _release() {
    setState(() => _value = 0);
    widget.onChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    final height = 148.0 * widget.scale;
    final width = 62.0 * widget.scale;
    final knob = 54.0 * widget.scale;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (details) => _beginDrag(details.localPosition),
      onVerticalDragUpdate: (details) =>
          _updateDrag(details.localPosition, height, knob),
      onVerticalDragEnd: (_) => _release(),
      onVerticalDragCancel: _release,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0x66304F8F),
          borderRadius: BorderRadius.circular(width / 2),
          border: Border.all(color: const Color(0xCCFFFFFF), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0x88188EFF), blurRadius: 12),
          ],
        ),
        child: Align(
          alignment: Alignment(0, _value),
          child: Container(
            width: knob,
            height: knob,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xD8DCEEFF),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.unfold_more_rounded,
              color: Color(0xFF277FEA),
              size: 23,
            ),
          ),
        ),
      ),
    );
  }
}

class _HelperDock extends StatelessWidget {
  const _HelperDock({
    required this.game,
    required this.scale,
    required this.onPause,
  });

  final BalancoGame game;
  final double scale;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 8 * scale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xE615285E),
        borderRadius: BorderRadius.circular(19 * scale),
        border: Border.all(color: const Color(0xCCFFFFFF), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 13)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: game.isDarknessLevelNotifier,
                builder: (_, isDark, _) => ValueListenableBuilder<double>(
                  valueListenable: game.lightChargeTimerNotifier,
                  builder: (_, timer, _) => ValueListenableBuilder<int>(
                    valueListenable: game.lightChargesNotifier,
                    builder: (_, count, _) => _DockButton(
                      count: count,
                      enabled: isDark && count > 0 && timer <= 0,
                      active: isDark && timer > 0,
                      onTap: game.useLightCharge,
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: const Color(0xFFFDEB71),
                        size: 28 * scale,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8 * scale),
              ValueListenableBuilder<double>(
                valueListenable: game.shieldTimerNotifier,
                builder: (_, _, _) => ValueListenableBuilder<int>(
                  valueListenable: game.remainingShields,
                  builder: (_, count, _) => _DockButton(
                    count: count,
                    enabled: count > 0 && !game.isShieldActive,
                    active: game.isShieldActive,
                    onTap: game.activateShield,
                    child: CustomPaint(
                      size: Size.square(26 * scale),
                      painter: ShieldIconPainter(
                        color: const Color(0xFF35DFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6 * scale),
          _DockButton(
            key: const ValueKey('race_pause_button'),
            onTap: onPause,
            child: Icon(
              Icons.pause_rounded,
              color: const Color(0xFFA990FF),
              size: 29 * scale,
            ),
          ),
        ],
      ),
    ),
  );
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    super.key,
    required this.onTap,
    required this.child,
    this.count,
    this.enabled = true,
    this.active = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final int? count;
  final bool enabled;
  final bool active;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Opacity(
      opacity: enabled || active ? 1 : 0.48,
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF5945A5) : const Color(0xFF263A78),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xAAFFFFFF), width: 1.4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            child,
            if (count != null)
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE84D5B),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
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

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
    this.compact = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;
  final bool compact;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: IconButton.filled(
      onPressed: onTap,
      style: IconButton.styleFrom(
        minimumSize: Size.square(compact ? 36 : 45),
        maximumSize: Size.square(compact ? 36 : 45),
        backgroundColor: active
            ? const Color(0xFF159E71)
            : const Color(0xFF274B9D),
        side: const BorderSide(color: Color(0xFF62DCFF), width: 1.7),
      ),
      icon: Icon(icon, color: Colors.white, size: compact ? 19 : 23),
    ),
  );
}
