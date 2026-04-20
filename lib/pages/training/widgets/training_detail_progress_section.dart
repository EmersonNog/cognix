import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/summaries/summaries_api.dart';

class TrainingDetailProgressSection extends StatelessWidget {
  const TrainingDetailProgressSection({
    super.key,
    required this.progressFuture,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Future<TrainingProgressData> progressFuture;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrainingProgressData>(
      future: progressFuture,
      builder: (context, snapshot) {
        final progressData = snapshot.data;
        final progress = progressData?.progress ?? 0.0;
        final answered = progressData?.answeredQuestions ?? 0;
        final total = progressData?.totalQuestions ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SEU PROGRESSO',
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurfaceMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.manrope(
                    color: onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$answered de $total questões respondidas nesta sessão',
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: onSurfaceMuted.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
