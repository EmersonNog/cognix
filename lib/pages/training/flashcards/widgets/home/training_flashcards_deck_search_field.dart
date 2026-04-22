import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardsDeckSearchField extends StatelessWidget {
  const TrainingFlashcardsDeckSearchField({
    super.key,
    required this.controller,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final TextEditingController controller;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.inter(color: onSurface, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: 'Buscar matéria',
        hintStyle: GoogleFonts.inter(
          color: onSurfaceMuted,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: onSurfaceMuted),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: controller.clear,
                icon: Icon(Icons.close_rounded, color: onSurfaceMuted),
              ),
        filled: true,
        fillColor: surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: surfaceContainerHigh.withValues(alpha: 0.95),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: onSurfaceMuted.withValues(alpha: 0.35)),
        ),
      ),
    );
  }
}
