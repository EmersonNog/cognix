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
              'Leituras derivadas da API para enxergar intensidade, distribui\u00E7\u00E3o e cobertura da sua rotina.',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: PerformanceMetricCard(
                label: 'Pontos de aten\u00E7\u00E3o',
                value: '${view.attentionSubcategoriesCount}',
                helper: weakestSubcategory == null
                    ? 'Ainda n\u00E3o h\u00E1 subcategorias com base suficiente para identificar alertas.'
                    : view.attentionSubcategoriesCount == 0
                    ? 'Nenhuma subcategoria ficou abaixo de ${view.attentionAccuracyThreshold.toStringAsFixed(0)}% de acerto'
                    : '${performanceShortSubcategoryName(weakestSubcategory.subcategory)} \u00E9 a mais sens\u00EDvel agora.',
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
                    ? 'Ainda n\u00E3o h\u00E1 subcategorias com base suficiente para comparar.'
                    : '${performanceShortSubcategoryName(strongestSubcategory.subcategory)}\n${performanceShortDisciplineName(strongestSubcategory.discipline)} \u2022 ${performanceAttemptsLabel(strongestSubcategory.totalAttempts)}',
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
                    ? 'Conclua simulados para liberar essa m\u00E9dia.'
                    : 'M\u00E9dia sobre ${view.completedSessions} simulados conclu\u00EDdos.',
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
                    ? 'Ainda n\u00E3o h\u00E1 subcategorias com base suficiente para comparar'
                    : '${performanceShortSubcategoryName(weakestSubcategory.subcategory)}\n${performanceShortDisciplineName(weakestSubcategory.discipline)} \u2022 ${performanceAttemptsLabel(weakestSubcategory.totalAttempts)}',
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
              'Aqui o foco \u00E9 peso relativo: onde seu volume j\u00E1 tem tra\u00E7\u00E3o e onde ainda falta presen\u00E7a.',
          onSurface: onSurface,
          onSurfaceMuted: onSurfaceMuted,
        ),
        const SizedBox(height: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PerformanceSpotlightCard(
              title: 'Maior presen\u00E7a',
              value: view.leader == null
                  ? 'Sem dados'
                  : performanceShortDisciplineName(view.leader!.discipline),
              subtitle: view.leader == null
                  ? 'Assim que voc\u00EA responder quest\u00F5es, essa leitura aparece.'
                  : '${performanceDisciplineShare(view.leader!.count, view.totalQuestions)} do seu hist\u00F3rico est\u00E1 aqui.',
              accent: view.leader == null
                  ? const Color(0xFF7C88A8)
                  : performanceDisciplineAccent(view.leader!.discipline),
              icon: Icons.trending_up_rounded,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            PerformanceSpotlightCard(
              title: 'Mais espa\u00E7o para crescer',
              value: view.underused == null
                  ? 'Sem leitura'
                  : performanceShortDisciplineName(view.underused!.discipline),
              subtitle: view.underused == null
                  ? 'Ainda n\u00E3o h\u00E1 base suficiente para comparar \u00E1reas.'
                  : '${performanceDisciplineShare(view.underused!.count, view.totalQuestions)} do volume atual passa por essa \u00E1rea.',
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
          title: 'Efici\u00EAncia e ritmo',
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
                label: 'Erros \u00FAteis',
                value: '${view.errorCount}',
                helper: view.errorCount == 0
                    ? 'Nenhum erro relevante no hist\u00F3rico.'
                    : 'Pontos com mais espa\u00E7o para revis\u00E3o.',
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
                label: 'Tempo por quest\u00E3o',
                value: performanceFormatSeconds(view.averageSecondsPerQuestion),
                helper: view.questionsAnswered == 0
                    ? 'A m\u00E9dia aparece com suas respostas.'
                    : 'Tempo m\u00E9dio gasto por quest\u00E3o.',
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
                    ? 'M\u00E9dia semanal'
                    : 'Volume inicial',
                value: view.hasWeeklyRhythmBase
                    ? (view.weeklyQuestionAverage == 0
                          ? '0'
                          : view.weeklyQuestionAverage.toStringAsFixed(1))
                    : '${view.questionsAnswered}',
                helper: view.questionsAnswered == 0
                    ? 'Sem quest\u00F5es recentes para calcular.'
                    : view.hasWeeklyRhythmBase
                    ? 'Quest\u00F5es respondidas por semana, em m\u00E9dia.'
                    : 'Quest\u00F5es acumuladas nos seus primeiros dias.',
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
