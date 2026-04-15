import 'dart:convert';

import '../../utils/api_datetime.dart';
import 'models.dart';

SubcategoryItem parseSubcategoryItem(
  Map item, {
  String fallbackDiscipline = '',
}) {
  return SubcategoryItem(
    name: item['name']?.toString() ?? '',
    total: int.tryParse(item['total']?.toString() ?? '') ?? 0,
    discipline: item['discipline']?.toString() ?? fallbackDiscipline,
  );
}

QuestionItem parseQuestionItem(
  Map row, {
  String fallbackDiscipline = '',
  String fallbackSubcategory = '',
}) {
  final alternatives = extractAlternativesFromRow(row);
  return QuestionItem(
    id: int.tryParse('${row['id']}') ?? 0,
    statement: row['enunciado']?.toString() ?? '',
    alternatives: alternatives,
    subcategory: row['subcategoria']?.toString() ?? fallbackSubcategory,
    discipline: row['disciplina']?.toString() ?? fallbackDiscipline,
    year: int.tryParse('${row['ano']}'),
    alternativesIntroduction: _optionalText(row['introducao_alternativas']),
    answerKey: extractAnswerKey(row['gabarito'], alternatives: alternatives),
    tip: row['dica']?.toString(),
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
  final savedAt =
      parseApiDateTime(payload['saved_at']?.toString()) ??
      _parseSavedAtMilliseconds(state['savedAt']);
  final stateVersion = int.tryParse(
    '${payload['state_version'] ?? state['stateVersion']}',
  );
  return TrainingSessionState(
    state: state,
    updatedAt: updatedAt,
    savedAt: savedAt,
    stateVersion: stateVersion,
  );
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
      progress: (double.tryParse('${latestRaw['progress']}') ?? 0.0).clamp(
        0.0,
        1.0,
      ),
      sessionAt:
          parseApiDateTime(latestRaw['session_at']?.toString()) ??
          parseApiDateTime(latestRaw['updated_at']?.toString()),
    );
  }

  return TrainingSessionsOverview(
    completedSessions: int.tryParse('${payload['completed_sessions']}') ?? 0,
    inProgressSessions: int.tryParse('${payload['in_progress_sessions']}') ?? 0,
    latestSession: latestSession,
  );
}

List<QuestionAlternative> extractAlternativesFromRow(Map row) {
  final keyed = <QuestionAlternative>[];
  const keys = ['a', 'b', 'c', 'd', 'e'];
  for (final key in keys) {
    final value = _optionalText(row['alternativa_$key']) ?? '';
    final fileUrl = _optionalText(row['alternativa_${key}_arquivo']);
    if (value.isNotEmpty || fileUrl != null) {
      keyed.add(
        QuestionAlternative(
          letter: key.toUpperCase(),
          text: value,
          fileUrl: fileUrl,
        ),
      );
    }
  }
  if (keyed.isNotEmpty) {
    return keyed;
  }

  final structuredAlternatives = row['alternatives'];
  if (structuredAlternatives is List) {
    final parsed = _parseStructuredAlternatives(structuredAlternatives);
    if (parsed.isNotEmpty) {
      return parsed;
    }
  }

  final rawAlternatives = row['alternativas']?.toString() ?? '';
  return parseAlternatives(rawAlternatives);
}

