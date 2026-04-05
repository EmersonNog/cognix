import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/study_plan/study_plan_api.dart';

class HomeDailyRhythmCard extends StatelessWidget {
  const HomeDailyRhythmCard({
    super.key,
    required this.studyPlanFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.userName,
  });

  final Future<StudyPlanData> studyPlanFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final firstName = userName.trim().split(RegExp(r'\s+')).first;

    return FutureBuilder<StudyPlanData>(
      future: studyPlanFuture,
      builder: (context, snapshot) {
        final plan = snapshot.data ?? const StudyPlanData.empty();
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final completionPercent = plan.weeklyCompletionPercent.clamp(0, 100);
        final insightLabel = _buildWeeklyInsightLabel(plan);
        final buttonLabel = plan.configured ? 'Abrir plano' : 'Montar plano';

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surfaceContainer,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLANO DA SEMANA',
                style: GoogleFonts.plusJakartaSans(
                  color: onSurfaceMuted,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ola, bom ver voce de\nnovo, ',
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    TextSpan(
                      text: '$firstName.',
                      style: GoogleFonts.manrope(
                        color: primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isLoading ? '--%' : '$completionPercent%',
                    style: GoogleFonts.manrope(
                      color: onSurface,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      plan.configured
                          ? 'da sua meta semanal\natingida'
                          : 'do seu plano semanal\nconfigurado',
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  widthFactor: isLoading ? 0.0 : completionPercent / 100,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: primaryDim.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.insights_rounded,
                      color: primary,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      insightLabel,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('study-plan'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    buttonLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String _buildWeeklyInsightLabel(StudyPlanData plan) {
  if (!plan.configured) {
    return 'Monte um plano para transformar sua rotina em uma meta semanal clara.';
  }

  final remainingActiveDays = (plan.activeDaysGoal - plan.activeDaysThisWeek)
      .clamp(0, plan.activeDaysGoal);
  if (remainingActiveDays > 0) {
    return remainingActiveDays == 1
        ? 'Falta 1 dia ativo para bater sua frequencia semanal.'
        : 'Faltam $remainingActiveDays dias ativos para bater sua frequencia semanal.';
  }

  final remainingMinutes =
      (plan.weeklyMinutesTarget - plan.completedMinutesThisWeek).clamp(
        0,
        plan.weeklyMinutesTarget,
      );
  if (remainingMinutes > 0) {
    return remainingMinutes == 1
        ? 'Falta 1 minuto para concluir sua carga semanal.'
        : 'Faltam $remainingMinutes min para concluir sua carga semanal.';
  }

  final remainingQuestions =
      (plan.weeklyQuestionsGoal - plan.answeredQuestionsThisWeek).clamp(
        0,
        plan.weeklyQuestionsGoal,
      );
  if (remainingQuestions > 0) {
    return remainingQuestions == 1
        ? 'Falta 1 questão para fechar sua meta semanal.'
        : 'Faltam $remainingQuestions questões para fechar sua meta semanal.';
  }

  return 'Sua meta semanal esta em dia. Aproveite para revisar ou avançar.';
}
