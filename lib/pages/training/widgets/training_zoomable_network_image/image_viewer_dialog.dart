part of '../training_zoomable_network_image.dart';

class _TrainingImageViewerDialog extends StatelessWidget {
  const _TrainingImageViewerDialog({
    required this.imageUrl,
    required this.accent,
    required this.onClose,
  });

  final String imageUrl;
  final Color accent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Material(
      color: colors.surface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _ViewerBackground(accent: accent),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: Column(
                children: [
                  _ViewerTopBar(accent: accent, onClose: onClose),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _ViewerImageCard(imageUrl: imageUrl, accent: accent),
                  ),
                  const SizedBox(height: 18),
                  _ViewerNavigationHint(accent: accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerBackground extends StatelessWidget {
  const _ViewerBackground({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.surfaceContainerHigh.withValues(alpha: 0.7),
                colors.surface,
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: IgnorePointer(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.08),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
