part of '../ai_chat_screen.dart';

class _AiChatBubbleAttachments extends StatelessWidget {
  const _AiChatBubbleAttachments({
    required this.attachments,
    required this.foreground,
    required this.muted,
  });

  final List<AiChatAttachment> attachments;
  final Color foreground;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: attachments
          .map(
            (attachment) => _AiChatBubbleAttachmentCard(
              attachment: attachment,
              foreground: foreground,
              muted: muted,
            ),
          )
          .toList(),
    );
  }
}

class _AiChatBubbleAttachmentCard extends StatelessWidget {
  const _AiChatBubbleAttachmentCard({
    required this.attachment,
    required this.foreground,
    required this.muted,
  });

  final AiChatAttachment attachment;
  final Color foreground;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    if (attachment.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          base64Decode(attachment.dataBase64),
          width: 142,
          height: 94,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildFileChip(),
        ),
      );
    }

    return _buildFileChip();
  }

  Widget _buildFileChip() {
    return Container(
      width: 176,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: foreground.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: foreground.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(_attachmentIconFor(attachment), color: foreground, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: foreground,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatAttachmentSize(attachment.sizeBytes),
                  style: GoogleFonts.inter(
                    color: muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
