import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/application/coop_game_coordinator.dart';
import 'package:balanco_game/features/coop/application/voice_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoopGameplayHeader extends StatelessWidget {
  const CoopGameplayHeader({
    super.key,
    required this.coordinator,
    required this.voice,
  });

  final CoopGameCoordinator coordinator;
  final VoiceChatController voice;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 100,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          left: 16,
          top: 12,
          child: _HeaderButton(
            icon: Icons.logout_rounded,
            label: 'LEAVE',
            color: Colors.redAccent,
            onTap: coordinator.requestLeave,
          ),
        ),
        Positioned(
          top: 12,
          child: ValueListenableBuilder(
            valueListenable: coordinator.room,
            builder: (_, room, _) => ValueListenableBuilder<int>(
              valueListenable: coordinator.game.currentScore,
              builder: (_, score, _) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: GameColors.sandLightUi,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: GameColors.brownDarkUi, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: GameColors.brownDarkUi,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'LEVEL ${room.raceLevel}',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 22,
                        color: GameColors.deepPurple,
                      ),
                    ),
                    Text(
                      '$score PTS',
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 11,
                        color: GameColors.orangeTextUi,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        coordinator.realtime.connected,
                        coordinator.syncHealthy,
                      ]),
                      builder: (_, _) {
                        final live = coordinator.realtime.connected.value;
                        final healthy = coordinator.syncHealthy.value;
                        return Text(
                          live && healthy ? 'LIVE SYNC' : 'SYNCING...',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: live && healthy ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          top: 8,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              voice.muted,
              voice.connected,
              voice.error,
            ]),
            builder: (_, _) {
              final muted = voice.muted.value;
              final hasError = voice.error.value != null;
              final connected = voice.connected.value;
              return _HeaderButton(
                icon: hasError
                    ? Icons.mic_off_rounded
                    : connected
                    ? (muted ? Icons.mic_off_rounded : Icons.mic_rounded)
                    : Icons.sync_rounded,
                label: hasError
                    ? 'MIC ERROR'
                    : connected
                    ? (muted ? 'UNMUTE' : 'MUTE')
                    : 'CONNECTING',
                color: hasError
                    ? Colors.red
                    : connected
                    ? (muted ? Colors.orange : Colors.green)
                    : Colors.blueGrey,
                onTap: voice.toggleMute,
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: GameColors.brownDarkUi, width: 2.5),
            boxShadow: const [
              BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 3)),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 25),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.luckiestGuy(
            fontSize: 10,
            color: GameColors.brownDarkUi,
          ),
        ),
      ],
    ),
  );
}
