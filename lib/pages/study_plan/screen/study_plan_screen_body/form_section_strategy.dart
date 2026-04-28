part of '../../study_plan_screen.dart';

extension _StudyPlanStrategySection on _StudyPlanFormContent {
  Widget _buildStrategySection() {
    return StudyPlanSection(
      title: 'Meta e estrategia',
      subtitle:
          'Deixe a semana com um critério claro para acompanhar evolução e constância.',
      surfaceContainer: palette.surfaceContainer,
      onSurface: palette.onSurface,
      onSurfaceMuted: palette.onSurfaceMuted,
      child: _StudyPlanSubsectionGrid(
        children: [
          previewMode
              ? _buildLockedSubsection(
                  title: 'Meta de questões',
                  subtitle:
                      'Use uma meta semanal clara para medir seu volume de prática.',
                )
              : StudyPlanSubsection(
                  title: 'Meta de questões',
                  subtitle:
                      'Use uma meta semanal clara para medir seu volume de prática.',
                  surfaceContainerHigh: palette.surfaceContainerHigh,
                  onSurface: palette.onSurface,
                  onSurfaceMuted: palette.onSurfaceMuted,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _StudyPlanScreenState._questionOptions.map((
                      value,
                    ) {
                      return StudyPlanChoiceChip(
                        label: '$value questões',
                        selected: draft.weeklyQuestionsGoal == value,
                        onTap: () => onWeeklyQuestionsChanged(value),
                        primary: palette.primary,
                        surfaceContainerHigh: palette.surfaceContainerHigh,
                        onSurface: palette.onSurface,
                        onSurfaceMuted: palette.onSurfaceMuted,
                      );
                    }).toList(),
                  ),
                ),
          previewMode
              ? _buildLockedSubsection(
                  title: 'Foco do plano',
                  subtitle:
                      'Escolha o critério que deve puxar o destaque da sua semana.',
                )
              : StudyPlanSubsection(
                  title: 'Foco do plano',
                  subtitle:
                      'Escolha o critério que deve puxar o destaque da sua semana.',
                  trailing: StudyPlanInfoBadge(
                    label: _focusModeLabel(draft.focusMode),
                    primary: palette.primary,
                    onSurface: palette.onSurface,
                  ),
                  surfaceContainerHigh: palette.surfaceContainerHigh,
                  onSurface: palette.onSurface,
                  onSurfaceMuted: palette.onSurfaceMuted,
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: StudyPlanFocusCard(
                                title: 'Constância',
                                subtitle:
                                    'Valoriza dias ativos e rotina consistente.',
                                icon: Icons.local_fire_department_rounded,
                                selected: draft.focusMode == 'constancia',
                                onTap: () => onFocusModeChanged('constancia'),
                                surfaceContainerHigh:
                                    palette.surfaceContainerHigh,
                                onSurface: palette.onSurface,
                                onSurfaceMuted: palette.onSurfaceMuted,
                                primary: palette.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StudyPlanFocusCard(
                                title: 'Revisão',
                                subtitle:
                                    'Puxa mais peso para tempo de estudo acumulado.',
                                icon: Icons.menu_book_rounded,
                                selected: draft.focusMode == 'revisao',
                                onTap: () => onFocusModeChanged('revisao'),
                                surfaceContainerHigh:
                                    palette.surfaceContainerHigh,
                                onSurface: palette.onSurface,
                                onSurfaceMuted: palette.onSurfaceMuted,
                                primary: palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: StudyPlanFocusCard(
                          title: 'Desempenho',
                          subtitle:
                              'Da mais importância ao volume de questões resolvidas.',
                          icon: Icons.stacked_line_chart_rounded,
                          selected: draft.focusMode == 'desempenho',
                          onTap: () => onFocusModeChanged('desempenho'),
                          surfaceContainerHigh: palette.surfaceContainerHigh,
                          onSurface: palette.onSurface,
                          onSurfaceMuted: palette.onSurfaceMuted,
                          primary: palette.primary,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
