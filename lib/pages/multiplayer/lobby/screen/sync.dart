part of '../multiplayer_create_room_screen.dart';

void _startCreateRoomConnectionCountdown(
  _MultiplayerCreateRoomScreenState state,
) {
  state._connectionCountdownTimer?.cancel();
  state._connectionCountdownTimer = Timer.periodic(const Duration(seconds: 1), (
    _,
  ) {
    if (!state.mounted || !state._connectionInterrupted) {
      state._connectionCountdownTimer?.cancel();
      state._connectionCountdownTimer = null;
      return;
    }
    final nextRemaining = state._connectionRemainingSeconds - 1;
    state._update(() {
      state._connectionRemainingSeconds = nextRemaining < 0 ? 0 : nextRemaining;
    });
    if (nextRemaining <= 0) {
      state._connectionCountdownTimer?.cancel();
      state._connectionCountdownTimer = null;
      _handleCreateRoomConnectionCountdownExpired(state);
    }
  });
}

void _handleCreateRoomConnectionCountdownExpired(
  _MultiplayerCreateRoomScreenState state,
) {
  if (!state.mounted || state._handledConnectionTimeoutRedirect) {
    return;
  }
  state._handledConnectionTimeoutRedirect = true;
  state._roomSync.stopPolling();
  Navigator.of(state.context).pushNamedAndRemoveUntil('home', (route) => false);
}

void _resetCreateRoomConnectionCountdown(
  _MultiplayerCreateRoomScreenState state,
) {
  state._connectionCountdownTimer?.cancel();
  state._connectionCountdownTimer = null;
  state._handledConnectionTimeoutRedirect = false;
  state._connectionRemainingSeconds = _createRoomConnectionGraceSeconds;
}

void _handleCreateRoomSyncStatus(
  _MultiplayerCreateRoomScreenState state,
  MultiplayerSyncStatusEvent event,
) {
  if (!state.mounted) {
    return;
  }
  final interrupted =
      event.status == MultiplayerRealtimeStatus.pollingFallback ||
      event.status == MultiplayerRealtimeStatus.reconnectScheduled ||
      event.status == MultiplayerRealtimeStatus.disconnected;
  state._update(() {
    if (interrupted) {
      if (!state._connectionInterrupted) {
        state._connectionRemainingSeconds = _createRoomConnectionGraceSeconds;
        _startCreateRoomConnectionCountdown(state);
      }
      state._connectionInterrupted = true;
      state._awaitingReconnectConfirmation = true;
    }
  });
}

bool _canShowCreateRoomReconnectNotice(
  _MultiplayerCreateRoomScreenState state,
) {
  final now = DateTime.now();
  final lastNoticeAt = state._lastReconnectNoticeAt;
  if (lastNoticeAt != null &&
      now.difference(lastNoticeAt) < const Duration(seconds: 6)) {
    return false;
  }
  state._lastReconnectNoticeAt = now;
  return true;
}

void _handleCreateRoomEvent(
  _MultiplayerCreateRoomScreenState state,
  MultiplayerRoomSyncEvent event,
) {
  if (!state.mounted) {
    return;
  }

  final room = event.room;
  final recoveredBySync =
      event.source != MultiplayerSyncSource.initial &&
      state._connectionInterrupted;
  final restored =
      event.source == MultiplayerSyncSource.websocket &&
      state._awaitingReconnectConfirmation;

  state._update(() {
    state._room = room;
    if (recoveredBySync) {
      _resetCreateRoomConnectionCountdown(state);
      state._connectionInterrupted = false;
      state._awaitingReconnectConfirmation = false;
    }
  });
  if (restored && _canShowCreateRoomReconnectNotice(state)) {
    _showCreateRoomReconnectSuccess(state, MultiplayerText.reconnectSuccess);
  }
  if (room.isInProgress) {
    _openCreateRoomMatch(state, room);
  }
}

void _handleCreateRoomSyncError(
  _MultiplayerCreateRoomScreenState state,
  MultiplayerRoomSyncError event,
) {
  return;
}
