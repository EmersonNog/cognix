import 'package:flutter/material.dart';

import '../onboarding_layout.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.layout,
    required this.asset,
    required this.glow,
  });

  final OnboardingLayout layout;
  final String asset;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: layout.illustrationStackWidth,
      height: layout.illustrationHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: layout.illustrationHaloTop,
            child: Container(
              width: layout.illustrationHaloSize,
              height: layout.illustrationHaloSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [glow.withValues(alpha: 0.35), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: layout.illustrationBaseWidth,
              height: layout.illustrationBaseHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [glow.withValues(alpha: 0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          Image.asset(
            asset,
            width: layout.illustrationImageWidth,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
