part of '../../study_plan_screen.dart';

extension _StudyPlanFormSectionHelpers on _StudyPlanFormContent {
  StudyPlanSubsection _buildLockedSubsection({
    required String title,
    required String subtitle,
  }) {
    return StudyPlanSubsection(
      title: title,
      subtitle: subtitle,
      trailing: StudyPlanLockBadge(primary: palette.primary),
      surfaceContainerHigh: palette.surfaceContainerHigh,
      onSurface: palette.onSurface,
      onSurfaceMuted: palette.onSurfaceMuted,
      onTap: onLockedTap,
      child: StudyPlanLockedPlaceholder(
        primary: palette.primary,
        onSurface: palette.onSurface,
        onSurfaceMuted: palette.onSurfaceMuted,
      ),
    );
  }
}

String _focusModeLabel(String focusMode) {
  switch (focusMode) {
    case 'constancia':
      return 'Constância';
    case 'revisao':
      return 'Revisão';
    case 'desempenho':
      return 'Desempenho';
    default:
      return 'Flexível';
  }
}

String _preferredPeriodLabel(String preferredPeriod) =>
    _StudyPlanScreenState._periodOptions[preferredPeriod] ?? 'Flexivel';
