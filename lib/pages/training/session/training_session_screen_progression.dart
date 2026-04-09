part of 'training_session_screen.dart';

Future<void> _finishSessionForState(
  _TrainingSessionScreenState state, {
  required int totalQuestionsLoaded,
}) async {
  state._stopwatch.stop();
  state._ticker?.cancel();
  state._sessionCompleted = true;

  final answered = state._isCorrectByQuestionId.values
      .where((value) => value != null)
      .length;
  final correct = state._isCorrectByQuestionId.values
      .where((value) => value == true)
      .length;
  final wrong = state._isCorrectByQuestionId.values
      .where((value) => value == false)
      .length;
  final totalQuestions = state._totalAvailable ?? totalQuestionsLoaded;
  final result = buildCompletedTrainingSessionResult(
    totalQuestions: totalQuestions,
    answeredQuestions: answered,
    correctAnswers: correct,
    wrongAnswers: wrong,
    elapsedSeconds: _currentElapsedForState(state).inSeconds,
  );

  await _saveCompletedSessionStateForState(state, result);
  if (!state.mounted) return;
  _navigateToResultsForState(state, result);
}

Future<void> _handleNextQuestionForState(
  _TrainingSessionScreenState state, {
  required QuestionItem question,
  required int visibleQuestionsCount,
}) async {
  final selectedOptionIndex = state._selections[question.id];
  if (selectedOptionIndex == null) return;

  final letter = _optionLetterForIndex(selectedOptionIndex);
  final lastSubmitted = state._lastSubmittedLetterByQuestionId[question.id];

  if (lastSubmitted == letter) {
    _clearAnswerFeedbackForState(state);
    await _advanceAfterAnswerForState(state, visibleQuestionsCount);
    return;
  }

  state._update(() => state._submitting = true);
  try {
    final result = await submitAttempt(
      questionId: question.id,
      selectedLetter: letter,
      discipline: state.widget.discipline,
      subcategory: state.widget.subcategory,
    );
    state._isCorrectByQuestionId[question.id] = result.isCorrect;
    state._lastSubmittedLetterByQuestionId[question.id] = letter;

    final correctOptionIndex = _optionIndexFromLetterForValue(
      result.correctLetter,
      question.alternatives.length,
    );
    if (correctOptionIndex != null) {
      state._correctOptionIndexByQuestionId[question.id] = correctOptionIndex;
    }

    if (state.mounted) {
      state._update(() {
        state._showingAnswerFeedback = true;
        state._feedbackQuestionId = question.id;
        state._correctOptionIndex = correctOptionIndex;
        state._lastAnswerWasCorrect = result.isCorrect;
      });
    }

    profileRefreshNotifier.markDirty();
    if (!state._sessionCompleted) {
      _saveSessionStateForState(state);
    }
  } catch (_) {
    if (!state.mounted) return;
    showCognixMessage(
      state.context,
      'Não foi possível salvar sua resposta. Tente novamente.',
      type: CognixMessageType.error,
    );
  } finally {
    if (state.mounted) {
      state._update(() => state._submitting = false);
    }
  }
}

Future<void> _advanceAfterAnswerForState(
  _TrainingSessionScreenState state,
  int visibleQuestionsCount,
) async {
  if (state._currentIndex < state._questions.length - 1) {
    state._update(() => state._currentIndex += 1);
    _maybePrefetchForState(state);
    _saveSessionStateForState(state);
    return;
  }

  if (_hasMoreQuestionsForState(state)) {
    try {
      await _loadMoreQuestionsForState(state);
    } catch (_) {
      if (!state.mounted) return;
      showCognixMessage(
        state.context,
        'Não foi possível carregar mais questões.',
        type: CognixMessageType.error,
      );
      return;
    }

    if (!state.mounted) return;
    if (state._currentIndex < state._questions.length - 1) {
      state._update(() => state._currentIndex += 1);
      _maybePrefetchForState(state);
      _saveSessionStateForState(state);
      return;
    }
  }

  if (state.mounted) {
    await _finishSessionForState(
      state,
      totalQuestionsLoaded: visibleQuestionsCount,
    );
  }
}

void _navigateToResultsForState(
  _TrainingSessionScreenState state,
  TrainingCompletedSessionResult result,
) {
  Navigator.of(state.context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => TrainingResultsScreen(
        discipline: state.widget.discipline,
        subcategory: state.widget.subcategory,
        totalQuestions: result.totalQuestions,
        answeredQuestions: result.answeredQuestions,
        correctAnswers: result.correctAnswers,
        wrongAnswers: result.wrongAnswers,
        elapsed: Duration(seconds: result.elapsedSeconds),
      ),
    ),
  );
}

String _optionLetterForIndex(int index) {
  const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  if (index >= 0 && index < letters.length) {
    return letters[index];
  }
  return '${index + 1}';
}

int? _optionIndexFromLetterForValue(String? letter, int optionsCount) {
  if (letter == null || letter.trim().isEmpty) {
    return null;
  }

  final normalized = letter.trim().toUpperCase();
  for (var i = 0; i < optionsCount; i++) {
    if (_optionLetterForIndex(i) == normalized) {
      return i;
    }
  }
  return null;
}

void _clearAnswerFeedbackForState(_TrainingSessionScreenState state) {
  if (!state.mounted) return;
  state._update(() {
    state._showingAnswerFeedback = false;
    state._feedbackQuestionId = null;
    state._correctOptionIndex = null;
    state._lastAnswerWasCorrect = null;
  });
}
