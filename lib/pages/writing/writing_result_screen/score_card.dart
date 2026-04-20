part of '../writing_result_screen.dart';

class _ScoreCard extends StatefulWidget {
  const _ScoreCard({required this.feedback});

  final WritingFeedback feedback;

  @override
  State<_ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<_ScoreCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final feedback = widget.feedback;
    final ratio = feedback.estimatedScore / 1000;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryDim, colors.surfaceLow],
        ),
        border: Border.all(color: colors.accent.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 92,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 62,
                  height: 62,
                  child: CircularProgressIndicator(
                    value: ratio,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${feedback.estimatedScore}',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PTS',
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnóstico geral',
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.accent,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nota estimada',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feedback.summary,
                  maxLines: _expanded ? null : 5,
                  overflow: _expanded
                      ? TextOverflow.visible
                      : TextOverflow.fade,
                  softWrap: true,
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 13,
                    height: 1.42,
                  ),
                ),
                if (feedback.summary.trim().length > 180) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _expanded ? 'Ver menos' : 'Ver mais',
                          style: GoogleFonts.plusJakartaSans(
                            color: colors.accent,
                            fontSize: 11.8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: colors.accent,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
