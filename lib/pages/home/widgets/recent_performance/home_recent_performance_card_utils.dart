part of 'home_recent_performance_card.dart';

Color _recentPerformanceAccentForAccuracy(
  double accuracyPercent, {
  required double attentionThreshold,
  required Color primary,
  required Color success,
  required Color danger,
}) {
  if (accuracyPercent < attentionThreshold) {
    return danger;
  }
  if (accuracyPercent >= 85) {
    return primary;
  }
  return success;
}

String _buildRelativeCompletionLabel(DateTime? completedAt, DateTime now) {
  if (completedAt == null) {
    return 'Concluído recentemente';
  }

  final difference = now.difference(completedAt);

  if (difference.inSeconds < 60) {
    return 'Concluído há instantes';
  }
  if (difference.inMinutes < 60) {
    return 'Concluído há ${difference.inMinutes} min';
  }
  if (difference.inHours < 24) {
    return 'Concluído há ${difference.inHours}h';
  }
  if (difference.inDays == 1) {
    return 'Concluído ontem';
  }
  return 'Concluído há ${difference.inDays} dias';
}
