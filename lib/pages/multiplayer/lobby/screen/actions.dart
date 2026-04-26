part of '../multiplayer_create_room_screen.dart';

Future<void> _refreshCreateRoom(
  _MultiplayerCreateRoomScreenState state, {
  bool silent = false,
}) async {
  final room = state._room;
  if (room == null || state._isRefreshing) {
    return;
  }
  if (room.isInProgress) {
    _openCreateRoomMatch(state, room);
    return;
  }

  state._isRefreshing = true;
  if (!silent) {
    state._update(() {});
  }
  await state._roomSync.refresh(
    source: silent
        ? MultiplayerSyncSource.polling
        : MultiplayerSyncSource.manual,
  );
  state._isRefreshing = false;
  if (!silent && state.mounted && !state._isOpeningMatch) {
    state._update(() {});
  }
}

Future<void> _removeCreateRoomParticipant(
  _MultiplayerCreateRoomScreenState state,
  MultiplayerParticipant participant,
) async {
  final room = state._room;
  if (room == null || participant.isHost) {
    return;
  }

  state._update(() => state._removingParticipantIds.add(participant.id));
  try {
    final updatedRoom =
        await state._roomSync.removeParticipant(participant.id) ??
        await removeMultiplayerParticipant(
          roomId: room.id,
          participantId: participant.id,
        );
    if (!state.mounted) return;
    state._roomSync.applyLocalRoom(updatedRoom);
  } catch (error) {
    _showCreateRoomError(state, error);
  } finally {
    if (state.mounted) {
      state._update(() => state._removingParticipantIds.remove(participant.id));
    }
  }
}

Future<void> _startCreateRoomMatch(
  _MultiplayerCreateRoomScreenState state,
) async {
  final room = state._room;
  if (room == null || !room.isWaiting || room.participants.length < 2) {
    return;
  }

  state._update(() => state._isStarting = true);
  try {
    final updatedRoom =
        await state._roomSync.startMatch() ??
        await startMultiplayerRoom(room.id);
    if (!state.mounted) return;
    state._roomSync.applyLocalRoom(updatedRoom);
    _openCreateRoomMatch(state, updatedRoom);
  } catch (error) {
    _showCreateRoomError(state, error);
  } finally {
    if (state.mounted && !state._isOpeningMatch) {
      state._update(() => state._isStarting = false);
    }
  }
}

void _openCreateRoomMatch(
  _MultiplayerCreateRoomScreenState state,
  MultiplayerRoom room,
) {
  if (state._isOpeningMatch || !state.mounted) {
    return;
  }

  state._isOpeningMatch = true;
  state._roomSync.stopPolling();
  Navigator.of(
    state.context,
  ).pushReplacementNamed('multiplayer-match', arguments: room);
}

Future<void> _handleCreateRoomBack(
  _MultiplayerCreateRoomScreenState state,
) async {
  final room = state._room;
  if (room == null || room.isInProgress) {
    Navigator.of(state.context).pop();
    return;
  }

  if (state._isClosing) {
    return;
  }

  final palette = MultiplayerPalette.fromContext(state.context);
  final shouldLeave = await showMultiplayerLeaveConfirmation(
    state.context,
    palette: palette,
    title: 'Encerrar sala?',
    message:
        'Se você sair agora, a sala será encerrada para todos os participantes.',
    confirmLabel: 'Encerrar sala',
  );
  if (!state.mounted || !shouldLeave) {
    return;
  }

  state._update(() => state._isClosing = true);
  try {
    final wsResult = await state._roomSync.leaveRoom();
    if (wsResult == null) {
      await leaveMultiplayerRoom(room.id);
    }
    if (!state.mounted) return;
    state._roomSync.stopPolling();
    Navigator.of(state.context).pop();
  } catch (error) {
    _showCreateRoomError(state, error);
  } finally {
    if (state.mounted) {
      state._update(() => state._isClosing = false);
    }
  }
}

void _showCreateRoomError(
  _MultiplayerCreateRoomScreenState state,
  Object error,
) {
  _showCreateRoomMessage(state, humanizeMultiplayerError(error));
}

void _showCreateRoomMessage(
  _MultiplayerCreateRoomScreenState state,
  String message,
) {
  if (!state.mounted) return;
  showCognixMessage(state.context, message);
}

void _showCreateRoomReconnectSuccess(
  _MultiplayerCreateRoomScreenState state,
  String message,
) {
  if (!state.mounted) return;
  showCognixMessage(state.context, message, type: CognixMessageType.success);
}
