import 'package:flutter/material.dart';

class CognixGradientBlob extends StatelessWidget {
  const CognixGradientBlob({
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

class CognixGlassBadge extends StatelessWidget {
  const CognixGlassBadge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0x99192540),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(child: child),
    );
  }
}
