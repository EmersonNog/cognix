import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import '../../../services/local/avatar_service.dart';

class ProfileAvatarDisplay extends StatefulWidget {
  const ProfileAvatarDisplay({
    required this.userName,
    required this.primary,
    this.size = 100,
    this.onTap,
  });

  final String userName;
  final Color primary;
  final double size;
  final VoidCallback? onTap;

  @override
  State<ProfileAvatarDisplay> createState() => _ProfileAvatarDisplayState();
}

class _ProfileAvatarDisplayState extends State<ProfileAvatarDisplay> {
  String _avatarSeed = '';

  @override
  void initState() {
    super.initState();
    _avatarSeed = widget.userName;
    _loadAvatarSeed();
  }

  @override
  void didUpdateWidget(covariant ProfileAvatarDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadAvatarSeed();
  }

  Future<void> _loadAvatarSeed() async {
    try {
      final seed = await AvatarService.getAvatarSeed();
      if (seed != null && mounted) {
        setState(() {
          _avatarSeed = seed;
        });
      }
    } catch (e) {
      // Se falhar, deixa o padrão
      debugPrint('Erro ao carregar avatar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: widget.primary, width: 3),
        ),
        child: ClipOval(child: RandomAvatar(_avatarSeed)),
      ),
    );
  }
}
