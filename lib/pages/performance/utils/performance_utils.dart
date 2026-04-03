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
    return 'Ci\u00EAncias Humanas';
  }
  if (normalized.contains('natureza')) {
    return 'Ci\u00EAncias da Natureza';
  }
  if (normalized.contains('matem')) {
    return 'Matem\u00E1tica';
  }

  return value;
}

String performanceShortSubcategoryName(String value) {
  final trimmed = value.trim();
  if (trimmed.length <= 28) {
    return trimmed;
  }

  return '${trimmed.substring(0, 28).trimRight()}...';
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
  return value == 1 ? '1 tentativa.' : '$value tentativas.';
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
      ? 'Seu hist\u00F3rico ainda est\u00E1 distribuindo volume entre poucas refer\u00EAncias.'
      : 'Voc\u00EA mostra mais presen\u00E7a em ${performanceShortDisciplineName(leaderDiscipline)}.';

  final coverage = activeDisciplineCount >= 4
      ? 'Seu treino j\u00E1 passou por todas as \u00E1reas de conhecimentos.'
      : activeDisciplineCount >= 2
      ? 'Seu estudo j\u00E1 est\u00E1 mais distribu\u00EDdo, mas ainda pode ganhar mais equil\u00EDbrio entre as \u00E1reas.'
      : 'Seu estudo ainda est\u00E1 concentrado em poucas \u00E1reas.';

  final rhythm = activeDaysLast30 >= (consistencyWindowDays * 0.7)
      ? 'A rotina recente indica uma cad\u00EAncia forte.'
      : activeDaysLast30 >= (consistencyWindowDays * 0.4)
      ? 'A rotina j\u00E1 tem uma base boa, mas ainda pede mais regularidade.'
      : 'Seu desempenho ainda depende bastante de ganhar frequ\u00EAncia.';

  final quality = accuracyPercent >= 75
      ? 'Sua taxa de acerto est\u00E1 em um bom n\u00EDvel.'
      : accuracyPercent >= 55
      ? 'Sua taxa de acerto est\u00E1 evoluindo, mas ainda h\u00E1 espa\u00E7o para ganhar mais consist\u00EAncia.'
      : 'Sua taxa de acerto ainda pede mais revis\u00E3o e refor\u00E7o nos estudos.';

  final simulation = completedSessions >= 15
      ? 'Seu hist\u00F3rico de simulados j\u00E1 oferece uma leitura mais consistente do seu comportamento.'
      : completedSessions >= 5
      ? 'Voc\u00EA j\u00E1 tem uma base inicial de simulados para observar seu comportamento.'
      : 'Ainda h\u00E1 espa\u00E7o para usar mais simulados como refer\u00EAncia do seu desempenho.';

  return '$focus $coverage $rhythm $quality $simulation';
}
