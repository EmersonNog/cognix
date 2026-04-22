import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardImageView extends StatelessWidget {
  const TrainingFlashcardImageView({
    super.key,
    required this.imageData,
    required this.height,
    required this.surfaceContainerHigh,
    required this.onSurfaceMuted,
  });

  final String imageData;
  final double height;
  final Color surfaceContainerHigh;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    final normalized = imageData.trim();

    Widget fallback() {
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: surfaceContainerHigh.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          'Imagem indisponivel',
          style: GoogleFonts.inter(
            color: onSurfaceMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (normalized.isEmpty) {
      return fallback();
    }

    final maybeFile = File(normalized);
    if (maybeFile.existsSync()) {
      return Image.file(
        maybeFile,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    try {
      final bytes = base64Decode(normalized);
      return Image.memory(
        Uint8List.fromList(bytes),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    } catch (_) {
      return fallback();
    }
  }
}
