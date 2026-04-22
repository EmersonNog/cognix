import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/writing/writing_api.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/cognix_theme_colors.dart';
import '../../../widgets/cognix/cognix_messages.dart';
import '../models/writing_route_args.dart';

part 'editor_checklist.dart';
part 'editor_helpers.dart';
part 'editor_inputs.dart';
part 'editor_theme.dart';

class WritingEditorScreen extends StatefulWidget {
  const WritingEditorScreen({super.key, required this.args});

  final WritingEditorArgs args;

  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  final _writingService = const WritingService();
  bool _isAnalyzing = false;
  late final TextEditingController _thesisController;
  late final TextEditingController _repertoireController;
  late final TextEditingController _argumentOneController;
  late final TextEditingController _argumentTwoController;
  late final TextEditingController _interventionController;
  late final TextEditingController _finalTextController;

  @override
  void initState() {
    super.initState();
    final draft = widget.args.initialDraft;
    _thesisController = TextEditingController(text: draft?.thesis ?? '');
    _repertoireController = TextEditingController(
      text: draft?.repertoire ?? '',
    );
    _argumentOneController = TextEditingController(
      text: draft?.argumentOne ?? '',
    );
    _argumentTwoController = TextEditingController(
      text: draft?.argumentTwo ?? '',
    );
    _interventionController = TextEditingController(
      text: draft?.intervention ?? '',
    );
    _finalTextController = TextEditingController(text: draft?.finalText ?? '');
  }

  @override
  void dispose() {
    _thesisController.dispose();
    _repertoireController.dispose();
    _argumentOneController.dispose();
    _argumentTwoController.dispose();
    _interventionController.dispose();
    _finalTextController.dispose();
    super.dispose();
  }

  WritingDraft _buildDraft() {
    return WritingDraft(
      theme: widget.args.theme,
      thesis: _thesisController.text,
      repertoire: _repertoireController.text,
      argumentOne: _argumentOneController.text,
      argumentTwo: _argumentTwoController.text,
      intervention: _interventionController.text,
      finalText: _finalTextController.text,
      submissionId: widget.args.initialDraft?.submissionId,
    );
  }

  bool _hasMeaningfulChanges(WritingDraft draft) {
    final initialDraft = widget.args.initialDraft;
    if (initialDraft == null) {
      return true;
    }

    return _normalizeDraftField(draft.thesis) !=
            _normalizeDraftField(initialDraft.thesis) ||
        _normalizeDraftField(draft.repertoire) !=
            _normalizeDraftField(initialDraft.repertoire) ||
        _normalizeDraftField(draft.argumentOne) !=
            _normalizeDraftField(initialDraft.argumentOne) ||
        _normalizeDraftField(draft.argumentTwo) !=
            _normalizeDraftField(initialDraft.argumentTwo) ||
        _normalizeDraftField(draft.intervention) !=
            _normalizeDraftField(initialDraft.intervention) ||
        _normalizeDraftField(draft.finalText) !=
            _normalizeDraftField(initialDraft.finalText);
  }

