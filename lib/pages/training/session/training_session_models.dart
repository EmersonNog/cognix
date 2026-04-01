import '../../../services/questions/questions_api.dart';

class TrainingCompletedSessionResult {
  const TrainingCompletedSessionResult({
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.elapsedSeconds,
  });

  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int elapsedSeconds;
}

class TrainingRestoredSessionData {
  const TrainingRestoredSessionData({
    required this.questions,
    required this.currentIndex,
    required this.totalAvailable,
    required this.offset,
    required this.selections,
    required this.lastSubmittedByQuestionId,
    required this.isCorrectByQuestionId,
    required this.correctOptionIndexByQuestionId,
    required this.paused,
    required this.elapsedSeconds,
    required this.showingAnswerFeedback,
    required this.feedbackQuestionId,
    required this.correctOptionIndex,
    required this.lastAnswerWasCorrect,
  });

  final List<QuestionItem> questions;
  final int currentIndex;
  final int? totalAvailable;
  final int offset;
  final Map<int, int> selections;
  final Map<int, String> lastSubmittedByQuestionId;
  final Map<int, bool?> isCorrectByQuestionId;
  final Map<int, int> correctOptionIndexByQuestionId;
  final bool paused;
  final int elapsedSeconds;
  final bool showingAnswerFeedback;
  final int? feedbackQuestionId;
  final int? correctOptionIndex;
  final bool? lastAnswerWasCorrect;
}

class TrainingSessionRestoreOutcome {
  const TrainingSessionRestoreOutcome({
    this.completedResult,
    this.restoredState,
  });

  final TrainingCompletedSessionResult? completedResult;
  final Map<String, dynamic>? restoredState;
}
