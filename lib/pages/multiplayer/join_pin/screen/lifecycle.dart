part of '../multiplayer_join_room_screen.dart';

void _initJoinRoomScreenState(_MultiplayerJoinRoomScreenState state) {
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
}

void _disposeJoinRoomScreenState(_MultiplayerJoinRoomScreenState state) {
  state._roomSubscription?.cancel();
  state._roomErrorSubscription?.cancel();
  state._roomStatusSubscription?.cancel();
  state._connectionCountdownTimer?.cancel();
  state._roomSync.dispose();
  state._pinController.dispose();
}

String? _currentJoinRoomDisplayName(_MultiplayerJoinRoomScreenState state) {
  final user = FirebaseAuth.instance.currentUser;
  final displayName = user?.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }
  return null;
}

void _startJoinRoomPolling(_MultiplayerJoinRoomScreenState state) {
  final room = state._room;
  if (room == null) {
    return;
  }

  state._roomSync.bindRoom(room, emitInitial: false);
  state._roomSync.startPolling();
}
