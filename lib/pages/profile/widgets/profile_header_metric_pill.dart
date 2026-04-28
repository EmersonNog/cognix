import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderMetricPill extends StatelessWidget {
  const ProfileHeaderMetricPill({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    required this.onSurface,
    this.isLocked = false,
  });

  final String label;
  final String value;
  final Color accent;
  final Color onSurface;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          if (isLocked)
            Icon(
              Icons.lock_rounded,
              color: onSurface.withValues(alpha: 0.82),
              size: 16,
            )
          else
            Text(
              value,
              style: GoogleFonts.manrope(
                color: onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}
