part of '../writing_editor_screen.dart';

class _WritingAiLoadingScreen extends StatefulWidget {
  const _WritingAiLoadingScreen({
    required this.title,
    required this.subtitle,
    required this.steps,
  });

  final String title;
  final String subtitle;
  final List<String> steps;

  @override
  State<_WritingAiLoadingScreen> createState() =>
      _WritingAiLoadingScreenState();
}

class _WritingAiLoadingScreenState extends State<_WritingAiLoadingScreen> {
  Timer? _timer;
  int _activeIndex = 0;

  List<String> get _steps =>
      widget.steps.isEmpty ? const ['Processando com IA'] : widget.steps;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1450), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _activeIndex = (_activeIndex + 1) % _steps.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final steps = _steps;
    final activeStep = steps[_activeIndex];

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.surface,
              colors.primary.withValues(alpha: 0.24),
              colors.surfaceContainer,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -72,
              right: -48,
              child: _LoadingGlow(
                size: 210,
                color: colors.accent.withValues(alpha: 0.18),
              ),
            ),
            Positioned(
              bottom: -92,
              left: -56,
              child: _LoadingGlow(
                size: 240,
                color: colors.primary.withValues(alpha: 0.2),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.18),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.28),
                            blurRadius: 34,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 96,
                            height: 96,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 92,
                                  height: 92,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors.primary,
                                    ),
                                    backgroundColor: colors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 66,
                                  height: 66,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [colors.primary, colors.accent],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colors.primary.withValues(
                                          alpha: 0.28,
                                        ),
                                        blurRadius: 24,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              color: colors.onSurface,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: colors.onSurfaceMuted,
                              fontSize: 13,
                              height: 1.38,
                            ),
                          ),
                          const SizedBox(height: 22),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.18),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              activeStep,
                              key: ValueKey(activeStep),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: colors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Isso pode levar alguns segundos.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: colors.onSurfaceMuted,
                              fontSize: 12.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingGlow extends StatelessWidget {
  const _LoadingGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
