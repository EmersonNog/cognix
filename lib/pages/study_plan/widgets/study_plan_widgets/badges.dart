part of '../study_plan_widgets.dart';

class StudyPlanInfoBadge extends StatelessWidget {
  const StudyPlanInfoBadge({
    super.key,
    required this.label,
    required this.primary,
    required this.onSurface,
  });

  final String label;
  final Color primary;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withValues(alpha: 0.26)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: onSurface,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class StudyPlanLockBadge extends StatelessWidget {
  const StudyPlanLockBadge({super.key, required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withValues(alpha: 0.24)),
      ),
      child: Icon(Icons.lock_rounded, color: primary, size: 14),
    );
  }
}

class StudyPlanLockedPlaceholder extends StatelessWidget {
  const StudyPlanLockedPlaceholder({
    super.key,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceMuted,
    this.message = 'Disponível com assinatura premium.',
  });

  final Color primary;
  final Color onSurface;
  final Color onSurfaceMuted;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_rounded,
            color: onSurface.withValues(alpha: 0.82),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                color: onSurfaceMuted,
                fontSize: 12.2,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
