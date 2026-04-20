part of '../writing_editor_screen.dart';

const _editorSurface = Color(0xFF060E20);
const _editorSurfaceContainer = Color(0xFF0F1930);
const _editorSurfaceContainerHigh = Color(0xFF141F38);
const _editorSurfaceContainerLow = Color(0xFF101B32);
const _editorOnSurface = Color(0xFFDEE5FF);
const _editorOnSurfaceMuted = Color(0xFF9AA6C5);
const _editorPrimary = Color(0xFFA3A6FF);
const _editorAccent = Color(0xFFFFC56E);
const _editorSuccess = Color(0xFF7ED6C5);

Color _difficultyAccent(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return const Color(0xFF65E6A5);
    case 'dificil':
    case 'difícil':
      return const Color(0xFFFF8E9D);
    default:
      return _editorAccent;
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
