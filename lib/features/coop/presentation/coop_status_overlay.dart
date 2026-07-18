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
      final isExitRequester = room.leaveRequestedBy == coordinator.userId;
      final isRestartRequester = room.rematchRequestedBy == coordinator.userId;
      final hasRestartVote = room.raceRestartKind != null;
      final title = room.hasPostgameExitVote
          ? 'RETURN TO MODES?'
          : hasRestartVote
          ? room.raceRestartKind == 'continue'
                ? 'NEXT LEVEL TOGETHER?'
                : 'RETRY TOGETHER?'
          : room.isCoopRunComplete
          ? 'CO-OP RUN COMPLETE!'
          : room.isCoopLevelComplete
          ? 'LEVEL ${room.raceLevel} COMPLETE!'
          : room.isCoopGameOver
          ? 'GAME OVER'
          : room.isEnded
          ? 'CO-OP COMPLETE'
          : room.hasLeaveVote
          ? 'LEAVE TOGETHER?'
          : 'GAME PAUSED';
      final message = room.hasPostgameExitVote
          ? (isExitRequester
                ? 'Waiting for your partner to agree...'
                : 'Your partner wants to return to Modes. Leave together?')
          : hasRestartVote
          ? (isRestartRequester
                ? 'Waiting for your partner to agree...'
                : room.raceRestartKind == 'continue'
                ? 'Your partner is ready for Level ${room.raceLevel + 1}.'
                : 'Your partner wants to retry Level ${room.raceLevel}.')
          : room.isCoopRunComplete
          ? 'You completed Levels ${room.raceStartLevel}-${room.raceEndLevel} together!\nShared score: ${room.score}'
          : room.isCoopLevelComplete
          ? 'Shared score: ${room.score}\nBoth players received this level\'s rewards.'
          : room.isCoopGameOver
          ? 'The shared attempt ended. Agree together to retry Level ${room.raceLevel}.'
          : room.isEnded
          ? room.score > 0
                ? 'Shared score: ${room.score}\nRewards were added to both players.'
                : 'The run ended by agreement. Unfinished rewards were not added.'
          : room.hasLeaveVote
          ? (isExitRequester
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
                if (room.hasPostgameExitVote && !isExitRequester)
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
                else if (hasRestartVote)
                  ElevatedButton.icon(
                    onPressed: isRestartRequester
                        ? null
                        : room.raceRestartKind == 'continue'
                        ? coordinator.continueTogether
                        : coordinator.retryTogether,
                    icon: Icon(
                      room.raceRestartKind == 'continue'
                          ? Icons.arrow_forward_rounded
                          : Icons.refresh_rounded,
                    ),
                    label: Text(
                      isRestartRequester
                          ? 'WAITING FOR PARTNER'
                          : room.raceRestartKind == 'continue'
                          ? 'AGREE: NEXT LEVEL'
                          : 'AGREE: RETRY',
                      style: GoogleFonts.luckiestGuy(),
                    ),
                  )
                else if (room.isEnded && !room.hasPostgameExitVote)
                  Column(
                    children: [
                      if (room.hasMoreCoopLevels && room.isCoopLevelComplete)
                        ElevatedButton.icon(
                          onPressed: coordinator.continueTogether,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            'CONTINUE TO LEVEL ${room.raceLevel + 1}',
                            style: GoogleFonts.luckiestGuy(),
                          ),
                        )
                      else if (room.isCoopGameOver)
                        ElevatedButton.icon(
                          onPressed: coordinator.retryTogether,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            'RETRY LEVEL ${room.raceLevel}',
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
                else if (room.hasLeaveVote && !isExitRequester)
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
