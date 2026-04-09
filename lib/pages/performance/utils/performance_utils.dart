import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../services/profile/profile_api.dart';

class PerformanceViewData {
  const PerformanceViewData({
    required this.disciplines,
    required this.totalQuestions,
    required this.activeDisciplineCount,
    required this.leader,
    required this.underused,
    required this.strongestSubcategory,
    required this.weakestSubcategory,
    required this.attentionSubcategoriesCount,
    required this.attentionAccuracyThreshold,
    required this.errorCount,
    required this.averageSecondsPerQuestion,
    required this.hasWeeklyRhythmBase,
    required this.weeklyQuestionAverage,
    required this.secondsPerSimulation,
    required this.completedSessions,
    required this.questionsAnswered,
    required this.totalCorrect,
    required this.accuracyPercent,
    required this.consistencyWindowDays,
    required this.activeDaysLast30,
  });

  final List<ProfileDisciplineStat> disciplines;
  final int totalQuestions;
  final int activeDisciplineCount;
  final ProfileDisciplineStat? leader;
  final ProfileDisciplineStat? underused;
  final ProfileSubcategoryInsight? strongestSubcategory;
  final ProfileSubcategoryInsight? weakestSubcategory;
  final int attentionSubcategoriesCount;
  final double attentionAccuracyThreshold;
  final int errorCount;
  final int averageSecondsPerQuestion;
  final bool hasWeeklyRhythmBase;
  final double weeklyQuestionAverage;
  final int secondsPerSimulation;
  final int completedSessions;
  final int questionsAnswered;
  final int totalCorrect;
  final double accuracyPercent;
  final int consistencyWindowDays;
  final int activeDaysLast30;

  factory PerformanceViewData.fromProfile(ProfileScoreData profile) {
    final disciplines = [...profile.questionsByDiscipline]
      ..sort((a, b) => b.count.compareTo(a.count));
    final totalQuestions = math.max(profile.questionsAnswered, 1);
    final activeDisciplineCount = disciplines
        .where((item) => item.count > 0)
        .length;
    final leader = disciplines.isNotEmpty ? disciplines.first : null;
    final underused = disciplines.length > 1 ? disciplines.last : leader;
    final errorCount = math.max(
      0,
      profile.questionsAnswered - profile.totalCorrect,
    );
    final averageSecondsPerQuestion = profile.questionsAnswered == 0
        ? 0
        : (profile.totalStudySeconds / profile.questionsAnswered).round();
    final hasWeeklyRhythmBase = profile.activeDaysLast30 >= 3;
    final weeklyQuestionAverage = profile.consistencyWindowDays == 0
        ? 0.0
        : (profile.questionsAnswered / profile.consistencyWindowDays) * 7;
    final secondsPerSimulation = profile.completedSessions == 0
        ? 0
        : (profile.totalStudySeconds / profile.completedSessions).round();

    return PerformanceViewData(
      disciplines: disciplines,
      totalQuestions: totalQuestions,
      activeDisciplineCount: activeDisciplineCount,
      leader: leader,
      underused: underused,
      strongestSubcategory: profile.strongestSubcategory,
      weakestSubcategory: profile.weakestSubcategory,
      attentionSubcategoriesCount: profile.attentionSubcategoriesCount,
      attentionAccuracyThreshold: profile.attentionAccuracyThreshold,
      errorCount: errorCount,
      averageSecondsPerQuestion: averageSecondsPerQuestion,
      hasWeeklyRhythmBase: hasWeeklyRhythmBase,
      weeklyQuestionAverage: weeklyQuestionAverage,
      secondsPerSimulation: secondsPerSimulation,
      completedSessions: profile.completedSessions,
      questionsAnswered: profile.questionsAnswered,
      totalCorrect: profile.totalCorrect,
      accuracyPercent: profile.accuracyPercent,
      consistencyWindowDays: profile.consistencyWindowDays,
      activeDaysLast30: profile.activeDaysLast30,
    );
  }
}

String performanceShortDisciplineName(String value) {
  final normalized = value.trim().toLowerCase();

  if (normalized.contains('linguagens')) {
    return 'Linguagens';
  }
  if (normalized.contains('humanas')) {
    return 'Ciências Humanas';
  }
  if (normalized.contains('natureza')) {
    return 'Ciências da Natureza';
  }
  if (normalized.contains('matem')) {
    return 'Matemática';
  }

  return value;
}

String performanceCompactDisciplineName(String value) {
  final normalized = value.trim().toLowerCase();

  if (normalized.contains('linguagens')) {
    return 'Linguagens';
  }
  if (normalized.contains('humanas')) {
    return 'Humanas';
  }
  if (normalized.contains('natureza')) {
    return 'Natureza';
  }
  if (normalized.contains('matem')) {
    return 'Matemática';
  }

  return value.trim();
}

