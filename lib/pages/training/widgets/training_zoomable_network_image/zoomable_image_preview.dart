part of '../training_zoomable_network_image.dart';

class _ZoomableImagePreview extends StatelessWidget {
  const _ZoomableImagePreview({
    required this.imageUrl,
    required this.placeholderColor,
    required this.borderColor,
    required this.borderRadius,
    required this.maxHeight,
    required this.hintLabel,
    required this.showOverlayHint,
    required this.expandToWidth,
    required this.onOpenViewer,
  });

  final String imageUrl;
  final Color placeholderColor;
  final Color? borderColor;
  final double borderRadius;
  final double maxHeight;
  final String hintLabel;
  final bool showOverlayHint;
  final bool expandToWidth;
  final VoidCallback onOpenViewer;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final effectiveBorderColor =
        borderColor == null || borderColor == Colors.transparent
        ? placeholderColor.withValues(alpha: 0.16)
        : borderColor!;
    final previewHeight = maxHeight.clamp(120.0, 180.0).toDouble();

    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onLongPress: onOpenViewer,
        child: Container(
          width: expandToWidth ? double.infinity : null,
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: colors.surfaceLow.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: effectiveBorderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _PreviewNetworkImage(
                  imageUrl: imageUrl,
                  placeholderColor: placeholderColor,
                  previewHeight: previewHeight,
                  expandToWidth: expandToWidth,
                ),
                if (showOverlayHint) _PreviewOverlayHint(label: hintLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewNetworkImage extends StatelessWidget {
  const _PreviewNetworkImage({
    required this.imageUrl,
    required this.placeholderColor,
    required this.previewHeight,
    required this.expandToWidth,
  });

  final String imageUrl;
  final Color placeholderColor;
  final double previewHeight;
  final bool expandToWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expandToWidth ? double.infinity : null,
      child: Image.network(
        imageUrl,
        width: expandToWidth ? double.infinity : null,
        fit: expandToWidth ? BoxFit.fitWidth : BoxFit.contain,
        alignment: Alignment.center,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _PreviewStateBox(
            width: expandToWidth ? double.infinity : previewHeight,
            height: previewHeight,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(placeholderColor),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _PreviewStateBox(
            width: expandToWidth ? double.infinity : previewHeight,
            height: previewHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Não foi possível carregar a imagem.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: placeholderColor,
                  fontSize: 12.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PreviewStateBox extends StatelessWidget {
  const _PreviewStateBox({
    required this.width,
    required this.height,
    required this.child,
  });

  final double? width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }
}

class _PreviewOverlayHint extends StatelessWidget {
  const _PreviewOverlayHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 10,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
