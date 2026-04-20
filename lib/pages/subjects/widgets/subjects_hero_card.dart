import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectsHeroCard extends StatelessWidget {
  const SubjectsHeroCard({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            surfaceContainerHigh,
            surfaceContainer.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.manrope(
                fontSize: 28,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: 'Domine o seu\n',
                  style: TextStyle(color: onSurface),
                ),
                TextSpan(
                  text: 'Sucesso\n',
                  style: TextStyle(color: primary),
                ),
                TextSpan(
                  text: 'Acadêmico',
                  style: TextStyle(color: primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.65,
            child: Text(
              'Escolha uma área de conhecimento para explorar conteúdos focados no Vestibular e ENEM. Sua aprovação começa aqui.',
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
