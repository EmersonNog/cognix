part of '../ai_chat_screen.dart';

class _AiChatAttachmentOptionsSheet extends StatelessWidget {
  const _AiChatAttachmentOptionsSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adicionar ao chat',
              style: GoogleFonts.manrope(
                color: colors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Envie imagens, PDFs ou textos para a IA ler junto com sua pergunta.',
              style: GoogleFonts.inter(
                color: colors.onSurfaceMuted,
                fontSize: 12.6,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            _AiChatAttachmentOptionTile(
              icon: Icons.photo_camera_rounded,
              title: 'Tirar foto',
              subtitle:
                  'Use a câmera para enviar uma página, questão ou anotação.',
              onTap: () =>
                  Navigator.of(context).pop(_AiChatAttachmentAction.camera),
            ),
            const SizedBox(height: 8),
            _AiChatAttachmentOptionTile(
              icon: Icons.photo_library_rounded,
              title: 'Escolher imagem',
              subtitle: 'Selecione uma imagem salva no aparelho.',
              onTap: () =>
                  Navigator.of(context).pop(_AiChatAttachmentAction.gallery),
            ),
            const SizedBox(height: 8),
            _AiChatAttachmentOptionTile(
              icon: Icons.attach_file_rounded,
              title: 'Selecionar arquivo',
              subtitle: 'PDF, TXT, MD, CSV ou imagem até 6 MB.',
              onTap: () =>
                  Navigator.of(context).pop(_AiChatAttachmentAction.file),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiChatAttachmentOptionTile extends StatelessWidget {
  const _AiChatAttachmentOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Material(
      color: colors.surfaceContainerHigh.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: colors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: colors.onSurface,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: colors.onSurfaceMuted,
                        fontSize: 11.6,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