String performanceShortSubcategoryName(String value) {
  final trimmed = value.trim();
  if (trimmed.length <= 28) {
    return trimmed;
  }

  return '${trimmed.substring(0, 28).trimRight()}...';
}

String performanceCompactSubcategoryName(String value) {
  final trimmed = value.trim();
  if (trimmed.length <= 20) {
    return trimmed;
  }

  return '${trimmed.substring(0, 20).trimRight()}...';
}

Color performanceDisciplineAccent(String value) {
  switch (_normalizeText(value)) {
    case 'linguagens, codigos e suas tecnologias':
      return const Color(0xFF7C9BFF);
    case 'ciencias humanas e suas tecnologias':
      return const Color(0xFFFF8A65);
    case 'ciencias da natureza e suas tecnologias':
      return const Color(0xFF49D7A8);
    case 'matematica e suas tecnologias':
      return const Color(0xFFFFC857);
    default:
      return const Color(0xFF8E7CFF);
  }
}

String _normalizeText(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('\u00E1', 'a')
      .replaceAll('\u00E0', 'a')
      .replaceAll('\u00E2', 'a')
      .replaceAll('\u00E3', 'a')
      .replaceAll('\u00E9', 'e')
      .replaceAll('\u00EA', 'e')
      .replaceAll('\u00ED', 'i')
      .replaceAll('\u00F3', 'o')
      .replaceAll('\u00F4', 'o')
      .replaceAll('\u00F5', 'o')
      .replaceAll('\u00FA', 'u')
      .replaceAll('\u00E7', 'c');
}

String performanceDisciplineShare(int count, int totalQuestions) {
  final ratio = totalQuestions == 0 ? 0 : (count / totalQuestions * 100);
  return '${ratio.toStringAsFixed(0)}%';
}

String performanceAttemptsLabel(int value) {
  return value == 1 ? '1 tentativa' : '$value tentativas';
}

String performanceAttentionHelper({required String subcategory}) {
  return 'Atenção em ${performanceCompactSubcategoryName(subcategory)}';
}

String performanceSubcategoryHelper({
  required String discipline,
  required String subcategory,
  required int totalAttempts,
}) {
  return '${performanceCompactDisciplineName(discipline)} • '
      '${performanceCompactSubcategoryName(subcategory)}\n'
      '${performanceAttemptsLabel(totalAttempts)}';
}

String performanceFormatSeconds(int value) {
  if (value <= 0) {
    return '0m';
  }
  if (value < 60) {
    return '${value}s';
  }

  final minutes = value ~/ 60;
  final seconds = value % 60;
  if (minutes >= 60) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  return seconds == 0 ? '${minutes}m' : '${minutes}m ${seconds}s';
}

String buildPerformanceNarrative({
  required String? leaderDiscipline,
  required int activeDisciplineCount,
  required int activeDaysLast30,
  required int consistencyWindowDays,
  required double accuracyPercent,
  required int completedSessions,
}) {
  final focus = leaderDiscipline == null
      ? 'Seu histórico ainda está distribuindo volume entre poucas referências.'
      : 'Você mostra mais presença em ${performanceShortDisciplineName(leaderDiscipline)}.';

  final coverage = activeDisciplineCount >= 4
      ? 'Seu treino já passou por todas as áreas de conhecimentos.'
      : activeDisciplineCount >= 2
      ? 'Seu estudo já está mais distribuído, mas ainda pode ganhar mais equilíbrio entre as áreas.'
      : 'Seu estudo ainda está concentrado em poucas áreas.';

  final rhythm = activeDaysLast30 >= (consistencyWindowDays * 0.7)
      ? 'A rotina recente indica uma cadência forte.'
      : activeDaysLast30 >= (consistencyWindowDays * 0.4)
      ? 'A rotina já tem uma base boa, mas ainda pede mais regularidade.'
      : 'Seu desempenho ainda depende bastante de ganhar frequência.';

  final quality = accuracyPercent >= 75
      ? 'Sua taxa de acerto está em um bom nível.'
      : accuracyPercent >= 55
      ? 'Sua taxa de acerto está evoluindo, mas ainda há espaço para ganhar mais consistência.'
      : 'Sua taxa de acerto ainda pede mais revisão e reforço nos estudos.';

  final simulation = completedSessions >= 15
      ? 'Seu histórico de simulados já oferece uma leitura mais consistente do seu comportamento.'
      : completedSessions >= 5
      ? 'Você já tem uma base inicial de simulados para observar seu comportamento.'
      : 'Ainda há espaço para usar mais simulados como referência do seu desempenho.';

  return '$focus $coverage $rhythm $quality $simulation';
}
