part of '../writing_editor_screen.dart';

class _ImageScanButton extends StatelessWidget {
  const _ImageScanButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onTap,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: isLoading || !isEnabled ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                )
              else
                Icon(
                  Icons.document_scanner_rounded,
                  size: 18,
                  color: colors.primary,
                ),
              const SizedBox(width: 8),
              Text(
                isLoading ? 'Lendo foto com IA...' : 'Escanear redação com IA',
                style: GoogleFonts.plusJakartaSans(
                  color: colors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageScanEmptyState extends StatelessWidget {
  const _ImageScanEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.tips_and_updates_rounded,
              color: colors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A transcrição aparecerá aqui',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Depois de escanear, revise o texto lido pela IA antes de pedir o diagnóstico.',
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 12.4,
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

class _ImageScanSourceTile extends StatelessWidget {
  const _ImageScanSourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: colors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: colors.onSurfaceMuted,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageScanConfidenceCard extends StatelessWidget {
  const _ImageScanConfidenceCard({required this.result});

  final WritingImageScanResult result;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final confidencePercent = (result.confidence * 100).round();
    final accent = result.needsReview ? colors.accent : colors.success;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.needsReview
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_rounded,
                color: accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Confiança da leitura: $confidencePercent%',
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 13.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          if (result.warnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final warning in result.warnings)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '- $warning',
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 12,
                    height: 1.32,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
