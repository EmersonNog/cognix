import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';

class OnboardingControls extends StatelessWidget {
  const OnboardingControls({
    super.key,
    required this.colors,
    required this.isDark,
    required this.currentPage,
    required this.pageCount,
    required this.shortScreen,
    required this.horizontalPadding,
    required this.onNext,
  });

  final CognixThemeColors colors;
  final bool isDark;
  final int currentPage;
  final int pageCount;
  final bool shortScreen;
  final double horizontalPadding;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == pageCount - 1;
    final buttonColor = isDark ? colors.primary : const Color(0xFF05070D);
    final buttonForeground = isDark ? const Color(0xFF060E20) : Colors.white;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        shortScreen ? 10 : 16,
        horizontalPadding,
        shortScreen ? 16 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OnboardingDots(
            currentPage: currentPage,
            pageCount: pageCount,
            activeColor: colors.onSurface,
            inactiveColor: colors.onSurfaceMuted.withValues(alpha: 0.18),
          ),
          SizedBox(height: shortScreen ? 20 : 28),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: buttonColor,
                foregroundColor: buttonForeground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLastPage ? 'Começar' : 'Próximo',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (!isLastPage) ...[
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: buttonForeground,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({
    required this.currentPage,
    required this.pageCount,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int currentPage;
  final int pageCount;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final selected = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: selected ? 26 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
