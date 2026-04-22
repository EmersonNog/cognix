part of '../training_session_screen.dart';

Future<void> _restoreOrLoadForState(_TrainingSessionScreenState state) async {
  try {
    final restored = await _restoreSessionStateForState(state);
    if (state._completedSessionResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!state.mounted || state._completedSessionResult == null) return;
        _navigateToResultsForState(state, state._completedSessionResult!);
      });
      return;
    }

    if (!restored) {
      await _loadInitialQuestionsForState(state);
    }
    _startTimerForState(state);
  } catch (error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.mounted) return;
      showCognixMessage(
        state.context,
        error.toString(),
        type: CognixMessageType.error,
      );
    });
    rethrow;
  }
}

Map<String, dynamic> _buildSessionPayloadForState(
  _TrainingSessionScreenState state, {
  required bool includeQuestions,
}) {
  return buildTrainingSessionPayload(
    discipline: state.widget.discipline,
    subcategory: state.widget.subcategory,
    currentIndex: state._currentIndex,
    questions: state._questions,
    selections: state._selections,
    lastSubmittedByQuestionId: state._lastSubmittedLetterByQuestionId,
    isCorrectByQuestionId: state._isCorrectByQuestionId,
    correctOptionIndexByQuestionId: state._correctOptionIndexByQuestionId,
    elapsedSeconds: _currentElapsedForState(state).inSeconds,
    paused: state._paused,
    totalAvailable: state._totalAvailable,
    offset: state._offset,
    includeQuestions: includeQuestions,
    showingAnswerFeedback: state._showingAnswerFeedback,
    feedbackQuestionId: state._feedbackQuestionId,
    correctOptionIndex: state._correctOptionIndex,
    lastAnswerWasCorrect: state._lastAnswerWasCorrect,
  );
}

Future<void> _saveSessionStateForState(
  _TrainingSessionScreenState state,
) async {
  if (!state.mounted || state._questions.isEmpty || state._sessionCompleted) {
    return;
  }

  final payload = _buildSessionPayloadForState(state, includeQuestions: true);
  await writeLocalTrainingSessionState(
    _TrainingSessionScreenState._sessionStateKey,
    payload,
  );
  _maybeSyncRemoteForState(state);
}

Future<bool> _handleBackNavigationForState(
  _TrainingSessionScreenState state,
) async {
  await _persistSessionImmediatelyForState(state);
  return true;
}

Future<void> _persistSessionImmediatelyForState(
  _TrainingSessionScreenState state,
) async {
  if (state._questions.isEmpty ||
      state._completedSessionResult != null ||
      state._sessionCompleted) {
    return;
  }

  final localPayload = _buildSessionPayloadForState(
    state,
    includeQuestions: true,
  );
  await writeLocalTrainingSessionState(
    _TrainingSessionScreenState._sessionStateKey,
    localPayload,
  );

  try {
    await saveRemoteTrainingSessionState(
      discipline: state.widget.discipline,
      subcategory: state.widget.subcategory,
      payload: _buildSessionPayloadForState(state, includeQuestions: false),
    );
    state._lastRemoteSyncAt = DateTime.now();
  } catch (_) {}
}

Future<void> _saveCompletedSessionStateForState(
  _TrainingSessionScreenState state,
  TrainingCompletedSessionResult result,
) async {
  final payload = buildCompletedTrainingSessionPayload(
    discipline: state.widget.discipline,
    subcategory: state.widget.subcategory,
    result: result,
  );
  await writeLocalTrainingSessionState(
    _TrainingSessionScreenState._sessionStateKey,
    payload,
  );
  try {
    await saveRemoteTrainingSessionState(
      discipline: state.widget.discipline,
      subcategory: state.widget.subcategory,
      payload: payload,
    );
  } catch (_) {}
}

Future<bool> _restoreSessionStateForState(
  _TrainingSessionScreenState state,
) async {
  TrainingSessionRestoreOutcome? outcome;
  try {
    if (state.mounted) {
      state._update(() => state._restoringSession = true);
    }
    outcome = await restoreTrainingSessionSnapshot(
      sessionKey: _TrainingSessionScreenState._sessionStateKey,
      discipline: state.widget.discipline,
      subcategory: state.widget.subcategory,
    );
  } finally {
    if (state.mounted) {
      state._update(() => state._restoringSession = false);
    }
  }

  if (outcome == null) {
    return false;
  }

  if (outcome.completedResult != null) {
    state._completedSessionResult = outcome.completedResult;
    return true;
  }

  final restoredState = outcome.restoredState;
  if (restoredState == null) {
    return false;
  }

  final applied = _applySessionStateForState(state, restoredState);
  if (applied) {
    await _saveSessionStateForState(state);
    state._restoredNoticeShown = true;
  }
  return applied;
}

bool _applySessionStateForState(
  _TrainingSessionScreenState state,
  Map<String, dynamic> decoded,
) {
  final restored = parseTrainingRestoredSessionData(
    decoded,
    fallbackSubcategory: state.widget.subcategory,
    fallbackDiscipline: state.widget.discipline,
  );
  if (restored == null) {
    return false;
  }

  state._questions
    ..clear()
    ..addAll(restored.questions);
  state._loadedIds
    ..clear()
    ..addAll(restored.questions.map((e) => e.id));

  state._currentIndex = restored.currentIndex;
  state._totalAvailable = restored.totalAvailable;
  state._offset = restored.offset;

  state._selections
    ..clear()
    ..addAll(restored.selections);

  state._lastSubmittedLetterByQuestionId
    ..clear()
    ..addAll(restored.lastSubmittedByQuestionId);

  state._isCorrectByQuestionId
    ..clear()
    ..addAll(restored.isCorrectByQuestionId);
  state._correctOptionIndexByQuestionId
    ..clear()
    ..addAll(restored.correctOptionIndexByQuestionId);

  state._paused = restored.paused;
  state._showingAnswerFeedback = restored.showingAnswerFeedback;
  state._feedbackQuestionId = restored.feedbackQuestionId;
  state._correctOptionIndex = restored.correctOptionIndex;
  state._lastAnswerWasCorrect = restored.lastAnswerWasCorrect;
  state._elapsedOffset = Duration(seconds: restored.elapsedSeconds);
  state._stopwatch
    ..stop()
    ..reset();
  if (state._paused) {
    state._stopwatch.stop();
  } else {
    state._stopwatch.start();
  }

  return true;
}

Future<void> _maybeSyncRemoteForState(_TrainingSessionScreenState state) async {
  final now = DateTime.now();
  if (state._lastRemoteSyncAt != null &&
      now.difference(state._lastRemoteSyncAt!).inSeconds < 15) {
    return;
  }

  state._lastRemoteSyncAt = now;
  try {
    await saveRemoteTrainingSessionState(
      discipline: state.widget.discipline,
      subcategory: state.widget.subcategory,
      payload: _buildSessionPayloadForState(state, includeQuestions: false),
    );
  } catch (_) {}
}
