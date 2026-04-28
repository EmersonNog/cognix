part of '../../study_plan_screen.dart';

class _PlanHeroCard extends StatelessWidget {
  const _PlanHeroCard({
    required this.palette,
    required this.configured,
    required this.weeklyCompletionPercent,
    required this.activeDaysValue,
    required this.minutesValue,
    required this.questionsValue,
    required this.updatedAt,
    this.previewMode = false,
    this.onTap,
  });

  final _StudyPlanPalette palette;
  final bool configured;
  final int weeklyCompletionPercent;
  final String activeDaysValue;
  final String minutesValue;
  final String questionsValue;
  final DateTime? updatedAt;
  final bool previewMode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final updatedLabel = previewMode
        ? 'Disponível com assinatura premium.'
        : updatedAt == null
        ? 'Ainda não salvo'
        : 'Atualizado ${updatedAt!.day.toString().padLeft(2, '0')}/${updatedAt!.month.toString().padLeft(2, '0')}';

    final content = Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.surfaceContainerHigh, palette.surfaceContainer],
        ),
        border: Border.all(color: palette.primary.withValues(alpha: 0.16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlanHeroHeader(
              palette: palette,
              configured: configured,
              updatedLabel: updatedLabel,
              weeklyCompletionPercent: weeklyCompletionPercent,
              previewMode: previewMode,
            ),
            const SizedBox(height: 16),
            _PlanProgressBar(
              palette: palette,
              percent: previewMode ? 0 : weeklyCompletionPercent,
            ),
            const SizedBox(height: 14),
            _HeroStatsStrip(
              palette: palette,
              locked: previewMode,
              items: const [
                (icon: Icons.calendar_today_rounded, label: 'dias ativos'),
                (icon: Icons.schedule_rounded, label: 'minutos'),
                (icon: Icons.quiz_rounded, label: 'questões'),
              ],
              values: [activeDaysValue, minutesValue, questionsValue],
            ),
          ],
        ),
      ),
    );

    if (onTap == null) {
      return Material(color: Colors.transparent, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: content,
      ),
    );
  }
}
