import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/study_plan/study_plan_api.dart';

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
        final summaryLabel = plan.configured
            ? '${plan.activeDaysThisWeek} de ${plan.studyDaysPerWeek} dias ativos na semana'
            : 'Monte, organize e acompanhe seu plano de estudos da semana.';
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
                'RITMO DIARIO',
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: primaryDim.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.event_note_rounded,
                        color: primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        summaryLabel,
                        style: GoogleFonts.inter(
                          color: onSurfaceMuted,
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
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
