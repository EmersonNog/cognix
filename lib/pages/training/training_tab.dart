import 'package:flutter/material.dart';

import 'widgets/training_actions.dart';
import 'widgets/training_answer_option.dart';
import 'widgets/training_context_card.dart';
import 'widgets/training_figure_card.dart';
import 'widgets/training_header.dart';
import 'widgets/training_prompt_card.dart';
import 'widgets/training_tip_card.dart';

class TrainingTab extends StatelessWidget {
  const TrainingTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
      children: [
        TrainingHeader(
          title: 'MECÂNICA QUÂNTICA • QUESTÃO 07/20',
          timeLabel: '14:42',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
          surfaceContainerHigh: surfaceContainerHigh,
        ),
        const SizedBox(height: 18),
        TrainingFigureCard(
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
          primary: primary,
        ),
        const SizedBox(height: 16),
        TrainingContextCard(
          surfaceContainer: surfaceContainer,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 18),
        TrainingPromptCard(
          surfaceContainer: surfaceContainer,
          onSurface: onSurface,
        ),
        const SizedBox(height: 14),
        TrainingAnswerOption(
          letter: 'A',
          text: 'O Princípio da incerteza de Heisenberg',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurfaceMuted: onSurfaceMuted,
          onSurface: onSurface,
          primary: primary,
        ),
        const SizedBox(height: 10),
        TrainingAnswerOption(
          letter: 'B',
          text: 'Efeito de Tunelamento Quântico',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurfaceMuted: onSurfaceMuted,
          onSurface: onSurface,
          primary: primary,
          selected: true,
        ),
        const SizedBox(height: 10),
        TrainingAnswerOption(
          letter: 'C',
          text: 'Princípio de Exclusão de Pauli',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurfaceMuted: onSurfaceMuted,
          onSurface: onSurface,
          primary: primary,
        ),
        const SizedBox(height: 10),
        TrainingAnswerOption(
          letter: 'D',
          text: 'Fator de Desdobramento de Zeeman',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurfaceMuted: onSurfaceMuted,
          onSurface: onSurface,
          primary: primary,
        ),
        const SizedBox(height: 10),
        TrainingAnswerOption(
          letter: 'E',
          text: 'Ressonância do Magneton de Bohr',
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainerHigh,
          onSurfaceMuted: onSurfaceMuted,
          onSurface: onSurface,
          primary: primary,
        ),
        const SizedBox(height: 18),
        TrainingPrimaryButton(
          label: 'Enviar Resposta',
          primary: primary,
        ),
        const SizedBox(height: 10),
        TrainingGhostButton(
          label: 'Pular Questão',
          surfaceContainerHigh: surfaceContainerHigh,
          onSurfaceMuted: onSurfaceMuted,
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
}
