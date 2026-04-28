import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/core/api_client.dart'
    show isSubscriptionRequiredError;
import '../../../services/writing/writing_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../models/writing_route_args.dart';

part 'filters/category_filter.dart';
part 'shared/entrance_section.dart';
part 'featured/featured_history_card.dart';
part 'featured/featured_monthly_card.dart';
part 'filters/search_toolbar.dart';
part 'shared/state_cards.dart';
part 'list/theme_list_cards.dart';
part 'list/theme_list_summary.dart';
part 'shared/theme_styles.dart';

class WritingThemeScreen extends StatefulWidget {
  const WritingThemeScreen({super.key});

  @override
  State<WritingThemeScreen> createState() => _WritingThemeScreenState();
}

class _WritingThemeScreenState extends State<WritingThemeScreen> {
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
  bool _isSubscriptionBlocked = false;
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
    final result = await fetchWritingThemesWithAccess(
      category: _selectedCategory,
      search: _searchQuery,
      limit: _pageSize,
      offset: 0,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _items = result.data.items;
      _categories = result.data.categories;
      _monthlyTheme = result.data.monthlyTheme;
      _hasMore = result.data.hasMore;
      _total = result.data.total;
      _isSubscriptionBlocked = result.requiresSubscription;
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
      final result = await fetchWritingThemesWithAccess(
        category: _selectedCategory,
        search: _searchQuery,
        limit: _pageSize,
        offset: _items.length,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _items = [..._items, ...result.data.items];
        _categories = result.data.categories;
        _monthlyTheme = result.data.monthlyTheme;
        _hasMore = result.data.hasMore;
        _total = result.data.total;
        _isSubscriptionBlocked = result.requiresSubscription;
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

  void _openSubscription() {
    Navigator.of(context).pushNamed('subscription');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final pageBackgroundColor = colors.surface;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        surfaceTintColor: pageBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: BackButton(color: colors.onSurface),
        title: Text(
          'Redação Cognix',
          style: GoogleFonts.manrope(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _themesFuture,
            builder: (context, snapshot) {
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting &&
                  _items.isEmpty;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
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
                  else if (snapshot.hasError &&
                      _items.isEmpty &&
                      !isSubscriptionRequiredError(snapshot.error))
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
                        onOpenTheme: _isSubscriptionBlocked
                            ? (_) => _openSubscription()
                            : _openTheme,
                        previewMode: _isSubscriptionBlocked,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _EntranceSection(
                      delay: 160,
                      child: _HistoryShortcutCard(
                        onTap: _isSubscriptionBlocked
                            ? _openSubscription
                            : () => Navigator.of(
                                context,
                              ).pushNamed('writing-history'),
                        previewMode: _isSubscriptionBlocked,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _EntranceSection(
                      delay: 180,
                      child: _ResultHeader(
                        visibleCount: _items.length,
                        totalCount: _total,
                        hasActiveSearch: _searchQuery.isNotEmpty,
                        previewMode: _isSubscriptionBlocked,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var index = 0; index < _items.length; index++) ...[
                      _EntranceSection(
                        delay: 220 + (index * 22),
                        child: _ThemeCard(
                          theme: _items[index],
                          onTap: _isSubscriptionBlocked
                              ? _openSubscription
                              : () => _openTheme(_items[index]),
                          previewMode: _isSubscriptionBlocked,
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
                        previewMode: _isSubscriptionBlocked,
                      ),
                    ],
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
