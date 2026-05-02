part of '../writing_editor_screen.dart';

extension _WritingEditorStateFlow on _WritingEditorScreenState {
  bool get _isImageScanMode => widget.args.mode.usesImageScan;

  void _initializeControllers() {
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

  void _disposeControllers() {
    _thesisController.dispose();
    _repertoireController.dispose();
    _argumentOneController.dispose();
    _argumentTwoController.dispose();
    _interventionController.dispose();
    _finalTextController.dispose();
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

  void _composeDraftText() {
    final finalText = _writingService.composeFinalText(_buildDraft());
    _setFinalText(finalText);
  }
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
