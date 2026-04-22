class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.subject,
    required this.frontText,
    required this.frontImageBase64,
    required this.backText,
    required this.backImageBase64,
  });

  final int id;
  final String subject;
  final String frontText;
  final String frontImageBase64;
  final String backText;
  final String backImageBase64;
}

class FlashcardDeckProgress {
  const FlashcardDeckProgress({
    required this.subject,
    required this.currentIndex,
    required this.correctCount,
    required this.wrongCount,
  });

  final String subject;
  final int currentIndex;
  final int correctCount;
  final int wrongCount;
}

class FlashcardsPayload {
  const FlashcardsPayload({
    required this.items,
    required this.progressBySubject,
  });

  final List<FlashcardItem> items;
  final Map<String, FlashcardDeckProgress> progressBySubject;
}
