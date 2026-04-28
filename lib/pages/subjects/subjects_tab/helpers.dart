part of '../subjects_tab.dart';

List<String> _previewDisciplinesFor(SubjectsArea area) {
  return switch (area) {
    SubjectsArea.natureza => const ['Biologia', 'Física', 'Química'],
    SubjectsArea.humanas => const ['História', 'Geografia', 'Sociologia'],
    SubjectsArea.linguagens => const ['Português', 'Literatura', 'Inglês'],
    SubjectsArea.matematica => const ['Álgebra', 'Geometria', 'Probabilidade'],
  };
}

_SubjectCardStatus _statusFromProgress(TrainingProgressData progress) {
  if (progress.hasCompletedSession) {
    return const _SubjectCardStatus.completed();
  }
  if (progress.answeredQuestions > 0) {
    return const _SubjectCardStatus.inProgress();
  }
  return const _SubjectCardStatus.available();
}

IconData _iconFor(String discipline) {
  final text = discipline.toLowerCase();
  if (text.contains('matem')) return Icons.calculate_rounded;
  if (text.contains('fisic')) return Icons.science_rounded;
  if (text.contains('quim')) return Icons.biotech_rounded;
  if (text.contains('biolog')) return Icons.bubble_chart_rounded;
  if (text.contains('hist')) return Icons.public_rounded;
  if (text.contains('geo')) return Icons.map_rounded;
  if (text.contains('filos')) return Icons.psychology_rounded;
  if (text.contains('socio')) return Icons.groups_rounded;
  if (text.contains('port')) return Icons.menu_book_rounded;
  if (text.contains('liter')) return Icons.book_rounded;
  if (text.contains('ingl')) return Icons.language_rounded;
  if (text.contains('arte')) return Icons.palette_rounded;
  return Icons.auto_awesome_rounded;
}

String _descriptionFor(String discipline) {
  return 'Conteúdo disponível para treino e revisão.';
}
