part of 'home_recent_performance_card.dart';

Color _recentPerformanceAccentForAccuracy(
  double accuracyPercent, {
  required double attentionThreshold,
  required Color primary,
}) {
  if (accuracyPercent < attentionThreshold) {
    return const Color(0xFFFF6B78);
  }
  if (accuracyPercent >= 85) {
    return primary;
  }
  return const Color(0xFF7ED6C5);
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
