import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../services/local/onboarding_storage.dart';
import 'onboarding_layout.dart';
import 'widgets/onboarding_illustration.dart';
import 'widgets/onboarding_page_body.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _background = Color(0xFF060E20);
  static const _accent = Color(0xFF8FA2FF);
  static const _muted = Color(0xFFB7C0E3);
  static const _caption = Color(0xFF8E9AC7);
  static const _surface = Color(0xFF0E1733);
  static const _outline = Color(0xFF223055);

  Future<void> _finish(BuildContext context) async {
    await OnboardingStorage.markSeen();
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed('login');
  }

  PageDecoration _pageDecoration(OnboardingLayout layout) {
    return PageDecoration(
      pageColor: _background,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: layout.titleFontSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      bodyTextStyle: TextStyle(
        color: _muted,
        fontSize: layout.pageBodyFontSize,
        height: 1.5,
      ),
      imageFlex: layout.imageFlex,
      bodyFlex: layout.bodyFlex,
      imagePadding: EdgeInsets.only(
        top: layout.imageTopPadding,
        bottom: layout.imageBottomPadding,
      ),
      contentMargin: EdgeInsets.symmetric(horizontal: layout.horizontalMargin),
      titlePadding: EdgeInsets.only(
        top: layout.titleTopPadding,
        bottom: layout.titleBottomPadding,
      ),
      safeArea: layout.safeArea,
    );
  }

  PageViewModel _buildPage(OnboardingLayout layout, _OnboardingPageSpec spec) {
    return PageViewModel(
      title: spec.title,
      bodyWidget: OnboardingPageBody(
        layout: layout,
        text: spec.body,
        highlights: spec.highlights,
        accent: spec.accent,
        muted: _muted,
        caption: _caption,
        surface: _surface,
        outline: _outline,
      ),
      image: OnboardingIllustration(
        layout: layout,
        asset: spec.asset,
        glow: spec.accent,
      ),
      decoration: _pageDecoration(layout),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = OnboardingLayout.fromSize(MediaQuery.sizeOf(context));
    final pages = _onboardingPages
        .map((spec) => _buildPage(layout, spec))
        .toList();

    return IntroductionScreen(
      globalBackgroundColor: _background,
      pages: pages,
      showSkipButton: true,
      skip: const Text('Pular', style: TextStyle(color: _muted)),
      next: const Icon(Icons.arrow_forward_rounded, color: _accent),
      done: const Text(
        'Comecar',
        style: TextStyle(color: _accent, fontWeight: FontWeight.w600),
      ),
      controlsPadding: EdgeInsets.fromLTRB(
        16,
        layout.controlsTopPadding,
        16,
        layout.controlsBottomPadding,
      ),
      onDone: () => _finish(context),
      onSkip: () => _finish(context),
      dotsDecorator: DotsDecorator(
        color: const Color(0xFF273053),
        activeColor: _accent,
        size: const Size(8, 8),
        activeSize: const Size(18, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _OnboardingPageSpec {
  const _OnboardingPageSpec({
    required this.title,
    required this.body,
    required this.highlights,
    required this.asset,
    required this.accent,
  });

  final String title;
  final String body;
  final List<String> highlights;
  final String asset;
  final Color accent;
}

const List<_OnboardingPageSpec> _onboardingPages = [
  _OnboardingPageSpec(
    title: 'Inteligência Artificial',
    body:
        'Gere mapas mentais com IA para organizar ideias, acelerar revisões e entrar no foco mais rápido.',
    highlights: [
      'Mapas rápidos',
      'Foco por assunto',
      'Revisão visual',
      'Clareza imediata',
    ],
    asset: 'assets/onboarding/onboarding_ai_maps.png',
    accent: Color(0xFFFF7C68),
  ),
  _OnboardingPageSpec(
    title: 'Treino direcionado',
    body: 'Organize o estudo por áreas e disciplinas para evoluir com clareza.',
    highlights: [
      'Revisão guiada',
      'Áreas-chave',
      'Progresso por área',
      'Ganhe tempo',
    ],
    asset: 'assets/onboarding/onboarding_focus.png',
    accent: Color(0xFF8FA2FF),
  ),
  _OnboardingPageSpec(
    title: 'Simulados com foco',
    body: 'Acompanhe tentativas, tempo e consistência para ajustar o ritmo.',
    highlights: [
      'Treino contínuo',
      'Ver resultados',
      'Ver desempenho',
      'Mapa mental',
    ],
    asset: 'assets/onboarding/onboarding_simulados.png',
    accent: Color(0xFF44D1C2),
  ),
  _OnboardingPageSpec(
    title: 'Metricas reais',
    body: 'Veja seu desempenho de forma objetiva e tome melhores decisões.',
    highlights: [
      'Pontos de atenção',
      'Maior acerto',
      'Menor acerto',
      'Ritmo do simulado',
    ],
    asset: 'assets/onboarding/onboarding_insights.png',
    accent: Color(0xFFF5B74C),
  ),
];
