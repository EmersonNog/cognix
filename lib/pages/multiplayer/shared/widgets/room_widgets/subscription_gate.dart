part of '../room_widgets.dart';

class MultiplayerSubscriptionGate extends StatelessWidget {
  const MultiplayerSubscriptionGate({
    super.key,
    required this.palette,
    required this.onPressed,
    this.message,
  });

  final MultiplayerPalette palette;
  final VoidCallback onPressed;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final features = <_SubscriptionFeatureData>[
      const _SubscriptionFeatureData(
        icon: Icons.add_home_work_rounded,
        label: 'Criar salas fechadas',
      ),
      const _SubscriptionFeatureData(
        icon: Icons.pin_rounded,
        label: 'Compartilhar PIN',
      ),
      const _SubscriptionFeatureData(
        icon: Icons.bolt_rounded,
        label: 'Partidas em tempo real',
      ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.primary.withValues(alpha: 0.26)),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withValues(alpha: 0.08),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.primary.withValues(alpha: 0.18),
            palette.surfaceContainer.withValues(alpha: 0.98),
            palette.surfaceContainerHigh.withValues(alpha: 0.98),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -44,
            right: -22,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.secondary.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -72,
            left: -36,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.primary.withValues(alpha: 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: palette.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: palette.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: palette.secondary,
                            size: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'MULTIPLAYER PREMIUM',
                            style: GoogleFonts.plusJakartaSans(
                              color: palette.secondary,
                              fontSize: 10.2,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: palette.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        color: palette.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Arena multiplayer pronta com assinatura ativa.',
                  style: GoogleFonts.manrope(
                    color: palette.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Desbloqueie criação de salas, lobby com participantes e partidas sincronizadas para jogar com a galera em tempo real.',
                  style: GoogleFonts.inter(
                    color: palette.onSurfaceMuted,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: palette.surface.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: palette.onSurface.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: palette.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.groups_2_rounded,
                              color: palette.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Preview da sala',
                                  style: GoogleFonts.manrope(
                                    color: palette.onSurface,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tudo liberado quando o acesso premium estiver ativo.',
                                  style: GoogleFonts.inter(
                                    color: palette.onSurfaceMuted,
                                    fontSize: 11.8,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _SubscriptionPreviewMetric(
                              palette: palette,
                              value: '30',
                              label: 'vagas',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _SubscriptionPreviewMetric(
                              palette: palette,
                              value: 'AO VIVO',
                              label: 'status',
                              isAccent: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: palette.surfaceContainerHigh.withValues(
                            alpha: 0.72,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PIN DA SALA',
                              style: GoogleFonts.plusJakartaSans(
                                color: palette.primary,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'XX  XX  XX',
                              style: GoogleFonts.plusJakartaSans(
                                color: palette.onSurface,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final feature in features)
                      _SubscriptionFeatureChip(
                        palette: palette,
                        feature: feature,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: palette.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.card_membership_rounded, size: 18),
                    label: Text(
                      'Ver assinatura',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
