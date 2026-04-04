part of '../avatar_store_dialog.dart';

String _formatAvatarRarity(String rarity) {
  switch (rarity.trim().toLowerCase()) {
    case 'raro':
      return 'Raro';
    case 'epico':
      return 'Épico';
    case 'lendario':
      return 'Lendário';
    default:
      return 'Comum';
  }
}

Color _avatarRarityColor(String rarity, Color primary) {
  switch (rarity.trim().toLowerCase()) {
    case 'raro':
      return const Color(0xFF58C4FF);
    case 'epico':
      return const Color(0xFFB785FF);
    case 'lendario':
      return const Color(0xFFFFC857);
    default:
      return primary;
  }
}
