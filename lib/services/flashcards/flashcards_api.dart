import 'models.dart';
import 'requests.dart';

export 'models.dart';

Future<FlashcardsPayload> fetchFlashcards() => fetchFlashcardsPayload();

Future<FlashcardItem> createFlashcard({
  required String subject,
  required String frontText,
  required String backText,
  String frontImageBase64 = '',
  String backImageBase64 = '',
}) {
  return createFlashcardRequest(
    subject: subject,
    frontText: frontText,
    backText: backText,
    frontImageBase64: frontImageBase64,
    backImageBase64: backImageBase64,
  );
}

Future<void> deleteFlashcardDeck(String subject) {
  return deleteFlashcardDeckRequest(subject);
}

Future<FlashcardDeckProgress> saveFlashcardDeckProgress({
  required String subject,
  required int currentIndex,
  required int correctCount,
  required int wrongCount,
}) {
  return saveFlashcardDeckProgressRequest(
    subject: subject,
    currentIndex: currentIndex,
    correctCount: correctCount,
    wrongCount: wrongCount,
  );
}
