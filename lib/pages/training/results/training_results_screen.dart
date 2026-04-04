import 'package:cognix/widgets/cognix_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/questions/questions_api.dart';
import '../session/training_session_screen.dart';
import '../session/training_session_storage.dart';
import 'utils/training_results_utils.dart';
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

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF060E20);
    const surfaceContainer = Color(0xFF0F1930);
    const surfaceContainerHigh = Color(0xFF141F38);
    const onSurface = Color(0xFFDEE5FF);
    const onSurfaceMuted = Color(0xFF9AA6C5);
    const primary = Color(0xFFA3A6FF);
    const primaryDim = Color(0xFF6063EE);

    final accuracy = trainingResultsAccuracyRatio(
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
    );
    final accuracyLabel = trainingResultsAccuracyLabel(
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
    );

    final pill = trainingResultsPillLabelForAccuracy(accuracy);

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
          onTap: () => _handleLogout(context),
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
              value: trainingResultsFormatElapsed(elapsed),
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
              label: 'TAXA DE PRECISÃO',
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              decoration: BoxDecoration(
                color: surfaceContainerHigh.withOpacity(0.44),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
              child: Column(
                children: [
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
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: onSurfaceMuted,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Refaça o simulado para treinar de novo, sua nova tentativa entra no seu histórico e pode atualizar seus indicadores.',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.inter(
                            color: onSurfaceMuted,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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

  Future<void> _restartSession() async {
    await clearLocalTrainingSessionState(
      _sessionStateKey,
      discipline: discipline,
      subcategory: subcategory,
    );

    try {
      await clearTrainingSession(
        discipline: discipline,
        subcategory: subcategory,
      );
    } catch (_) {}
  }
}
