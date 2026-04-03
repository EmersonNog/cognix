double trainingResultsAccuracyRatio({
  required int correctAnswers,
  required int totalQuestions,
}) {
  if (totalQuestions == 0) {
    return 0.0;
  }

  return correctAnswers / totalQuestions;
}

String trainingResultsAccuracyLabel({
  required int correctAnswers,
  required int totalQuestions,
}) {
  final accuracy = trainingResultsAccuracyRatio(
    correctAnswers: correctAnswers,
    totalQuestions: totalQuestions,
  );

  return '${(accuracy * 100).clamp(0, 100).toStringAsFixed(0)}%';
}

String trainingResultsFormatElapsed(Duration elapsed) {
  final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
  final hours = elapsed.inHours;

  if (hours > 0) {
    final hh = hours.toString().padLeft(2, '0');
    return '$hh:$minutes:$seconds';
  }

  return '$minutes:$seconds';
}

String trainingResultsPillLabelForAccuracy(double accuracy) {
  if (accuracy >= 0.9) {
    return 'IMPECÁVEL';
  }
  if (accuracy >= 0.8) {
    return 'MODO MESTRE';
  }
  if (accuracy >= 0.7) {
    return 'MANDANDO BEM';
  }
  if (accuracy >= 0.6) {
    return 'BOM RITMO';
  }
  if (accuracy >= 0.5) {
    return 'EM EVOLUÇÃO';
  }

  return 'PRECISA PRATICAR';
}
