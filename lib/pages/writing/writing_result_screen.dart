import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/writing/writing_api.dart';
import 'writing_route_args.dart';

part 'writing_result_screen/checklist_summary.dart';
part 'writing_result_screen/feedback_cards.dart';
part 'writing_result_screen/score_card.dart';
part 'writing_result_screen/section_title.dart';

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
