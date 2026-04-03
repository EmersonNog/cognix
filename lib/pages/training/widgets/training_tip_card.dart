import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingTipCard extends StatelessWidget {
  const TrainingTipCard({
    super.key,
    required this.surfaceContainer,
    required this.onSurfaceMuted,
    required this.primary,
    required this.tip,
  });

  final Color surfaceContainer;
  final Color onSurfaceMuted;
  final Color primary;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    final trimmedTip = tip?.trim();
    final hasTip = trimmedTip != null && trimmedTip.isNotEmpty;
    final tipText = hasTip
        ? trimmedTip
        : 'Sem dica disponivel para esta questao.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  color: onSurfaceMuted,
                  fontSize: 11.5,
                  height: 1.45,
                ),
                children: [
                  TextSpan(
                    text: 'Dica do Cognix: ',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: tipText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
