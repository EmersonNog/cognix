import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/writing/writing_api.dart';
import 'writing_route_args.dart';

class WritingEditorScreen extends StatefulWidget {
  const WritingEditorScreen({super.key, required this.args});

  final WritingEditorArgs args;

  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  static const _surface = Color(0xFF060E20);
  static const _surfaceContainer = Color(0xFF0F1930);
  static const _surfaceContainerHigh = Color(0xFF141F38);
  static const _surfaceContainerLow = Color(0xFF101B32);
  static const _onSurface = Color(0xFFDEE5FF);
  static const _onSurfaceMuted = Color(0xFF9AA6C5);
  static const _primary = Color(0xFFA3A6FF);
  static const _accent = Color(0xFFFFC56E);
  static const _success = Color(0xFF7ED6C5);

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
    _repertoireController = TextEditingController(text: draft?.repertoire ?? '');
    _argumentOneController = TextEditingController(text: draft?.argumentOne ?? '');
    _argumentTwoController = TextEditingController(text: draft?.argumentTwo ?? '');
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
    );
  }

  Future<void> _analyzeDraft() async {
    final draft = _buildDraft();
    if (draft.finalText.trim().length < 80) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escreva um texto maior antes de gerar o diagnóstico.'),
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);
    try {
      final feedback = await analyzeWritingDraft(draft);
      if (!mounted) return;
      Navigator.of(context).pushNamed(
        'writing-result',
        arguments: WritingResultArgs(draft: draft, feedback: feedback),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _composeDraftText() {
    final paragraphs = [
      _thesisController.text.trim(),
      _argumentOneController.text.trim(),
      _argumentTwoController.text.trim(),
      _interventionController.text.trim(),
    ].where((item) => item.isNotEmpty).join('\n\n');

    setState(() {
      _finalTextController.text = paragraphs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = _buildDraft();
    final checklist = _writingService.buildChecklist(draft);
    final completedCount = checklist.where((item) => item.completed).length;

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: _surface,
        foregroundColor: _onSurface,
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
            onTap: _analyzeDraft,
          ),
        ],
      ),
    );
  }
}

class _ThemeHero extends StatelessWidget {
  const _ThemeHero({required this.theme});

  final WritingTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2341), Color(0xFF101B32)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _WritingEditorScreenState._accent.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeroPill(
                icon: Icons.label_rounded,
                label: theme.category.toUpperCase(),
                accent: _WritingEditorScreenState._accent,
              ),
              const SizedBox(width: 8),
              _HeroPill(
                icon: Icons.bar_chart_rounded,
                label: theme.difficulty,
                accent: _difficultyAccent(theme.difficulty),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            theme.title,
            style: GoogleFonts.manrope(
              color: _WritingEditorScreenState._onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            theme.description,
            style: GoogleFonts.inter(
              color: _WritingEditorScreenState._onSurfaceMuted,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: accent,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickOverview extends StatelessWidget {
  const _QuickOverview({
    required this.wordCount,
    required this.paragraphCount,
    required this.completedCount,
    required this.totalChecklist,
  });

  final int wordCount;
  final int paragraphCount;
  final int completedCount;
  final int totalChecklist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OverviewCard(
            icon: Icons.notes_rounded,
            label: 'Palavras',
            value: '$wordCount',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _OverviewCard(
            icon: Icons.view_agenda_rounded,
            label: 'Parágrafos',
            value: '$paragraphCount',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _OverviewCard(
            icon: Icons.task_alt_rounded,
            label: 'Checklist',
            value: '$completedCount/$totalChecklist',
            accent: _WritingEditorScreenState._success,
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = _WritingEditorScreenState._primary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _WritingEditorScreenState._surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: _WritingEditorScreenState._onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              color: _WritingEditorScreenState._onSurfaceMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: _WritingEditorScreenState._accent,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.manrope(
            color: _WritingEditorScreenState._onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: _WritingEditorScreenState._onSurfaceMuted,
            fontSize: 12.8,
            height: 1.38,
          ),
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _WritingEditorScreenState._surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _WritingEditorScreenState._primary.withValues(alpha: 0.1),
        ),
      ),
      child: child,
    );
  }
}

class _WritingInput extends StatelessWidget {
  const _WritingInput({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    required this.minLines,
    required this.onChanged,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final int minLines;
  final ValueChanged<String> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _WritingEditorScreenState._surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _WritingEditorScreenState._primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: _WritingEditorScreenState._primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.manrope(
                    color: _WritingEditorScreenState._onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            style: GoogleFonts.inter(
              color: _WritingEditorScreenState._onSurfaceMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            minLines: minLines,
            maxLines: null,
            onChanged: onChanged,
            style: GoogleFonts.inter(
              color: _WritingEditorScreenState._onSurface,
              fontSize: 13.6,
              height: 1.45,
            ),
            cursorColor: _WritingEditorScreenState._primary,
            decoration: InputDecoration(
              filled: true,
              fillColor: _WritingEditorScreenState._surface,
              hintText: 'Escreva aqui',
              hintStyle: GoogleFonts.inter(
                color: _WritingEditorScreenState._onSurfaceMuted.withValues(
                  alpha: 0.65,
                ),
                fontSize: 13,
              ),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _WritingEditorScreenState._primary.withValues(alpha: 0.08),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: _WritingEditorScreenState._primary.withValues(alpha: 0.08),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: _WritingEditorScreenState._primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposeButton extends StatelessWidget {
  const _ComposeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _WritingEditorScreenState._accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.post_add_rounded,
                size: 18,
                color: _WritingEditorScreenState._accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Montar texto com a estrutura',
                style: GoogleFonts.plusJakartaSans(
                  color: _WritingEditorScreenState._accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.items});

  final List<WritingChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _WritingEditorScreenState._surfaceContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _WritingEditorScreenState._success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: _WritingEditorScreenState._success,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Checklist de revisão',
                  style: GoogleFonts.manrope(
                    color: _WritingEditorScreenState._onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final item in items) _ChecklistTile(item: item),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({required this.item});

  final WritingChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.completed
        ? _WritingEditorScreenState._success
        : _WritingEditorScreenState._onSurfaceMuted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: color,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    color: _WritingEditorScreenState._onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.helper,
                  style: GoogleFonts.inter(
                    color: _WritingEditorScreenState._onSurfaceMuted,
                    fontSize: 11.8,
                    height: 1.3,
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

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _WritingEditorScreenState._primary,
          foregroundColor: const Color(0xFF060E20),
          disabledBackgroundColor: _WritingEditorScreenState._primary.withValues(
            alpha: 0.82,
          ),
          disabledForegroundColor: const Color(0xFF060E20),
          elevation: isLoading ? 0 : 2,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF060E20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(label),
                  ],
                )
              : Row(
                  key: const ValueKey('idle'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
        ),
      ),
    );
  }
}

Color _difficultyAccent(String value) {
  switch (value.trim().toLowerCase()) {
    case 'facil':
    case 'fácil':
      return const Color(0xFF65E6A5);
    case 'dificil':
    case 'difícil':
      return const Color(0xFFFF8E9D);
    default:
      return _WritingEditorScreenState._accent;
  }
}
