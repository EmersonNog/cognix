import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/multiplayer/models.dart';
import '../../shared/widgets/palette.dart';
import '../../shared/widgets/room_widgets.dart';

class MultiplayerJoinedRoomPreview extends StatelessWidget {
  const MultiplayerJoinedRoomPreview({
    super.key,
    required this.room,
    required this.palette,
    required this.isLeaving,
    required this.wasRemoved,
    required this.onLeave,
  });

  final MultiplayerRoom room;
  final MultiplayerPalette palette;
  final bool isLeaving;
  final bool wasRemoved;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultiplayerPinHero(
          pin: room.pin,
          label: 'Você entrou no PIN',
          caption: 'Quando o host iniciar, a partida começa para todos.',
          palette: palette,
        ),
        const SizedBox(height: 16),
        MultiplayerRoomStatusCard(
          title: _statusTitle,
          subtitle: _statusSubtitle,
          icon: _statusIcon,
          palette: palette,
        ),
        const SizedBox(height: 16),
        _JoinedRoomParticipantsPanel(room: room, palette: palette),
        const SizedBox(height: 10),
        _LeaveRoomButton(
          palette: palette,
          isLeaving: isLeaving,
          enabled: !room.isInProgress && !wasRemoved,
          onLeave: onLeave,
        ),
      ],
    );
  }

  String get _statusTitle {
    if (wasRemoved) return 'Você foi removido';
    if (room.isInProgress) return 'Partida iniciada';
    return 'Aguardando início';
  }

  String get _statusSubtitle {
    if (wasRemoved) return 'O criador removeu sua entrada desta sala.';
    if (room.isInProgress) return 'O lobby foi fechado para iniciar o jogo.';
    return 'Sua presença já aparece no lobby. A lista atualiza automaticamente.';
  }

  IconData get _statusIcon {
    if (wasRemoved) return Icons.person_remove_alt_1_rounded;
    if (room.isInProgress) return Icons.play_circle_fill_rounded;
    return Icons.sensors_rounded;
  }
}

class _JoinedRoomParticipantsPanel extends StatelessWidget {
  const _JoinedRoomParticipantsPanel({
    required this.room,
    required this.palette,
  });

  final MultiplayerRoom room;
  final MultiplayerPalette palette;

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
                '${room.participants.length}/${room.maxParticipants}',
                style: GoogleFonts.plusJakartaSans(
                  color: palette.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final participant in room.participants) ...[
            MultiplayerParticipantTile(
              participant: participant,
              palette: palette,
              canRemove: false,
            ),
            if (participant != room.participants.last)
              const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _LeaveRoomButton extends StatelessWidget {
  const _LeaveRoomButton({
    required this.palette,
    required this.isLeaving,
    required this.enabled,
    required this.onLeave,
  });

  final MultiplayerPalette palette;
  final bool isLeaving;
  final bool enabled;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: enabled && !isLeaving ? onLeave : null,
      style: FilledButton.styleFrom(
        backgroundColor: palette.surfaceContainerHigh,
        foregroundColor: palette.onSurface,
        disabledBackgroundColor: palette.surfaceContainerHigh,
        disabledForegroundColor: palette.onSurfaceMuted,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: isLeaving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.logout_rounded),
      label: Text(
        isLeaving ? 'Saindo...' : 'Sair da sala',
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
      ),
    );
  }
}
