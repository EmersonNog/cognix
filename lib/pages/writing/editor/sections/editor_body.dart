part of '../writing_editor_screen.dart';

extension _WritingEditorBody on _WritingEditorScreenState {
  Widget _buildEditorScaffold() {
    final colors = context.cognixColors;
    final draft = _buildDraft();
    final isImageScanMode = _isImageScanMode;
    final checklist = isImageScanMode
        ? const <WritingChecklistItem>[]
        : _writingService.buildChecklist(draft);
    final completedCount = checklist.where((item) => item.completed).length;
    final missingRequiredSections = isImageScanMode
        ? const <String>[]
        : _writingService.missingRequiredSections(draft);
    final hasRequiredSections = missingRequiredSections.isEmpty;
    final hasEnoughText = draft.finalText.trim().length >= 80;
    final hasMeaningfulChanges = _hasMeaningfulChanges(draft);
    final canAnalyze =
        hasRequiredSections && hasMeaningfulChanges && hasEnoughText;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          isImageScanMode ? 'Redação por foto' : 'Treino de redação',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w900),
        ),
        actions: [
          if (isImageScanMode)
            IconButton(
              tooltip: 'Aviso de privacidade',
              onPressed: () => _showImageScanPrivacyInfo(context),
              icon: const Icon(Icons.info_outline_rounded),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          WritingThemeHero(theme: widget.args.theme),
          const SizedBox(height: 16),
          _QuickOverview(
            wordCount: draft.wordCount,
            paragraphCount: draft.paragraphCount,
            statusIcon: isImageScanMode
                ? Icons.document_scanner_rounded
                : Icons.task_alt_rounded,
            statusLabel: isImageScanMode ? 'Entrada' : 'Checklist',
            statusValue: isImageScanMode
                ? (draft.finalText.trim().isEmpty ? 'Foto IA' : 'Revisão')
                : '$completedCount/${checklist.length}',
            statusAccent: isImageScanMode ? colors.accent : colors.success,
          ),
          if (isImageScanMode)
            ..._buildImageScanEditorContent(draft)
          else
            ..._buildManualEditorContent(),
          if (!isImageScanMode) ...[
            const SizedBox(height: 12),
            _ChecklistCard(items: checklist),
          ],
          const SizedBox(height: 20),
          _PrimaryActionButton(
            label: _isAnalyzing ? 'Analisando com IA...' : 'Analisar redação',
            icon: Icons.auto_awesome_rounded,
            isLoading: _isAnalyzing,
            isEnabled: canAnalyze,
            onTap: _analyzeDraft,
          ),
          _EditorActionHint(
            hasEnoughText: hasEnoughText,
            hasRequiredSections: hasRequiredSections,
            hasMeaningfulChanges: hasMeaningfulChanges,
            hasInitialDraft: widget.args.initialDraft != null,
            isImageScanMode: isImageScanMode,
            missingRequiredSections: missingRequiredSections,
          ),
        ],
      ),
    );
  }
}

class _EditorActionHint extends StatelessWidget {
  const _EditorActionHint({
    required this.hasEnoughText,
    required this.hasRequiredSections,
    required this.hasMeaningfulChanges,
    required this.hasInitialDraft,
    required this.isImageScanMode,
    required this.missingRequiredSections,
  });

  final bool hasEnoughText;
  final bool hasRequiredSections;
  final bool hasMeaningfulChanges;
  final bool hasInitialDraft;
  final bool isImageScanMode;
  final List<String> missingRequiredSections;

  @override
  Widget build(BuildContext context) {
    final colors = context.cognixColors;
    final message = _message;
    if (message == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: colors.onSurfaceMuted,
          fontSize: 12.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String? get _message {
    if (!hasEnoughText) {
      return isImageScanMode
          ? 'Escaneie a redação e revise a transcrição para liberar a análise.'
          : 'Escreva um texto maior antes de gerar o diagnóstico.';
    }
    if (!hasRequiredSections) {
      return 'Preencha ${_formatMissingSectionsMessage(missingRequiredSections)} para liberar a análise.';
    }
    if (hasInitialDraft && !hasMeaningfulChanges) {
      return 'Altere o texto antes de pedir uma nova análise de IA.';
    }
    return null;
  }
}
