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

  Widget _buildIllustration(String asset, Color glow) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [glow.withOpacity(0.35), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 260,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [glow.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          Image.asset(asset, width: 280, fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _buildBody(String text, List<String> highlights, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(color: _muted, fontSize: 18, height: 1.5),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: _surface.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _outline.withOpacity(0.6)),
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
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gridWidth = constraints.maxWidth > 320
                      ? 320.0
                      : constraints.maxWidth;
                  final itemWidth = (gridWidth - 8) / 2;
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: gridWidth,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: highlights
                            .map(
                              (item) => SizedBox(
                                width: itemWidth,
                                child: _HighlightChip(
                                  label: item,
                                  accent: accent,
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

  PageDecoration _pageDecoration() {
    return PageDecoration(
      pageColor: _background,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      bodyTextStyle: const TextStyle(color: _muted, fontSize: 18, height: 1.5),
      imagePadding: const EdgeInsets.only(top: 32, bottom: 12),
      contentMargin: const EdgeInsets.symmetric(horizontal: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: _background,
      pages: [
        PageViewModel(
          title: 'Treino direcionado',
          bodyWidget: _buildBody(
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
            'assets/onboarding/onboarding_focus.png',
            const Color(0xFF8FA2FF),
          ),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: 'Simulados com foco',
          bodyWidget: _buildBody(
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
            'assets/onboarding/onboarding_simulados.png',
            const Color(0xFF44D1C2),
          ),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: 'Métricas reais',
          bodyWidget: _buildBody(
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
            'assets/onboarding/onboarding_insights.png',
            const Color(0xFFF5B74C),
          ),
          decoration: _pageDecoration(),
        ),
      ],
      showSkipButton: true,
      skip: const Text('Pular', style: TextStyle(color: _muted)),
      next: const Icon(Icons.arrow_forward_rounded, color: _accent),
      done: const Text(
        'Começar',
        style: TextStyle(color: _accent, fontWeight: FontWeight.w600),
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
  const _HighlightChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
