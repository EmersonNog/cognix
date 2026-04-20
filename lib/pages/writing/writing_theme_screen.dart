import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/writing/writing_api.dart';
import '../../widgets/cognix/cognix_page_layout.dart';
import 'writing_route_args.dart';

class WritingThemeScreen extends StatefulWidget {
  const WritingThemeScreen({super.key});

  @override
  State<WritingThemeScreen> createState() => _WritingThemeScreenState();
}

class _WritingThemeScreenState extends State<WritingThemeScreen> {
  static const _surface = Color(0xFF060E20);
  static const _surfaceContainer = Color(0xFF0F1930);
  static const _surfaceContainerHigh = Color(0xFF141F38);
  static const _onSurface = Color(0xFFDEE5FF);
  static const _onSurfaceMuted = Color(0xFF9AA6C5);
  static const _primary = Color(0xFFA3A6FF);
  static const _accent = Color(0xFFFFC56E);
  static const _pageSize = 10;

  late Future<void> _themesFuture;
  late final TextEditingController _searchController;
  Timer? _searchDebounce;

  List<WritingTheme> _items = const [];
  List<String> _categories = const [];
  WritingTheme? _monthlyTheme;
  String? _selectedCategory;
  String _searchQuery = '';
  bool _hasMore = false;
  bool _isLoadingMore = false;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _themesFuture = _reloadThemes();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reloadThemes() async {
    final data = await fetchWritingThemes(
      category: _selectedCategory,
      search: _searchQuery,
      limit: _pageSize,
      offset: 0,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _items = data.items;
      _categories = data.categories;
      _monthlyTheme = data.monthlyTheme;
      _hasMore = data.hasMore;
      _total = data.total;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final data = await fetchWritingThemes(
        category: _selectedCategory,
        search: _searchQuery,
        limit: _pageSize,
        offset: _items.length,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _items = [..._items, ...data.items];
        _categories = data.categories;
        _monthlyTheme = data.monthlyTheme;
        _hasMore = data.hasMore;
        _total = data.total;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _selectCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      _themesFuture = _reloadThemes();
    });
  }

