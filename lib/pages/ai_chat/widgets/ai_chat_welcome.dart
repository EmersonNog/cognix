part of '../ai_chat_screen.dart';

class _AiChatWelcomePanel extends StatelessWidget {
  const _AiChatWelcomePanel({
    required this.userName,
    required this.isSending,
    required this.onPromptSelected,
  });

  final String? userName;
  final bool isSending;
  final ValueChanged<String> onPromptSelected;

  static const _suggestions = <_AiChatSuggestion>[
    _AiChatSuggestion(
      label: 'Explicar matéria',
      prompt:
          'Explique uma matéria de forma simples, com exemplo e passo a passo.',
    ),
    _AiChatSuggestion(
      label: 'Resolver questão',
      prompt: 'Me ajude a resolver uma questão mostrando o raciocínio.',
    ),
    _AiChatSuggestion(
      label: 'Revisar para prova',
      prompt:
          'Monte uma revisão rápida para uma prova com os pontos mais importantes.',
    ),
    _AiChatSuggestion(
      label: 'Tirar dúvida',
      prompt: 'Tenho uma dúvida e quero uma explicação direta com exemplos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _AiChatBrainMark(),
          const SizedBox(height: 24),
          Text(
            _buildGreeting(userName),
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: colors.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.04,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No que você quer focar hoje?',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 16,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'SUGESTÕES PARA VOCÊ',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: colors.onSurfaceMuted,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _AiChatSuggestionGrid(
            suggestions: _suggestions,
            enabled: !isSending,
            onSelected: onPromptSelected,
          ),
        ],
      ),
    );
  }
}

class _AiChatSuggestion {
  const _AiChatSuggestion({required this.label, required this.prompt});

  final String label;
  final String prompt;
}

class _AiChatBrainMark extends StatelessWidget {
  const _AiChatBrainMark();

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 72,
      height: 64,
      child: Icon(
        Icons.psychology_alt_rounded,
        color: isDark ? colors.onSurface : const Color(0xFF101521),
        size: 64,
      ),
    );
  }
}

class _AiChatSuggestionGrid extends StatelessWidget {
  const _AiChatSuggestionGrid({
    required this.suggestions,
    required this.enabled,
    required this.onSelected,
  });

  final List<_AiChatSuggestion> suggestions;
  final bool enabled;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 10,
          children: [
            for (final suggestion in suggestions)
              SizedBox(
                width: itemWidth,
                child: _AiChatSuggestionButton(
                  suggestion: suggestion,
                  enabled: enabled,
                  onTap: () => onSelected(suggestion.prompt),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AiChatSuggestionButton extends StatelessWidget {
  const _AiChatSuggestionButton({
    required this.suggestion,
    required this.enabled,
    required this.onTap,
  });

  final _AiChatSuggestion suggestion;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.onSurfaceMuted.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: colors.accent, size: 15),
              const SizedBox(width: 7),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    suggestion.label,
                    maxLines: 1,
                    softWrap: false,
                    style: GoogleFonts.plusJakartaSans(
                      color: enabled ? colors.onSurface : colors.onSurfaceMuted,
                      fontSize: 13.4,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
