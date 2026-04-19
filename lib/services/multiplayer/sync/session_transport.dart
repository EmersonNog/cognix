part of '../sync.dart';

extension _MultiplayerRoomSyncSessionTransport on MultiplayerRoomSyncSession {
  Future<void> _connectWebSocket() async {
    if (_isDisposed || _isConnectingWebSocket) {
      return;
    }

    final room = _room;
    if (room == null || room.isFinished || room.isClosed) {
      _emitStatus(
        MultiplayerRealtimeStatus.pollingFallback,
        detail: 'room not eligible for websocket',
      );
      _startPollingTimer();
      return;
    }

    _isConnectingWebSocket = true;
    _emitStatus(
      MultiplayerRealtimeStatus.connecting,
      detail: 'connecting websocket',
    );
    _pollingTimer?.cancel();
    _pollingTimer = null;
    await _disconnectWebSocket();
    try {
      final token = await _tokenProvider();
      final uri = Uri.parse(
        '${apiWebSocketBaseUrl()}/multiplayer/rooms/${room.id}/ws',
      ).replace(queryParameters: <String, String>{'token': token});
      final channel = _channelFactory(uri);
      await channel.ready;
      _webSocketChannel = channel;
      _lastSocketActivityAt = DateTime.now().toUtc();
      _reconnectAttempts = 0;
      _startHeartbeat();
      _emitStatus(
        MultiplayerRealtimeStatus.connected,
        detail: 'websocket connected',
      );
      _webSocketSubscription = channel.stream.listen(
        _handleWebSocketMessage,
        onError: (Object error, StackTrace stackTrace) {
          _emitError(error, MultiplayerSyncSource.websocket);
          _fallbackToPolling();
        },
        onDone: _fallbackToPolling,
        cancelOnError: true,
      );
    } catch (error) {
      _emitError(error, MultiplayerSyncSource.websocket);
      _fallbackToPolling();
    } finally {
      _isConnectingWebSocket = false;
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    if (_isDisposed) {
      return;
    }

    _lastSocketActivityAt = DateTime.now().toUtc();
    final payload = _decodePayload(message);
    if (payload['event'] == 'pong') {
      _emitStatus(
        MultiplayerRealtimeStatus.connected,
        detail: 'heartbeat acknowledged',
      );
      return;
    }
    if (payload['event'] == 'command.result') {
      _resolvePendingCommand(payload, isError: false);
      return;
    }
    if (payload['event'] == 'command.error') {
      _resolvePendingCommand(payload, isError: true);
      return;
    }
    final rawRoom = payload['room'];
    if (rawRoom is! Map) {
      return;
    }

    final room = parseMultiplayerRoom(Map<String, dynamic>.from(rawRoom));
    _room = room;
    _emitRoom(room, MultiplayerSyncSource.websocket);
  }

  Map<String, dynamic> _decodePayload(dynamic message) {
    if (message is Map<String, dynamic>) {
      return message;
    }
    if (message is String) {
      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }
    return const <String, dynamic>{};
  }

  void _fallbackToPolling() {
    if (_isDisposed || !_isRealtimeEnabled) {
      return;
    }
    unawaited(_disconnectWebSocket());
    _emitStatus(
      MultiplayerRealtimeStatus.pollingFallback,
      detail: 'falling back to polling',
    );
    unawaited(refresh(source: MultiplayerSyncSource.polling));
    _startPollingTimer();
    _scheduleReconnect();
  }

  void _startPollingTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      _pollingInterval,
      (_) => refresh(source: MultiplayerSyncSource.polling),
    );
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      final channel = _webSocketChannel;
      if (channel == null) {
        return;
      }

      final lastActivity = _lastSocketActivityAt;
      if (lastActivity != null &&
          DateTime.now().toUtc().difference(lastActivity) > _heartbeatTimeout) {
        _fallbackToPolling();
        return;
      }

      try {
        channel.sink.add(jsonEncode(<String, String>{'type': 'ping'}));
      } catch (error) {
        _emitError(error, MultiplayerSyncSource.websocket);
        _fallbackToPolling();
      }
    });
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null || !_isRealtimeEnabled || _isDisposed) {
      return;
    }

    _reconnectAttempts += 1;
    final multiplier = _reconnectAttempts.clamp(1, 6);
    final delay = Duration(
      milliseconds: _reconnectDelay.inMilliseconds * multiplier,
    );
    _emitStatus(
      MultiplayerRealtimeStatus.reconnectScheduled,
      detail: 'websocket reconnect scheduled in ${delay.inSeconds}s',
    );
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      unawaited(_connectWebSocket());
    });
  }

  Future<void> _disconnectWebSocket() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    for (final completer in _pendingCommands.values) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('Conexão WebSocket encerrada.'));
      }
    }
    _pendingCommands.clear();
    await _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    await _webSocketChannel?.sink.close();
    _webSocketChannel = null;
    _lastSocketActivityAt = null;
  }
}
