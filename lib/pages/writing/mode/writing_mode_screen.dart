import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/cognix_theme_colors.dart';
import '../models/writing_route_args.dart';
import '../shared/writing_theme_hero.dart';

class WritingModeScreen extends StatelessWidget {
  const WritingModeScreen({super.key, required this.args});

  final WritingModeSelectionArgs args;

  void _openEditor(BuildContext context, WritingEditorMode mode) {
    Navigator.of(context).pushNamed(
      'writing-editor',
      arguments: WritingEditorArgs(theme: args.theme, mode: mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          'Escolher formato',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          WritingThemeHero(theme: args.theme),
          const SizedBox(height: 20),
          Text(
            'Como você quer começar?',
            style: GoogleFonts.manrope(
              color: colors.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha o fluxo que combina melhor com a redação deste treino.',
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          _WritingModeOptionCard(
            icon: Icons.edit_note_rounded,
            title: 'Digitar com roteiro',
            subtitle: 'Informe tema, ideia e repertório.',
            bullets: const [
              'Ideal para construir a redação dentro do app',
              'Mantém o checklist estrutural guiado',
              'Permite montar o texto final automaticamente',
            ],
            buttonLabel: 'Começar digitando',
            accent: colors.primary,
            onTap: () => _openEditor(context, WritingEditorMode.manual),
          ),
          const SizedBox(height: 14),
          _WritingModeOptionCard(
            icon: Icons.document_scanner_rounded,
            title: 'Usar foto com IA',
            subtitle: 'Envie a foto e revise o texto.',
            bullets: const [
              'Sem campos manuais de tese e argumentos',
              'A IA lê a imagem e gera um texto editável',
              'Você revisa a transcrição antes de analisar',
            ],
            buttonLabel: 'Escanear redação',
            accent: colors.accent,
            onTap: () => _openEditor(context, WritingEditorMode.imageScan),
          ),
        ],
      ),
    );
  }
}

class _WritingModeOptionCard extends StatelessWidget {
  const _WritingModeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.buttonLabel,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> bullets;
  final String buttonLabel;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        color: colors.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: colors.onSurfaceMuted,
                        fontSize: 12.6,
                        height: 1.38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, color: accent, size: 17),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bullet,
                      style: GoogleFonts.inter(
                        color: colors.onSurface,
                        fontSize: 12.4,
                        fontWeight: FontWeight.w700,
                        height: 1.28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
