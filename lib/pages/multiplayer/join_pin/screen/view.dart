part of '../multiplayer_join_room_screen.dart';

Widget _buildJoinRoomScreen(
  _MultiplayerJoinRoomScreenState state,
  BuildContext context,
) {
  final palette = MultiplayerPalette.fromContext(context);
  final room = state._room;

  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;
      _handleJoinRoomBack(state);
    },
    child: Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          MultiplayerScaffold(
            title: room == null ? 'Entrar na sala' : 'Sala encontrada',
            subtitle: room == null
                ? 'Digite o PIN enviado pelo criador da sala.'
                : 'Aguarde o criador iniciar a partida.',
            palette: palette,
            onBack: () {
              _handleJoinRoomBack(state);
            },
            trailing: room == null
                ? null
                : MultiplayerLobbyRefreshAction(
                    palette: palette,
                    isRefreshing: state._isRefreshing,
                    enabled: !room.isInProgress && !state._wasRemoved,
                    onRefresh: () {
                      _refreshJoinRoom(state);
                    },
                  ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                if (room == null)
                  MultiplayerJoinForm(
                    controller: state._pinController,
                    palette: palette,
                    canJoin: state._canJoin,
                    isJoining: state._isJoining,
                    errorMessage: state._errorMessage,
                    onChanged: () => state._update(() {}),
                    onJoin: () {
                      _joinRoom(state);
                    },
                  )
                else
                  MultiplayerJoinedRoomPreview(
                    room: room,
                    palette: palette,
                    isLeaving: state._isLeaving,
                    wasRemoved: state._wasRemoved,
                    onLeave: () {
                      _leaveJoinRoom(state);
                    },
                  ),
              ],
            ),
          ),
          if (state._shouldShowConnectionOverlay)
            MultiplayerConnectionOverlay(
              palette: palette,
              title: 'Voltando para a sala...',
              message:
                  'A conexão deu uma escapada. Segura so um instante enquanto buscamos o estado atual.',
              icon: Icons.sync_problem_rounded,
              remainingSeconds: state._connectionRemainingSeconds,
            ),
        ],
      ),
    ),
  );
}
