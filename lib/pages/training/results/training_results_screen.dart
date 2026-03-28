import 'package:cognix/widgets/cognix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/training_results_action_buttons.dart';
import 'widgets/training_results_metric_card.dart';
import 'widgets/training_results_pill_tag.dart';
import 'widgets/training_results_score_ring.dart';
import 'widgets/training_results_stat_card.dart';
import 'widgets/training_results_top_icon_button.dart';
import 'widgets/training_results_topic_progress.dart';

class TrainingResultsScreen extends StatelessWidget {
  const TrainingResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF060E20);
    const surfaceContainer = Color(0xFF0F1930);
    const surfaceContainerHigh = Color(0xFF141F38);
    const onSurface = Color(0xFFDEE5FF);
    const onSurfaceMuted = Color(0xFF9AA6C5);
    const primary = Color(0xFFA3A6FF);
    const primaryDim = Color(0xFF6063EE);

    return Scaffold(
      backgroundColor: surface,
      body: CognixPageLayout(
        title: 'Cognix - Resultados',
        backgroundColor: surface,
        topBarColor: surfaceContainerHigh,
        titleColor: onSurface,
        leadingColor: primary,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TrainingResultsTopIconButton(
              icon: Icons.settings_rounded,
              background: surfaceContainer,
              iconColor: onSurfaceMuted,
            ),
            const SizedBox(width: 8),
            TrainingResultsTopIconButton(
              icon: Icons.logout_rounded,
              background: surfaceContainer,
              iconColor: onSurfaceMuted,
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          children: [
            const SizedBox(height: 12),
            TrainingResultsScoreRing(
              score: 15,
              total: 20,
              primary: primary,
              primaryDim: primaryDim,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 16),
            Center(
              child: TrainingResultsPillTag(
                label: 'ACADÊMICO AVANÇADO',
                background: primary.withOpacity(0.18),
                textColor: primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Trabalho exemplar, mestre.\n'
              'Você dominou as profundezas do conhecimento.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Seu desempenho hoje te coloca entre os 15% melhores candidatos '
              'se preparando para a Final de Física Quântica. Continue assim!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TrainingResultsStatCard(
              label: 'TEMPO DECORRIDO',
              value: '14:22',
              subtitle: '4m mais rápido que a média',
              primary: primary,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              icon: Icons.timer_rounded,
              background: surfaceContainer,
            ),
            const SizedBox(height: 16),
            TrainingResultsMetricCard(
              label: 'TAXA DE PRECISÃO',
              value: '75%',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              progress: 0.75,
              background: surfaceContainer,
              icon: Icons.gps_fixed_rounded,
              accentColor: const Color(0xFFEE7FD1),
              valueFontSize: 20,
              barHeight: 3,
              solidFill: true,
            ),
            const SizedBox(height: 16),
            TrainingResultsMetricCard(
              label: 'PONTOS FORTES',
              value: 'Mecânica Quântica',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              progress: 0.6,
              background: surfaceContainer,
              icon: Icons.auto_awesome_rounded,
              accentColor: primary,
              valueFontSize: 13.5,
              barHeight: 3,
            ),
            const SizedBox(height: 18),
            Text(
              'Análise por Tópico',
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            TrainingResultsTopicProgress(
              label: 'Dinâmica de Ondas',
              progress: 1,
              valueLabel: '100%',
              accentColor: primary,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              trackColor: surfaceContainerHigh,
            ),
            const SizedBox(height: 10),
            TrainingResultsTopicProgress(
              label: 'Física de Partículas',
              progress: 0.6,
              valueLabel: '60%',
              accentColor: primary,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              trackColor: surfaceContainerHigh,
            ),
            const SizedBox(height: 10),
            TrainingResultsTopicProgress(
              label: 'Termodinâmica',
              progress: 0.4,
              valueLabel: '40%',
              accentColor: const Color(0xFFEE7FD1),
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              trackColor: surfaceContainerHigh,
            ),
            const SizedBox(height: 18),
            TrainingResultsPrimaryButton(
              label: 'Revisar Todas as Questões',
              background: primary,
              icon: Icons.assignment_rounded,
            ),
            const SizedBox(height: 15),
            TrainingResultsSecondaryButton(
              label: 'Voltar ao Painel',
              background: surfaceContainerHigh,
              icon: Icons.grid_view_rounded,
              onSurfaceMuted: onSurfaceMuted,
            ),
          ],
        ),
      ),
    );
  }
}
