part of '../study_plan_screen.dart';

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
    final selectedDisciplines = draft.priorityDisciplines.length;

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
          title: 'Estrutura da semana',
          subtitle:
              'Organize a base do plano definindo frequência, carga diaria e melhor janela do dia.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: _StudyPlanSubsectionGrid(
            children: [
              StudyPlanSubsection(
                title: 'Ritmo semanal',
                subtitle:
                    'Escolha em quantos dias você quer distribuir seus estudos.',
                surfaceContainerHigh: palette.surfaceContainerHigh,
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
              StudyPlanSubsection(
                title: 'Carga diária',
                subtitle:
                    'Defina o tempo médio que você quer dedicar por dia ativo.',
                surfaceContainerHigh: palette.surfaceContainerHigh,
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
              StudyPlanSubsection(
                title: 'Melhor período',
                subtitle: 'Escolha quando você costuma render melhor.',
                trailing: StudyPlanInfoBadge(
                  label: _preferredPeriodLabel(draft.preferredPeriod),
                  primary: palette.primary,
                  onSurface: palette.onSurface,
                ),
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _StudyPlanScreenState._periodOptions.entries.map((
                    entry,
                  ) {
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Meta e estratégia',
          subtitle:
              'Deixe a semana com um critério claro para acompanhar evolução e constância.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: _StudyPlanSubsectionGrid(
            children: [
              StudyPlanSubsection(
                title: 'Meta de questões',
                subtitle:
                    'Use uma meta semanal clara para medir seu volume de prática.',
                surfaceContainerHigh: palette.surfaceContainerHigh,
                onSurface: palette.onSurface,
                onSurfaceMuted: palette.onSurfaceMuted,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _StudyPlanScreenState._questionOptions.map((value) {
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
              StudyPlanSubsection(
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
                              title: 'Revisao',
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
        ),
        const SizedBox(height: 16),
        StudyPlanSection(
          title: 'Prioridades da semana',
          subtitle:
              'Escolha as disciplinas que merecem mais atenção dentro do seu planejamento.',
          surfaceContainer: palette.surfaceContainer,
          onSurface: palette.onSurface,
          onSurfaceMuted: palette.onSurfaceMuted,
          child: StudyPlanSubsection(
            title: 'Disciplinas prioritárias',
            subtitle:
                'Você pode selecionar até 4 frentes para dar mais foco ao plano.',
            trailing: StudyPlanInfoBadge(
              label: '$selectedDisciplines/4 selecionadas',
              primary: palette.primary,
              onSurface: palette.onSurface,
            ),
            surfaceContainerHigh: palette.surfaceContainerHigh,
            onSurface: palette.onSurface,
            onSurfaceMuted: palette.onSurfaceMuted,
            child: availableDisciplines.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: palette.surface.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Text(
                      'Ainda não encontramos disciplinas disponíveis para priorizar.',
                      style: GoogleFonts.inter(
                        color: palette.onSurfaceMuted,
                        fontSize: 12.2,
                        height: 1.45,
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableDisciplines.map((discipline) {
                      return StudyPlanChoiceChip(
                        label: discipline,
                        selected: draft.priorityDisciplines.contains(
                          discipline,
                        ),
                        onTap: () => onDisciplineToggled(discipline),
                        primary: palette.primary,
                        surfaceContainerHigh: palette.surfaceContainerHigh,
                        onSurface: palette.onSurface,
                        onSurfaceMuted: palette.onSurfaceMuted,
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}

String _focusModeLabel(String focusMode) {
  switch (focusMode) {
    case 'constancia':
      return 'Constância';
    case 'revisao':
      return 'Revisão';
    case 'desempenho':
      return 'Desempenho';
    default:
      return 'Flexível';
  }
}

String _preferredPeriodLabel(String preferredPeriod) =>
    _StudyPlanScreenState._periodOptions[preferredPeriod] ?? 'Flexivel';

class _StudyPlanSubsectionGrid extends StatelessWidget {
  const _StudyPlanSubsectionGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth >= 860
            ? 3
            : constraints.maxWidth >= 560
            ? 2
            : 1;
        final spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (columnCount - 1))) /
            columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) {
            return SizedBox(width: itemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}
