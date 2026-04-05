part of 'study_plan_screen.dart';

Widget _buildBodyForState(
  _StudyPlanScreenState state, {
  required _StudyPlanPalette palette,
  required StudyPlanData displayPlan,
}) {
  if (state._isLoading) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
      ),
    );
  }

  if (state._errorMessage != null) {
    return _StudyPlanErrorState(
      palette: palette,
      message: state._errorMessage!,
      onRetry: () => _loadForState(state),
    );
  }

  return _StudyPlanFormContent(
    palette: palette,
    plan: state._plan,
    displayPlan: displayPlan,
    draft: state._draft,
    availableDisciplines: state._availableDisciplines,
    onStudyDaysChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(studyDaysPerWeek: value),
      );
    },
    onMinutesChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(minutesPerDay: value),
      );
    },
    onWeeklyQuestionsChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(weeklyQuestionsGoal: value),
      );
    },
    onFocusModeChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(focusMode: value),
      );
    },
    onPreferredPeriodChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(preferredPeriod: value),
      );
    },
    onDisciplineToggled: (discipline) {
      _toggleDisciplineForState(state, discipline);
    },
  );
}

class _StudyPlanErrorState extends StatelessWidget {
  const _StudyPlanErrorState({
    required this.palette,
    required this.message,
    required this.onRetry,
  });

  final _StudyPlanPalette palette;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_tethering_error_rounded,
              color: palette.primary,
              size: 36,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: palette.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente novamente para abrir seu plano de estudos.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: palette.onSurfaceMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: palette.surfaceContainerHigh,
              ),
              child: const Text('Recarregar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyPlanFormContent extends StatelessWidget {
  const _StudyPlanFormContent({
    required this.palette,
    required this.plan,
    required this.displayPlan,
    required this.draft,
    required this.availableDisciplines,
    required this.onStudyDaysChanged,
    required this.onMinutesChanged,
    required this.onWeeklyQuestionsChanged,
    required this.onFocusModeChanged,
    required this.onPreferredPeriodChanged,
    required this.onDisciplineToggled,
  });

  final _StudyPlanPalette palette;
  final StudyPlanData plan;
  final StudyPlanData displayPlan;
  final _StudyPlanDraft draft;
  final List<String> availableDisciplines;
  final ValueChanged<int> onStudyDaysChanged;
  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<int> onWeeklyQuestionsChanged;
  final ValueChanged<String> onFocusModeChanged;
  final ValueChanged<String> onPreferredPeriodChanged;
  final ValueChanged<String> onDisciplineToggled;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
      children: [
        _PlanHeroCard(
          palette: palette,
          configured: plan.configured,
          weeklyCompletionPercent: displayPlan.weeklyCompletionPercent,
          activeDaysValue:
              '${displayPlan.activeDaysThisWeek}/${displayPlan.activeDaysGoal}',
          minutesValue:
              '${displayPlan.completedMinutesThisWeek}/${displayPlan.weeklyMinutesTarget}',
          questionsValue:
              '${displayPlan.answeredQuestionsThisWeek}/${displayPlan.weeklyQuestionsGoal}',
          updatedAt: plan.updatedAt,
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Ritmo semanal',
          subtitle:
              'Escolha em quantos dias voce quer distribuir seus estudos.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List<Widget>.generate(7, (index) {
              final value = index + 1;
              return StudyPlanChoiceChip(
                label: '$value dias',
                selected: draft.studyDaysPerWeek == value,
                onTap: () => onStudyDaysChanged(value),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Carga diaria',
          subtitle: 'Defina o tempo medio que voce quer dedicar por dia ativo.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _StudyPlanScreenState._minutesOptions.map((value) {
              return StudyPlanChoiceChip(
                label: '$value min',
                selected: draft.minutesPerDay == value,
                onTap: () => onMinutesChanged(value),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Meta de questoes',
          subtitle: 'Use uma meta semanal clara para acompanhar sua evolucao.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _StudyPlanScreenState._questionOptions.map((value) {
              return StudyPlanChoiceChip(
                label: '$value questoes',
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
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Foco do plano',
          subtitle: 'Escolha o criterio que mais importa para sua semana.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StudyPlanFocusCard(
                      title: 'Constancia',
                      subtitle: 'Valoriza dias ativos e rotina consistente.',
                      icon: Icons.local_fire_department_rounded,
                      selected: draft.focusMode == 'constancia',
                      onTap: () => onFocusModeChanged('constancia'),
                      surfaceContainerHigh: palette.surfaceContainerHigh,
                      onSurface: palette.onSurface,
                      onSurfaceMuted: palette.onSurfaceMuted,
                      primary: palette.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StudyPlanFocusCard(
                      title: 'Revisao',
                      subtitle:
                          'Puxa mais peso para tempo de estudo acumulado.',
                      icon: Icons.menu_book_rounded,
                      selected: draft.focusMode == 'revisao',
                      onTap: () => onFocusModeChanged('revisao'),
                      surfaceContainerHigh: palette.surfaceContainerHigh,
                      onSurface: palette.onSurface,
                      onSurfaceMuted: palette.onSurfaceMuted,
                      primary: palette.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StudyPlanFocusCard(
                title: 'Desempenho',
                subtitle:
                    'Da mais importancia ao volume de questoes resolvidas.',
                icon: Icons.stacked_line_chart_rounded,
                selected: draft.focusMode == 'desempenho',
                onTap: () => onFocusModeChanged('desempenho'),
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
                primary: palette.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Melhor periodo',
          subtitle: 'Escolha quando voce costuma render melhor.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _StudyPlanScreenState._periodOptions.entries.map((entry) {
              return StudyPlanChoiceChip(
                label: entry.value,
                selected: draft.preferredPeriod == entry.key,
                onTap: () => onPreferredPeriodChanged(entry.key),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Disciplinas prioritarias',
          subtitle:
              'Escolha ate 4 frentes para ganhar mais foco no seu planejamento.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableDisciplines.map((discipline) {
              return StudyPlanChoiceChip(
                label: discipline,
                selected: draft.priorityDisciplines.contains(discipline),
                onTap: () => onDisciplineToggled(discipline),
                primary: palette.primary,
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
