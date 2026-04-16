import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'multiplayer_palette.dart';

Future<bool> showMultiplayerLeaveConfirmation(
  BuildContext context, {
  required MultiplayerPalette palette,
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: palette.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          title,
          style: GoogleFonts.manrope(
            color: palette.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: palette.onSurfaceMuted,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.plusJakartaSans(
                color: palette.onSurfaceMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB42318),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              confirmLabel,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      );
    },
  );

  return result == true;
}
