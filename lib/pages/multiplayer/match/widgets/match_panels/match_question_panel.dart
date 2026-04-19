part of '../multiplayer_match_panels.dart';

class MatchQuestionPanel extends StatelessWidget {
  const MatchQuestionPanel({
    super.key,
    required this.palette,
    required this.question,
    required this.selectedAnswerIndex,
    required this.hasSubmittedAnswer,
    required this.lastAnswerWasCorrect,
    required this.correctLetter,
    required this.onSelectAnswer,
  });

  final MultiplayerPalette palette;
  final QuestionItem question;
  final int? selectedAnswerIndex;
  final bool hasSubmittedAnswer;
  final bool? lastAnswerWasCorrect;
  final String? correctLetter;
  final ValueChanged<int> onSelectAnswer;

  @override
  Widget build(BuildContext context) {
    final correctOptionIndex = _correctOptionIndex();

    return MultiplayerPanel(
      palette: palette,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrainingSessionQuestionCard(
            discipline: question.discipline,
            statement: question.statement,
            alternativesIntroduction: question.alternativesIntroduction,
            surfaceContainer: palette.surfaceContainerHigh,
            onSurface: palette.onSurface,
            onSurfaceMuted: palette.onSurfaceMuted,
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < question.alternatives.length; i++) ...[
            Builder(
              builder: (context) {
                final alternative = question.alternatives[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: hasSubmittedAnswer ? null : () => onSelectAnswer(i),
                  child: TrainingAnswerOption(
                    letter: alternative.letter,
                    text: alternative.text,
                    attachmentUrl: alternative.fileUrl,
                    attachmentLabel: _attachmentLabel(alternative.fileUrl),
                    surfaceContainer: palette.surfaceContainer,
                    surfaceContainerHigh: palette.surfaceContainerHigh,
                    onSurfaceMuted: palette.onSurfaceMuted,
                    onSurface: palette.onSurface,
                    primary: palette.primary,
                    selected: selectedAnswerIndex == i,
                    isDisabled: hasSubmittedAnswer,
                    showSelectedCorrect:
                        hasSubmittedAnswer &&
                        selectedAnswerIndex == i &&
                        lastAnswerWasCorrect == true,
                    showSelectedIncorrect:
                        hasSubmittedAnswer &&
                        selectedAnswerIndex == i &&
                        lastAnswerWasCorrect == false,
                    showCorrectReveal:
                        hasSubmittedAnswer &&
                        lastAnswerWasCorrect == false &&
                        correctOptionIndex == i,
                  ),
                );
              },
            ),
            if (i < question.alternatives.length - 1)
              const SizedBox(height: 10),
          ],
          if (hasSubmittedAnswer) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.lock_rounded, color: palette.primary, size: 17),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _feedbackMessage(lastAnswerWasCorrect),
                    style: GoogleFonts.inter(
                      color: palette.onSurfaceMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int? _correctOptionIndex() {
    final resolvedCorrectLetter = correctLetter ?? question.answerKey;
    final normalized = resolvedCorrectLetter?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return question.alternatives.indexWhere(
      (item) => item.letter.trim().toUpperCase() == normalized,
    );
  }

  String _feedbackMessage(bool? wasCorrect) {
    if (wasCorrect == true) {
      return 'Resposta correta. Aguarde a próxima rodada.';
    }
    if (wasCorrect == false) {
      return 'Resposta registrada. Confira a alternativa correta e avance.';
    }
    return 'Resposta registrada. Aguarde os outros jogadores.';
  }

  String? _attachmentLabel(String? fileUrl) {
    final value = fileUrl?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return value;
  }
}
