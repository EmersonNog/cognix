import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../theme/cognix_theme_colors.dart';

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
    final colors = context.cognixColors;
    final actionSize = size * 0.24;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 3),
            ),
            child: ClipOval(child: RandomAvatar(_effectiveSeed())),
          ),
          if (onTap != null)
            Positioned(
              right: size * 0.03,
              bottom: size * 0.03,
              child: Container(
                width: actionSize,
                height: actionSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfaceContainerHigh,
                  border: Border.all(
                    color: colors.surfaceContainer,
                    width: 2.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit_rounded,
                  size: size * 0.12,
                  color: primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
