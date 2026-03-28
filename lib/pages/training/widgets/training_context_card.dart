import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingContextCard extends StatelessWidget {
  const TrainingContextCard({
    super.key,
    required this.surfaceContainer,
    required this.onSurfaceMuted,
  });

  final Color surfaceContainer;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O CONTEXTO',
            style: GoogleFonts.plusJakartaSans(
              color: onSurfaceMuted,
              fontSize: 10.5,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Considere a equação de Schrödinger independente do tempo para um '
            'sistema onde a energia potencial ψV(x) é definida como um poço '
            'quadrado finito. Se a energia da partícula é menor que a profundidade '
            'do poço ψV₀, qual fenômeno descreve a presença da partícula na região '
            'classicamente proibida?',
            style: GoogleFonts.inter(
              color: onSurfaceMuted,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
