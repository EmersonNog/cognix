import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/cognix_theme_colors.dart';

class SubscriptionRequiredCard extends StatelessWidget {
  const SubscriptionRequiredCard({
    super.key,
    this.title = 'Acesso bloqueado',
    this.message = 'Evolua sua experiência com um plano de assinatura.',
    this.buttonLabel = 'Gerenciar acesso',
    this.compact = false,
    this.onPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primary.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 38 : 42,
                height: compact ? 38 : 42,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.lock_open_rounded,
                  color: colors.primary,
                  size: compact ? 20 : 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: colors.onSurface,
                        fontSize: compact ? 15.5 : 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message,
                      style: GoogleFonts.inter(
                        color: colors.onSurfaceMuted,
                        fontSize: compact ? 12.2 : 12.8,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onPressed != null) ...[
            SizedBox(height: compact ? 12 : 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.card_membership_rounded, size: 18),
                label: Text(buttonLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.surface,
                  padding: EdgeInsets.symmetric(vertical: compact ? 11 : 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
