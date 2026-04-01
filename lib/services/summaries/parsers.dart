import '../../utils/api_datetime.dart';
import '../questions/questions_api.dart' show TrainingSessionState;
import 'core.dart';
import 'models.dart';

SummaryData parseSummaryData(
  Map<String, dynamic> payload, {
  required String fallbackDiscipline,
  required String fallbackSubcategory,
}) {
  return SummaryData(
    title: payload['title']?.toString() ?? '$fallbackSubcategory - Resumo',
    discipline: payload['discipline']?.toString() ?? fallbackDiscipline,
    subcategory: payload['subcategory']?.toString() ?? fallbackSubcategory,
    nodes: parseSummaryNodes(payload['nodes']),
    stats: parseSummaryStats(payload['stats']),
    lockedUntilComplete: payload['locked_until_complete'] == true,
    lockedMessage: payload['locked_message']?.toString(),
  );
}

SummaryStats parseSummaryStats(dynamic raw) {
  if (raw is Map) {
    final totalAttempts =
        int.tryParse(raw['total_attempts']?.toString() ?? '') ?? 0;
    final totalCorrect =
        int.tryParse(raw['total_correct']?.toString() ?? '') ?? 0;
    final accuracyPercent =
        double.tryParse(raw['accuracy_percent']?.toString() ?? '') ?? 0.0;
    final lastAttemptAt = parseApiDateTime(raw['last_attempt_at']?.toString());
    return SummaryStats(
      totalAttempts: totalAttempts,
      totalCorrect: totalCorrect,
      accuracyPercent: accuracyPercent,
      lastAttemptAt: lastAttemptAt,
    );
  }

  return const SummaryStats(
    totalAttempts: 0,
    totalCorrect: 0,
    accuracyPercent: 0.0,
    lastAttemptAt: null,
  );
}

List<SummaryNode> parseSummaryNodes(dynamic rawNodes) {
  final nodes = <SummaryNode>[];
  if (rawNodes is! List) {
    return nodes;
  }

  for (final item in rawNodes.take(maxSummaryNodes)) {
    if (item is! Map) continue;

    final title = item['title']?.toString().trim() ?? '';
    final itemsRaw = item['items'];
    final items = <String>[];

    if (itemsRaw is List) {
      items.addAll(
        itemsRaw
            .take(maxItemsPerSummaryNode)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty),
      );
    }

    if (title.isNotEmpty && items.isNotEmpty) {
      nodes.add(SummaryNode(title: title, items: items));
    }
  }

  return nodes;
}

TrainingProgressData parseTrainingProgressData(
  Map<String, dynamic> payload, {
  required TrainingSessionState? sessionState,
}) {
  final totalQuestions =
      int.tryParse(payload['total_questions']?.toString() ?? '') ?? 0;

  final sessionProgress = parseSessionProgress(
    sessionState?.state,
    fallbackTotalQuestions: totalQuestions,
  );
  if (sessionProgress != null) {
    return sessionProgress;
  }

  return TrainingProgressData(
    answeredQuestions: 0,
    totalQuestions: totalQuestions,
    progress: 0.0,
    hasCompletedSession: false,
  );
}

TrainingProgressData? parseSessionProgress(
  Map<String, dynamic>? state, {
  required int fallbackTotalQuestions,
}) {
  if (state == null || state.isEmpty) return null;

  if (state['completed'] == true) {
    final result = state['result'];
    if (result is! Map) return null;
    final answeredQuestions =
        int.tryParse('${result['answeredQuestions']}') ?? 0;
    final totalQuestions =
        int.tryParse('${result['totalQuestions']}') ?? fallbackTotalQuestions;

    return TrainingProgressData(
      answeredQuestions: answeredQuestions,
      totalQuestions: totalQuestions,
      progress: totalQuestions <= 0
          ? 0.0
          : (answeredQuestions / totalQuestions).clamp(0.0, 1.0),
      hasCompletedSession: true,
    );
  }

  final lastSubmitted = state['lastSubmitted'];
  if (lastSubmitted is! Map) {
    return TrainingProgressData(
      answeredQuestions: 0,
      totalQuestions: fallbackTotalQuestions,
      progress: 0.0,
      hasCompletedSession: false,
    );
  }

  final answeredQuestions = lastSubmitted.length;
  final totalQuestions =
      int.tryParse('${state['totalAvailable']}') ?? fallbackTotalQuestions;

  return TrainingProgressData(
    answeredQuestions: answeredQuestions,
    totalQuestions: totalQuestions,
    progress: totalQuestions <= 0
        ? 0.0
        : (answeredQuestions / totalQuestions).clamp(0.0, 1.0),
    hasCompletedSession: false,
  );
}
