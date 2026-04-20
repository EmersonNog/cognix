part of '../writing_theme_screen.dart';

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
            colors: [color.withValues(alpha: 0.28), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
