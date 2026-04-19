import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/multiplayer/models.dart';
import '../../shared/widgets/room_widgets.dart';
import '../../shared/widgets/palette.dart';

class MultiplayerJoinForm extends StatelessWidget {
  const MultiplayerJoinForm({
    super.key,
    required this.controller,
    required this.palette,
    required this.canJoin,
    required this.isJoining,
    required this.errorMessage,
    required this.onChanged,
    required this.onJoin,
  });

  final TextEditingController controller;
  final MultiplayerPalette palette;
  final bool canJoin;
  final bool isJoining;
  final String? errorMessage;
  final VoidCallback onChanged;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return MultiplayerPanel(
      palette: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PIN da sala',
            style: GoogleFonts.manrope(
              color: palette.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Use o código de 6 dígitos para entrar no lobby multiplayer.',
            style: GoogleFonts.inter(
              color: palette.onSurfaceMuted,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 6,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (_) => onChanged(),
            onSubmitted: (_) => onJoin(),
            style: GoogleFonts.plusJakartaSans(
              color: palette.onSurface,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 9,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: palette.surfaceContainerHigh.withValues(alpha: 0.68),
              hintText: '000000',
              hintStyle: GoogleFonts.plusJakartaSans(
                color: palette.onSurfaceMuted.withValues(alpha: 0.35),
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 9,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: palette.onSurfaceMuted.withValues(alpha: 0.14),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: palette.primary, width: 1.4),
              ),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              style: GoogleFonts.inter(
                color: palette.secondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: canJoin ? onJoin : null,
            style: FilledButton.styleFrom(
              backgroundColor: palette.primary,
              disabledBackgroundColor: palette.surfaceContainerHigh,
              disabledForegroundColor: palette.onSurfaceMuted,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: isJoining
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.meeting_room_rounded),
            label: Text(
              isJoining ? 'Entrando...' : 'Entrar na sala',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final statusTitle = wasRemoved
        ? 'Você foi removido'
        : room.isInProgress
        ? 'Partida iniciada'
        : 'Aguardando início';
    final statusSubtitle = wasRemoved
        ? 'O criador removeu sua entrada desta sala.'
        : room.isInProgress
        ? 'O lobby foi fechado para iniciar o jogo.'
        : 'Sua presença já aparece no lobby. A lista atualiza automaticamente.';

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
          title: statusTitle,
          subtitle: statusSubtitle,
          icon: wasRemoved
              ? Icons.person_remove_alt_1_rounded
              : room.isInProgress
              ? Icons.play_circle_fill_rounded
              : Icons.sensors_rounded,
          palette: palette,
        ),
        const SizedBox(height: 16),
        MultiplayerPanel(
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
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: isLeaving || room.isInProgress || wasRemoved
              ? null
              : onLeave,
          style: FilledButton.styleFrom(
            backgroundColor: palette.surfaceContainerHigh,
            disabledBackgroundColor: palette.surfaceContainerHigh,
            disabledForegroundColor: palette.onSurfaceMuted,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
        ),
      ],
    );
  }
}

class MultiplayerLobbyRefreshAction extends StatelessWidget {
  const MultiplayerLobbyRefreshAction({
    super.key,
    required this.palette,
    required this.isRefreshing,
    required this.enabled,
    required this.onRefresh,
  });

  final MultiplayerPalette palette;
  final bool isRefreshing;
  final bool enabled;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = enabled ? palette.primary : palette.onSurfaceMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && !isRefreshing ? onRefresh : null,
        borderRadius: BorderRadius.circular(15),
        child: Tooltip(
          message: isRefreshing ? 'Atualizando...' : 'Atualizar sala',
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.primary.withValues(alpha: enabled ? 0.13 : 0.07),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: isRefreshing
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: palette.primary,
                      ),
                    )
                  : Icon(
                      Icons.refresh_rounded,
                      color: foregroundColor,
                      size: 22,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
