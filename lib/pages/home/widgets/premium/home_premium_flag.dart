import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/entitlements/entitlements_api.dart';

class HomePremiumFlag extends StatelessWidget {
  const HomePremiumFlag({
    super.key,
    required this.entitlementsFuture,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.accent,
    required this.onOpenPremium,
    required this.onManageSubscription,
  });

  final Future<EntitlementStatus> entitlementsFuture;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final Color accent;
  final VoidCallback onOpenPremium;
  final VoidCallback onManageSubscription;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EntitlementStatus>(
      future: entitlementsFuture,
      builder: (context, snapshot) {
        final subscription = snapshot.data?.subscription;
        final hasAccess = subscription?.hasAccess == true;
        final shouldManageSubscription =
            hasAccess ||
            subscription?.canCancel == true ||
            subscription?.willCancelAtPeriodEnd == true;
        final title = shouldManageSubscription
            ? 'Gerenciar assinatura'
            : 'Assinar Premium';
        final subtitle = shouldManageSubscription
            ? hasAccess
                  ? 'Acompanhe seu plano atual, renovação e acesso premium.'
                  : 'Confira o status da sua assinatura e os detalhes do plano.'
            : 'Planos mensal e anual para destravar recursos avançados.';
        final onPressed = shouldManageSubscription
            ? onManageSubscription
            : onOpenPremium;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [surfaceContainer, surfaceContainerHigh],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: primary.withValues(alpha: 0.18)),
                boxShadow: [
                  BoxShadow(
                    color: primaryDim.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -18,
                    right: -12,
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accent.withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                          height: 56,
                          child: _HomePremiumSignalBar(
                            primary: primary,
                            primaryDim: primaryDim,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.11),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'COGNIX PREMIUM',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: primary,
                                    fontSize: 10.5,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                style: GoogleFonts.manrope(
                                  color: onSurface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: GoogleFonts.inter(
                                  color: onSurfaceMuted,
                                  fontSize: 12.2,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomePremiumSignalBar extends StatefulWidget {
  const _HomePremiumSignalBar({
    required this.primary,
    required this.primaryDim,
  });

  final Color primary;
  final Color primaryDim;

  @override
  State<_HomePremiumSignalBar> createState() => _HomePremiumSignalBarState();
}

class _HomePremiumSignalBarState extends State<_HomePremiumSignalBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = Curves.easeInOut.transform(_controller.value);
        final barAlpha = 0.72 + (0.28 * pulse);
        final glowAlpha = 0.16 + (0.22 * pulse);
        final glowBlur = 10.0 + (10.0 * pulse);

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: widget.primary.withValues(alpha: barAlpha),
            boxShadow: [
              BoxShadow(
                color: widget.primary.withValues(alpha: glowAlpha),
                blurRadius: glowBlur,
                spreadRadius: 1.2 + pulse,
              ),
            ],
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
