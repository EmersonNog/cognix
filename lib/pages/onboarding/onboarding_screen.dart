import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../services/local/onboarding_storage.dart';

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
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed('login');
  }

  Widget _buildIllustration(BuildContext context, String asset, Color glow) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final shortScreen = screenHeight < 760;
    final denseScreen = screenHeight < 700;
    final illustrationHeight = denseScreen
        ? 176.0
        : shortScreen
        ? 216.0
        : 260.0;
    final haloSize = denseScreen
        ? 150.0
        : shortScreen
        ? 186.0
        : 220.0;
    final baseWidth = denseScreen
        ? 208.0
        : shortScreen
        ? 234.0
        : 260.0;
    final baseHeight = denseScreen
        ? 100.0
        : shortScreen
        ? 118.0
        : 140.0;
    final imageWidth = denseScreen
        ? 188.0
        : shortScreen
        ? 228.0
        : 280.0;
    final stackWidth = math.max(baseWidth, math.max(haloSize, imageWidth));

    return SizedBox(
      width: stackWidth,
      height: illustrationHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: denseScreen ? 2 : 10,
            child: Container(
              width: haloSize,
              height: haloSize,
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
              width: baseWidth,
              height: baseHeight,
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
          Image.asset(asset, width: imageWidth, fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    String text,
    List<String> highlights,
    Color accent,
  ) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final compactScreen = screenWidth < 380;
    final denseWidth = screenWidth < 360;
    final shortScreen = screenHeight < 760;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(color: _muted, fontSize: 18, height: 1.5),
        ),
        SizedBox(height: shortScreen ? 14 : 18),
        Container(
          padding: EdgeInsets.fromLTRB(
            denseWidth ? 12 : 14,
            shortScreen ? 12 : 14,
            denseWidth ? 12 : 14,
            shortScreen
                ? 12
                : compactScreen
                ? 14
                : 16,
          ),
          decoration: BoxDecoration(
            color: _surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _outline.withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Destaques',
                style: TextStyle(
                  color: _caption,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: shortScreen ? 8 : 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = denseWidth ? 6.0 : 8.0;
                  final gridWidth = constraints.maxWidth > 420
                      ? 420.0
                      : constraints.maxWidth;
                  final itemWidth = (gridWidth - spacing) / 2;
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: gridWidth,
                      child: Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: highlights
                            .map(
                              (item) => SizedBox(
                                width: itemWidth,
                                child: _HighlightChip(
                                  label: item,
                                  accent: accent,
                                  compact: compactScreen || shortScreen,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  PageDecoration _pageDecoration(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final shortScreen = screenHeight < 760;
    final denseScreen = screenHeight < 700;
    final horizontalMargin = screenWidth < 360
        ? 16.0
        : screenWidth < 390
        ? 20.0
        : 28.0;

    return PageDecoration(
      pageColor: _background,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: denseScreen
            ? 26
            : shortScreen
            ? 28
            : 30,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      bodyTextStyle: TextStyle(
        color: _muted,
        fontSize: shortScreen ? 17 : 18,
        height: 1.5,
      ),
      imageFlex: shortScreen ? 4 : 1,
      bodyFlex: shortScreen ? 5 : 1,
      imagePadding: EdgeInsets.only(
        top: denseScreen
            ? 8
            : shortScreen
            ? 16
            : 32,
        bottom: shortScreen ? 8 : 12,
      ),
      contentMargin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      titlePadding: EdgeInsets.only(
        top: denseScreen
            ? 8
            : shortScreen
            ? 10
            : 16,
        bottom: shortScreen ? 16 : 24,
      ),
      safeArea: shortScreen ? 72 : 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortScreen = MediaQuery.sizeOf(context).height < 760;

    return IntroductionScreen(
      globalBackgroundColor: _background,
      pages: [
        PageViewModel(
          title: 'inteligência Artificial',
          bodyWidget: _buildBody(
            context,
            'Gere mapas mentais com IA para organizar ideias, acelerar revisões e entrar no foco mais rápido.',
            const [
              'Mapas rápidos',
              'Foco por assunto',
              'Revisão visual',
              'Clareza imediata',
            ],
            const Color(0xFFFF7C68),
          ),
          image: _buildIllustration(
            context,
            'assets/onboarding/onboarding_ai_maps.png',
            const Color(0xFFFF7C68),
          ),
          decoration: _pageDecoration(context),
        ),
        PageViewModel(
          title: 'Treino direcionado',
          bodyWidget: _buildBody(
            context,
            'Organize o estudo por áreas e disciplinas para evoluir com clareza.',
            const [
              'Rotas por área',
              'Áreas-chave',
              'Progresso por área',
              'Revisões inteligentes',
            ],
            const Color(0xFF8FA2FF),
          ),
          image: _buildIllustration(
            context,
            'assets/onboarding/onboarding_focus.png',
            const Color(0xFF8FA2FF),
          ),
          decoration: _pageDecoration(context),
        ),
        PageViewModel(
          title: 'Simulados com foco',
          bodyWidget: _buildBody(
            context,
            'Acompanhe tentativas, tempo e consistência para ajustar o ritmo.',
            const [
              'Continuar simulado',
              'Ver resultados',
              'Resumo do simulado',
              'Mapa mental',
            ],
            const Color(0xFF44D1C2),
          ),
          image: _buildIllustration(
            context,
            'assets/onboarding/onboarding_simulados.png',
            const Color(0xFF44D1C2),
          ),
          decoration: _pageDecoration(context),
        ),
        PageViewModel(
          title: 'Métricas reais',
          bodyWidget: _buildBody(
            context,
            'Veja seu desempenho de forma objetiva e tome melhores decisões.',
            const [
              'Pontos de atenção',
              'Maior acerto',
              'Menor acerto',
              'Tempo por simulado',
            ],
            const Color(0xFFF5B74C),
          ),
          image: _buildIllustration(
            context,
            'assets/onboarding/onboarding_insights.png',
            const Color(0xFFF5B74C),
          ),
          decoration: _pageDecoration(context),
        ),
      ],
      showSkipButton: true,
      skip: const Text('Pular', style: TextStyle(color: _muted)),
      next: const Icon(Icons.arrow_forward_rounded, color: _accent),
      done: const Text(
        'Começar',
        style: TextStyle(color: _accent, fontWeight: FontWeight.w600),
      ),
      controlsPadding: EdgeInsets.fromLTRB(
        16,
        shortScreen ? 8 : 16,
        16,
        shortScreen ? 10 : 16,
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

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({
    required this.label,
    required this.accent,
    required this.compact,
  });

  final String label;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 38 : 40),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 12,
        vertical: compact ? 7 : 8,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: _HighlightChipLabel(label: label, compact: compact),
    );
  }
}

class _HighlightChipLabel extends StatelessWidget {
  const _HighlightChipLabel({required this.label, required this.compact});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
