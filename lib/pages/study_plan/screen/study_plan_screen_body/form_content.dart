part of '../../study_plan_screen.dart';

class _StudyPlanFormContent extends StatelessWidget {
  const _StudyPlanFormContent({
    this.leading,
    required this.palette,
    required this.plan,
    required this.displayPlan,
    required this.draft,
    required this.availableDisciplines,
    required this.onStudyDaysChanged,
    required this.onMinutesChanged,
    required this.onWeeklyQuestionsChanged,
    required this.onFocusModeChanged,
    required this.onPreferredPeriodChanged,
    required this.onDisciplineToggled,
    this.previewMode = false,
    this.onLockedTap,
  });

  final Widget? leading;
  final _StudyPlanPalette palette;
  final StudyPlanData plan;
  final StudyPlanData displayPlan;
  final _StudyPlanDraft draft;
  final List<String> availableDisciplines;
  final ValueChanged<int> onStudyDaysChanged;
  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<int> onWeeklyQuestionsChanged;
  final ValueChanged<String> onFocusModeChanged;
  final ValueChanged<String> onPreferredPeriodChanged;
  final ValueChanged<String> onDisciplineToggled;
  final bool previewMode;
  final VoidCallback? onLockedTap;

  @override
  Widget build(BuildContext context) {
    final selectedDisciplines = draft.priorityDisciplines.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
      children: [
        if (leading != null) ...[leading!, const SizedBox(height: 16)],
        _PlanHeroCard(
          palette: palette,
          configured: plan.configured,
          weeklyCompletionPercent: displayPlan.weeklyCompletionPercent,
          activeDaysValue:
              '${displayPlan.activeDaysThisWeek}/${displayPlan.activeDaysGoal}',
          minutesValue:
              '${displayPlan.completedMinutesThisWeek}/${displayPlan.weeklyMinutesTarget}',
          questionsValue:
              '${displayPlan.answeredQuestionsThisWeek}/${displayPlan.weeklyQuestionsGoal}',
          updatedAt: plan.updatedAt,
          previewMode: previewMode,
          onTap: previewMode ? onLockedTap : null,
        ),
        const SizedBox(height: 16),
        _buildStructureSection(),
        const SizedBox(height: 16),
        _buildStrategySection(),
        const SizedBox(height: 16),
        _buildPrioritiesSection(selectedDisciplines),
      ],
    );
  }
}
