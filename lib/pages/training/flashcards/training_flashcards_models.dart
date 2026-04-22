import '../../../services/flashcards/flashcards_api.dart';

enum TrainingFlashcardDeckFilter { todos, comImagem, semImagem, recentes }

String trainingFlashcardDeckFilterLabel(TrainingFlashcardDeckFilter filter) {
  switch (filter) {
    case TrainingFlashcardDeckFilter.todos:
      return 'Todos';
    case TrainingFlashcardDeckFilter.comImagem:
      return 'Com imagem';
    case TrainingFlashcardDeckFilter.semImagem:
      return 'Sem imagem';
    case TrainingFlashcardDeckFilter.recentes:
      return 'Recentes';
  }
}

String normalizeTrainingFlashcardSubject(String subject) {
  final trimmedSubject = subject.trim();
  if (trimmedSubject.isEmpty) {
    return 'Sem matéria';
  }
  return trimmedSubject;
}

class TrainingFlashcardDraft {
  const TrainingFlashcardDraft({
    this.id = 0,
    required this.subject,
    required this.frontText,
    required this.frontImage,
    required this.backText,
    required this.backImage,
  });

  factory TrainingFlashcardDraft.fromApi(FlashcardItem item) {
    return TrainingFlashcardDraft(
      id: item.id,
      subject: item.subject,
      frontText: item.frontText,
      frontImage: item.frontImageBase64,
      backText: item.backText,
      backImage: item.backImageBase64,
    );
  }

  final int id;
  final String subject;
  final String frontText;
  final String frontImage;
  final String backText;
  final String backImage;
}

class TrainingFlashcardDeckSessionState {
  const TrainingFlashcardDeckSessionState({
    required this.currentIndex,
    required this.correctCount,
    required this.wrongCount,
  });

  final int currentIndex;
  final int correctCount;
  final int wrongCount;
}

class TrainingFlashcardDeckSessionResult {
  const TrainingFlashcardDeckSessionResult({
    required this.subject,
    required this.reviewedCount,
    required this.currentIndex,
    required this.correctCount,
    required this.wrongCount,
  });

  final String subject;
  final int reviewedCount;
  final int currentIndex;
  final int correctCount;
  final int wrongCount;
}
