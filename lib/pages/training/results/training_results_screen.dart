import 'dart:convert';

import 'package:cognix/widgets/cognix_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/questions/questions_api.dart';
import '../session/training_session_screen.dart';
import 'widgets/training_results_action_buttons.dart';
import 'widgets/training_results_metric_card.dart';
import 'widgets/training_results_pill_tag.dart';
import 'widgets/training_results_score_ring.dart';
import 'widgets/training_results_stat_card.dart';
import 'widgets/training_results_top_icon_button.dart';

class TrainingResultsScreen extends StatelessWidget {
  const TrainingResultsScreen({
    super.key,
    required this.discipline,
    required this.subcategory,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.elapsed,
  });

  final String discipline;
  final String subcategory;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final Duration elapsed;
  static const _sessionStateKey = 'training_session_state';

  static const _pillThresholds = <_PillThreshold>[
    _PillThreshold(0.9, 'IMPECAVEL'),
    _PillThreshold(0.8, 'MODO MESTRE'),
    _PillThreshold(0.7, 'MANDANDO BEM'),
    _PillThreshold(0.6, 'BOM RITMO'),
    _PillThreshold(0.5, 'EM EVOLUCAO'),
    _PillThreshold(-1, 'PRECISA PRATICAR'),
  ];

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF060E20);
    const surfaceContainer = Color(0xFF0F1930);
    const surfaceContainerHigh = Color(0xFF141F38);
    const onSurface = Color(0xFFDEE5FF);
    const onSurfaceMuted = Color(0xFF9AA6C5);
    const primary = Color(0xFFA3A6FF);
    const primaryDim = Color(0xFF6063EE);

    final accuracy = totalQuestions == 0
        ? 0.0
        : correctAnswers / totalQuestions;
    final accuracyLabel =
        '${(accuracy * 100).clamp(0, 100).toStringAsFixed(0)}%';

    final pill = _pillLabelForAccuracy(accuracy);

    return Scaffold(
      backgroundColor: surface,
      body: CognixPageLayout(
        title: 'Cognix - Resultados',
        backgroundColor: surface,
        topBarColor: surfaceContainerHigh,
        titleColor: onSurface,
        leadingColor: primary,
        trailing: TrainingResultsTopIconButton(
          icon: Icons.logout_rounded,
          background: surfaceContainer,
          iconColor: onSurfaceMuted,
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          children: [
            const SizedBox(height: 12),
            TrainingResultsScoreRing(
              score: correctAnswers,
              total: totalQuestions,
              primary: primary,
              primaryDim: primaryDim,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
            ),
            const SizedBox(height: 16),
            Center(
              child: TrainingResultsPillTag(
                label: pill,
                background: primary.withOpacity(0.18),
                textColor: primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Simulado finalizado.',
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
              '$discipline • $subcategory',
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
              value: _formatElapsed(elapsed),
              subtitle:
                  '$answeredQuestions/$totalQuestions questões respondidas',
              primary: primary,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              icon: Icons.timer_rounded,
              background: surfaceContainer,
            ),
            const SizedBox(height: 16),
            TrainingResultsMetricCard(
              label: 'TAXA DE PRECISAO',
              value: accuracyLabel,
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              progress: accuracy,
              background: surfaceContainer,
              icon: Icons.gps_fixed_rounded,
              accentColor: const Color(0xFFEE7FD1),
              valueFontSize: 20,
              barHeight: 3,
              solidFill: true,
            ),
            const SizedBox(height: 16),
            TrainingResultsMetricCard(
              label: 'ACERTOS',
              value: '$correctAnswers',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              progress: totalQuestions == 0
                  ? 0
                  : correctAnswers / totalQuestions,
              background: surfaceContainer,
              icon: Icons.check_circle_rounded,
              accentColor: primary,
              valueFontSize: 13.5,
              barHeight: 3,
            ),
            const SizedBox(height: 16),
            TrainingResultsMetricCard(
              label: 'ERROS',
              value: '$wrongAnswers',
              onSurface: onSurface,
              onSurfaceMuted: onSurfaceMuted,
              progress: totalQuestions == 0 ? 0 : wrongAnswers / totalQuestions,
              background: surfaceContainer,
              icon: Icons.cancel_rounded,
              accentColor: const Color(0xFFEE7FD1),
              valueFontSize: 13.5,
              barHeight: 3,
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () async {
                await _restartSession();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => TrainingSessionScreen(
                      title: subcategory,
                      discipline: discipline,
                      subcategory: subcategory,
                      surfaceContainer: surfaceContainer,
                      surfaceContainerHigh: surfaceContainerHigh,
                      onSurface: onSurface,
                      onSurfaceMuted: onSurfaceMuted,
                      primary: primary,
                    ),
                  ),
                );
              },
              child: TrainingResultsPrimaryButton(
                label: 'Refazer Simulado',
                background: primary,
                icon: Icons.refresh_rounded,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: TrainingResultsSecondaryButton(
                label: 'Voltar ao Painel',
                background: surfaceContainerHigh,
                icon: Icons.grid_view_rounded,
                onSurfaceMuted: onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatElapsed(Duration elapsed) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = elapsed.inHours;
    if (hours > 0) {
      final hh = hours.toString().padLeft(2, '0');
      return '$hh:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  String _pillLabelForAccuracy(double accuracy) {
    for (final threshold in _pillThresholds) {
      if (accuracy >= threshold.minAccuracy) {
        return threshold.label;
      }
    }
    return _pillThresholds.last.label;
  }

  Future<void> _restartSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionStateKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map &&
            decoded['discipline'] == discipline &&
            decoded['subcategory'] == subcategory) {
          await prefs.remove(_sessionStateKey);
        }
      } catch (_) {
        await prefs.remove(_sessionStateKey);
      }
    }

    try {
      await clearTrainingSession(
        discipline: discipline,
        subcategory: subcategory,
      );
    } catch (_) {}
  }
}

class _PillThreshold {
  const _PillThreshold(this.minAccuracy, this.label);

  final double minAccuracy;
  final String label;
}
