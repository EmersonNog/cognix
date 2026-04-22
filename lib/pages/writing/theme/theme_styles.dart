part of 'writing_theme_screen.dart';

class _DifficultyStyle {
  const _DifficultyStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

_DifficultyStyle _difficultyStyle(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return const _DifficultyStyle(
        background: Color(0x1A54D2A5),
        foreground: Color(0xFF7CF0C3),
      );
    case 'dificil':
    case 'difícil':
      return const _DifficultyStyle(
        background: Color(0x1AF36B7F),
        foreground: Color(0xFFFF8E9D),
      );
    case 'medio':
    case 'médio':
      return const _DifficultyStyle(
        background: Color(0x1AFFC56E),
        foreground: Color(0xFFFFC56E),
      );
    default:
      return const _DifficultyStyle(
        background: Color(0x1AA3A6FF),
        foreground: Color(0xFFA3A6FF),
      );
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

Color _categoryAccent(String category) {
  switch (category.trim().toLowerCase()) {
    case 'direitos humanos':
      return const Color(0xFFFFC56E);
    case 'cidadania':
      return const Color(0xFF7ED6C5);
    case 'educação':
    case 'educacao':
      return const Color(0xFFA3A6FF);
    case 'meio ambiente':
      return const Color(0xFF65E6A5);
    case 'saúde':
    case 'saude':
      return const Color(0xFFFF8E9D);
    case 'tecnologia':
      return const Color(0xFF8EC5FF);
    case 'cultura':
      return const Color(0xFFE6A8FF);
    case 'segurança':
    case 'seguranca':
      return const Color(0xFFFFA36E);
    default:
      return const Color(0xFFA3A6FF);
  }
}
