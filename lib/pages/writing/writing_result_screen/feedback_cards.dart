part of '../writing_result_screen.dart';

class _CompetencyCard extends StatelessWidget {
  const _CompetencyCard({required this.competency});

  final WritingCompetencyFeedback competency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WritingResultScreen._surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: WritingResultScreen._primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${competency.score}',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: WritingResultScreen._primary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competency.title,
                  style: GoogleFonts.inter(
                    color: WritingResultScreen._onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  competency.comment,
                  style: GoogleFonts.inter(
                    color: WritingResultScreen._onSurfaceMuted,
                    fontSize: 12.3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewriteCard extends StatelessWidget {
  const _RewriteCard({required this.suggestion});

  final WritingRewriteSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: WritingResultScreen._surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WritingResultScreen._accent.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.section.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: WritingResultScreen._accent,
              fontSize: 10,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion.issue,
            style: GoogleFonts.manrope(
              color: WritingResultScreen._onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            suggestion.suggestion,
            style: GoogleFonts.inter(
              color: WritingResultScreen._onSurfaceMuted,
              fontSize: 12.7,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WritingResultScreen._surfaceContainerHigh,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              suggestion.example,
              style: GoogleFonts.inter(
                color: WritingResultScreen._onSurface,
                fontSize: 12.5,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
