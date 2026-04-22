import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/training_zoomable_network_image.dart';

class TrainingSessionQuestionCard extends StatelessWidget {
  const TrainingSessionQuestionCard({
    super.key,
    required this.discipline,
    required this.statement,
    this.alternativesIntroduction,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String discipline;
  final String statement;
  final String? alternativesIntroduction;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    final statementStyle = GoogleFonts.inter(
      color: onSurface,
      fontSize: 13.5,
      height: 1.45,
    );
    final alternativesIntroductionStyle = GoogleFonts.inter(
      color: onSurfaceMuted,
      fontSize: 12.5,
      height: 1.45,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discipline,
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ..._buildContentBlocks(
            statement,
            textStyle: statementStyle,
            placeholderColor: onSurfaceMuted,
          ),
          if (alternativesIntroduction != null &&
              alternativesIntroduction!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._buildContentBlocks(
              alternativesIntroduction!,
              textStyle: alternativesIntroductionStyle,
              placeholderColor: onSurfaceMuted,
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildContentBlocks(
    String content, {
    required TextStyle textStyle,
    required Color placeholderColor,
  }) {
    final blocks = _parseBlocks(content);
    if (blocks.isEmpty) {
      return [Text(content, style: textStyle)];
    }

    return [
      for (var i = 0; i < blocks.length; i++) ...[
        if (blocks[i].imageUrl != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrainingZoomableNetworkImage(
                imageUrl: blocks[i].imageUrl!,
                placeholderColor: placeholderColor,
                showOverlayHint: false,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14,
                    color: placeholderColor.withValues(alpha: 0.88),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pressione e segure para ampliar',
                    style: GoogleFonts.plusJakartaSans(
                      color: placeholderColor.withValues(alpha: 0.88),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          )
        else if (blocks[i].text != null && blocks[i].text!.trim().isNotEmpty)
          Text(blocks[i].text!, style: textStyle),
        if (i < blocks.length - 1) const SizedBox(height: 12),
      ],
    ];
  }

  List<_QuestionContentBlock> _parseBlocks(String content) {
    final lines = content.split(RegExp(r'\r?\n'));
    final blocks = <_QuestionContentBlock>[];
    final textBuffer = <String>[];

    void flushText() {
      final text = textBuffer.join('\n').trim();
      textBuffer.clear();
      if (text.isEmpty) return;
      blocks.add(_QuestionContentBlock.text(text));
    }

    for (final line in lines) {
      final trimmed = line.trim();
      if (_isImageUrl(trimmed)) {
        flushText();
        blocks.add(_QuestionContentBlock.image(trimmed));
        continue;
      }
      textBuffer.add(line);
    }

    flushText();
    return blocks;
  }

  bool _isImageUrl(String value) {
    if (value.isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) {
      return false;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return false;
    }

    return RegExp(
      r'\.(png|jpe?g|gif|webp|bmp)(?:\?|#|$)',
      caseSensitive: false,
    ).hasMatch(value);
  }
}

class _QuestionContentBlock {
  const _QuestionContentBlock.text(this.text) : imageUrl = null;
  const _QuestionContentBlock.image(this.imageUrl) : text = null;

  final String? text;
  final String? imageUrl;
}
