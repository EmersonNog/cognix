part of '../parsers.dart';

List<ProfileRecentActivityDay> parseProfileRecentActivityWindow(dynamic raw) {
  if (raw is! List) {
    return const [];
  }

  final items = <ProfileRecentActivityDay>[];
  for (final item in raw.whereType<Map>()) {
    final date = _parseCalendarDate(item['date']?.toString());
    if (date == null) {
      continue;
    }
    items.add(
      ProfileRecentActivityDay(
        date: date,
        active: item['active'] == true,
        isToday: item['is_today'] == true,
      ),
    );
  }

  return items;
}

List<ProfileRecentCompletedSession> parseProfileRecentCompletedSessionsPreview(
  dynamic raw,
) {
  if (raw is! List) {
    return const [];
  }

  return raw
      .whereType<Map>()
      .map((item) {
        return ProfileRecentCompletedSession(
          discipline: parseTrimmedString(item['discipline']),
          subcategory: parseTrimmedString(item['subcategory']),
          answeredQuestions: parseIntValue(item['answered_questions']),
          totalQuestions: parseIntValue(item['total_questions']),
          correctAnswers: parseIntValue(item['correct_answers']),
          accuracyPercent: parseDoubleValue(item['accuracy_percent']),
          completedAt: parseApiDateTime(item['completed_at']?.toString()),
        );
      })
      .where((item) {
        return item.discipline.isNotEmpty && item.subcategory.isNotEmpty;
      })
      .toList();
}

DateTime? _parseCalendarDate(String? rawValue) {
  final normalized = rawValue?.trim() ?? '';
  if (normalized.isEmpty) {
    return null;
  }

  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(normalized);
  if (match == null) {
    return null;
  }

  final year = int.tryParse(match.group(1) ?? '');
  final month = int.tryParse(match.group(2) ?? '');
  final day = int.tryParse(match.group(3) ?? '');
  if (year == null || month == null || day == null) {
    return null;
  }

  return DateTime(year, month, day);
}
