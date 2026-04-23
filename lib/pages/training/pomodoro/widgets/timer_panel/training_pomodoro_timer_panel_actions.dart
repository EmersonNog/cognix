part of '../training_pomodoro_timer_panel.dart';

class _TrainingPomodoroActionRow extends StatelessWidget {
  const _TrainingPomodoroActionRow({
    required this.isRunning,
    required this.primaryActionColor,
    required this.primaryActionForegroundColor,
    required this.shellColor,
    required this.onSurface,
    required this.onPrimaryAction,
    required this.onReset,
  });

  final bool isRunning;
  final Color primaryActionColor;
  final Color primaryActionForegroundColor;
  final Color shellColor;
  final Color onSurface;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final primaryButtonWidth = (constraints.maxWidth - 68)
            .clamp(188.0, 248.0)
            .toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: primaryButtonWidth,
              child: FilledButton.icon(
                onPressed: onPrimaryAction,
                icon: Icon(
                  isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(isRunning ? 'Pausar' : 'Iniciar'),
                style: FilledButton.styleFrom(
                  backgroundColor: primaryActionColor,
                  foregroundColor: primaryActionForegroundColor,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _TrainingPomodoroIconButton(
              icon: Icons.restart_alt_rounded,
              backgroundColor: shellColor,
              onSurface: onSurface,
              onTap: onReset,
            ),
          ],
        );
      },
    );
  }
}

class _TrainingPomodoroIconButton extends StatelessWidget {
  const _TrainingPomodoroIconButton({
    required this.icon,
    required this.backgroundColor,
    required this.onSurface,
    required this.onTap,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color onSurface;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, color: onSurface, size: 22),
        ),
      ),
    );
  }
}
