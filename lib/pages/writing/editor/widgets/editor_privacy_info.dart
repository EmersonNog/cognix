part of '../writing_editor_screen.dart';

void _showImageScanPrivacyInfo(BuildContext context) {
  final colors = context.cognixColors;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surfaceContainer,
    barrierColor: Colors.black.withValues(alpha: 0.48),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.privacy_tip_rounded,
                      color: colors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aviso de privacidade',
                      style: GoogleFonts.manrope(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Para transformar sua foto em texto, o Cognix envia a imagem '
                'para uma inteligência artificial de leitura do Google.',
                style: GoogleFonts.inter(
                  color: colors.onSurface,
                  fontSize: 13.4,
                  height: 1.42,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'O Cognix não salva essa foto nesse processo. A imagem é usada '
                'apenas para tentar ler sua redação. Quando o texto aparecer, '
                'revise com atenção antes de pedir o diagnóstico.',
                style: GoogleFonts.inter(
                  color: colors.onSurfaceMuted,
                  fontSize: 12.8,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Entendi'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
