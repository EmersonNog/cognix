int parseIntValue(Object? rawValue, {int fallback = 0}) {
  return int.tryParse('$rawValue') ?? fallback;
}

double parseDoubleValue(Object? rawValue, {double fallback = 0.0}) {
  return double.tryParse('$rawValue') ?? fallback;
}

String parseTrimmedString(Object? rawValue, {String fallback = ''}) {
  final normalized = rawValue?.toString().trim() ?? '';
  return normalized.isNotEmpty ? normalized : fallback;
}

String? parseOptionalTrimmedString(Object? rawValue) {
  final normalized = rawValue?.toString().trim() ?? '';
  return normalized.isNotEmpty ? normalized : null;
}

bool parseBoolValue(Object? rawValue, {bool fallback = false}) {
  return rawValue is bool ? rawValue : fallback;
}
