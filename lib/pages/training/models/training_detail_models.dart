import 'package:flutter/material.dart';

class TrainingPrimaryCtaData {
  const TrainingPrimaryCtaData({
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  final String label;
  final String subtitle;
  final IconData icon;
}

class TrainingQuickActionData {
  const TrainingQuickActionData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
}
