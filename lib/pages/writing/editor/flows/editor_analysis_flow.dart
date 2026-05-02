part of '../writing_editor_screen.dart';

extension _WritingEditorAnalysisFlow on _WritingEditorScreenState {
  Future<void> _analyzeDraft() async {
    final draft = _buildDraft();
    final missingRequiredSections = _isImageScanMode
        ? const <String>[]
        : _writingService.missingRequiredSections(draft);
    if (!_isImageScanMode && missingRequiredSections.isNotEmpty) {
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
        _isImageScanMode
            ? 'Escaneie a redação e revise a transcrição antes de gerar o diagnóstico.'
            : 'Escreva um texto maior antes de gerar o diagnóstico.',
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

    _setAnalyzing(true);
    try {
      final feedback = await _runWithAiLoading(
        title: 'Analisando sua redação',
        subtitle: 'A IA está avaliando tema, estrutura e competências.',
        steps: _analysisLoadingSteps,
        action: () => analyzeWritingDraft(draft),
      );
      final analyzedDraft = draft.copyWith(submissionId: feedback.submissionId);
      if (!mounted) return;
      Navigator.of(context).pushNamed(
        'writing-result',
        arguments: WritingResultArgs(
          draft: analyzedDraft,
          feedback: feedback,
          editorMode: widget.args.mode,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showCognixMessage(
        context,
        error.toString().replaceFirst('Exception: ', ''),
        type: CognixMessageType.error,
      );
    } finally {
      _setAnalyzing(false);
    }
  }
}
