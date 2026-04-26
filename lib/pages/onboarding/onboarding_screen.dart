import 'package:flutter/material.dart';

import '../../services/local/onboarding_storage.dart';
import '../../theme/cognix_theme_colors.dart';
import 'onboarding_pages.dart';
import 'widgets/onboarding_controls.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_top_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await OnboardingStorage.markSeen();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed('login');
  }

  void _goNext() {
    if (_currentPage == onboardingPages.length - 1) {
      _finish();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortScreen = constraints.maxHeight < 680;
            final horizontalPadding = constraints.maxWidth < 380 ? 24.0 : 32.0;

            return Column(
              children: [
                OnboardingTopBar(
                  colors: colors,
                  onSkip: _finish,
                  horizontalPadding: horizontalPadding,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingPages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        spec: onboardingPages[index],
                        colors: colors,
                        horizontalPadding: horizontalPadding,
                      );
                    },
                  ),
                ),
                OnboardingControls(
                  colors: colors,
                  isDark: isDark,
                  currentPage: _currentPage,
                  pageCount: onboardingPages.length,
                  shortScreen: shortScreen,
                  horizontalPadding: horizontalPadding,
                  onNext: _goNext,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
