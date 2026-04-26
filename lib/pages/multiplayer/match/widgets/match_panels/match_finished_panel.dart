part of '../multiplayer_match_panels.dart';

class MatchFinishedPanel extends StatelessWidget {
  const MatchFinishedPanel({
    super.key,
    required this.palette,
    required this.room,
    required this.currentFirebaseUid,
  });

  final MultiplayerPalette palette;
  final MultiplayerRoom room;
  final String? currentFirebaseUid;

  @override
  Widget build(BuildContext context) {
    final ranking = room.ranking.isNotEmpty
        ? room.ranking
        : ([...room.participants]..sort((a, b) {
            final scoreCompare = b.score.compareTo(a.score);
            if (scoreCompare != 0) return scoreCompare;
            final correctCompare = b.correctAnswers.compareTo(a.correctAnswers);
            if (correctCompare != 0) return correctCompare;
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }));
    final winner = ranking.isEmpty ? null : ranking.first;
    final winnerTitle = winner == null
        ? 'Partida encerrada'
        : _isCurrentParticipant(winner, currentFirebaseUid)
        ? 'Você venceu!'
        : 'Vitória de ${winner.name}!';

    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: palette.secondary.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: palette.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      winnerTitle,
                      style: GoogleFonts.manrope(
                        color: palette.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${room.questionIds.length} rodada${room.questionIds.length == 1 ? '' : 's'} concluída${room.questionIds.length == 1 ? '' : 's'}',
                      style: GoogleFonts.inter(
                        color: palette.onSurfaceMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ranking final',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < ranking.length; i++) ...[
            _RankingTile(
              palette: palette,
              participant: ranking[i],
              position: i + 1,
              currentFirebaseUid: currentFirebaseUid,
            ),
            if (i < ranking.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

String _participantDisplayName(
  MultiplayerParticipant participant,
  String? currentFirebaseUid,
) {
  if (_isCurrentParticipant(participant, currentFirebaseUid)) {
    return 'Você';
  }

  return participant.name;
}

bool _isCurrentParticipant(
  MultiplayerParticipant participant,
  String? currentFirebaseUid,
) {
  final normalizedUid = currentFirebaseUid?.trim();
  return normalizedUid != null &&
      normalizedUid.isNotEmpty &&
      participant.firebaseUid == normalizedUid;
}

class _RankingTile extends StatelessWidget {
  const _RankingTile({
    required this.palette,
    required this.participant,
    required this.position,
    required this.currentFirebaseUid,
  });

  final MultiplayerPalette palette;
  final MultiplayerParticipant participant;
  final int position;
  final String? currentFirebaseUid;

  @override
  Widget build(BuildContext context) {
    final isTopThree = position <= 3;
    final participantLabel = _participantDisplayName(
      participant,
      currentFirebaseUid,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: isTopThree
            ? palette.primary.withValues(alpha: 0.12)
            : palette.surfaceContainerHigh.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTopThree
              ? palette.primary.withValues(alpha: 0.24)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isTopThree
                  ? palette.secondary.withValues(alpha: 0.18)
                  : palette.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '#$position',
                style: GoogleFonts.plusJakartaSans(
                  color: isTopThree
                      ? palette.secondary
                      : palette.onSurfaceMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participantLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${participant.correctAnswers} acerto${participant.correctAnswers == 1 ? '' : 's'}',
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${participant.score} pts',
            style: GoogleFonts.plusJakartaSans(
              color: palette.primary,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
