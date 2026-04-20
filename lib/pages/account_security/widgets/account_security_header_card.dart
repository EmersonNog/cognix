import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_security_palette.dart';

class AccountSecurityHeaderCard extends StatelessWidget {
  const AccountSecurityHeaderCard({
    super.key,
    required this.providerLabel,
    this.email,
    this.displayName,
  });

  final String providerLabel;
  final String? email;
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AccountSecurityPalette.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AccountSecurityPalette.border),
        boxShadow: [
          BoxShadow(
            color: AccountSecurityPalette.shadow,
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AccountSecurityPalette.primary,
                  AccountSecurityPalette.primaryDim,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.shield_rounded,
              color: AccountSecurityPalette.primaryForeground,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Controle do acesso',
                  style: GoogleFonts.manrope(
                    color: AccountSecurityPalette.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Gerencie senha, provedor atual e a exclusão permanente da sua conta.',
                  style: GoogleFonts.inter(
                    color: AccountSecurityPalette.onSurfaceMuted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _AccountSecurityInfoChip(
                      icon: Icons.verified_user_rounded,
                      label: providerLabel,
                      color: AccountSecurityPalette.primary,
                    ),
                    if (email != null && email!.isNotEmpty)
                      _AccountSecurityInfoChip(
                        icon: Icons.mail_outline_rounded,
                        label: email!,
                        color: AccountSecurityPalette.secondary,
                      ),
                    if (displayName != null && displayName!.isNotEmpty)
                      _AccountSecurityInfoChip(
                        icon: Icons.person_outline_rounded,
                        label: displayName!,
                        color: AccountSecurityPalette.accent,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountSecurityInfoChip extends StatelessWidget {
  const _AccountSecurityInfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: AccountSecurityPalette.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
