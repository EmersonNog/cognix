part of '../ai_chat_screen.dart';

class _AiChatComposer extends StatelessWidget {
  const _AiChatComposer({
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSending;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colors.surfaceContainer.withValues(alpha: 0.96)
        : const Color(0xFFF7F8FC);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.98),
          border: Border(
            top: BorderSide(
              color: colors.onSurfaceMuted.withValues(alpha: 0.06),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 96),
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colors.onSurfaceMuted.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: !isSending,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      if (canSend) {
                        onSend();
                      }
                    },
                    style: GoogleFonts.inter(
                      color: colors.onSurface,
                      fontSize: 15.5,
                      height: 1.35,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Pergunte ao Cognix...',
                      filled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: GoogleFonts.inter(
                        color: colors.onSurfaceMuted.withValues(alpha: 0.72),
                        fontSize: 15.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _AiChatComposerIconButton(
                        icon: Icons.add_rounded,
                        onPressed: null,
                      ),
                      const SizedBox(width: 8),
                      _AiChatComposerIconButton(
                        icon: Icons.mic_none_rounded,
                        onPressed: null,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: canSend ? onSend : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: colors.primary,
                            foregroundColor: onPrimary,
                            disabledBackgroundColor: colors.primary.withValues(
                              alpha: 0.45,
                            ),
                            disabledForegroundColor: onPrimary.withValues(
                              alpha: 0.72,
                            ),
                            shape: const CircleBorder(),
                            elevation: 0,
                          ),
                          child: isSending
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: onPrimary,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 23,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'O Cognix IA pode cometer erros. Verifique sempre as informações importantes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: colors.onSurfaceMuted.withValues(alpha: 0.82),
                fontSize: 10.5,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiChatComposerIconButton extends StatelessWidget {
  const _AiChatComposerIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 21,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: colors.surface,
          disabledBackgroundColor: colors.surface,
          foregroundColor: colors.onSurfaceMuted,
          disabledForegroundColor: colors.onSurfaceMuted.withValues(
            alpha: 0.75,
          ),
          shape: const CircleBorder(),
          side: BorderSide(
            color: colors.onSurfaceMuted.withValues(alpha: 0.12),
          ),
        ),
      ),
    );
  }
}
