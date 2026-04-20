part of '../models.dart';

class WritingSubmissionsData {
  const WritingSubmissionsData({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  const WritingSubmissionsData.empty()
    : items = const [],
      total = 0,
      limit = 0,
      offset = 0,
      hasMore = false;

  final List<WritingSubmissionSummary> items;
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;
}

class WritingSubmissionSummary {
  const WritingSubmissionSummary({
    required this.id,
    required this.theme,
    required this.status,
    required this.currentVersion,
    required this.latestSummary,
    this.latestScore,
    this.lastAnalyzedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final WritingTheme theme;
  final String status;
  final int currentVersion;
  final int? latestScore;
  final String latestSummary;
  final DateTime? lastAnalyzedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class WritingSubmissionVersion {
  const WritingSubmissionVersion({
    required this.id,
    required this.versionNumber,
    required this.thesis,
    required this.repertoire,
    required this.argumentOne,
    required this.argumentTwo,
    required this.intervention,
    required this.finalText,
    required this.estimatedScore,
    required this.summary,
    required this.checklist,
    required this.competencies,
    required this.rewriteSuggestions,
    this.analyzedAt,
    this.createdAt,
  });

  final int id;
  final int versionNumber;
  final String thesis;
  final String repertoire;
  final String argumentOne;
  final String argumentTwo;
  final String intervention;
  final String finalText;
  final int estimatedScore;
  final String summary;
  final List<WritingChecklistItem> checklist;
  final List<WritingCompetencyFeedback> competencies;
  final List<WritingRewriteSuggestion> rewriteSuggestions;
  final DateTime? analyzedAt;
  final DateTime? createdAt;

  WritingDraft toDraft({
    required WritingTheme theme,
    required int submissionId,
  }) {
    return WritingDraft(
      theme: theme,
      thesis: thesis,
      repertoire: repertoire,
      argumentOne: argumentOne,
      argumentTwo: argumentTwo,
      intervention: intervention,
      finalText: finalText,
      submissionId: submissionId,
    );
  }

  WritingFeedback toFeedback({required int submissionId}) {
    return WritingFeedback(
      estimatedScore: estimatedScore,
      summary: summary,
      competencies: competencies,
      rewriteSuggestions: rewriteSuggestions,
      checklist: checklist,
      submissionId: submissionId,
      versionId: id,
      versionNumber: versionNumber,
    );
  }
}

class WritingSubmissionDetail {
  const WritingSubmissionDetail({
    required this.id,
    required this.theme,
    required this.status,
    required this.currentVersion,
    required this.latestSummary,
    required this.versions,
    required this.versionsTotal,
    required this.versionsLimit,
    required this.versionsOffset,
    required this.versionsHasMore,
    this.latestScore,
    this.lastAnalyzedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final WritingTheme theme;
  final String status;
  final int currentVersion;
  final int? latestScore;
  final String latestSummary;
  final List<WritingSubmissionVersion> versions;
  final int versionsTotal;
  final int versionsLimit;
  final int versionsOffset;
  final bool versionsHasMore;
  final DateTime? lastAnalyzedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
