part of '../study_plan_screen.dart';

Widget _buildBodyForState(
  _StudyPlanScreenState state, {
  required _StudyPlanPalette palette,
  required StudyPlanData displayPlan,
}) {
  if (state._isLoading) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
      ),
    );
  }

  if (state._isSubscriptionRequired) {
    return _StudyPlanFormContent(
      palette: palette,
      plan: const StudyPlanData.empty(),
      displayPlan: const StudyPlanData.empty(),
      draft: state._draft,
      availableDisciplines: const [],
      previewMode: true,
      onLockedTap: () => Navigator.of(state.context).pushNamed('subscription'),
      onStudyDaysChanged: (_) =>
          Navigator.of(state.context).pushNamed('subscription'),
      onMinutesChanged: (_) =>
          Navigator.of(state.context).pushNamed('subscription'),
      onWeeklyQuestionsChanged: (_) =>
          Navigator.of(state.context).pushNamed('subscription'),
      onFocusModeChanged: (_) =>
          Navigator.of(state.context).pushNamed('subscription'),
      onPreferredPeriodChanged: (_) =>
          Navigator.of(state.context).pushNamed('subscription'),
      onDisciplineToggled: (_) =>
          Navigator.of(state.context).pushNamed('subscription'),
    );
  }

  if (state._errorMessage != null) {
    return _StudyPlanErrorState(
      palette: palette,
      message: state._errorMessage!,
      isSubscriptionRequired: state._isSubscriptionRequired,
      onRetry: state._isSubscriptionRequired
          ? () => Navigator.of(state.context).pushNamed('subscription')
          : () => _loadForState(state),
    );
  }

  return _StudyPlanFormContent(
    palette: palette,
    plan: state._plan,
    displayPlan: displayPlan,
    draft: state._draft,
    availableDisciplines: state._availableDisciplines,
    onStudyDaysChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(studyDaysPerWeek: value),
      );
    },
    onMinutesChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(minutesPerDay: value),
      );
    },
    onWeeklyQuestionsChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(weeklyQuestionsGoal: value),
      );
    },
    onFocusModeChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(focusMode: value),
      );
    },
    onPreferredPeriodChanged: (value) {
      _updateDraftForState(
        state,
        (current) => current.copyWith(preferredPeriod: value),
      );
    },
    onDisciplineToggled: (discipline) {
      _toggleDisciplineForState(state, discipline);
    },
  );
}
