import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/writing/writing_api.dart';
import '../../widgets/cognix/cognix_page_layout.dart';
import 'writing_route_args.dart';

part 'writing_theme_screen/category_filter.dart';
part 'writing_theme_screen/entrance_section.dart';
part 'writing_theme_screen/featured_cards.dart';
part 'writing_theme_screen/glow.dart';
part 'writing_theme_screen/search_toolbar.dart';
part 'writing_theme_screen/state_cards.dart';
part 'writing_theme_screen/theme_list_widgets.dart';
part 'writing_theme_screen/theme_styles.dart';

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
                    delay: 160,
                    child: _HistoryShortcutCard(
                      onTap: () =>
                          Navigator.of(context).pushNamed('writing-history'),
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
