import 'package:flutter/material.dart';

class TrainingResultsTopIconButton extends StatelessWidget {
  const TrainingResultsTopIconButton({
    super.key,
    this.icon,
    this.onTap,
    required this.background,
    required this.iconColor,
  });

  final IconData? icon;
  final VoidCallback? onTap;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, color: iconColor, size: 18),
        ),
      ),
    );
  }
}
