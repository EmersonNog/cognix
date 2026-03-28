import 'package:flutter/material.dart';

class PlanTopIconButton extends StatelessWidget {
  const PlanTopIconButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
