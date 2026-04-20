import 'dart:math';

import '../../../services/questions/questions_api.dart';

class TrainingQuestionsBatch {
  const TrainingQuestionsBatch({
    required this.items,
    required this.total,
    required this.nextOffset,
  });

  final List<QuestionItem> items;
  final int total;
  final int nextOffset;
}

Future<TrainingQuestionsBatch> loadInitialTrainingQuestions({
  required String discipline,
  required String subcategory,
  required int pageSize,
}) async {
  final page = await fetchQuestionsPageBySubcategory(
    discipline: discipline,
    subcategory: subcategory,
    limit: pageSize,
    offset: 0,
  );

  final items = _shuffleQuestionItems(page.items);
  return TrainingQuestionsBatch(
    items: items,
    total: page.total ?? items.length,
    nextOffset: page.offset + page.items.length,
  );
}

Future<TrainingQuestionsBatch> loadMoreTrainingQuestions({
  required String discipline,
  required String subcategory,
  required int pageSize,
  required int offset,
  required Set<int> loadedIds,
}) async {
  final page = await fetchQuestionsPageBySubcategory(
    discipline: discipline,
    subcategory: subcategory,
    limit: pageSize,
    offset: offset,
  );

  final newItems = page.items
      .where((item) => !loadedIds.contains(item.id))
      .toList();
  return TrainingQuestionsBatch(
    items: _shuffleQuestionItems(newItems),
    total: page.total ?? offset + page.items.length,
    nextOffset: offset + page.items.length,
  );
}

List<QuestionItem> _shuffleQuestionItems(List<QuestionItem> items) {
  final shuffled = List<QuestionItem>.from(items);
  shuffled.shuffle(Random());
  return shuffled;
}
