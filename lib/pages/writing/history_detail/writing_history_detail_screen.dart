import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/writing/writing_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../../../widgets/cognix/cognix_page_layout.dart';
import '../models/writing_route_args.dart';

part 'history_detail_cards.dart';
part 'history_detail_helpers.dart';
part 'history_detail_states.dart';

class WritingHistoryDetailScreen extends StatefulWidget {
  const WritingHistoryDetailScreen({super.key, required this.args});

  final WritingHistoryDetailArgs args;

  @override
  State<WritingHistoryDetailScreen> createState() =>
      _WritingHistoryDetailScreenState();
}

class _WritingHistoryDetailScreenState
    extends State<WritingHistoryDetailScreen> {
  static const _pageSize = 5;

  late Future<void> _future;
  WritingSubmissionDetail? _detail;
  List<WritingSubmissionVersion> _versions = const [];
  bool _hasMore = false;
  bool _isLoadingMore = false;
  int _versionsTotal = 0;

  @override
  void initState() {
    super.initState();
    _future = _reload();
  }

  Future<void> _reload() async {
    final detail = await fetchWritingSubmissionDetail(
      widget.args.submissionId,
      versionsLimit: _pageSize,
      versionsOffset: 0,
    );
    if (!mounted) return;
    setState(() {
      _detail = detail;
      _versions = detail.versions;
      _versionsTotal = detail.versionsTotal;
      _hasMore =
          detail.versionsHasMore ||
          detail.versions.length < detail.versionsTotal;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _reload();
    });
    await _future;
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final detail = await fetchWritingSubmissionDetail(
        widget.args.submissionId,
        versionsLimit: _pageSize,
        versionsOffset: _versions.length,
      );
      if (!mounted) return;
      final nextVersions = [..._versions, ...detail.versions];
      setState(() {
        _detail = detail;
        _versions = nextVersions;
        _versionsTotal = detail.versionsTotal;
        _hasMore =
            detail.versionsHasMore ||
            nextVersions.length < detail.versionsTotal;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  void _continueFromVersion(
    WritingSubmissionDetail detail,
    WritingSubmissionVersion version,
  ) {
    Navigator.of(context).pushNamed(
      'writing-editor',
      arguments: WritingEditorArgs(
        theme: detail.theme,
        initialDraft: version.toDraft(
          theme: detail.theme,
          submissionId: detail.id,
        ),
      ),
    );
  }

  void _openDiagnosis(
    WritingSubmissionDetail detail,
    WritingSubmissionVersion version,
  ) {
    Navigator.of(context).pushNamed(
      'writing-result',
      arguments: WritingResultArgs(
        draft: version.toDraft(theme: detail.theme, submissionId: detail.id),
        feedback: version.toFeedback(submissionId: detail.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CognixPageLayout(
        title: 'Detalhes da redação',
        backgroundColor: colors.surface,
        topBarColor: colors.surfaceContainerHigh,
        titleColor: colors.onSurface,
        leadingIcon: Icons.layers_rounded,
        leadingColor: colors.accent,
        trailing: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          color: colors.onSurfaceMuted,
        ),
        backgroundLayers: [
          _Glow(top: -90, right: -55, color: colors.accent),
          _Glow(top: 250, left: -80, color: colors.primary),
        ],
        child: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingState();
            }

            if (snapshot.hasError || _detail == null) {
              return _ErrorState(onRetry: _refresh);
            }

            final detail = _detail!;
            return RefreshIndicator(
              color: colors.accent,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                children: [
                  _SectionHeader(
                    title: 'Histórico',
                    subtitle: 'Escolha uma versão.',
                    pillLabel: '$_versionsTotal versões',
                  ),
                  const SizedBox(height: 12),
                  for (final version in _versions) ...[
                    _VersionCard(
                      detail: detail,
                      version: version,
                      isLatest: version.versionNumber == detail.currentVersion,
                      onContinue: () => _continueFromVersion(detail, version),
                      onOpenDiagnosis: () => _openDiagnosis(detail, version),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_hasMore)
                    _LoadMoreButton(
                      remainingCount: _versionsTotal - _versions.length,
                      isLoading: _isLoadingMore,
                      onTap: _loadMore,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
