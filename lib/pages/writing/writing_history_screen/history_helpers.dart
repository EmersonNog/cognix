part of '../writing_history_screen.dart';

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
      return _WritingHistoryScreenState._primary;
  }
}

class _Glow extends StatelessWidget {
  const _Glow({this.top, this.left, this.right, required this.color});

  final double? top;
  final double? left;
  final double? right;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.24), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
