part of '../ai_chat_screen.dart';

class _AiChatHeader extends StatelessWidget {
  const _AiChatHeader({required this.hasMessages, required this.onClear});

  final bool hasMessages;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat IA',
                style: GoogleFonts.manrope(
                  color: colors.onSurface,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  height: 1.04,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Um apoio rápido para dúvidas, revisões e próximos passos.',
                style: GoogleFonts.inter(
                  color: colors.onSurfaceMuted,
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (hasMessages)
          IconButton(
            tooltip: 'Limpar conversa',
            onPressed: onClear,
            icon: Icon(
              Icons.delete_sweep_rounded,
              color: colors.onSurfaceMuted,
            ),
          ),
      ],
    );
  }
}
