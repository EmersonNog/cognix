part of '../writing_history_detail_screen.dart';

String _shortDate(DateTime? value) {
  if (value == null) {
    return 'Sem data';
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month $hour:$minute';
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
