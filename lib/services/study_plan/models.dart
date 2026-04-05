class StudyPlanData {
  const StudyPlanData({
    required this.configured,
    required this.studyDaysPerWeek,
    required this.minutesPerDay,
    required this.weeklyQuestionsGoal,
    required this.focusMode,
    required this.preferredPeriod,
    required this.priorityDisciplines,
    required this.weekStart,
    required this.weekEnd,
    required this.activeDaysThisWeek,
    required this.completedMinutesThisWeek,
    required this.answeredQuestionsThisWeek,
    required this.activeDaysGoal,
    required this.activeDaysPercent,
    required this.weeklyMinutesTarget,
    required this.minutesPercent,
    required this.questionsPercent,
    required this.weeklyCompletionPercent,
    required this.updatedAt,
  });

  const StudyPlanData.empty()
    : configured = false,
      studyDaysPerWeek = 5,
      minutesPerDay = 60,
      weeklyQuestionsGoal = 80,
      focusMode = 'constancia',
      preferredPeriod = 'flexivel',
      priorityDisciplines = const [],
      weekStart = null,
      weekEnd = null,
      activeDaysThisWeek = 0,
      completedMinutesThisWeek = 0,
      answeredQuestionsThisWeek = 0,
      activeDaysGoal = 5,
      activeDaysPercent = 0,
      weeklyMinutesTarget = 300,
      minutesPercent = 0,
      questionsPercent = 0,
      weeklyCompletionPercent = 0,
      updatedAt = null;

  final bool configured;
  final int studyDaysPerWeek;
  final int minutesPerDay;
  final int weeklyQuestionsGoal;
  final String focusMode;
  final String preferredPeriod;
  final List<String> priorityDisciplines;
  final DateTime? weekStart;
  final DateTime? weekEnd;
  final int activeDaysThisWeek;
  final int completedMinutesThisWeek;
  final int answeredQuestionsThisWeek;
  final int activeDaysGoal;
  final int activeDaysPercent;
  final int weeklyMinutesTarget;
  final int minutesPercent;
  final int questionsPercent;
  final int weeklyCompletionPercent;
  final DateTime? updatedAt;
}
