part of '../room_widgets.dart';

class MultiplayerParticipantTile extends StatelessWidget {
  const MultiplayerParticipantTile({
    super.key,
    required this.participant,
    required this.palette,
    this.canRemove = false,
    this.onRemove,
  });

  final MultiplayerParticipant participant;
  final MultiplayerPalette palette;
  final bool canRemove;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final subtitle = participant.score > 0
        ? '${participant.score} pts'
        : participant.answeredCurrentQuestion
        ? 'Resposta enviada'
        : participant.isHost
        ? 'Criador da sala'
        : 'Participante';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: participant.isHost
                ? palette.primary.withValues(alpha: 0.18)
                : palette.secondary.withValues(alpha: 0.16),
            child: Text(
              participant.name.trim().isEmpty
                  ? '?'
                  : participant.name.trim()[0].toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color: participant.isHost ? palette.primary : palette.secondary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (canRemove)
            IconButton(
              tooltip: 'Remover participante',
              onPressed: onRemove,
              icon: Icon(
                Icons.close_rounded,
                color: palette.onSurfaceMuted,
                size: 20,
              ),
            )
          else
            Icon(
              participant.answeredCurrentQuestion
                  ? Icons.task_alt_rounded
                  : participant.isHost
                  ? Icons.workspace_premium_rounded
                  : Icons.check_circle_rounded,
              color: participant.answeredCurrentQuestion
                  ? palette.primary
                  : participant.isHost
                  ? palette.primary
                  : palette.onSurfaceMuted,
              size: 20,
            ),
        ],
      ),
    );
  }
}
