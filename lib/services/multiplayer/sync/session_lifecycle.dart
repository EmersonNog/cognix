part of '../sync.dart';

void _bindRoom(
  MultiplayerRoomSyncSession session,
  MultiplayerRoom room, {
  bool emitInitial = true,
}) {
  session._ensureNotDisposed();
  final previousRoomId = session._room?.id;
  session._room = room;
  if (emitInitial) {
    session._emitRoom(room, MultiplayerSyncSource.initial);
  }
  if (session._isRealtimeEnabled &&
      previousRoomId != null &&
      previousRoomId != room.id) {
    unawaited(session._connectWebSocket());
  }
}

void _applyLocalRoom(
  MultiplayerRoomSyncSession session,
  MultiplayerRoom room, {
  MultiplayerSyncSource source = MultiplayerSyncSource.action,
}) {
  session._ensureNotDisposed();
  session._room = room;
  session._emitRoom(room, source);
}

void _startPolling(
  MultiplayerRoomSyncSession session, {
  Duration interval = const Duration(seconds: 3),
}) {
  session._ensureNotDisposed();
  session._pollingInterval = interval;
  session._isRealtimeEnabled = true;
  unawaited(session._connectWebSocket());
}

void _stopPolling(MultiplayerRoomSyncSession session) {
  session._isRealtimeEnabled = false;
  session._pollingTimer?.cancel();
  session._pollingTimer = null;
  session._heartbeatTimer?.cancel();
  session._heartbeatTimer = null;
  session._reconnectTimer?.cancel();
  session._reconnectTimer = null;
  session._emitStatus(
    MultiplayerRealtimeStatus.disconnected,
    detail: 'sync stopped',
  );
  unawaited(session._disconnectWebSocket());
}

void _disposeSyncSession(MultiplayerRoomSyncSession session) {
  if (session._isDisposed) {
    return;
  }

  session._isDisposed = true;
  _stopPolling(session);
  session._events.close();
  session._errors.close();
  session._status.close();
}

extension _MultiplayerRoomSyncSessionLifecycleInternals
    on MultiplayerRoomSyncSession {
  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('MultiplayerRoomSyncSession already disposed.');
    }
  }
}
