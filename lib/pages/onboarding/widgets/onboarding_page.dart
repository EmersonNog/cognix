import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';
import '../onboarding_pages.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.spec,
    required this.colors,
    required this.horizontalPadding,
  });

  final OnboardingPageSpec spec;
  final CognixThemeColors colors;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortScreen = constraints.maxHeight < 560;
        final imageHeight = shortScreen ? 174.0 : 246.0;
        final imageTopGap = shortScreen ? 12.0 : 34.0;
        final titleGap = shortScreen ? 20.0 : 32.0;
        final bodyGap = shortScreen ? 12.0 : 16.0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: imageTopGap),
                  Image.asset(
                    spec.asset,
                    height: imageHeight,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(height: titleGap),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      spec.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        color: colors.onSurface,
                        fontSize: shortScreen ? 29 : 34,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                      ),
                    ),
                  ),
                  SizedBox(height: bodyGap),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      spec.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: colors.onSurfaceMuted,
                        fontSize: shortScreen ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        height: 1.52,
                      ),
                    ),
                  ),
                  SizedBox(height: shortScreen ? 16 : 28),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
