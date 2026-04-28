part of '../study_plan_widgets.dart';

class StudyPlanChoiceChip extends StatelessWidget {
  const StudyPlanChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.primary,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.2)
                : surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? primary.withValues(alpha: 0.55)
                  : onSurfaceMuted.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: selected ? onSurface : onSurfaceMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class StudyPlanFocusCard extends StatelessWidget {
  const StudyPlanFocusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 152),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.12)
                : surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? primary.withValues(alpha: 0.42)
                  : onSurfaceMuted.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? primary.withValues(alpha: 0.18)
                      : onSurfaceMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: selected ? primary : onSurfaceMuted),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: onSurface,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: onSurfaceMuted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
