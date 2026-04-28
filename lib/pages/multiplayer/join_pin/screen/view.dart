part of '../multiplayer_join_room_screen.dart';

Widget _buildJoinRoomScreen(
  _MultiplayerJoinRoomScreenState state,
  BuildContext context,
) {
  final palette = MultiplayerPalette.fromContext(context);
  final room = state._room;
  final showSubscriptionGate = room == null && state._isSubscriptionRequired;
  final title = showSubscriptionGate
      ? 'Multiplayer premium'
      : room == null
      ? 'Entrar na sala'
      : 'Sala encontrada';
  final subtitle = showSubscriptionGate
      ? 'Ative sua assinatura para entrar em salas e jogar ao vivo.'
      : room == null
      ? 'Digite o PIN enviado pelo criador da sala.'
      : 'Aguarde o criador iniciar a partida.';

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
            title: title,
            subtitle: subtitle,
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
                  if (showSubscriptionGate)
                    MultiplayerSubscriptionGate(
                      palette: palette,
                      message: state._errorMessage,
                      onPressed: () {
                        Navigator.of(state.context).pushNamed('subscription');
                      },
                    )
                  else
                    MultiplayerJoinForm(
                      controller: state._pinController,
                      palette: palette,
                      canJoin: state._canJoin,
                      isJoining: state._isJoining,
                      errorMessage: state._errorMessage,
                      onChanged: () => state._update(() {
                        state._errorMessage = null;
                        state._isSubscriptionRequired = false;
                      }),
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
                  'A conexão deu uma escapada. Segura só um instante enquanto buscamos o estado atual.',
              icon: Icons.sync_problem_rounded,
              remainingSeconds: state._connectionRemainingSeconds,
            ),
        ],
      ),
    ),
  );
}
