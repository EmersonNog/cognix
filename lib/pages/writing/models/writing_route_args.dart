import '../../../services/writing/writing_api.dart';

enum WritingEditorMode {
  manual,
  imageScan;

  bool get usesImageScan => this == WritingEditorMode.imageScan;
}

class WritingModeSelectionArgs {
  const WritingModeSelectionArgs({required this.theme});

  final WritingTheme theme;
}

class WritingEditorArgs {
  const WritingEditorArgs({
    required this.theme,
    this.initialDraft,
    this.mode = WritingEditorMode.manual,
  });

  final WritingTheme theme;
  final WritingDraft? initialDraft;
  final WritingEditorMode mode;
}

class WritingResultArgs {
  const WritingResultArgs({
    required this.draft,
    required this.feedback,
    this.editorMode = WritingEditorMode.manual,
  });

  final WritingDraft draft;
  final WritingFeedback feedback;
  final WritingEditorMode editorMode;
}

class WritingHistoryDetailArgs {
  const WritingHistoryDetailArgs({required this.submissionId});

  final int submissionId;
}
