part of '../performance_sections.dart';

class DisciplineSection extends StatelessWidget {
  const DisciplineSection({
    super.key,
    required this.view,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final PerformanceViewData view;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final hasDistributionBase = view.hasDisciplineDistributionBase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PerformanceSectionHeader(
          title: 'Leitura por disciplina',
          subtitle:
              'Aqui o foco é peso relativo: onde seu volume já tem tração e onde ainda falta presença.',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PerformanceSpotlightCard(
              title: 'Maior presença',
              value: !hasDistributionBase || view.leader == null
                  ? 'Sem dados'
                  : performanceShortDisciplineName(view.leader!.discipline),
              subtitle: !hasDistributionBase || view.leader == null
                  ? 'Responda mais questões em pelo menos duas áreas para liberar essa leitura.'
                  : '${performanceDisciplineShare(view.leader!.count, view.totalQuestions)} do seu histórico está aqui.',
              accent: !hasDistributionBase || view.leader == null
                  ? const Color(0xFF7C88A8)
                  : performanceDisciplineAccent(view.leader!.discipline),
              icon: Icons.trending_up_rounded,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            PerformanceSpotlightCard(
              title: 'Mais espaço para crescer',
              value: !hasDistributionBase || view.underused == null
                  ? 'Sem leitura'
                  : performanceShortDisciplineName(view.underused!.discipline),
              subtitle: !hasDistributionBase || view.underused == null
                  ? 'Ainda não há base suficiente para comparar áreas.'
                  : '${performanceDisciplineShare(view.underused!.count, view.totalQuestions)} do volume atual passa por essa área.',
              accent: !hasDistributionBase || view.underused == null
                  ? const Color(0xFF7C88A8)
                  : performanceDisciplineAccent(view.underused!.discipline),
              icon: Icons.radar_rounded,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
          ],
        ),
        if (hasDistributionBase && view.disciplines.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colors.onSurfaceMuted.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              children: [
                for (
                  var index = 0;
                  index < view.disciplines.length;
                  index++
                ) ...[
                  PerformanceDisciplineBreakdownRow(
                    label: performanceShortDisciplineName(
                      view.disciplines[index].discipline,
                    ),
                    count: view.disciplines[index].count,
                    share: view.disciplines[index].count / view.totalQuestions,
                    accent: performanceDisciplineAccent(
                      view.disciplines[index].discipline,
                    ),
                    onSurface: onSurface,
                    onSurfaceMuted: onSurfaceMuted,
                  ),
                  if (index != view.disciplines.length - 1)
                    const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 22),
      ],
    );
  }
}
