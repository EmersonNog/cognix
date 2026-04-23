import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'support_palette.dart';

class SupportInfoCard extends StatelessWidget {
  const SupportInfoCard({super.key, required this.onShowAbout});

  final VoidCallback onShowAbout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: supportCardSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mais informações do app',
                  style: GoogleFonts.manrope(
                    color: supportOnSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Veja detalhes da versão atual do Cognix direto nesta área.',
                  style: GoogleFonts.inter(
                    color: supportOnSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          FilledButton(
            onPressed: onShowAbout,
            style: FilledButton.styleFrom(
              backgroundColor: supportPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Ver detalhes'),
          ),
        ],
      ),
    );
  }
}
