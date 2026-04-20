import '../core/api_client.dart' show apiBaseUrl, getJson, postJson;
import 'models.dart';
import 'parsers.dart';

Future<WritingThemesData> fetchWritingThemes({
  String? category,
  String? search,
  int limit = 10,
  int offset = 0,
}) async {
  final queryParameters = <String, String>{
    'limit': '$limit',
    'offset': '$offset',
  };
  if (category != null && category.trim().isNotEmpty) {
    queryParameters['category'] = category.trim();
  }
  if (search != null && search.trim().isNotEmpty) {
    queryParameters['search'] = search.trim();
  }

  final payload = await getJson(
    Uri.parse(
      '${apiBaseUrl()}/writing/themes',
    ).replace(queryParameters: queryParameters),
    errorMessage: 'Não consegui carregar os temas de redação',
  );
  return parseWritingThemesData(payload);
}

Future<WritingFeedback> analyzeWritingDraft(WritingDraft draft) async {
  final payload = await postJson(
    Uri.parse('${apiBaseUrl()}/writing/analyze'),
    body: {
      'theme': {
        'id': draft.theme.id,
        'title': draft.theme.title,
        'category': draft.theme.category,
        'description': draft.theme.description,
        'keywords': draft.theme.keywords,
      },
      'thesis': draft.thesis,
      'repertoire': draft.repertoire,
      'argument_one': draft.argumentOne,
      'argument_two': draft.argumentTwo,
      'intervention': draft.intervention,
      'final_text': draft.finalText,
    },
    errorMessage: 'Não consegui analisar sua redação agora',
    timeout: const Duration(seconds: 45),
  );
  return parseWritingFeedback(payload);
}
