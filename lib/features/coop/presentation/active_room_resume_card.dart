import 'package:balanco_game/core/theme/game_colors.dart';
import 'package:balanco_game/features/coop/domain/coop_room.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveRoomResumeCard extends StatelessWidget {
  const ActiveRoomResumeCard({
    super.key,
    required this.room,
    required this.busy,
    required this.onResume,
  });

  final CoopRoom room;
  final bool busy;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final mode = room.isRace ? 'RACE' : 'CO-OP';
    final status = switch (room.status) {
      'waiting' => 'WAITING FOR PLAYERS',
      'paused' => 'MATCH PAUSED',
      'leave_vote' => 'DECISION PENDING',
      _ => 'MATCH IN PROGRESS',
    };
    final accent = room.isRace
        ? const Color(0xFFFF8A3D)
        : const Color(0xFF2FC5F4);

    return Semantics(
      button: true,
      label: 'Resume $mode room ${room.code}',
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 11, 10, 11),
        decoration: BoxDecoration(
          color: GameColors.sandLightUi,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: GameColors.brownDarkUi, width: 3),
          boxShadow: const [
            BoxShadow(color: GameColors.brownDarkUi, offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                border: Border.all(color: GameColors.brownDarkUi, width: 2.5),
              ),
              child: Icon(
                room.isRace ? Icons.flag_rounded : Icons.people_alt_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$mode  •  ${room.code}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.luckiestGuy(
                      color: GameColors.brownDarkUi,
                      fontSize: 17,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '$status  •  ${room.members.length}/${room.isRace ? room.maxPlayers : 2} PLAYERS',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: busy ? null : onResume,
              icon: busy
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.play_arrow_rounded, size: 22),
              label: Text('RESUME', style: GoogleFonts.luckiestGuy()),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(
                    color: GameColors.brownDarkUi,
                    width: 2.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
