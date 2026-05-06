part of '../ai_chat_screen.dart';

class _AiChatAttachmentPreviewStrip extends StatelessWidget {
  const _AiChatAttachmentPreviewStrip({
    required this.attachments,
    required this.onRemove,
  });

  final List<AiChatAttachment> attachments;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return _AiChatAttachmentPreviewCard(
            attachment: attachments[index],
            onRemove: () => onRemove(index),
          );
        },
      ),
    );
  }
}

class _AiChatAttachmentPreviewCard extends StatelessWidget {
  const _AiChatAttachmentPreviewCard({
    required this.attachment,
    required this.onRemove,
  });

  final AiChatAttachment attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          _AiChatAttachmentThumb(attachment: attachment),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatAttachmentSize(attachment.sizeBytes),
                  style: GoogleFonts.inter(
                    color: colors.onSurfaceMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              tooltip: 'Remover anexo',
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded),
              iconSize: 16,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                foregroundColor: colors.onSurfaceMuted,
                backgroundColor: colors.surfaceContainerHigh.withValues(
                  alpha: 0.65,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiChatAttachmentThumb extends StatelessWidget {
  const _AiChatAttachmentThumb({required this.attachment});

  final AiChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    if (attachment.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          base64Decode(attachment.dataBase64),
          width: 42,
          height: 42,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              _AiChatAttachmentIcon(attachment: attachment),
        ),
      );
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        _attachmentIconFor(attachment),
        color: colors.primary,
        size: 21,
      ),
    );
  }
}

class _AiChatAttachmentIcon extends StatelessWidget {
  const _AiChatAttachmentIcon({required this.attachment});

  final AiChatAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    return Container(
      width: 42,
      height: 42,
      color: colors.primary.withValues(alpha: 0.10),
      child: Icon(
        _attachmentIconFor(attachment),
        color: colors.primary,
        size: 21,
      ),
    );
  }
}
