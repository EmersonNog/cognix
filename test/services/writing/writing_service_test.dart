import 'package:flutter_test/flutter_test.dart';
import 'package:cognix/services/writing/writing_api.dart';

void main() {
  group('WritingService', () {
    const theme = WritingTheme(
      id: 'theme-1',
      title: 'Tema',
      category: 'Sociedade',
      description: 'Descricao',
      keywords: [],
    );

    test('composeFinalText keeps repertoire as its own paragraph', () {
      const service = WritingService();
      const draft = WritingDraft(
        theme: theme,
        thesis: 'A tese central precisa ser defendida com clareza.',
        repertoire:
            'Segundo a Constituicao Federal, a educacao e direito social.',
        argumentOne:
            'O primeiro argumento mostra a ausencia de politicas publicas.',
        argumentTwo:
            'O segundo argumento evidencia desigualdades historicas persistentes.',
        intervention:
            'Portanto, o Estado deve criar campanhas por meio das escolas.',
        finalText: '',
      );

      final finalText = service.composeFinalText(draft);

      expect(finalText, contains(draft.thesis));
      expect(finalText, contains(draft.repertoire));
      expect(finalText.split('\n\n'), [
        draft.thesis,
        draft.repertoire,
        draft.argumentOne,
        draft.argumentTwo,
        draft.intervention,
      ]);
    });

    test('missingRequiredSections requires all guided structure fields', () {
      const service = WritingService();
      const draft = WritingDraft(
        theme: theme,
        thesis: 'Tese preenchida.',
        repertoire: '',
        argumentOne: 'Argumento 1 preenchido.',
        argumentTwo: '',
        intervention: '',
        finalText: 'Texto final preenchido manualmente.',
      );

      expect(service.missingRequiredSections(draft), [
        'Repertorio',
        'Argumento 2',
        'Proposta de intervencao',
      ]);
    });
  });
}
