part of '../models.dart';

class WritingImageScanResult {
  const WritingImageScanResult({
    required this.text,
    required this.confidence,
    required this.warnings,
  });

  final String text;
  final double confidence;
  final List<String> warnings;

  bool get hasText => text.trim().isNotEmpty;
  bool get needsReview => confidence < 0.78 || warnings.isNotEmpty;
}
