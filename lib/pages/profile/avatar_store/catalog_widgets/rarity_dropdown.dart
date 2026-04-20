part of '../../avatar_store_dialog.dart';

class _AvatarRarityDropdown extends StatelessWidget {
  const _AvatarRarityDropdown({
    required this.selectedRarity,
    required this.availableRarities,
    required this.primary,
    required this.onSurface,
    required this.palette,
    required this.onSelected,
  });

  final String selectedRarity;
  final List<String> availableRarities;
  final Color primary;
  final Color onSurface;
  final _AvatarStorePalette palette;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final hasCustomSelection = selectedRarity != _allRaritiesFilterValue;

    return PopupMenuButton<String>(
      tooltip: 'Filtrar por raridade',
      initialValue: selectedRarity,
      onSelected: onSelected,
      color: palette.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        _AvatarRarityMenuItem(
          value: _allRaritiesFilterValue,
          label: 'Todas',
          onSurface: onSurface,
        ),
        ...availableRarities.map(
          (rarity) => _AvatarRarityMenuItem(
            value: rarity,
            label: _formatAvatarRarity(rarity),
            onSurface: onSurface,
          ),
        ),
      ],
      child: _AvatarRarityFilterButton(
        selected: hasCustomSelection,
        primary: primary,
        onSurface: onSurface,
        palette: palette,
      ),
    );
  }
}

class _AvatarRarityMenuItem extends PopupMenuItem<String> {
  _AvatarRarityMenuItem({
    required String value,
    required String label,
    required Color onSurface,
  }) : super(
         value: value,
         child: Text(
           label,
           style: GoogleFonts.plusJakartaSans(
             color: onSurface,
             fontSize: 12.5,
             fontWeight: FontWeight.w700,
           ),
         ),
       );
}

class _AvatarRarityFilterButton extends StatelessWidget {
  const _AvatarRarityFilterButton({
    required this.selected,
    required this.primary,
    required this.onSurface,
    required this.palette,
  });

  final bool selected;
  final Color primary;
  final Color onSurface;
  final _AvatarStorePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: selected
            ? primary.withValues(alpha: 0.14)
            : palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? primary.withValues(alpha: 0.22) : palette.border,
        ),
      ),
      child: Icon(
        Icons.tune_rounded,
        size: 18,
        color: selected ? primary : onSurface.withValues(alpha: 0.78),
      ),
    );
  }
}
