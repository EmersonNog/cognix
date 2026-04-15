import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'training_zoomable_network_image.dart';

class TrainingAnswerOption extends StatelessWidget {
  const TrainingAnswerOption({
    super.key,
    required this.letter,
    required this.text,
    this.attachmentUrl,
    this.attachmentLabel,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurfaceMuted,
    required this.onSurface,
    required this.primary,
    this.selected = false,
    this.isDisabled = false,
    this.showSelectedCorrect = false,
    this.showSelectedIncorrect = false,
    this.showCorrectReveal = false,
  });

  final String letter;
  final String text;
  final String? attachmentUrl;
  final String? attachmentLabel;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;
  final Color onSurface;
  final Color primary;
  final bool selected;
  final bool isDisabled;
  final bool showSelectedCorrect;
  final bool showSelectedIncorrect;
  final bool showCorrectReveal;

  @override
  Widget build(BuildContext context) {
    final isPositive = showSelectedCorrect || showCorrectReveal;
    final isNegative = showSelectedIncorrect;

    final accentColor = isNegative
        ? const Color(0xFFFF6B7A)
        : showCorrectReveal
        ? const Color(0xFF4FD7A8)
        : isPositive
        ? const Color(0xFF31C48D)
        : primary;

    final background = isNegative
        ? const Color(0xFFFF6B7A).withValues(alpha: 0.12)
        : showCorrectReveal
        ? const Color(0xFF4FD7A8).withValues(alpha: 0.1)
        : isPositive
        ? const Color(0xFF31C48D).withValues(alpha: 0.14)
        : selected
        ? surfaceContainerHigh
        : surfaceContainer;
    final borderColor = isPositive || isNegative || selected
        ? accentColor.withValues(alpha: isPositive || isNegative ? 0.7 : 0.5)
        : Colors.transparent;
    final badgeBackground = isPositive || isNegative
        ? accentColor.withValues(alpha: 0.16)
        : selected
        ? primary.withValues(alpha: 0.15)
        : surfaceContainerHigh;
    final badgeForeground = isPositive || isNegative
        ? accentColor
        : selected
        ? primary
        : onSurfaceMuted;
    final trailingIcon = showSelectedCorrect
        ? Icons.check_circle
        : showSelectedIncorrect
        ? Icons.cancel_rounded
        : showCorrectReveal
        ? Icons.check_circle_outline_rounded
        : selected
        ? Icons.check_circle
        : null;
    final displayText = text.trim();
    final hasImageAttachment = _isImageUrl(attachmentUrl);
    final resolvedAttachmentLabel = hasImageAttachment
        ? 'Pressione e segure para ampliar'
        : attachmentLabel?.trim();
    final attachmentIcon = hasImageAttachment
        ? Icons.touch_app_rounded
        : Icons.attach_file_rounded;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: badgeBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                letter,
                style: GoogleFonts.plusJakartaSans(
                  color: badgeForeground,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (displayText.isNotEmpty || !hasImageAttachment)
                  Text(
                    displayText.isEmpty
                        ? 'Arquivo complementar disponivel.'
                        : text,
                    style: GoogleFonts.inter(
                      color: isDisabled && !isPositive && !isNegative
                          ? onSurface.withValues(alpha: 0.92)
                          : onSurface,
                      fontSize: 12.5,
                    ),
                  ),
                if (hasImageAttachment) ...[
                  if (displayText.isNotEmpty) const SizedBox(height: 10),
                  TrainingZoomableNetworkImage(
                    imageUrl: attachmentUrl!.trim(),
                    borderColor: borderColor,
                    placeholderColor: badgeForeground,
                    borderRadius: 12,
                    maxHeight: 220,
                    showOverlayHint: false,
                    expandToWidth: true,
                  ),
                ],
                if (resolvedAttachmentLabel != null &&
                    resolvedAttachmentLabel.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(attachmentIcon, size: 14, color: badgeForeground),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          resolvedAttachmentLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: badgeForeground,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon, color: accentColor, size: 18),
        ],
      ),
    );
  }

  bool _isImageUrl(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme) {
      return false;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return false;
    }

    return RegExp(
      r'\.(png|jpe?g|gif|webp|bmp)(?:\?|#|$)',
      caseSensitive: false,
    ).hasMatch(normalized);
  }
}
