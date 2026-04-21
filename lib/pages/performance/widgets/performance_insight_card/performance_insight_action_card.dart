import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceInsightActionCard extends StatelessWidget {
  const PerformanceInsightActionCard({
    super.key,
    required this.nextAction,
    required this.primary,
    required this.onSurface,
  });

  final String nextAction;
  final Color primary;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_forward_rounded, color: primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              nextAction,
              style: GoogleFonts.inter(
                color: onSurface,
                fontSize: 12.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
