import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingFlashcardSheetField extends StatelessWidget {
  const TrainingFlashcardSheetField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.surfaceContainerHigh,
    required this.primary,
    this.maxLines = 1,
    this.isCompact = false,
    this.suggestions = const <String>[],
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color surfaceContainerHigh;
  final Color primary;
  final int maxLines;
  final bool isCompact;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    final normalizedInput = controller.text.trim().toLowerCase();
    final filteredSuggestions = suggestions
        .where((suggestion) {
          if (suggestion.trim().isEmpty) return false;
          if (normalizedInput.isEmpty) return true;
          return suggestion.toLowerCase().contains(normalizedInput) &&
              suggestion.toLowerCase() != normalizedInput;
        })
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: onSurface.withValues(alpha: 0.86),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: isCompact ? 8 : 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: GoogleFonts.inter(
            color: onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: onSurfaceMuted.withValues(alpha: 0.72),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: surfaceContainerHigh.withValues(alpha: 0.72),
            isDense: isCompact,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isCompact ? 14 : 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: surfaceContainerHigh),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: primary.withValues(alpha: 0.85),
                width: 1.4,
              ),
            ),
          ),
        ),
        if (filteredSuggestions.isNotEmpty && maxLines == 1) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filteredSuggestions.map((suggestion) {
              return ActionChip(
                onPressed: () {
                  controller.text = suggestion;
                  controller.selection = TextSelection.collapsed(
                    offset: suggestion.length,
                  );
                },
                backgroundColor: surfaceContainerHigh.withValues(alpha: 0.68),
                side: BorderSide(
                  color: surfaceContainerHigh.withValues(alpha: 0.95),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                label: Text(
                  suggestion,
                  style: GoogleFonts.plusJakartaSans(
                    color: onSurface,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
