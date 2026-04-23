import 'package:flutter_test/flutter_test.dart';
import 'package:cognix/services/writing/writing_api.dart';

void main() {
  group('WritingService', () {
    const theme = WritingTheme(
      id: 'theme-1',
      title: 'Tema',
      category: 'Sociedade',
      description: 'Descrição',
      keywords: [],
    );

    test('composeFinalText keeps repertoire as its own paragraph', () {
      const service = WritingService();
      const draft = WritingDraft(
        theme: theme,
        thesis: 'A tese central precisa ser defendida com clareza.',
        repertoire:
            'Segundo a Constituição Federal, a educação e direito social.',
        argumentOne:
            'O primeiro argumento mostra a ausência de politicas públicas.',
        argumentTwo:
            'O segundo argumento evidencia desigualdades históricas persistentes.',
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
        'Repertório',
        'Argumento 2',
        'Proposta de intervenção',
      ]);
    });
  });
}
