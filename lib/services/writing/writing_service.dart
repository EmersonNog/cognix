import 'models.dart';

class WritingService {
  const WritingService();

  List<String> missingRequiredSections(WritingDraft draft) {
    return [
      if (draft.thesis.trim().isEmpty) 'Tese',
      if (draft.repertoire.trim().isEmpty) 'Repertório',
      if (draft.argumentOne.trim().isEmpty) 'Argumento 1',
      if (draft.argumentTwo.trim().isEmpty) 'Argumento 2',
      if (draft.intervention.trim().isEmpty) 'Proposta de intervenção',
    ];
  }

  String composeFinalText(WritingDraft draft) {
    final thesis = _cleanParagraph(draft.thesis);
    final repertoire = _cleanParagraph(draft.repertoire);
    final argumentOne = _cleanParagraph(draft.argumentOne);
    final argumentTwo = _cleanParagraph(draft.argumentTwo);
    final intervention = _cleanParagraph(draft.intervention);

    return [
      thesis,
      repertoire,
      argumentOne,
      argumentTwo,
      intervention,
    ].where((item) => item.isNotEmpty).join('\n\n');
  }

  List<WritingChecklistItem> buildChecklist(WritingDraft draft) {
    final normalizedText = _normalize(draft.finalText);
    final intervention = _normalize(draft.intervention);

    return [
      WritingChecklistItem(
        label: 'Tese clara',
        completed: draft.thesis.trim().length >= 28,
        helper: 'Apresente uma posição objetiva sobre o problema.',
      ),
      WritingChecklistItem(
        label: 'Repertório sociocultural',
        completed: draft.repertoire.trim().length >= 36,
        helper: 'Use autor, lei, dado, obra ou acontecimento relevante.',
      ),
      WritingChecklistItem(
        label: 'Dois argumentos',
        completed:
            draft.argumentOne.trim().length >= 32 &&
            draft.argumentTwo.trim().length >= 32,
        helper: 'Desenvolva duas causas ou consequências diferentes.',
      ),
      WritingChecklistItem(
        label: 'Proposta completa',
        completed:
            _hasAny(intervention, ['governo', 'estado', 'ministério']) &&
            _hasAny(intervention, ['campanha', 'programa', 'política']) &&
            _hasAny(intervention, ['por meio', 'através', 'mediante']) &&
            _hasAny(intervention, ['para', 'a fim de']),
        helper: 'Inclua agente, ação, meio, finalidade e detalhamento.',
      ),
      WritingChecklistItem(
        label: 'Texto em formato dissertativo',
        completed:
            draft.wordCount >= 180 &&
            draft.paragraphCount >= 4 &&
            _hasAny(normalizedText, ['portanto', 'assim', 'dessa forma']),
        helper: 'Organize introdução, desenvolvimento e conclusão.',
      ),
    ];
  }

  bool _hasAny(String value, List<String> terms) {
    return terms.any(value.contains);
  }

  String _normalize(String value) {
    return value.toLowerCase().trim();
  }

  String _cleanParagraph(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
