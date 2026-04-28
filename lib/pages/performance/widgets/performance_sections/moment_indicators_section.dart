part of '../performance_sections.dart';

class MomentIndicatorsSection extends StatelessWidget {
  const MomentIndicatorsSection({
    super.key,
    required this.view,
    required this.onSurface,
    required this.onSurfaceMuted,
    this.previewMode = false,
  });

  final PerformanceViewData view;
  final Color onSurface;
  final Color onSurfaceMuted;
  final bool previewMode;

  static const String _lockedHelper = 'Disponível com assinatura premium.';

  @override
  Widget build(BuildContext context) {
    final strongestSubcategory = view.strongestSubcategory;
    final weakestSubcategory = view.weakestSubcategory;
    final hasComparisonBase = view.hasSubcategoryComparisonBase;
    final hasAttentionBase = view.hasAttentionBase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PerformanceSectionHeader(
          title: 'Indicadores do momento',
          subtitle:
              'Leituras do seu histórico para enxergar intensidade, distribuição e cobertura da sua rotina.',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 14),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PerformanceMetricCard(
                  label: 'Pontos de atenção',
                  value: previewMode
                      ? ''
                      : hasAttentionBase
                      ? '${view.attentionSubcategoriesCount}'
                      : '--',
                  helper: previewMode
                      ? _lockedHelper
                      : !hasAttentionBase || weakestSubcategory == null
                      ? 'Ainda não há disciplinas com base suficiente para identificar alertas.'
                      : view.attentionSubcategoriesCount == 0
                      ? 'Nenhuma disciplina ficou abaixo de ${view.attentionAccuracyThreshold.toStringAsFixed(0)}% de acerto.'
                      : performanceAttentionHelper(
                          subcategory: weakestSubcategory.subcategory,
                        ),
                  icon: Icons.warning_amber_rounded,
                  accent: const Color(0xFF7C9BFF),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  isLocked: previewMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PerformanceMetricCard(
                  label: 'Maior acerto',
                  value: previewMode
                      ? ''
                      : !hasComparisonBase || strongestSubcategory == null
                      ? '--'
                      : '${strongestSubcategory.accuracyPercent.toStringAsFixed(0)}%',
                  helper: previewMode
                      ? _lockedHelper
                      : !hasComparisonBase || strongestSubcategory == null
                      ? 'Ainda não há disciplinas com base suficiente para comparar.'
                      : performanceSubcategoryHelper(
                          discipline: strongestSubcategory.discipline,
                          subcategory: strongestSubcategory.subcategory,
                          totalAttempts: strongestSubcategory.totalAttempts,
                        ),
                  icon: Icons.emoji_events_rounded,
                  accent: const Color(0xFFC28BFF),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  isLocked: previewMode,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PerformanceMetricCard(
                  label: 'Tempo por simulado',
                  value: previewMode
                      ? ''
                      : performanceFormatSeconds(view.secondsPerSimulation),
                  helper: previewMode
                      ? _lockedHelper
                      : view.completedSessions == 0
                      ? 'Conclua simulados para liberar essa média.'
                      : 'Média sobre ${view.completedSessions} simulados concluídos.',
                  icon: Icons.flag_rounded,
                  accent: const Color(0xFFFFC857),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  isLocked: previewMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PerformanceMetricCard(
                  label: 'Menor acerto',
                  value: previewMode
                      ? ''
                      : !hasComparisonBase || weakestSubcategory == null
                      ? '--'
                      : '${weakestSubcategory.accuracyPercent.toStringAsFixed(0)}%',
                  helper: previewMode
                      ? _lockedHelper
                      : !hasComparisonBase || weakestSubcategory == null
                      ? 'Ainda não há disciplinas com base suficiente para comparar.'
                      : performanceSubcategoryHelper(
                          discipline: weakestSubcategory.discipline,
                          subcategory: weakestSubcategory.subcategory,
                          totalAttempts: weakestSubcategory.totalAttempts,
                        ),
                  icon: Icons.troubleshoot_rounded,
                  accent: const Color(0xFF4ED7A6),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  isLocked: previewMode,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
