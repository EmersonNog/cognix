import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(destinations.length, (index) {
            final destination = destinations[index];
            return _HomeNavItem(
              label: destination.label,
              icon: destination.icon,
              selected: currentIndex == index,
              onTap: () => onSelected(index),
              primary: primary,
              muted: onSurfaceMuted,
              selectedBackground: surfaceContainerHigh,
            );
          }),
        ),
      ),
    );
  }
}

class _HomeDestination {
  const _HomeDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
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
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;
  final Color muted;
  final Color selectedBackground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: primary.withValues(alpha: 0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 20, color: selected ? primary : muted),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? primary : muted,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
