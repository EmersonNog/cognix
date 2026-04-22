import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../training_detail_models.dart';

class TrainingDetailQuickActions extends StatelessWidget {
  const TrainingDetailQuickActions({
    super.key,
    required this.actions,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final List<TrainingQuickActionData> actions;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AÇÕES RÁPIDAS',
          style: GoogleFonts.plusJakartaSans(
            color: onSurfaceMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              _QuickActionItem(
                icon: actions[i].icon,
                label: actions[i].label,
                subtitle: actions[i].subtitle,
                surfaceContainerHigh: surfaceContainerHigh,
                onSurface: onSurface,
                onSurfaceMuted: onSurfaceMuted,
                onTap: actions[i].onTap,
              ),
              if (i != actions.length - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: onSurfaceMuted.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: onSurfaceMuted, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded, color: onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}
