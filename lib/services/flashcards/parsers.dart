import 'models.dart';

FlashcardsPayload parseFlashcardsPayload(Map<String, dynamic> payload) {
  final rawItems = payload['items'];
  final rawDeckStates = payload['deck_states'];

  final items = (rawItems is List ? rawItems : const <dynamic>[])
      .whereType<Map>()
      .map(
        (item) => parseFlashcardItem(Map<String, dynamic>.from(item)),
      )
      .toList();

  final progressBySubject = <String, FlashcardDeckProgress>{};
  for (final rawState in (rawDeckStates is List ? rawDeckStates : const <dynamic>[])) {
    if (rawState is! Map) continue;
    final state = parseFlashcardDeckProgress(Map<String, dynamic>.from(rawState));
    progressBySubject[state.subject] = state;
  }

  return FlashcardsPayload(
    items: items,
    progressBySubject: progressBySubject,
  );
}

FlashcardItem parseFlashcardItem(Map<String, dynamic> payload) {
  return FlashcardItem(
    id: (payload['id'] as num?)?.toInt() ?? 0,
    subject: (payload['subject'] as String? ?? '').trim(),
    frontText: (payload['front_text'] as String? ?? '').trim(),
    frontImageBase64: (payload['front_image_base64'] as String? ?? '').trim(),
    backText: (payload['back_text'] as String? ?? '').trim(),
    backImageBase64: (payload['back_image_base64'] as String? ?? '').trim(),
  );
}

FlashcardDeckProgress parseFlashcardDeckProgress(Map<String, dynamic> payload) {
  return FlashcardDeckProgress(
    subject: (payload['subject'] as String? ?? '').trim(),
    currentIndex: (payload['current_index'] as num?)?.toInt() ?? 0,
    correctCount: (payload['correct_count'] as num?)?.toInt() ?? 0,
    wrongCount: (payload['wrong_count'] as num?)?.toInt() ?? 0,
  );
}
