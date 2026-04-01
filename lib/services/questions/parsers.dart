import 'dart:convert';

import '../../utils/api_datetime.dart';
import 'models.dart';

SubcategoryItem parseSubcategoryItem(Map item) {
  return SubcategoryItem(
    name: item['name']?.toString() ?? '',
    total: int.tryParse(item['total']?.toString() ?? '') ?? 0,
  );
}

QuestionItem parseQuestionItem(
  Map row, {
  String fallbackDiscipline = '',
  String fallbackSubcategory = '',
}) {
  return QuestionItem(
    id: int.tryParse('${row['id']}') ?? 0,
    statement: row['enunciado']?.toString() ?? '',
    alternatives: extractAlternativesFromRow(row),
    subcategory: row['subcategoria']?.toString() ?? fallbackSubcategory,
    discipline: row['disciplina']?.toString() ?? fallbackDiscipline,
    year: int.tryParse('${row['ano']}'),
  );
}

QuestionsPage parseQuestionsPage(
  Map<String, dynamic> payload, {
  required int fallbackLimit,
  required int fallbackOffset,
  required String fallbackDiscipline,
  required String fallbackSubcategory,
}) {
  final items = payload['items'];
  if (items is! List) {
    return QuestionsPage(
      items: const [],
      limit: fallbackLimit,
      offset: fallbackOffset,
      total: int.tryParse('${payload['total']}'),
    );
  }

  final parsedItems = items.whereType<Map>().map((row) {
    return parseQuestionItem(
      row,
      fallbackDiscipline: fallbackDiscipline,
      fallbackSubcategory: fallbackSubcategory,
    );
  }).toList();

  return QuestionsPage(
    items: parsedItems,
    limit: int.tryParse('${payload['limit']}') ?? fallbackLimit,
    offset: int.tryParse('${payload['offset']}') ?? fallbackOffset,
    total: int.tryParse('${payload['total']}'),
  );
}

TrainingSessionState parseTrainingSessionState(Map<String, dynamic> payload) {
  final state = (payload['state'] as Map?)?.cast<String, dynamic>() ?? {};
  final updatedAt = parseApiDateTime(payload['updated_at']?.toString());
  return TrainingSessionState(state: state, updatedAt: updatedAt);
}

TrainingSessionsOverview parseTrainingSessionsOverview(
  Map<String, dynamic> payload,
) {
  final latestRaw = payload['latest_session'];

  TrainingSessionOverviewItem? latestSession;
  if (latestRaw is Map) {
    latestSession = TrainingSessionOverviewItem(
      discipline: latestRaw['discipline']?.toString() ?? '',
      subcategory: latestRaw['subcategory']?.toString() ?? '',
      completed: latestRaw['completed'] == true,
      answeredQuestions:
          int.tryParse('${latestRaw['answered_questions']}') ?? 0,
      totalQuestions: int.tryParse('${latestRaw['total_questions']}') ?? 0,
      progress:
          (double.tryParse('${latestRaw['progress']}') ?? 0.0).clamp(0.0, 1.0),
      updatedAt: parseApiDateTime(latestRaw['updated_at']?.toString()),
    );
  }

  return TrainingSessionsOverview(
    completedSessions: int.tryParse('${payload['completed_sessions']}') ?? 0,
    inProgressSessions: int.tryParse('${payload['in_progress_sessions']}') ?? 0,
    latestSession: latestSession,
  );
}

List<String> extractAlternativesFromRow(Map row) {
  final keyed = <String>[];
  const keys = ['a', 'b', 'c', 'd', 'e'];
  for (final key in keys) {
    final value = row['alternativa_$key']?.toString().trim() ?? '';
    if (value.isNotEmpty) {
      keyed.add(value);
    }
  }
  if (keyed.isNotEmpty) {
    return keyed;
  }

  final rawAlternatives = row['alternativas']?.toString() ?? '';
  return parseAlternatives(rawAlternatives);
}

List<String> parseAlternatives(String raw) {
  final text = raw.trim();
  if (text.isEmpty) {
    return [];
  }

  try {
    final decoded = jsonDecode(text);
    if (decoded is List) {
      return decoded.map((e) => e.toString()).toList();
    }
    if (decoded is Map) {
      return decoded.values.map((e) => e.toString()).toList();
    }
  } catch (_) {}

  final byLine = text
      .split(RegExp(r'[\r\n]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (byLine.length > 1) {
    return byLine;
  }

  final bySemicolon = text
      .split(';')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (bySemicolon.length > 1) {
    return bySemicolon;
  }

  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final optionRegex = RegExp(
    r'([A-E])\s*[\)\.\:\-]\s*(.*?)(?=\s+[A-E]\s*[\)\.\:\-]\s*|$)',
    caseSensitive: false,
  );
  final matches = optionRegex.allMatches(normalized).toList();
  if (matches.length > 1) {
    return matches
        .map((m) => (m.group(2) ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return [text];
}