  String _normalizeDraftField(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\r\n?'), '\n')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n');
  }

  String _formatMissingSectionsMessage(List<String> sections) {
    if (sections.isEmpty) {
      return '';
    }
    if (sections.length == 1) {
      return sections.first;
    }

    final allButLast = sections.take(sections.length - 1).join(', ');
    return '$allButLast e ${sections.last}';
  }

  Future<void> _analyzeDraft() async {
    final draft = _buildDraft();
    final missingRequiredSections = _writingService.missingRequiredSections(
      draft,
    );
    if (missingRequiredSections.isNotEmpty) {
      showCognixMessage(
        context,
        'Preencha ${_formatMissingSectionsMessage(missingRequiredSections)} antes de pedir a análise.',
        type: CognixMessageType.error,
      );
      return;
    }
    if (draft.finalText.trim().length < 80) {
      showCognixMessage(
        context,
        'Escreva um texto maior antes de gerar o diagnóstico.',
        type: CognixMessageType.error,
      );
      return;
    }
    if (!_hasMeaningfulChanges(draft)) {
      showCognixMessage(
        context,
        'Faça alguma alteração no texto antes de gerar uma nova análise.',
        type: CognixMessageType.error,
      );
      return;
    }

    setState(() => _isAnalyzing = true);
    try {
      final feedback = await analyzeWritingDraft(draft);
      final analyzedDraft = draft.copyWith(submissionId: feedback.submissionId);
      if (!mounted) return;
      Navigator.of(context).pushNamed(
        'writing-result',
        arguments: WritingResultArgs(draft: analyzedDraft, feedback: feedback),
      );
    } catch (error) {
      if (!mounted) return;
      showCognixMessage(
        context,
        error.toString().replaceFirst('Exception: ', ''),
        type: CognixMessageType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _composeDraftText() {
    final finalText = _writingService.composeFinalText(_buildDraft());

    setState(() {
      _finalTextController.value = TextEditingValue(
        text: finalText,
        selection: TextSelection.collapsed(offset: finalText.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final draft = _buildDraft();
    final checklist = _writingService.buildChecklist(draft);
    final completedCount = checklist.where((item) => item.completed).length;
    final missingRequiredSections = _writingService.missingRequiredSections(
      draft,
    );
    final hasRequiredSections = missingRequiredSections.isEmpty;
    final hasMeaningfulChanges = _hasMeaningfulChanges(draft);
    final canAnalyze = hasRequiredSections && hasMeaningfulChanges;
    final hasInitialDraft = widget.args.initialDraft != null;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Treino de redação',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          _ThemeHero(theme: widget.args.theme),
          const SizedBox(height: 16),
          _QuickOverview(
            wordCount: draft.wordCount,
            paragraphCount: draft.paragraphCount,
            completedCount: completedCount,
            totalChecklist: checklist.length,
          ),
          const SizedBox(height: 18),
          const _SectionHeader(
            eyebrow: 'Roteiro',
            title: 'Estrutura guiada',
            subtitle: 'Monte as ideias principais antes de fechar o texto.',
          ),
          const SizedBox(height: 12),
          _GuideCard(
            child: Column(
              children: [
                _WritingInput(
                  icon: Icons.track_changes_rounded,
                  label: 'Tese',
                  hint: 'Qual é a posição central do seu texto?',
                  controller: _thesisController,
                  minLines: 2,
                  onChanged: (_) => setState(() {}),
                ),
                _WritingInput(
                  icon: Icons.menu_book_rounded,
                  label: 'Repertório',
                  hint: 'Lei, dado, autor, obra ou acontecimento.',
                  controller: _repertoireController,
                  minLines: 2,
                  onChanged: (_) => setState(() {}),
                ),
                _WritingInput(
                  icon: Icons.looks_one_rounded,
                  label: 'Argumento 1',
                  hint: 'Desenvolva o primeiro ponto com clareza.',
                  controller: _argumentOneController,
                  minLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
                _WritingInput(
                  icon: Icons.looks_two_rounded,
                  label: 'Argumento 2',
                  hint: 'Apresente um segundo ponto complementar.',
                  controller: _argumentTwoController,
                  minLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
                _WritingInput(
                  icon: Icons.campaign_rounded,
                  label: 'Proposta de intervenção',
                  hint: 'Agente, ação, meio, finalidade e detalhamento.',
                  controller: _interventionController,
                  minLines: 3,
                  onChanged: (_) => setState(() {}),
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ComposeButton(onTap: _composeDraftText),
          const SizedBox(height: 20),
          const _SectionHeader(
            eyebrow: 'Redação',
            title: 'Texto final',
            subtitle: 'Revise e ajuste o texto completo antes da análise.',
          ),
          const SizedBox(height: 12),
          _GuideCard(
            child: _WritingInput(
              icon: Icons.edit_note_rounded,
              label: 'Redação completa',
              hint: 'Escreva ou cole a redação final aqui.',
              controller: _finalTextController,
              minLines: 12,
              onChanged: (_) => setState(() {}),
              isLast: true,
            ),
          ),
          const SizedBox(height: 12),
          _ChecklistCard(items: checklist),
          const SizedBox(height: 20),
          _PrimaryActionButton(
            label: _isAnalyzing ? 'Analisando com IA...' : 'Analisar redação',
            icon: Icons.auto_awesome_rounded,
            isLoading: _isAnalyzing,
            isEnabled: canAnalyze,
            onTap: _analyzeDraft,
          ),
          if (!hasRequiredSections) ...[
            const SizedBox(height: 10),
            Text(
              'Preencha ${_formatMissingSectionsMessage(missingRequiredSections)} para liberar a análise.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: colors.onSurfaceMuted,
                fontSize: 12.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else if (hasInitialDraft && !hasMeaningfulChanges) ...[
            const SizedBox(height: 10),
            Text(
              'Altere o texto antes de pedir uma nova análise de IA.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: colors.onSurfaceMuted,
                fontSize: 12.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
