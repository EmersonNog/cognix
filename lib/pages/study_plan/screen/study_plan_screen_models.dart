part of '../study_plan_screen.dart';

class _StudyPlanDraft {
  const _StudyPlanDraft({
    required this.studyDaysPerWeek,
    required this.minutesPerDay,
    required this.weeklyQuestionsGoal,
    required this.focusMode,
    required this.preferredPeriod,
    required this.priorityDisciplines,
  });

  factory _StudyPlanDraft.fromPlan(StudyPlanData plan) {
    return _StudyPlanDraft(
      studyDaysPerWeek: plan.studyDaysPerWeek,
      minutesPerDay: plan.minutesPerDay,
      weeklyQuestionsGoal: plan.weeklyQuestionsGoal,
      focusMode: plan.focusMode,
      preferredPeriod: plan.preferredPeriod,
      priorityDisciplines: List<String>.from(plan.priorityDisciplines),
    );
  }

  final int studyDaysPerWeek;
  final int minutesPerDay;
  final int weeklyQuestionsGoal;
  final String focusMode;
  final String preferredPeriod;
  final List<String> priorityDisciplines;

  _StudyPlanDraft copyWith({
    int? studyDaysPerWeek,
    int? minutesPerDay,
    int? weeklyQuestionsGoal,
    String? focusMode,
    String? preferredPeriod,
    List<String>? priorityDisciplines,
  }) {
    return _StudyPlanDraft(
      studyDaysPerWeek: studyDaysPerWeek ?? this.studyDaysPerWeek,
      minutesPerDay: minutesPerDay ?? this.minutesPerDay,
      weeklyQuestionsGoal: weeklyQuestionsGoal ?? this.weeklyQuestionsGoal,
      focusMode: focusMode ?? this.focusMode,
      preferredPeriod: preferredPeriod ?? this.preferredPeriod,
      priorityDisciplines:
          priorityDisciplines ?? List<String>.from(this.priorityDisciplines),
    );
  }
}

class _StudyPlanPalette {
  const _StudyPlanPalette({
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.secondary,
  });

  factory _StudyPlanPalette.fromContext(BuildContext context) {
    final colors = context.cognixColors;
    return _StudyPlanPalette(
      surface: colors.surface,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      onSurface: colors.onSurface,
      onSurfaceMuted: colors.onSurfaceMuted,
      primary: colors.primary,
      secondary: colors.secondaryDim,
    );
  }

  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color secondary;
}
