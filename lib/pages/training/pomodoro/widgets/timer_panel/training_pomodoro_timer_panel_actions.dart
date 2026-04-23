part of '../training_pomodoro_timer_panel.dart';

class _TrainingPomodoroActionRow extends StatelessWidget {
  const _TrainingPomodoroActionRow({
    required this.isRunning,
    required this.primaryActionColor,
    required this.primaryActionForegroundColor,
    required this.shellColor,
    required this.resetBorderColor,
    required this.resetIconColor,
    required this.onPrimaryAction,
    required this.onReset,
  });

  final bool isRunning;
  final Color primaryActionColor;
  final Color primaryActionForegroundColor;
  final Color shellColor;
  final Color resetBorderColor;
  final Color resetIconColor;
  final VoidCallback onPrimaryAction;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 292),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
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
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _TrainingPomodoroIconButton(
              icon: Icons.restart_alt_rounded,
              backgroundColor: shellColor,
              borderColor: resetBorderColor,
              iconColor: resetIconColor,
              onTap: onReset,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingPomodoroIconButton extends StatelessWidget {
  const _TrainingPomodoroIconButton({
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}
