import 'package:flutter/material.dart';

class GradientBlob extends StatelessWidget {
  const GradientBlob({
    super.key,
    required this.size,
    required this.colorA,
    required this.colorB,
  });

  final double size;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [colorA, colorB]),
      ),
    );
  }
}

class GlassBadge extends StatelessWidget {
  const GlassBadge({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0x99192540),
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: child),
    );
  }
}
