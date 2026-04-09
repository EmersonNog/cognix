part of '../study_plan_screen.dart';

Future<void> _loadForState(_StudyPlanScreenState state) async {
  state._previewRequestToken += 1;
  state._applyState(() {
    state._isLoading = true;
    state._errorMessage = null;
  });

  try {
    final results = await Future.wait<Object>([
      fetchStudyPlan(),
      fetchDisciplines(),
    ]);
    if (!state.mounted) {
      return;
    }

    final plan = results[0] as StudyPlanData;
    final disciplines = results[1] as List<String>;
    state._applyState(() {
      state._plan = plan;
      state._previewPlan = plan;
      state._draft = _StudyPlanDraft.fromPlan(plan);
      state._availableDisciplines = disciplines;
      state._isLoading = false;
    });
  } catch (_) {
    if (!state.mounted) {
      return;
    }
    state._applyState(() {
      state._isLoading = false;
      state._errorMessage = 'Não foi possível carregar seu plano agora.';
    });
  }
}

Future<void> _saveForState(_StudyPlanScreenState state) async {
  state._applyState(() => state._isSaving = true);
  try {
    final savedPlan = await saveStudyPlan(
      studyDaysPerWeek: state._draft.studyDaysPerWeek,
      minutesPerDay: state._draft.minutesPerDay,
      weeklyQuestionsGoal: state._draft.weeklyQuestionsGoal,
      focusMode: state._draft.focusMode,
      preferredPeriod: state._draft.preferredPeriod,
      priorityDisciplines: state._draft.priorityDisciplines,
    );
    if (!state.mounted) {
      return;
    }

    state._previewDebounce?.cancel();
    state._previewRequestToken += 1;
    state._applyState(() {
      state._plan = savedPlan;
      state._previewPlan = savedPlan;
      state._draft = _StudyPlanDraft.fromPlan(savedPlan);
    });
    studyPlanRefreshNotifier.markDirty();
    showCognixMessage(
      state.context,
      'Plano de estudos salvo. Sua semana já foi atualizada.',
      type: CognixMessageType.success,
    );
  } catch (_) {
    if (!state.mounted) {
      return;
    }
    showCognixMessage(
      state.context,
      'Não foi possível salvar seu plano agora. Tente novamente.',
      type: CognixMessageType.error,
    );
  } finally {
    if (state.mounted) {
      state._applyState(() => state._isSaving = false);
    }
  }
}

void _updateDraftForState(
  _StudyPlanScreenState state,
  _StudyPlanDraft Function(_StudyPlanDraft current) updater,
) {
  state._applyState(() {
    state._draft = updater(state._draft);
  });
  _schedulePreviewForState(state);
}

void _toggleDisciplineForState(_StudyPlanScreenState state, String discipline) {
  _updateDraftForState(state, (current) {
    final next = List<String>.from(current.priorityDisciplines);
    if (next.contains(discipline)) {
      next.remove(discipline);
    } else if (next.length < 4) {
      next.add(discipline);
    }
    return current.copyWith(priorityDisciplines: next);
  });
}

void _schedulePreviewForState(_StudyPlanScreenState state) {
  state._previewDebounce?.cancel();
  if (state._isLoading || state._errorMessage != null) {
    return;
  }
  state._previewDebounce = Timer(
    _StudyPlanScreenState._previewDebounceDuration,
    () => _refreshPreviewForState(state),
  );
}

Future<void> _refreshPreviewForState(_StudyPlanScreenState state) async {
  final requestToken = ++state._previewRequestToken;
  try {
    final previewPlan = await previewStudyPlan(
      studyDaysPerWeek: state._draft.studyDaysPerWeek,
      minutesPerDay: state._draft.minutesPerDay,
      weeklyQuestionsGoal: state._draft.weeklyQuestionsGoal,
      focusMode: state._draft.focusMode,
      preferredPeriod: state._draft.preferredPeriod,
      priorityDisciplines: state._draft.priorityDisciplines,
    );
    if (!state.mounted || requestToken != state._previewRequestToken) {
      return;
    }
    state._applyState(() => state._previewPlan = previewPlan);
  } catch (_) {}
}
