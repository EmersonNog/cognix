part of '../multiplayer_join_room_screen.dart';

void _handleJoinRoomRemoval(_MultiplayerJoinRoomScreenState state) {
  if (state._handledRemovalRedirect || !state.mounted) {
    return;
  }

  state._handledRemovalRedirect = true;
  _notifyJoinRoomAndGoHome(
    state,
    message: MultiplayerText.removedFromRoom,
    backgroundColor: const Color(0xFFB42318),
  );
}

void _handleJoinRoomClosedByHost(_MultiplayerJoinRoomScreenState state) {
  if (state._handledRoomClosedRedirect || !state.mounted) {
    return;
  }

  state._handledRoomClosedRedirect = true;
  state._roomSync.stopPolling();
  _notifyJoinRoomAndGoHome(
    state,
    message: MultiplayerText.hostClosedRoom,
    backgroundColor: const Color(0xFFB42318),
  );
}

void _startJoinRoomConnectionCountdown(_MultiplayerJoinRoomScreenState state) {
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
      _handleJoinRoomConnectionCountdownExpired(state);
    }
  });
}

void _handleJoinRoomConnectionCountdownExpired(
  _MultiplayerJoinRoomScreenState state,
) {
  if (!state.mounted || state._handledConnectionTimeoutRedirect) {
    return;
  }
  state._handledConnectionTimeoutRedirect = true;
  state._roomSync.stopPolling();
  Navigator.of(state.context).pushNamedAndRemoveUntil('home', (route) => false);
}

void _resetJoinRoomConnectionCountdown(_MultiplayerJoinRoomScreenState state) {
  state._connectionCountdownTimer?.cancel();
  state._connectionCountdownTimer = null;
  state._handledConnectionTimeoutRedirect = false;
  state._connectionRemainingSeconds = _joinRoomConnectionGraceSeconds;
}

void _handleJoinRoomSyncStatus(
  _MultiplayerJoinRoomScreenState state,
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
        state._connectionRemainingSeconds = _joinRoomConnectionGraceSeconds;
        _startJoinRoomConnectionCountdown(state);
      }
      state._connectionInterrupted = true;
      state._awaitingReconnectConfirmation = true;
    }
  });
}

bool _canShowJoinRoomReconnectNotice(_MultiplayerJoinRoomScreenState state) {
  final now = DateTime.now();
  final lastNoticeAt = state._lastReconnectNoticeAt;
  if (lastNoticeAt != null &&
      now.difference(lastNoticeAt) < const Duration(seconds: 6)) {
    return false;
  }
  state._lastReconnectNoticeAt = now;
  return true;
}

void _handleJoinRoomEvent(
  _MultiplayerJoinRoomScreenState state,
  MultiplayerRoomSyncEvent event,
) {
  if (!state.mounted) {
    return;
  }

  final updatedRoom = event.room;
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  final wasRemoved =
      currentUid != null && !updatedRoom.hasParticipantFirebaseUid(currentUid);
  final recoveredBySync =
      event.source != MultiplayerSyncSource.initial &&
      state._connectionInterrupted;
  final restored =
      event.source == MultiplayerSyncSource.websocket &&
      state._awaitingReconnectConfirmation;

  state._update(() {
    state._room = updatedRoom;
    state._wasRemoved = wasRemoved;
    if (recoveredBySync) {
      _resetJoinRoomConnectionCountdown(state);
      state._connectionInterrupted = false;
      state._awaitingReconnectConfirmation = false;
    }
  });
  if (restored && _canShowJoinRoomReconnectNotice(state)) {
    _showJoinRoomReconnectSuccess(state, MultiplayerText.roomReconnectSuccess);
  }

  if (updatedRoom.isInProgress || wasRemoved) {
    state._roomSync.stopPolling();
  }
  if (updatedRoom.isInProgress) {
    _openJoinRoomMatch(state, updatedRoom);
    return;
  }
  if (wasRemoved) {
    _handleJoinRoomRemoval(state);
  }
}

void _handleJoinRoomSyncError(
  _MultiplayerJoinRoomScreenState state,
  MultiplayerRoomSyncError event,
) {
  if (isMultiplayerNotFoundError(event.error)) {
    _handleJoinRoomClosedByHost(state);
    return;
  }
  return;
}
