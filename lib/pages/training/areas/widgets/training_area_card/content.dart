part of '../training_area_card.dart';

class _TrainingAreaCardContent extends StatelessWidget {
  const _TrainingAreaCardContent({required this.card, required this.style});

  final TrainingAreaCard card;
  final _TrainingAreaCardStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: style.leadingIconBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: style.leadingIconBorder),
            ),
            child: Icon(card.item.icon, color: card.item.accent, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: style.pillBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Área de treino',
                    style: GoogleFonts.plusJakartaSans(
                      color: card.item.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  card.item.title,
                  style: GoogleFonts.manrope(
                    color: card.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  card.item.subtitle,
                  style: GoogleFonts.inter(
                    color: card.onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: style.countBackground,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: style.countBorder),
                      ),
                      child: Text(
                        '${card.totalQuestions} questoes',
                        style: GoogleFonts.plusJakartaSans(
                          color: card.onSurface,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            card.locked ? 'Requer assinatura' : 'Entrar agora',
                            style: GoogleFonts.plusJakartaSans(
                              color: card.item.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: style.trailingBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: style.trailingBorder),
            ),
            child: Icon(
              card.locked ? Icons.lock_rounded : Icons.arrow_forward_rounded,
              color: style.trailingIconColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
