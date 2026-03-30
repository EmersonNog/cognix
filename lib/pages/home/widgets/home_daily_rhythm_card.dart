import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDailyRhythmCard extends StatelessWidget {
  const HomeDailyRhythmCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.primaryDim,
    required this.userName,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final Color primaryDim;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RITMO DIARIO',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Bom ver você de\nnovo, ',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                TextSpan(
                  text: '$userName.',
                  style: GoogleFonts.manrope(
                    color: primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '68%',
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'da meta semanal\natingida',
                  style: GoogleFonts.inter(
                    color: onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Container(
                height: 8,
                width: 180,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('plan'),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Ver Planos',
                style: GoogleFonts.plusJakartaSans(
                  color: onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
