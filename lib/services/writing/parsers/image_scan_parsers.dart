part of '../parsers.dart';

WritingImageScanResult parseWritingImageScanResult(
  Map<String, dynamic> payload,
) {
  return WritingImageScanResult(
    text: payload['text'] is String ? (payload['text'] as String).trim() : '',
    confidence: _parseDouble(payload['confidence']).clamp(0, 1).toDouble(),
    warnings: _parseStringList(
      payload['warnings'],
    ).map((item) => item.trim()).where((item) => item.isNotEmpty).toList(),
  );
}
