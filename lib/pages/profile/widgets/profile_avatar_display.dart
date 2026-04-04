import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfileAvatarDisplay extends StatelessWidget {
  const ProfileAvatarDisplay({
    super.key,
    required this.userName,
    required this.primary,
    required this.avatarSeed,
    this.size = 100,
    this.onTap,
  });

  final String userName;
  final Color primary;
  final String avatarSeed;
  final double size;
  final VoidCallback? onTap;

  String _effectiveSeed() {
    final normalized = avatarSeed.trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }

    final fallback = userName.trim();
    if (fallback.isNotEmpty) {
      return fallback;
    }

    return 'avatar_1';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primary, width: 3),
        ),
        child: ClipOval(child: RandomAvatar(_effectiveSeed())),
      ),
    );
  }
}
