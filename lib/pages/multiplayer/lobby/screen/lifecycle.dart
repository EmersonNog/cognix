part of '../multiplayer_create_room_screen.dart';

void _initCreateRoomScreenState(_MultiplayerCreateRoomScreenState state) {
  state._roomSync = MultiplayerRoomSyncSession();
  state._roomSubscription = state._roomSync.events.listen(
    state._handleRoomEvent,
  );
  state._roomErrorSubscription = state._roomSync.errors.listen(
    state._handleRoomSyncError,
  );
  state._roomStatusSubscription = state._roomSync.status.listen(
    state._handleRoomSyncStatus,
  );
  _createRoom(state);
}

void _disposeCreateRoomScreenState(_MultiplayerCreateRoomScreenState state) {
  state._roomSubscription?.cancel();
  state._roomErrorSubscription?.cancel();
  state._roomStatusSubscription?.cancel();
  state._connectionCountdownTimer?.cancel();
  state._roomSync.dispose();
}

String? _currentCreateRoomDisplayName(_MultiplayerCreateRoomScreenState state) {
  final user = FirebaseAuth.instance.currentUser;
  final displayName = user?.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }
  return null;
}

Future<void> _createRoom(_MultiplayerCreateRoomScreenState state) async {
  state._update(() {
    state._isLoading = true;
    state._errorMessage = null;
    state._isSubscriptionRequired = false;
  });

  try {
    final room = await createMultiplayerRoom(
      displayName: _currentCreateRoomDisplayName(state),
    );
    if (!state.mounted) return;
    state._update(() {
      state._room = room;
      state._isLoading = false;
    });
    _startCreateRoomPolling(state);
  } catch (error) {
    if (!state.mounted) return;
    state._update(() {
      state._errorMessage = humanizeMultiplayerError(error);
      state._isSubscriptionRequired = isSubscriptionRequiredError(error);
      state._isLoading = false;
    });
  }
}

void _startCreateRoomPolling(_MultiplayerCreateRoomScreenState state) {
  final room = state._room;
  if (room == null) {
    return;
  }
  state._roomSync.bindRoom(room, emitInitial: false);
  state._roomSync.startPolling();
}
