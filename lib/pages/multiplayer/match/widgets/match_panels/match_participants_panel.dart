part of '../multiplayer_match_panels.dart';

class MatchParticipantsPanel extends StatelessWidget {
  const MatchParticipantsPanel({
    super.key,
    required this.palette,
    required this.room,
  });

  final MultiplayerPalette palette;
  final MultiplayerRoom room;

  @override
  Widget build(BuildContext context) {
    final participants = room.participants;

    return MultiplayerPanel(
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jogadores na partida',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (final participant in participants.take(4)) ...[
            MultiplayerParticipantTile(
              participant: participant,
              palette: palette,
            ),
            const SizedBox(height: 8),
          ],
          if (participants.length > 4)
            Text(
              '+${participants.length - 4} jogador${participants.length - 4 == 1 ? '' : 'es'}',
              style: GoogleFonts.inter(
                color: palette.onSurfaceMuted,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
