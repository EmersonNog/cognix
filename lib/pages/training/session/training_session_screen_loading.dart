part of 'training_session_screen.dart';

Future<void> _loadInitialQuestionsForState(
  _TrainingSessionScreenState state,
) async {
  final batch = await loadInitialTrainingQuestions(
    discipline: state.widget.discipline,
    subcategory: state.widget.subcategory,
    pageSize: state._pageSize,
  );
  state._totalAvailable = batch.total;
  state._offset = batch.nextOffset;
  state._questions
    ..clear()
    ..addAll(batch.items);
  state._loadedIds
    ..clear()
    ..addAll(batch.items.map((e) => e.id));
}

Future<void> _loadMoreQuestionsForState(
  _TrainingSessionScreenState state,
) async {
  if (state._loadingMore || !_hasMoreQuestionsForState(state)) return;

  state._update(() => state._loadingMore = true);
  try {
    final batch = await loadMoreTrainingQuestions(
      discipline: state.widget.discipline,
      subcategory: state.widget.subcategory,
      pageSize: state._pageSize,
      offset: state._offset,
      loadedIds: state._loadedIds,
    );
    state._totalAvailable ??= batch.total;
    state._offset = batch.nextOffset;

    if (batch.items.isNotEmpty) {
      state._update(() {
        state._questions.addAll(batch.items);
        state._loadedIds.addAll(batch.items.map((e) => e.id));
      });
    }
  } finally {
    if (state.mounted) {
      state._update(() => state._loadingMore = false);
    }
  }
}

bool _hasMoreQuestionsForState(_TrainingSessionScreenState state) {
  if (state._totalAvailable == null) {
    return false;
  }
  return state._questions.length < state._totalAvailable!;
}

void _maybePrefetchForState(_TrainingSessionScreenState state) {
  if (state._loadingMore || !_hasMoreQuestionsForState(state)) return;

  final triggerIndex = state._questions.length - 3;
  if (state._currentIndex >= triggerIndex) {
    _loadMoreQuestionsForState(state).catchError((_) {});
  }
}
