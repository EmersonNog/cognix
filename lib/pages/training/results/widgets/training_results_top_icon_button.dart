import 'package:flutter/material.dart';

class TrainingResultsTopIconButton extends StatelessWidget {
  const TrainingResultsTopIconButton({
    super.key,
    this.icon,
    required this.background,
    required this.iconColor,
  });

  final IconData? icon;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }
}
