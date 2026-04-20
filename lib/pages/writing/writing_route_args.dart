import '../../services/writing/writing_api.dart';

class WritingEditorArgs {
  const WritingEditorArgs({required this.theme, this.initialDraft});

  final WritingTheme theme;
  final WritingDraft? initialDraft;
}

class WritingResultArgs {
  const WritingResultArgs({required this.draft, required this.feedback});

  final WritingDraft draft;
  final WritingFeedback feedback;
}

class WritingHistoryDetailArgs {
  const WritingHistoryDetailArgs({required this.submissionId});

  final int submissionId;
}
