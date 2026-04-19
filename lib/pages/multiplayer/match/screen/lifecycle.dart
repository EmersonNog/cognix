part of '../multiplayer_match_screen.dart';

void _initMatchScreenState(_MultiplayerMatchScreenState state) {
  state._roomSync = MultiplayerRoomSyncSession(
    heartbeatInterval: _matchHeartbeatInterval,
    heartbeatTimeout: _matchHeartbeatTimeout,
    reconnectDelay: _matchReconnectDelay,
  );
  state._roomSubscription = state._roomSync.events.listen(
    state._handleRoomEvent,
  );
  state._roomErrorSubscription = state._roomSync.errors.listen(
    state._handleRoomSyncError,
  );
  state._roomStatusSubscription = state._roomSync.status.listen(
    state._handleRoomSyncStatus,
  );
  state._room = state.widget.room;
  state._remainingSeconds = _matchRemainingSecondsForRoom(state.widget.room);
  if (state._room != null) {
    _startMatchPolling(state);
  }
  _startMatchRoundTimer(state);
  _loadMatchQuestions(state);
}

void _disposeMatchScreenState(_MultiplayerMatchScreenState state) {
  state._roundTimer?.cancel();
  state._roomSubscription?.cancel();
  state._roomErrorSubscription?.cancel();
  state._roomStatusSubscription?.cancel();
  state._connectionCountdownTimer?.cancel();
  state._roomSync.dispose();
}

void _startMatchPolling(_MultiplayerMatchScreenState state) {
  final room = state._room;
  if (room == null) {
    return;
  }

  state._roomSync.bindRoom(room, emitInitial: false);
  state._roomSync.startPolling(interval: _matchPollingInterval);
}

void _startMatchRoundTimer(_MultiplayerMatchScreenState state) {
  state._roundTimer?.cancel();
  state._roundTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (!state.mounted ||
        (state._room?.isFinished ?? false)) {
      return;
    }
    if (state._remainingSeconds <= 0) {
      _handleMatchRoundTimeout(state);
      return;
    }
    final nextRemaining = state._remainingSeconds - 1;
    state._update(() => state._remainingSeconds = nextRemaining);
    if (nextRemaining <= 0) {
      _handleMatchRoundTimeout(state);
    }
  });
}

Future<void> _handleMatchRoundTimeout(
  _MultiplayerMatchScreenState state,
) async {
  final room = state._room;
  if (!state.mounted ||
      room == null ||
      room.isFinished ||
      !room.hasMatchQuestions ||
      state._isResolvingRoundTimeout) {
    return;
  }
  final lastAttemptAt = state._lastTimeoutSyncAttemptAt;
  final now = DateTime.now();
  if (lastAttemptAt != null &&
      now.difference(lastAttemptAt) < const Duration(seconds: 2)) {
    return;
  }

  state._lastTimeoutSyncAttemptAt = now;
  state._isResolvingRoundTimeout = true;

  try {
    for (var attempt = 0; attempt < 3; attempt++) {
      if (!state.mounted || state._room?.isFinished == true) {
        break;
      }
      await state._roomSync.refresh(source: MultiplayerSyncSource.manual);
      if (!state.mounted) {
        return;
      }
      if ((state._room?.currentQuestionIndex ?? state._questionIndex) !=
              state._questionIndex ||
          (state._room?.isFinished ?? false)) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 900));
    }
  } finally {
    state._isResolvingRoundTimeout = false;
  }
}

Future<void> _loadMatchQuestions(
  _MultiplayerMatchScreenState state, {
  MultiplayerRoom? roomOverride,
}) async {
  final sourceRoom = roomOverride ?? state._room;
  state._update(() {
    state._isLoadingQuestions = true;
    state._questionsErrorMessage = null;
  });

  try {
    final loadedQuestions = sourceRoom?.hasMatchQuestions == true
        ? await _loadMatchQuestionsByRoomIds(sourceRoom!)
        : await _loadMatchFallbackQuestions();

    if (!state.mounted) return;
    state._update(() {
      state._questions
        ..clear()
        ..addAll(loadedQuestions);
      state._questionIndex = _resolveInitialMatchQuestionIndex(
        sourceRoom,
        loadedQuestions,
      );
      state._selectedAnswerIndex = null;
      state._hasSubmittedAnswer = false;
      state._lastAnswerWasCorrect = null;
      state._lastCorrectLetter = null;
      state._remainingSeconds = _matchRemainingSecondsForRoom(sourceRoom);
      state._score = sourceRoom == null
          ? 0
          : _matchScoreFromRoom(sourceRoom) ?? state._score;
      state._loadedQuestionIdsKey = _matchQuestionIdsKey(
        sourceRoom?.questionIds,
      );
      state._isLoadingQuestions = false;
      if (state._questions.isEmpty) {
        state._questionsErrorMessage = 'Não encontrei questões disponíveis.';
      }
    });
  } catch (error) {
    if (!state.mounted) return;
    state._update(() {
      state._questionsErrorMessage = humanizeMultiplayerError(
        error,
        fallback: 'Não consegui carregar as questões da partida.',
      );
      state._isLoadingQuestions = false;
    });
  }
}

Future<List<QuestionItem>> _loadMatchQuestionsByRoomIds(
  MultiplayerRoom room,
) async {
  final questionsById = <int, QuestionItem>{
    for (final question in await fetchQuestionsByIds(room.questionIds))
      question.id: question,
  };

  return [
    for (final id in room.questionIds)
      if (questionsById[id] != null) questionsById[id]!,
  ];
}

Future<List<QuestionItem>> _loadMatchFallbackQuestions() async {
  final disciplines = await fetchDisciplines();

  for (final discipline in disciplines) {
    final subcategories = await fetchSubcategories(discipline);
    for (final subcategory in subcategories) {
      if (subcategory.total <= 0) {
        continue;
      }
      final page = await fetchQuestionsPageBySubcategory(
        discipline: discipline,
        subcategory: subcategory.name,
        limit: 10,
      );
      if (page.items.isNotEmpty) {
        return page.items;
      }
    }
  }

  return const <QuestionItem>[];
}

int _resolveInitialMatchQuestionIndex(
  MultiplayerRoom? room,
  List<QuestionItem> loadedQuestions,
) {
  final index = room?.hasMatchQuestions == true
      ? room!.currentQuestionIndex
      : 0;
  if (loadedQuestions.isEmpty || index < 0) {
    return 0;
  }
  return index.clamp(0, loadedQuestions.length - 1);
}
