part of '../ai_chat_screen.dart';

class _AiChatBubble extends StatelessWidget {
  const _AiChatBubble({required this.message});

  final AiChatMessage message;

  bool get _isUser => message.role == AiChatRole.user;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final width = MediaQuery.sizeOf(context).width;
    final maxBubbleWidth = math.min(620.0, width * 0.82);
    final background = _isUser ? colors.primary : colors.surfaceContainerHigh;
    final foreground = _isUser
        ? Theme.of(context).colorScheme.onPrimary
        : colors.onSurface;
    final metadataColor = _isUser
        ? foreground.withValues(alpha: 0.72)
        : colors.onSurfaceMuted;

    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(_isUser ? 18 : 6),
              bottomRight: Radius.circular(_isUser ? 6 : 18),
            ),
            border: _isUser
                ? null
                : Border.all(
                    color: colors.onSurfaceMuted.withValues(alpha: 0.10),
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AiChatFormattedText(
                text: message.content,
                style: GoogleFonts.inter(
                  color: foreground,
                  fontSize: 13.4,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _formatMessageTime(message.createdAt),
                style: GoogleFonts.plusJakartaSans(
                  color: metadataColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiChatFormattedText extends StatelessWidget {
  const _AiChatFormattedText({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style,
        children: _buildInlineMarkdownSpans(
          text: text,
          baseStyle: style,
          strongStyle: style.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
