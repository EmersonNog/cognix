part of '../performance_sections.dart';

class EfficiencySection extends StatelessWidget {
  const EfficiencySection({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PerformanceSectionHeader(
          title: 'Eficiência e ritmo',
          subtitle:
              'Mais do que volume, essa leitura mostra a qualidade do seu tempo e das suas respostas.',
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
                  label: 'Acertos',
                  value: previewMode ? '' : '${view.totalCorrect}',
                  helper: previewMode
                      ? _lockedHelper
                      : view.questionsAnswered == 0
                      ? 'Suas respostas certas aparecem aqui.'
                      : '${view.accuracyPercent.toStringAsFixed(0)}% do volume virou acerto.',
                  icon: Icons.check_circle_rounded,
                  accent: const Color(0xFF4ED7A6),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  isLocked: previewMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PerformanceMetricCard(
                  label: 'Erros úteis',
                  value: previewMode ? '' : '${view.errorCount}',
                  helper: previewMode
                      ? _lockedHelper
                      : view.errorCount == 0
                      ? 'Nenhum erro relevante no historico.'
                      : 'Pontos com mais espaço para revisão.',
                  icon: Icons.refresh_rounded,
                  accent: const Color(0xFFFF9D6C),
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
                  label: 'Tempo por questão',
                  value: previewMode
                      ? ''
                      : performanceFormatSeconds(
                          view.averageSecondsPerQuestion,
                        ),
                  helper: previewMode
                      ? _lockedHelper
                      : view.questionsAnswered == 0
                      ? 'A média aparece com suas respostas.'
                      : 'Tempo médio gasto por questão.',
                  icon: Icons.timer_outlined,
                  accent: const Color(0xFF7C9BFF),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  isLocked: previewMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PerformanceMetricCard(
                  label: view.hasWeeklyRhythmBase
                      ? 'Média semanal'
                      : 'Volume inicial',
                  value: previewMode
                      ? ''
                      : view.hasWeeklyRhythmBase
                      ? (view.weeklyQuestionAverage == 0
                            ? '0'
                            : view.weeklyQuestionAverage.toStringAsFixed(1))
                      : '${view.questionsAnswered}',
                  helper: previewMode
                      ? _lockedHelper
                      : view.questionsAnswered == 0
                      ? 'Sem questões recentes para calcular.'
                      : view.hasWeeklyRhythmBase
                      ? 'Questões respondidas por semana, em média.'
                      : 'Questões acumuladas nos primeiros dias.',
                  icon: Icons.bolt_rounded,
                  accent: const Color(0xFFFFC857),
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
