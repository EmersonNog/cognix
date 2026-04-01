import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingHeader extends StatelessWidget {
  const TrainingHeader({
    super.key,
    required this.title,
    required this.timeLabel,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.surfaceContainerHigh,
    this.paused = false,
    this.onPauseToggle,
  });

  final String title;
  final String timeLabel;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color surfaceContainerHigh;
  final bool paused;
  final VoidCallback? onPauseToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: onSurfaceMuted,
            fontSize: 10.5,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _InfoChip(
              icon: Icons.timer_rounded,
              label: timeLabel,
              surfaceContainerHigh: surfaceContainerHigh,
              onSurface: onSurface,
            ),
            const SizedBox(width: 12),
            _GhostChip(
              label: paused ? 'RETOMAR' : 'PAUSAR',
              surfaceContainerHigh: surfaceContainerHigh,
              primary: primary,
              onTap: onPauseToggle,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.surfaceContainerHigh,
    required this.onSurface,
  });

  final IconData icon;
  final String label;
  final Color surfaceContainerHigh;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: onSurface),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GhostChip extends StatelessWidget {
  const _GhostChip({
    required this.label,
    required this.surfaceContainerHigh,
    required this.primary,
    this.onTap,
  });

  final String label;
  final Color surfaceContainerHigh;
  final Color primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: surfaceContainerHigh.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: primary,
              fontSize: 10.5,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
