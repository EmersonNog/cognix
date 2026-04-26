part of '../multiplayer_create_room_screen.dart';

Widget _buildCreateRoomScreen(
  _MultiplayerCreateRoomScreenState state,
  BuildContext context,
) {
  final palette = MultiplayerPalette.fromContext(context);

  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;
      await _handleCreateRoomBack(state);
    },
    child: Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          MultiplayerScaffold(
            title: 'Criar sala',
            subtitle: 'Compartilhe o PIN e aguarde os participantes.',
            leadingIcon: Icons.groups_2_rounded,
            palette: palette,
            onBack: () {
              _handleCreateRoomBack(state);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: _buildCreateRoomContent(state, palette),
            ),
          ),
          if (state._shouldShowConnectionOverlay)
            MultiplayerConnectionOverlay(
              palette: palette,
              title: 'Segurando a sala...',
              message:
                  'Sua conexão oscilou. Verifique a internet enquanto tentamos retomar tudo.',
              icon: Icons.wifi_tethering_error_rounded,
              remainingSeconds: state._connectionRemainingSeconds,
            ),
        ],
      ),
    ),
  );
}

List<Widget> _buildCreateRoomContent(
  _MultiplayerCreateRoomScreenState state,
  MultiplayerPalette palette,
) {
  final room = state._room;
  if (state._isLoading) {
    return [
      MultiplayerLoadingPanel(
        palette: palette,
        message: 'Criando sala multiplayer...',
      ),
    ];
  }

  if (room == null) {
    return [
      MultiplayerErrorPanel(
        palette: palette,
        title: 'Não conseguimos criar a sala',
        message: state._errorMessage ?? 'Não foi possível criar a sala.',
        onRetry: () {
          _createRoom(state);
        },
      ),
    ];
  }

  final canStart =
      room.isWaiting && room.participants.length > 1 && !state._isStarting;

  return [
    MultiplayerPinHero(
      pin: room.pin,
      label: 'PIN da sala',
      caption: 'Quem tiver esse código pode entrar na partida.',
      palette: palette,
    ),
    const SizedBox(height: 16),
    MultiplayerRoomStatusCard(
      title: room.isInProgress ? 'Partida iniciada' : 'Sala em espera',
      subtitle: room.isInProgress
          ? 'O lobby já foi fechado para iniciar o jogo.'
          : 'A lista atualiza automaticamente. Você pode remover participantes antes de iniciar.',
      icon: room.isInProgress
          ? Icons.play_circle_fill_rounded
          : Icons.hourglass_top_rounded,
      palette: palette,
    ),
    const SizedBox(height: 18),
    MultiplayerCreateParticipantsSection(
      participants: room.participants,
      maxParticipants: room.maxParticipants,
      palette: palette,
      removingParticipantIds: state._removingParticipantIds,
      onRemove: (participant) {
        _removeCreateRoomParticipant(state, participant);
      },
    ),
    const SizedBox(height: 14),
    OutlinedButton.icon(
      onPressed: state._isRefreshing
          ? null
          : () {
              _refreshCreateRoom(state);
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.primary,
        side: BorderSide(color: palette.primary.withValues(alpha: 0.42)),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: state._isRefreshing
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: palette.primary,
              ),
            )
          : const Icon(Icons.refresh_rounded, size: 18),
      label: Text(
        state._isRefreshing ? 'Atualizando...' : 'Atualizar participantes',
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
      ),
    ),
    const SizedBox(height: 10),
    FilledButton.icon(
      onPressed: canStart
          ? () {
              _startCreateRoomMatch(state);
            }
          : null,
      style: FilledButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        disabledBackgroundColor: palette.surfaceContainerHigh,
        disabledForegroundColor: palette.onSurfaceMuted,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: state._isStarting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              room.isInProgress
                  ? Icons.check_rounded
                  : Icons.play_arrow_rounded,
            ),
      label: Text(
        room.isInProgress
            ? 'Partida iniciada'
            : room.participants.length > 1
            ? 'Iniciar partida'
            : 'Aguardando jogadores',
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
      ),
    ),
  ];
}
