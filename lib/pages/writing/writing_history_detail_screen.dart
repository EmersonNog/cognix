import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/writing/writing_api.dart';
import '../../widgets/cognix/cognix_page_layout.dart';
import 'writing_route_args.dart';

part 'writing_history_detail_screen/history_detail_cards.dart';
part 'writing_history_detail_screen/history_detail_helpers.dart';
part 'writing_history_detail_screen/history_detail_states.dart';

class WritingHistoryDetailScreen extends StatefulWidget {
  const WritingHistoryDetailScreen({super.key, required this.args});

  final WritingHistoryDetailArgs args;

  @override
  State<WritingHistoryDetailScreen> createState() =>
      _WritingHistoryDetailScreenState();
}

class _WritingHistoryDetailScreenState
    extends State<WritingHistoryDetailScreen> {
  static const _surface = Color(0xFF060E20);
  static const _surfaceContainer = Color(0xFF0F1930);
  static const _surfaceContainerHigh = Color(0xFF141F38);
  static const _onSurface = Color(0xFFDEE5FF);
  static const _onSurfaceMuted = Color(0xFF9AA6C5);
  static const _primary = Color(0xFFA3A6FF);
  static const _accent = Color(0xFFFFC56E);
  static const _success = Color(0xFF7ED6C5);
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
    return Scaffold(
      backgroundColor: _surface,
      body: CognixPageLayout(
        title: 'Detalhes da redação',
        backgroundColor: _surface,
        topBarColor: _surfaceContainerHigh,
        titleColor: _onSurface,
        leadingIcon: Icons.layers_rounded,
        leadingColor: _accent,
        trailing: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
          color: _onSurfaceMuted,
        ),
        backgroundLayers: const [
          _Glow(top: -90, right: -55, color: _accent),
          _Glow(top: 250, left: -80, color: _primary),
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
              color: _accent,
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
