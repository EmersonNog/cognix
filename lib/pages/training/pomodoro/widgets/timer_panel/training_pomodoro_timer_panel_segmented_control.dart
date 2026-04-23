part of '../training_pomodoro_timer_panel.dart';

class _TrainingPomodoroSegmentedControl extends StatelessWidget {
  const _TrainingPomodoroSegmentedControl({
    required this.shellColor,
    required this.borderColor,
    required this.selectedSegmentColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.isFocusPhase,
    required this.onSelectFocus,
    required this.onSelectPause,
  });

  final Color shellColor;
  final Color borderColor;
  final Color selectedSegmentColor;
  final Color activeColor;
  final Color inactiveColor;
  final bool isFocusPhase;
  final VoidCallback onSelectFocus;
  final VoidCallback onSelectPause;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: shellColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TrainingPomodoroSegment(
              label: 'FOCO',
              isSelected: isFocusPhase,
              selectedSegmentColor: selectedSegmentColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: onSelectFocus,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TrainingPomodoroSegment(
              label: 'PAUSA',
              isSelected: !isFocusPhase,
              selectedSegmentColor: selectedSegmentColor,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: onSelectPause,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingPomodoroSegment extends StatelessWidget {
  const _TrainingPomodoroSegment({
    required this.label,
    required this.isSelected,
    required this.selectedSegmentColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color selectedSegmentColor;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? selectedSegmentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
