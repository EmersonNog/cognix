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
              right: -2,
              bottom: -2,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF131E39),
                  border: Border.all(color: primary, width: 1.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit_rounded,
                  size: size * 0.14,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
