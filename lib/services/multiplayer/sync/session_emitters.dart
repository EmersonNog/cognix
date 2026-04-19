part of '../sync.dart';

extension _MultiplayerRoomSyncSessionEmitters on MultiplayerRoomSyncSession {
  void _emitRoom(MultiplayerRoom room, MultiplayerSyncSource source) {
    if (_isDisposed) {
      return;
    }
    _events.add(
      MultiplayerRoomSyncEvent(
        room: room,
        source: source,
        receivedAt: DateTime.now().toUtc(),
      ),
    );
  }

  void _emitError(Object error, MultiplayerSyncSource source) {
    if (_isDisposed) {
      return;
    }
    _errors.add(
      MultiplayerRoomSyncError(
        error: error,
        source: source,
        occurredAt: DateTime.now().toUtc(),
      ),
    );
    _emitStatus(
      MultiplayerRealtimeStatus.pollingFallback,
      detail: 'sync error',
      error: error,
    );
  }

  void _emitStatus(
    MultiplayerRealtimeStatus status, {
    String? detail,
    Object? error,
  }) {
    if (_isDisposed) {
      return;
    }
    _currentStatus = status;
    _status.add(
      MultiplayerSyncStatusEvent(
        status: status,
        occurredAt: DateTime.now().toUtc(),
        detail: detail,
        error: error,
      ),
    );
  }
}
