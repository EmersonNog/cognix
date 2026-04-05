import '../core/api_client.dart' show apiBaseUrl, getJson;
import 'models.dart';
import 'parsers.dart';

Future<HomeRecommendationsData> fetchHomeRecommendations() async {
  final payload = await getJson(
    Uri.parse('${apiBaseUrl()}/users/recommendations'),
    errorMessage: 'Erro ao carregar recomendacoes',
  );
  return parseHomeRecommendationsData(payload);
}
