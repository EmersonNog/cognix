import 'package:flutter/material.dart';
import '../utils/performance_utils.dart';
import 'performance_widgets.dart';

class MomentIndicatorsSection extends StatelessWidget {
  const MomentIndicatorsSection({
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
    final strongestSubcategory = view.strongestSubcategory;
    final weakestSubcategory = view.weakestSubcategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PerformanceSectionHeader(
          title: 'Indicadores do momento',
          subtitle:
              'Leituras derivadas da API para enxergar intensidade, distribuição e cobertura da sua rotina.',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: PerformanceMetricCard(
                label: 'Pontos de atenção',
                value: '${view.attentionSubcategoriesCount}',
                helper: weakestSubcategory == null
                    ? 'Ainda não há disciplinas com base suficiente para identificar alertas.'
                    : view.attentionSubcategoriesCount == 0
                    ? 'Nenhuma disciplina ficou abaixo de ${view.attentionAccuracyThreshold.toStringAsFixed(0)}% de acerto'
                    : '${performanceShortSubcategoryName(weakestSubcategory.subcategory)} é a mais sensível agora.',
                icon: Icons.warning_amber_rounded,
                accent: const Color(0xFF7C9BFF),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PerformanceMetricCard(
                label: 'Maior acerto',
                value: strongestSubcategory == null
                    ? '--'
                    : '${strongestSubcategory.accuracyPercent.toStringAsFixed(0)}%',
                helper: strongestSubcategory == null
                    ? 'Ainda não há disciplinas com base suficiente para comparar.'
                    : '${performanceShortSubcategoryName(strongestSubcategory.subcategory)}\n${performanceShortDisciplineName(strongestSubcategory.discipline)} • ${performanceAttemptsLabel(strongestSubcategory.totalAttempts)}',
                icon: Icons.emoji_events_rounded,
                accent: const Color(0xFFC28BFF),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PerformanceMetricCard(
                label: 'Tempo por simulado',
                value: performanceFormatSeconds(view.secondsPerSimulation),
                helper: view.completedSessions == 0
                    ? 'Conclua simulados para liberar essa média.'
                    : 'Média sobre ${view.completedSessions} simulados concluídos.',
                icon: Icons.flag_rounded,
                accent: const Color(0xFFFFC857),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PerformanceMetricCard(
                label: 'Menor acerto',
                value: weakestSubcategory == null
                    ? '--'
                    : '${weakestSubcategory.accuracyPercent.toStringAsFixed(0)}%',
                helper: weakestSubcategory == null
                    ? 'Ainda não há disciplinas com base suficiente para comparar'
                    : '${performanceShortSubcategoryName(weakestSubcategory.subcategory)}\n${performanceShortDisciplineName(weakestSubcategory.discipline)} • ${performanceAttemptsLabel(weakestSubcategory.totalAttempts)}',
                icon: Icons.troubleshoot_rounded,
                accent: const Color(0xFF4ED7A6),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

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
              value: view.leader == null
                  ? 'Sem dados'
                  : performanceShortDisciplineName(view.leader!.discipline),
              subtitle: view.leader == null
                  ? 'Assim que você responder questões, essa leitura aparece.'
                  : '${performanceDisciplineShare(view.leader!.count, view.totalQuestions)} do seu histórico está aqui.',
              accent: view.leader == null
                  ? const Color(0xFF7C88A8)
                  : performanceDisciplineAccent(view.leader!.discipline),
              icon: Icons.trending_up_rounded,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            PerformanceSpotlightCard(
              title: 'Mais espaço para crescer',
              value: view.underused == null
                  ? 'Sem leitura'
                  : performanceShortDisciplineName(view.underused!.discipline),
              subtitle: view.underused == null
                  ? 'Ainda não há base suficiente para comparar áreas.'
                  : '${performanceDisciplineShare(view.underused!.count, view.totalQuestions)} do volume atual passa por essa área.',
              accent: view.underused == null
                  ? const Color(0xFF7C88A8)
                  : performanceDisciplineAccent(view.underused!.discipline),
              icon: Icons.radar_rounded,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
          ],
        ),
        if (view.disciplines.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF101A33),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.045)),
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

class EfficiencySection extends StatelessWidget {
  const EfficiencySection({
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
        Row(
          children: [
            Expanded(
              child: PerformanceMetricCard(
                label: 'Acertos',
                value: '${view.totalCorrect}',
                helper: view.questionsAnswered == 0
                    ? 'Suas respostas certas aparecem aqui.'
                    : '${view.accuracyPercent.toStringAsFixed(0)}% do volume virou acerto.',
                icon: Icons.check_circle_rounded,
                accent: const Color(0xFF4ED7A6),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PerformanceMetricCard(
                label: 'Erros úteis',
                value: '${view.errorCount}',
                helper: view.errorCount == 0
                    ? 'Nenhum erro relevante no histórico.'
                    : 'Pontos com mais espaço para revisão.',
                icon: Icons.refresh_rounded,
                accent: const Color(0xFFFF9D6C),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PerformanceMetricCard(
                label: 'Tempo por questão',
                value: performanceFormatSeconds(view.averageSecondsPerQuestion),
                helper: view.questionsAnswered == 0
                    ? 'A média aparece com suas respostas.'
                    : 'Tempo médio gasto por questão.',
                icon: Icons.timer_outlined,
                accent: const Color(0xFF7C9BFF),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PerformanceMetricCard(
                label: view.hasWeeklyRhythmBase
                    ? 'Média semanal'
                    : 'Volume inicial',
                value: view.hasWeeklyRhythmBase
                    ? (view.weeklyQuestionAverage == 0
                          ? '0'
                          : view.weeklyQuestionAverage.toStringAsFixed(1))
                    : '${view.questionsAnswered}',
                helper: view.questionsAnswered == 0
                    ? 'Sem questões recentes para calcular.'
                    : view.hasWeeklyRhythmBase
                    ? 'Questões respondidas por semana, em média.'
                    : 'Questões acumuladas nos seus primeiros dias.',
                icon: Icons.bolt_rounded,
                accent: const Color(0xFFFFC857),
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}
