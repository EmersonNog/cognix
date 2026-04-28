part of '../../study_plan_screen.dart';

extension _StudyPlanPrioritiesSection on _StudyPlanFormContent {
  Widget _buildPrioritiesSection(int selectedDisciplines) {
    return StudyPlanSection(
      title: 'Prioridades da semana',
      subtitle:
          'Escolha as áreas que merecem mais atenção dentro do seu planejamento.',
      surfaceContainer: palette.surfaceContainer,
      onSurface: palette.onSurface,
      onSurfaceMuted: palette.onSurfaceMuted,
      child: previewMode
          ? _buildLockedSubsection(
              title: 'Áreas prioritárias',
              subtitle:
                  'Você pode selecionar até 4 frentes para dar mais foco ao plano.',
            )
          : StudyPlanSubsection(
              title: 'Áreas prioritárias',
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
    );
  }
}
