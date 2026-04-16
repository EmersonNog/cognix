import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/multiplayer/multiplayer_api.dart';
import 'multiplayer_lobby_widgets.dart';
import 'multiplayer_palette.dart';

class MultiplayerCreateParticipantsSection extends StatelessWidget {
  const MultiplayerCreateParticipantsSection({
    super.key,
    required this.participants,
    required this.maxParticipants,
    required this.palette,
    required this.removingParticipantIds,
    required this.onRemove,
  });

  final List<MultiplayerParticipant> participants;
  final int maxParticipants;
  final MultiplayerPalette palette;
  final Set<int> removingParticipantIds;
  final ValueChanged<MultiplayerParticipant> onRemove;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Participantes',
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${participants.length}/$maxParticipants',
                style: GoogleFonts.plusJakartaSans(
                  color: palette.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final participant in participants) ...[
            MultiplayerParticipantTile(
              participant: participant,
              palette: palette,
              canRemove:
                  !participant.isHost &&
                  !removingParticipantIds.contains(participant.id),
              onRemove: () => onRemove(participant),
            ),
            if (participant != participants.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class MultiplayerLoadingPanel extends StatelessWidget {
  const MultiplayerLoadingPanel({
    super.key,
    required this.palette,
    required this.message,
  });

  final MultiplayerPalette palette;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      child: Row(
        children: [
          CircularProgressIndicator(color: palette.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                color: palette.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiplayerErrorPanel extends StatelessWidget {
  const MultiplayerErrorPanel({
    super.key,
    required this.palette,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final MultiplayerPalette palette;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: GoogleFonts.inter(
              color: palette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
