import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';

part 'training_zoomable_network_image/image_viewer_dialog.dart';
part 'training_zoomable_network_image/image_viewer_sections.dart';
part 'training_zoomable_network_image/zoomable_image_preview.dart';

class TrainingZoomableNetworkImage extends StatelessWidget {
  const TrainingZoomableNetworkImage({
    super.key,
    required this.imageUrl,
    required this.placeholderColor,
    this.borderColor,
    this.borderRadius = 14,
    this.maxHeight = 280,
    this.hintLabel = 'Pressione e segure para ampliar',
    this.showOverlayHint = true,
    this.expandToWidth = true,
  });

  final String imageUrl;
  final Color placeholderColor;
  final Color? borderColor;
  final double borderRadius;
  final double maxHeight;
  final String hintLabel;
  final bool showOverlayHint;
  final bool expandToWidth;

  @override
  Widget build(BuildContext context) {
    return _ZoomableImagePreview(
      imageUrl: imageUrl,
      placeholderColor: placeholderColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      maxHeight: maxHeight,
      hintLabel: hintLabel,
      showOverlayHint: showOverlayHint,
      expandToWidth: expandToWidth,
      onOpenViewer: () => _openViewer(context),
    );
  }

  Future<void> _openViewer(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      builder: (dialogContext) {
        return _TrainingImageViewerDialog(
          imageUrl: imageUrl,
          accent: placeholderColor,
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }
}
