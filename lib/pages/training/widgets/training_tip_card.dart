import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingTipCard extends StatelessWidget {
  const TrainingTipCard({
    super.key,
    required this.surfaceContainer,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
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
                  const TextSpan(
                    text:
                        'Lembre-se que a função de onda ψ(x) se mantém contínua '
                        'nas fronteiras. Se E < V₀, a solução na barreira é uma '
                        'função de decaimento exponencial, não zero.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
