DateTime? parseApiDateTime(String? rawValue) {
  if (rawValue == null) {
    return null;
  }

  final normalized = rawValue.trim();
  if (normalized.isEmpty) {
    return null;
  }

  final parsed = DateTime.tryParse(normalized);
  if (parsed == null) {
    return null;
  }

  final hasTimezone =
      normalized.endsWith('Z') ||
      RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(normalized);

  if (hasTimezone) {
    return parsed.toLocal();
  }

  return DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  ).toLocal();
}

String formatShortDateTime(DateTime? value) {
  if (value == null) {
    return 'Sem tentativas';
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year.toString();
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');

  return '$day/$month/$year $hour:$minute';
}
