import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/writing/writing_api.dart';
import 'writing_route_args.dart';

class WritingResultScreen extends StatelessWidget {
  const WritingResultScreen({super.key, required this.args});

  final WritingResultArgs args;

  static const _surface = Color(0xFF060E20);
  static const _surfaceContainer = Color(0xFF0F1930);
  static const _surfaceContainerHigh = Color(0xFF141F38);
  static const _onSurface = Color(0xFFDEE5FF);
  static const _onSurfaceMuted = Color(0xFF9AA6C5);
  static const _primary = Color(0xFFA3A6FF);
  static const _accent = Color(0xFFFFC56E);

  @override
  Widget build(BuildContext context) {
    final feedback = args.feedback;

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _onSurface,
        elevation: 0,
        title: Text(
          'Diagnóstico',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          _ScoreCard(feedback: feedback),
          const SizedBox(height: 16),
          _ChecklistSummary(items: feedback.checklist),
          const SizedBox(height: 16),
          _SectionTitle(
            title: 'Competências ENEM',
            subtitle:
                'Estimativa pedagógica para orientar sua próxima reescrita.',
          ),
          const SizedBox(height: 12),
          for (final competency in feedback.competencies) ...[
            _CompetencyCard(competency: competency),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          _SectionTitle(
            title: 'Reescrita guiada',
            subtitle:
                'Use essas sugestões para melhorar trechos específicos do texto.',
          ),
          const SizedBox(height: 12),
          for (final suggestion in feedback.rewriteSuggestions) ...[
            _RewriteCard(suggestion: suggestion),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                  'writing-editor',
                  arguments: WritingEditorArgs(
                    theme: args.draft.theme,
                    initialDraft: args.draft,
                  ),
                );
              },
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Reescrever agora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: const Color(0xFF060E20),
                textStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.feedback});

  final WritingFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final ratio = feedback.estimatedScore / 1000;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2341), Color(0xFF101B32)],
        ),
        border: Border.all(
          color: WritingResultScreen._accent.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 98,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 62,
                  height: 62,
                  child: CircularProgressIndicator(
                    value: ratio,
                    strokeWidth: 7,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      WritingResultScreen._accent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${feedback.estimatedScore}',
                  style: GoogleFonts.manrope(
                    color: WritingResultScreen._onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PTS',
                  style: GoogleFonts.plusJakartaSans(
                    color: WritingResultScreen._accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnóstico geral',
                  style: GoogleFonts.plusJakartaSans(
                    color: WritingResultScreen._accent,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nota estimada',
                  style: GoogleFonts.manrope(
                    color: WritingResultScreen._onSurface,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feedback.summary,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: WritingResultScreen._onSurfaceMuted,
                    fontSize: 12.9,
                    height: 1.46,
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

class _ChecklistSummary extends StatelessWidget {
  const _ChecklistSummary({required this.items});

  final List<WritingChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    final completed = items.where((item) => item.completed).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WritingResultScreen._surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$completed/${items.length} critérios atendidos',
            style: GoogleFonts.manrope(
              color: WritingResultScreen._onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in items)
                _ChecklistPill(label: item.label, completed: item.completed),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistPill extends StatelessWidget {
  const _ChecklistPill({required this.label, required this.completed});

  final String label;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? const Color(0xFF65E6A5)
        : WritingResultScreen._onSurfaceMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.check_rounded : Icons.close_rounded,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: WritingResultScreen._onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: WritingResultScreen._onSurfaceMuted,
            fontSize: 12.8,
            height: 1.38,
          ),
        ),
      ],
    );
  }
}

class _CompetencyCard extends StatelessWidget {
  const _CompetencyCard({required this.competency});

  final WritingCompetencyFeedback competency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WritingResultScreen._surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: WritingResultScreen._primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${competency.score}',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: WritingResultScreen._primary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competency.title,
                  style: GoogleFonts.inter(
                    color: WritingResultScreen._onSurface,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  competency.comment,
                  style: GoogleFonts.inter(
                    color: WritingResultScreen._onSurfaceMuted,
                    fontSize: 12.3,
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

class _RewriteCard extends StatelessWidget {
  const _RewriteCard({required this.suggestion});

  final WritingRewriteSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: WritingResultScreen._surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WritingResultScreen._accent.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.section.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: WritingResultScreen._accent,
              fontSize: 10,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion.issue,
            style: GoogleFonts.manrope(
              color: WritingResultScreen._onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            suggestion.suggestion,
            style: GoogleFonts.inter(
              color: WritingResultScreen._onSurfaceMuted,
              fontSize: 12.7,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WritingResultScreen._surfaceContainerHigh,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              suggestion.example,
              style: GoogleFonts.inter(
                color: WritingResultScreen._onSurface,
                fontSize: 12.5,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