List<QuestionAlternative> parseAlternatives(String raw) {
  final text = raw.trim();
  if (text.isEmpty) {
    return const [];
  }

  try {
    final decoded = jsonDecode(text);
    if (decoded is List) {
      return _parseStructuredAlternatives(decoded);
    }
    if (decoded is Map) {
      final parsed = <QuestionAlternative>[];
      var index = 0;
      for (final entry in decoded.entries) {
        final letter =
            _normalizeAlternativeLetter(entry.key) ?? _letterFromIndex(index);
        index += 1;
        final value = entry.value?.toString().trim() ?? '';
        if (value.isEmpty) continue;
        parsed.add(QuestionAlternative(letter: letter, text: value));
      }
      if (parsed.isNotEmpty) {
        parsed.sort((a, b) => a.letter.compareTo(b.letter));
        return parsed;
      }
    }
  } catch (_) {}

  final byLine = text
      .split(RegExp(r'[\r\n]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (byLine.length > 1) {
    return _buildIndexedAlternatives(byLine);
  }

  final bySemicolon = text
      .split(';')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (bySemicolon.length > 1) {
    return _buildIndexedAlternatives(bySemicolon);
  }

  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final optionRegex = RegExp(
    r'([A-E])\s*[\)\.\:\-]\s*(.*?)(?=\s+[A-E]\s*[\)\.\:\-]\s*|$)',
    caseSensitive: false,
  );
  final matches = optionRegex.allMatches(normalized).toList();
  if (matches.length > 1) {
    return matches
        .map((match) {
          final letter = _normalizeAlternativeLetter(match.group(1)) ?? 'A';
          return QuestionAlternative(
            letter: letter,
            text: (match.group(2) ?? '').trim(),
          );
        })
        .where((item) => item.text.isNotEmpty)
        .toList();
  }

  return _buildIndexedAlternatives([text]);
}

String? extractAnswerKey(
  dynamic raw, {
  required List<QuestionAlternative> alternatives,
}) {
  final value = _optionalText(raw);
  if (value == null) {
    return null;
  }

  final direct = _normalizeAlternativeLetter(value);
  if (direct != null) {
    return direct;
  }

  final numeric = int.tryParse(value);
  if (numeric != null && numeric > 0 && numeric <= 26) {
    return String.fromCharCode(64 + numeric);
  }

  final letterMatch = RegExp(
    r'(?:alternativa|opcao|option)?\s*([A-Z])(?:\b|[\)\.\:\-])',
    caseSensitive: false,
  ).firstMatch(value);
  final matchedLetter = _normalizeAlternativeLetter(letterMatch?.group(1));
  if (matchedLetter != null) {
    return matchedLetter;
  }

  final normalizedAnswer = _normalizeComparableText(value);
  for (final alternative in alternatives) {
    if (_normalizeComparableText(alternative.text) == normalizedAnswer) {
      return alternative.letter;
    }
  }

  return null;
}

List<QuestionAlternative> _parseStructuredAlternatives(List raw) {
  final parsed = <QuestionAlternative>[];
  for (var i = 0; i < raw.length; i++) {
    final item = raw[i];
    if (item is Map) {
      final letter =
          _normalizeAlternativeLetter(
            item['letter'] ?? item['id'] ?? item['key'] ?? item['label'],
          ) ??
          _letterFromIndex(i);
      final text =
          _optionalText(item['text'] ?? item['value'] ?? item['content']) ?? '';
      final fileUrl = _optionalText(
        item['fileUrl'] ?? item['file_url'] ?? item['arquivo'] ?? item['url'],
      );
      if (text.isEmpty && fileUrl == null) {
        continue;
      }
      parsed.add(
        QuestionAlternative(letter: letter, text: text, fileUrl: fileUrl),
      );
      continue;
    }

    final text = item?.toString().trim() ?? '';
    if (text.isEmpty) continue;
    parsed.add(QuestionAlternative(letter: _letterFromIndex(i), text: text));
  }
  return parsed;
}

List<QuestionAlternative> _buildIndexedAlternatives(List<String> values) {
  return [
    for (var i = 0; i < values.length; i++)
      QuestionAlternative(letter: _letterFromIndex(i), text: values[i]),
  ];
}

String _letterFromIndex(int index) {
  final normalizedIndex = index.clamp(0, 25);
  return String.fromCharCode(65 + normalizedIndex);
}

String? _normalizeAlternativeLetter(dynamic raw) {
  final value = _optionalText(raw)?.toUpperCase();
  if (value == null || value.isEmpty) {
    return null;
  }

  if (value.length == 1 && RegExp(r'^[A-Z]$').hasMatch(value)) {
    return value;
  }

  final match = RegExp(r'\b([A-Z])\b').firstMatch(value);
  return match?.group(1);
}

String _normalizeComparableText(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
}

String? _optionalText(dynamic raw) {
  final value = raw?.toString().trim();
  if (value == null || value.isEmpty) {
    return null;
  }
  return value;
}

DateTime? _parseSavedAtMilliseconds(dynamic raw) {
  final milliseconds = int.tryParse('$raw');
  if (milliseconds == null || milliseconds <= 0) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
}
