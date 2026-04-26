part of '../multiplayer_match_screen.dart';

Future<void> _goHomeFromMatch(_MultiplayerMatchScreenState state) async {
  if (state._isLeaving) {
    return;
  }

  final shouldLeave = await _confirmMatchLeave(state);
  if (!shouldLeave || !state.mounted) {
    return;
  }

  final room = state._room;
  state._update(() => state._isLeaving = true);

  try {
    if (room != null && !room.isFinished) {
      final wsResult = await state._roomSync.leaveRoom();
      if (wsResult == null) {
        await leaveMultiplayerRoom(room.id);
      }
    }
  } catch (error) {
    if (!isMultiplayerNotFoundError(error)) {
      _showMatchError(state, error);
      if (state.mounted) {
        state._update(() => state._isLeaving = false);
      }
      return;
    }
  }

  if (!state.mounted) return;
  state._roomSync.stopPolling();
  Navigator.of(state.context).pushNamedAndRemoveUntil('home', (route) => false);
}

Future<bool> _confirmMatchLeave(_MultiplayerMatchScreenState state) async {
  final room = state._room;
  if (room == null || room.isFinished || !room.isInProgress) {
    return true;
  }

  final isHost = state._isCurrentUserHost;
  return showMultiplayerLeaveConfirmation(
    state.context,
    palette: MultiplayerPalette.fromContext(state.context),
    title: isHost ? 'Encerrar partida?' : 'Sair da partida?',
    message: isHost
        ? 'Ao sair agora, todos os jogadores serão desconectados desta partida imediatamente.'
        : 'Você vai deixar a partida atual e não poderá continuar desta rodada de onde parou.',
    confirmLabel: isHost ? 'Encerrar agora' : 'Sair agora',
    icon: isHost ? Icons.cancel_schedule_send_rounded : Icons.logout_rounded,
    accentColor: isHost ? const Color(0xFFB42318) : const Color(0xFFF4A261),
    eyebrow: isHost ? 'Afeta toda a sala' : 'Você sairá sozinho.',
    cancelLabel: 'Continuar jogando',
  );
}

void _selectMatchAnswer(_MultiplayerMatchScreenState state, int index) {
  if (state._hasSubmittedAnswer ||
      state._isSubmittingAnswer ||
      state._remainingSeconds <= 0) {
    return;
  }

  state._update(() => state._selectedAnswerIndex = index);
}

Future<void> _submitMatchAnswer(_MultiplayerMatchScreenState state) async {
  final question = state._currentQuestion;
  final selectedIndex = state._selectedAnswerIndex;
  final previousQuestionIndex = state._questionIndex;
  if (question == null ||
      selectedIndex == null ||
      state._hasSubmittedAnswer ||
      state._isSubmittingAnswer) {
    return;
  }

  final selectedAlternative = question.alternatives[selectedIndex];
  state._update(() => state._isSubmittingAnswer = true);
  try {
    final room = state._room;
    final usesSyncedQuestions = room?.hasMatchQuestions == true;
    final bool? wasCorrect;
    final String? correctLetter;
    final int? score;

    if (usesSyncedQuestions) {
      final result =
          await state._roomSync.submitAnswer(
            questionId: question.id,
            selectedLetter: selectedAlternative.letter,
          ) ??
          await submitMultiplayerAnswer(
            roomId: room!.id,
            questionId: question.id,
            selectedLetter: selectedAlternative.letter,
          );
      wasCorrect = result.isCorrect;
      correctLetter = result.correctLetter;
      score = result.score;
      if (state.mounted) {
        state._update(() {
          state._score =
              result.score ?? _matchScoreFromRoom(result.room) ?? state._score;
        });
      }
    } else {
      final attempt = await submitAttempt(
        questionId: question.id,
        selectedLetter: selectedAlternative.letter,
        discipline: question.discipline,
        subcategory: question.subcategory,
      );
      wasCorrect = attempt.isCorrect;
      correctLetter = attempt.correctLetter;
      score = null;
    }

    if (!state.mounted) return;
    final roundAdvanced =
        usesSyncedQuestions &&
        (state._questionIndex != previousQuestionIndex ||
            (state._room?.isFinished ?? false));
    state._update(() {
      if (roundAdvanced) {
        state._selectedAnswerIndex = null;
        state._lastAnswerWasCorrect = null;
        state._lastCorrectLetter = null;
        state._hasSubmittedAnswer = state._room?.isFinished ?? false;
      } else {
        state._lastAnswerWasCorrect = wasCorrect;
        state._lastCorrectLetter = correctLetter;
        state._hasSubmittedAnswer = true;
      }
      if (score != null) {
        state._score = score;
      } else if (!usesSyncedQuestions && wasCorrect == true) {
        state._score += 100;
      }
    });
  } catch (error) {
    _showMatchError(state, error);
  } finally {
    if (state.mounted) {
      state._update(() => state._isSubmittingAnswer = false);
    }
  }
}

void _goToNextMatchQuestion(_MultiplayerMatchScreenState state) {
  if (!state._hasSubmittedAnswer ||
      state._questionIndex >= state._questions.length - 1) {
    return;
  }

  state._update(() {
    state._questionIndex++;
    state._selectedAnswerIndex = null;
    state._hasSubmittedAnswer = false;
    state._lastAnswerWasCorrect = null;
    state._lastCorrectLetter = null;
    state._remainingSeconds = 60;
  });
}

void _notifyMatchAndGoHome(
  _MultiplayerMatchScreenState state, {
  required String message,
  required Color backgroundColor,
}) {
  showCognixMessage(state.context, message, type: CognixMessageType.error);

  Future<void>.delayed(const Duration(milliseconds: 350), () {
    if (!state.mounted) return;
    Navigator.of(
      state.context,
    ).pushNamedAndRemoveUntil('home', (route) => false);
  });
}

void _showMatchError(_MultiplayerMatchScreenState state, Object error) {
  if (!state.mounted) return;
  showCognixMessage(
    state.context,
    humanizeMultiplayerError(error),
    type: CognixMessageType.error,
  );
}

VoidCallback? _resolveMatchButtonAction(
  _MultiplayerMatchScreenState state, {
  required bool hasQuestion,
  required bool isLastQuestion,
  required bool usesSyncedQuestions,
}) {
  if (!hasQuestion || state._isLoadingQuestions || state._isSubmittingAnswer) {
    return null;
  }
  if (state._hasSubmittedAnswer) {
    if (usesSyncedQuestions) {
      return null;
    }
    return isLastQuestion ? null : () => _goToNextMatchQuestion(state);
  }
  if (state._selectedAnswerIndex == null || state._remainingSeconds <= 0) {
    return null;
  }
  return () {
    _submitMatchAnswer(state);
  };
}

String _resolveMatchButtonLabel(
  _MultiplayerMatchScreenState state, {
  required bool isLastQuestion,
  required bool usesSyncedQuestions,
}) {
  if (state._isSubmittingAnswer) {
    return 'Enviando...';
  }
  if (state._remainingSeconds <= 0 && !state._hasSubmittedAnswer) {
    return 'Tempo esgotado';
  }
  if (state._hasSubmittedAnswer) {
    if (usesSyncedQuestions) {
      return 'Aguardando rodada';
    }
    return isLastQuestion ? 'Fim das questões' : 'Próxima questão';
  }
  return 'Enviar resposta';
}
