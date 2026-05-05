import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/app_theme_controller.dart';

class HomeLogoutButton extends StatelessWidget {
  const HomeLogoutButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.backgroundColor,
    required this.iconColor,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.logout_rounded),
        color: iconColor,
        iconSize: 18,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class HomeThemeButton extends StatelessWidget {
  const HomeThemeButton({
    super.key,
    required this.preference,
    required this.onPressed,
    required this.backgroundColor,
    required this.iconColor,
  });

  final AppThemePreference preference;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(_iconFor(preference)),
        color: iconColor,
        iconSize: 18,
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

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.primary,
    required this.onSurfaceMuted,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color primary;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    const destinations = <_HomeDestination>[
      _HomeDestination(label: 'Início', icon: Icons.grid_view_rounded),
      _HomeDestination(label: 'Treino', icon: Icons.timer_rounded),
      _HomeDestination(
        label: 'Chat',
        icon: Icons.auto_awesome_rounded,
        featured: true,
      ),
      _HomeDestination(label: 'Análise', icon: Icons.insights_rounded),
      _HomeDestination(label: 'Perfil', icon: Icons.person_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: surfaceContainer,
          borderRadius: BorderRadius.circular(22),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primary.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: List<Widget>.generate(destinations.length * 2 - 1, (slot) {
            if (slot.isOdd) {
              return const SizedBox(width: 4);
            }

            final index = slot ~/ 2;
            final destination = destinations[index];
            return Expanded(
              child: _HomeNavItem(
                label: destination.label,
                icon: destination.icon,
                selected: currentIndex == index,
                onTap: () => onSelected(index),
                primary: primary,
                muted: onSurfaceMuted,
                selectedBackground: surfaceContainerHigh,
                featured: destination.featured,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _HomeDestination {
  const _HomeDestination({
    required this.label,
    required this.icon,
    this.featured = false,
  });

  final String label;
  final IconData icon;
  final bool featured;
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.primary,
    required this.muted,
    required this.selectedBackground,
    required this.featured,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;
  final Color muted;
  final Color selectedBackground;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? selectedBackground : Colors.transparent;
    final border = selected && featured
        ? Border.all(color: primary.withValues(alpha: 0.34))
        : null;
    final activeColor = selected ? primary : muted;
    final iconSize = selected && featured ? 21.0 : 20.0;
    final labelWeight = selected && featured
        ? FontWeight.w800
        : FontWeight.w600;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: border,
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: primary.withValues(alpha: featured ? 0.32 : 0.22),
                    blurRadius: featured ? 20 : 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: iconSize, color: activeColor),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: labelWeight,
                color: activeColor,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
