import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/questions/questions_api.dart';
import '../../services/summaries/summaries_api.dart';
import '../training/training_detail_screen.dart';
import 'subjects_data.dart';
import 'widgets/subject_card.dart';
import 'widgets/subject_category_header.dart';
import 'widgets/subjects_hero_card.dart';

class SubjectsTab extends StatefulWidget {
  const SubjectsTab({
    super.key,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.primary,
    required this.area,
  });

  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color primary;
  final SubjectsArea area;

  @override
  State<SubjectsTab> createState() => _SubjectsTabState();
}

class _SubjectsTabState extends State<SubjectsTab> {
  late Future<List<_SubjectCardData>> _subcategoriesFuture;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = _loadSubjectCards();
  }

  void _refreshSubjectCards() {
    if (!mounted) return;
    setState(() {
      _subcategoriesFuture = _loadSubjectCards();
    });
  }

  Future<List<_SubjectCardData>> _loadSubjectCards() async {
    final discipline = subjectsAreaTitle(widget.area);
    final items = await fetchSubcategories(discipline);

    return Future.wait(
      items.map((item) async {
        try {
          final progress = await fetchTrainingProgress(
            discipline: discipline,
            subcategory: item.name,
          );
          return _SubjectCardData(
            item: item,
            status: _statusFromProgress(progress),
          );
        } catch (_) {
          return _SubjectCardData(
            item: item,
            status: const _SubjectCardStatus.available(),
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = subjectsAreaTitle(widget.area);

    return FutureBuilder<List<_SubjectCardData>>(
      future: _subcategoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _LoadingState(
            surfaceContainer: widget.surfaceContainer,
            onSurfaceMuted: widget.onSurfaceMuted,
            primary: widget.primary,
          );
        }

        if (snapshot.hasError) {
          return _ErrorState(
            message: 'Não foi possível carregar as disciplinas.',
            onSurfaceMuted: widget.onSurfaceMuted,
          );
        }

        final items = snapshot.data ?? [];
        final totalQuestionsInArea = items.fold<int>(
          0,
          (sum, item) => sum + item.item.total,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
          children: [
            SubjectsHeroCard(
              surfaceContainer: widget.surfaceContainer,
              surfaceContainerHigh: widget.surfaceContainerHigh,
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
            const SizedBox(height: 20),
            SubjectCategoryHeader(
              title: title,
              subtitle: '${items.length} Matérias Disponíveis',
              onSurface: widget.onSurface,
              onSurfaceMuted: widget.onSurfaceMuted,
              primary: widget.primary,
            ),
            const SizedBox(height: 14),
            if (items.isEmpty)
              _EmptyState(onSurfaceMuted: widget.onSurfaceMuted)
            else
              for (final subcategory in items) ...[
                SubjectCard(
                  title: subcategory.item.name,
                  description: _descriptionFor(subcategory.item.name),
                  footerText: '${subcategory.item.total} questões',
                  icon: _iconFor(subcategory.item.name),
                  statusLabel: subcategory.status.label,
                  statusColor: subcategory.status.foregroundColor,
                  statusBackgroundColor: subcategory.status.backgroundColor,
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrainingDetailScreen(
                          title: subcategory.item.name,
                          discipline: title,
                          area: widget.area,
                          description: 'Subcategoria de $title',
                          badgeLabel: 'Subcategoria',
                          badgeColor: widget.primary,
                          countLabel:
                              '${subcategory.item.total} questões disponíveis',
                          areaTotalQuestions: totalQuestionsInArea,
                          surfaceContainerHigh: widget.surfaceContainerHigh,
                          onSurface: widget.onSurface,
                          onSurfaceMuted: widget.onSurfaceMuted,
                          primary: widget.primary,
                        ),
                      ),
                    );
                    _refreshSubjectCards();
                  },
                  surfaceContainer: widget.surfaceContainer,
                  surfaceContainerHigh: widget.surfaceContainerHigh,
                  onSurface: widget.onSurface,
                  onSurfaceMuted: widget.onSurfaceMuted,
                  primary: widget.primary,
                ),
                const SizedBox(height: 12),
              ],
          ],
        );
      },
    );
  }
}

class _SubjectCardData {
  const _SubjectCardData({
    required this.item,
    required this.status,
  });

  final SubcategoryItem item;
  final _SubjectCardStatus status;
}

class _SubjectCardStatus {
  const _SubjectCardStatus({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  const _SubjectCardStatus.completed()
    : label = 'Concluída',
      foregroundColor = const Color(0xFF31C48D),
      backgroundColor = const Color(0x1431C48D);

  const _SubjectCardStatus.inProgress()
    : label = 'Em andamento',
      foregroundColor = const Color(0xFFF5B942),
      backgroundColor = const Color(0x14F5B942);

  const _SubjectCardStatus.available()
    : label = 'Disponível',
      foregroundColor = const Color(0xFF8FA7FF),
      backgroundColor = const Color(0x148FA7FF);

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({
    required this.surfaceContainer,
    required this.onSurfaceMuted,
    required this.primary,
  });

  final Color surfaceContainer;
  final Color onSurfaceMuted;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: surfaceContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Carregando disciplinas...',
              style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onSurfaceMuted});

  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        'Nenhuma disciplina encontrada.',
        style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onSurfaceMuted});

  final String message;
  final Color onSurfaceMuted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.inter(color: onSurfaceMuted, fontSize: 12.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}

_SubjectCardStatus _statusFromProgress(TrainingProgressData progress) {
  if (progress.hasCompletedSession) {
    return const _SubjectCardStatus.completed();
  }
  if (progress.answeredQuestions > 0) {
    return const _SubjectCardStatus.inProgress();
  }
  return const _SubjectCardStatus.available();
}

IconData _iconFor(String discipline) {
  final text = discipline.toLowerCase();
  if (text.contains('matem')) return Icons.calculate_rounded;
  if (text.contains('fisic')) return Icons.science_rounded;
  if (text.contains('quim')) return Icons.biotech_rounded;
  if (text.contains('biolog')) return Icons.bubble_chart_rounded;
  if (text.contains('hist')) return Icons.public_rounded;
  if (text.contains('geo')) return Icons.map_rounded;
  if (text.contains('filos')) return Icons.psychology_rounded;
  if (text.contains('socio')) return Icons.groups_rounded;
  if (text.contains('port')) return Icons.menu_book_rounded;
  if (text.contains('liter')) return Icons.book_rounded;
  if (text.contains('ingl')) return Icons.language_rounded;
  if (text.contains('arte')) return Icons.palette_rounded;
  return Icons.auto_awesome_rounded;
}

String _descriptionFor(String discipline) {
  return 'Conteúdo disponível para treino e revisão.';
}
