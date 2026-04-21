final RegExp _emailPattern = RegExp(
  r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
  caseSensitive: false,
);

bool isValidEmail(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    return false;
  }
  return _emailPattern.hasMatch(normalized);
}
