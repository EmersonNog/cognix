part of '../models.dart';

class WritingChecklistItem {
  const WritingChecklistItem({
    required this.label,
    required this.completed,
    required this.helper,
  });

  final String label;
  final bool completed;
  final String helper;
}

class WritingCompetencyFeedback {
  const WritingCompetencyFeedback({
    required this.title,
    required this.score,
    required this.comment,
  });

  final String title;
  final int score;
  final String comment;
}

class WritingRewriteSuggestion {
  const WritingRewriteSuggestion({
    required this.section,
    required this.issue,
    required this.suggestion,
    required this.example,
  });

  final String section;
  final String issue;
  final String suggestion;
  final String example;
}

class WritingFeedback {
  const WritingFeedback({
    required this.estimatedScore,
    required this.summary,
    required this.competencies,
    required this.rewriteSuggestions,
    required this.checklist,
    this.submissionId,
    this.versionId,
    this.versionNumber,
  });

  final int estimatedScore;
  final String summary;
  final List<WritingCompetencyFeedback> competencies;
  final List<WritingRewriteSuggestion> rewriteSuggestions;
  final List<WritingChecklistItem> checklist;
  final int? submissionId;
  final int? versionId;
  final int? versionNumber;
}
