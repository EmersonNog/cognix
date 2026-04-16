import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final effectiveBorderColor =
        borderColor == null || borderColor == Colors.transparent
        ? placeholderColor.withValues(alpha: 0.16)
        : borderColor!;
    final previewHeight = maxHeight.clamp(120.0, 180.0).toDouble();

    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onLongPress: () => _openViewer(context),
        child: Container(
          width: expandToWidth ? double.infinity : null,
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: effectiveBorderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
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

                      return SizedBox(
                        width: expandToWidth ? double.infinity : previewHeight,
                        height: previewHeight,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              placeholderColor,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: expandToWidth ? double.infinity : previewHeight,
                        height: previewHeight,
                        child: Center(
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
                        ),
                      );
                    },
                  ),
                ),
                if (showOverlayHint)
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
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
                                  hintLabel,
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openViewer(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      builder: (dialogContext) {
        const pageBackground = Color(0xFF060E20);
        const surfaceContainer = Color(0xFF10182E);
        const surfaceContainerHigh = Color(0xFF1A2340);
        final accent = placeholderColor;

        return Material(
          color: pageBackground,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      surfaceContainerHigh.withValues(alpha: 0.7),
                      pageBackground,
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            style: IconButton.styleFrom(
                              backgroundColor: surfaceContainerHigh,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            icon: const Icon(Icons.close_rounded),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
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
                                    child: Icon(
                                      Icons.image_search_rounded,
                                      size: 18,
                                      color: accent,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Visualizacao da imagem',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.manrope(
                                        color: Colors.white.withValues(
                                          alpha: 0.92,
                                        ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 980),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: surfaceContainer,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.62,
                                      ),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0B1020),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ),
                                        ),
                                        child: InteractiveViewer(
                                          minScale: 1,
                                          maxScale: 4.5,
                                          boundaryMargin: const EdgeInsets.all(
                                            24,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(24),
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.contain,
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }

                                                      return Center(
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2.4,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                placeholderColor,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 24,
                                                          ),
                                                      child: Text(
                                                        'Não foi possível carregar a imagem.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.inter(
                                                              color:
                                                                  const Color(
                                                                    0xFF596077,
                                                                  ),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
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
                              child: Icon(
                                Icons.zoom_in_rounded,
                                color: accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Modo de navegacao',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Use dois dedos para ampliar e arraste para explorar os detalhes.',
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withValues(
                                        alpha: 0.72,
                                      ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
