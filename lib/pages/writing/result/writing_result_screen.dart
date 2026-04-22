import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/writing/writing_api.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../models/writing_route_args.dart';

part 'checklist_summary.dart';
part 'feedback_cards.dart';
part 'score_card.dart';
part 'section_title.dart';

class WritingResultScreen extends StatelessWidget {
  const WritingResultScreen({super.key, required this.args});

  final WritingResultArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final colorScheme = Theme.of(context).colorScheme;
    final feedback = args.feedback;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
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
          const _SectionTitle(
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
          const _SectionTitle(
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
                backgroundColor: colors.primary,
                foregroundColor: colorScheme.onPrimary,
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
