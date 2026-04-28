part of '../../study_plan_screen.dart';

extension _StudyPlanStructureSection on _StudyPlanFormContent {
  Widget _buildStructureSection() {
    return StudyPlanSection(
      title: 'Estrutura da semana',
      subtitle:
          'Organize a base do plano definindo frequência, carga diária e melhor janela do dia.',
      surfaceContainer: palette.surfaceContainer,
      onSurface: palette.onSurface,
      onSurfaceMuted: palette.onSurfaceMuted,
      child: _StudyPlanSubsectionGrid(
        children: [
          previewMode
              ? _buildLockedSubsection(
                  title: 'Ritmo semanal',
                  subtitle:
                      'Escolha em quantos dias você quer distribuir seus estudos.',
                )
              : StudyPlanSubsection(
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
          previewMode
              ? _buildLockedSubsection(
                  title: 'Carga diária',
                  subtitle:
                      'Defina o tempo médio que você quer dedicar por dia ativo.',
                )
              : StudyPlanSubsection(
                  title: 'Carga diária',
                  subtitle:
                      'Defina o tempo médio que você quer dedicar por dia ativo.',
                  surfaceContainerHigh: palette.surfaceContainerHigh,
                  onSurface: palette.onSurface,
                  onSurfaceMuted: palette.onSurfaceMuted,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _StudyPlanScreenState._minutesOptions.map((
                      value,
                    ) {
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
          previewMode
              ? _buildLockedSubsection(
                  title: 'Melhor período',
                  subtitle: 'Escolha quando você costuma render melhor.',
                )
              : StudyPlanSubsection(
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
    );
  }
}
