part of '../multiplayer_match_screen.dart';

void _handleMatchRemoval(_MultiplayerMatchScreenState state) {
  if (state._handledRemovalRedirect || !state.mounted) {
    return;
  }

  state._handledRemovalRedirect = true;
  state._roomSync.stopPolling();
  _notifyMatchAndGoHome(
    state,
    message: MultiplayerText.removedFromMatch,
    backgroundColor: const Color(0xFFB42318),
  );
}

void _handleMatchClosedByHost(_MultiplayerMatchScreenState state) {
  if (state._handledRoomClosedRedirect ||
      !state.mounted ||
      state._isCurrentUserHost) {
    return;
  }

  state._handledRoomClosedRedirect = true;
  state._roomSync.stopPolling();
  _notifyMatchAndGoHome(
    state,
    message: MultiplayerText.hostClosedMatch,
    backgroundColor: const Color(0xFFB42318),
  );
}

void _handleMatchRoomEvent(
  _MultiplayerMatchScreenState state,
  MultiplayerRoomSyncEvent event,
) {
  if (!state.mounted) {
    return;
  }

  final previousRoom = state._room;
  final updatedRoom = event.room;
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  final wasRemoved =
      currentUid != null && !updatedRoom.hasParticipantFirebaseUid(currentUid);
  final hostLeft = !updatedRoom.hasParticipantFirebaseUid(
    updatedRoom.hostFirebaseUid,
  );
  final recoveredBySync =
      event.source != MultiplayerSyncSource.initial &&
      state._connectionInterrupted;
  final restored =
      event.source == MultiplayerSyncSource.websocket &&
      state._awaitingReconnectConfirmation;
  final shouldReloadQuestions =
      _matchQuestionIdsKey(updatedRoom.questionIds) !=
      state._loadedQuestionIdsKey;
  final shouldSyncQuestionIndex =
      updatedRoom.hasMatchQuestions &&
      !updatedRoom.isFinished &&
      updatedRoom.currentQuestionIndex != state._questionIndex &&
      updatedRoom.currentQuestionIndex >= 0 &&
      updatedRoom.currentQuestionIndex < state._questions.length;

  state._update(() {
    state._room = updatedRoom;
    state._score = _matchScoreFromRoom(updatedRoom) ?? state._score;
    if (recoveredBySync) {
      _resetMatchConnectionCountdown(state);
      state._connectionInterrupted = false;
      state._awaitingReconnectConfirmation = false;
    }
    if (updatedRoom.isFinished) {
      state._remainingSeconds = 0;
      state._hasSubmittedAnswer = true;
    }
    if (shouldSyncQuestionIndex) {
      state._questionIndex = updatedRoom.currentQuestionIndex;
      state._lastTimeoutSyncAttemptAt = null;
      state._selectedAnswerIndex = null;
      state._hasSubmittedAnswer = false;
      state._lastAnswerWasCorrect = null;
      state._lastCorrectLetter = null;
      state._remainingSeconds = _matchRemainingSecondsForRoom(updatedRoom);
    } else if (previousRoom?.roundStartedAt != updatedRoom.roundStartedAt &&
        !updatedRoom.isFinished) {
      state._lastTimeoutSyncAttemptAt = null;
      state._remainingSeconds = _matchRemainingSecondsForRoom(updatedRoom);
    }
  });

  if (state._isLeaving) {
    return;
  }
  if (restored && _canShowMatchReconnectNotice(state)) {
    _showMatchReconnectSuccess(state, MultiplayerText.reconnectSuccess);
  }
  if (updatedRoom.isClosed) {
    _handleMatchClosedByHost(state);
    return;
  }
  if (wasRemoved) {
    _handleMatchRemoval(state);
    return;
  }
  if (hostLeft && !updatedRoom.isHostFirebaseUid(currentUid)) {
    _handleMatchClosedByHost(state);
    return;
  }
  if (shouldReloadQuestions) {
    _loadMatchQuestions(state, roomOverride: updatedRoom);
  }
}

void _handleMatchRoomSyncError(
  _MultiplayerMatchScreenState state,
  MultiplayerRoomSyncError event,
) {
  if (isMultiplayerNotFoundError(event.error)) {
    _handleMatchClosedByHost(state);
  }
}

void _startMatchConnectionCountdown(_MultiplayerMatchScreenState state) {
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
      _handleMatchConnectionCountdownExpired(state);
    }
  });
}

void _handleMatchConnectionCountdownExpired(
  _MultiplayerMatchScreenState state,
) {
  if (!state.mounted || state._handledConnectionTimeoutRedirect) {
    return;
  }
  state._handledConnectionTimeoutRedirect = true;
  state._roomSync.stopPolling();
  Navigator.of(state.context).pushNamedAndRemoveUntil('home', (route) => false);
}

void _resetMatchConnectionCountdown(_MultiplayerMatchScreenState state) {
  state._connectionCountdownTimer?.cancel();
  state._connectionCountdownTimer = null;
  state._handledConnectionTimeoutRedirect = false;
  state._connectionRemainingSeconds = _connectionGraceSeconds;
}

void _handleMatchRoomSyncStatus(
  _MultiplayerMatchScreenState state,
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
        state._connectionRemainingSeconds = _connectionGraceSeconds;
        _startMatchConnectionCountdown(state);
      }
      state._connectionInterrupted = true;
      state._awaitingReconnectConfirmation = true;
    }
  });
}

bool _canShowMatchReconnectNotice(_MultiplayerMatchScreenState state) {
  final now = DateTime.now();
  final lastNoticeAt = state._lastReconnectNoticeAt;
  if (lastNoticeAt != null &&
      now.difference(lastNoticeAt) < const Duration(seconds: 6)) {
    return false;
  }
  state._lastReconnectNoticeAt = now;
  return true;
}

void _showMatchReconnectSuccess(
  _MultiplayerMatchScreenState state,
  String message,
) {
  if (!state.mounted) return;
  showCognixMessage(state.context, message, type: CognixMessageType.success);
}

String? _matchQuestionIdsKey(List<int>? questionIds) {
  if (questionIds == null || questionIds.isEmpty) {
    return null;
  }
  return questionIds.join(',');
}

int? _matchScoreFromRoom(MultiplayerRoom room) {
  final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
  if (firebaseUid == null || firebaseUid.trim().isEmpty) {
    return null;
  }

  for (final participant in room.participants) {
    if (participant.firebaseUid == firebaseUid) {
      return participant.score;
    }
  }
  return null;
}

int _matchRemainingSecondsForRoom(MultiplayerRoom? room) {
  if (room == null || room.roundStartedAt == null) {
    return room?.roundDurationSeconds ?? 60;
  }

  final referenceTime = room.serverTime?.toUtc() ?? DateTime.now().toUtc();
  final elapsed = referenceTime
      .toUtc()
      .difference(room.roundStartedAt!.toUtc())
      .inSeconds;
  return (room.roundDurationSeconds - elapsed).clamp(
    0,
    room.roundDurationSeconds,
  );
}
