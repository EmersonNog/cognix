part of '../writing_theme_screen.dart';

class _SearchToolbar extends StatelessWidget {
  const _SearchToolbar({
    required this.searchController,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SearchField(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 10),
        _CategoryDropdown(
          categories: categories,
          selectedCategory: selectedCategory,
          onSelected: onCategorySelected,
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _WritingThemeScreenState._surfaceContainerHigh.withValues(
          alpha: 0.92,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.inter(
          color: _WritingThemeScreenState._onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar tema',
          hintStyle: GoogleFonts.inter(
            color: _WritingThemeScreenState._onSurfaceMuted,
            fontSize: 13,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 18,
              color: _WritingThemeScreenState._onSurfaceMuted,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
