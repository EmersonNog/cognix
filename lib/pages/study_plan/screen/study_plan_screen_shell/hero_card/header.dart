part of '../../../study_plan_screen.dart';

class _PlanHeroHeader extends StatelessWidget {
  const _PlanHeroHeader({
    required this.palette,
    required this.configured,
    required this.updatedLabel,
    required this.weeklyCompletionPercent,
    this.previewMode = false,
  });

  final _StudyPlanPalette palette;
  final bool configured;
  final String updatedLabel;
  final int weeklyCompletionPercent;
  final bool previewMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                previewMode
                    ? 'PLANO DE ESTUDOS'
                    : configured
                    ? 'SEU PLANO DA SEMANA'
                    : 'NOVO PLANO',
                style: GoogleFonts.plusJakartaSans(
                  color: palette.onSurfaceMuted,
                  fontSize: 10.5,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                previewMode
                    ? 'Acompanhe seu ritmo e suas metas da semana'
                    : configured
                    ? 'Seu progresso contra a meta da semana'
                    : 'Monte uma rotina realista para acompanhar daqui em diante',
                style: GoogleFonts.manrope(
                  color: palette.onSurface,
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                updatedLabel,
                style: GoogleFonts.inter(
                  color: palette.onSurfaceMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _PlanPercentBadge(
          palette: palette,
          percent: weeklyCompletionPercent,
          locked: previewMode,
        ),
      ],
    );
  }
}

class _PlanPercentBadge extends StatelessWidget {
  const _PlanPercentBadge({
    required this.palette,
    required this.percent,
    this.locked = false,
  });

  final _StudyPlanPalette palette;
  final int percent;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: palette.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.primary.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: locked
            ? Icon(
                Icons.lock_rounded,
                color: palette.primary,
                size: 24,
              )
            : Text(
                '$percent%',
                style: GoogleFonts.manrope(
                  color: palette.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
