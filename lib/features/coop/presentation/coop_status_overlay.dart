import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/application/coop_game_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoopStatusOverlay extends StatelessWidget {
  const CoopStatusOverlay({super.key, required this.coordinator});
  final CoopGameCoordinator coordinator;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: coordinator.room,
    builder: (context, room, _) {
      if (room.isPlaying || room.endedByAgreement) {
        return const SizedBox.shrink();
      }
      final isRequester = room.leaveRequestedBy == coordinator.userId;
      final title = room.hasPostgameExitVote
          ? 'RETURN TO MODES?'
          : room.isEnded
          ? 'CO-OP COMPLETE'
          : room.hasLeaveVote
          ? 'LEAVE TOGETHER?'
          : 'GAME PAUSED';
      final message = room.hasPostgameExitVote
          ? (isRequester
                ? 'Waiting for your partner to agree...'
                : 'Your partner wants to return to Modes. Leave together?')
          : room.isEnded
          ? room.score > 0
                ? 'Shared score: ${room.score}\nRewards were added to both players.'
                : 'The run ended by agreement. Unfinished rewards were not added.'
          : room.hasLeaveVote
          ? (isRequester
                ? 'Waiting for your partner to decide…'
                : 'Your partner wants to leave. End the run for both players?')
          : 'Either player can resume when you are both ready.';
      return Positioned.fill(
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          child: Container(
            width: 335,
            padding: const EdgeInsets.all(24),
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
                    fontSize: 28,
                    color: GameColors.orangeTextUi,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),
                if (room.hasPostgameExitVote && !isRequester)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            coordinator.respondToPostgameExit(false),
                        child: const Text('STAY'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            coordinator.respondToPostgameExit(true),
                        child: const Text('RETURN BOTH'),
                      ),
                    ],
                  )
                else if (room.isEnded && !room.hasPostgameExitVote)
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: coordinator.retryTogether,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(
                          'RETRY TOGETHER',
                          style: GoogleFonts.luckiestGuy(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: coordinator.requestPostgameExit,
                        child: Text(
                          'RETURN TO MODES',
                          style: GoogleFonts.luckiestGuy(),
                        ),
                      ),
                    ],
                  )
                else if (room.isPaused)
                  ElevatedButton.icon(
                    onPressed: () => coordinator.setPaused(false),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      'RESUME FOR BOTH',
                      style: GoogleFonts.luckiestGuy(),
                    ),
                  )
                else if (room.hasLeaveVote && !isRequester)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => coordinator.respondToLeave(false),
                        child: const Text('STAY'),
                      ),
                      ElevatedButton(
                        onPressed: () => coordinator.respondToLeave(true),
                        child: const Text('LEAVE BOTH'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
