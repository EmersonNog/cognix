part of '../writing_editor_screen.dart';

Color _difficultyAccent(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return const Color(0xFF65E6A5);
    case 'dificil':
    case 'difícil':
      return const Color(0xFFFF8E9D);
    default:
      return AppTheme.darkColors.accent;
  }
}

String _formatDifficultyLabel(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return 'Fácil';
    case 'medio':
    case 'médio':
      return 'Médio';
    case 'dificil':
    case 'difícil':
      return 'Difícil';
    default:
      return value.trim().isEmpty ? 'Médio' : value.trim();
  }
}
