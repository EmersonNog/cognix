import '../core/api_client.dart' show apiBaseUrl, deleteJson, getJson, postJson;
import 'models.dart';
import 'parsers.dart';

Uri _flashcardsUri(String path) => Uri.parse('${apiBaseUrl()}$path');

Future<FlashcardsPayload> fetchFlashcardsPayload() async {
  final payload = await getJson(
    _flashcardsUri('/flashcards'),
    errorMessage: 'Não consegui carregar seus flashcards agora.',
  );
  return parseFlashcardsPayload(payload);
}

Future<FlashcardItem> createFlashcardRequest({
  required String subject,
  required String frontText,
  required String backText,
  String frontImageBase64 = '',
  String backImageBase64 = '',
}) async {
  final payload = await postJson(
    _flashcardsUri('/flashcards'),
    body: <String, dynamic>{
      'subject': subject,
      'front_text': frontText,
      'back_text': backText,
      'front_image_base64': frontImageBase64,
      'back_image_base64': backImageBase64,
    },
    errorMessage: 'Não consegui salvar esse flashcard agora.',
  );
  return parseFlashcardItem(payload);
}

Future<void> deleteFlashcardDeckRequest(String subject) {
  final normalizedSubject = subject.trim();
  final uri = _flashcardsUri(
    '/flashcards/deck',
  ).replace(queryParameters: <String, String>{'subject': normalizedSubject});
  return deleteJson(uri, errorMessage: 'Não consegui apagar esse deck agora.');
}

Future<FlashcardDeckProgress> saveFlashcardDeckProgressRequest({
  required String subject,
  required int currentIndex,
  required int correctCount,
  required int wrongCount,
}) async {
  final payload = await postJson(
    _flashcardsUri('/flashcards/deck/progress'),
    body: <String, dynamic>{
      'subject': subject,
      'current_index': currentIndex,
      'correct_count': correctCount,
      'wrong_count': wrongCount,
    },
    errorMessage: 'Não consegui salvar seu progresso de flashcards.',
  );
  return parseFlashcardDeckProgress(payload);
}
