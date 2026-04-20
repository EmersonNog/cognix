part of '../parsers.dart';

List<T> _parseList<T>(
  Object? value,
  T Function(Map<String, dynamic> item) mapper,
) {
  if (value is! List) {
    return const [];
  }
  return value
      .whereType<Map>()
      .map((item) => mapper(Map<String, dynamic>.from(item)))
      .toList();
}

List<String> _parseStringList(Object? value) {
  if (value is! List) {
    return const [];
  }
  return value.map((item) => item.toString()).toList();
}

int _parseInt(Object? value) {
  if (value is int) return value;
  return int.tryParse('$value') ?? 0;
}

int? _parseNullableInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse('$value');
}
