part of '../sync.dart';

Future<MultiplayerRoom?> _refresh(
  MultiplayerRoomSyncSession session, {
  MultiplayerSyncSource source = MultiplayerSyncSource.manual,
}) async {
  session._ensureNotDisposed();
  final currentRoom = session._room;
  if (currentRoom == null || session._isRefreshing) {
    return null;
  }

  session._isRefreshing = true;
  try {
    final updatedRoom = await session._fetchRoom(currentRoom.id);
    session._room = updatedRoom;
    session._emitRoom(updatedRoom, source);
    return updatedRoom;
  } catch (error) {
    session._emitError(error, source);
    return null;
  } finally {
    session._isRefreshing = false;
  }
}

Future<MultiplayerRoom?> _startMatch(MultiplayerRoomSyncSession session) async {
  final result = await session._sendCommand(
    action: 'start_match',
    payload: const <String, dynamic>{},
  );
  if (result == null) {
    return null;
  }

  final room = parseMultiplayerRoom(result);
  _applyLocalRoom(session, room);
  return room;
}

Future<MultiplayerRoom?> _removeParticipant(
  MultiplayerRoomSyncSession session,
  int participantId,
) async {
  final result = await session._sendCommand(
    action: 'remove_participant',
    payload: <String, dynamic>{'participant_id': participantId},
  );
  if (result == null) {
    return null;
  }

  final room = parseMultiplayerRoom(result);
  _applyLocalRoom(session, room);
  return room;
}

Future<MultiplayerAnswerResult?> _submitAnswer(
  MultiplayerRoomSyncSession session, {
  required int questionId,
  required String selectedLetter,
}) async {
  final result = await session._sendCommand(
    action: 'submit_answer',
    payload: <String, dynamic>{
      'question_id': questionId,
      'selected_letter': selectedLetter,
    },
  );
  if (result == null) {
    return null;
  }

  final answerResult = parseMultiplayerAnswerResult(result);
  _applyLocalRoom(session, answerResult.room);
  return answerResult;
}

Future<Map<String, dynamic>?> _leaveRoom(MultiplayerRoomSyncSession session) {
  return session._sendCommand(
    action: 'leave_room',
    payload: const <String, dynamic>{},
  );
}

extension _MultiplayerRoomSyncSessionCommands on MultiplayerRoomSyncSession {
  Future<Map<String, dynamic>?> _sendCommand({
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final channel = _webSocketChannel;
    if (channel == null || !isWebSocketReady) {
      return null;
    }

    final requestId =
        'cmd_${DateTime.now().microsecondsSinceEpoch}_${_commandSequence++}';
    final completer = Completer<Map<String, dynamic>>();
    _pendingCommands[requestId] = completer;

    try {
      channel.sink.add(
        jsonEncode(<String, dynamic>{
          'type': 'command',
          'request_id': requestId,
          'action': action,
          'payload': payload,
        }),
      );
    } catch (error) {
      _pendingCommands.remove(requestId);
      rethrow;
    }

    return completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        _pendingCommands.remove(requestId);
        throw TimeoutException(
          'Comando multiplayer expirou.',
          const Duration(seconds: 12),
        );
      },
    );
  }

  void _resolvePendingCommand(
    Map<String, dynamic> payload, {
    required bool isError,
  }) {
    final requestId = payload['request_id']?.toString();
    if (requestId == null || requestId.isEmpty) {
      return;
    }

    final completer = _pendingCommands.remove(requestId);
    if (completer == null || completer.isCompleted) {
      return;
    }

    if (isError) {
      completer.completeError(
        Exception(
          payload['message']?.toString() ?? 'Falha no comando multiplayer.',
        ),
      );
      return;
    }

    final result = payload['result'];
    if (result is Map) {
      completer.complete(Map<String, dynamic>.from(result));
      return;
    }
    completer.complete(const <String, dynamic>{});
  }
}
