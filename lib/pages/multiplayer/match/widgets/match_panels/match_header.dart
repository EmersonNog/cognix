part of '../multiplayer_match_panels.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({
    super.key,
    required this.palette,
    required this.room,
    required this.questionIndex,
    required this.totalQuestions,
    required this.remainingSeconds,
    required this.score,
  });

  final MultiplayerPalette palette;
  final MultiplayerRoom? room;
  final int questionIndex;
  final int totalQuestions;
  final int remainingSeconds;
  final int score;

  @override
  Widget build(BuildContext context) {
    final currentRoom = room;
    final participantCount = currentRoom?.participantCount ?? 0;
    final roundLabel = totalQuestions == 0
        ? 'Carregando questões'
        : 'Rodada ${questionIndex + 1} de $totalQuestions';

    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roundLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: palette.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Desafio da rodada',
                      style: GoogleFonts.manrope(
                        color: palette.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              _MatchTimerBadge(
                palette: palette,
                remainingSeconds: remainingSeconds,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MatchHudChip(
                palette: palette,
                icon: Icons.groups_2_rounded,
                label: participantCount == 0
                    ? 'Jogadores'
                    : '$participantCount jogador${participantCount == 1 ? '' : 'es'}',
              ),
              const SizedBox(width: 8),
              _MatchHudChip(
                palette: palette,
                icon: Icons.leaderboard_rounded,
                label: '$score pts',
              ),
              if (currentRoom != null) ...[
                const SizedBox(width: 8),
                _MatchHudChip(
                  palette: palette,
                  icon: Icons.tag_rounded,
                  label: currentRoom.pin,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MatchTimerBadge extends StatelessWidget {
  const _MatchTimerBadge({
    required this.palette,
    required this.remainingSeconds,
  });

  final MultiplayerPalette palette;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final isEnding = remainingSeconds <= 10;
    final color = isEnding ? palette.secondary : palette.primary;

    return Container(
      width: 78,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Column(
        children: [
          Icon(Icons.timer_rounded, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            '${remainingSeconds}s',
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchHudChip extends StatelessWidget {
  const _MatchHudChip({
    required this.palette,
    required this.icon,
    required this.label,
  });

  final MultiplayerPalette palette;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: palette.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: palette.onSurfaceMuted, size: 15),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: palette.onSurface,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
