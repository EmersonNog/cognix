import 'package:flutter/material.dart';

import 'app_theme_controller.dart';
import 'app_theme_scope.dart';
import 'cognix_theme_colors.dart';

class ThemeModeQuickButton extends StatelessWidget {
  const ThemeModeQuickButton({super.key, this.backgroundColor, this.iconColor});

  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final controller = AppThemeScope.of(context);
    final colors = context.cognixColors;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.onSurfaceMuted.withValues(alpha: 0.12),
        ),
      ),
      child: IconButton(
        onPressed: () => showThemeModeSheet(context),
        icon: Icon(_iconFor(controller.preference)),
        color: iconColor ?? colors.onSurfaceMuted,
        iconSize: 19,
        padding: EdgeInsets.zero,
        tooltip: 'Aparência',
      ),
    );
  }

  IconData _iconFor(AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.system => Icons.brightness_auto_rounded,
      AppThemePreference.light => Icons.light_mode_rounded,
      AppThemePreference.dark => Icons.dark_mode_rounded,
    };
  }
}

Future<void> showThemeModeSheet(BuildContext context) async {
  final theme = Theme.of(context);
  final colors = context.cognixColors;
  final controller = AppThemeScope.of(context);

  await showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aparência',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Escolha como o Cognix deve aparecer para você.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              for (final preference in AppThemePreference.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(switch (preference) {
                    AppThemePreference.system => Icons.brightness_auto_rounded,
                    AppThemePreference.light => Icons.light_mode_rounded,
                    AppThemePreference.dark => Icons.dark_mode_rounded,
                  }, color: colors.primary),
                  title: Text(
                    preference.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: controller.preference == preference
                      ? Icon(Icons.check_rounded, color: colors.success)
                      : null,
                  onTap: () async {
                    await controller.setPreference(preference);
                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}
