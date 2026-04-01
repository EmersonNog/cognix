import 'package:flutter/material.dart';

import '../../../services/questions/questions_api.dart';
import '../widgets/training_actions.dart';
import '../widgets/training_answer_option.dart';
import '../widgets/training_header.dart';
import 'training_session_question_card.dart';
import '../widgets/training_tip_card.dart';

class TrainingSessionBody extends StatelessWidget {
  const TrainingSessionBody({
    super.key,
    required this.subcategory,
    required this.discipline,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedIndex,
    required this.hasMore,
    required this.isLoadingMore,
    required this.isSubmitting,
    required this.isPaused,
    required this.timeLabel,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onPauseToggle,
    required this.onSelectOption,
    required this.onNext,
    required this.onPrevious,
  });

  final String subcategory;
  final String discipline;
  final QuestionItem question;
  final int currentIndex;
  final int totalQuestions;
  final int? selectedIndex;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSubmitting;
  final bool isPaused;
  final String timeLabel;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final VoidCallback onPauseToggle;
  final ValueChanged<int> onSelectOption;
  final Future<void> Function() onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final isLastVisibleQuestion = currentIndex >= totalQuestions - 1;
    final isNextDisabled = selectedIndex == null || isSubmitting || isLoadingMore;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
      children: [
        TrainingHeader(
          title:
              '${subcategory.toUpperCase()} - QUESTAO ${currentIndex + 1}/$totalQuestions',
          timeLabel: timeLabel,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
          surfaceContainerHigh: surfaceContainerHigh,
          paused: isPaused,
          onPauseToggle: onPauseToggle,
        ),
        const SizedBox(height: 16),
        TrainingSessionQuestionCard(
          discipline: discipline,
          statement: question.statement,
          surfaceContainer: surfaceContainer,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 14),
        for (var i = 0; i < question.alternatives.length; i++) ...[
          GestureDetector(
            onTap: () => onSelectOption(i),
            child: TrainingAnswerOption(
              letter: _optionLetter(i),
              text: question.alternatives[i],
              surfaceContainer: surfaceContainer,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurfaceMuted: onSurfaceMuted,
              onSurface: onSurface,
              primary: primary,
              selected: selectedIndex == i,
            ),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        AbsorbPointer(
          absorbing: isNextDisabled,
          child: Opacity(
            opacity: isNextDisabled ? 0.45 : 1,
            child: GestureDetector(
              onTap: onNext,
              child: TrainingPrimaryButton(
                label: _buildPrimaryLabel(
                  isLastVisibleQuestion: isLastVisibleQuestion,
                  hasMore: hasMore,
                  isLoadingMore: isLoadingMore,
                ),
                primary: primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (currentIndex > 0)
          GestureDetector(
            onTap: onPrevious,
            child: TrainingGhostButton(
              label: 'Questao Anterior',
              surfaceContainerHigh: surfaceContainerHigh,
              onSurfaceMuted: onSurfaceMuted,
            ),
          ),
        const SizedBox(height: 16),
        TrainingTipCard(
          surfaceContainer: surfaceContainer,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
      ],
    );
  }

  String _buildPrimaryLabel({
    required bool isLastVisibleQuestion,
    required bool hasMore,
    required bool isLoadingMore,
  }) {
    if (isLastVisibleQuestion && hasMore) {
      return isLoadingMore ? 'Carregando...' : 'Proxima Questao';
    }
    return currentIndex < totalQuestions - 1
        ? 'Proxima Questao'
        : 'Finalizar Simulado';
  }

  String _optionLetter(int index) {
    const letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    if (index >= 0 && index < letters.length) {
      return letters[index];
    }
    return '${index + 1}';
  }
}
