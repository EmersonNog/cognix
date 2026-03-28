import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.progressLabel,
    required this.icon,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String description;
  final double progress;
  final String progressLabel;
  final IconData icon;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: onSurface,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        color: onSurfaceMuted,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 5,
                    color: surfaceContainerHigh,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),
                      alignment: Alignment.centerLeft,
                      child: Container(color: primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded, color: primary, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            progressLabel,
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