  void _updateSearch(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _searchQuery = value.trim();
        _themesFuture = _reloadThemes();
      });
    });
  }

  void _openTheme(WritingTheme theme) {
    Navigator.of(
      context,
    ).pushNamed('writing-editor', arguments: WritingEditorArgs(theme: theme));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: CognixPageLayout(
        title: 'Redação Cognix',
        backgroundColor: _surface,
        topBarColor: _surfaceContainerHigh,
        titleColor: _onSurface,
        leadingIcon: Icons.edit_note_rounded,
        leadingColor: _accent,
        trailing: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          color: _onSurfaceMuted,
        ),
        backgroundLayers: const [
          _Glow(top: -80, right: -50, color: _accent),
          _Glow(top: 220, left: -80, color: _primary),
        ],
        child: FutureBuilder<void>(
          future: _themesFuture,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting &&
                _items.isEmpty;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              children: [
                _EntranceSection(
                  delay: 0,
                  child: _HeroPanel(
                    totalCount: _total,
                    currentCategory: _selectedCategory,
                    categoryCount: _categories.length,
                  ),
                ),
                const SizedBox(height: 16),
                _EntranceSection(
                  delay: 80,
                  child: _SearchToolbar(
                    searchController: _searchController,
                    onSearchChanged: _updateSearch,
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _selectCategory,
                  ),
                ),
                const SizedBox(height: 16),
                if (isLoading)
                  const _LoadingCard()
                else if (snapshot.hasError && _items.isEmpty)
                  const _InfoCard(
                    title: 'Não consegui carregar os temas agora',
                    subtitle:
                        'Confira sua conexão e tente novamente em instantes.',
                    icon: Icons.cloud_off_rounded,
                  )
                else if (_items.isEmpty)
                  const _InfoCard(
                    title: 'Nenhum tema disponível',
                    subtitle:
                        'Ainda não há temas de redação cadastrados no momento.',
                    icon: Icons.edit_note_rounded,
                  )
                else ...[
                  _EntranceSection(
                    delay: 140,
                    child: _MonthlyThemeCard(
                      theme: _monthlyTheme,
                      onOpenTheme: _openTheme,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EntranceSection(
                    delay: 180,
                    child: _ResultHeader(
                      visibleCount: _items.length,
                      totalCount: _total,
                      hasActiveSearch: _searchQuery.isNotEmpty,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var index = 0; index < _items.length; index++) ...[
                    _EntranceSection(
                      delay: 220 + (index * 22),
                      child: _ThemeCard(
                        theme: _items[index],
                        onTap: () => _openTheme(_items[index]),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_hasMore) ...[
                    const SizedBox(height: 4),
                    _LoadMoreButton(
                      remainingCount: _total - _items.length,
                      isLoading: _isLoadingMore,
                      onTap: _loadMore,
                    ),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EntranceSection extends StatelessWidget {
  const _EntranceSection({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, widget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: widget,
          ),
        );
      },
      child: child,
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.totalCount,
    required this.currentCategory,
    required this.categoryCount,
  });

  final int totalCount;
  final String? currentCategory;
  final int categoryCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07142A), Color(0xFF091C38)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _WritingThemeScreenState._primary.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'REDAÇÃO COGNIX',
              style: GoogleFonts.plusJakartaSans(
                color: _WritingThemeScreenState._accent,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A4279), Color(0xFF17274B)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _WritingThemeScreenState._accent.withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.draw_rounded,
                  color: _WritingThemeScreenState._accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escolha um tema',
                      style: GoogleFonts.manrope(
                        color: _WritingThemeScreenState._onSurface,
                        fontSize: 20.5,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Temas prontos para praticar, organizar ideias e escrever melhor.',
                      style: GoogleFonts.inter(
                        color: _WritingThemeScreenState._onSurfaceMuted,
                        fontSize: 12.6,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                icon: Icons.library_books_rounded,
                label: totalCount > 0 ? '$totalCount temas' : 'Sem temas',
              ),
              _HeroPill(
                icon: Icons.grid_view_rounded,
                label: '$categoryCount categorias',
              ),
              if (currentCategory != null)
                _HeroPill(
                  icon: Icons.filter_alt_rounded,
                  label: currentCategory!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: _WritingThemeScreenState._surfaceContainerHigh.withValues(
          alpha: 0.78,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: _WritingThemeScreenState._accent,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: _WritingThemeScreenState._onSurface,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

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

class _MonthlyThemeCard extends StatelessWidget {
  const _MonthlyThemeCard({required this.theme, required this.onOpenTheme});

  final WritingTheme? theme;
  final ValueChanged<WritingTheme> onOpenTheme;

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme;
    if (currentTheme == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => onOpenTheme(currentTheme),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF241E38), Color(0xFF10182C)],
            ),
            border: Border.all(
              color: _WritingThemeScreenState._accent.withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _WritingThemeScreenState._accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: _WritingThemeScreenState._accent,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REDAÇÃO DO MÊS',
                      style: GoogleFonts.plusJakartaSans(
                        color: _WritingThemeScreenState._accent,
                        fontSize: 9.5,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentTheme.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        color: _WritingThemeScreenState._onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentTheme.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: _WritingThemeScreenState._onSurfaceMuted,
                        fontSize: 11.9,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _WritingThemeScreenState._accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: _WritingThemeScreenState._accent,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                  color: _WritingThemeScreenState._onSurfaceMuted.withValues(alpha: 0.24),
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
                                ? _WritingThemeScreenState._accent.withValues(alpha: 0.12)
                                : _WritingThemeScreenState._surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? _WritingThemeScreenState._accent.withValues(alpha: 0.28)
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

class _DifficultyStyle {
  const _DifficultyStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

_DifficultyStyle _difficultyStyle(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return const _DifficultyStyle(
        background: Color(0x1A54D2A5),
        foreground: Color(0xFF7CF0C3),
      );
    case 'dificil':
    case 'difícil':
      return const _DifficultyStyle(
        background: Color(0x1AF36B7F),
        foreground: Color(0xFFFF8E9D),
      );
    case 'medio':
    case 'médio':
      return const _DifficultyStyle(
        background: Color(0x1AFFC56E),
        foreground: Color(0xFFFFC56E),
      );
    default:
      return const _DifficultyStyle(
        background: Color(0x1AA3A6FF),
        foreground: Color(0xFFA3A6FF),
      );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveSearch,
  });

  final int visibleCount;
  final int totalCount;
  final bool hasActiveSearch;

  @override
  Widget build(BuildContext context) {
    final label = hasActiveSearch ? 'Resultados encontrados' : 'Temas disponíveis';
    final detail = visibleCount >= totalCount
        ? '$totalCount temas'
        : '$visibleCount de $totalCount temas';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: _WritingThemeScreenState._onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Navegue pelos temas disponíveis sem sair da tela.',
                style: GoogleFonts.inter(
                  color: _WritingThemeScreenState._onSurfaceMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _WritingThemeScreenState._surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            detail,
            style: GoogleFonts.inter(
              color: _WritingThemeScreenState._onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.theme, required this.onTap});

  final WritingTheme theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          decoration: BoxDecoration(
            color: _WritingThemeScreenState._surfaceContainer,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _WritingThemeScreenState._primary.withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ThemeBadge(label: theme.category),
                  const SizedBox(width: 8),
                  _ThemeBadge(
                    label: theme.difficulty,
                    backgroundColor: _difficultyStyle(theme.difficulty).background,
                    foregroundColor: _difficultyStyle(theme.difficulty).foreground,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: _WritingThemeScreenState._onSurfaceMuted,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                theme.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  color: _WritingThemeScreenState._onSurface,
                  fontSize: 14.8,
                  fontWeight: FontWeight.w900,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                theme.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: _WritingThemeScreenState._onSurfaceMuted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              if (theme.keywords.isNotEmpty) ...[
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final keyword in theme.keywords.take(3))
                      _KeywordPill(label: keyword),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({
    required this.remainingCount,
    required this.isLoading,
    required this.onTap,
  });

  final int remainingCount;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = remainingCount > _WritingThemeScreenState._pageSize
        ? _WritingThemeScreenState._pageSize
        : remainingCount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: _WritingThemeScreenState._surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _WritingThemeScreenState._accent.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                isLoading ? 'Carregando...' : 'Carregar mais $count temas',
                style: GoogleFonts.inter(
                  color: _WritingThemeScreenState._accent,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (!isLoading) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.expand_more_rounded,
                  color: _WritingThemeScreenState._accent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeBadge extends StatelessWidget {
  const _ThemeBadge({
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            _WritingThemeScreenState._accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          color: foregroundColor ?? _WritingThemeScreenState._accent,
          fontSize: 9.4,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _KeywordPill extends StatelessWidget {
  const _KeywordPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _WritingThemeScreenState._surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: _WritingThemeScreenState._onSurfaceMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _WritingThemeScreenState._surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Carregando temas de redação...',
              style: GoogleFonts.inter(
                color: _WritingThemeScreenState._onSurfaceMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _WritingThemeScreenState._surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _WritingThemeScreenState._accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: _WritingThemeScreenState._accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: _WritingThemeScreenState._onSurface,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: _WritingThemeScreenState._onSurfaceMuted,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({this.top, this.left, this.right, required this.color});

  final double? top;
  final double? left;
  final double? right;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.28), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
