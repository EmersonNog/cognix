part of 'writing_editor_screen.dart';

class _WritingInput extends StatelessWidget {
  const _WritingInput({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    required this.minLines,
    required this.onChanged,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final int minLines;
  final ValueChanged<String> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colors.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.manrope(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            style: GoogleFonts.inter(
              color: colors.onSurfaceMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            minLines: minLines,
            maxLines: null,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              color: colors.onSurface,
              fontSize: 13.6,
              height: 1.45,
            ),
            cursorColor: colors.primary,
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.surface,
              hintText: 'Escreva aqui',
              hintStyle: GoogleFonts.inter(
                color: colors.onSurfaceMuted.withValues(alpha: 0.65),
                fontSize: 13,
              ),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colors.primary.withValues(alpha: 0.08),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: colors.primary.withValues(alpha: 0.08),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: colors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposeButton extends StatelessWidget {
  const _ComposeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.post_add_rounded, size: 18, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'Montar texto com a estrutura',
                style: GoogleFonts.plusJakartaSans(
                  color: colors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.isEnabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading || !isEnabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colors.primary.withValues(alpha: 0.82),
          disabledForegroundColor: colorScheme.onPrimary,
          elevation: isLoading ? 0 : 2,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(label),
                  ],
                )
              : Row(
                  key: const ValueKey('idle'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
        ),
      ),
    );
  }
}
