part of '../subjects_tab.dart';

class _SubjectCardData {
  const _SubjectCardData({required this.item, required this.status});

  final SubcategoryItem item;
  final _SubjectCardStatus status;
}

class _SubjectCardStatus {
  const _SubjectCardStatus({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  const _SubjectCardStatus.completed()
    : label = 'Concluída',
      foregroundColor = const Color(0xFF31C48D),
      backgroundColor = const Color(0x1431C48D);

  const _SubjectCardStatus.inProgress()
    : label = 'Em andamento',
      foregroundColor = const Color(0xFFF5B942),
      backgroundColor = const Color(0x14F5B942);

  const _SubjectCardStatus.available()
    : label = 'Disponível',
      foregroundColor = const Color(0xFF8FA7FF),
      backgroundColor = const Color(0x148FA7FF);

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
}
