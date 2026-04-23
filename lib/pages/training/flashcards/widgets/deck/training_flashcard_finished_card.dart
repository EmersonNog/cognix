import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardFinishedCard extends StatelessWidget {
  const TrainingFlashcardFinishedCard({
    super.key,
    required this.correctCount,
    required this.wrongCount,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.onReviewAgain,
  });

  final int correctCount;
  final int wrongCount;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final VoidCallback onReviewAgain;

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final totalAnswers = correctCount + wrongCount;
    final accuracy = totalAnswers == 0
        ? 0
        : ((correctCount / totalAnswers) * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: surfaceContainerHigh.withValues(alpha: 0.86)),
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(
              primary.withValues(alpha: isLightMode ? 0.05 : 0.08),
              surfaceContainer,
            ),
            surfaceContainer,
            Color.alphaBlend(
              primary.withValues(alpha: isLightMode ? 0.02 : 0.04),
              surfaceContainer,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isLightMode
                ? primary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.14),
            blurRadius: isLightMode ? 16 : 22,
            offset: Offset(0, isLightMode ? 8 : 14),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                primary.withValues(alpha: isLightMode ? 0.06 : 0.10),
                surfaceContainer,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isLightMode
                    ? primary.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primary.withValues(alpha: 0.28),
                        primary.withValues(alpha: 0.12),
                        primary.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.32),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sessão concluída',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Você terminou este deck. Continue revisando ou reinicie a sessão para fixar melhor o conteúdo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _FinishedStatCard(
                  label: 'Acertos',
                  value: '$correctCount',
                  accent: const Color(0xFF44D38A),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FinishedStatCard(
                  label: 'Erros',
                  value: '$wrongCount',
                  accent: const Color(0xFFFF7B7B),
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FinishedStatCard(
                  label: 'Domínio',
                  value: '$accuracy%',
                  accent: primary,
                  onSurface: onSurface,
                  onSurfaceMuted: onSurfaceMuted,
                  primary: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Reinicie o deck para revisar do zero.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onReviewAgain,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Revisar novamente'),
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinishedStatCard extends StatefulWidget {
  const _FinishedStatCard({
    required this.label,
    required this.value,
    required this.accent,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String label;
  final String value;
  final Color accent;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  State<_FinishedStatCard> createState() => _FinishedStatCardState();
}

class _FinishedStatCardState extends State<_FinishedStatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      decoration: BoxDecoration(
        color: isLightMode
            ? Color.alphaBlend(
                widget.primary.withValues(alpha: 0.05),
                Colors.white,
              )
            : Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLightMode
              ? widget.accent.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final pulseValue = _pulse.value;
              return Transform.scale(
                scale: 0.9 + (pulseValue * 0.25),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(
                      alpha: 0.78 + (pulseValue * 0.22),
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accent.withValues(
                          alpha: 0.2 + (pulseValue * 0.3),
                        ),
                        blurRadius: 8 + (pulseValue * 8),
                        spreadRadius: pulseValue * 1.4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Text(
            widget.value,
            style: GoogleFonts.manrope(
              color: widget.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              color: widget.onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
