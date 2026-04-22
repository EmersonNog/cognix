import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/writing/writing_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../../../utils/api_datetime.dart';
import '../../../widgets/cognix/cognix_page_layout.dart';
import '../models/writing_route_args.dart';

part 'history_cards.dart';
part 'history_helpers.dart';
part 'history_state_widgets.dart';

class WritingHistoryScreen extends StatefulWidget {
  const WritingHistoryScreen({super.key});

  @override
  State<WritingHistoryScreen> createState() => _WritingHistoryScreenState();
}

class _WritingHistoryScreenState extends State<WritingHistoryScreen> {
  static const _pageSize = 5;

  late Future<void> _future;
  List<WritingSubmissionSummary> _items = const [];
  bool _hasMore = false;
  bool _isLoadingMore = false;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _future = _reload();
  }

  Future<void> _reload() async {
    final data = await fetchWritingSubmissions(limit: _pageSize, offset: 0);
    if (!mounted) return;
    setState(() {
      _items = data.items;
      _hasMore = data.hasMore || data.items.length < data.total;
      _total = data.total;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final data = await fetchWritingSubmissions(
        limit: _pageSize,
        offset: _items.length,
      );
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...data.items];
        _hasMore = data.hasMore || _items.length < data.total;
        _total = data.total;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  void _openDetail(WritingSubmissionSummary item) {
    Navigator.of(context).pushNamed(
      'writing-history-detail',
      arguments: WritingHistoryDetailArgs(submissionId: item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final latest = _items.isEmpty ? null : _items.first;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CognixPageLayout(
        title: 'Histórico de redação',
        backgroundColor: colors.surface,
        topBarColor: colors.surfaceContainerHigh,
        titleColor: colors.onSurface,
        leadingIcon: Icons.history_rounded,
        leadingColor: colors.accent,
        trailing: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          color: colors.onSurfaceMuted,
        ),
        backgroundLayers: [
          _Glow(top: -90, right: -50, color: colors.accent),
          _Glow(top: 200, left: -70, color: colors.primary),
        ],
        child: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting &&
                _items.isEmpty;

            return RefreshIndicator(
              color: colors.accent,
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                children: [
                  _HeroCard(totalCount: _total, latest: latest),
                  const SizedBox(height: 18),
                  _SectionHeader(
                    title: 'Suas redações',
                    subtitle: _total == 0
                        ? 'Quando você analisar uma redação, ela aparece aqui.'
                        : 'Acompanhe a evolução e retome quando quiser.',
                  ),
                  const SizedBox(height: 12),
                  if (isLoading)
                    const _LoadingCard()
                  else if (snapshot.hasError && _items.isEmpty)
                    const _InfoCard(
                      title: 'Não consegui carregar o histórico',
                      subtitle:
                          'Confira sua conexão e tente novamente em instantes.',
                      icon: Icons.cloud_off_rounded,
                    )
                  else if (_items.isEmpty)
                    const _InfoCard(
                      title: 'Nenhuma redação salva ainda',
                      subtitle:
                          'Assim que você analisar a primeira redação, o histórico aparece aqui com as versões.',
                      icon: Icons.auto_stories_rounded,
                    )
                  else ...[
                    for (final item in _items) ...[
                      _HistoryCard(item: item, onTap: () => _openDetail(item)),
                      const SizedBox(height: 12),
                    ],
                    if (_hasMore)
                      _LoadMoreButton(
                        remainingCount: _total - _items.length,
                        isLoading: _isLoadingMore,
                        onTap: _loadMore,
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
