part of '../multiplayer_match_screen.dart';

Widget _buildMultiplayerMatchScreen(
  _MultiplayerMatchScreenState state,
  BuildContext context,
) {
  const palette = MultiplayerPalette();
  final currentRoom = state._room;
  final currentQuestion = state._currentQuestion;
  final usesSyncedQuestions = currentRoom?.hasMatchQuestions == true;
  final isFinished = currentRoom?.isFinished == true;

  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;
      await _goHomeFromMatch(state);
    },
    child: Scaffold(
      backgroundColor: palette.surface,
      body: Stack(
        children: [
          MultiplayerScaffold(
            title: isFinished ? 'Fim da partida' : 'Partida iniciada',
            subtitle: isFinished
                ? 'Confira o ranking final da sala.'
                : 'Responda antes do tempo acabar e acompanhe a rodada.',
            leadingIcon: isFinished
                ? Icons.emoji_events_rounded
                : Icons.bolt_rounded,
            palette: palette,
            onBack: () {
              _goHomeFromMatch(state);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                MatchHeader(
                  palette: palette,
                  room: currentRoom,
                  questionIndex: state._questionIndex,
                  totalQuestions: state._questions.length,
                  remainingSeconds: state._remainingSeconds,
                  score: state._score,
                ),
                const SizedBox(height: 16),
                if (isFinished && currentRoom != null)
                  MatchFinishedPanel(palette: palette, room: currentRoom)
                else if (state._isLoadingQuestions)
                  MatchLoadingPanel(palette: palette)
                else if (state._questionsErrorMessage != null ||
                    currentQuestion == null)
                  MatchErrorPanel(
                    palette: palette,
                    message:
                        state._questionsErrorMessage ??
                        'Não há questão carregada para esta rodada.',
                    onRetry: () {
                      _loadMatchQuestions(state);
                    },
                  )
                else
                  MatchQuestionPanel(
                    palette: palette,
                    question: currentQuestion,
                    selectedAnswerIndex: state._selectedAnswerIndex,
                    hasSubmittedAnswer: state._hasSubmittedAnswer,
                    lastAnswerWasCorrect: state._lastAnswerWasCorrect,
                    correctLetter: state._lastCorrectLetter,
                    onSelectAnswer: (index) {
                      _selectMatchAnswer(state, index);
                    },
                  ),
                if (currentRoom != null && !isFinished) ...[
                  const SizedBox(height: 16),
                  MatchParticipantsPanel(palette: palette, room: currentRoom),
                ],
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: isFinished
                      ? () {
                          _goHomeFromMatch(state);
                        }
                      : _resolveMatchButtonAction(
                          state,
                          hasQuestion: currentQuestion != null,
                          isLastQuestion:
                              state._questionIndex >=
                              state._questions.length - 1,
                          usesSyncedQuestions: usesSyncedQuestions,
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: palette.surface,
                    disabledBackgroundColor: palette.surfaceContainerHigh,
                    disabledForegroundColor: palette.onSurfaceMuted,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(
                    isFinished
                        ? Icons.home_rounded
                        : state._hasSubmittedAnswer
                        ? Icons.arrow_forward_rounded
                        : Icons.send_rounded,
                  ),
                  label: Text(
                    isFinished
                        ? 'Voltar para o início'
                        : _resolveMatchButtonLabel(
                            state,
                            isLastQuestion:
                                state._questionIndex >=
                                state._questions.length - 1,
                            usesSyncedQuestions: usesSyncedQuestions,
                          ),
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state._shouldShowConnectionOverlay)
            MultiplayerConnectionOverlay(
              palette: palette,
              title: 'Reconectando a partida...',
              message:
                  'Confira sua internet. Estamos trazendo a rodada de volta para você.',
              icon: Icons.sports_esports_rounded,
              remainingSeconds: state._connectionRemainingSeconds,
            ),
        ],
      ),
    ),
  );
}
