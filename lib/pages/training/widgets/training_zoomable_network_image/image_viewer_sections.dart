part of '../training_zoomable_network_image.dart';

class _ViewerTopBar extends StatelessWidget {
  const _ViewerTopBar({required this.accent, required this.onClose});

  final Color accent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainerHigh,
            foregroundColor: colors.onSurface,
            side: BorderSide(
              color: colors.onSurfaceMuted.withValues(alpha: 0.12),
            ),
          ),
          icon: const Icon(Icons.close_rounded),
        ),
        const SizedBox(width: 10),
        Expanded(child: _ViewerTitleCard(accent: accent)),
      ],
    );
  }
}

class _ViewerTitleCard extends StatelessWidget {
  const _ViewerTitleCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.image_search_rounded, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Visualização da imagem',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: colors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _ZoomBadge(accent: accent),
        ],
      ),
    );
  }
}

class _ZoomBadge extends StatelessWidget {
  const _ZoomBadge({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'ZOOM',
        style: GoogleFonts.plusJakartaSans(
          color: accent,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ViewerImageCard extends StatelessWidget {
  const _ViewerImageCard({required this.imageUrl, required this.accent});

  final String imageUrl;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: colors.surfaceContainer,
            border: Border.all(
              color: colors.onSurfaceMuted.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toque prolongado ativo',
                style: GoogleFonts.plusJakartaSans(
                  color: colors.onSurfaceMuted.withValues(alpha: 0.72),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _InteractiveNetworkImage(
                  imageUrl: imageUrl,
                  accent: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InteractiveNetworkImage extends StatelessWidget {
  const _InteractiveNetworkImage({
    required this.imageUrl,
    required this.accent,
  });

  final String imageUrl;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.surfaceLow,
          border: Border.all(
            color: colors.onSurfaceMuted.withValues(alpha: 0.12),
          ),
        ),
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4.5,
          boundaryMargin: const EdgeInsets.all(24),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Não foi possível carregar a imagem.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: colors.onSurfaceMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewerNavigationHint extends StatelessWidget {
  const _ViewerNavigationHint({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.zoom_in_rounded, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Modo de navegação',
                  style: GoogleFonts.plusJakartaSans(
                    color: colors.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use dois dedos para ampliar e arraste para explorar os detalhes.',
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted.withValues(alpha: 0.72),
                    fontSize: 11.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
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
