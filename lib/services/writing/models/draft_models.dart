part of '../models.dart';

class WritingDraft {
  const WritingDraft({
    required this.theme,
    required this.thesis,
    required this.repertoire,
    required this.argumentOne,
    required this.argumentTwo,
    required this.intervention,
    required this.finalText,
    this.submissionId,
  });

  final WritingTheme theme;
  final String thesis;
  final String repertoire;
  final String argumentOne;
  final String argumentTwo;
  final String intervention;
  final String finalText;
  final int? submissionId;

  WritingDraft copyWith({
    WritingTheme? theme,
    String? thesis,
    String? repertoire,
    String? argumentOne,
    String? argumentTwo,
    String? intervention,
    String? finalText,
    int? submissionId,
    bool clearSubmissionId = false,
  }) {
    return WritingDraft(
      theme: theme ?? this.theme,
      thesis: thesis ?? this.thesis,
      repertoire: repertoire ?? this.repertoire,
      argumentOne: argumentOne ?? this.argumentOne,
      argumentTwo: argumentTwo ?? this.argumentTwo,
      intervention: intervention ?? this.intervention,
      finalText: finalText ?? this.finalText,
      submissionId: clearSubmissionId
          ? null
          : (submissionId ?? this.submissionId),
    );
  }

  int get wordCount => finalText
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.trim().isNotEmpty)
      .length;

  int get paragraphCount => finalText
      .split(RegExp(r'\n\s*\n'))
      .where((paragraph) => paragraph.trim().isNotEmpty)
      .length;
}
