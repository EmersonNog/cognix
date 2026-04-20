part of '../writing_theme_screen.dart';

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showCategorySheet(context),
        child: Ink(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _WritingThemeScreenState._surfaceContainerHigh.withValues(
              alpha: 0.92,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.tune_rounded,
                size: 19,
                color: _WritingThemeScreenState._accent,
              ),
              if (selectedCategory != null)
                Positioned(
                  top: 11,
                  right: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _WritingThemeScreenState._accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _WritingThemeScreenState._accent.withValues(
                            alpha: 0.38,
                          ),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCategorySheet(BuildContext context) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _CategorySheet(
          categories: categories,
          selectedCategory: selectedCategory,
        );
      },
    );

    if (selected != selectedCategory) {
      onSelected(selected);
    }
  }
}

class _CategorySheet extends StatelessWidget {
  const _CategorySheet({
    required this.categories,
    required this.selectedCategory,
  });

  final List<String> categories;
  final String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final items = <String?>[null, ...categories];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            color: _WritingThemeScreenState._surfaceContainer,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _WritingThemeScreenState._primary.withValues(alpha: 0.14),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: _WritingThemeScreenState._onSurfaceMuted.withValues(
                    alpha: 0.24,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Escolha a categoria',
                        style: GoogleFonts.manrope(
                          color: _WritingThemeScreenState._onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: _WritingThemeScreenState._onSurfaceMuted,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == selectedCategory;
                    final label = item ?? 'Todas as categorias';

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.of(context).pop(item),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _WritingThemeScreenState._accent.withValues(
                                    alpha: 0.12,
                                  )
                                : _WritingThemeScreenState
                                      ._surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? _WritingThemeScreenState._accent.withValues(
                                      alpha: 0.28,
                                    )
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  label,
                                  style: GoogleFonts.inter(
                                    color: isSelected
                                        ? _WritingThemeScreenState._accent
                                        : _WritingThemeScreenState._onSurface,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_rounded,
                                  color: _WritingThemeScreenState._accent,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
