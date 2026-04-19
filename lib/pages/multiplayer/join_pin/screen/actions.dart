part of '../multiplayer_join_room_screen.dart';

Future<void> _joinRoom(_MultiplayerJoinRoomScreenState state) async {
  if (!state._canJoin) return;

  state._update(() {
    state._isJoining = true;
    state._errorMessage = null;
    state._wasRemoved = false;
    state._isOpeningMatch = false;
  });

  try {
    final room = await joinMultiplayerRoom(
      pin: state._pinController.text.trim(),
      displayName: _currentJoinRoomDisplayName(state),
    );
    if (!state.mounted) return;
    state._update(() => state._room = room);
    if (room.isInProgress) {
      _openJoinRoomMatch(state, room);
      return;
    }
    _startJoinRoomPolling(state);
  } catch (error) {
    if (!state.mounted) return;
    state._update(() => state._errorMessage = humanizeMultiplayerError(error));
  } finally {
    if (state.mounted && !state._isOpeningMatch) {
      state._update(() => state._isJoining = false);
    }
  }
}

Future<void> _refreshJoinRoom(
  _MultiplayerJoinRoomScreenState state, {
  bool silent = false,
}) async {
  final room = state._room;
  if (room == null || state._isRefreshing || state._wasRemoved) {
    return;
  }
  if (room.isInProgress) {
    _openJoinRoomMatch(state, room);
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

Future<void> _leaveJoinRoom(_MultiplayerJoinRoomScreenState state) async {
  final room = state._room;
  if (room == null || state._isLeaving) {
    return;
  }

  const palette = MultiplayerPalette();
  final shouldLeave = await showMultiplayerLeaveConfirmation(
    state.context,
    palette: palette,
    title: 'Sair da sala?',
    message: 'Você vai abandonar este lobby e sair da sala multiplayer.',
    confirmLabel: 'Sair da sala',
  );
  if (!state.mounted || !shouldLeave) {
    return;
  }

  state._update(() => state._isLeaving = true);
  try {
    final wsResult = await state._roomSync.leaveRoom();
    if (wsResult == null) {
      await leaveMultiplayerRoom(room.id);
    }
    if (!state.mounted) return;
    state._roomSync.stopPolling();
    Navigator.of(state.context).pop();
  } catch (error) {
    if (isMultiplayerNotFoundError(error)) {
      _handleJoinRoomClosedByHost(state);
      return;
    }
    _showJoinRoomError(state, error);
  } finally {
    if (state.mounted) {
      state._update(() => state._isLeaving = false);
    }
  }
}

void _notifyJoinRoomAndGoHome(
  _MultiplayerJoinRoomScreenState state, {
  required String message,
  Color? backgroundColor,
}) {
  showCognixMessage(state.context, message, type: CognixMessageType.error);

  Future<void>.delayed(const Duration(milliseconds: 350), () {
    if (!state.mounted) return;
    Navigator.of(
      state.context,
    ).pushNamedAndRemoveUntil('home', (route) => false);
  });
}

void _openJoinRoomMatch(
  _MultiplayerJoinRoomScreenState state,
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

void _handleJoinRoomBack(_MultiplayerJoinRoomScreenState state) {
  final room = state._room;
  if (room == null || room.isInProgress || state._wasRemoved) {
    Navigator.of(state.context).pop();
    return;
  }

  _leaveJoinRoom(state);
}

void _showJoinRoomError(_MultiplayerJoinRoomScreenState state, Object error) {
  if (!state.mounted) return;
  showCognixMessage(
    state.context,
    humanizeMultiplayerError(error),
    type: CognixMessageType.error,
  );
}

void _showJoinRoomReconnectSuccess(
  _MultiplayerJoinRoomScreenState state,
  String message,
) {
  if (!state.mounted) return;
  showCognixMessage(state.context, message, type: CognixMessageType.success);
}
