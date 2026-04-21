import 'package:flutter/material.dart';

import '../../../../theme/cognix_theme_colors.dart';

String buildInsightMetadataText(String? generatedAtLabel) {
  final parts = <String>['Resumo editorial do seu momento atual'];
  if (generatedAtLabel != null && generatedAtLabel.isNotEmpty) {
    parts.add(generatedAtLabel);
  }
  return parts.join(' · ');
}

Color resolveInsightRiskColor(CognixThemeColors colors, String riskLevel) {
  switch (riskLevel.trim().toLowerCase()) {
    case 'alto':
      return colors.danger;
    case 'medio':
    case 'médio':
      return colors.accent;
    default:
      return colors.success;
  }
}

String capitalizeInsightLabel(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return trimmed;
  }
  return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
}
