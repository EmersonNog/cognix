import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import '../../../services/avatar_service.dart';

class AvatarSelectorDialog extends StatefulWidget {
  const AvatarSelectorDialog({
    required this.primary,
    required this.onSurface,
    required this.surfaceContainer,
  });

  final Color primary;
  final Color onSurface;
  final Color surfaceContainer;

  @override
  State<AvatarSelectorDialog> createState() => _AvatarSelectorDialogState();
}

class _AvatarSelectorDialogState extends State<AvatarSelectorDialog> {
  late String _selectedSeed;
  final List<String> _avatarOptions = [
    'avatar_1',
    'avatar_2',
    'avatar_3',
    'avatar_4',
    'avatar_5',
    'avatar_6',
    'avatar_7',
    'avatar_8',
    'avatar_9',
    'avatar_10',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentSeed();
  }

  Future<void> _loadCurrentSeed() async {
    final seed = await AvatarService.getAvatarSeed();
    setState(() {
      _selectedSeed = seed ?? _avatarOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Escolha seu Avatar',
              style: GoogleFonts.manrope(
                color: widget.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _avatarOptions.length,
              itemBuilder: (context, index) {
                final seed = _avatarOptions[index];
                final isSelected = _selectedSeed == seed;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSeed = seed;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? widget.primary : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(child: RandomAvatar(seed)),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.manrope(
                        color: widget.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AvatarService.saveAvatarSeed(_selectedSeed);
                      if (context.mounted) {
                        Navigator.pop(context, _selectedSeed);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Salvar',
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
